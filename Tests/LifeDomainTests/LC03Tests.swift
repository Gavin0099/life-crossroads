import Foundation
import XCTest
@testable import LifeDomain
import LifeData

final class LC03Tests: XCTestCase {
    func state(_ c: ModelCatalog, _ code: String = "JPN", family: Int = 1, age: Int = 39) throws -> LifeState {
        try SimulationEngine.advance(LifeState.born(catalog: c, countryCode: code, householdID: "\(code.lowercased())-\(family)", seed: 0), to: age, catalog: c).0
    }

    func testTaiwanNativeDefinitionsAndLicensesRemainDistinct() throws {
        let c = try StatisticsRepository.bundled()
        let tw = try XCTUnwrap(c.countries.first { $0.code == "TWN" })
        XCTAssertEqual(tw.dataStatus, .limited)
        XCTAssertEqual(tw.indicators.first { $0.indicator == "TWN.INTERNET.12PLUS" }?.value, 87.2)
        XCTAssertEqual(tw.indicators.first { $0.indicator == "TWN.OOP.INCLUDING.REIMBURSEMENT" }?.value, 38.78)
        XCTAssertEqual(tw.indicators.first { $0.indicator == "SH.XPD.CHEX.GD.ZS" }?.value, 7.25)
        XCTAssertFalse(tw.indicators.contains { $0.indicator == "IT.NET.USER.ZS" || $0.indicator == "SH.XPD.OOPC.CH.ZS" })
        XCTAssertTrue(tw.indicators.allSatisfy { $0.usage == "contextOnly" })
        XCTAssertEqual(Set(c.sources.filter { $0.format == "taiwan-row" }.map(\.license)), ["OGDL-Taiwan-1.0"])
        var forged = c
        let index = try XCTUnwrap(forged.countries.firstIndex { $0.code == "TWN" })
        forged.countries[index].indicators[0].unit = "% of population"
        XCTAssertThrowsError(try forged.validate())
        forged = c
        forged.countries[index].indicators[1].comparisonGroup = "sha2011-oop-che-2023"
        XCTAssertThrowsError(try forged.validate())
    }

    func testUnknownCostIsRecordedAndCannotBecomeAComparableZero() throws {
        let c = try StatisticsRepository.bundled(), before = try state(c, "TWN", age: 13)
        let result = try EnvironmentComparisonEngine.preview(state: before, eventID: "teen-project", choiceID: "invest", catalog: c)
        XCTAssertTrue(result.trace.applied, "Unknown national input is not a lack of real access")
        XCTAssertFalse(result.trace.environmentGaps.isEmpty)
        XCTAssertFalse(result.trace.costSteps.contains { $0.ruleID == "context.digital" })
        XCTAssertTrue(result.trace.costSteps.contains { $0.ruleID == "context.digital.unestimated" && $0.inputs.isEmpty && $0.sourceIDs.isEmpty })
        XCTAssertTrue(result.availableAlternatives.contains { $0.id == "offline" && $0.environmentGaps.isEmpty })
        XCTAssertEqual(before.decisions.count, 0)
        var invalid = c
        let i = try XCTUnwrap(invalid.countries.firstIndex { $0.code == "JPN" })
        invalid.countries[i].indicators[0].value = nil
        XCTAssertThrowsError(try invalid.validate())
    }

    func testCareFinancingThresholdsHaveIndependentExpectedBudgetsAndNoEffectsWhenRejected() throws {
        let original = try StatisticsRepository.bundled()
        // Contract in docs/lc03-country-environments.md: <20 =>1, [20,40)=>2, >=40=>3 materials.
        for (value, materials, feasible) in [(19.999, 1, true), (20.0, 2, true), (39.999, 2, true), (40.0, 3, false)] {
            var c = original
            let i = try XCTUnwrap(c.countries.firstIndex { $0.code == "JPN" })
            let j = try XCTUnwrap(c.countries[i].indicators.firstIndex { $0.indicator == "SH.XPD.OOPC.CH.ZS" })
            c.countries[i].indicators[j].value = value
            let before = try state(c)
            let result = try DecisionResolver.resolve(state: before, eventID: "adult-care", choiceID: "invest", catalog: c)
            XCTAssertEqual(result.trace.finalCost.materials, materials)
            XCTAssertEqual(result.trace.applied, feasible)
            XCTAssertEqual(result.trace.costSteps.first { $0.ruleID == "context.care-financing" }?.sourceIDs, ["wdi-oop-2023"])
            if !feasible {
                XCTAssertEqual(result.state, before)
                XCTAssertTrue(result.trace.recordedStoryFacts.isEmpty)
                XCTAssertTrue(result.trace.effectSteps.isEmpty)
            }
        }
    }

    func testSameChoiceHasDifferentCostsSupportAndRealFutureRouteConditions() throws {
        let c = try StatisticsRepository.bundled()
        let jp = try EnvironmentComparisonEngine.preview(state: state(c), eventID: "adult-care", choiceID: "invest", catalog: c)
        let indiaBefore = try state(c, "IND")
        let india = try EnvironmentComparisonEngine.preview(state: indiaBefore, eventID: "adult-care", choiceID: "invest", catalog: c)
        XCTAssertEqual(jp.trace.finalCost.materials, 1)
        XCTAssertEqual(india.trace.finalCost.materials, 3)
        XCTAssertTrue(jp.trace.applied); XCTAssertFalse(india.trace.applied)
        XCTAssertTrue(india.availableAlternatives.contains { $0.id == "ask" && $0.cost.materials == 0 })
        XCTAssertTrue(india.availableAlternatives.contains { $0.id == "rest" && $0.cost == Cost() })
        let organized = try DecisionResolver.resolve(state: state(c), eventID: "adult-care", choiceID: "invest", catalog: c).state
        let seeking = try DecisionResolver.resolve(state: indiaBefore, eventID: "adult-care", choiceID: "ask", catalog: c).state
        let future = try XCTUnwrap(c.decisions.first { $0.id == "middle-support" })
        let continued = try StoryBranchEngine.project(event: future, state: try SimulationEngine.advance(organized, to: 52, catalog: c).0, catalog: c)
        let recovery = try StoryBranchEngine.project(event: future, state: try SimulationEngine.advance(seeking, to: 52, catalog: c).0, catalog: c)
        XCTAssertEqual(continued.event.storyVariantID, "middle-support-reciprocal")
        XCTAssertEqual(recovery.event.storyVariantID, "middle-support-first-request")
        XCTAssertTrue(continued.event.choices.contains { $0.id == "shareShift" })
        XCTAssertFalse(recovery.event.choices.contains { $0.id == "shareShift" })
        XCTAssertEqual(continued.evaluation?.sourceEventID, "adult-care")
        // This checks the conditional route projection, not a guarantee of drawing the future event.
    }

    func testHouseholdSnapshotComparisonKeepsPastAndShowsWithinCountryDifference() throws {
        let c = try StatisticsRepository.bundled()
        var session = try LifeSession.start(catalog: c, countryCode: "IND", householdID: "ind-1", seed: 0)
        while session.state.age < 39 {
            try session.choose("rest", catalog: c); try session.continueLife(catalog: c)
        }
        let original = session
        let rows = try session.compareHouseholds(choiceID: "invest", catalog: c)
        XCTAssertEqual(rows.map(\.householdID), ["ind-1", "ind-2"])
        XCTAssertEqual(rows.map(\.applied), [false, true])
        XCTAssertEqual(rows.map(\.budgetBefore.materials), [2, 4])
        XCTAssertEqual(rows.map(\.finalCost.time), [2, 3])
        XCTAssertTrue(rows.allSatisfy { $0.resourcesBefore == original.state.resources && $0.seed == 0 })
        XCTAssertEqual(session, original)
    }

    func testCountryNamesAndOrderingNeverChangeCostsOrSupport() throws {
        let c = try StatisticsRepository.bundled(), before = try state(c)
        let actual = try DecisionResolver.resolve(state: before, eventID: "adult-care", choiceID: "invest", catalog: c)
        var changed = c
        for i in changed.countries.indices { changed.countries[i].name = "同一個名字" }
        changed.countries.reverse(); changed.households.reverse()
        XCTAssertEqual(actual, try DecisionResolver.resolve(state: before, eventID: "adult-care", choiceID: "invest", catalog: changed))
    }

    func testEightCountriesCompleteRestoreAndReplay() throws {
        let c = try StatisticsRepository.bundled()
        for h in c.households {
            var session = try LifeSession.start(catalog: c, countryCode: h.countryCode, householdID: h.id, seed: 0)
            var replay = session
            while session.phase != .ended {
                let event = try session.event(catalog: c)
                let available = try event.choices.filter { try session.preview(choiceID: $0.id, catalog: c).applied }
                let selected = try XCTUnwrap(available.first { $0.id == "invest" } ?? available.first { $0.id == "ask" } ?? available.first)
                try session.choose(selected.id, catalog: c); try replay.choose(selected.id, catalog: c)
                try session.continueLife(catalog: c); try replay.continueLife(catalog: c)
            }
            XCTAssertEqual(session.state.age, 80); XCTAssertEqual(session.traces.count, 15)
            XCTAssertEqual(session, replay)
            XCTAssertEqual(try LifeSession.restore(from: JSONEncoder().encode(session), catalog: c), session)
        }
    }

    func testTaiwanFullBranchPreservesOriginalAndBothCompletedRemaindersOnRestore() throws {
        let c = try StatisticsRepository.bundled()
        var original = try LifeSession.start(catalog: c, countryCode: "TWN", householdID: "twn-1", seed: 0)
        while original.phase != .ended {
            try original.choose("rest", catalog: c); try original.continueLife(catalog: c)
        }
        var fork = try BranchExperiment.start(original: original, decisionIndex: 3, choiceID: "offline", catalog: c)
        while fork.alternative.phase != .ended {
            if fork.alternative.phase == .reflecting { try fork.continueLife(catalog: c) }
            else { try fork.choose("rest", catalog: c) }
        }
        let restored = try JSONDecoder().decode(BranchExperiment.self, from: JSONEncoder().encode(fork))
        try restored.validate(catalog: c)
        XCTAssertEqual(restored, fork)
        XCTAssertEqual(fork.original, original)
        let comparison = try BranchComparisonEngine.compare(restored, catalog: c)
        XCTAssertEqual(comparison.rows.count, 12)
        XCTAssertEqual(comparison.rows.last?.original.age, 80)
        XCTAssertEqual(comparison.rows.last?.alternative.age, 80)
    }

    func testUnknownLicenseForgedExtractionColumnAndNationalValueAreRejected() throws {
        let c = try StatisticsRepository.bundled()
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(c)) as? [String: Any])
        var sources = try XCTUnwrap(object["sources"] as? [[String: Any]])
        let national = try XCTUnwrap(sources.firstIndex { $0["id"] as? String == "taiwan-che" })
        sources[national]["license"] = "unverified"
        object["sources"] = sources
        XCTAssertThrowsError(try StatisticsRepository.decode(JSONSerialization.data(withJSONObject: object)))
        sources[national]["license"] = "OGDL-Taiwan-1.0"
        sources[national]["column"] = 6 // NHE/GDP is not CHE/GDP.
        object["sources"] = sources
        XCTAssertThrowsError(try StatisticsRepository.decode(JSONSerialization.data(withJSONObject: object)))

        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        try FileManager.default.copyItem(at: root.appendingPathComponent("LifeCrossroads/Data/Resources"), to: directory)
        var changed = c
        let index = try XCTUnwrap(changed.countries.firstIndex { $0.code == "TWN" })
        changed.countries[index].indicators[0].value = 0
        try JSONEncoder().encode(changed).write(to: directory.appendingPathComponent("catalog.json"))
        XCTAssertThrowsError(try StatisticsRepository.load(directory: directory))
    }
}
