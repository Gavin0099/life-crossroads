import Foundation
import LifeDomain

public struct ExperienceRun: Codable, Equatable, Sendable {
    public let country: String
    public let household: String
    public let seed: UInt64
    public let policy: BatchPolicy
    public let focus: [LifeFocusSelection]
    public let events: [String]
    public let choices: [String]
    public let variants: [String?]
    public let connections: [StoryConnection]
    public let environmentReceipts: [ConsequenceTrace]
    public let finalResources: ResourceValues
    public let replayMatched: Bool
}
public struct ExperienceAuditReport: Codable, Equatable, Sendable {
    public let version: String
    public let engineVersion: String
    public let contentVersion: String
    public let seeds: [UInt64]
    public let policies: [BatchPolicy]
    public let policyDescription: String
    public let eventCounts: [String: Int]
    public let unobservedEvents: [String]
    public let runs: [ExperienceRun]
    public let claimBoundary: String
}
public enum ExperienceAudit {
    public static func run(catalog: ModelCatalog, seeds: [UInt64]) throws -> ExperienceAuditReport {
        guard !seeds.isEmpty, Set(seeds).count == seeds.count else { throw ModelError.invalid("audit seeds") }
        var runs: [ExperienceRun] = [], counts: [String: Int] = [:]
        for family in catalog.households.sorted(by: { $0.id < $1.id }) {
            for policy in BatchPolicy.allCases {
                for seed in seeds.sorted() {
                    var life = try LifeSession.start(catalog: catalog, countryCode: family.countryCode, householdID: family.id, seed: seed)
                    while life.phase != .ended {
                        let focus: LifeFocus
                        switch policy {
                        case .investFirst: focus = life.state.age < 23 ? .learning : .stability
                        case .supportFirst: focus = .relationships
                        case .restFirst: focus = .recovery
                        case .seededVariety: focus = LifeFocus.available(at: life.state.age)[Int(seed % UInt64(LifeFocus.available(at: life.state.age).count))]
                        }
                        if life.state.age < 80 { try life.chooseFocus(focus, catalog: catalog) }
                        let event = try life.event(catalog: catalog)
                        let available = try event.choices.filter { try life.preview(choiceID: $0.id, catalog: catalog).applied }
                        let supportive = ["confirmHelp", "returnHelp", "reviewShared", "pacedRole"].first { id in available.contains { $0.id == id } }
                        let prepared = ["shareDraft", "makeTime", "pacedRole", "stagedPlan", "poweredBench", "portableKit", "benchWork", "mobileRepair", "reserveVisit", "sharedPlan", "reviewVisit", "reviewShared"].first { id in available.contains { $0.id == id } }
                        let priority = policy == .supportFirst ? supportive : policy == .investFirst ? prepared : nil
                        let choice = try priority ?? BatchAnalyzer.choose(policy: policy, available: available, seed: seed, eventID: event.id, age: life.state.age)
                        try life.choose(choice, catalog: catalog); try life.continueLife(catalog: catalog)
                    }
                    let restored = try LifeSession.restore(from: JSONEncoder().encode(life), catalog: catalog)
                    guard restored == life, life.traces.count == 15 else { throw ModelError.invalid("audit replay or length") }
                    for trace in life.traces { counts[trace.eventID, default: 0] += 1 }
                    runs.append(.init(country: family.countryCode, household: family.id, seed: seed, policy: policy,
                        focus: life.focusSelections, events: life.traces.map(\.eventID), choices: life.traces.map(\.choiceID),
                        variants: life.traces.map(\.storyVariantID), connections: try StoryConnections.evaluate(life, catalog: catalog),
                        environmentReceipts: life.traces.filter { $0.storyBranch?.environmentOpportunity != nil },
                        finalResources: life.state.resources, replayMatched: true))
                }
            }
        }
        return .init(version: "experience-audit-1", engineVersion: LifeState.engineVersion, contentVersion: catalog.contentVersion,
            seeds: seeds.sorted(), policies: BatchPolicy.allCases,
            policyDescription: "investFirst：前期學習、成年穩定重心，優先採取已開放的準備/工具/看診延續行動，再用舊投入策略；supportFirst：關係重心，先確認/自願回應已開放的支持，再用舊求助策略；restFirst：恢復重心與休息；mixed：依Seed選可用重心，事件行動依原獨立策略亂數。這不是同一選擇純環境比較。",
            eventCounts: counts, unobservedEvents: catalog.decisions.map(\.id).filter { counts[$0] == nil }.sorted(), runs: runs,
            claimBoundary: "八國16虛構家庭的有限工程樣本；臺灣缺值保持未知。故事連結需真實前因及可行延續行動，另分是否接受；不是兒童理解、娛樂性、真實機率或整體完成百分比。未觀察到不等於不可達。")
    }
}
