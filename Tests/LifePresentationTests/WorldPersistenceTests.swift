import XCTest
import Foundation
import LifeDomain
import LifeData
import LifePresentation
import LifePersistence

final class WorldPersistenceTests: XCTestCase {
    func testPlaybackIsIndependentOfClockAndKeepsReviewedOpeningFixture() throws {
        let c = try StatisticsRepository.bundled()
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        struct Baseline: Decodable { struct Run: Decodable { let traces: [ConsequenceTrace] }; let run: Run }
        for country in ["jpn", "twn"] {
            let reference = try JSONDecoder().decode(Baseline.self, from: Data(contentsOf: root.appendingPathComponent("artifacts/evidence/life-loop/baseline-\(country)-seed0.json")))
            // The opportunity engine intentionally changes later stories. Keep the old opening as
            // an independent fixture, then compare clock modes with an ordinary pure-engine run.
            var direct = try LifeSession.start(catalog: c, countryCode: country.uppercased(), householdID: "\(country)-1", seed: 0)
            let frozenOpening = try XCTUnwrap(reference.run.traces.first)
            try direct.choose(frozenOpening.choiceID, catalog: c)
            let encoder = JSONEncoder()
            var opening = try XCTUnwrap(JSONSerialization.jsonObject(with: encoder.encode(frozenOpening)) as? [String: Any])
            opening["engineVersion"] = LifeState.engineVersion; opening["contentVersion"] = c.contentVersion
            let reviewed = try JSONDecoder().decode(ConsequenceTrace.self, from: JSONSerialization.data(withJSONObject: opening))
            // The new catalog adds candidates, but must not alter existing opening candidates or outcomes.
            var actual = try XCTUnwrap(JSONSerialization.jsonObject(with: encoder.encode(XCTUnwrap(direct.traces.first))) as? [String: Any])
            var selection = try XCTUnwrap(actual["eventSelection"] as? [String: Any])
            let baselineIDs = Set(reviewed.eventSelection.candidates.map(\.eventID))
            selection["candidates"] = (selection["candidates"] as? [[String: Any]])?.filter { baselineIDs.contains($0["eventID"] as? String ?? "") }
            actual["eventSelection"] = selection
            XCTAssertEqual(try JSONDecoder().decode(ConsequenceTrace.self, from: JSONSerialization.data(withJSONObject: actual)), reviewed)
            try direct.continueLife(catalog: c)
            while direct.phase != .ended {
                let event = try direct.event(catalog: c)
                let preferred = ["remoteStudio", "mentorRelay", "portfolio", "cooperate", "invest", "rest"]
                let available = try event.choices.filter { try direct.preview(choiceID: $0.id, catalog: c).applied }.map(\.id)
                try direct.choose(try XCTUnwrap(preferred.first(where: available.contains)), catalog: c)
                try direct.continueLife(catalog: c)
            }
            var saves: [Data] = []
            for mode in 0..<3 {
                let temp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
                defer { try? FileManager.default.removeItem(at: temp) }
                let repo = SaveRepository(fileURL: temp.appendingPathComponent("journey.json"))
                var s = try LifeSession.start(catalog: c, countryCode: country.uppercased(), householdID: "\(country)-1", seed: 0)
                var p = WorldPlayback(); p.bind(s, now: 0)
                for (index, trace) in direct.traces.enumerated() {
                    _ = p.skip(now: Double(index * 10))
                    try s.choose(trace.choiceID, catalog: c)
                    try repo.save(.single(s), catalog: c)
                    let saved = try XCTUnwrap(repo.load(catalog: c)).activeSession
                    XCTAssertEqual(saved, s)
                    XCTAssertEqual(s.traces.last, trace, "Presentation clocks cannot alter the pure-engine run")
                    p.bind(saved, now: Double(index * 10))
                    if mode == 1 { p.setSpeed(.fast, now: Double(index * 10)) }
                    let ticket = mode == 2 ? p.skip(now: Double(index * 10)) : p.tick(now: Double(index * 10 + 3))
                    XCTAssertTrue(p.accepts(try XCTUnwrap(ticket), session: s))
                    try s.continueLife(catalog: c); try repo.save(.single(s), catalog: c)
                    p.bind(s, now: Double(index * 10 + 3))
                }
                XCTAssertEqual(s, direct)
                saves.append(try Data(contentsOf: repo.fileURL))
            }
            XCTAssertEqual(saves[0], saves[1]); XCTAssertEqual(saves[1], saves[2])
        }
    }
    func testForkOriginalBytesSurvivePresentationAndMidBranchDiskRestore() throws {
        let c = try StatisticsRepository.bundled()
        var original = try LifeSession.start(catalog: c, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        while original.phase != .ended {
            try original.choose("rest", catalog: c); try original.continueLife(catalog: c)
        }
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        let originalBytes = try encoder.encode(original)
        var branch = try BranchExperiment.start(original: original, decisionIndex: 3, choiceID: "offline", catalog: c)
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: temp) }
        let repo = SaveRepository(fileURL: temp.appendingPathComponent("branch.json"))
        var p = WorldPlayback(); var now = 0.0
        while branch.alternative.phase != .ended {
            let s = branch.alternative
            p.bind(s, now: now)
            if s.phase == .reflecting {
                XCTAssertNotNil(p.skip(now: now)); try branch.continueLife(catalog: c)
            } else { _ = p.skip(now: now); try branch.choose("rest", catalog: c) }
            now += 10
            try repo.save(.branch(branch), catalog: c)
            let loaded = try XCTUnwrap(repo.load(catalog: c))
            branch = try XCTUnwrap(loaded.experiment)
            XCTAssertEqual(try encoder.encode(branch.original), originalBytes)
        }
        XCTAssertEqual(branch.alternative.state.age, 80)
        XCTAssertEqual(branch.alternative.traces.count, 15)
        XCTAssertNotEqual(branch.alternative, branch.original)
        XCTAssertEqual(try encoder.encode(branch.original), originalBytes)
    }
}
