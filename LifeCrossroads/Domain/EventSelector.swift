import Foundation

public enum EventSchedule {
    public static let decisionAges = [8, 10, 12, 13, 17, 21, 25, 32, 39, 45, 52, 59, 65, 72, 80]
}

public enum EventConditionKind: String, Codable, Sendable {
    case resourceAtLeast, resourceAtMost, householdAtLeast, priorChoice
}

public struct EventCondition: Codable, Equatable, Sendable {
    public var id: String
    public var kind: EventConditionKind
    /// Resource/family field, or an earlier event ID for priorChoice.
    public var key: String
    public var threshold: Int?
    public var choiceIDs: [String]
}

public struct EventConditionEvaluation: Codable, Equatable, Sendable {
    public let condition: EventCondition
    public let actualValue: Int?
    public let actualChoiceID: String?
    public let matched: Bool
}

public struct EventCandidateEvaluation: Codable, Equatable, Sendable {
    public let eventID: String
    public let isFallback: Bool
    public let conditions: [EventConditionEvaluation]
    public let eligible: Bool
}

/// How a situation was encountered, distinct from the later choice's cost/resource causes.
public struct EventSelectionTrace: Codable, Equatable, Sendable {
    public let algorithm: String
    public let seed: UInt64
    public let age: Int
    public let key: String
    public let draw: Double
    public let candidates: [EventCandidateEvaluation]
    public let eligibleEventIDs: [String]
    public let selectedEventID: String
    public let assumptionID: String
    public var summary: String {
        eligibleEventIDs.count == 1
            ? "\(age)歲這個階段只有一個符合目前條件的情境，接續這段故事。"
            : "\(age)歲有\(eligibleEventIDs.count)個符合目前條件的情境；這次用固定Seed遇見其中之一。"
    }
}

public enum EventSelector {
    public static let version = "conditional-slots-v1"

    public static func select(state: LifeState, catalog: ModelCatalog) throws -> EventSelectionTrace {
        try catalog.validate()
        try state.validate(catalog: catalog)
        guard EventSchedule.decisionAges.contains(state.age),
              let household = catalog.households.first(where: { $0.id == state.householdID }),
              household.countryCode == state.countryCode else { throw ModelError.invalid("event selection context") }
        func value(_ key: String) -> Int? {
            switch key {
            case "health": state.resources.health
            case "financial": state.resources.financial
            case "relationships": state.resources.relationships
            case "skills": state.resources.skills
            default: nil
            }
        }
        func familyValue(_ key: String) -> Int? {
            switch key {
            case "mentorSupport": household.mentorSupport
            case "careLoad": household.careLoad
            case "travelCost": household.travelCost
            case "materialBudget": household.materialBudget
            default: nil
            }
        }
        let candidates = catalog.decisions.filter { $0.age == state.age }.sorted { $0.id < $1.id }.map { event in
            let conditions = event.eligibility.sorted { $0.id < $1.id }.map { condition -> EventConditionEvaluation in
                var actualValue: Int? = nil
                var actualChoiceID: String? = nil
                var matched = false
                switch condition.kind {
                case .resourceAtLeast, .resourceAtMost:
                    actualValue = value(condition.key)
                    if let actualValue, let threshold = condition.threshold {
                        matched = condition.kind == .resourceAtLeast ? actualValue >= threshold : actualValue <= threshold
                    }
                case .householdAtLeast:
                    actualValue = familyValue(condition.key)
                    if let actualValue, let threshold = condition.threshold { matched = actualValue >= threshold }
                case .priorChoice:
                    actualChoiceID = state.decisions.first(where: { $0.eventID == condition.key })?.choiceID
                    if let actualChoiceID { matched = condition.choiceIDs.contains(actualChoiceID) }
                }
                return .init(condition: condition, actualValue: actualValue, actualChoiceID: actualChoiceID, matched: matched)
            }
            return EventCandidateEvaluation(eventID: event.id, isFallback: event.isFallback, conditions: conditions,
                                            eligible: conditions.allSatisfy(\.matched))
        }
        let eligible = candidates.filter(\.eligible).map(\.eventID)
        guard !eligible.isEmpty, candidates.contains(where: { $0.isFallback && $0.eligible }) else {
            throw ModelError.missing("eligible fallback event")
        }
        let key = KeyedRandom.key(eventID: "life-slot", age: state.age, channel: version)
        let draw = KeyedRandom.draw(seed: state.seed, key: key)
        let index = min(eligible.count - 1, Int(draw * Double(eligible.count)))
        return .init(algorithm: KeyedRandom.version + "+" + version, seed: state.seed, age: state.age,
                     key: key, draw: draw, candidates: candidates, eligibleEventIDs: eligible,
                     selectedEventID: eligible[index], assumptionID: "event-selection")
    }
}
