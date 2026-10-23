import XCTest
import LifeDomain
import LifeData
@testable import LifeAnalysis

final class BatchAnalysisTests: XCTestCase {
    private let background = BatchBackground(countryCode: "JPN", householdID: "jpn-1", templateID: "supported")
    private func step(age: Int = 8, event: String = "a", variant: String? = nil,
                      before: Int = 98, request: Int = 5, after: Int = 100, clamp: Int = -3) -> BatchStep {
        .init(age: age, eventID: event, storyVariantID: variant, choiceID: "invest", chosenKind: .learn, storyBranch: nil,
              offeredChoiceIDs: ["invest"], availableChoiceIDs: ["invest"],
              resourcesBefore: .init(relationships: before), resourcesAfter: .init(relationships: after),
              requestedDeltaBeforeClamp: .init(relationships: request), clampAdjustment: .init(relationships: clamp),
              candidates: [.init(eventID: event, eligible: true, conditions: [])])
    }
    private func run(_ steps: [BatchStep], jumps: [BatchJump] = [], seed: UInt64 = 0) -> BatchRun {
        .init(runID: "test/\(seed)", background: background, policy: .investFirst, seed: seed,
              initialResources: .init(), finalResources: steps.last?.resourcesAfter ?? .zero, steps: steps, timeJumps: jumps)
    }
    func testRatesDistinguishNoOpportunityFromObservedZero() {
        XCTAssertNil(CountRate(0, of: 0).rate)
        XCTAssertEqual(CountRate(0, of: 8).rate, 0)
        XCTAssertEqual(CountRate(3, of: 8).rate, 0.375)
    }
    func testHammingIncludesZeroAndSeparatesStoryVariantFromEventID() throws {
        let a = run(LifeSession.decisionAges.map { step(age: $0) })
        var steps = a.steps; steps[1] = step(age: 10, variant: "new")
        let b = run(steps, seed: 1)
        steps[2] = step(age: 12, event: "b")
        let c = run(steps, seed: 2)
        let result = try BatchAnalyzer.pairDifferences([(a,b),(a,c),(b,c)])
        XCTAssertEqual(result.pairCount, 3)
        XCTAssertEqual(result.eventIDHamming[0].frequency.count, 1)
        XCTAssertEqual(result.eventIDHamming[1].frequency.count, 2)
        XCTAssertEqual(result.storyRouteHamming[1].frequency.count, 2)
        XCTAssertEqual(result.storyRouteHamming[2].frequency.count, 1)
        XCTAssertThrowsError(try BatchAnalyzer.pairDifferences([(a,run([]))]))
    }
    func testClampUsesNetGainAndSeparatesPartialFullAndLowerBound() throws {
        let r = run([step(), step(before: 100, request: 3, after: 100, clamp: -3),
                     step(before: 100, request: 0, after: 100, clamp: 0),
                     step(before: 1, request: -3, after: 0, clamp: 2)])
        let report = try BatchAnalyzer.clampSummary(runs: [r], isJump: false)
        let result = try XCTUnwrap(report.resources.first { $0.resource == .relationships })
        XCTAssertEqual(report.totalObservations, 4)
        XCTAssertEqual(result.positiveNetGainSteps, 2)
        XCTAssertEqual(result.requestedPositivePoints, 8)
        XCTAssertEqual(result.lostPositivePoints, CountRate(6, of: 8))
        XCTAssertEqual(result.fullyOffsetPositiveSteps, CountRate(1, of: 2))
        XCTAssertEqual(result.lowerBoundAdjustmentPoints, 2)
    }
    func testMultiHookLossIsOneAggregateAndNeverAllocatedToEachHook() throws {
        let hooks = [HookOrigin(hookID: "a", eventID: "a", choiceID: "invest", dueAge: 12, requestedEffect: .init(relationships: 2)),
                     HookOrigin(hookID: "b", eventID: "b", choiceID: "ask", dueAge: 12, requestedEffect: .init(relationships: 2))]
        let jump = BatchJump(fromAge: 10, toAge: 12, resourcesBefore: .init(relationships: 99), resourcesAfter: .init(relationships: 100),
                             requestedDeltaBeforeClamp: .init(relationships: 4), clampAdjustment: .init(relationships: -3), originHooks: hooks)
        let result = try BatchAnalyzer.clampSummary(runs: [run([], jumps: [jump])], isJump: true)
        XCTAssertEqual(result.totalObservations, 1)
        XCTAssertEqual(result.attributions.count, 1)
        XCTAssertEqual(result.attributions[0].kind, .aggregateHookJump)
        XCTAssertEqual(result.attributions[0].originHooks.count, 2)
        XCTAssertEqual(result.attributions[0].lostPositivePoints, CountRate(3, of: 4))
    }
    func testInvalidBatchInputsFailInsteadOfDroppingSamples() throws {
        let catalog = try StatisticsRepository.bundled()
        XCTAssertThrowsError(try BatchAnalyzer.run(catalog: catalog, seeds: []))
        XCTAssertThrowsError(try BatchAnalyzer.run(catalog: catalog, seeds: [1,1]))
        var missing = catalog; missing.households.removeAll { $0.id == "jpn-1" }
        XCTAssertThrowsError(try BatchAnalyzer.run(catalog: missing, seeds: [0]))
    }
    func testPoliciesExecuteDifferentChoicesAndSampleOrderDoesNotChangeReport() throws {
        let catalog = try StatisticsRepository.bundled()
        let a = try BatchAnalyzer.run(catalog: catalog, seeds: [0,1])
        let b = try BatchAnalyzer.run(catalog: catalog, seeds: [1,0])
        XCTAssertEqual(a,b)
        XCTAssertEqual(a.runCount, 64)
        XCTAssertEqual(a.cohorts.count, 32)
        XCTAssertEqual(a.policyComparisons.count, 48)
        XCTAssertTrue(a.cohorts.allSatisfy { $0.seedPairDifferences.pairCount == 1 })
        let same = a.runs.filter { $0.background.countryCode == "JPN" && $0.background.householdID == "jpn-1" && $0.seed == 0 }
        XCTAssertEqual(same.first { $0.policy == .investFirst }?.steps.first?.choiceID, "invest")
        XCTAssertEqual(same.first { $0.policy == .supportFirst }?.steps.first?.choiceID, "ask")
        XCTAssertEqual(same.first { $0.policy == .restFirst }?.steps.first?.choiceID, "rest")
        XCTAssertEqual(try JSONDecoder().decode(BatchReport.self, from: JSONEncoder().encode(a)), a)
    }
}
