import Foundation
import XCTest
import LifeDomain
import LifeData
import LifePersistence
@testable import LifePresentation

final class WorldRequestTransitionTests: XCTestCase {
    private func archive(_ name: String) throws -> JourneySave {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let save = try JSONDecoder().decode(JourneySave.self, from: Data(contentsOf: root.appendingPathComponent("artifacts/evidence/interaction-memory-loop/interaction-fixtures/\(name).json")))
        try save.validate(catalog: StatisticsRepository.bundled())
        return save
    }
    private func frame(_ name: String) throws -> LifeWorldFrame {
        try WorldMomentProjector.project(session: archive(name).journey.activeSession, catalog: StatisticsRepository.bundled())
    }
    private func motion(_ ms: Double, reduced: Bool = false, phase: LifeWorldMomentKind = .committedOutcome,
                        frozen: Bool = true, total: Double = 100_000) -> PresentationMotionFrame {
        PresentationMotionFrame(elapsedMs: total, frozen: frozen, reduceMotion: reduced,
                                phase: phase, phaseToken: "same-saved-result", phaseElapsedMs: ms)
    }
    func testReviewedHandoverTimingAndEndpoints() throws {
        // Acceptance timing, independent of the implementation's easing formula:
        // held through 700 ms; halfway at 760; settled from 820 onward.
        for name in ["13-ask", "32-ask"] {
            let f = try frame(name)
            for (ms, expected) in [(-1.0, 0.0), (0, 0), (700, 0), (760, 0.5), (820, 1), (900, 1), (10_000, 1)] {
                XCTAssertEqual(WorldRequestTransition.listeningOpacity(frame: f, motion: motion(ms)), expected, accuracy: 0.0001)
            }
            let samples = stride(from: 0.0, through: 2000, by: 25).map {
                WorldRequestTransition.listeningOpacity(frame: f, motion: motion($0))
            }
            XCTAssertTrue(samples.allSatisfy { (0...1).contains($0) })
            XCTAssertEqual(samples, samples.sorted())
        }
    }
    func testReducedMotionAndInvalidTimeKeepTheHonestStaticRequest() throws {
        let f = try frame("32-ask")
        for ms in [0.0, 900, 1400, .infinity, -.infinity, .nan] {
            XCTAssertEqual(WorldRequestTransition.listeningOpacity(frame: f, motion: motion(ms, reduced: true)), 0)
        }
        for ms in [Double.infinity, -.infinity, .nan] {
            XCTAssertEqual(WorldRequestTransition.listeningOpacity(frame: f, motion: motion(ms)), 0)
        }
        XCTAssertEqual(WorldCastScene.project(f)?.kind, .requesting)
    }
    func testInvitationsRestParticipationAndWrongPhaseCannotPlayRequestHandover() throws {
        for name in ["13-before", "13-rest", "32-before", "32-participating", "72-ahe"] {
            XCTAssertEqual(WorldRequestTransition.listeningOpacity(frame: try frame(name), motion: motion(1400)), 0, name)
        }
        let f = try frame("13-ask")
        XCTAssertEqual(WorldRequestTransition.listeningOpacity(frame: f.presenting(.eventPaused), motion: motion(1400)), 0)
        XCTAssertEqual(WorldRequestTransition.listeningOpacity(frame: f, motion: motion(1400, phase: .eventPaused)), 0)
    }
    func testPauseResumeAndTotalClockDoNotRestartThePose() throws {
        let f = try frame("13-ask")
        let paused = WorldRequestTransition.listeningOpacity(frame: f, motion: motion(760, frozen: true, total: 2_000))
        let resumed = WorldRequestTransition.listeningOpacity(frame: f, motion: motion(760, frozen: false, total: 90_000))
        XCTAssertEqual(paused, 0.5)
        XCTAssertEqual(paused, resumed)
    }
    func testPresentationSamplingCannotChangeSavedStoryOrRestoredProjection() throws {
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        for name in ["13-ask", "32-ask"] {
            let save = try archive(name), before = try encoder.encode(save), f = try frame(name)
            for ms in [0.0, 200, 900, 1400, 60_000] {
                _ = WorldRequestTransition.listeningOpacity(frame: f, motion: motion(ms))
                XCTAssertEqual(WorldCastScene.project(f)?.kind, .requesting)
            }
            XCTAssertEqual(try encoder.encode(save), before)
            let restored = try JSONDecoder().decode(JourneySave.self, from: before)
            try restored.validate(catalog: StatisticsRepository.bundled())
            let after = try WorldMomentProjector.project(session: restored.journey.activeSession, catalog: StatisticsRepository.bundled())
            XCTAssertEqual(after, f)
        }
    }
}
