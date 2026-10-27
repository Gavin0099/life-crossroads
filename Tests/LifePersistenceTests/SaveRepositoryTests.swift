import XCTest
import LifeDomain
import LifeData
import LifePersistence

final class SaveRepositoryTests: XCTestCase {
    func testFocusDiskResumeAndOldEngineArchivePreservation() throws {
        let catalog = try StatisticsRepository.bundled()
        let folder = try directory()
        let repository = SaveRepository(fileURL: folder.appendingPathComponent("journey.json"))
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let fixture = root.appendingPathComponent("artifacts/evidence/world-trace-visual/saved-lives/13-before.json")
        // Actual archive committed before this feature, not a newly generated lookalike.
        let oldData = try Data(contentsOf: fixture)
        try oldData.write(to: repository.fileURL)
        XCTAssertThrowsError(try repository.load(catalog: catalog), "An old engine is not silently replayed under new story rules")
        XCTAssertEqual(try Data(contentsOf: repository.fileURL), oldData)
        let old = LifeJourney.single(try .start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0))
        XCTAssertEqual(JourneySave(journey: old).schemaVersion, 1)
        XCTAssertTrue(old.activeSession.focusSelections.isEmpty)
        XCTAssertTrue(old.activeSession.jumps.allSatisfy { $0.focusEffect == nil })
        var next = old
        try next.chooseFocus(.learning, catalog: catalog)
        XCTAssertEqual(next.activeSession.state, old.activeSession.state)
        XCTAssertEqual(try Data(contentsOf: repository.fileURL), oldData, "Pending changes cannot rewrite the archive before save")
        XCTAssertEqual(JourneySave(journey: next).schemaVersion, 2)
        try repository.save(next, catalog: catalog)
        let written = try Data(contentsOf: repository.fileURL)
        var downgrade = try XCTUnwrap(JSONSerialization.jsonObject(with: written) as? [String: Any])
        downgrade["schemaVersion"] = 1
        try JSONSerialization.data(withJSONObject: downgrade).write(to: repository.fileURL)
        XCTAssertThrowsError(try repository.load(catalog: catalog), "A focused archive cannot masquerade as an older format")
        try written.write(to: repository.fileURL)
        XCTAssertEqual(try repository.load(catalog: catalog), next)
        var resumed = try XCTUnwrap(repository.load(catalog: catalog))
        try resumed.choose("rest", catalog: catalog); try resumed.continueLife(catalog: catalog)
        try next.choose("rest", catalog: catalog); try next.continueLife(catalog: catalog)
        XCTAssertEqual(resumed, next)
        try repository.save(resumed, catalog: catalog)
        XCTAssertEqual(try repository.load(catalog: catalog), resumed)
    }

    private func directory() throws -> URL {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("LC04-tests-" + UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        addTeardownBlock { try FileManager.default.removeItem(at: directory) }
        return directory
    }
    private func completed(_ catalog: ModelCatalog) throws -> LifeSession {
        var life = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        while life.phase != .ended {
            let choices = try life.event(catalog: catalog).choices.filter { try life.preview(choiceID: $0.id, catalog: catalog).applied }
            try life.choose(XCTUnwrap(choices.first).id, catalog: catalog)
            try life.continueLife(catalog: catalog)
        }
        return life
    }

    func testRealDiskRoundTripEveryPhaseKeepsOriginalAndReplaysRemainingLife() throws {
        let catalog = try StatisticsRepository.bundled(), old = try completed(catalog)
        let file = try directory().appendingPathComponent("nested/journey.json")
        let repository = SaveRepository(fileURL: file)
        XCTAssertNil(try repository.load(catalog: catalog))
        var live = LifeJourney.branch(try .start(original: old, decisionIndex: 3, choiceID: "offline", catalog: catalog))
        try repository.save(live, catalog: catalog)
        var resumed = try XCTUnwrap(SaveRepository(fileURL: file).load(catalog: catalog))
        while live.activeSession.phase != .ended {
            XCTAssertEqual(live, resumed)
            XCTAssertEqual(resumed.experiment?.original, old)
            if live.activeSession.phase == .reflecting {
                try live.continueLife(catalog: catalog); try resumed.continueLife(catalog: catalog)
            } else {
                try live.choose("rest", catalog: catalog); try resumed.choose("rest", catalog: catalog)
            }
            try repository.save(resumed, catalog: catalog)
            resumed = try XCTUnwrap(SaveRepository(fileURL: file).load(catalog: catalog))
        }
        XCTAssertEqual(live, resumed)
        let comparison = try BranchComparisonEngine.compare(XCTUnwrap(resumed.experiment), catalog: catalog)
        XCTAssertEqual(comparison.rows.count, 12)
        XCTAssertEqual(comparison.rows.last?.alternative.age, 80)
    }

    func testSingleLifeSaveResumesWithoutChangingLegacySessionResults() throws {
        let catalog = try StatisticsRepository.bundled()
        var journey = LifeJourney.single(try .start(catalog: catalog, countryCode: "USA", householdID: "usa-2", seed: .max))
        let repository = SaveRepository(fileURL: try directory().appendingPathComponent("save.json"))
        try journey.choose("rest", catalog: catalog)
        try repository.save(journey, catalog: catalog)
        var restored = try XCTUnwrap(repository.load(catalog: catalog))
        try journey.continueLife(catalog: catalog); try restored.continueLife(catalog: catalog)
        XCTAssertEqual(journey, restored)
    }

    func testCorruptAndUnknownVersionFilesThrowAndRetainOriginalBytes() throws {
        let catalog = try StatisticsRepository.bundled(), old = try completed(catalog)
        let file = try directory().appendingPathComponent("save.json"), repository: SaveRepository
        repository = SaveRepository(fileURL: file)
        let good = try JSONEncoder().encode(JourneySave(journey: .single(old)))
        var schema = try XCTUnwrap(JSONSerialization.jsonObject(with: good) as? [String: Any]); schema["schemaVersion"] = 999
        let badVersion = try JSONSerialization.data(withJSONObject: schema)
        let engineVersion = Data(String(decoding: good, as: UTF8.self).replacingOccurrences(of: LifeState.engineVersion, with: "unknown-engine").utf8)
        for data in [Data(), Data("{partial".utf8), badVersion, engineVersion] {
            try data.write(to: file)
            XCTAssertThrowsError(try repository.load(catalog: catalog))
            XCTAssertEqual(try Data(contentsOf: file), data)
        }
    }

    func testInvalidSnapshotCannotOverwriteAnExistingValidSave() throws {
        let catalog = try StatisticsRepository.bundled(), old = try completed(catalog)
        let repository = SaveRepository(fileURL: try directory().appendingPathComponent("save.json"))
        try repository.save(.single(old), catalog: catalog)
        let before = try Data(contentsOf: repository.fileURL)
        let fork = try BranchExperiment.start(original: old, decisionIndex: 3, choiceID: "offline", catalog: catalog)
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(fork)) as? [String: Any])
        object["changedChoiceID"] = "rest"
        let forged = try JSONDecoder().decode(BranchExperiment.self, from: JSONSerialization.data(withJSONObject: object))
        XCTAssertThrowsError(try repository.save(.branch(forged), catalog: catalog))
        XCTAssertEqual(try Data(contentsOf: repository.fileURL), before)
        XCTAssertEqual(try repository.load(catalog: catalog), .single(old))
    }

    func testFilesystemFailureDoesNotAlterJourneyOrReplaceOtherPath() throws {
        let catalog = try StatisticsRepository.bundled(), old = try completed(catalog)
        let directory = try directory(), obstruction = directory.appendingPathComponent("not-a-directory")
        let marker = Data("retain".utf8); try marker.write(to: obstruction)
        let repository = SaveRepository(fileURL: obstruction.appendingPathComponent("save.json"))
        XCTAssertThrowsError(try repository.save(.single(old), catalog: catalog))
        XCTAssertEqual(try Data(contentsOf: obstruction), marker)
        XCTAssertThrowsError(try SaveRepository(fileURL: directory).load(catalog: catalog))
    }
}
