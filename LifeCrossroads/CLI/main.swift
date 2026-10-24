import Foundation
import LifeData
import LifeDomain
import LifeAnalysis

struct Comparison: Codable {
    let country: String
    let household: String
    let trace: ConsequenceTrace
}
struct SkeletonRun: Codable {
    let country: String
    let household: String
    let finalAge: Int
    let decisionCount: Int
    let storyCallbacks: Int
    let decisionIDs: [String]
    let decisionAges: [Int]
    let finalResources: ResourceValues
    let storyOrigins: [String]
}
struct DemoEvidence: Codable {
    let purpose: String
    let dataVersion: String
    let comparison: [Comparison]
    let skeletonRuns: [SkeletonRun]
}

do {
    let mode = try DemoCLIArguments.parse(Array(CommandLine.arguments.dropFirst()))
    let catalog = try StatisticsRepository.bundled()
    if mode == .environmentSamples {
        let report = try EnvironmentSampleRunner.evidence(catalog: catalog)
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        print(String(decoding: try encoder.encode(report), as: UTF8.self))
        exit(0)
    }
    if mode == .branchSample {
        let sample = try BranchSampleRunner.evidence(catalog: catalog)
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        print(String(decoding: try encoder.encode(sample), as: UTF8.self))
        exit(0)
    }
    if case .batchReport(let seedCount) = mode {
        let report = try BatchAnalyzer.run(catalog: catalog, seeds: (0..<seedCount).map(UInt64.init))
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        print(String(decoding: try encoder.encode(report), as: UTF8.self))
        exit(0)
    }
    if mode == .storySamples {
        let evidence = try StorySampleRunner.evidence(catalog: catalog)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        print(String(decoding: try encoder.encode(evidence), as: UTF8.self))
        exit(0)
    }
    let firstCountries = ["JPN", "USA", "IND", "KEN"]
    var comparison: [Comparison] = []
    var runs: [SkeletonRun] = []
    for code in firstCountries {
        let name = catalog.countries.first { $0.code == code }!.name
        for number in 1...2 {
            let householdID = "\(code.lowercased())-\(number)"
            let born = try LifeState.born(catalog: catalog, countryCode: code, householdID: householdID, seed: 42)
            let (teen, _) = try SimulationEngine.advance(born, to: 13, catalog: catalog)
            let result = try DecisionResolver.resolve(state: teen, eventID: "teen-project", choiceID: "invest", catalog: catalog)
            comparison.append(.init(country: name, household: householdID, trace: result.trace))
            var session = try LifeSession.start(catalog: catalog, countryCode: code, householdID: householdID, seed: 42)
            while session.phase != .ended {
                guard session.traces.count < session.plannedDecisionCount else { throw ModelError.invalid("demo exceeded life length") }
                let event = try session.event(catalog: catalog)
                let available = try event.choices.filter { try session.preview(choiceID: $0.id, catalog: catalog).applied }
                let choiceID = try StorySampleRunner.choose(from: available)
                try session.choose(choiceID, catalog: catalog)
                try session.continueLife(catalog: catalog)
            }
            let state = session.state
            let traces = session.traces
            runs.append(.init(country: name, household: householdID, finalAge: state.age,
                              decisionCount: state.decisions.count, storyCallbacks: state.memories.count,
                              decisionIDs: traces.map(\.eventID), decisionAges: traces.map(\.age),
                              finalResources: state.resources, storyOrigins: state.memories.map(\.originEventID)))
        }
    }
    let evidence = DemoEvidence(purpose: "純 Swift 執行證據：四國完整人生與背景比較；不是實機或死亡模擬。",
                                dataVersion: catalog.dataVersion, comparison: comparison, skeletonRuns: runs)
    if mode == .json {
        let encoder = JSONEncoder(); encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        print(String(decoding: try encoder.encode(evidence), as: UTF8.self))
    } else {
        print("人生岔路｜同一項13歲選擇：投入線上學習（Seed 42）")
        for item in comparison {
            let trace = item.trace
            print("\(item.country) / \(item.household)：時間\(trace.finalCost.time)，材料\(trace.finalCost.materials)，健康變化\(trace.resourcesAfter.health - trace.resourcesBefore.health)")
        }
        print("四國八家庭：每局五階段15項決策，從出生推進至80歲回顧；實際事件與人物呼應見 --json。")
        print("資料為背景，成本與後果為明示的遊戲假設。--story-samples 提供固定背景、三個預定 Seed 的故事與重播核驗。")
    }
} catch {
    // CLI failures remain non-zero, so CI cannot mistake missing evidence for success.
    FileHandle.standardError.write(Data("life-demo failed: \(error)\n".utf8))
    exit(1)
}
