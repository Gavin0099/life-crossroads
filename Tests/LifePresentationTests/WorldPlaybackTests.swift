import XCTest
import LifeDomain
import LifeData
import LifePresentation

final class WorldPlaybackTests: XCTestCase {
    func testAccumulatedClockPauseSpeedAndBackgroundDoNotJump() throws {
        let c = try StatisticsRepository.bundled()
        let s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        var p = WorldPlayback(); p.bind(s, now: 10)
        XCTAssertNil(p.tick(now: 10.5)); XCTAssertEqual(p.elapsedMs, 500, accuracy: 0.001)
        p.setPaused(true, now: 11)
        XCTAssertNil(p.tick(now: 90)); XCTAssertEqual(p.elapsedMs, 1000, accuracy: 0.001)
        p.setPaused(false, now: 90); p.setSpeed(.fast, now: 90.25)
        XCTAssertEqual(p.elapsedMs, 1250, accuracy: 0.001)
        p.setSuspended(true, now: 90.5)
        XCTAssertEqual(p.elapsedMs, 2000, accuracy: 0.001)
        p.setSuspended(false, now: 200); p.setSpeed(.normal, now: 200)
        XCTAssertNil(p.tick(now: 200.5)); XCTAssertEqual(p.elapsedMs, 2500, accuracy: 0.001)
        XCTAssertNil(p.tick(now: 201)); XCTAssertEqual(p.phase, .eventPaused)
        let time = p.elapsedMs
        XCTAssertNil(p.tick(now: 1000)); XCTAssertEqual(p.elapsedMs, time)
        XCTAssertEqual(s.traces.count, 0)
    }
    func testExactlyOnceStaleGenerationFailureRetryAndRestore() throws {
        let c = try StatisticsRepository.bundled()
        var s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        try s.choose("rest", catalog: c)
        var p = WorldPlayback(); p.bind(s, now: 0)
        let ticket = try XCTUnwrap(p.tick(now: 2.1))
        XCTAssertTrue(p.accepts(ticket, session: s)); XCTAssertNil(p.skip(now: 3)); XCTAssertNil(p.tick(now: 4))
        p.commitFailed(now: 4); XCTAssertTrue(p.paused)
        XCTAssertNil(p.tick(now: 100)); XCTAssertFalse(p.accepts(ticket, session: s))
        let retry = try XCTUnwrap(p.skip(now: 100))
        XCTAssertTrue(p.accepts(retry, session: s))
        XCTAssertFalse(p.accepts(ticket, session: s), "An older failed ticket must not revive during a retry")
        try s.continueLife(catalog: c); p.bind(s, now: 100)
        XCTAssertFalse(p.accepts(retry, session: s)); XCTAssertNil(p.skip(now: 100))
        XCTAssertEqual(p.phase, .eventPaused); XCTAssertNil(p.skip(now: 100))
        try s.choose("rest", catalog: c); p.bind(s, now: 101, restoring: true)
        XCTAssertNil(p.tick(now: 500)); XCTAssertTrue(p.paused)
        XCTAssertNotNil(p.skip(now: 500))
        let oldGeneration = p.generation; p.bind(s, now: 501)
        XCTAssertGreaterThan(p.generation, oldGeneration)
        XCTAssertFalse(p.accepts(retry, session: s))
        let beforeReset = try XCTUnwrap(p.skip(now: 502))
        p.bind(s, now: 503, reset: true)
        _ = p.skip(now: 503)
        XCTAssertFalse(p.accepts(beforeReset, session: s), "Same-Seed restarts never reuse a callback generation")
    }
    func testOffscreenFreezesClockButExplicitContinueAndPausedRestoreRemainReadable() throws {
        let c = try StatisticsRepository.bundled()
        var s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        var p = WorldPlayback(); p.bind(s, now: 0)
        p.setOffscreen(true, now: 0.5)
        XCTAssertNil(p.tick(now: 50)); XCTAssertEqual(p.elapsedMs, 500, accuracy: 0.001)
        XCTAssertNil(p.skip(now: 50)); XCTAssertEqual(p.phase, .eventPaused)
        try s.choose("rest", catalog: c)
        p.setPaused(true, now: 50); p.bind(s, now: 50)
        XCTAssertEqual(p.motion(reduceMotion: false).phaseElapsedMs, 2000, "A newly paused committed outcome uses its completed frame")
        XCTAssertNotNil(p.skip(now: 50), "Explicit accessible action works when the scene is scrolled away")
        p.bind(s, now: 51, restoring: true)
        XCTAssertEqual(p.phaseElapsedMs, 2000); XCTAssertNil(p.tick(now: 500))
    }

    func testNormalFastAndSkipAreIdenticalForEightCountriesAndRestore() throws {
        let c = try StatisticsRepository.bundled()
        for country in ["TWN", "JPN", "USA", "DEU", "IND", "BRA", "VNM", "KEN"] {
            var results: [LifeSession] = []
            for mode in 0..<3 {
                var s = try LifeSession.start(catalog: c, countryCode: country, householdID: "\(country.lowercased())-1", seed: 0)
                var p = WorldPlayback(); var now = 0.0
                p.bind(s, now: now)
                if mode == 1 { p.setSpeed(.fast, now: now) }
                for index in 0..<15 {
                    if mode == 2 { XCTAssertNil(p.skip(now: now)) }
                    else { now += mode == 1 ? 1.01 : 3.01; XCTAssertNil(p.tick(now: now)) }
                    XCTAssertEqual(p.phase, .eventPaused)
                    let e = try s.event(catalog: c)
                    let choice = try XCTUnwrap(e.choices.first { (try? s.preview(choiceID: $0.id, catalog: c).applied) == true })
                    try s.choose(choice.id, catalog: c); p.bind(s, now: now)
                    if index == 7 { s = try LifeSession.restore(from: JSONEncoder().encode(s), catalog: c); p.bind(s, now: now, restoring: true); p.setPaused(false, now: now) }
                    let ticket: WorldAdvanceTicket?
                    if mode == 2 { ticket = p.skip(now: now) }
                    else { now += mode == 1 ? 0.68 : 2.01; ticket = p.tick(now: now) }
                    XCTAssertTrue(p.accepts(try XCTUnwrap(ticket), session: s))
                    try s.continueLife(catalog: c); p.bind(s, now: now)
                }
                XCTAssertEqual(s.phase, .ended); XCTAssertEqual(s.state.age, 80); results.append(s)
            }
            XCTAssertEqual(results[0], results[1]); XCTAssertEqual(results[1], results[2])
        }
    }
}
