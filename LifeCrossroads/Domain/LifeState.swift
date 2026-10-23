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
    public var originOccurrenceID: String? = nil
    public var originResourcesBefore: ResourceValues? = nil
}

public struct DecisionRecord: Codable, Equatable, Sendable {
    public let eventID: String
    public let choiceID: String
    public let age: Int
    public var occurrenceID: String? = nil
}

public struct LifeState: Codable, Equatable, Sendable {
    public static let engineVersion = "lc02-3"
    public static let directedEngineVersion = "lc02-3+director-1"
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
    public var directorHistory: DirectorHistory? = nil

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

    public func validate(catalog: ModelCatalog, directedCatalog: EventCatalog? = nil) throws {
        guard engineVersion == (directorHistory == nil ? Self.engineVersion : Self.directedEngineVersion), dataVersion == catalog.dataVersion,
              contentVersion == catalog.contentVersion else { throw ModelError.invalid("state version") }
        let stage = try LifeStage.at(age: age)
        let context = try EnvironmentRules.context(catalog: catalog, countryCode: countryCode, householdID: householdID)
        try resources.validate(in: 0...100)
        guard (0...stage.timeBudget).contains(remainingTime), (0...stage.energyBudget).contains(remainingEnergy),
              (0...context.household.materialBudget).contains(remainingMaterials),
              (directorHistory != nil || Set(decisions.map(\.eventID)).count == decisions.count) else { throw ModelError.invalid("state budget/history") }
        if let history = directorHistory {
            guard let directedCatalog, directedCatalog.model == catalog,
                  history.directorVersion == EventDirector.version, history.catalogVersion == directedCatalog.version,
                  history.occurrences.count == decisions.count, decisions.count <= directedCatalog.slots.count,
                  history.occurrences.allSatisfy({ (0...100).contains($0.age) }),
                  decisions.allSatisfy({ (0...100).contains($0.age) }) else { throw ModelError.invalid("director history/version") }
            var expectedFacts: [RelationshipFact] = []
            var counts: [String: Int] = [:]
            var priorAge = -1
            var usedSlots: Set<String> = []
            var usedOccurrences: Set<String> = []
            for (record, occurrence) in zip(decisions, history.occurrences) {
                let event = try directedCatalog.event(record.eventID)
                counts[event.id, default: 0] += 1
                let expected = EventOccurrence(eventID: event.id, slotID: occurrence.slotID, age: record.age, ordinal: counts[event.id]!)
                guard occurrence == expected, occurrence.id == record.occurrenceID,
                      usedSlots.insert(occurrence.slotID).inserted, usedOccurrences.insert(occurrence.id).inserted,
                      directedCatalog.slots.contains(where: { $0.id == occurrence.slotID && $0.age == record.age }),
                      record.age > priorAge, record.age <= age,
                      record.age >= event.minimumAge, record.age <= event.maximumAge,
                      event.decision.choices.contains(where: { $0.id == record.choiceID }) else {
                    throw ModelError.invalid("directed decision history")
                }
                let previous = history.occurrences.filter { $0.age < record.age }
                let same = previous.filter { $0.eventID == event.id }
                guard event.policy.maxOccurrences.map({ same.count < $0 }) ?? true,
                      same.last.map({ record.age - $0.age >= event.policy.cooldownYears }) ?? true else {
                    throw ModelError.invalid("directed occurrence policy")
                }
                if let group = event.policy.exclusiveGroup,
                   previous.contains(where: { prior in
                       prior.eventID != event.id && directedCatalog.events.contains { $0.id == prior.eventID && $0.policy.exclusiveGroup == group }
                   }) { throw ModelError.invalid("directed exclusive history") }
                for effect in event.relationshipEffects where effect.choiceID == record.choiceID {
                    expectedFacts.append(.init(personID: effect.personID, factID: effect.factID, present: effect.present,
                                               originOccurrenceID: occurrence.id, originChoiceID: record.choiceID, assumptionID: event.assumptionID))
                }
                priorAge = record.age
            }
            guard history.relationships == expectedFacts else { throw ModelError.invalid("forged relationship facts") }
        } else {
            guard directedCatalog == nil else { throw ModelError.invalid("missing director history") }
            var previousAge = -1
            for record in decisions {
                guard record.occurrenceID == nil, record.age > previousAge, record.age <= age,
                      let event = catalog.decisions.first(where: { $0.id == record.eventID }), event.age == record.age,
                      event.choices.contains(where: { $0.id == record.choiceID }) else { throw ModelError.invalid("decision history") }
                previousAge = record.age
            }
        }
        try uniqueHooks()
        for hook in pendingHooks + memories {
            try hook.effect.validate(in: -20...20)
            if let directedCatalog, let occurrenceID = hook.originOccurrenceID {
                guard let originIndex = decisions.firstIndex(where: { $0.occurrenceID == occurrenceID }),
                      let occurrence = directorHistory?.occurrences.first(where: { $0.id == occurrenceID }),
                      let resourcesBefore = hook.originResourcesBefore else { throw ModelError.invalid("directed story origin snapshot") }
                let record = decisions[originIndex]
                guard record.eventID == hook.originEventID, record.choiceID == hook.originChoiceID else {
                    throw ModelError.invalid("directed story provenance")
                }
                try resourcesBefore.validate(in: 0...100)
                let definition = try directedCatalog.event(record.eventID)
                // StoryBranchEngine reads decision history and resources. Rebuild its actual origin inputs,
                // never project a past scene using today's resources. Full-session replay verifies the snapshot.
                var origin = self
                origin.age = record.age; origin.resources = resourcesBefore
                origin.decisions = Array(decisions.prefix(originIndex))
                let projected = StoryBranchEngine.project(
                    event: Self.directedDecision(definition.decision, at: occurrence.age), state: origin).event
                guard let choice = projected.choices.first(where: { $0.id == record.choiceID }),
                      hook == StoryRules.callback(event: projected, choice: choice, occurrence: occurrence,
                                                  resourcesBefore: resourcesBefore) else {
                    throw ModelError.invalid("directed story provenance")
                }
            } else {
                guard directorHistory == nil, hook.originOccurrenceID == nil, hook.originResourcesBefore == nil,
                      decisions.contains(where: { $0.eventID == hook.originEventID && $0.choiceID == hook.originChoiceID }),
                      let event = catalog.decisions.first(where: { $0.id == hook.originEventID }),
                      let choice = event.choices.first(where: { $0.id == hook.originChoiceID }),
                      hook == StoryRules.callback(event: event, choice: choice) else { throw ModelError.invalid("story provenance") }
            }
        }
        guard pendingHooks.allSatisfy({ $0.dueAge > age }), memories.allSatisfy({ $0.dueAge <= age }) else {
            throw ModelError.invalid("story timing")
        }
    }

    static func directedDecision(_ definition: DecisionSkeleton, at age: Int) -> DecisionSkeleton {
        var event = definition; event.age = age; return event
    }

    private func uniqueHooks() throws {
        let ids = (pendingHooks + memories).map(\.id)
        guard Set(ids).count == ids.count else { throw ModelError.invalid("duplicate story hook") }
    }
}

enum StoryRules {
    static func callback(event: DecisionSkeleton, choice: ChoiceDefinition, occurrence: EventOccurrence? = nil,
                         resourcesBefore: ResourceValues? = nil) -> StoryHook? {
        guard let hookID = choice.delayedHook else { return nil }
        return .init(id: "\(occurrence?.id ?? event.id):\(hookID)", originEventID: event.id, originChoiceID: choice.id,
                     dueAge: min(100, event.age + 4), person: event.recurringPerson,
                     text: "\(event.recurringPerson)記得你當年的選擇，這次邀你一起分享經驗。",
                     effect: .init(relationships: 2, skills: 1), assumptionID: "story-callback", originOccurrenceID: occurrence?.id, originResourcesBefore: resourcesBefore)
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
    public static func advance(_ state: LifeState, to age: Int, catalog: ModelCatalog, directedCatalog: EventCatalog? = nil) throws -> (LifeState, TimeJumpTrace) {
        try catalog.validate(); try state.validate(catalog: catalog, directedCatalog: directedCatalog)
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
        try next.validate(catalog: catalog, directedCatalog: directedCatalog)
        return (next, .init(fromAge: state.age, toAge: age, triggeredHooks: hooks,
                            resourcesBefore: state.resources, resourcesAfter: next.resources,
                            clampAdjustment: next.resources - raw, assumptionID: "life-stages"))
    }
}
