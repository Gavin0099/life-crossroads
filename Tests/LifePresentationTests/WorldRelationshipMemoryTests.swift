import Foundation
import XCTest
import LifeDomain
import LifeData
import LifePersistence
@testable import LifePresentation

final class WorldRelationshipMemoryTests: XCTestCase {
    private func saved(_ name: String) throws -> JourneySave {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        return try JSONDecoder().decode(JourneySave.self, from: Data(contentsOf: root.appendingPathComponent("artifacts/evidence/multi-cast-loop/cast-fixtures/\(name).json")))
    }
    private func session(_ name: String) throws -> LifeSession {
        let archive = try saved(name); try archive.validate(catalog: StatisticsRepository.bundled())
        return archive.journey.activeSession
    }
    private func altered(_ session: LifeSession, _ mutate: (inout [String: Any]) -> Void) throws -> LifeSession {
        var json = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(session)) as? [String: Any])
        mutate(&json)
        // Intentionally bypass archive validation to exercise the projector's fail-closed boundary.
        return try JSONDecoder().decode(LifeSession.self, from: JSONSerialization.data(withJSONObject: json))
    }
    func testPairedHistoryUsesExactPastAndPresentReceipts() throws {
        let old = try session("72-ahe"), new = try session("72-neighbor")
        XCTAssertEqual(old.state.seed, new.state.seed); XCTAssertEqual(old.state.householdID, new.state.householdID)
        let a = try XCTUnwrap(WorldRelationshipMemory.project(session: old))
        let b = try XCTUnwrap(WorldRelationshipMemory.project(session: new))
        XCTAssertEqual(a.past.age, 10); XCTAssertEqual(a.past.eventID, "child-friend"); XCTAssertEqual(a.past.choiceID, "invest")
        XCTAssertEqual(a.present.age, 72); XCTAssertEqual(a.present.choiceID, "invest")
        XCTAssertEqual(a.presentPersonID, "ahe"); XCTAssertTrue(a.keptFriendship)
        XCTAssertEqual(b.past.choiceID, "rest"); XCTAssertEqual(b.presentPersonID, "cheng"); XCTAssertFalse(b.keptFriendship)
        XCTAssertFalse(b.description.contains("第一次")); XCTAssertFalse(b.description.contains("童年的小澄"))
    }
    func testNoMemoryForInvitationsRestOrRequests() throws {
        for name in ["72-ahe-before", "72-neighbor-before", "13-ask", "32-ask", "10-rest"] {
            XCTAssertNil(WorldRelationshipMemory.project(session: try session(name)), name)
        }
        for choice in ["ask", "rest"] {
            var s = try session("72-ahe-before"); try s.choose(choice, catalog: StatisticsRepository.bundled())
            XCTAssertNil(WorldRelationshipMemory.project(session: s))
        }
        let frame = try WorldMomentProjector.project(session: session("72-ahe"), catalog: StatisticsRepository.bundled())
        XCTAssertNil(frame.presenting(.eventPaused).relationshipMemory)
        XCTAssertEqual(frame.presenting(.committedOutcome).relationshipMemory, frame.relationshipMemory)
    }
    func testMismatchedBranchSourcesAndActorsCannotCreateMemory() throws {
        let original = try session("72-ahe")
        let cases: [(String, (inout [String: Any]) -> Void)] = [
            ("source age", { $0["sourceAge"] = 13 }), ("source event", { $0["sourceEventID"] = "teen-project" }),
            ("source choice", { $0["sourceChoiceID"] = "rest" }), ("future source", { $0["sourceAge"] = 80 }),
            ("flag", { $0["flagKey"] = "support" }), ("variant", { $0["variantID"] = "later-reconnect-new-neighbor" })]
        for (name, change) in cases {
            let bad = try altered(original) { j in
                var traces = j["traces"] as! [[String: Any]], t = traces.removeLast()
                var b = t["storyBranch"] as! [String: Any]; change(&b); t["storyBranch"] = b; traces.append(t); j["traces"] = traces
            }
            XCTAssertNil(WorldRelationshipMemory.project(session: bad), name)
        }
        for name in ["72-ahe", "72-neighbor"] {
            for mutation in ["wrongPerson", "unapplied", "missingFact", "wrongFactReceipt"] {
                let bad = try altered(session(name)) { j in
                    var traces = j["traces"] as! [[String: Any]]
                    if mutation == "wrongPerson" { traces[traces.count - 1]["recurringPerson"] = name == "72-ahe" ? "小澄" : "阿禾" }
                    if mutation == "unapplied" { traces[traces.count - 1]["applied"] = false }
                    let i = traces.firstIndex { ($0["age"] as? Int) == 10 }!
                    if mutation == "missingFact" { traces[i]["recordedStoryFacts"] = [] }
                    if mutation == "wrongFactReceipt" {
                        var facts = traces[i]["recordedStoryFacts"] as! [[String: Any]]; facts[0]["age"] = 8; traces[i]["recordedStoryFacts"] = facts
                    }
                    j["traces"] = traces
                }
                XCTAssertNil(WorldRelationshipMemory.project(session: bad), "\(name) \(mutation)")
            }
        }
    }
    func testReplayRestoreAndOriginalBytesRemainIdentical() throws {
        let catalog = try StatisticsRepository.bundled(), encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        for name in ["72-ahe", "72-neighbor", "13-ask", "32-ask", "32-participating"] {
            let save = try saved(name), s = save.journey.activeSession, before = try encoder.encode(save)
            let restored = try JSONDecoder().decode(JourneySave.self, from: before)
            try restored.validate(catalog: catalog)
            let replayed = try LifeSession.restore(from: encoder.encode(s), catalog: catalog)
            let expected = try WorldMomentProjector.project(session: s, catalog: catalog)
            XCTAssertEqual(expected, try WorldMomentProjector.project(session: restored.journey.activeSession, catalog: catalog))
            XCTAssertEqual(expected, try WorldMomentProjector.project(session: replayed, catalog: catalog))
            XCTAssertEqual(before, try encoder.encode(save))
        }
    }
    func testRequestBeatsNeverPromoteToAgreementOrParticipation() throws {
        let catalog = try StatisticsRepository.bundled()
        for name in ["13-ask", "32-ask"] {
            let s = try session(name), f = try WorldMomentProjector.project(session: s, catalog: catalog)
            for (milliseconds, expected) in [(0.0, WorldRequestBeat.expressing),(1099, .expressing),(1100, .listening),(2000, .listening)] {
                let m = PresentationMotionFrame(elapsedMs: milliseconds, frozen: true, reduceMotion: false, phase: .committedOutcome, phaseToken: "saved", phaseElapsedMs: milliseconds)
                XCTAssertEqual(WorldRequestBeat.project(frame: f, motion: m), expected)
                XCTAssertEqual(WorldCastScene.project(f)?.kind, .requesting)
            }
            let reduced = PresentationMotionFrame(elapsedMs: 2000, frozen: true, reduceMotion: true, phase: .committedOutcome, phaseToken: "saved", phaseElapsedMs: 2000)
            XCTAssertEqual(WorldRequestBeat.project(frame: f, motion: reduced), .expressing)
        }
        let request = try session("32-ask")
        XCTAssertTrue(request.traces.last!.changedRelationships.isEmpty)
        for name in ["10-before", "13-rest", "32-participating", "72-ahe"] {
            let f = try WorldMomentProjector.project(session: session(name), catalog: catalog)
            let m = PresentationMotionFrame(elapsedMs: 2000, frozen: true, reduceMotion: false, phase: f.moment, phaseToken: "saved", phaseElapsedMs: 2000)
            XCTAssertNil(WorldRequestBeat.project(frame: f, motion: m))
        }
    }
    func testCurrentEventTitleCannotBecomeThePastChoice() throws {
        for (name, age) in [("72-ahe", 72), ("72-neighbor", 72), ("72-neighbor", 65)] {
            let s = try session(name), trace = try XCTUnwrap(s.traces.first { $0.age == age })
            let text = LifeStoryComparison.consequences(trace, arrival: try XCTUnwrap(s.jumps.first { $0.toAge == age })).joined(separator: "。")
            let sourceAge = try XCTUnwrap(trace.storyBranch?.sourceAge)
            XCTAssertFalse(text.contains("\(sourceAge)歲留下的選擇：\(trace.eventTitle)"), "Present title must not be attributed to the earlier age")
            XCTAssertTrue(text.contains("\(sourceAge)歲"))
            XCTAssertTrue(text.contains("現在\(age)歲"))
        }
        let noSource = try session("32-ahe-trail")
        let trace = try XCTUnwrap(noSource.traces.last)
        XCTAssertNil(trace.storyBranch?.sourceAge)
        XCTAssertFalse(LifeStoryComparison.consequences(trace, arrival: try XCTUnwrap(noSource.jumps.last)).joined().contains("歲留下的故事記錄"))
    }

}
