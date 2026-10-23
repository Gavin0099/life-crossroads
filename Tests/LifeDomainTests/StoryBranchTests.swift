import XCTest
import LifeData
import LifeDomain

/// Reviewed contracts: one changed early choice must change later story content or available actions.
final class StoryBranchTests: XCTestCase {
    private func session(at age: Int, choices: [String: String], seed: UInt64 = 42) throws -> LifeSession {
        let catalog = try StatisticsRepository.bundled()
        var play = try LifeSession.start(catalog: catalog, countryCode: "USA", householdID: "usa-2", seed: seed)
        while play.state.age < age {
            let event = try play.event(catalog: catalog)
            try play.choose(choices[event.id] ?? "rest", catalog: catalog)
            try play.continueLife(catalog: catalog)
        }
        return play
    }

    func testChildhoodFriendshipChangesWhoAppearsAtSeventyTwo() throws {
        let catalog = try StatisticsRepository.bundled()
        let keptPromise = try session(at: 72, choices: ["child-friend": "invest"])
        let anotherRoute = try session(at: 72, choices: ["child-friend": "rest"])
        let reunion = try keptPromise.event(catalog: catalog)
        let newConnection = try anotherRoute.event(catalog: catalog)
        XCTAssertEqual(reunion.recurringPerson, "阿禾")
        XCTAssertEqual(newConnection.recurringPerson, "小澄")
        XCTAssertNotEqual(reunion.title, newConnection.title)
        XCTAssertNotEqual(reunion.choices.map(\.title), newConnection.choices.map(\.title))
        XCTAssertEqual(keptPromise.state.seed, anotherRoute.state.seed)
    }

    func testLearningRouteChangesMentorSceneAndWorkshopOpportunity() throws {
        let catalog = try StatisticsRepository.bundled()
        let prepared = ["child-interest": "invest", "child-transition": "invest", "teen-project": "offline"]
        let paper = try session(at: 17, choices: prepared)
        var onlineChoices = prepared; onlineChoices["teen-project"] = "invest"
        let online = try session(at: 17, choices: onlineChoices)
        let firstSteps = try session(at: 17, choices: [:])
        let paperEvent = try paper.event(catalog: catalog)
        XCTAssertNotEqual(paperEvent.title, try online.event(catalog: catalog).title)
        XCTAssertTrue(paperEvent.choices.contains { $0.id == "leadWorkshop" })
        XCTAssertFalse(try firstSteps.event(catalog: catalog).choices.contains { $0.id == "leadWorkshop" })
        XCTAssertNotEqual(paperEvent.recurringPerson, try firstSteps.event(catalog: catalog).recurringPerson)
    }

    func testSharedCareArrangementUnlocksReciprocalSupport() throws {
        let catalog = try StatisticsRepository.bundled()
        let shared = try session(at: 52, choices: ["adult-care": "invest"])
        let firstRequest = try session(at: 52, choices: ["adult-care": "rest"])
        let reciprocal = try shared.event(catalog: catalog)
        XCTAssertTrue(reciprocal.choices.contains { $0.id == "shareShift" })
        XCTAssertFalse(try firstRequest.event(catalog: catalog).choices.contains { $0.id == "shareShift" })
        XCTAssertNotEqual(reciprocal.title, try firstRequest.event(catalog: catalog).title)
    }

    func testLearningBranchTraceRecordsActualHistoryAndBothSidesOfResourceThreshold() throws {
        let catalog = try StatisticsRepository.bundled()
        let play = try session(at: 17, choices: ["teen-project": "offline"])
        var below = play.state
        below.resources.skills = 27
        let denied = try DecisionResolver.resolve(state: below, eventID: "teen-direction", choiceID: "leadWorkshop", catalog: catalog)
        XCTAssertFalse(denied.trace.applied)
        XCTAssertEqual(denied.state, below)
        let lower = try XCTUnwrap(denied.trace.storyBranch)
        XCTAssertEqual(lower.ruleID, "story.learning-route")
        XCTAssertEqual(lower.sourceEventID, "teen-project")
        XCTAssertEqual(lower.sourceChoiceID, "offline")
        XCTAssertEqual(lower.variantID, "teen-direction-paper")
        XCTAssertEqual(lower.resourceChecks.first?.resource, "skills")
        XCTAssertEqual(lower.resourceChecks.first?.value, 27)
        XCTAssertEqual(lower.resourceChecks.first?.minimum, 28)
        XCTAssertEqual(lower.resourceChecks.first?.met, false)
        XCTAssertFalse(lower.offeredChoiceIDs.contains("leadWorkshop"))
        XCTAssertTrue(lower.offeredChoiceIDs.contains("rest"))
        XCTAssertTrue(lower.offeredChoiceIDs.contains("ask"))
        XCTAssertTrue(try DecisionResolver.resolve(state: below, eventID: "teen-direction", choiceID: "rest", catalog: catalog).trace.applied)

        var ready = below; ready.resources.skills = 28
        let accepted = try DecisionResolver.resolve(state: ready, eventID: "teen-direction", choiceID: "leadWorkshop", catalog: catalog)
        XCTAssertTrue(accepted.trace.applied)
        XCTAssertEqual(accepted.trace.storyBranch?.resourceChecks.first?.met, true)
        XCTAssertTrue(try XCTUnwrap(accepted.trace.storyBranch).offeredChoiceIDs.contains("leadWorkshop"))
        XCTAssertEqual(accepted.trace.choiceTitle, "和樹老師一起帶領紙本小工作坊")
        XCTAssertEqual(accepted.state.decisions.last?.choiceID, "leadWorkshop")
        try accepted.state.validate(catalog: catalog)
    }

    func testCareBranchRequiresHistoryAndHealthAndCannotBeBypassedThroughResolver() throws {
        let catalog = try StatisticsRepository.bundled()
        let priorArrangement = try session(at: 52, choices: ["adult-care": "invest"])
        var tired = priorArrangement.state; tired.resources.health = 54
        let denied = try DecisionResolver.resolve(state: tired, eventID: "middle-support", choiceID: "shareShift", catalog: catalog)
        XCTAssertFalse(denied.trace.applied)
        XCTAssertEqual(denied.state, tired)
        XCTAssertEqual(denied.trace.storyBranch?.sourceChoiceID, "invest")
        XCTAssertEqual(denied.trace.storyBranch?.resourceChecks.first?.value, 54)
        XCTAssertEqual(denied.trace.storyBranch?.resourceChecks.first?.minimum, 55)
        XCTAssertEqual(denied.trace.storyBranch?.resourceChecks.first?.met, false)
        XCTAssertTrue(try DecisionResolver.resolve(state: tired, eventID: "middle-support", choiceID: "ask", catalog: catalog).trace.applied)
        var rested = tired; rested.resources.health = 55
        let accepted = try DecisionResolver.resolve(state: rested, eventID: "middle-support", choiceID: "shareShift", catalog: catalog)
        XCTAssertTrue(accepted.trace.applied)
        let noArrangement = try session(at: 52, choices: [:])
        let missingHistory = try DecisionResolver.resolve(state: noArrangement.state, eventID: "middle-support", choiceID: "shareShift", catalog: catalog)
        XCTAssertFalse(missingHistory.trace.applied)
        XCTAssertEqual(missingHistory.trace.storyBranch?.sourceChoiceID, "rest")
        XCTAssertTrue(missingHistory.state.resources.health >= 55)
    }

    func testPreviewExecutionAndCodableReplayKeepActualVariantAndChoiceSnapshots() throws {
        let catalog = try StatisticsRepository.bundled()
        var play = try session(at: 72, choices: ["child-friend": "ask"])
        let actualEvent = try play.event(catalog: catalog)
        let preview = try play.preview(choiceID: "invest", catalog: catalog)
        var restored = try JSONDecoder().decode(LifeSession.self, from: JSONEncoder().encode(play))
        try play.choose("invest", catalog: catalog)
        try restored.choose("invest", catalog: catalog)
        XCTAssertEqual(play, restored)
        XCTAssertEqual(play.traces.last, preview)
        XCTAssertEqual(preview.eventTitle, actualEvent.title)
        XCTAssertEqual(preview.choiceTitle, "和阿禾修補風車，再做一張合照")
        XCTAssertEqual(preview.recurringPerson, "阿禾")
        XCTAssertEqual(preview.storyVariantID, "later-reconnect-old-friend")
        XCTAssertEqual(preview.storyBranch?.sourceChoiceID, "ask")
        XCTAssertEqual(preview.storyBranch?.offeredChoiceIDs, actualEvent.choices.map(\.id))
        XCTAssertEqual(try JSONDecoder().decode(ConsequenceTrace.self, from: JSONEncoder().encode(preview)), preview)
    }

    func testAllCountryFamiliesCanFinishWithDiverseChoicesAndBranchNarratives() throws {
        let catalog = try StatisticsRepository.bundled()
        var seenVariants: Set<String> = []
        for household in catalog.households where household.countryCode != "TWN" {
            for seed: UInt64 in 0..<12 {
                var play = try LifeSession.start(catalog: catalog, countryCode: household.countryCode,
                                                householdID: household.id, seed: seed)
                while play.phase != .ended {
                    let event = try play.event(catalog: catalog)
                    if let variant = event.storyVariantID {
                        seenVariants.insert(variant)
                        XCTAssertNotNil(EventNarratives.texts[variant])
                    }
                    let preferred = event.choices[Int(seed % UInt64(event.choices.count))].id
                    let preview = try play.preview(choiceID: preferred, catalog: catalog)
                    try play.choose(preview.applied ? preferred : "rest", catalog: catalog)
                    XCTAssertTrue(try XCTUnwrap(play.traces.last).applied)
                    try play.continueLife(catalog: catalog)
                }
                XCTAssertEqual(play.state.decisions.count, 15)
                XCTAssertEqual(play.state.age, 80)
                try play.state.validate(catalog: catalog)
            }
        }
        XCTAssertEqual(seenVariants, ["teen-direction-paper", "teen-direction-online", "teen-direction-first-steps",
                                     "middle-support-reciprocal", "middle-support-first-request",
                                     "later-reconnect-old-friend", "later-reconnect-new-neighbor"])
    }

    func testZeroNationalCostIsObservationAndOnlyOccurredLuckContributes() throws {
        let catalog = try StatisticsRepository.bundled()
        var sawChance = false, sawNoChance = false
        for seed: UInt64 in 0..<20 {
            let play = try session(at: 13, choices: [:], seed: seed)
            let trace = try play.preview(choiceID: "invest", catalog: catalog)
            XCTAssertFalse(trace.observations.isEmpty)
            let national = try XCTUnwrap(trace.costSteps.first { $0.ruleID == "context.digital" })
            XCTAssertEqual(national.adjustment, Cost()) // USA fixture exceeds both reviewed digital thresholds.
            XCTAssertFalse(trace.contributingInfluences.contains(.socialEnvironment))
            if trace.randomTrial?.occurred == true {
                sawChance = true
                XCTAssertTrue(trace.contributingInfluences.contains(.randomness))
                XCTAssertTrue(trace.effectSteps.contains { $0.ruleID == "luck.encouragement" && $0.delta.relationships == 1 })
            } else {
                sawNoChance = true
                XCTAssertFalse(trace.contributingInfluences.contains(.randomness))
            }
        }
        XCTAssertTrue(sawChance)
        XCTAssertTrue(sawNoChance)
    }
}
