import XCTest
import LifeDomain
import LifeData

final class BranchExperimentTests: XCTestCase {
    private func finish(_ input: LifeSession, catalog: ModelCatalog, prefer: String = "invest") throws -> LifeSession {
        var life = input
        while life.phase != .ended {
            if life.phase == .reflecting { try life.continueLife(catalog: catalog); continue }
            let event = try life.event(catalog: catalog)
            let choices = try event.choices.filter { try life.preview(choiceID: $0.id, catalog: catalog).applied }
            try life.choose(choices.first(where: { $0.id == prefer })?.id ?? XCTUnwrap(choices.first).id, catalog: catalog)
        }
        return life
    }
    private func original(_ catalog: ModelCatalog, seed: UInt64 = 0) throws -> LifeSession {
        try finish(.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: seed), catalog: catalog)
    }
    private func finish(_ input: BranchExperiment, catalog: ModelCatalog, prefer: String = "rest") throws -> BranchExperiment {
        var experiment = input
        while experiment.alternative.phase != .ended {
            if experiment.alternative.phase == .reflecting { try experiment.continueLife(catalog: catalog) }
            else {
                let choices = try experiment.alternative.event(catalog: catalog).choices
                let selected = try XCTUnwrap(choices.first(where: { $0.id == prefer }))
                try experiment.choose(selected.id, catalog: catalog)
            }
        }
        return experiment
    }
    private func altered<T: Codable>(_ value: T, _ mutate: (inout [String: Any]) -> Void) throws -> T {
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(value)) as? [String: Any])
        mutate(&object)
        return try JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: object))
    }

    func testAllCheckpointsPreserveExactPrefixAndOriginalIncludingFirstAndLast() throws {
        let catalog = try StatisticsRepository.bundled(), old = try original(catalog)
        let savedBytes = try JSONEncoder().encode(old)
        for index in 0..<15 {
            let before = try old.beforeDecision(at: index, catalog: catalog)
            XCTAssertEqual(before.phase, .choosing)
            XCTAssertEqual(before.state.decisions, Array(old.state.decisions.prefix(index)))
            XCTAssertEqual(before.traces, Array(old.traces.prefix(index)))
            XCTAssertEqual(before.jumps, Array(old.jumps.prefix(index + 1)))
            XCTAssertEqual(before.selectionTraces, Array(old.selectionTraces.prefix(index + 1)))
            let fork = try BranchExperiment.start(original: old, decisionIndex: index, choiceID: "rest", catalog: catalog)
            XCTAssertEqual(fork.original, old)
            XCTAssertEqual(fork.snapshot.session, before)
            XCTAssertEqual(fork.alternative.traces[index].resourcesBefore, old.traces[index].resourcesBefore)
            let completed = try finish(fork, catalog: catalog)
            let comparison = try BranchComparisonEngine.compare(completed, catalog: catalog)
            XCTAssertEqual(comparison.rows.count, 15 - index)
            XCTAssertEqual(comparison.rows.first?.decisionIndex, index)
            XCTAssertEqual(comparison.rows.last?.original.age, 80)
            XCTAssertEqual(completed.original, try JSONDecoder().decode(LifeSession.self, from: savedBytes))
            XCTAssertEqual(comparison.originalFinal, old.state.resources)
            XCTAssertEqual(comparison.alternativeFinal, completed.alternative.state.resources)
        }
    }

    func testSameSeedChoicesAndCodableAtEveryPhaseReproduceCompleteAlternative() throws {
        let catalog = try StatisticsRepository.bundled()
        for seed: UInt64 in [0, 1, 2, .max] {
            let old = try original(catalog, seed: seed)
            let fork = try BranchExperiment.start(original: old, decisionIndex: 3, choiceID: "offline", catalog: catalog)
            var live = fork, restored = try JSONDecoder().decode(BranchExperiment.self, from: JSONEncoder().encode(fork))
            while live.alternative.phase != .ended {
                XCTAssertEqual(live, restored)
                if live.alternative.phase == .reflecting {
                    try live.continueLife(catalog: catalog); try restored.continueLife(catalog: catalog)
                } else {
                    try live.choose("rest", catalog: catalog); try restored.choose("rest", catalog: catalog)
                }
                restored = try JSONDecoder().decode(BranchExperiment.self, from: JSONEncoder().encode(restored))
            }
            try restored.validate(catalog: catalog)
            XCTAssertEqual(live, restored)
            XCTAssertEqual(live, try finish(fork, catalog: catalog))
            XCTAssertEqual(try BranchComparisonEngine.compare(live, catalog: catalog),
                           try BranchComparisonEngine.compare(restored, catalog: catalog))
        }
    }

    func testReplayingUnchangedChoicesFromCheckpointExactlyReproducesOriginal() throws {
        let catalog = try StatisticsRepository.bundled(), old = try original(catalog, seed: 2)
        for index in [0, 3, 8, 14] {
            var replay = try old.beforeDecision(at: index, catalog: catalog)
            for trace in old.traces.dropFirst(index) {
                try replay.choose(trace.choiceID, catalog: catalog)
                try replay.continueLife(catalog: catalog)
            }
            XCTAssertEqual(replay, old)
        }
    }

    func testChangedChoiceRebuildsFutureHooksAndPreservesEarlierPendingHooksExactlyOnce() throws {
        // Fixture: an 8-year action schedules a 12-year callback, and the 10-year action a 14-year callback.
        // The fork must retain the former and omit the latter; production currently schedules hooks later in life.
        var catalog = try StatisticsRepository.bundled()
        for id in ["child-interest", "child-friend"] {
            let event = try XCTUnwrap(catalog.decisions.firstIndex { $0.id == id })
            let choice = try XCTUnwrap(catalog.decisions[event].choices.firstIndex { $0.id == "invest" })
            catalog.decisions[event].choices[choice].delayedHook = "reconnect"
        }
        let old = try original(catalog)
        let fork = try BranchExperiment.start(original: old, decisionIndex: 1, choiceID: "rest", catalog: catalog)
        let before = fork.snapshot.session
        XCTAssertFalse(before.state.pendingHooks.isEmpty)
        XCTAssertEqual(fork.alternative.state.pendingHooks, before.state.pendingHooks)
        XCTAssertFalse(old.traces[1].scheduledHooks.isEmpty)
        let complete = try finish(fork, catalog: catalog)
        let allTriggered = complete.alternative.jumps.flatMap(\.triggeredHooks)
        for hook in before.state.pendingHooks { XCTAssertEqual(allTriggered.filter { $0.id == hook.id }.count, 1) }
        for cancelled in old.traces.dropFirst().flatMap(\.scheduledHooks) {
            XCTAssertFalse(allTriggered.contains(where: { $0.id == cancelled.id }))
        }
        XCTAssertEqual(Set(allTriggered.map(\.id)).count, allTriggered.count)
        XCTAssertTrue(complete.alternative.state.pendingHooks.isEmpty)
        XCTAssertEqual(complete.alternative.state.story.fact("friendship")?.value, "paused")
    }

    func testPairedCandidateDrawsRemainEqualEvenWhenWeightsOrEligibilityChange() throws {
        let catalog = try StatisticsRepository.bundled(), old = try original(catalog)
        let fork = try finish(BranchExperiment.start(original: old, decisionIndex: 3, choiceID: "offline", catalog: catalog), catalog: catalog)
        XCTAssertNotNil(old.traces[3].randomTrial)
        XCTAssertEqual(old.traces[3].randomTrial?.key, fork.alternative.traces[3].randomTrial?.key)
        XCTAssertEqual(old.traces[3].randomTrial?.draw, fork.alternative.traces[3].randomTrial?.draw)
        var checked = 0
        for (a, b) in zip(old.selectionTraces, fork.alternative.selectionTraces) {
            for candidate in a.candidates {
                if let other = b.candidates.first(where: { $0.eventID == candidate.eventID }) {
                    XCTAssertEqual(candidate.randomKey, other.randomKey)
                    XCTAssertEqual(candidate.uniform, other.uniform); checked += 1
                }
            }
        }
        XCTAssertGreaterThan(checked, 15)
        XCTAssertNotEqual(old.state.story, fork.alternative.state.story)
        let report = try BranchComparisonEngine.compare(fork, catalog: catalog)
        XCTAssertGreaterThan(report.laterDifferentActions, 0)
        XCTAssertTrue(report.scopeExplanation.contains("每一步由你親自選擇"))
        XCTAssertTrue(report.scopeExplanation.contains("不能把所有差異只歸因"))
    }

    func testSingleChangedChoiceActuallyChangesLaterPersonAndLearningRoute() throws {
        let catalog = try legacyStoryFixture(), old = try original(catalog)
        for (index, choice, laterIndex, variant) in [(1, "rest", 13, "later-reconnect-new-neighbor"),
                                                     (3, "offline", 4, "teen-direction-paper")] {
            var fork = try BranchExperiment.start(original: old, decisionIndex: index, choiceID: choice, catalog: catalog)
            while fork.alternative.phase != .ended {
                if fork.alternative.phase == .reflecting { try fork.continueLife(catalog: catalog) }
                else { try fork.choose(old.traces[fork.alternative.traces.count].choiceID, catalog: catalog) }
            }
            XCTAssertEqual(fork.alternative.traces[laterIndex].storyVariantID, variant)
            XCTAssertNotEqual(fork.alternative.traces[laterIndex].storyVariantID, old.traces[laterIndex].storyVariantID)
            let comparison = try BranchComparisonEngine.compare(fork, catalog: catalog)
            XCTAssertEqual(comparison.laterDifferentActions, 0)
            XCTAssertTrue(comparison.rows.first(where: { $0.decisionIndex == laterIndex })!.storyChanged)
        }
    }

    func testInvalidForkAndPhaseFailuresDoNotMutateOriginalOrAlternative() throws {
        let catalog = try StatisticsRepository.bundled(), old = try original(catalog)
        for index in [-1, 15, Int.max] {
            XCTAssertThrowsError(try old.beforeDecision(at: index, catalog: catalog))
            XCTAssertThrowsError(try BranchExperiment.start(original: old, decisionIndex: index, choiceID: "rest", catalog: catalog))
        }
        XCTAssertThrowsError(try BranchExperiment.start(original: old, decisionIndex: 0, choiceID: old.traces[0].choiceID, catalog: catalog))
        XCTAssertThrowsError(try BranchExperiment.start(original: old, decisionIndex: 0, choiceID: "invented", catalog: catalog))
        XCTAssertThrowsError(try BranchExperiment.start(original: old.beforeDecision(at: 0, catalog: catalog), decisionIndex: 0, choiceID: "rest", catalog: catalog))
        var fork = try BranchExperiment.start(original: old, decisionIndex: 3, choiceID: "offline", catalog: catalog)
        let before = fork
        XCTAssertThrowsError(try fork.choose("rest", catalog: catalog))
        XCTAssertThrowsError(try BranchComparisonEngine.compare(fork, catalog: catalog))
        XCTAssertEqual(fork, before)
        try fork.continueLife(catalog: catalog)
        let choosing = fork
        XCTAssertThrowsError(try fork.continueLife(catalog: catalog))
        XCTAssertThrowsError(try fork.choose("nonexistent", catalog: catalog))
        XCTAssertEqual(fork, choosing)
    }

    func testUnaffordableAlternateRejectedUsingItsOriginalPreChoiceBudget() throws {
        var catalog = try StatisticsRepository.bundled()
        catalog.decisions[0].choices[0].timeCost = 8
        let old = try finish(.start(catalog: catalog, countryCode: "KEN", householdID: "ken-2", seed: 0), catalog: catalog, prefer: "rest")
        XCTAssertThrowsError(try BranchExperiment.start(original: old, decisionIndex: 0, choiceID: "invest", catalog: catalog))
        XCTAssertEqual(old.traces[0].choiceID, "rest")
    }

    func testDecodedForgedMetadataSnapshotsAndAlternativeCannotResumeOrCompare() throws {
        let catalog = try StatisticsRepository.bundled(), old = try original(catalog)
        let fork = try BranchExperiment.start(original: old, decisionIndex: 3, choiceID: "offline", catalog: catalog)
        let mutations: [(inout [String: Any]) -> Void] = [
            { $0["version"] = "future-version" },
            { $0["changedChoiceID"] = "rest" },
            { var snapshot = $0["snapshot"] as! [String: Any]; snapshot["decisionIndex"] = -1; $0["snapshot"] = snapshot },
            { var snapshot = $0["snapshot"] as! [String: Any]; snapshot["randomVersion"] = "other"; $0["snapshot"] = snapshot },
            { var snapshot = $0["snapshot"] as! [String: Any]; snapshot["session"] = $0["alternative"]; $0["snapshot"] = snapshot },
            { $0["alternative"] = $0["original"] }
        ]
        for mutation in mutations {
            var bad = try altered(fork, mutation)
            let unchanged = bad
            XCTAssertThrowsError(try bad.validate(catalog: catalog))
            XCTAssertThrowsError(try bad.continueLife(catalog: catalog))
            XCTAssertThrowsError(try BranchComparisonEngine.compare(bad, catalog: catalog))
            XCTAssertEqual(bad, unchanged)
        }
    }

    func testIndividuallyValidAlternativeFromDifferentSeedOrBackgroundIsRejected() throws {
        let catalog = try StatisticsRepository.bundled(), old = try original(catalog)
        let fork = try BranchExperiment.start(original: old, decisionIndex: 0, choiceID: "rest", catalog: catalog)
        for (country, household, seed) in [("JPN", "jpn-1", UInt64(1)), ("USA", "usa-1", UInt64(0)), ("JPN", "jpn-2", UInt64(0))] {
            var other = try LifeSession.start(catalog: catalog, countryCode: country, householdID: household, seed: seed)
            try other.choose("rest", catalog: catalog)
            try other.validate(catalog: catalog)
            let replacement = try JSONSerialization.jsonObject(with: JSONEncoder().encode(other))
            let forged = try altered(fork) { $0["alternative"] = replacement }
            XCTAssertThrowsError(try forged.validate(catalog: catalog))
        }
    }

    func testFourCountryTwoFamilyBranchMatrixCompletesAndKeepsOriginal() throws {
        let catalog = try StatisticsRepository.bundled()
        for country in ["JPN", "USA", "IND", "KEN"] {
            for family in 1...2 {
                for seed: UInt64 in [0, 1, 2, 42] {
                    let old = try finish(.start(catalog: catalog, countryCode: country, householdID: "\(country.lowercased())-\(family)", seed: seed), catalog: catalog)
                    let fork = try finish(BranchExperiment.start(original: old, decisionIndex: 3, choiceID: "rest", catalog: catalog), catalog: catalog)
                    XCTAssertEqual(fork.original, old)
                    XCTAssertEqual(fork.alternative.traces.count, 15)
                    try fork.validate(catalog: catalog)
                }
            }
        }
    }
}
