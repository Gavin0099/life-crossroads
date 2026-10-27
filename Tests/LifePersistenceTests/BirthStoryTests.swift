import XCTest
import LifeDomain
import LifeData
import LifePresentation
import LifePersistence

final class BirthStoryTests: XCTestCase {
    private func finish(_ initial: LifeSession, catalog: ModelCatalog, project: String = "offline") throws -> LifeSession {
        var life = initial
        while life.phase != .ended {
            if life.phase == .reflecting { try life.continueLife(catalog: catalog) }
            else {
                let event = try life.event(catalog: catalog)
                let wish = event.id == "teen-project" ? project : "rest"
                try life.choose(try life.preview(choiceID: wish, catalog: catalog).applied ? wish : "rest", catalog: catalog)
            }
        }
        return life
    }
    private func data<T: Encodable>(_ value: T) throws -> Data {
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]; return try encoder.encode(value)
    }
    func testBirthDrawOrderingCoverageAndReceiptBinding() throws {
        let c = try StatisticsRepository.bundled()
        var shuffled = c; shuffled.households.reverse(); shuffled.countries.reverse()
        var seen = Set<String>()
        for seed in UInt64(0)..<512 {
            let draw = try BirthDraw.draw(catalog: c, seed: seed)
            XCTAssertEqual(draw, try BirthDraw.draw(catalog: shuffled, seed: seed))
            XCTAssertEqual(draw.candidateIDs.count, 16)
            seen.insert(draw.householdID)
        }
        XCTAssertEqual(seen, Set(c.households.map(\.id)))
        let life = try LifeSession.startRandom(catalog: c, seed: 0)
        XCTAssertEqual(life, try LifeSession.restore(from: data(life), catalog: c))
        var raw = try XCTUnwrap(JSONSerialization.jsonObject(with: data(life)) as? [String: Any])
        var receipt = try XCTUnwrap(raw["birthDraw"] as? [String: Any])
        receipt["selectedDraw"] = -1; raw["birthDraw"] = receipt
        XCTAssertThrowsError(try LifeSession.restore(from: JSONSerialization.data(withJSONObject: raw), catalog: c))
        XCTAssertThrowsError(try JSONDecoder().decode(LifeSession.self, from: JSONSerialization.data(withJSONObject: raw)).chooseFocusForTest(c))
    }
    func testCompleteParallelDiskReplayAndOriginalBytesAllPhases() throws {
        let c = try StatisticsRepository.bundled()
        let old = try finish(.startRandom(catalog: c, seed: 0), catalog: c)
        let originalBytes = try data(old)
        let other = try XCTUnwrap(c.households.first { $0.countryCode != old.state.countryCode })
        var live = LifeJourney.parallel(try .start(original: old, countryCode: other.countryCode, householdID: other.id, catalog: c))
        let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: folder) }
        let repo = SaveRepository(fileURL: folder.appendingPathComponent("life.json"))
        XCTAssertThrowsError(try live.parallelExperiment?.comparison(catalog: c))
        while true {
            try repo.save(live, catalog: c)
            var restored = try XCTUnwrap(repo.load(catalog: c))
            XCTAssertEqual(live, restored)
            XCTAssertEqual(try data(XCTUnwrap(restored.comparisonOriginal)), originalBytes)
            XCTAssertEqual(JourneySave(journey: live).schemaVersion, 3)
            if live.activeSession.phase == .ended { break }
            if live.activeSession.phase == .reflecting {
                try live.continueLife(catalog: c); try restored.continueLife(catalog: c)
            } else {
                let choice = live.activeSession.state.age == 13 ? "ask" : "rest"
                try live.choose(choice, catalog: c); try restored.choose(choice, catalog: c)
            }
            XCTAssertEqual(live, restored)
        }
        let rows = try XCTUnwrap(live.parallelExperiment).comparison(catalog: c)
        XCTAssertEqual(rows.count, 15); XCTAssertEqual(rows.first?.alternative.age, 8); XCTAssertEqual(rows.last?.alternative.age, 80)
        XCTAssertEqual(rows.map(\.original), old.traces)
        XCTAssertEqual(rows.map(\.alternative), live.activeSession.traces)
        XCTAssertLessThanOrEqual(LifeStoryComparison.highlights(rows).count, 3)
        XCTAssertTrue(LifeStoryComparison.highlights(rows).contains { $0.original.age == 17 })
        XCTAssertNotEqual(rows[3].original.recordedStoryFacts, rows[3].alternative.recordedStoryFacts)
        XCTAssertFalse(LifeStoryComparison.consequences(rows[4].original, arrival: rows[4].originalArrival).contains { $0.contains("紙本創作") }, "An unselected continuation must not be narrated as an invitation")
        let originalRestored = try LifeSession.restore(from: originalBytes, catalog: c)
        XCTAssertEqual(originalRestored, old)
        // Existing within-birth branching preserves a random-birth receipt too.
        let fork = try BranchExperiment.start(original: old, decisionIndex: 3, choiceID: "ask", catalog: c)
        try fork.validate(catalog: c); XCTAssertEqual(fork.alternative.birthDraw, old.birthDraw)
    }
    func testRealCreationConstraintsAndConditionalContinuationWithoutCountryScripts() throws {
        let c = try StatisticsRepository.bundled()
        func atProject(_ code: String, _ number: Int) throws -> LifeSession {
            var life = try LifeSession.start(catalog: c, countryCode: code, householdID: "\(code.lowercased())-\(number)", seed: 34)
            for _ in 0..<3 { try life.choose("rest", catalog: c); try life.continueLife(catalog: c) }
            return life
        }
        let japan = try atProject("JPN", 1), kenya = try atProject("KEN", 1)
        let jOnline = try japan.preview(choiceID: "invest", catalog: c), kOnline = try kenya.preview(choiceID: "invest", catalog: c)
        // Reviewed rule witness: base 3 + shared device 1 - mentor 2 + network 1/2.
        XCTAssertEqual(jOnline.finalCost.time, 3); XCTAssertEqual(kOnline.finalCost.time, 4)
        XCTAssertEqual(jOnline.finalCost.materials, 1); XCTAssertEqual(kOnline.finalCost.materials, 2)
        XCTAssertEqual(try japan.preview(choiceID: "offline", catalog: c).finalCost, try kenya.preview(choiceID: "offline", catalog: c).finalCost)
        XCTAssertEqual(try atProject("KEN", 2).preview(choiceID: "invest", catalog: c).finalCost.time, 5)
        let missing = try atProject("TWN", 1).preview(choiceID: "invest", catalog: c)
        XCTAssertFalse(missing.environmentGaps.isEmpty)
        XCTAssertTrue(BirthStory.creationContext(preview: missing).contains("尚不足"))
        for code in ["JPN", "KEN"] {
            for action in ["invest", "offline", "ask", "rest"] {
                var life = try atProject(code, 1)
                try life.choose(action, catalog: c); try life.continueLife(catalog: c)
                let event = try life.event(catalog: c)
                if action == "invest" || action == "offline" {
                    XCTAssertEqual(event.id, "teen-direction", "Seed 34 is a disclosed actual continuation witness")
                    if action == "offline" { XCTAssertTrue(LifeNarrative.text(event: event, state: life.state).contains("13歲留下的紙本")) }
                    else { XCTAssertNotNil(try life.preview(choiceID: "ask", catalog: c).storyBranch?.opportunity) }
                }
                XCTAssertEqual(life.state.story.fact("learning")?.choiceID, action)
                XCTAssertEqual(try LifeSession.restore(from: data(life), catalog: c), life)
            }
        }
        // Country labels are presentation only. Same inputs must retain the same narrative and rules.
        var renamed = c
        for index in renamed.countries.indices { renamed.countries[index].name = "另一個名稱" }
        XCTAssertEqual(try japan.preview(choiceID: "invest", catalog: renamed), jOnline)
    }

    func testParallelRejectsInvalidPairAndSaveDowngrade() throws {
        let c = try StatisticsRepository.bundled()
        let start = try LifeSession.startRandom(catalog: c, seed: 0)
        XCTAssertThrowsError(try ParallelLifeExperiment.start(original: start, countryCode: "JPN", householdID: "jpn-1", catalog: c))
        let original = try finish(start, catalog: c)
        XCTAssertThrowsError(try ParallelLifeExperiment.start(original: original, countryCode: original.state.countryCode, householdID: original.state.householdID, catalog: c))
        let save = JourneySave(journey: .single(start))
        var raw = try XCTUnwrap(JSONSerialization.jsonObject(with: data(save)) as? [String: Any])
        for version in [1, 2, 4] {
            raw["schemaVersion"] = version
            let bad = try JSONDecoder().decode(JourneySave.self, from: JSONSerialization.data(withJSONObject: raw))
            XCTAssertThrowsError(try bad.validate(catalog: c))
        }
        let other = try XCTUnwrap(c.households.first { $0.id != original.state.householdID })
        let pair = try ParallelLifeExperiment.start(original: original, countryCode: other.countryCode, householdID: other.id, catalog: c)
        var forged = try XCTUnwrap(JSONSerialization.jsonObject(with: data(pair)) as? [String: Any])
        forged["alternative"] = try JSONSerialization.jsonObject(with: data(LifeSession.start(catalog: c, countryCode: other.countryCode, householdID: other.id, seed: 99)))
        var invalid = try JSONDecoder().decode(ParallelLifeExperiment.self, from: JSONSerialization.data(withJSONObject: forged))
        XCTAssertThrowsError(try invalid.choose("rest", catalog: c))
        XCTAssertThrowsError(try invalid.comparison(catalog: c))
    }
}
private extension LifeSession {
    func chooseFocusForTest(_ catalog: ModelCatalog) throws {
        var value = self; try value.chooseFocus(.learning, catalog: catalog)
    }
}
