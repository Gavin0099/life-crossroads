import Foundation

public struct BranchComparisonRow: Codable, Equatable, Sendable {
    public let decisionIndex: Int
    public let original: ConsequenceTrace
    public let alternative: ConsequenceTrace
    public let originalArrival: TimeJumpTrace
    public let alternativeArrival: TimeJumpTrace
    public var storyChanged: Bool {
        original.eventID != alternative.eventID || original.storyVariantID != alternative.storyVariantID
            || original.recurringPerson != alternative.recurringPerson
            || original.storyBranch?.offeredChoiceIDs != alternative.storyBranch?.offeredChoiceIDs
    }
    public var sameAction: Bool { original.eventID == alternative.eventID && original.choiceID == alternative.choiceID }
}

public struct BranchComparison: Codable, Equatable, Sendable {
    public let forkIndex: Int
    public let rows: [BranchComparisonRow]
    public let originalFinal: ResourceValues
    public let alternativeFinal: ResourceValues
    public var laterDifferentActions: Int { rows.dropFirst().filter { !$0.sameAction }.count }
    public var scopeExplanation: String {
        "國家、家庭、岔路前歷史、版本與種子相同；共有機會沿用相同亂數鍵。改選後每一步由你親自選擇，沒有自動代選。後續有\(laterDifferentActions)個時點的事件或行動不同，因此不能把所有差異只歸因於最初那一步。這是模型內的另一種可能，不是現實因果證明，也沒有較成功的人生。"
    }
}

public enum BranchComparisonEngine {
    public static func compare(_ experiment: BranchExperiment, catalog: ModelCatalog) throws -> BranchComparison {
        try experiment.validate(catalog: catalog)
        guard experiment.alternative.phase == .ended else { throw ModelError.invalid("comparison needs both complete lives") }
        let original = experiment.original, alternative = experiment.alternative
        let rows = (experiment.snapshot.decisionIndex..<original.traces.count).map { index in
            BranchComparisonRow(decisionIndex: index, original: original.traces[index], alternative: alternative.traces[index],
                                originalArrival: original.jumps[index], alternativeArrival: alternative.jumps[index])
        }
        return .init(forkIndex: experiment.snapshot.decisionIndex, rows: rows,
                     originalFinal: original.state.resources, alternativeFinal: alternative.state.resources)
    }
}
