import Foundation
import LifeDomain

/// Reviewable execution sample. The harness policy is disclosed; the App has no automatic choices.
struct BranchSampleEvidence: Codable {
    let purpose: String
    let baselinePolicy: String
    let alternativePolicy: String
    let checkpointAge: Int
    let experiment: BranchExperiment
    let comparison: BranchComparison
    let originalReplayIdentical: Bool
    let alternativeReplayIdentical: Bool
    let restoredEveryStepIdentical: Bool
}

enum BranchSampleRunner {
    static func evidence(catalog: ModelCatalog) throws -> BranchSampleEvidence {
        var original = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        while original.phase != .ended {
            let available = try original.event(catalog: catalog).choices.filter { try original.preview(choiceID: $0.id, catalog: catalog).applied }
            let choice = try StorySampleRunner.choose(from: available)
            try original.choose(choice, catalog: catalog)
            try original.continueLife(catalog: catalog)
        }
        let forkIndex = 3
        var experiment = try BranchExperiment.start(original: original, decisionIndex: forkIndex, choiceID: "offline", catalog: catalog)
        let fork = experiment
        while experiment.alternative.phase != .ended {
            if experiment.alternative.phase == .reflecting { try experiment.continueLife(catalog: catalog) }
            else { try experiment.choose("rest", catalog: catalog) }
            let restored = try JSONDecoder().decode(BranchExperiment.self, from: JSONEncoder().encode(experiment))
            try restored.validate(catalog: catalog)
            guard restored == experiment else { throw ModelError.invalid("branch sample restore mismatch") }
            experiment = restored
        }
        var replay = fork
        for trace in experiment.alternative.traces.dropFirst(forkIndex + 1) {
            try replay.continueLife(catalog: catalog)
            try replay.choose(trace.choiceID, catalog: catalog)
        }
        try replay.continueLife(catalog: catalog)
        let originalReplay = try LifeSession.restore(from: JSONEncoder().encode(original), catalog: catalog)
        guard replay == experiment, originalReplay == original else { throw ModelError.invalid("branch sample replay mismatch") }
        return .init(purpose: "模型內實際執行的兩條完整人生；不是兒少或現實因果證據。",
                     baselinePolicy: "樣本工具優先投入、再其他可行主動選項、求助、休息。",
                     alternativePolicy: "樣本工具在13歲改選紙本，其後每步選休息。這是明示的測試策略；App由玩家親選。",
                     checkpointAge: 13, experiment: experiment,
                     comparison: try BranchComparisonEngine.compare(experiment, catalog: catalog),
                     originalReplayIdentical: true, alternativeReplayIdentical: true, restoredEveryStepIdentical: true)
    }
}
