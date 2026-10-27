import Foundation

public enum EventSchedule {
    public static let milestones = [8: "child-interest", 10: "child-friend", 13: "teen-project", 39: "adult-care", 80: "later-review"]
    public static let decisionAges = [8, 10, 12, 13, 17, 21, 25, 32, 39, 45, 52, 59, 65, 72, 80]
}

public enum EventConditionKind: String, Codable, Sendable {
    case resourceAtLeast, resourceAtMost, householdAtLeast, priorChoice, storyFlag, relationshipAtLeast
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
    public let exclusions: [String]
    public let policy: EventPolicy
    public let baseWeight: Double
    public let weightSteps: [EventWeightStep]
    public let finalWeight: Double
    public let randomKey: String
    public let uniform: Double
    public let raceScore: Double?
}
public struct EventWeightStep: Codable, Equatable, Sendable {
    public let ruleID: String
    public let input: String
    public let multiplier: Double
}

/// How a situation was encountered, distinct from the later choice's cost/resource causes.
public struct EventSelectionTrace: Codable, Equatable, Sendable {
    public let rules: SelectionRules
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
            : "\(age)歲有\(eligibleEventIDs.count)個符合目前條件的情境；過去的故事與近期經歷會影響遇見機會，這次也有偶然的成分。"
    }
}


public enum EventSelector {
    public static let version = "independent-exponential-race-v2"
    public static func resource(_ key: String, in state: LifeState) -> Int? {
        switch key {
        case "health": state.resources.health
        case "financial": state.resources.financial
        case "relationships": state.resources.relationships
        case "skills": state.resources.skills
        default: nil
        }
    }
    public static func select(state: LifeState, catalog: ModelCatalog) throws -> EventSelectionTrace {
        try catalog.validate(); try state.validate(catalog: catalog)
        guard EventSchedule.decisionAges.contains(state.age),
              let household = catalog.households.first(where: { $0.id == state.householdID }) else {
            throw ModelError.invalid("event selection context")
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
        let appointment = CreativeOpportunityRules.appointment(state)
        let rules = catalog.selectionRules
        let candidates = catalog.decisions.sorted { $0.id < $1.id }.map { event -> EventCandidateEvaluation in
            let policy = event.selection
            let conditions = event.eligibility.sorted { $0.id < $1.id }.map { condition -> EventConditionEvaluation in
                var actualValue: Int?, actualChoiceID: String?
                var matched = false
                switch condition.kind {
                case .resourceAtLeast, .resourceAtMost:
                    actualValue = resource(condition.key, in: state)
                    if let actualValue, let threshold = condition.threshold {
                        matched = condition.kind == .resourceAtLeast ? actualValue >= threshold : actualValue <= threshold
                    }
                case .householdAtLeast:
                    actualValue = familyValue(condition.key)
                    if let actualValue, let threshold = condition.threshold { matched = actualValue >= threshold }
                case .priorChoice:
                    actualChoiceID = state.decisions.last(where: { $0.eventID == condition.key })?.choiceID
                    if let actualChoiceID { matched = condition.choiceIDs.contains(actualChoiceID) }
                case .storyFlag:
                    actualChoiceID = state.story.fact(condition.key)?.value
                    if let actualChoiceID { matched = condition.choiceIDs.contains(actualChoiceID) }
                case .relationshipAtLeast:
                    actualValue = state.story.relationships.first { $0.personID == condition.key }?.familiarity ?? 0
                    if let actualValue, let threshold = condition.threshold { matched = actualValue >= threshold }
                }
                return .init(condition: condition, actualValue: actualValue, actualChoiceID: actualChoiceID, matched: matched)
            }
            var exclusions: [String] = []
            if let appointment, event.id != appointment.event {
                exclusions.append("creative-opportunities-1:followup:\(appointment.origin.eventID)@\(appointment.origin.age):\(appointment.origin.choiceID)")
            }
            if !policy.includes(state.age) { exclusions.append("age-window") }
            if let milestone = EventSchedule.milestones[state.age], event.id != milestone { exclusions.append("milestone-slot") }
            if let last = state.story.events.lastIndex(where: { $0.eventID == event.id }) {
                if !policy.repeatable { exclusions.append("one-shot") }
                if state.story.events.count - last - 1 < policy.cooldownDecisions { exclusions.append("cooldown") }
            }
            if let group = policy.exclusiveGroup,
               state.story.events.contains(where: { $0.exclusiveGroup == group && $0.eventID != event.id }) { exclusions.append("exclusive-group") }
            exclusions += conditions.filter { !$0.matched }.map { "condition:" + $0.condition.id }
            var weight = policy.baseWeight
            var steps: [EventWeightStep] = []
            func multiply(_ rule: String, _ input: String, _ factor: Double) {
                weight *= factor; steps.append(.init(ruleID: rule, input: input, multiplier: factor))
            }
            if let key = policy.continuityFlag, let fact = state.story.fact(key), policy.continuityValues.contains(fact.value) {
                multiply("story-continuity", "\(key)=\(fact.value)@\(fact.eventID):\(fact.age)", rules.continuityMultiplier)
            }
            if let focus = policy.focusAffinity, let memory = state.focusHistory.last(where: { $0.focus == focus }) {
                multiply("completed-life-focus", "\(focus.rawValue)@\(memory.fromAge)-\(memory.toAge)", rules.continuityMultiplier)
            }
            if let person = policy.relationshipID,
               let relationship = state.story.relationships.first(where: { $0.personID == person }), relationship.familiarity > 0 {
                multiply("known-person", "\(person)=\(relationship.familiarity)", rules.relationshipMultiplier)
            }
            if state.story.events.suffix(rules.recentCategoryWindow).contains(where: { $0.category == policy.category }) {
                multiply("recent-category", policy.category, rules.recentCategoryMultiplier)
            }
            for adjustment in policy.resourceWeights.sorted(by: { $0.resource < $1.resource }) {
                if let actual = resource(adjustment.resource, in: state), actual <= adjustment.atMost {
                    multiply("resource-context", "\(adjustment.resource)=\(actual)<=\(adjustment.atMost)", adjustment.multiplier)
                }
            }
            // No country, household, candidate index or random-consumption counter in this key.
            let key = KeyedRandom.key(eventID: event.id, age: state.age, channel: version)
            // Keep the finite 53-bit uniform inside (0,1), including the rare draw == 0 endpoint.
            let uniform = min(1.0.nextDown, 1 - KeyedRandom.draw(seed: state.seed, key: key))
            let eligible = exclusions.isEmpty
            return .init(eventID: event.id, isFallback: event.isFallback, conditions: conditions, eligible: eligible,
                         exclusions: exclusions, policy: policy, baseWeight: policy.baseWeight, weightSteps: steps,
                         finalWeight: weight, randomKey: key, uniform: uniform, raceScore: eligible ? -log(uniform) / weight : nil)
        }
        let eligible = candidates.filter(\.eligible)
        guard let winner = eligible.min(by: { left, right in
            let a = left.raceScore!, b = right.raceScore!
            return a == b ? left.eventID < right.eventID : a < b
        }) else { throw ModelError.missing("eligible event with recovery choice") }
        return .init(rules: rules, algorithm: KeyedRandom.version + "+" + version, seed: state.seed, age: state.age,
                     key: winner.randomKey, draw: winner.uniform, candidates: candidates,
                     eligibleEventIDs: eligible.map(\.eventID), selectedEventID: winner.eventID, assumptionID: appointment == nil ? "event-selection" : "creative-opportunities")
    }
}
