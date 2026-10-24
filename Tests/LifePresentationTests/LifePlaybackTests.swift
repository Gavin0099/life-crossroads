import XCTest
import Foundation
import LifeDomain
import LifeData
import LifePresentation
import LifePersistence

final class LifePlaybackTests: XCTestCase {
    func testPauseSpeedAndSkipOnlyChangeChoreographyAndArriveOnce() throws {
        var flow = LifePlayback()
        try flow.travel(from: 8, to: 10)
        for _ in 0..<8 { flow.pulse() }
        XCTAssertEqual(flow.progress, 0.25)
        flow.pause()
        flow.setSpeed(.fast)
        let paused = flow
        for _ in 0..<50 { flow.pulse() }
        XCTAssertEqual(flow, paused, "No offline catch-up or speed-induced resume")
        flow.togglePause(); flow.pulse()
        XCTAssertEqual(flow.progress, 0.34375)
        flow.skip()
        XCTAssertEqual(flow.phase, .event)
        XCTAssertEqual(flow.displayAge, 10)
        XCTAssertTrue(flow.isPaused)
        let arrived = flow
        for _ in 0..<50 { flow.pulse(); flow.skip(); flow.togglePause() }
        XCTAssertEqual(flow, arrived, "An event stays paused for a real player choice")
    }

    func testNormalAndFastArriveAtTheSameEventAndInvalidIntervalsDoNotMutate() throws {
        for (speed, pulses) in [(LifePlaybackSpeed.normal, 32), (.fast, 11)] {
            var flow = LifePlayback()
            try flow.travel(from: 12, to: 13); flow.setSpeed(speed)
            for _ in 0..<(pulses - 1) { flow.pulse() }
            XCTAssertEqual(flow.phase, .living)
            flow.pulse()
            XCTAssertEqual(flow.phase, .event)
            XCTAssertEqual(flow.progress, 1)
        }
        var flow = LifePlayback()
        try flow.travel(from: 0, to: 8)
        let before = flow
        for (from, to) in [(-1, 8), (101, 102), (13, 12), (0, 101)] {
            XCTAssertThrowsError(try flow.travel(from: from, to: to))
            XCTAssertEqual(flow, before)
        }
        try flow.travel(from: 100, to: 100)
        XCTAssertEqual(flow.phase, .event, "A zero-length interval never forces animation waiting")
    }

    func testTwoChildhoodEventsLeaveActualMemoriesInTheSameScene() throws {
        let catalog = try StatisticsRepository.bundled()
        var life = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        var flow = LifePlayback()
        try flow.travel(from: 0, to: 8)
        flow.skip()
        let first = LifeWorldViewState(session: life, playback: flow, event: try life.event(catalog: catalog))
        XCTAssertEqual(first.sceneID, "river-home")
        XCTAssertTrue(first.visibleChanges.isEmpty)
        try life.choose("rest", catalog: catalog); flow.restore(life)
        let outcome = LifeWorldViewState(session: life, playback: flow, event: nil)
        XCTAssertEqual(outcome.visibleChanges.map(\.kind), [.activity])
        XCTAssertEqual(outcome.visibleChanges[0].source.eventID, "child-interest")
        XCTAssertEqual(outcome.visibleChanges[0].source.choiceID, "rest")
        XCTAssertEqual(outcome.characters[0].expression, .resting)
        try life.continueLife(catalog: catalog)
        try flow.travel(from: 8, to: 10)
        for _ in 0..<32 { flow.pulse() }
        XCTAssertEqual(flow.phase, .event)
        try life.choose("ask", catalog: catalog); flow.restore(life)
        let second = LifeWorldViewState(session: life, playback: flow, event: nil)
        XCTAssertEqual(second.sceneID, first.sceneID)
        XCTAssertEqual(second.visibleChanges.first { $0.kind == .friendship }?.value, "connected")
        XCTAssertEqual(second.visibleChanges.first { $0.kind == .friendship }?.source.age, 10)
        XCTAssertTrue(second.characters.contains { $0.actor == .ahe })
        XCTAssertEqual(second.phase, .consequence)
    }

    func testRestDoesNotInventAnInteractingFriendAndPausedWorldKeepsItsProgress() throws {
        let catalog = try StatisticsRepository.bundled()
        var life = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        try life.choose("rest", catalog: catalog); try life.continueLife(catalog: catalog)
        try life.choose("rest", catalog: catalog)
        var flow = LifePlayback(); flow.restore(life)
        let rest = LifeWorldViewState(session: life, playback: flow, event: nil)
        XCTAssertEqual(rest.characters.map(\.actor), [.mumu])
        XCTAssertEqual(rest.visibleChanges.first { $0.kind == .friendship }?.value, "paused")
        try life.continueLife(catalog: catalog)
        try flow.travel(from: 10, to: 12)
        for _ in 0..<20 { flow.pulse() }
        let walking = LifeWorldViewState(session: life, playback: flow, event: nil)
        flow.pause()
        let frozen = LifeWorldViewState(session: life, playback: flow, event: nil)
        XCTAssertEqual(frozen.age, walking.age)
        XCTAssertEqual(frozen.progress, walking.progress)
        XCTAssertEqual(frozen.light, .evening)
        XCTAssertTrue(frozen.isMotionPaused)
        XCTAssertFalse(frozen.isEventPaused)
    }

    func testPlaybackPoliciesPreserveFullLifeSelectionsTracesAndComparableChoices() throws {
        let catalog = try StatisticsRepository.bundled()
        for country in ["JPN", "TWN"] {
            for seed: UInt64 in [0, 3] {
                var baseline: LifeSession?
                for policy in ["normal", "fast", "pausedAndSkipped"] {
                    var life = try LifeSession.start(catalog: catalog, countryCode: country,
                        householdID: "\(country.lowercased())-1", seed: seed)
                    var flow = LifePlayback()
                    var fromAge = 0
                    var stages = Set<String>()
                    while life.phase != .ended {
                        try flow.travel(from: fromAge, to: life.state.age)
                        let before = life
                        if policy == "pausedAndSkipped" {
                            flow.pause(); for _ in 0..<40 { flow.pulse() }; flow.skip()
                        } else {
                            flow.setSpeed(policy == "fast" ? .fast : .normal)
                            for _ in 0..<32 { flow.pulse() }
                        }
                        XCTAssertEqual(life, before)
                        let event = try life.event(catalog: catalog)
                        let world = LifeWorldViewState(session: life, playback: flow, event: event)
                        stages.insert(world.stageID)
                        XCTAssertEqual(world.age, life.state.age)
                        let available = try event.choices.first { try life.preview(choiceID: $0.id, catalog: catalog).applied }
                        let choice = try XCTUnwrap(available).id
                        if event.id == "teen-project" {
                            let comparison = try life.compare(choiceID: choice, countryCodes: ["JPN", "USA"], catalog: catalog)
                            XCTAssertEqual(comparison.map(\.eventID), ["teen-project", "teen-project"])
                        }
                        try life.choose(choice, catalog: catalog); flow.restore(life)
                        let result = LifeWorldViewState(session: life, playback: flow, event: nil)
                        for change in result.visibleChanges {
                            XCTAssertTrue(life.traces.contains { $0.eventID == change.source.eventID && $0.choiceID == change.source.choiceID && $0.age == change.source.age })
                        }
                        fromAge = life.state.age
                        try life.continueLife(catalog: catalog)
                    }
                    XCTAssertEqual(stages, ["childhood", "adolescence", "youngAdult", "middleAge", "laterLife"])
                    XCTAssertEqual(life.traces.count, 15)
                    if let baseline { XCTAssertEqual(life, baseline) } else { baseline = life }
                }
            }
        }
    }

    func testRestoringDuringTravelStopsAtSavedEventWithoutChangingDiskOrStory() throws {
        let catalog = try StatisticsRepository.bundled()
        var life = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        try life.choose("rest", catalog: catalog); try life.continueLife(catalog: catalog)
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let saves = SaveRepository(fileURL: directory.appendingPathComponent("journey.json"))
        try saves.save(.single(life), catalog: catalog)
        let bytes = try Data(contentsOf: saves.fileURL)
        var flow = LifePlayback(); try flow.travel(from: 8, to: 10)
        for _ in 0..<7 { flow.pulse() }
        let priorObjects = LifeWorldViewState(session: life, playback: flow, event: nil).visibleChanges
        let restored = try XCTUnwrap(saves.load(catalog: catalog))
        XCTAssertEqual(restored.activeSession, life)
        flow.restore(restored.activeSession)
        for _ in 0..<200 { flow.pulse() }
        XCTAssertEqual(flow.phase, .event)
        XCTAssertTrue(flow.isPaused)
        XCTAssertEqual(try Data(contentsOf: saves.fileURL), bytes)
        XCTAssertEqual(LifeWorldViewState(session: restored.activeSession, playback: flow,
            event: try life.event(catalog: catalog)).visibleChanges, priorObjects)
        try life.choose("rest", catalog: catalog); flow.restore(life)
        XCTAssertEqual(flow.phase, .consequence)
    }
}
