import Foundation

public struct StoryHook: Codable, Equatable, Sendable {
    public let id: String
    public let originEventID: String
    public let originChoiceID: String
    public let dueAge: Int
    public let person: String
    public let text: String
    public let effect: ResourceValues
    public let assumptionID: String
}

public struct DecisionRecord: Codable, Equatable, Sendable {
    public let eventID: String
    public let choiceID: String
    public let age: Int
}

public struct LifeState: Codable, Equatable, Sendable {
    public static let engineVersion = "lc01-2"
    public var engineVersion: String
    public var dataVersion: String
    public var contentVersion: String
    public var seed: UInt64
    public var countryCode: String
    public var householdID: String
    public var age: Int
    public var resources: ResourceValues
    public var remainingTime: Int
    public var remainingEnergy: Int
    public var remainingMaterials: Int
    public var decisions: [DecisionRecord]
    public var pendingHooks: [StoryHook]
    public var memories: [StoryHook]

    public static func born(catalog: ModelCatalog, countryCode: String, householdID: String, seed: UInt64) throws -> Self {
        try catalog.validate()
        let context = try EnvironmentRules.context(catalog: catalog, countryCode: countryCode, householdID: householdID)
        return .init(engineVersion: engineVersion, dataVersion: catalog.dataVersion,
                     contentVersion: catalog.contentVersion, seed: seed,
                     countryCode: countryCode, householdID: householdID, age: 0,
                     resources: context.household.initialResources,
                     remainingTime: LifeStage.childhood.timeBudget,
                     remainingEnergy: LifeStage.childhood.energyBudget,
                     remainingMaterials: context.household.materialBudget,
                     decisions: [], pendingHooks: [], memories: [])
    }

    public func validate(catalog: ModelCatalog) throws {
        guard engineVersion == Self.engineVersion, dataVersion == catalog.dataVersion,
              contentVersion == catalog.contentVersion else { throw ModelError.invalid("state version") }
        let stage = try LifeStage.at(age: age)
        let context = try EnvironmentRules.context(catalog: catalog, countryCode: countryCode, householdID: householdID)
        try resources.validate(in: 0...100)
        guard (0...stage.timeBudget).contains(remainingTime), (0...stage.energyBudget).contains(remainingEnergy),
              (0...context.household.materialBudget).contains(remainingMaterials),
              Set(decisions.map(\.eventID)).count == decisions.count else { throw ModelError.invalid("state budget/history") }
        var previousAge = -1
        for record in decisions {
            guard record.age > previousAge, record.age <= age,
                  let event = catalog.decisions.first(where: { $0.id == record.eventID }), event.age == record.age,
                  event.choices.contains(where: { $0.id == record.choiceID }) else {
                throw ModelError.invalid("decision history")
            }
            previousAge = record.age
        }
        try uniqueHooks()
        for hook in pendingHooks + memories {
            try hook.effect.validate(in: -20...20)
            guard decisions.contains(where: { $0.eventID == hook.originEventID && $0.choiceID == hook.originChoiceID }),
                  let event = catalog.decisions.first(where: { $0.id == hook.originEventID }),
                  let choice = event.choices.first(where: { $0.id == hook.originChoiceID }),
                  hook == StoryRules.callback(event: event, choice: choice) else {
                throw ModelError.invalid("story provenance")
            }
        }
        guard pendingHooks.allSatisfy({ $0.dueAge > age }), memories.allSatisfy({ $0.dueAge <= age }) else {
            throw ModelError.invalid("story timing")
        }
    }

    private func uniqueHooks() throws {
        let ids = (pendingHooks + memories).map(\.id)
        guard Set(ids).count == ids.count else { throw ModelError.invalid("duplicate story hook") }
    }
}

enum StoryRules {
    static func callback(event: DecisionSkeleton, choice: ChoiceDefinition) -> StoryHook? {
        guard let hookID = choice.delayedHook else { return nil }
        return .init(id: "\(event.id):\(hookID)", originEventID: event.id, originChoiceID: choice.id,
                     dueAge: min(100, event.age + 4), person: event.recurringPerson,
                     text: "\(event.recurringPerson)記得你當年的選擇，這次邀你一起分享經驗。",
                     effect: .init(relationships: 2, skills: 1), assumptionID: "story-callback")
    }
}

public struct TimeJumpTrace: Codable, Equatable, Sendable {
    public let fromAge: Int
    public let toAge: Int
    public let triggeredHooks: [StoryHook]
    public let resourcesBefore: ResourceValues
    public let resourcesAfter: ResourceValues
    public let clampAdjustment: ResourceValues
    public let assumptionID: String
}

public enum SimulationEngine {
    public static func advance(_ state: LifeState, to age: Int, catalog: ModelCatalog) throws -> (LifeState, TimeJumpTrace) {
        try catalog.validate(); try state.validate(catalog: catalog)
        let stage = try LifeStage.at(age: age)
        guard age > state.age else { throw ModelError.invalid("non-forward time jump") }
        var next = state
        let hooks = state.pendingHooks.filter { $0.dueAge <= age }.sorted {
            $0.dueAge == $1.dueAge ? $0.id < $1.id : $0.dueAge < $1.dueAge
        }
        let delta = hooks.reduce(ResourceValues.zero) { $0 + $1.effect }
        let raw = state.resources + delta
        next.age = age; next.resources = raw.clamped
        next.remainingTime = stage.timeBudget; next.remainingEnergy = stage.energyBudget
        let context = try EnvironmentRules.context(catalog: catalog, countryCode: state.countryCode, householdID: state.householdID)
        next.remainingMaterials = context.household.materialBudget
        next.pendingHooks.removeAll { $0.dueAge <= age }; next.memories.append(contentsOf: hooks)
        try next.validate(catalog: catalog)
        return (next, .init(fromAge: state.age, toAge: age, triggeredHooks: hooks,
                            resourcesBefore: state.resources, resourcesAfter: next.resources,
                            clampAdjustment: next.resources - raw, assumptionID: "life-stages"))
    }
}
