import XCTest
import LifeDomain
import LifeData

final class LifeExperienceTests: XCTestCase {
    func testFocusDoesNotRerollRevealedEventOrApplyBeforeTimeAdvances() throws {
        let c = try StatisticsRepository.bundled()
        var s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        let before = s.state, event = try s.event(catalog: c), selection = s.currentSelection
        for _ in 0..<20 { try s.chooseFocus(.recovery, catalog: c); try s.chooseFocus(.learning, catalog: c) }
        XCTAssertEqual(s.state, before)
        XCTAssertEqual(try s.event(catalog: c), event)
        XCTAssertEqual(s.currentSelection, selection)
        XCTAssertEqual(s.focusSelections.count, 1, "Repeated direction changes replace the pending allocation, not farm it")
        XCTAssertThrowsError(try s.chooseFocus(.stability, catalog: c))
        XCTAssertFalse(LifeFocus.available(at: 22).contains(.stability))
        XCTAssertTrue(LifeFocus.available(at: 23).contains(.stability))
        var control = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        try control.choose("rest", catalog: c); try control.continueLife(catalog: c)
        try s.choose("rest", catalog: c); try s.continueLife(catalog: c)
        XCTAssertEqual(s.state.resources.skills, control.state.resources.skills)
        XCTAssertEqual(s.jumps.last?.focusEffect?.requested, .zero)
        XCTAssertEqual(s.jumps.last?.focusEffect?.actual, .zero)
        try s.validate(catalog: c)
    }

    func testFocusCreatesReadinessWithoutHiddenPointsAcrossShortAndLongIntervals() throws {
        let c = try StatisticsRepository.bundled()
        var state = try LifeState.born(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 3)
        state.age = 23; state.resources.skills = 100
        let (capped, receipt) = try SimulationEngine.advance(state, to: 40, catalog: c, focus: .learning)
        XCTAssertEqual(capped.resources.skills, 100)
        XCTAssertEqual(receipt.focusEffect?.actual, .zero)
        XCTAssertEqual(receipt.focusEffect?.requested, .zero)
        state.resources.skills = 40
        let (long, _) = try SimulationEngine.advance(state, to: 60, catalog: c, focus: .learning)
        let (short, _) = try SimulationEngine.advance(state, to: 24, catalog: c, focus: .learning)
        XCTAssertEqual(long.resources.skills, 40)
        XCTAssertEqual(short.resources.skills, 40)
        XCTAssertEqual(long.focusHistory.last?.focus, .learning)
        XCTAssertEqual(short.focusHistory.last?.toAge, 24)
    }

    func testReplayRejectsUnknownVersionsDuplicateAndFutureFocusRecords() throws {
        let c = try StatisticsRepository.bundled()
        var s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        try s.chooseFocus(.learning, catalog: c)
        let data = try JSONEncoder().encode(s)
        for kind in ["version", "duplicate", "future", "ended"] {
            var object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
            var records = try XCTUnwrap(object["focusLog"] as? [[String: Any]])
            switch kind {
            case "version": records[0]["version"] = "unknown"
            case "duplicate": records.append(records[0])
            case "future": records[0]["decisionIndex"] = 9
            default: records[0]["phase"] = "ended"
            }
            object["focusLog"] = records
            XCTAssertThrowsError(try LifeSession.restore(from: JSONSerialization.data(withJSONObject: object), catalog: c), kind)
        }
    }

    func testCompleteFocusReplayBranchAndPreservedOriginal() throws {
        let c = try legacyStoryFixture()
        var s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 7)
        while s.phase != .ended {
            if s.canChooseFocus { try s.chooseFocus(.learning, catalog: c) }
            try s.choose("rest", catalog: c); try s.continueLife(catalog: c)
        }
        XCTAssertThrowsError(try s.chooseFocus(.recovery, catalog: c))
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        let bytes = try encoder.encode(s)
        var second = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 7)
        while second.phase != .ended {
            if second.canChooseFocus { try second.chooseFocus(.learning, catalog: c) }
            try second.choose("rest", catalog: c); try second.continueLife(catalog: c)
        }
        XCTAssertEqual(try encoder.encode(second), bytes, "Same Seed, focus and actions must reproduce the entire life")
        XCTAssertEqual(try LifeSession.restore(from: bytes, catalog: c), s)
        var branch = try BranchExperiment.start(original: s, decisionIndex: 3, choiceID: "invest", catalog: c)
        XCTAssertEqual(branch.snapshot.session.activeFocus, .learning)
        try branch.chooseFocus(.recovery, catalog: c)
        try branch.continueLife(catalog: c)
        while branch.alternative.phase != .ended {
            try branch.choose("rest", catalog: c); try branch.continueLife(catalog: c)
        }
        try branch.validate(catalog: c)
        XCTAssertEqual(branch.original, s)
        XCTAssertEqual(try encoder.encode(branch.original), bytes)
        let restored = try JSONDecoder().decode(BranchExperiment.self, from: encoder.encode(branch))
        try restored.validate(catalog: c)
        XCTAssertEqual(restored, branch)
        XCTAssertEqual(branch.alternative.traces.prefix(3), s.traces.prefix(3))
        XCTAssertEqual(branch.alternative.jumps.prefix(4), s.jumps.prefix(4))
        let report = try BranchComparisonEngine.compare(branch, catalog: c)
        XCTAssertEqual(report.rows.count, 12)
        XCTAssertGreaterThan(report.differentFocusIntervals, 0)
    }

    func testContextualNarrativeUsesActualHistoryIncludingSeekingAndRecovery() throws {
        let c = try legacyStoryFixture()
        var texts: [String] = []
        for choice in ["invest", "offline", "ask", "rest"] {
            var s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
            for _ in 0..<3 { try s.choose("rest", catalog: c); try s.continueLife(catalog: c) }
            let before = s
            let teen = LifeNarrative.text(event: try s.event(catalog: c), state: s.state)
            XCTAssertTrue(teen.contains("課後的時間"))
            XCTAssertEqual(s, before, "Reading prose must have no simulation effects")
            try s.choose(choice, catalog: c); try s.continueLife(catalog: c)
            let text = LifeNarrative.text(event: try s.event(catalog: c), state: s.state)
            texts.append(text)
            let required = ["invest": "13歲留下的線上", "offline": "13歲留下的紙本", "ask": "先說出需要", "rest": "把時間留給自己"]
            XCTAssertTrue(text.contains(required[choice]!))
            if choice == "ask" { XCTAssertTrue(text.contains("沒有保證")) }
        }
        XCTAssertEqual(Set(texts).count, 4)
    }

    func test1024LivesAcrossEightCountriesFamiliesSeedsAndFocusPoliciesHaveNoDeadEnds() throws {
        let c = try StatisticsRepository.bundled()
        var count = 0
        for household in c.households {
            for seed in 0..<64 {
                var s = try LifeSession.start(catalog: c, countryCode: household.countryCode, householdID: household.id, seed: UInt64(seed))
                while s.phase != .ended {
                    if s.canChooseFocus {
                        let options = LifeFocus.available(at: s.state.age)
                        try s.chooseFocus(options[(seed + s.traces.count) % options.count], catalog: c)
                    }
                    let choices = try s.event(catalog: c).choices.filter { (try? s.preview(choiceID: $0.id, catalog: c).applied) == true }
                    XCTAssertFalse(choices.isEmpty)
                    try s.choose(choices[(seed + s.traces.count) % choices.count].id, catalog: c)
                    try s.continueLife(catalog: c)
                    try s.state.resources.validate(in: 0...100)
                }
                if seed % 16 == 0 {
                    XCTAssertEqual(try LifeSession.restore(from: JSONEncoder().encode(s), catalog: c), s)
                }
                count += 1
            }
        }
        XCTAssertEqual(count, 1024)
    }
}
