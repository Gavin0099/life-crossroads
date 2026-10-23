import Foundation

public enum ResourceField: String, Codable, CaseIterable, Sendable {
    case health, financial, relationships, skills
    public func value(in resources: ResourceValues) -> Int {
        switch self { case .health: resources.health; case .financial: resources.financial
        case .relationships: resources.relationships; case .skills: resources.skills }
    }
}
public enum HouseholdField: String, Codable, CaseIterable, Sendable {
    case travelCost, careLoad, mentorSupport, materialBudget
    public func value(in household: HouseholdProfile) -> Int {
        switch self { case .travelCost: household.travelCost; case .careLoad: household.careLoad
        case .mentorSupport: household.mentorSupport; case .materialBudget: household.materialBudget }
    }
}
public enum EventCondition: Codable, Equatable, Sendable {
    case indicator(code: String, minimum: Double, maximum: Double)
    case household(field: HouseholdField, minimum: Int, maximum: Int)
    case deviceAccess(DeviceAccess)
    case resource(field: ResourceField, minimum: Int, maximum: Int)
    case relationship(personID: String, factID: String, present: Bool)
    case historyChoice(eventID: String, choiceID: String)
    case historyEvent(eventID: String, present: Bool)
}
public struct EventPolicy: Codable, Equatable, Sendable {
    public var maxOccurrences: Int?
    public var cooldownYears: Int
    public var exclusiveGroup: String?
    public init(maxOccurrences: Int? = 1, cooldownYears: Int = 0, exclusiveGroup: String? = nil) {
        self.maxOccurrences = maxOccurrences; self.cooldownYears = cooldownYears; self.exclusiveGroup = exclusiveGroup
    }
}
public struct ChoiceRelationshipEffect: Codable, Equatable, Sendable {
    public var choiceID: String
    public var personID: String
    public var factID: String
    public var present: Bool
    public init(choiceID: String, personID: String, factID: String, present: Bool = true) {
        self.choiceID = choiceID; self.personID = personID; self.factID = factID; self.present = present
    }
}
public struct ChoiceEligibility: Codable, Equatable, Sendable {
    public var choiceID: String
    public var conditions: [EventCondition]
    public init(choiceID: String, conditions: [EventCondition]) { self.choiceID = choiceID; self.conditions = conditions }
}
public struct DirectedEvent: Codable, Equatable, Sendable {
    public var decision: DecisionSkeleton
    public var minimumAge: Int
    public var maximumAge: Int
    public var weight: Int
    public var conditions: [EventCondition]
    public var policy: EventPolicy
    public var relationshipEffects: [ChoiceRelationshipEffect]
    public var choiceConditions: [ChoiceEligibility]
    public var assumptionID: String
    public var id: String { decision.id }
    public init(decision: DecisionSkeleton, minimumAge: Int, maximumAge: Int, weight: Int,
                conditions: [EventCondition] = [], policy: EventPolicy = .init(),
                relationshipEffects: [ChoiceRelationshipEffect] = [], choiceConditions: [ChoiceEligibility] = [],
                assumptionID: String) {
        self.decision = decision; self.minimumAge = minimumAge; self.maximumAge = maximumAge
        self.weight = weight; self.conditions = conditions; self.policy = policy
        self.relationshipEffects = relationshipEffects; self.choiceConditions = choiceConditions; self.assumptionID = assumptionID
    }
}
public struct LifeSlot: Codable, Equatable, Sendable {
    public var id: String
    public var age: Int
    public var fallbackEventID: String
    public init(id: String, age: Int, fallbackEventID: String) {
        self.id = id; self.age = age; self.fallbackEventID = fallbackEventID
    }
}
public struct EventCatalog: Codable, Equatable, Sendable {
    public var version: String
    public var model: ModelCatalog
    public var events: [DirectedEvent]
    public var slots: [LifeSlot]
    public var personIDs: [String]
    public init(version: String, model: ModelCatalog, events: [DirectedEvent], slots: [LifeSlot], personIDs: [String] = []) {
        self.version = version; self.model = model; self.events = events; self.slots = slots; self.personIDs = personIDs
    }
    public func event(_ id: String) throws -> DirectedEvent {
        guard let event = events.first(where: { $0.id == id }) else { throw ModelError.missing("directed event: \(id)") }
        return event
    }
}
public struct EligibilityCheck: Codable, Equatable, Sendable {
    public let ruleID: String
    public let observed: String
    public let expected: String
    public let met: Bool
    public let sourceIDs: [String]
    public let assumptionIDs: [String]
    public var originOccurrenceIDs: [String] = []
}
public struct EligibilityEvaluation: Codable, Equatable, Sendable {
    public let eventID: String
    public let checks: [EligibilityCheck]
    public var eligible: Bool { checks.allSatisfy(\.met) }
    public var rejectionReasons: [String] { checks.filter { !$0.met }.map { "\($0.ruleID): \($0.observed); requires \($0.expected)" } }
}
public struct EventOccurrence: Codable, Equatable, Sendable {
    public let id: String
    public let eventID: String
    public let slotID: String
    public let age: Int
    public let ordinal: Int
    public init(eventID: String, slotID: String, age: Int, ordinal: Int) {
        self.eventID = eventID; self.slotID = slotID; self.age = age; self.ordinal = ordinal
        self.id = "\(eventID.utf8.count):\(eventID)|\(slotID.utf8.count):\(slotID)|\(age)|\(ordinal)"
    }
}
public struct RelationshipFact: Codable, Equatable, Sendable {
    public let personID: String
    public let factID: String
    public let present: Bool
    public let originOccurrenceID: String
    public let originChoiceID: String
    public let assumptionID: String
}
public struct DirectorHistory: Codable, Equatable, Sendable {
    public let directorVersion: String
    public let catalogVersion: String
    public var occurrences: [EventOccurrence]
    public var relationships: [RelationshipFact]
    public init(catalogVersion: String) {
        self.directorVersion = EventDirector.version; self.catalogVersion = catalogVersion
        self.occurrences = []; self.relationships = []
    }
}
public struct EligibleEvent: Codable, Equatable, Sendable {
    public let eventID: String
    public let weight: Int
    public init(eventID: String, weight: Int) { self.eventID = eventID; self.weight = weight }
}
public struct SelectionResult: Codable, Equatable, Sendable {
    public let algorithm: String
    public let key: String
    public let draw: Double
    public let totalWeight: Int
    public let selectedEventID: String
}
public struct CandidateEvaluation: Codable, Equatable, Sendable {
    public let eventID: String
    public let weight: Int
    public let eligibility: EligibilityEvaluation
}
public struct EventSelectionTrace: Codable, Equatable, Sendable {
    public let directorVersion: String
    public let catalogVersion: String
    public let dataVersion: String
    public let contentVersion: String
    public let seed: UInt64
    public let countryCode: String
    public let householdID: String
    public let slotID: String
    public let age: Int
    public let candidates: [CandidateEvaluation]
    public let selection: SelectionResult
    public let occurrence: EventOccurrence
}
public struct DirectedOffer: Codable, Equatable, Sendable {
    public let occurrence: EventOccurrence
    public let trace: EventSelectionTrace
}
public struct DirectedComparison: Codable, Equatable, Sendable {
    public let countryCode: String
    public let comparable: Bool
    public let reasons: [String]
    public let eligibility: EligibilityEvaluation?
    public let trace: ConsequenceTrace?
}
