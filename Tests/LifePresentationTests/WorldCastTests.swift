import Foundation
import XCTest
import LifeDomain
import LifeData
import LifePersistence
@testable import LifePresentation

final class WorldCastTests: XCTestCase {
    private var directory: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("artifacts/evidence/multi-cast-loop/cast-fixtures")
    }
    private func session(_ name: String) throws -> LifeSession {
        let save = try JSONDecoder().decode(JourneySave.self, from: Data(contentsOf: directory.appendingPathComponent(name + ".json")))
        try save.validate(catalog: StatisticsRepository.bundled())
        return save.journey.activeSession
    }
    private func frame(_ name: String) throws -> LifeWorldFrame {
        try WorldMomentProjector.project(session: session(name), catalog: StatisticsRepository.bundled())
    }
    private func replacing(_ f: LifeWorldFrame, actors: [WorldActorProjection]? = nil, event: String? = nil) -> LifeWorldFrame {
        .init(stage: f.stage, age: f.age, visualFromAge: f.visualFromAge, sceneID: f.sceneID,
              actors: actors ?? f.actors, worldChanges: f.worldChanges, moment: f.moment,
              eventID: event ?? f.eventID, environmentGaps: f.environmentGaps, committedChoiceID: f.committedChoiceID)
    }
    func testRealSavedRolesAndActivitiesMatchReviewedStoryMatrix() throws {
        // Expected identities come from the actual catalog/trace inventory, not renderer lookups.
        let expected: [(String, String, WorldCastScene.Kind)] = [
            ("10-friend","ahe",.conversation), ("13-ask","teacher",.requesting),
            ("13-paper","teacher",.explaining), ("17-remote","teacher",.remoteExchange),
            ("17-collective","teacher",.sharedMaking), ("25-collective","teacher",.sharedMaking),
            ("32-ahe-trail","ahe",.natureNotes), ("32-ask","cheng",.requesting), ("32-participating","cheng",.pacedParticipation),
            ("72-ahe","ahe",.reunion), ("72-neighbor","cheng",.newConnection)]
        for (name, person, kind) in expected {
            let f = try frame(name), cast = try XCTUnwrap(WorldCastScene.project(f), name)
            XCTAssertEqual(cast.personID, person, name); XCTAssertEqual(cast.kind, kind, name)
            XCTAssertEqual(cast.choiceID, f.committedChoiceID)
            XCTAssertNil(WorldCastScene.project(replacing(f, actors: [])), "Missing evidence must not create a companion")
            XCTAssertNil(WorldCastScene.project(replacing(f, event: "unknown")))
        }
    }
    func testInvitationIsNotParticipationAndRestDoesNotMakeHelpers() throws {
        for name in ["10-before","32-before","72-ahe-before","72-neighbor-before"] {
            let f = try frame(name), cast = try XCTUnwrap(WorldCastScene.project(f))
            XCTAssertEqual(cast.kind, .invitation); XCTAssertNil(cast.choiceID)
            XCTAssertFalse(f.actors.contains { $0.role == "interacted" || $0.role == "participant" })
        }
        for name in ["10-rest","13-rest"] {
            let f = try frame(name)
            XCTAssertNil(WorldCastScene.project(f)); XCTAssertEqual(f.actors.map(\.personID), ["mumu"])
        }
        let f = try frame("17-collective")
        XCTAssertNil(WorldCastScene.project(f.presenting(.eventPaused)))
        XCTAssertNil(WorldCastScene.project(f.presenting(.living)))
        var uncommitted = f; uncommitted.committedChoiceID = nil
        XCTAssertNil(WorldCastScene.project(uncommitted))
    }
    func testRequestWithoutConfirmedHelpUsesRecipientNotSharedWork() throws {
        let s = try session("32-ask"), f = try frame("32-ask")
        XCTAssertTrue(s.traces.last!.changedRelationships.isEmpty)
        XCTAssertTrue(s.traces.last!.recordedStoryFacts.contains { $0.key == "support" && $0.value == "requested" })
        XCTAssertEqual(f.actors.first { $0.personID == "cheng" }?.role, "recipient")
        XCTAssertEqual(WorldCastScene.project(f)?.kind, .requesting)
        XCTAssertFalse(WorldCastScene.project(f)!.description.contains("已獲得"))
    }
    func testOldFriendAndNewNeighborFollowSameSeedActualHistory() throws {
        let old = try session("72-ahe"), new = try session("72-neighbor")
        XCTAssertEqual(old.state.seed, new.state.seed); XCTAssertEqual(old.state.countryCode, new.state.countryCode)
        XCTAssertEqual(old.state.householdID, new.state.householdID)
        XCTAssertTrue(old.traces.last!.changedRelationships.isEmpty)
        XCTAssertEqual(old.traces.last!.storyVariantID, "later-reconnect-old-friend")
        XCTAssertEqual(new.traces.last!.storyVariantID, "later-reconnect-new-neighbor")
        XCTAssertEqual(try frame("72-ahe").actors.last?.personID, "ahe")
        XCTAssertEqual(try frame("72-neighbor").actors.last?.personID, "cheng")
        // Rest and a request must not inherit the windmill-making pose from the same event.
        for before in ["72-ahe-before","72-neighbor-before"] {
            var s = try session(before); try s.choose("rest", catalog: StatisticsRepository.bundled())
            XCTAssertNil(WorldCastScene.project(try WorldMomentProjector.project(session: s, catalog: StatisticsRepository.bundled())))
            s = try session(before); try s.choose("ask", catalog: StatisticsRepository.bundled())
            XCTAssertEqual(WorldCastScene.project(try WorldMomentProjector.project(session: s, catalog: StatisticsRepository.bundled()))?.kind, .planning)
        }
    }
    func testCastingRestoresReplaysAndNeverRewritesOriginalBytes() throws {
        let c = try StatisticsRepository.bundled()
        let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: folder) }
        let repo = SaveRepository(fileURL: folder.appendingPathComponent("life.json"))
        for name in ["10-friend","13-ask","17-remote","25-collective","32-participating","72-ahe","72-neighbor"] {
            let s = try session(name); try repo.save(.single(s), catalog: c)
            let before = try Data(contentsOf: repo.fileURL)
            let restored = try XCTUnwrap(repo.load(catalog: c)).activeSession
            let replay = try LifeSession.restore(from: JSONEncoder().encode(restored), catalog: c)
            XCTAssertEqual(replay, s)
            XCTAssertEqual(WorldCastScene.project(try WorldMomentProjector.project(session: replay, catalog: c)), WorldCastScene.project(try frame(name)))
            XCTAssertEqual(try Data(contentsOf: repo.fileURL), before)
        }
    }
    func testUnknownAndCandidateIdentitiesNeverBecomeStoryCast() throws {
        XCTAssertNil(WorldMomentProjector.personID("工作夥伴"))
        XCTAssertNil(WorldMomentProjector.personID("cat")); XCTAssertNil(WorldMomentProjector.personID("dog"))
        let f = try frame("10-before")
        for id in ["cat","dog","hare","unknown"] {
            XCTAssertNil(WorldCastScene.project(replacing(f, actors: [.init(personID: id, role: "inviter", evidenceEventID: f.eventID)])))
        }
    }
    func testNatureContinuationDoesNotInventFirstTimeExperience() throws {
        let c = try StatisticsRepository.bundled()
        var s = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 5)
        let choices = [8:"invest",10:"invest",12:"observe",13:"invest",17:"invest",21:"rest",25:"invest"]
        while s.state.age < 32 {
            try s.choose(try XCTUnwrap(choices[s.state.age]), catalog: c)
            try s.continueLife(catalog: c)
        }
        XCTAssertEqual(try s.event(catalog: c).id, "adult-local-trail")
        try s.choose("record", catalog: c)
        XCTAssertEqual(s.traces.last?.storyVariantID, "adult-local-trail-continuation")
        XCTAssertEqual(try session("32-ahe-trail").traces.last?.storyVariantID, "adult-local-trail-recovery")
        let cast = try XCTUnwrap(WorldCastScene.project(try WorldMomentProjector.project(session: s, catalog: c)))
        XCTAssertEqual(cast.kind, .natureNotes)
        XCTAssertFalse(cast.description.contains("入門"), "A pose cannot infer that observation happened for the first time")
        XCTAssertFalse(cast.description.contains("首次"))
    }

}
