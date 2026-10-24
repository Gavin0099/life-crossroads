import XCTest
import Foundation
import LifeDomain
import LifeData
import LifePresentation

final class ProjectMomentTests: XCTestCase {
    private func beforeProject(seed: UInt64 = 0, country: String = "JPN", family: Int = 1) throws -> LifeSession {
        let catalog = try StatisticsRepository.bundled()
        var session = try LifeSession.start(catalog: catalog, countryCode: country,
            householdID: "\(country.lowercased())-\(family)", seed: seed)
        for _ in 0..<3 {
            try session.choose("rest", catalog: catalog)
            try session.continueLife(catalog: catalog)
        }
        XCTAssertEqual(try session.event(catalog: catalog).id, "teen-project")
        return session
    }

    func testFourActualChoicesHaveDistinctPropsMemoryAndOnlyRecordedPeople() throws {
        let catalog = try StatisticsRepository.bundled()
        // Reviewed catalog contract: online/paper/none/none; rest records no teacher interaction.
        for (choice, activity, word) in [("invest", ProjectMoment.Activity.online, "線上"),
                                       ("offline", .paper, "紙本"), ("ask", .ask, "未建立"), ("rest", .rest, "未建立")] {
            var session = try beforeProject()
            try session.choose(choice, catalog: catalog)
            let moment = try XCTUnwrap(ProjectMoment(trace: XCTUnwrap(session.traces.last)))
            XCTAssertEqual(moment.activity, activity)
            XCTAssertTrue(try XCTUnwrap(moment.memory).contains(word))
            XCTAssertEqual(moment.person, choice == "rest" ? nil : "樹老師")
            XCTAssertEqual(moment.pendingCount, choice == "invest" ? 1 : 0)
            XCTAssertEqual(moment.receipt, "teen-project/13/\(choice)/0")
            if choice == "rest" {
                XCTAssertEqual(moment.actualChange, .init(health: 2, relationships: 1))
                XCTAssertEqual(moment.cost, .init())
                XCTAssertEqual(moment.influences, ["你的選擇"])
                XCTAssertTrue(moment.support.isEmpty)
                XCTAssertNil(moment.chance)
            }
        }
    }

    func testUnknownAndUnappliedEventsNeverProduceACommittedReaction() throws {
        let catalog = try StatisticsRepository.bundled()
        let child = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        XCTAssertNil(ProjectMoment(trace: try child.preview(choiceID: "rest", catalog: catalog)))
        var state = try beforeProject().state
        state.remainingTime = 0
        let denied = try DecisionResolver.resolve(state: state, eventID: "teen-project", choiceID: "invest", catalog: catalog).trace
        XCTAssertFalse(denied.applied)
        XCTAssertNil(ProjectMoment(trace: denied))
        var raw = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(denied)) as? [String: Any])
        raw["applied"] = true; raw["choiceID"] = "future-choice"
        let unknown = try JSONDecoder().decode(ConsequenceTrace.self, from: JSONSerialization.data(withJSONObject: raw))
        XCTAssertNil(ProjectMoment(trace: unknown))
    }

    func testActualClampedDeltasAndMissingEnvironmentSurviveProjection() throws {
        let catalog = try StatisticsRepository.bundled()
        var state = try beforeProject(country: "TWN").state
        state.resources = .init(health: 100, financial: 100, relationships: 100, skills: 100)
        let trace = try DecisionResolver.resolve(state: state, eventID: "teen-project", choiceID: "invest", catalog: catalog).trace
        let moment = try XCTUnwrap(ProjectMoment(trace: trace))
        XCTAssertEqual(moment.actualChange, .init(financial: -1))
        XCTAssertFalse(moment.gaps.isEmpty)
        XCTAssertTrue(moment.gaps[0].contains("未知環境成本不是0"))
        // An illustration must not replace actual capped gains with the option's advertised +4 skills.
        XCTAssertEqual(moment.actualChange.skills, 0)
    }

    func testChanceBadgeRequiresAnOccurredNonzeroEffectAndNoNewDraw() throws {
        let catalog = try StatisticsRepository.bundled()
        var sawBoth = Set<Bool>()
        for seed: UInt64 in 0..<16 {
            let before = try beforeProject(seed: seed)
            let trace = try before.preview(choiceID: "offline", catalog: catalog)
            let moment = try XCTUnwrap(ProjectMoment(trace: trace))
            sawBoth.insert(trace.randomTrial?.occurred == true)
            XCTAssertEqual(moment.chance != nil, trace.randomTrial?.occurred == true)
            XCTAssertFalse(moment.support.isEmpty)
            XCTAssertEqual(ProjectMoment(trace: trace), moment)
            XCTAssertEqual(before.traces.count, 3, "Projection must leave the session untouched")
        }
        XCTAssertEqual(sawBoth, [true, false])
    }

    func testCodableRestoreAndFixedSeedReplayProduceIdenticalPresentation() throws {
        let catalog = try StatisticsRepository.bundled()
        var original = try beforeProject()
        try original.choose("offline", catalog: catalog)
        let restored = try JSONDecoder().decode(LifeSession.self, from: JSONEncoder().encode(original))
        var replay = try beforeProject()
        try replay.choose("offline", catalog: catalog)
        let trace = try XCTUnwrap(original.traces.last)
        XCTAssertEqual(original, replay)
        XCTAssertEqual(ProjectMoment(trace: trace), ProjectMoment(trace: try XCTUnwrap(restored.traces.last)))
        XCTAssertEqual(ProjectMoment(trace: trace), ProjectMoment(trace: try XCTUnwrap(replay.traces.last)))
    }

    func testForkUsesItsOwnReactionWithoutRewritingOriginalAndRestoresBoth() throws {
        let catalog = try StatisticsRepository.bundled()
        var original = try beforeProject()
        try original.choose("offline", catalog: catalog)
        while original.phase != .ended {
            if original.phase == .reflecting { try original.continueLife(catalog: catalog) }
            else { try original.choose("rest", catalog: catalog) }
        }
        let frozen = original
        let originalMoment = try XCTUnwrap(ProjectMoment(trace: original.traces[3]))
        let fork = try BranchExperiment.start(original: original, decisionIndex: 3, choiceID: "ask", catalog: catalog)
        XCTAssertEqual(fork.original, frozen)
        XCTAssertEqual(ProjectMoment(trace: fork.original.traces[3]), originalMoment)
        let changed = try XCTUnwrap(ProjectMoment(trace: fork.alternative.traces[3]))
        XCTAssertEqual(originalMoment.activity, .paper)
        XCTAssertEqual(changed.activity, .ask)
        XCTAssertTrue(try XCTUnwrap(changed.memory).contains("未建立"))
        let restored = try JSONDecoder().decode(BranchExperiment.self, from: JSONEncoder().encode(fork))
        try restored.validate(catalog: catalog)
        XCTAssertEqual(ProjectMoment(trace: restored.original.traces[3]), originalMoment)
        XCTAssertEqual(ProjectMoment(trace: restored.alternative.traces[3]), changed)
    }
}
