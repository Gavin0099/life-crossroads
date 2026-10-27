import XCTest
@testable import LifeDomain
import LifeData
import LifePersistence
import LifePresentation

final class OpportunityTests: XCTestCase {
    private func at(_ age: Int, code: String = "JPN", household: Int = 1, project: String = "invest",
                    continuation: String? = nil, seed: UInt64 = 34, catalog c: ModelCatalog) throws -> LifeSession {
        var life = try LifeSession.start(catalog: c, countryCode: code, householdID: "\(code.lowercased())-\(household)", seed: seed)
        while life.state.age < age {
            let event = try life.event(catalog: c)
            let preferred = life.state.age == 13 ? project : (life.state.age == 17 ? (continuation ?? "rest") : "rest")
            let choice = try event.choices.contains { $0.id == preferred } && life.preview(choiceID: preferred, catalog: c).applied ? preferred : "rest"
            try life.choose(choice, catalog: c); try life.continueLife(catalog: c)
        }
        return life
    }
    func testSameWishAndHouseholdCreateDifferentExecutableOpportunitiesAndAdultRoutes() throws {
        let c = try StatisticsRepository.bundled()
        for (code, offer, adult, opposite) in [("JPN", "remoteStudio", "portfolio", "cooperate"), ("KEN", "mentorRelay", "cooperate", "portfolio")] {
            var teen = try at(17, code: code, catalog: c)
            XCTAssertEqual(teen.traces[3].choiceID, "invest")
            XCTAssertEqual(try teen.event(catalog: c).id, "teen-direction")
            XCTAssertTrue(try teen.preview(choiceID: offer, catalog: c).applied)
            let other = offer == "remoteStudio" ? "mentorRelay" : "remoteStudio"
            XCTAssertFalse(try teen.preview(choiceID: other, catalog: c).applied)
            let before = teen
            XCTAssertThrowsError(try teen.choose(other, catalog: c)); XCTAssertEqual(teen, before)
            let receipt = try XCTUnwrap(teen.preview(choiceID: offer, catalog: c).storyBranch?.opportunity)
            XCTAssertEqual(receipt.observations.count, 2)
            XCTAssertEqual(receipt.observations.first?.year, 2023)
            XCTAssertTrue(receipt.assumptionIDs.contains("creative-opportunities"))
            XCTAssertEqual(receipt.assumptionIDs.contains("support-network"), code == "KEN")
            XCTAssertEqual(receipt.mentorSupport != nil, code == "KEN")
            let adultLife = try at(25, code: code, continuation: offer, catalog: c)
            XCTAssertEqual(try adultLife.event(catalog: c).id, "adult-learning")
            let offered = try adultLife.preview(choiceID: adult, catalog: c)
            XCTAssertTrue(offered.applied); XCTAssertFalse(try adultLife.preview(choiceID: opposite, catalog: c).applied)
            XCTAssertEqual(offered.storyBranch?.opportunity?.assumptionIDs, ["creative-opportunities"])
            XCTAssertNil(offered.storyBranch?.opportunity?.mentorSupport)
            XCTAssertEqual(offered.storyBranch?.sourceAge, 17); XCTAssertEqual(offered.storyBranch?.sourceChoiceID, offer)
            XCTAssertEqual(offered.eventSelection.assumptionID, "creative-opportunities")
            XCTAssertEqual(offered.costSteps.contains { $0.ruleID == "context.digital" }, code == "JPN")
        }
    }
    func testMissingInputsNoSupportAndOfflineDoNotInventRoutes() throws {
        let c = try StatisticsRepository.bundled()
        let missing = try at(17, code: "TWN", catalog: c)
        let trace = try missing.preview(choiceID: "ask", catalog: c)
        XCTAssertEqual(trace.storyBranch?.opportunity?.route, "unknown")
        XCTAssertNil(trace.storyBranch?.opportunity?.preparation)
        XCTAssertFalse(try missing.preview(choiceID: "remoteStudio", catalog: c).applied)
        XCTAssertFalse(try missing.preview(choiceID: "mentorRelay", catalog: c).applied)
        var noSupport = c
        for i in noSupport.households.indices where noSupport.households[i].templateID == "shared-equipment-near-support" { noSupport.households[i].mentorSupport = 0 }
        // A reviewed 13-year decision fixture with no earlier consumption; the route must not fabricate a teacher.
        let born = try LifeState.born(catalog: noSupport, countryCode: "KEN", householdID: "ken-1", seed: 34)
        let s = try SimulationEngine.advance(born, to: 13, catalog: noSupport).0
        // Time budget is bounded: use a lower-base-cost fixture to make the earlier action affordable.
        noSupport.decisions[noSupport.decisions.firstIndex { $0.id == "teen-project" }!].choices[0].timeCost = 1
        let result = try DecisionResolver.resolve(state: s, eventID: "teen-project", choiceID: "invest", catalog: noSupport)
        XCTAssertTrue(result.trace.applied)
        let future = try SimulationEngine.advance(result.state, to: 17, catalog: noSupport).0
        let denied = try DecisionResolver.resolve(state: future, eventID: "teen-direction", choiceID: "mentorRelay", catalog: noSupport)
        XCTAssertFalse(denied.trace.applied); XCTAssertEqual(denied.trace.storyBranch?.opportunity?.route, "seeking")
        let j = try at(17, project: "offline", catalog: c), k = try at(17, code: "KEN", project: "offline", catalog: c)
        XCTAssertEqual(try j.event(catalog: c), try k.event(catalog: c))
        XCTAssertEqual(try j.preview(choiceID: "offline", catalog: c).finalCost, try k.preview(choiceID: "offline", catalog: c).finalCost)
        // The offline learning route also creates real cooperative experience, in every environment.
        for code in ["JPN", "KEN", "TWN"] {
            let paperAdult = try at(25, code: code, project: "offline", continuation: "offline", catalog: c)
            XCTAssertTrue(try paperAdult.preview(choiceID: "cooperate", catalog: c).applied)
            XCTAssertFalse(try paperAdult.preview(choiceID: "portfolio", catalog: c).applied)
            XCTAssertEqual(try paperAdult.preview(choiceID: "cooperate", catalog: c).storyBranch?.sourceChoiceID, "offline")
        }
        for option in ["ask", "rest"] {
            let recovery = try at(25, continuation: option, catalog: c)
            let event = try recovery.event(catalog: c)
            if event.id == "adult-learning" {
                XCTAssertFalse(event.choices.contains { ["portfolio", "cooperate"].contains($0.id) })
                XCTAssertTrue(try recovery.preview(choiceID: "offline", catalog: c).applied)
            }
        }
    }
    func testThresholdsNamesAndCandidateOrderAreIndependent() throws {
        let original = try StatisticsRepository.bundled()
        for (internet, power, expected) in [(60.0,95.0,"remote"), (59.999,95.0,"relay"), (90.0,94.999,"relay"), (90.0,95.0,"remote")] {
            var c = original
            let index = c.countries.firstIndex { $0.code == "JPN" }!
            for i in c.countries[index].indicators.indices {
                if c.countries[index].indicators[i].indicator == "IT.NET.USER.ZS" { c.countries[index].indicators[i].value = internet }
                if c.countries[index].indicators[i].indicator == "EG.ELC.ACCS.ZS" { c.countries[index].indicators[i].value = power }
            }
            let life = try at(17, catalog: c)
            let receipt = try life.preview(choiceID: "ask", catalog: c)
            XCTAssertEqual(receipt.storyBranch?.opportunity?.route, expected)
            var renamed = c; renamed.decisions.reverse(); renamed.countries.reverse()
            for i in renamed.countries.indices { renamed.countries[i].name = "測試名稱" }
            XCTAssertEqual(try life.preview(choiceID: "ask", catalog: renamed), receipt)
        }
    }
    func testSameTemplateDefaultAndExplicitMixedFamilyExploration() throws {
        let c = try StatisticsRepository.bundled()
        var original = try at(80, catalog: c); try original.choose("rest", catalog: c); try original.continueLife(catalog: c)
        let defaults = ParallelLifeExperiment.matchingHouseholds(original: original, catalog: c)
        XCTAssertEqual(defaults.count, 7)
        XCTAssertTrue(defaults.allSatisfy { $0.templateID == "shared-equipment-near-support" })
        XCTAssertThrowsError(try ParallelLifeExperiment.start(original: original, countryCode: "KEN", householdID: "ken-2", catalog: c, sameTemplateOnly: true))
        XCTAssertNoThrow(try ParallelLifeExperiment.start(original: original, countryCode: "KEN", householdID: "ken-2", catalog: c, sameTemplateOnly: false))
    }
    func testLateRememberedRelationshipOutranksAnEarlyCosmeticDifference() throws {
        var c = try StatisticsRepository.bundled()
        c.decisions.removeAll { !$0.isFallback }
        for i in c.decisions.indices {
            c.decisions[i].selection.minimumAge = c.decisions[i].age
            c.decisions[i].selection.maximumAge = c.decisions[i].age
        }
        func complete(friend: String) throws -> LifeSession {
            var life = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 34)
            while life.phase != .ended {
                try life.choose(life.state.age == 10 ? friend : "rest", catalog: c)
                try life.continueLife(catalog: c)
            }
            return life
        }
        let old = try complete(friend: "invest"), alternative = try complete(friend: "rest")
        let rows = old.traces.indices.map { BranchComparisonRow(decisionIndex: $0, original: old.traces[$0],
            alternative: alternative.traces[$0], originalArrival: old.jumps[$0], alternativeArrival: alternative.jumps[$0]) }
        let highlights = LifeStoryComparison.highlights(rows)
        XCTAssertTrue(highlights.contains { $0.original.age == 72 && $0.original.recurringPerson == "阿禾" && $0.alternative.recurringPerson == "小澄" })
        XCTAssertLessThanOrEqual(highlights.count, 3)
        XCTAssertTrue(LifeStoryComparison.highlights(rows.map { BranchComparisonRow(decisionIndex: $0.decisionIndex, original: $0.original, alternative: $0.original, originalArrival: $0.originalArrival, alternativeArrival: $0.originalArrival) }).isEmpty)
    }

    func testCompletePairReplayDiskAndIncompatibleFilePreservation() throws {
        let c = try StatisticsRepository.bundled()
        var original = try at(80, continuation: "remoteStudio", catalog: c)
        try original.choose("rest", catalog: c); try original.continueLife(catalog: c)
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        let originalBytes = try encoder.encode(original)
        var journey = LifeJourney.parallel(try .start(original: original, countryCode: "KEN", householdID: "ken-1", catalog: c, sameTemplateOnly: true))
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: dir) }
        let repo = SaveRepository(fileURL: dir.appendingPathComponent("save.json"))
        while true {
            try repo.save(journey, catalog: c)
            let restored = try XCTUnwrap(repo.load(catalog: c)); XCTAssertEqual(restored, journey)
            XCTAssertEqual(try encoder.encode(XCTUnwrap(restored.comparisonOriginal)), originalBytes)
            if journey.activeSession.phase == .ended { break }
            if journey.activeSession.phase == .reflecting { try journey.continueLife(catalog: c) }
            else {
                let age = journey.activeSession.state.age
                try journey.choose(age == 13 ? "invest" : age == 17 ? "mentorRelay" : age == 25 ? "cooperate" : "rest", catalog: c)
            }
        }
        XCTAssertEqual(try journey.parallelExperiment?.comparison(catalog: c).count, 15)
        let highlights = LifeStoryComparison.highlights(try XCTUnwrap(journey.parallelExperiment).comparison(catalog: c))
        XCTAssertLessThanOrEqual(highlights.count, 3); XCTAssertTrue(highlights.contains { $0.original.age == 25 })
        let good = try Data(contentsOf: repo.fileURL)
        let forged = Data(String(decoding: good, as: UTF8.self).replacingOccurrences(of: "\"relay\"", with: "\"remote\"").utf8)
        try forged.write(to: repo.fileURL)
        XCTAssertThrowsError(try repo.load(catalog: c)); XCTAssertEqual(try Data(contentsOf: repo.fileURL), forged)
        let old = Data(String(decoding: good, as: UTF8.self).replacingOccurrences(of: LifeState.engineVersion, with: "lc03-environment-1").utf8)
        try old.write(to: repo.fileURL)
        XCTAssertThrowsError(try repo.load(catalog: c)); XCTAssertEqual(try Data(contentsOf: repo.fileURL), old)
    }
}
