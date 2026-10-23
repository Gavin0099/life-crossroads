import Foundation
import LifeData
import LifeDomain

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
    if CommandLine.arguments.contains("--director-audit") {
        try runDirectorAudit()
        exit(0)
    }
    let catalog = try StatisticsRepository.bundled()
    let firstCountries = ["JPN", "USA", "IND", "KEN"]
    var comparison: [Comparison] = []
    var runs: [SkeletonRun] = []
    for code in firstCountries {
        let name = catalog.countries.first { $0.code == code }!.name
        for number in 1...2 {
            let householdID = "\(code.lowercased())-\(number)"
            var state = try LifeState.born(catalog: catalog, countryCode: code, householdID: householdID, seed: 42)
            let (teen, _) = try SimulationEngine.advance(state, to: 13, catalog: catalog)
            let result = try DecisionResolver.resolve(state: teen, eventID: "teen-project", choiceID: "invest", catalog: catalog)
            comparison.append(.init(country: name, household: householdID, trace: result.trace))
            var traces: [ConsequenceTrace] = []
            for event in catalog.decisions {
                (state, _) = try SimulationEngine.advance(state, to: event.age, catalog: catalog)
                var result = try DecisionResolver.resolve(state: state, eventID: event.id, choiceID: "invest", catalog: catalog)
                if !result.trace.applied {
                    result = try DecisionResolver.resolve(state: state, eventID: event.id, choiceID: "ask", catalog: catalog)
                }
                guard result.trace.applied else { throw ModelError.invalid("demo cannot advance") }
                state = result.state; traces.append(result.trace)
            }
            runs.append(.init(country: name, household: householdID, finalAge: state.age,
                              decisionCount: state.decisions.count, storyCallbacks: state.memories.count,
                              decisionIDs: traces.map(\.eventID), decisionAges: traces.map(\.age),
                              finalResources: state.resources, storyOrigins: state.memories.map(\.originEventID)))
        }
    }
    let evidence = DemoEvidence(purpose: "LC-01 執行證據：決策骨架與背景比較；不是 SwiftUI 可玩版或死亡模擬。",
                                dataVersion: catalog.dataVersion, comparison: comparison, skeletonRuns: runs)
    if CommandLine.arguments.contains("--json") {
        let encoder = JSONEncoder(); encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        print(String(decoding: try encoder.encode(evidence), as: UTF8.self))
    } else {
        print("人生岔路 LC-01｜同一項13歲選擇：投入時間一起學習（Seed 42）")
        for item in comparison {
            let trace = item.trace
            print("\(item.country) / \(item.household)：時間\(trace.finalCost.time)，材料\(trace.finalCost.materials)，健康變化\(trace.resourcesAfter.health - trace.resourcesBefore.health)")
        }
        print("四國八家庭：每段骨架均從出生推進至80歲回顧，15項決策；每段3次人物呼應。")
        print("資料為背景，成本與後果為明示的遊戲假設。SwiftUI、實機與兒少試玩仍待 LC-02 以後驗證。")
    }
} catch {
    // CLI failures remain non-zero, so CI cannot mistake missing evidence for success.
    let operation = CommandLine.arguments.contains("--director-audit") ? "Event Director audit" : "LC-01 demo"
    FileHandle.standardError.write(Data("\(operation) failed: \(error)\n".utf8))
    exit(1)
}
