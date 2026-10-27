import Foundation

public struct AvailableAction: Codable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let cost: Cost
    public let environmentGaps: [String]
}

public struct EnvironmentComparison: Codable, Equatable, Sendable {
    public let trace: ConsequenceTrace
    public let availableAlternatives: [AvailableAction]
}

public enum EnvironmentComparisonEngine {
    /// Compare an actual snapshot. This does not replace the original or silently play the future.
    public static func preview(state: LifeState, eventID: String, choiceID: String,
                               catalog: ModelCatalog) throws -> EnvironmentComparison {
        let result = try DecisionResolver.resolve(state: state, eventID: eventID, choiceID: choiceID, catalog: catalog)
        guard let original = catalog.decisions.first(where: { $0.id == eventID }) else { throw ModelError.missing("comparison event") }
        let event = try StoryBranchEngine.project(event: original, state: state, catalog: catalog).event
        let alternatives = try event.choices.filter { $0.id != choiceID }.compactMap { choice -> AvailableAction? in
            let trace = try DecisionResolver.resolve(state: state, eventID: eventID, choiceID: choice.id, catalog: catalog).trace
            guard trace.applied else { return nil }
            return .init(id: choice.id, title: choice.title, cost: trace.finalCost, environmentGaps: trace.environmentGaps)
        }
        return .init(trace: result.trace, availableAlternatives: alternatives)
    }
}
