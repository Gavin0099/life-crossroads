import Foundation

/// Authored story facts. Values describe actions actually taken, never nationality or moral worth.
public struct StoryChange: Codable, Equatable, Sendable {
    public var key: String
    public var value: String
    public var personID: String
    public var relationshipDelta: Int
}
public struct StoryFact: Codable, Equatable, Sendable {
    public let key: String
    public let value: String
    public let eventID: String
    public let choiceID: String
    public let age: Int
}
public struct RelationshipState: Codable, Equatable, Sendable {
    public let personID: String
    public var familiarity: Int
    public var interactions: [StoryFact]
}
public struct EventMemory: Codable, Equatable, Sendable {
    public let eventID: String
    public let age: Int
    public let category: String
    public let exclusiveGroup: String?
}
public struct StoryMemory: Codable, Equatable, Sendable {
    public var flags: [StoryFact] = []
    public var relationships: [RelationshipState] = []
    public var events: [EventMemory] = []
    public func fact(_ key: String) -> StoryFact? { flags.first { $0.key == key } }
    public static let values: [String: Set<String>] = [
        "friendship": ["connected", "paused"], "learning": ["online", "paper", "none"],
        "creative": ["remote", "collective", "seeking", "paused"],
        "care": ["shared", "seeking", "paused"], "repair": ["practiced", "seeking"],
        "kitchen": ["shared", "seeking"], "garden": ["tending", "seeking"],
        "nature": ["observing", "seeking"],
        "support": ["requested", "arranged", "reciprocal"],
        "recovery": ["protected", "paced", "returned"],
        "careAccess": ["reserved", "shared", "seeking", "followed"],
        "budget": ["staged"],
        "tools": ["powered", "portable", "manual", "seeking", "cooperating"]
    ]
    public static let people: Set<String> = ["ahe", "teacher", "cheng"]

    /// Reconstructible from the decision ledger; forged facts or relationships cannot pass state validation.
    static func rebuild(_ records: [DecisionRecord], catalog: ModelCatalog) throws -> StoryMemory {
        var memory = StoryMemory()
        for record in records {
            guard let event = catalog.decisions.first(where: { $0.id == record.eventID }),
                  let choice = event.choices.first(where: { $0.id == record.choiceID }) else {
                throw ModelError.invalid("story memory origin")
            }
            for change in choice.storyChanges {
                let fact = StoryFact(key: change.key, value: change.value, eventID: event.id, choiceID: choice.id, age: record.age)
                // Asking for help does not erase previously acquired experience or an existing agreement.
                let activeValues: Set<String> = ["practiced", "shared", "tending", "observing"]
                let existing = memory.fact(change.key)?.value ?? ""
                // Current requests/rest remain in the immutable decision ledger. They must not erase
                // an earlier confirmed arrangement or tried participation pace, including its source.
                let preservesSupport = change.key == "support" && change.value == "requested" && ["arranged", "reciprocal"].contains(existing)
                let preservesPace = change.key == "recovery" && change.value == "protected" && ["paced", "returned"].contains(existing)
                if !preservesSupport && !preservesPace && (change.value != "seeking" || !activeValues.contains(existing)) {
                    memory.flags.removeAll { $0.key == change.key }; memory.flags.append(fact)
                }
                if !change.personID.isEmpty {
                    if let index = memory.relationships.firstIndex(where: { $0.personID == change.personID }) {
                        memory.relationships[index].familiarity = min(10, max(0, memory.relationships[index].familiarity + change.relationshipDelta))
                        memory.relationships[index].interactions.append(fact)
                    } else {
                        memory.relationships.append(.init(personID: change.personID, familiarity: max(0, change.relationshipDelta), interactions: [fact]))
                    }
                }
            }
            memory.events.append(.init(eventID: event.id, age: record.age, category: event.selection.category,
                                       exclusiveGroup: event.selection.exclusiveGroup))
        }
        memory.flags.sort { $0.key < $1.key }; memory.relationships.sort { $0.personID < $1.personID }
        return memory
    }
}

public struct StoryContinuation: Codable, Equatable, Sendable {
    public var flag: String
    public var activeValues: [String]
    public var unlockedChoices: [String]
    public var minimumSkills: Int
    public var activeTitle: String
    public var recoveryTitle: String
}
