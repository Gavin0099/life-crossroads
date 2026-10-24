import XCTest
import Foundation
import LifeDomain
import LifeData
import LifePresentation

final class LifeWorldFrameTests: XCTestCase {
    func testChoosingNeverProjectsAnUnmadeChoiceOrFutureSuccess() throws {
        let c = try StatisticsRepository.bundled()
        let s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        let f = try WorldMomentProjector.project(session: s, catalog: c)
        XCTAssertEqual(f.age, 8); XCTAssertEqual(f.visualFromAge, 0); XCTAssertEqual(f.moment, .eventPaused)
        XCTAssertTrue(f.worldChanges.isEmpty)
        XCTAssertFalse(f.actors.contains { $0.role == "interacted" })
        XCTAssertEqual(f.presenting(.living).age, 8, "Montage cannot change canonical age")
    }
    func testRestAndUnknownEventDoNotInventSupport() throws {
        let c = try StatisticsRepository.bundled()
        var s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        try s.choose("rest", catalog: c)
        let f = try WorldMomentProjector.project(session: s, catalog: c)
        XCTAssertEqual(f.moment, .committedOutcome)
        XCTAssertEqual(f.actors.map(\.personID), ["mumu"])
        XCTAssertFalse(f.worldChanges.contains { $0.kind == .occurredChance || $0.kind == .relationship })
        var broken = c; broken.decisions.removeAll()
        try s.continueLife(catalog: c)
        XCTAssertThrowsError(try WorldMomentProjector.project(session: s, catalog: broken))
    }
    func testFactsPendingHooksTriggeredHooksAndTaiwanGapsHaveSources() throws {
        let c = try StatisticsRepository.bundled()
        var s = try LifeSession.start(catalog: c, countryCode: "TWN", householdID: "twn-1", seed: 0)
        for _ in 0..<3 { try s.choose("rest", catalog: c); try s.continueLife(catalog: c) }
        try s.choose("invest", catalog: c)
        let f = try WorldMomentProjector.project(session: s, catalog: c)
        XCTAssertFalse(f.environmentGaps.isEmpty)
        XCTAssertTrue(f.worldChanges.contains { $0.kind == .memory && $0.sourceEventID == "teen-project" && $0.sourceChoiceID == "invest" && $0.sourceAge == 13 })
        XCTAssertTrue(f.worldChanges.contains { $0.kind == .pendingClue && !$0.isOccurred })
        XCTAssertEqual(try WorldMomentProjector.project(session: LifeSession.restore(from: JSONEncoder().encode(s), catalog: c), catalog: c), f)
        try s.continueLife(catalog: c)
        let next = try WorldMomentProjector.project(session: s, catalog: c)
        XCTAssertEqual(next.worldChanges.filter { $0.kind == .delayedConsequence }.count, s.jumps.last?.triggeredHooks.count)
        for _ in s.traces.count..<s.plannedDecisionCount {
            try s.choose("rest", catalog: c); try s.continueLife(catalog: c)
        }
        XCTAssertEqual(try WorldMomentProjector.project(session: s, catalog: c).moment, .ending)
    }
}
