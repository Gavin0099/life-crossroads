import XCTest
import LifeData
import LifeDomain

final class LifeSessionTests: XCTestCase {
    func testRoundAllowancesResetWhileResourcesAndChoicesContinue() throws {
        let c = try StatisticsRepository.bundled()
        for choice in ["invest", "rest"] {
            var session = try LifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-2", seed: 42)
            try session.choose(choice, catalog: c)
            let trace = try XCTUnwrap(session.traces.last)
            XCTAssertEqual(trace.budgetAfter.time, choice == "invest" ? 1 : 4)
            XCTAssertEqual(trace.budgetAfter.energy, choice == "invest" ? 3 : 5)
            XCTAssertEqual(trace.budgetAfter.materials, choice == "invest" ? 3 : 4)
            let carriedResources = session.state.resources
            let carriedChoices = session.state.decisions
            try session.continueLife(catalog: c)
            XCTAssertEqual(session.state.remainingTime, 4)
            XCTAssertEqual(session.state.remainingEnergy, 5)
            XCTAssertEqual(session.state.remainingMaterials, 4)
            XCTAssertEqual(session.state.resources, carriedResources)
            XCTAssertEqual(session.state.decisions, carriedChoices)
        }
    }

    func testEveryDecisionHasOriginalStoryText() throws {
        let c = try StatisticsRepository.bundled()
        XCTAssertTrue(Set(c.decisions.map(\.id)).isSubset(of: Set(EventNarratives.texts.keys)))
        XCTAssertTrue(EventNarratives.texts.values.allSatisfy { $0.count >= 40 })
        XCTAssertEqual(c.contentVersion, "lx05-opportunity-story-1")
    }
    func testFourCountryEightFamilyPlaythroughsReachReviewAndCannotRepeat() throws {
        let c = try StatisticsRepository.bundled()
        for code in ["JPN", "USA", "IND", "KEN"] {
            for family in 1...2 {
                var session = try LifeSession.start(catalog: c, countryCode: code, householdID: "\(code.lowercased())-\(family)", seed: 42)
                for age in [8, 10, 12, 13, 17, 21, 25, 32, 39, 45, 52, 59, 65, 72, 80] {
                    XCTAssertEqual(try session.event(catalog: c).age, age)
                    let event = try session.event(catalog: c)
                    let choices = try event.choices.filter { try session.preview(choiceID: $0.id, catalog: c).applied }
                    let choice = try XCTUnwrap(choices.first).id
                    try session.choose(choice, catalog: c)
                    XCTAssertEqual(session.phase, .reflecting)
                    XCTAssertThrowsError(try session.choose(choice, catalog: c))
                    try session.continueLife(catalog: c)
                }
                XCTAssertEqual(session.phase, .ended)
                XCTAssertEqual(session.traces.count, 15)
                XCTAssertEqual(session.state.memories.count, session.traces.flatMap(\.scheduledHooks).count)
                XCTAssertThrowsError(try session.continueLife(catalog: c))
                XCTAssertThrowsError(try session.event(catalog: c))
            }
        }
    }

    func testUnavailableChoiceDoesNotAdvanceSessionAndRestRemainsPossible() throws {
        var c = try StatisticsRepository.bundled()
        c.decisions[0].choices[0].timeCost = 8 // Explicit unaffordable option, not a national restriction on an offline child activity.
        var session = try LifeSession.start(catalog: c, countryCode: "KEN", householdID: "ken-2", seed: 42)
        let original = session
        XCTAssertFalse(try session.preview(choiceID: "invest", catalog: c).applied)
        XCTAssertThrowsError(try session.choose("invest", catalog: c))
        XCTAssertEqual(session, original)
        XCTAssertThrowsError(try session.continueLife(catalog: c))
        try session.choose("rest", catalog: c)
        try session.continueLife(catalog: c)
        XCTAssertEqual(session.state.age, 10)
    }

    func testComparisonHoldsChoiceSeedAndPastResourcesFixed() throws {
        let c = try StatisticsRepository.bundled()
        let session = try LifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-2", seed: 42)
        let comparisons = try session.compare(choiceID: "invest", countryCodes: ["USA", "JPN", "IND", "KEN"], catalog: c)
        XCTAssertEqual(comparisons.map(\.finalCost.time), [3, 3, 3, 3])
        XCTAssertEqual(Set(comparisons.map(\.seed)), [42])
        XCTAssertTrue(comparisons.allSatisfy { $0.resourcesBefore == session.state.resources && $0.choiceID == "invest" })
        XCTAssertEqual(comparisons.map(\.applied), [true, true, true, true])
        XCTAssertEqual(session.phase, .choosing)
        XCTAssertTrue(session.traces.isEmpty)
    }

    func testSameBackgroundReplayUsesSameTraceAndSessionCodableResumes() throws {
        let c = try StatisticsRepository.bundled()
        var first = try LifeSession.start(catalog: c, countryCode: "IND", householdID: "ind-1", seed: .max)
        let replay = first
        try first.choose("invest", catalog: c)
        var restored = try JSONDecoder().decode(LifeSession.self, from: JSONEncoder().encode(first))
        XCTAssertEqual(restored, first)
        try restored.continueLife(catalog: c)
        try first.continueLife(catalog: c)
        XCTAssertEqual(restored, first)
        var second = replay
        try second.choose("invest", catalog: c)
        XCTAssertEqual(second.traces.first, first.traces.first)
    }

    func testRestExplanationIncludesOnlyExecutedContribution() throws {
        let c = try StatisticsRepository.bundled()
        let session = try LifeSession.start(catalog: c, countryCode: "KEN", householdID: "ken-2", seed: 42)
        let trace = try session.preview(choiceID: "rest", catalog: c)
        XCTAssertTrue(trace.applied)
        XCTAssertFalse(trace.observations.isEmpty) // Observed data alone is not a cause.
        XCTAssertNil(trace.randomTrial)
        XCTAssertEqual(trace.contributingInfluences, [.playerChoice])
        XCTAssertFalse(trace.influenceSummary.contains("運氣"))
        XCTAssertFalse(trace.influenceSummary.contains("環境條件"))
        XCTAssertFalse(trace.influenceSummary.contains("他人的協助"))
    }

    func testUnsuccessfulRandomTrialIsNotListedAsContribution() throws {
        let c = try StatisticsRepository.bundled()
        var checked = false
        for seed in UInt64(0)..<20 {
            let session = try LifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-2", seed: seed)
            let trace = try session.preview(choiceID: "invest", catalog: c)
            if trace.randomTrial?.occurred == false {
                XCTAssertEqual(trace.contributingInfluences, [.playerChoice, .family, .otherPeople])
                XCTAssertFalse(trace.influenceSummary.contains("機會事件"))
                checked = true
                break
            }
        }
        XCTAssertTrue(checked)
    }

    func testComparisonUsesSelectedChoiceAndStableTemplateAfterFamilyReordering() throws {
        var c = try StatisticsRepository.bundled()
        let ken1 = try XCTUnwrap(c.households.firstIndex { $0.id == "ken-1" })
        let ken2 = try XCTUnwrap(c.households.firstIndex { $0.id == "ken-2" })
        c.households.swapAt(ken1, ken2)
        let session = try LifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-2", seed: 42)
        let comparisons = try session.compare(choiceID: "rest", countryCodes: ["USA", "KEN"], catalog: c)
        XCTAssertEqual(comparisons.map(\.householdID), ["usa-2", "ken-2"])
        XCTAssertTrue(comparisons.allSatisfy { $0.choiceID == "rest" && $0.finalCost == Cost() })
        XCTAssertTrue(comparisons.allSatisfy { $0.resourcesBefore == session.state.resources && $0.seed == 42 })
        XCTAssertTrue(try XCTUnwrap(session.compare(choiceID: "rest", countryCodes: ["TWN"], catalog: c).first).environmentGaps.isEmpty)
    }

    func testDecodedCorruptSessionCannotIndexBeyondCatalog() throws {
        let c = try StatisticsRepository.bundled()
        var session = try LifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: 42)
        try session.choose("rest", catalog: c)
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(session)) as? [String: Any])
        let trace = try XCTUnwrap((object["traces"] as? [Any])?.first)
        object["traces"] = Array(repeating: trace, count: 16)
        var corrupt = try JSONDecoder().decode(LifeSession.self, from: JSONSerialization.data(withJSONObject: object))
        XCTAssertThrowsError(try corrupt.continueLife(catalog: c))
    }
}
