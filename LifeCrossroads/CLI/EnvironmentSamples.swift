import Foundation
import LifeDomain
import LifeAnalysis

struct EnvironmentSample: Codable {
    let eventID: String
    let age: Int
    let choiceID: String
    let seed: UInt64
    let comparisons: [EnvironmentComparison]
    let householdComparison: [ConsequenceTrace]
}
struct EnvironmentRun: Codable {
    let countryCode: String
    let householdID: String
    let seed: UInt64
    let policy: String
    let traces: [ConsequenceTrace]
    let replayAndRestoreMatch: Bool
}
struct EnvironmentEvidence: Codable {
    let engineVersion: String
    let dataVersion: String
    let claimBoundary: String
    let samples: [EnvironmentSample]
    let runs: [EnvironmentRun]
    let policies: [PolicyDefinition]
}

enum EnvironmentSampleRunner {
    static func evidence(catalog: ModelCatalog) throws -> EnvironmentEvidence {
        let codes = catalog.countries.map(\.code)
        var samples: [EnvironmentSample] = []
        var observed = Set<String>()
        // Actual selected events, not forced catalog events. Include three different choices with
        // environment rules, plus the offline equality case. Search is bounded and recorded.
        for seed in UInt64(0)..<16 where observed.count < 4 {
            var session = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: seed)
            while session.phase != .ended {
                let event = try session.event(catalog: catalog)
                if ["child-interest", "teen-project", "adult-care", "middle-support"].contains(event.id), !observed.contains(event.id) {
                    let traces = try session.compare(choiceID: "invest", countryCodes: codes, catalog: catalog)
                    let rows = try traces.map { trace in
                        var before = session.state
                        before.countryCode = trace.countryCode; before.householdID = trace.householdID
                        return try EnvironmentComparisonEngine.preview(state: before, eventID: event.id, choiceID: "invest", catalog: catalog)
                    }
                    samples.append(.init(eventID: event.id, age: session.state.age, choiceID: "invest", seed: seed,
                                         comparisons: rows, householdComparison: try session.compareHouseholds(choiceID: "invest", catalog: catalog)))
                    observed.insert(event.id)
                }
                let offered = try event.choices.filter { try session.preview(choiceID: $0.id, catalog: catalog).applied }
                let choice = offered.first { $0.id == "invest" } ?? offered.first { $0.id == "ask" } ?? offered.first { $0.id == "rest" }
                guard let choice else { throw ModelError.invalid("no recovery in sample") }
                try session.choose(choice.id, catalog: catalog); try session.continueLife(catalog: catalog)
            }
        }
        guard observed.count == 4 else { throw ModelError.missing("three environmental choices and offline equality witness") }
        var runs: [EnvironmentRun] = []
        for family in catalog.households.sorted(by: { $0.id < $1.id }) {
            for policy in BatchPolicy.allCases {
              for seed: UInt64 in [0, 3] {
                var life = try LifeSession.start(catalog: catalog, countryCode: family.countryCode, householdID: family.id, seed: seed)
                var replay = life
                while life.phase != .ended {
                    let event = try life.event(catalog: catalog)
                    let offered = try event.choices.filter { try life.preview(choiceID: $0.id, catalog: catalog).applied }
                    let choiceID = try BatchAnalyzer.choose(policy: policy, available: offered, seed: seed, eventID: event.id, age: life.state.age)
                    try life.choose(choiceID, catalog: catalog); try replay.choose(choiceID, catalog: catalog)
                    try life.continueLife(catalog: catalog); try replay.continueLife(catalog: catalog)
                }
                let restored = try LifeSession.restore(from: JSONEncoder().encode(life), catalog: catalog)
                guard restored == life, replay == life else { throw ModelError.invalid("environment evidence replay") }
                runs.append(.init(countryCode: family.countryCode, householdID: family.id, seed: seed,
                                  policy: policy.rawValue, traces: life.traces, replayAndRestoreMatch: true))
              }
            }
        }
        return .init(engineVersion: LifeState.engineVersion, dataVersion: catalog.dataVersion,
                     claimBoundary: "八國16虛構家庭×4明列策略×Seed0/3（3為0～15搜尋中的照顧呼應見證）；實際抽中事件的同選擇快照比較固定前史/資源/Seed/家庭模板。台灣未知成本不作定量結論；完整各國人生另保留實際後續選擇，不能歸因於國籍或一項改選。不是娛樂性、教育效果、實機或全球抽樣證據。",
                     samples: samples, runs: runs, policies: BatchPolicy.allCases.map(BatchAnalyzer.definition))
    }
}
