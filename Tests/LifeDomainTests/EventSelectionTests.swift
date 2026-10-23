import XCTest
import LifeData
import LifeDomain

final class EventSelectionTests: XCTestCase {
    /// Product acceptance fixes the seeds before implementation; do not search for a favorable sample.
    private func play(seed: UInt64, catalog: ModelCatalog) throws -> LifeSession {
        var session = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: seed)
        while session.phase != .ended {
            let event = try session.event(catalog: catalog)
            var selected: String?
            for choiceID in ["invest", "ask", "rest"] + event.choices.map(\.id) where selected == nil {
                if event.choices.contains(where: { $0.id == choiceID }), try session.preview(choiceID: choiceID, catalog: catalog).applied {
                    selected = choiceID
                }
            }
            try session.choose(XCTUnwrap(selected), catalog: catalog)
            try session.continueLife(catalog: catalog)
        }
        return session
    }

    func testPreselectedSeedsProduceDifferentActualEventsWithSameBackgroundAndPolicy() throws {
        let catalog = try StatisticsRepository.bundled()
        let samples = try [UInt64(0), 1, 2].map { try play(seed: $0, catalog: catalog) }
        for first in 0..<2 {
            for second in (first + 1)..<3 {
                XCTAssertNotEqual(samples[first].traces.map(\.eventID), samples[second].traces.map(\.eventID))
                XCTAssertNotEqual(samples[first].traces.map(\.eventTitle), samples[second].traces.map(\.eventTitle))
                XCTAssertNotEqual(samples[first].traces.map(\.choiceTitle), samples[second].traces.map(\.choiceTitle))
                XCTAssertNotEqual(samples[first].traces.map(\.recurringPerson), samples[second].traces.map(\.recurringPerson))
            }
        }
        XCTAssertEqual(samples.map { $0.state.decisions.count }, [15, 15, 15])
    }

    func testSameSeedAndPolicyReproduceEveryEventConditionAndOutcome() throws {
        let catalog = try StatisticsRepository.bundled()
        for seed: UInt64 in [0, 1, 2] {
            let first = try play(seed: seed, catalog: catalog)
            XCTAssertEqual(first, try play(seed: seed, catalog: catalog))
            XCTAssertEqual(first.selectionTraces.count, 15)
            XCTAssertEqual(first.selectionTraces.map(\.age), LifeSession.decisionAges)
            XCTAssertEqual(first.selectionTraces.map(\.selectedEventID), first.traces.map(\.eventID))
            XCTAssertEqual(first.traces.map(\.eventSelection), first.selectionTraces)
        }
    }

    func testCatalogOrderCannotChangeSelectedEventsOrTraces() throws {
        let catalog = try StatisticsRepository.bundled()
        var reordered = catalog
        reordered.decisions.reverse()
        for index in reordered.decisions.indices { reordered.decisions[index].eligibility.reverse() }
        try reordered.validate()
        XCTAssertEqual(try play(seed: 1, catalog: catalog), try play(seed: 1, catalog: reordered))
    }

    func testConditionsShowActualInputsAndIneligibleEventsCannotBeForced() throws {
        let catalog = try StatisticsRepository.bundled()
        let born = try LifeState.born(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        var atTwentyOne = try SimulationEngine.advance(born, to: 21, catalog: catalog).0
        atTwentyOne.resources.skills = 100 // Skills alone cannot invent the missing earlier project.
        let selection = try EventSelector.select(state: atTwentyOne, catalog: catalog)
        let repair = try XCTUnwrap(selection.candidates.first { $0.eventID == "teen-repair-table" })
        XCTAssertFalse(repair.eligible)
        let history = try XCTUnwrap(repair.conditions.first { $0.condition.kind == .storyFlag })
        XCTAssertNil(history.actualChoiceID)
        XCTAssertFalse(history.matched)
        XCTAssertTrue(repair.conditions.contains { $0.actualValue == 100 && $0.matched })
        let forced = try DecisionResolver.resolve(state: atTwentyOne, eventID: "teen-repair-table", choiceID: "invest", catalog: catalog)
        XCTAssertFalse(forced.trace.applied)
        XCTAssertEqual(forced.state, atTwentyOne)
        XCTAssertTrue(forced.trace.effectSteps.isEmpty)

        atTwentyOne.resources.health = 49
        let noKitchen = try EventSelector.select(state: atTwentyOne, catalog: catalog)
        let kitchen = try XCTUnwrap(noKitchen.candidates.first { $0.eventID == "teen-shared-kitchen" })
        XCTAssertFalse(kitchen.eligible)
        XCTAssertTrue(kitchen.conditions.contains { $0.condition.key == "careLoad" && $0.actualValue == 1 && $0.matched })
        XCTAssertTrue(kitchen.conditions.contains { $0.condition.key == "health" && $0.actualValue == 49 && !$0.matched })
        XCTAssertTrue(noKitchen.eligibleEventIDs.contains("teen-launch"))
        XCTAssertFalse(noKitchen.eligibleEventIDs.contains("teen-shared-kitchen"))

        atTwentyOne.resources.health = 50
        let atKitchenBoundary = try EventSelector.select(state: atTwentyOne, catalog: catalog)
        let boundaryKitchen = try XCTUnwrap(atKitchenBoundary.candidates.first { $0.eventID == "teen-shared-kitchen" })
        XCTAssertTrue(boundaryKitchen.eligible)
        XCTAssertTrue(boundaryKitchen.conditions.contains { $0.condition.key == "health" && $0.actualValue == 50 && $0.matched })

        var atThirtyTwo = try SimulationEngine.advance(born, to: 32, catalog: catalog).0
        atThirtyTwo.resources.financial = 65
        let atMarketBoundary = try EventSelector.select(state: atThirtyTwo, catalog: catalog)
        XCTAssertTrue(try XCTUnwrap(atMarketBoundary.candidates.first { $0.eventID == "adult-neighbor-market" }).eligible)
        atThirtyTwo.resources.financial = 66
        let aboveMarketBoundary = try EventSelector.select(state: atThirtyTwo, catalog: catalog)
        XCTAssertFalse(try XCTUnwrap(aboveMarketBoundary.candidates.first { $0.eventID == "adult-neighbor-market" }).eligible)
    }

    func testEligibleButUnselectedEventCannotBeExecutedDirectly() throws {
        let catalog = try StatisticsRepository.bundled()
        let born = try LifeState.born(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 2)
        let current = try SimulationEngine.advance(born, to: 12, catalog: catalog).0
        let selection = try EventSelector.select(state: current, catalog: catalog)
        XCTAssertGreaterThan(selection.eligibleEventIDs.count, 1)
        let unselected = try XCTUnwrap(selection.eligibleEventIDs.first { $0 != selection.selectedEventID })
        let forced = try DecisionResolver.resolve(state: current, eventID: unselected, choiceID: "rest", catalog: catalog)
        XCTAssertFalse(forced.trace.applied)
        XCTAssertEqual(forced.state, current)
    }

    func testCatalogRejectsMissingFallbackAndInvalidConditionContract() throws {
        let catalog = try StatisticsRepository.bundled()
        var noFallback = catalog
        noFallback.decisions.removeAll { $0.age == 12 && $0.isFallback }
        XCTAssertThrowsError(try noFallback.validate())
        var invalid = catalog
        let index = try XCTUnwrap(invalid.decisions.firstIndex { $0.id == "teen-repair-table" })
        invalid.decisions[index].eligibility[0].key = "KEN" // Country identifiers are not a history field.
        XCTAssertThrowsError(try invalid.validate())
        invalid = catalog
        let garden = try XCTUnwrap(invalid.decisions.firstIndex { $0.id == "middle-garden-table" })
        invalid.decisions[garden].eligibility[0].threshold = -1
        XCTAssertThrowsError(try invalid.validate())
        invalid = catalog
        invalid.decisions[garden].eligibility[0].key = "country-success"
        XCTAssertThrowsError(try invalid.validate())
    }

    func testPublicSelectorRejectsInvalidStateAndCatalogBeforeProducingTrace() throws {
        let catalog = try StatisticsRepository.bundled()
        var current = try LifeState.born(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        current = try SimulationEngine.advance(current, to: 12, catalog: catalog).0
        var invalidState = current; invalidState.resources.health = -1
        XCTAssertThrowsError(try EventSelector.select(state: invalidState, catalog: catalog))
        var invalidCatalog = catalog; invalidCatalog.schemaVersion = 999
        XCTAssertThrowsError(try EventSelector.select(state: current, catalog: invalidCatalog))
    }

    func testLastContinueCannotFinishAgainstAnotherContentVersion() throws {
        let catalog = try StatisticsRepository.bundled()
        var current = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        while current.state.age < 80 {
            try current.choose("rest", catalog: catalog)
            try current.continueLife(catalog: catalog)
        }
        try current.choose("rest", catalog: catalog)
        let before = current
        var wrongVersion = catalog; wrongVersion.contentVersion = "another-content"
        XCTAssertThrowsError(try current.continueLife(catalog: wrongVersion))
        XCTAssertEqual(current, before)
        try current.continueLife(catalog: catalog)
        XCTAssertEqual(current.phase, .ended)
    }

    func testRestoreReplaysAndRejectsForgedSelectionOrPastConsequencesBeforeContinuation() throws {
        let catalog = try StatisticsRepository.bundled()
        var current = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 1)
        for _ in 0..<5 {
            try current.choose("rest", catalog: catalog)
            try current.continueLife(catalog: catalog)
        }
        let encoded = try JSONEncoder().encode(current)
        var restored = try LifeSession.restore(from: encoded, catalog: catalog)
        XCTAssertEqual(restored, current)
        try restored.choose("rest", catalog: catalog)
        try current.choose("rest", catalog: catalog)
        XCTAssertEqual(restored, current)

        let original = try XCTUnwrap(JSONSerialization.jsonObject(with: encoded) as? [String: Any])
        for mutation in ["selection-id", "selection-draw", "past-outcome"] {
            var object = original
            if mutation == "past-outcome" {
                var traces = try XCTUnwrap(object["traces"] as? [[String: Any]])
                traces[0]["eventTitle"] = "forged story"
                object["traces"] = traces
            } else {
                var selections = try XCTUnwrap(object["selectionTraces"] as? [[String: Any]])
                if mutation == "selection-id" { selections[0]["selectedEventID"] = "child-library-map" }
                else { selections[0]["draw"] = -0.5 }
                object["selectionTraces"] = selections
            }
            let tampered = try JSONSerialization.data(withJSONObject: object)
            XCTAssertThrowsError(try LifeSession.restore(from: tampered, catalog: catalog))
            var raw = try JSONDecoder().decode(LifeSession.self, from: tampered)
            XCTAssertThrowsError(try raw.event(catalog: catalog))
            XCTAssertThrowsError(try raw.choose("rest", catalog: catalog))
        }
    }

    func testComparisonKeepsActualEncounterAndSelectionFixed() throws {
        let catalog = try StatisticsRepository.bundled()
        var current = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        for _ in 0..<2 {
            try current.choose("invest", catalog: catalog)
            try current.continueLife(catalog: catalog)
        }
        let actual = try current.event(catalog: catalog)
        let comparison = try current.compare(choiceID: "rest", countryCodes: ["JPN", "USA", "IND", "KEN"], catalog: catalog)
        XCTAssertTrue(comparison.allSatisfy { $0.eventID == actual.id && $0.eventSelection == current.currentSelection })
        XCTAssertTrue(comparison.allSatisfy { $0.resourcesBefore == current.state.resources })
    }

    func testOneThousandLivesHaveFifteenSlotsNoDeadlocksAndPreserveStoryAnchors() throws {
        let catalog = try StatisticsRepository.bundled()
        let families = catalog.households.filter { $0.countryCode != "TWN" }
        let anchors = EventSchedule.milestones
        for index in 0..<1000 {
            let family = families[index % families.count]
            var session = try LifeSession.start(catalog: catalog, countryCode: family.countryCode,
                                                householdID: family.id, seed: UInt64(index / families.count))
            while session.phase != .ended {
                let event = try session.event(catalog: catalog)
                if let anchor = anchors[event.age] { XCTAssertEqual(event.id, anchor) }
                let candidate = event.choices[index % event.choices.count].id
                let preview = try session.preview(choiceID: candidate, catalog: catalog)
                try session.choose(preview.applied ? candidate : "rest", catalog: catalog)
                try session.continueLife(catalog: catalog)
            }
            XCTAssertEqual(session.traces.count, 15)
            XCTAssertEqual(session.selectionTraces.count, 15)
            XCTAssertEqual(session.state.age, 80)
            XCTAssertTrue(session.traces.allSatisfy(\.applied))
            try session.state.validate(catalog: catalog)
        }
    }
}
