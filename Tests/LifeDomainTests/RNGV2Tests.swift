import XCTest
import LifeData
@testable import LifeDomain

final class RNGV2Tests: XCTestCase {
    private func state(_ age: Int, catalog: ModelCatalog, seed: UInt64 = 7) throws -> LifeState {
        let born = try LifeState.born(catalog: catalog, countryCode: "USA", householdID: "usa-2", seed: seed)
        return try SimulationEngine.advance(born, to: age, catalog: catalog).0
    }
    /// A controlled domain fixture: find a Seed that actually selects this eligible event.
    /// No forced-event resolver or bypass of production eligibility is used.
    private func encounter(_ id: String, state original: LifeState, catalog: ModelCatalog) throws -> LifeState {
        for seed: UInt64 in 0..<512 {
            var current = original; current.seed = seed
            if try EventSelector.select(state: current, catalog: catalog).selectedEventID == id { return current }
        }
        throw ModelError.unavailable("fixture event never eligible: \(id)")
    }
    func testCandidateKeysSurviveReorderingAndAdditionAndRemainPairedAcrossCountries() throws {
        let c = try StatisticsRepository.bundled()
        let current = try state(25, catalog: c)
        let original = try EventSelector.select(state: current, catalog: c)
        var reordered = c; reordered.decisions.reverse()
        XCTAssertEqual(original, try EventSelector.select(state: current, catalog: reordered))
        var expanded = c
        var added = try XCTUnwrap(c.decisions.first { $0.id == "teen-tool-library" })
        added.id = "test-extra-opportunity"; expanded.decisions.append(added)
        let withExtra = try EventSelector.select(state: current, catalog: expanded)
        for old in original.candidates {
            XCTAssertEqual(old, withExtra.candidates.first { $0.eventID == old.eventID })
            XCTAssertGreaterThan(old.uniform, 0); XCTAssertLessThan(old.uniform, 1)
            XCTAssertTrue(old.finalWeight.isFinite && old.finalWeight > 0)
        }
        var elsewhere = current; elsewhere.countryCode = "KEN"; elsewhere.householdID = "ken-2"
        XCTAssertEqual(original, try EventSelector.select(state: elsewhere, catalog: c))
    }
    func testRaceUsesRecordedWeightsAndIndependentSamples() throws {
        let c = try StatisticsRepository.bundled()
        let current = try state(32, catalog: c)
        let trace = try EventSelector.select(state: current, catalog: c)
        for candidate in trace.candidates {
            XCTAssertEqual(candidate.finalWeight, candidate.weightSteps.reduce(candidate.baseWeight) { $0 * $1.multiplier }, accuracy: 1e-12)
            if candidate.eligible {
                // Specification: exponential clock at rate w has survival P(T>t)=exp(-w*t).
                let score = try XCTUnwrap(candidate.raceScore)
                XCTAssertEqual(exp(-candidate.finalWeight * score), candidate.uniform, accuracy: 1e-12)
            } else { XCTAssertNil(candidate.raceScore); XCTAssertFalse(candidate.exclusions.isEmpty) }
        }
        let winner = try XCTUnwrap(trace.candidates.first { $0.eventID == trace.selectedEventID })
        XCTAssertTrue(trace.candidates.compactMap(\.raceScore).allSatisfy { $0 >= winner.raceScore! })
        XCTAssertEqual(Set(trace.candidates.map(\.randomKey)).count, 40)
    }
    func testPolicyValidationRejectsNonfiniteZeroNegativeAndUnknownFields() throws {
        let c = try StatisticsRepository.bundled()
        for weight in [0.0, -1, Double.infinity, Double.nan] {
            var broken = c; broken.decisions[0].selection.baseWeight = weight
            XCTAssertThrowsError(try broken.validate())
        }
        var broken = c; broken.selectionRules.continuityMultiplier = .infinity
        XCTAssertThrowsError(try broken.validate())
        broken = c; broken.decisions[0].selection.relationshipID = "country.JPN"
        XCTAssertThrowsError(try broken.validate())
        broken = c; broken.decisions[0].choices[0].storyChanges = [.init(key: "nationality", value: "success", personID: "", relationshipDelta: 0)]
        XCTAssertThrowsError(try broken.validate())
        broken = c; broken.decisions[0].selection.maximumAge = 7
        XCTAssertThrowsError(try broken.validate())
    }
    func testOneShotCooldownAndMutualExclusionHaveObservableReasons() throws {
        let c = try StatisticsRepository.bundled()
        var current = try encounter("adult-shift-offer", state: state(25, catalog: c), catalog: c)
        current = try DecisionResolver.resolve(state: current, eventID: "adult-shift-offer", choiceID: "extraShift", catalog: c).state
        current = try SimulationEngine.advance(current, to: 32, catalog: c).0
        let selection = try EventSelector.select(state: current, catalog: c)
        XCTAssertTrue(try XCTUnwrap(selection.candidates.first { $0.eventID == "adult-shift-offer" }).exclusions.contains("one-shot"))
        XCTAssertTrue(try XCTUnwrap(selection.candidates.first { $0.eventID == "adult-neighbor-market" }).exclusions.contains("exclusive-group"))
        current = try encounter("middle-rest-circle", state: state(45, catalog: c), catalog: c)
        current = try DecisionResolver.resolve(state: current, eventID: "middle-rest-circle", choiceID: "rest", catalog: c).state
        for age in [52, 59] {
            current = try SimulationEngine.advance(current, to: age, catalog: c).0
            let next = try EventSelector.select(state: current, catalog: c)
            XCTAssertTrue(try XCTUnwrap(next.candidates.first { $0.eventID == "middle-rest-circle" }).exclusions.contains("cooldown"))
            current = try DecisionResolver.resolve(state: current, eventID: next.selectedEventID, choiceID: "rest", catalog: c).state
        }
        current = try SimulationEngine.advance(current, to: 65, catalog: c).0
        let ready = try EventSelector.select(state: current, catalog: c)
        XCTAssertTrue(try XCTUnwrap(ready.candidates.first { $0.eventID == "middle-rest-circle" }).eligible)
        current = try encounter("middle-rest-circle", state: current, catalog: c)
        let repeated = try DecisionResolver.resolve(state: current, eventID: "middle-rest-circle", choiceID: "boundaries", catalog: c)
        XCTAssertTrue(repeated.trace.applied)
        XCTAssertEqual(repeated.state.decisions.filter { $0.eventID == "middle-rest-circle" }.count, 2)
        try repeated.state.validate(catalog: c)
    }
    func testFourNewStoryLinesChangeOptionsAndPreserveSourceDecision() throws {
        let c = try StatisticsRepository.bundled()
        let routes = [("teen-tool-library", 17, "practice", "adult-repair-coop", 32, "repair"),
                      ("teen-shared-kitchen", 21, "invest", "adult-meal-circle", 32, "kitchen"),
                      ("middle-garden-table", 32, "invest", "middle-seed-exchange", 52, "garden"),
                      ("child-rain-notebook", 12, "observe", "teen-river-survey", 21, "nature")]
        for (origin, firstAge, choice, outcome, lastAge, flag) in routes {
            var initial = try state(firstAge, catalog: c)
            if origin == "teen-shared-kitchen" { initial.householdID = "usa-1"; initial.remainingMaterials = 2 }
            let start = try encounter(origin, state: initial, catalog: c)
            let learned = try DecisionResolver.resolve(state: start, eventID: origin, choiceID: choice, catalog: c)
            XCTAssertTrue(learned.trace.applied)
            XCTAssertEqual(learned.state.story.fact(flag)?.age, firstAge)
            XCTAssertEqual(learned.state.story.fact(flag)?.choiceID, choice)
            var later = try SimulationEngine.advance(learned.state, to: lastAge, catalog: c).0
            later.resources.skills = 30
            later = try encounter(outcome, state: later, catalog: c)
            let experienced = try DecisionResolver.resolve(state: later, eventID: outcome, choiceID: "lead", catalog: c)
            XCTAssertTrue(experienced.trace.applied)
            XCTAssertEqual(experienced.trace.storyBranch?.sourceEventID, origin)
            XCTAssertEqual(experienced.trace.storyBranch?.sourceAge, firstAge)
            XCTAssertTrue(experienced.trace.storyVariantID?.hasSuffix("-continuation") == true)
            var fresh = try state(lastAge, catalog: c); fresh.resources.skills = 100
            fresh = try encounter(outcome, state: fresh, catalog: c)
            let denied = try DecisionResolver.resolve(state: fresh, eventID: outcome, choiceID: "lead", catalog: c)
            XCTAssertFalse(denied.trace.applied) // Skills cannot manufacture the missing story.
            XCTAssertEqual(denied.state, fresh)
            let projected = StoryBranchEngine.project(event: try XCTUnwrap(c.decisions.first { $0.id == outcome }), state: fresh)
            XCTAssertTrue(projected.event.choices.contains { $0.id == "rest" })
            XCTAssertTrue(projected.event.choices.contains { $0.kind == .askSupport })
        }
    }
    func testHelpDoesNotEraseExperienceAndFactsCannotBeForged() throws {
        let c = try StatisticsRepository.bundled()
        var current = try encounter("teen-tool-library", state: state(17, catalog: c), catalog: c)
        current = try DecisionResolver.resolve(state: current, eventID: "teen-tool-library", choiceID: "practice", catalog: c).state
        let fact = try XCTUnwrap(current.story.fact("repair"))
        current = try SimulationEngine.advance(current, to: 32, catalog: c).0
        current = try encounter("adult-repair-coop", state: current, catalog: c)
        current = try DecisionResolver.resolve(state: current, eventID: "adult-repair-coop", choiceID: "seekGuide", catalog: c).state
        XCTAssertEqual(current.story.fact("repair"), fact)
        XCTAssertGreaterThan(current.story.relationships.first { $0.personID == "teacher" }!.interactions.count, 1)
        var forged = current; forged.story.flags.removeAll()
        XCTAssertThrowsError(try forged.validate(catalog: c))
        forged = current; forged.story.relationships[0].familiarity = 10
        XCTAssertThrowsError(try forged.validate(catalog: c))
        forged = current; forged.engineVersion = "lc02-4"
        XCTAssertThrowsError(try forged.validate(catalog: c))
    }
    func testDynamicWindowsExecuteAtActualAgeAndTraceContinuityWithoutCountryMultipliers() throws {
        let c = try StatisticsRepository.bundled()
        var current = try encounter("middle-friend-letter", state: state(45, catalog: c), catalog: c)
        let result = try DecisionResolver.resolve(state: current, eventID: "middle-friend-letter", choiceID: "write", catalog: c)
        XCTAssertTrue(result.trace.applied)
        XCTAssertEqual(result.trace.age, 45)
        current = try SimulationEngine.advance(result.state, to: 72, catalog: c).0
        let selection = try EventSelector.select(state: current, catalog: c)
        let reunion = try XCTUnwrap(selection.candidates.first { $0.eventID == "later-reconnect" })
        XCTAssertTrue(reunion.weightSteps.contains { $0.ruleID == "story-continuity" })
        let event = StoryBranchEngine.project(event: try XCTUnwrap(c.decisions.first { $0.id == "later-reconnect" }), state: current)
        XCTAssertEqual(event.event.recurringPerson, "阿禾")
        XCTAssertEqual(event.evaluation?.sourceEventID, "middle-friend-letter")
        XCTAssertEqual(event.evaluation?.sourceAge, 45)
    }
}
