import Foundation
import XCTest
import LifeData
@testable import LifeDomain

/// Independent requirements are documented in docs/rng/batch-contract.md before these tests.
final class EventDirectorTests: XCTestCase {
    private func catalog() throws -> EventCatalog { try DirectedDemo.catalog(base: StatisticsRepository.bundled()) }
    private func born(_ c: EventCatalog, seed: UInt64 = 42, family: String = "usa-1") throws -> LifeState {
        var state = try LifeState.born(catalog: c.model, countryCode: String(family.prefix(3)).uppercased(), householdID: family, seed: seed)
        state.directorHistory = .init(catalogVersion: c.version)
        return state
    }
    private func advance(_ state: LifeState, to age: Int, _ c: EventCatalog) throws -> LifeState {
        // Boundary fixtures inspect eligibility only; no claim that injected histories are playable routes.
        var value = state; value.age = age
        value.remainingTime = try LifeStage.at(age: age).timeBudget
        value.remainingEnergy = try LifeStage.at(age: age).energyBudget
        return value
    }
    private func finish(_ initial: DirectedLifeSession, _ c: EventCatalog, choices: [String: String] = [:]) throws -> DirectedLifeSession {
        var run = initial
        while run.phase != .ended {
            if run.phase == .reflecting { try run.continueLife(catalog: c); continue }
            let event = try run.event(catalog: c)
            let choice = choices[event.id] ?? "ask"
            try run.choose(choice, catalog: c)
        }
        return run
    }

    func testCatalogRejectsInvalidDefinitionsAndUnsafeRecoveryRestrictions() throws {
        let c = try catalog()
        XCTAssertNoThrow(try c.validate())
        var validMaterialBoundary = c
        validMaterialBoundary.events[15].conditions = [.household(field: .materialBudget, minimum: 3, maximum: 4)]
        XCTAssertNoThrow(try validMaterialBoundary.validate())
        // Conditional-policy mutations target an optional event, avoiding unrelated fallback guards.
        let badMutations: [(inout EventCatalog) -> Void] = [
            { $0.events[0].weight = 0 }, { $0.events[0].weight = -1 },
            { $0.events.append($0.events[0]) }, { $0.events[0].decision.id = "" },
            { $0.events[15].minimumAge = 13; $0.events[15].maximumAge = 12 },
            { $0.events[15].policy.cooldownYears = -1 }, { $0.events[15].policy.maxOccurrences = 0 },
            { $0.events[15].policy.exclusiveGroup = "" },
            { $0.events[15].conditions = [.resource(field: .health, minimum: 101, maximum: 100)] },
            { $0.events[15].conditions = [.indicator(code: "IT.NET.USER.ZS", minimum: .nan, maximum: 100)] },
            { $0.events[15].conditions = [.household(field: .mentorSupport, minimum: 3, maximum: 4)] },
            { $0.events[15].conditions = [.historyChoice(eventID: "missing", choiceID: "ask")] },
            { $0.events[0].choiceConditions = [.init(choiceID: "rest", conditions: [.resource(field: .skills, minimum: 50, maximum: 100)])] },
            { $0.events[0].choiceConditions = [.init(choiceID: "ask", conditions: [.resource(field: .skills, minimum: 50, maximum: 100)])] },
            { $0.slots.removeLast() }, { $0.slots[1].age = $0.slots[0].age }
        ]
        for (index, mutate) in badMutations.enumerated() {
            var invalid = c; mutate(&invalid)
            XCTAssertThrowsError(try invalid.validate(), "mutation \(index)")
        }
    }

    func testWeightedSelectorRejectsEmptyDuplicateNegativeAndOverflowPools() throws {
        let pools: [[EligibleEvent]] = [[], [.init(eventID: "a", weight: 0)], [.init(eventID: "a", weight: -1)],
            [.init(eventID: "", weight: 1)], [.init(eventID: "a", weight: 1), .init(eventID: "a", weight: 2)],
            [.init(eventID: "a", weight: Int.max), .init(eventID: "b", weight: 1)]]
        for pool in pools {
            XCTAssertThrowsError(try WeightedEventSelector.select(candidates: pool, seed: 0, slotID: "slot", age: 8))
        }
        XCTAssertThrowsError(try WeightedEventSelector.select(candidates: [.init(eventID: "a", weight: 1)], seed: 0, slotID: "", age: 8))
        XCTAssertThrowsError(try WeightedEventSelector.select(candidates: [.init(eventID: "a", weight: 1)], seed: 0, slotID: "slot", age: 101))
    }

    func testOneCandidateAlwaysWinsAndUnrelatedDrawCannotMoveSelection() throws {
        for seed: UInt64 in [0, 1, 42, .max] {
            let selected = try WeightedEventSelector.select(candidates: [.init(eventID: "only", weight: 17)], seed: seed, slotID: "slot", age: 13)
            XCTAssertEqual(selected.selectedEventID, "only")
            XCTAssertEqual(selected.totalWeight, 17)
            _ = KeyedRandom.draw(seed: seed, key: "unrelated-effect")
            XCTAssertEqual(try WeightedEventSelector.select(candidates: [.init(eventID: "only", weight: 17)], seed: seed, slotID: "slot", age: 13), selected)
            XCTAssertTrue((0..<1).contains(selected.draw))
        }
    }

    func testWeightedSelectionIsOrderInvariantAndRespectsGrossOneToThreeRatio() throws {
        let candidates = [EligibleEvent(eventID: "a", weight: 1), .init(eventID: "b", weight: 3)]
        var counts: [String: Int] = [:]
        for seed: UInt64 in 0..<4096 {
            let selected = try WeightedEventSelector.select(candidates: candidates, seed: seed, slotID: "weight-fixture", age: 25)
            XCTAssertEqual(selected, try WeightedEventSelector.select(candidates: candidates.reversed(), seed: seed, slotID: "weight-fixture", age: 25))
            counts[selected.selectedEventID, default: 0] += 1
        }
        // Predeclared broad 20%...30% band about a 25% specified probability; not a fit to observed output.
        XCTAssertTrue((819...1229).contains(counts["a", default: 0]))
        XCTAssertTrue((2867...3277).contains(counts["b", default: 0]))
    }

    func testEligibilityChecksBothAgeAndResourceBoundarySides() throws {
        let c = try catalog(); let initial = try born(c)
        var event = try c.event("rng-community-practice")
        event.minimumAge = 25; event.maximumAge = 59
        for (age, health, expected) in [(24, 20, false), (25, 19, false), (25, 20, true), (59, 100, true), (60, 100, false)] {
            var state = try advance(initial, to: age, c); state.resources.health = health
            let result = try EventEligibility.evaluate(event: event, state: state, catalog: c)
            XCTAssertEqual(result.eligible, expected, "age \(age), health \(health)")
            XCTAssertFalse(result.checks.isEmpty)
            XCTAssertTrue(result.checks.allSatisfy { !$0.assumptionIDs.isEmpty })
        }
    }

    func testEligibilityUsesEnvironmentValuesAndHouseholdRatherThanCountryName() throws {
        var c = try catalog()
        let usa = c.model.countries.firstIndex { $0.code == "USA" }!
        let internet = c.model.countries[usa].indicators.firstIndex { $0.indicator == "IT.NET.USER.ZS" }!
        c.model.countries[usa].indicators[internet].value = 50 // Explicit synthetic boundary fixture.
        var event = try c.event("rng-child-tool-library")
        event.conditions = [.indicator(code: "IT.NET.USER.ZS", minimum: 50, maximum: 50),
                            .household(field: .mentorSupport, minimum: 2, maximum: 2), .deviceAccess(.shared)]
        let first = try advance(born(c), to: 8, c)
        XCTAssertTrue(try EventEligibility.evaluate(event: event, state: first, catalog: c).eligible)
        c.model.countries[usa].name = "任意更名"
        XCTAssertTrue(try EventEligibility.evaluate(event: event, state: first, catalog: c).eligible)
        c.model.countries[usa].indicators[internet].value = 49.99
        let denied = try EventEligibility.evaluate(event: event, state: first, catalog: c)
        XCTAssertFalse(denied.eligible)
        XCTAssertFalse(denied.checks.first { $0.ruleID.contains("indicator") }!.sourceIDs.isEmpty)
        c.model.countries[usa].indicators[internet].value = 50
        let second = try advance(born(c, family: "usa-2"), to: 8, c)
        XCTAssertFalse(try EventEligibility.evaluate(event: event, state: second, catalog: c).eligible)
    }

    func testOnceOnlyCooldownBoundaryAndMutualExclusionAreSeparateRules() throws {
        let c = try catalog(); var state = try advance(born(c), to: 34, c)
        var practice = try c.event("rng-community-practice")
        state.directorHistory!.occurrences = [.init(eventID: practice.id, slotID: "life-25", age: 25, ordinal: 1)]
        XCTAssertFalse(try EventEligibility.evaluate(event: practice, state: state, catalog: c).eligible)
        state.age = 35
        XCTAssertTrue(try EventEligibility.evaluate(event: practice, state: state, catalog: c).eligible)
        practice.policy.maxOccurrences = 1
        XCTAssertFalse(try EventEligibility.evaluate(event: practice, state: state, catalog: c).eligible)
        practice.policy.maxOccurrences = nil
        state.directorHistory!.occurrences = [.init(eventID: "rng-mutual-support", slotID: "life-39", age: 39, ordinal: 1)]
        state.age = 52
        let excluded = try EventEligibility.evaluate(event: practice, state: state, catalog: c)
        XCTAssertFalse(excluded.eligible)
        XCTAssertTrue(excluded.rejectionReasons.contains { $0.contains("policy.exclusive") })
    }

    func testHistoryAndRelationshipConditionsDoNotInferFactsFromText() throws {
        let c = try catalog(); var state = try advance(born(c), to: 52, c)
        var event = try c.event("rng-mutual-support")
        event.conditions = [.historyChoice(eventID: "adult-care", choiceID: "ask"),
                            .historyEvent(eventID: "child-friend", present: false),
                            .relationship(personID: "tool-library", factID: "connection", present: true)]
        XCTAssertFalse(try EventEligibility.evaluate(event: event, state: state, catalog: c).eligible)
        state.decisions = [.init(eventID: "adult-care", choiceID: "ask", age: 39)]
        XCTAssertFalse(try EventEligibility.evaluate(event: event, state: state, catalog: c).eligible)
        state.directorHistory!.relationships = [.init(personID: "tool-library", factID: "connection", present: true,
                                                      originOccurrenceID: "fixture-only", originChoiceID: "ask", assumptionID: "rng-scheduling-demo")]
        XCTAssertTrue(try EventEligibility.evaluate(event: event, state: state, catalog: c).eligible)
        state.decisions.append(.init(eventID: "child-friend", choiceID: "rest", age: 10))
        XCTAssertFalse(try EventEligibility.evaluate(event: event, state: state, catalog: c).eligible)
    }

    func testFullLifeReplayCandidatePermutationAndMidlifeResumeAreIdentical() throws {
        let c = try catalog(); var reversed = c; reversed.events.reverse()
        let first = try DirectedLifeSession.start(catalog: c, countryCode: "KEN", householdID: "ken-1", seed: 73)
        let completed = try finish(first, c)
        XCTAssertEqual(completed.traces.count, 15)
        XCTAssertEqual(completed.selections.count, 15)
        XCTAssertEqual(completed.state.age, 80)
        XCTAssertEqual(Set(try completed.traces.map { try LifeStage.at(age: $0.age) }), Set(LifeStage.allCases))
        XCTAssertEqual(completed, try finish(DirectedLifeSession.start(catalog: c, countryCode: "KEN", householdID: "ken-1", seed: 73), c))
        XCTAssertEqual(completed, try finish(DirectedLifeSession.start(catalog: reversed, countryCode: "KEN", householdID: "ken-1", seed: 73), reversed))
        var middle = first
        for _ in 0..<7 { try middle.choose("ask", catalog: c); try middle.continueLife(catalog: c) }
        let restored = try JSONDecoder().decode(DirectedLifeSession.self, from: JSONEncoder().encode(middle))
        try restored.validate(catalog: c)
        XCTAssertEqual(try finish(restored, c), completed)
    }

    func testVersionAndHistoryTamperingAreRejectedRatherThanRestarted() throws {
        let c = try catalog()
        var play = try DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: 42)
        try play.choose("ask", catalog: c)
        let original = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(play)) as? [String: Any])
        for mode in ["engine", "legacy-engine", "strip-director", "choice", "resource", "phase"] {
            var value = original; var state = value["state"] as! [String: Any]
            switch mode {
            case "engine": state["engineVersion"] = "unknown-engine"
            case "legacy-engine": state["engineVersion"] = LifeState.engineVersion
            case "strip-director": state.removeValue(forKey: "directorHistory")
            case "choice":
                var decisions = state["decisions"] as! [[String: Any]]; decisions[0]["choiceID"] = "invented-choice"; state["decisions"] = decisions
            case "resource":
                var resources = state["resources"] as! [String: Any]; resources["skills"] = 99; state["resources"] = resources
            default: value["phase"] = "ended"
            }
            value["state"] = state
            let corrupt = try JSONDecoder().decode(DirectedLifeSession.self, from: JSONSerialization.data(withJSONObject: value))
            XCTAssertThrowsError(try corrupt.validate(catalog: c), mode)
            XCTAssertThrowsError(try DirectedLifeSession.restore(JSONSerialization.data(withJSONObject: value), catalog: c), mode)
        }
        var wrongVersion = c; wrongVersion.version = "new-catalog-version"
        XCTAssertThrowsError(try play.validate(catalog: wrongVersion))
    }

    func testUnavailableChoiceDoesNotApplyFactsAndPreviewDoesNotMutateSession() throws {
        var c = try catalog()
        let library = c.events.firstIndex { $0.id == "rng-child-tool-library" }!
        let join = c.events[library].decision.choices.firstIndex { $0.id == "join" }!
        c.events[library].decision.choices[join].timeCost = 8
        let seed = try XCTUnwrap((UInt64(0)..<256).first {
            try DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-2", seed: $0).event(catalog: c).id == "rng-child-tool-library"
        })
        var play = try DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-2", seed: seed)
        let before = play
        XCTAssertFalse(try play.preview(choiceID: "join", catalog: c).applied)
        XCTAssertEqual(play, before)
        XCTAssertThrowsError(try play.choose("join", catalog: c))
        XCTAssertEqual(play, before)
        XCTAssertTrue(play.state.directorHistory!.relationships.isEmpty)
        try play.choose("ask", catalog: c)
        XCTAssertEqual(play.state.directorHistory!.relationships.count, 1)
        XCTAssertEqual(play.state.directorHistory!.relationships[0].originChoiceID, "ask")
    }

    func testLowResourceAndZeroMaterialsStillHaveSupportAndCompleteLife() throws {
        var c = try catalog()
        for index in c.model.households.indices {
            c.model.households[index].initialResources = .zero
            c.model.households[index].materialBudget = 0
        }
        for code in ["JPN", "USA", "IND", "KEN"] {
            for family in 1...2 {
                var play = try DirectedLifeSession.start(catalog: c, countryCode: code, householdID: "\(code.lowercased())-\(family)", seed: 3)
                while play.phase != .ended {
                    XCTAssertTrue(try play.preview(choiceID: "ask", catalog: c).applied)
                    XCTAssertTrue(try play.preview(choiceID: "rest", catalog: c).applied)
                    try play.choose("ask", catalog: c); try play.continueLife(catalog: c)
                }
                XCTAssertEqual(play.traces.count, 15)
                XCTAssertEqual(play.state.age, 80)
                XCTAssertTrue(play.traces.allSatisfy { $0.finalCost.materials == 0 })
            }
        }
    }
    func testEarlierChoiceUnlocksLaterActionWithRealProvenanceAndSameSeed() throws {
        let c = try catalog()
        var verified = false
        for seed: UInt64 in 0..<32 {
            var connected = try DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: seed)
            var unconnected = connected
            while connected.phase != .ended {
                let event = try connected.event(catalog: c)
                XCTAssertEqual(event.id, try unconnected.event(catalog: c).id)
                if event.id == "rng-legacy-workshop",
                   connected.state.directorHistory!.relationships.contains(where: { $0.factID == "connection" }) {
                    XCTAssertTrue(connected.state.resources.skills >= 28)
                    XCTAssertTrue(unconnected.state.resources.skills >= 28)
                    XCTAssertTrue(event.choices.contains { $0.id == "host" })
                    XCTAssertFalse(try unconnected.event(catalog: c).choices.contains { $0.id == "host" })
                    let rejected = try unconnected.preview(choiceID: "host", catalog: c)
                    XCTAssertFalse(rejected.applied)
                    let before = unconnected
                    XCTAssertThrowsError(try unconnected.choose("host", catalog: c))
                    XCTAssertEqual(unconnected, before)
                    let fact = connected.state.directorHistory!.relationships[0]
                    XCTAssertEqual(fact.originChoiceID, "ask")
                    XCTAssertEqual(fact.assumptionID, "rng-scheduling-demo")
                    XCTAssertTrue(connected.traces.contains { $0.occurrenceID == fact.originOccurrenceID && $0.eventID == "rng-child-tool-library" })
                    try connected.choose("host", catalog: c)
                    XCTAssertTrue(connected.traces.last!.choiceEligibility!.allSatisfy(\.met))
                    XCTAssertEqual(connected.traces.last!.choiceEligibility!.first { $0.ruleID.contains("relationship") }?.originOccurrenceIDs, [fact.originOccurrenceID])
                    XCTAssertEqual(connected.traces.last!.choiceID, "host")
                    verified = true; break
                }
                try connected.choose("ask", catalog: c)
                try unconnected.choose(event.id == "rng-child-tool-library" ? "rest" : "ask", catalog: c)
                try connected.continueLife(catalog: c); try unconnected.continueLife(catalog: c)
            }
            if verified { break }
        }
        XCTAssertTrue(verified, "At least one complete legal route must reach the relation-gated action")
    }

    func testRepeatedEventKeepsDistinctOccurrencesRandomKeysAndDelayedHooks() throws {
        let c = try catalog(); var verified = false
        for seed: UInt64 in 0..<64 {
            let run = try finish(DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-2", seed: seed), c,
                                 choices: ["rng-community-practice": "practice"])
            let repeats = run.traces.filter { $0.eventID == "rng-community-practice" }
            if repeats.count >= 2 {
                XCTAssertEqual(Set(repeats.compactMap(\.occurrenceID)).count, repeats.count)
                XCTAssertEqual(Set(repeats.compactMap { $0.randomTrial?.key }).count, repeats.count)
                let hooks = repeats.flatMap(\.scheduledHooks)
                XCTAssertEqual(hooks.count, repeats.count)
                XCTAssertEqual(Set(hooks.map(\.id)).count, hooks.count)
                XCTAssertTrue(hooks.allSatisfy { hook in run.state.memories.contains { $0.id == hook.id } })
                let history = run.state.directorHistory!.occurrences.filter { $0.eventID == "rng-community-practice" }
                XCTAssertEqual(history.map(\.ordinal), Array(1...history.count))
                for pair in zip(history, history.dropFirst()) { XCTAssertGreaterThanOrEqual(pair.1.age - pair.0.age, 10) }
                try run.validate(catalog: c)
                verified = true; break
            }
        }
        XCTAssertTrue(verified)
    }

    func testComparisonKeepsSelectedEventAndLabelsIneligibleBackground() throws {
        var c = try catalog()
        let library = c.events.firstIndex { $0.id == "rng-child-tool-library" }!
        c.events[library].conditions.append(.indicator(code: "IT.NET.USER.ZS", minimum: 90, maximum: 100))
        let seed = try XCTUnwrap((UInt64(0)..<32).first {
            try DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: $0).event(catalog: c).id == "rng-child-tool-library"
        })
        let run = try DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: seed)
        let comparisons = try run.compare(choiceID: "join", countryCodes: ["USA", "KEN", "TWN"], catalog: c)
        XCTAssertTrue(comparisons[0].comparable)
        XCTAssertEqual(comparisons[0].trace?.eventID, "rng-child-tool-library")
        XCTAssertEqual(comparisons[0].trace?.choiceID, "join")
        XCTAssertEqual(comparisons[0].trace?.seed, seed)
        XCTAssertEqual(comparisons[0].trace?.resourcesBefore, run.state.resources)
        XCTAssertFalse(comparisons[1].comparable)
        XCTAssertNil(comparisons[1].trace)
        XCTAssertFalse(comparisons[1].reasons.isEmpty)
        XCTAssertFalse(comparisons[2].comparable)
        XCTAssertNil(comparisons[2].trace)
        XCTAssertTrue(run.traces.isEmpty)
    }

    func testUnknownRelationshipIsNotEvidenceOfExplicitAbsence() throws {
        let c = try catalog(); var state = try advance(born(c), to: 52, c)
        var event = try c.event("rng-mutual-support")
        event.conditions = [.relationship(personID: "tool-library", factID: "connection", present: false)]
        let unknown = try EventEligibility.evaluate(event: event, state: state, catalog: c)
        XCTAssertFalse(unknown.eligible)
        XCTAssertEqual(unknown.checks.last?.observed, "unknown")
        state.directorHistory!.relationships = [.init(personID: "tool-library", factID: "connection", present: false,
            originOccurrenceID: "boundary-fixture", originChoiceID: "rest", assumptionID: "rng-scheduling-demo")]
        XCTAssertTrue(try EventEligibility.evaluate(event: event, state: state, catalog: c).eligible)
    }

    func testDirectedSelectionDoesNotShiftExistingOutcomeRandomKeyOrDraw() throws {
        var c = try catalog()
        c.events.removeAll { DirectedDemo.newEventIDs.contains($0.id) }
        for seed: UInt64 in [0, 1, 42, .max] {
            let legacy = try LifeSession.start(catalog: c.model, countryCode: "USA", householdID: "usa-1", seed: seed)
            let directed = try DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: seed)
            XCTAssertEqual(try legacy.event(catalog: c.model).id, try directed.event(catalog: c).id)
            let original = try legacy.preview(choiceID: "invest", catalog: c.model)
            let addedDirector = try directed.preview(choiceID: "invest", catalog: c)
            XCTAssertNotNil(original.randomTrial)
            XCTAssertEqual(addedDirector.randomTrial, original.randomTrial)
            XCTAssertEqual(addedDirector.resourcesAfter, original.resourcesAfter)
        }
    }

    func testForgedChoosingAfterFinalSlotThrowsInsteadOfIndexingPastSchedule() throws {
        let c = try catalog()
        let completed = try finish(DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: 1), c)
        var value = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(completed)) as? [String: Any])
        var selections = value["selections"] as! [[String: Any]]
        var jumps = value["jumps"] as! [[String: Any]]
        let last = try XCTUnwrap(selections.last)
        value["phase"] = "choosing"
        selections.append(last); jumps.append(jumps.last!)
        value["selections"] = selections; value["jumps"] = jumps
        value["currentOffer"] = ["occurrence": last["occurrence"]!, "trace": last]
        let data = try JSONSerialization.data(withJSONObject: value)
        XCTAssertThrowsError(try DirectedLifeSession.restore(data, catalog: c))
        let forged = try JSONDecoder().decode(DirectedLifeSession.self, from: data)
        XCTAssertThrowsError(try forged.event(catalog: c))
    }

    func testExtremeHistoryAgesAreRejectedBeforeCooldownArithmetic() throws {
        let c = try catalog()
        let completed = try finish(DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: 1), c)
        let original = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(completed)) as? [String: Any])
        for age in [Int.min, Int.max] {
            for surface in ["occurrence", "decision"] {
                var value = original; var state = value["state"] as! [String: Any]
                if surface == "occurrence" {
                    var history = state["directorHistory"] as! [String: Any]
                    var occurrences = history["occurrences"] as! [[String: Any]]
                    occurrences[occurrences.count - 1]["age"] = age
                    history["occurrences"] = occurrences; state["directorHistory"] = history
                } else {
                    var decisions = state["decisions"] as! [[String: Any]]
                    decisions[decisions.count - 1]["age"] = age; state["decisions"] = decisions
                }
                value["state"] = state
                XCTAssertThrowsError(try DirectedLifeSession.restore(JSONSerialization.data(withJSONObject: value), catalog: c), "\(surface), \(age)")
            }
        }
    }

    func testCatalogRejectsMissingOrUnaffordableOrAgeUnsafeSupport() throws {
        let c = try catalog()
        let mutations: [(inout EventCatalog) -> Void] = [
            { $0.events[0].decision.choices.removeAll { $0.kind == .askSupport } },
            { let i = $0.events[0].decision.choices.firstIndex { $0.kind == .askSupport }!; $0.events[0].decision.choices[i].materialCost = 1 },
            { let i = $0.events[0].decision.choices.firstIndex { $0.kind == .askSupport }!; $0.events[0].decision.choices[i].minimumAge = 9 },
            { let i = $0.events[0].decision.choices.firstIndex { $0.kind == .askSupport }!; $0.events[0].decision.choices[i].control = .adultResponsibility },
            { let i = $0.events[0].decision.choices.firstIndex { $0.kind == .askSupport }!; $0.events[0].decision.choices[i].timeCost = 8 },
            { let i = $0.events[0].decision.choices.firstIndex { $0.kind == .askSupport }!; $0.events[0].decision.choices[i].energyCost = 8 },
            { let i = $0.events[0].decision.choices.firstIndex { $0.kind == .askSupport }!; $0.events[0].decision.choices[i].requiresDigitalAccess = true }
        ]
        for (index, mutate) in mutations.enumerated() {
            var unsafe = c; mutate(&unsafe)
            XCTAssertThrowsError(try unsafe.validate(), "unsafe support fixture \(index)")
        }
    }

    func testDelayedCallbackKeepsProjectedPersonAndSurvivesRestore() throws {
        var c = try catalog()
        c.events.removeAll { DirectedDemo.newEventIDs.contains($0.id) }
        let index = c.events.firstIndex { $0.id == "later-reconnect" }!
        let ask = c.events[index].decision.choices.firstIndex { $0.id == "ask" }!
        c.events[index].decision.choices[ask].delayedHook = "qa-followup"
        try c.validate()
        let completed = try finish(DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: 42), c)
        let reunion = try XCTUnwrap(completed.traces.first { $0.eventID == "later-reconnect" })
        XCTAssertEqual(reunion.recurringPerson, "阿禾")
        XCTAssertEqual(reunion.scheduledHooks.count, 1)
        XCTAssertEqual(reunion.scheduledHooks[0].person, "阿禾")
        XCTAssertEqual(reunion.scheduledHooks[0].dueAge, 76)
        XCTAssertTrue(completed.state.memories.contains { $0 == reunion.scheduledHooks[0] })
        let restored = try DirectedLifeSession.restore(JSONEncoder().encode(completed), catalog: c)
        XCTAssertEqual(restored, completed)
    }

    func testTerminalAgeCannotSchedulePastFutureButNinetyNineCanReachOneHundred() throws {
        var c = try catalog()
        c.events.removeAll { DirectedDemo.newEventIDs.contains($0.id) }
        let lastSlot = c.slots.count - 1
        let lastEvent = c.events.firstIndex { $0.id == "later-review" }!
        let ask = c.events[lastEvent].decision.choices.firstIndex { $0.id == "ask" }!
        c.slots[lastSlot].age = 100
        c.events[lastEvent].minimumAge = 100; c.events[lastEvent].maximumAge = 100
        c.events[lastEvent].decision.choices[ask].delayedHook = "qa-final-hook"
        XCTAssertThrowsError(try c.validate())
        c.slots[lastSlot].age = 99
        c.events[lastEvent].minimumAge = 99; c.events[lastEvent].maximumAge = 99
        try c.validate()
        let completed = try finish(DirectedLifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: 42), c)
        XCTAssertEqual(completed.state.age, 99)
        let hook = try XCTUnwrap(completed.traces.last?.scheduledHooks.first)
        XCTAssertEqual(hook.dueAge, 100)
        XCTAssertTrue(completed.state.pendingHooks.contains(hook))
        let (hundred, jump) = try SimulationEngine.advance(completed.state, to: 100, catalog: c.model, directedCatalog: c)
        XCTAssertTrue(jump.triggeredHooks.contains(hook))
        XCTAssertTrue(hundred.memories.contains(hook))
        XCTAssertFalse(hundred.pendingHooks.contains(hook))
    }

    func testStoryGatedChoicesCannotBeTheOnlyGuaranteedRecoveryRoute() throws {
        // Independent contract: recovery survives the actual story projection, not just definition loading.
        let original = try catalog()
        XCTAssertNoThrow(try original.validate())
        for (eventID, gatedID) in [("teen-direction", "leadWorkshop"), ("middle-support", "shareShift")] {
            for recoveryKind in [ChoiceKind.askSupport, .rest] {
                var invalid = original
                let index = try XCTUnwrap(invalid.events.firstIndex { $0.id == eventID })
                invalid.events[index].decision.choices.removeAll { $0.kind == recoveryKind }
                let choiceIndex = try XCTUnwrap(invalid.events[index].decision.choices.firstIndex { $0.id == gatedID })
                invalid.events[index].decision.choices[choiceIndex].kind = recoveryKind
                invalid.events[index].decision.choices[choiceIndex].control = .personal
                invalid.events[index].decision.choices[choiceIndex].minimumAge = 0
                invalid.events[index].decision.choices[choiceIndex].timeCost = 0
                invalid.events[index].decision.choices[choiceIndex].energyCost = 0
                invalid.events[index].decision.choices[choiceIndex].materialCost = 0
                invalid.events[index].decision.choices[choiceIndex].requiresDigitalAccess = false
                XCTAssertThrowsError(try invalid.validate(), "\(eventID)/\(gatedID) cannot guarantee \(recoveryKind)")
            }
        }
    }

}
