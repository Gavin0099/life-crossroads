import Foundation
import XCTest
import LifeDomain
import LifeData
import LifePersistence
@testable import LifePresentation

final class WorldActivityTests: XCTestCase {
    private var fixtures: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("artifacts/evidence/visual-loop-02/fixtures")
    }
    private func session(_ name: String) throws -> LifeSession {
        let catalog = try StatisticsRepository.bundled()
        let save = try JSONDecoder().decode(JourneySave.self, from: Data(contentsOf: fixtures.appendingPathComponent(name + ".json")))
        try save.validate(catalog: catalog)
        return save.journey.activeSession
    }
    func testReviewedRealRoutesRenderDifferentActionsWithoutChangingArchives() throws {
        let catalog = try StatisticsRepository.bundled()
        // Expected artwork semantics are the reviewed Issue16 matrix, not selector-derived values.
        let expected: [(String, WorldActivity.Kind)] = [
            ("13-online", .onlinePractice), ("13-paper", .paperPractice), ("13-ask", .asking), ("13-rest", .resting),
            ("17-remote", .remoteCollaboration), ("17-collective", .sharedWorkshop),
            ("25-remote", .trialWork), ("25-collective", .communityWork),
            ("32-prepared", .protectedRest), ("32-participating", .pacedParticipation)
        ]
        for (name, kind) in expected {
            let original = try session(name)
            let encoded = try JSONEncoder().encode(original)
            let frame = try WorldMomentProjector.project(session: original, catalog: catalog)
            let visual = try XCTUnwrap(WorldActivity.project(frame), name)
            XCTAssertEqual(visual.kind, kind, name)
            let replay = try LifeSession.restore(from: encoded, catalog: catalog)
            XCTAssertEqual(replay, original)
            XCTAssertEqual(WorldActivity.project(try WorldMomentProjector.project(session: replay, catalog: catalog)), visual)
            XCTAssertEqual(original, try session(name), "Read-only render cannot modify original persisted life")
            if name != "32-prepared" {
                XCTAssertEqual(visual.sourceChoiceID, original.traces.last?.choiceID)
                XCTAssertEqual(visual.sourceEventID, original.traces.last?.eventID)
            } else {
                XCTAssertNil(frame.committedChoiceID)
                XCTAssertLessThan(visual.sourceAge, frame.age)
            }
        }
    }
    func testPendingInvitationsAndUnknownAgesCannotBecomeCompletedWork() throws {
        let catalog = try StatisticsRepository.bundled()
        for name in ["08-arrival", "13-before", "65-arrival", "80-arrival"] {
            let frame = try WorldMomentProjector.project(session: session(name), catalog: catalog)
            XCTAssertNil(WorldActivity.project(frame), name)
        }
        let committed = try WorldMomentProjector.project(session: session("17-remote"), catalog: catalog)
        XCTAssertNil(WorldActivity.project(committed.presenting(.eventPaused)))
        XCTAssertNil(WorldActivity.project(committed.presenting(.living)))
        var unproven = committed; unproven.committedChoiceID = nil
        XCTAssertNil(WorldActivity.project(unproven), "Old memories and available devices are not evidence of today's choice")
    }
    func testUnmadeChoicesKeepASettingButNeverBorrowWorkingPoses() throws {
        let catalog = try StatisticsRepository.bundled()
        let before = try WorldMomentProjector.project(session: session("13-before"), catalog: catalog)
        XCTAssertEqual(WorldActivity.neutralSetting(before)?.background, "VL2Studio")
        XCTAssertEqual(WorldActivity.neutralSetting(before)?.cell, 0)
        XCTAssertNil(WorldActivity.project(before))
        let after = try WorldMomentProjector.project(session: session("13-online"), catalog: catalog)
        XCTAssertNil(WorldActivity.neutralSetting(after))
        XCTAssertEqual(WorldActivity.project(after)?.background, WorldActivity.neutralSetting(before)?.background)
        let old = try WorldMomentProjector.project(session: session("65-arrival"), catalog: catalog)
        XCTAssertNil(WorldActivity.neutralSetting(old), "Unknown events keep their original presentation")
    }
    func testRestPreparationRequiresCompletedFocusNotPendingClue() throws {
        let catalog = try StatisticsRepository.bundled()
        let frame = try WorldMomentProjector.project(session: session("32-prepared"), catalog: catalog)
        let stripped = LifeWorldFrame(stage: frame.stage, age: frame.age, visualFromAge: frame.visualFromAge,
            sceneID: frame.sceneID, actors: frame.actors, worldChanges: frame.worldChanges.filter { $0.kind != .livedFocus },
            moment: frame.moment, eventID: frame.eventID, environmentGaps: frame.environmentGaps)
        XCTAssertNil(WorldActivity.project(stripped))
        XCTAssertEqual(WorldActivity.project(frame)?.kind, .protectedRest)
        XCTAssertNil(WorldActivity.project(frame)?.companionID, "An inviter is not a confirmed helper")
    }
    func testCountryGapsAndResourceSaturationCannotSelectOrEraseActivity() throws {
        let catalog = try StatisticsRepository.bundled()
        let frame = try WorldMomentProjector.project(session: session("13-online"), catalog: catalog)
        var noDelta = LifeWorldFrame(stage: frame.stage, age: frame.age, visualFromAge: frame.visualFromAge,
            sceneID: frame.sceneID, actors: [], worldChanges: [], moment: frame.moment,
            eventID: frame.eventID, environmentGaps: ["no comparable electricity statistics"])
        noDelta.committedChoiceID = frame.committedChoiceID
        XCTAssertEqual(WorldActivity.project(noDelta)?.kind, .onlinePractice, "An applied action survives zero resource delta; gaps are never illustrated as outages")
        XCTAssertNil(WorldActivity.project(noDelta)?.companionID)
    }
}
