import Foundation

extension EventCatalog {
    public func validate() throws {
        try model.validate()
        guard !version.isEmpty, slots.count == 15, !events.isEmpty else { throw ModelError.invalid("director catalog shape") }
        func unique(_ values: [String]) throws {
            guard values.allSatisfy({ !$0.isEmpty }), Set(values).count == values.count else { throw ModelError.invalid("director duplicate/empty ID") }
        }
        try unique(events.map(\.id)); try unique(slots.map(\.id)); try unique(personIDs)
        let ids = Set(events.map(\.id)), people = Set(personIDs), assumptions = Set(model.assumptions.map(\.id))
        func conditions(_ values: [EventCondition]) throws {
            for value in values {
                switch value {
                case let .indicator(code, low, high):
                    guard CountryProfile.requiredIndicators.contains(code), low.isFinite, high.isFinite,
                          low >= 0, low <= high, high <= 100 else { throw ModelError.invalid("indicator condition") }
                case let .household(field, low, high):
                    let upperBound = field == .materialBudget ? 4 : 2
                    guard low >= 0, low <= high, high <= upperBound else { throw ModelError.invalid("household condition") }
                case let .resource(_, low, high):
                    guard low >= 0, low <= high, high <= 100 else { throw ModelError.invalid("resource condition") }
                case .deviceAccess: break
                case let .relationship(person, fact, _):
                    guard people.contains(person), !fact.isEmpty,
                          events.contains(where: { $0.relationshipEffects.contains(where: { $0.personID == person && $0.factID == fact }) })
                    else { throw ModelError.missing("relationship definition") }
                case let .historyChoice(event, choice):
                    guard let prior = events.first(where: { $0.id == event }), prior.decision.choices.contains(where: { $0.id == choice }) else {
                        throw ModelError.missing("history choice definition")
                    }
                case let .historyEvent(event, _):
                    guard ids.contains(event) else { throw ModelError.missing("history event definition") }
                }
            }
        }
        for event in events {
            guard event.minimumAge >= 0, event.maximumAge <= 100, event.minimumAge <= event.maximumAge,
                  event.weight > 0, event.weight <= WeightedEventSelector.maximumTotalWeight,
                  event.policy.cooldownYears >= 0, event.policy.cooldownYears <= 100,
                  event.policy.maxOccurrences.map({ $0 > 0 && $0 <= 100 }) ?? true,
                  event.policy.exclusiveGroup.map({ !$0.isEmpty }) ?? true,
                  assumptions.contains(event.assumptionID), !event.decision.title.isEmpty,
                  !event.decision.recurringPerson.isEmpty, !event.decision.storyQuestion.isEmpty else {
                throw ModelError.invalid("directed event metadata: \(event.id)")
            }
            try unique(event.decision.choices.map(\.id)); try unique(event.choiceConditions.map(\.choiceID))
            for choice in event.decision.choices {
                guard (0...100).contains(choice.minimumAge), (0...8).contains(choice.timeCost),
                      (0...8).contains(choice.energyCost), (0...4).contains(choice.materialCost),
                      !choice.title.isEmpty, !choice.assumptionIDs.isEmpty,
                      choice.assumptionIDs.allSatisfy(assumptions.contains) else { throw ModelError.invalid("directed choice") }
                try choice.effect.validate(in: -20...20)
            }
            guard event.decision.choices.contains(where: { choice in
                choice.kind == .rest && choice.timeCost == 0 && choice.energyCost == 0 && choice.materialCost == 0
                    && !choice.requiresDigitalAccess && choice.control == .personal && choice.minimumAge <= event.minimumAge
                    && !event.choiceConditions.contains(where: { $0.choiceID == choice.id })
                    && !StoryBranchEngine.isConditionallyHidden(eventID: event.id, choiceID: choice.id)
            }) else { throw ModelError.missing("directed free recovery choice") }
            // Every authored age must retain a genuinely available offline, material-free support route.
            let stages = try Set((event.minimumAge...event.maximumAge).map { try LifeStage.at(age: $0) })
            let readyFamilies = model.households.filter { family in
                model.countries.contains { $0.code == family.countryCode && $0.dataStatus == .ready }
            }
            guard event.decision.choices.contains(where: { choice in
                choice.kind == .askSupport && !choice.requiresDigitalAccess && choice.materialCost == 0
                    && choice.minimumAge <= event.minimumAge
                    && (choice.control != .adultResponsibility || event.minimumAge >= 23)
                    && !event.choiceConditions.contains(where: { $0.choiceID == choice.id })
                    && !StoryBranchEngine.isConditionallyHidden(eventID: event.id, choiceID: choice.id)
                    && stages.allSatisfy { stage in
                        choice.energyCost <= stage.energyBudget && readyFamilies.allSatisfy { family in
                            max(0, choice.timeCost - family.mentorSupport) <= stage.timeBudget
                        }
                    }
            }) else { throw ModelError.missing("directed available material-free support choice") }
            if event.decision.choices.contains(where: { $0.delayedHook != nil }),
               slots.contains(where: { $0.age == 100 && $0.age >= event.minimumAge && $0.age <= event.maximumAge }) {
                throw ModelError.invalid("cannot schedule a future hook from terminal age 100")
            }
            try conditions(event.conditions)
            for restriction in event.choiceConditions {
                guard let choice = event.decision.choices.first(where: { $0.id == restriction.choiceID }),
                      choice.kind != .rest, choice.kind != .askSupport else { throw ModelError.invalid("recovery choice restriction") }
                try conditions(restriction.conditions)
            }
            var effects: Set<String> = []
            for effect in event.relationshipEffects {
                let key = "\(effect.choiceID.utf8.count):\(effect.choiceID)|\(effect.personID.utf8.count):\(effect.personID)|\(effect.factID.utf8.count):\(effect.factID)"
                guard event.decision.choices.contains(where: { $0.id == effect.choiceID }), people.contains(effect.personID),
                      !effect.factID.isEmpty, effects.insert(key).inserted else { throw ModelError.invalid("relationship effect") }
            }
        }
        var prior = 0
        for slot in slots {
            let fallback = try event(slot.fallbackEventID)
            guard slot.age > prior, slot.age <= 100, slot.age >= 0,
                  fallback.minimumAge == slot.age, fallback.maximumAge == slot.age,
                  fallback.conditions.isEmpty, fallback.policy == EventPolicy() else {
                throw ModelError.invalid("slot must have dedicated unconditional once-only fallback")
            }
            prior = slot.age
        }
        guard Set(try slots.map { try LifeStage.at(age: $0.age) }) == Set(LifeStage.allCases) else {
            throw ModelError.invalid("director must cover five stages")
        }
        // Overflow is rejected even if not all definitions are simultaneously eligible.
        _ = try WeightedEventSelector.totalWeight(events.map { .init(eventID: $0.id, weight: $0.weight) })
    }
}

public enum EventEligibility {
    public static func evaluate(event: DirectedEvent, state: LifeState, catalog: EventCatalog) throws -> EligibilityEvaluation {
        guard (0...100).contains(state.age), (state.directorHistory?.occurrences ?? []).allSatisfy({ (0...100).contains($0.age) }) else {
            throw ModelError.invalid("eligibility age/history bounds")
        }
        let context = try EnvironmentRules.context(catalog: catalog.model, countryCode: state.countryCode, householdID: state.householdID)
        let history = state.directorHistory?.occurrences ?? []
        let occurrences = history.filter { $0.eventID == event.id }
        var checks: [EligibilityCheck] = [
            .init(ruleID: "age.window", observed: String(state.age), expected: "\(event.minimumAge)...\(event.maximumAge)",
                  met: state.age >= event.minimumAge && state.age <= event.maximumAge, sourceIDs: [], assumptionIDs: [event.assumptionID]),
            .init(ruleID: "policy.occurrences", observed: String(occurrences.count), expected: event.policy.maxOccurrences.map { "<\($0)" } ?? "repeatable",
                  met: event.policy.maxOccurrences.map { occurrences.count < $0 } ?? true, sourceIDs: [], assumptionIDs: [event.assumptionID])]
        if let last = occurrences.last {
            checks.append(.init(ruleID: "policy.cooldown", observed: String(state.age - last.age), expected: ">=\(event.policy.cooldownYears)",
                                met: state.age - last.age >= event.policy.cooldownYears, sourceIDs: [], assumptionIDs: [event.assumptionID]))
        }
        if let group = event.policy.exclusiveGroup {
            let conflicting = history.filter { occurrence in
                occurrence.eventID != event.id && catalog.events.contains { $0.id == occurrence.eventID && $0.policy.exclusiveGroup == group }
            }
            checks.append(.init(ruleID: "policy.exclusive.\(group)", observed: conflicting.map(\.eventID).joined(separator: ","),
                                expected: "no other definition in group", met: conflicting.isEmpty, sourceIDs: [], assumptionIDs: [event.assumptionID]))
        }
        checks += evaluateConditions(event.conditions, state: state, context: context, assumptionID: event.assumptionID)
        return .init(eventID: event.id, checks: checks)
    }

    public static func choiceChecks(choiceID: String, event: DirectedEvent, state: LifeState, catalog: EventCatalog) throws -> [EligibilityCheck] {
        let context = try EnvironmentRules.context(catalog: catalog.model, countryCode: state.countryCode, householdID: state.householdID)
        return evaluateConditions(event.choiceConditions.first(where: { $0.choiceID == choiceID })?.conditions ?? [],
                                  state: state, context: context, assumptionID: event.assumptionID)
    }

    static func evaluateConditions(_ conditions: [EventCondition], state: LifeState, context: EnvironmentContext,
                                   assumptionID: String) -> [EligibilityCheck] {
        conditions.enumerated().map { index, condition in
            let rule = "condition.\(index)"
            func check(_ suffix: String, _ observed: String, _ expected: String, _ met: Bool, _ sources: [String] = []) -> EligibilityCheck {
                .init(ruleID: "\(rule).\(suffix)", observed: observed, expected: expected, met: met,
                      sourceIDs: sources, assumptionIDs: [assumptionID])
            }
            switch condition {
            case let .indicator(code, low, high):
                let observation = context.observations.first { $0.indicator == code }
                let value = observation?.value
                return check("indicator.\(code)", value.map(String.init(describing:)) ?? "missing", "\(low)...\(high)",
                             value.map { $0.isFinite && $0 >= low && $0 <= high } ?? false, observation.map { [$0.sourceID] } ?? [])
            case let .household(field, low, high):
                let value = field.value(in: context.household)
                return check("household.\(field.rawValue)", String(value), "\(low)...\(high)", value >= low && value <= high)
            case let .deviceAccess(required):
                return check("household.deviceAccess", context.household.deviceAccess.rawValue, required.rawValue, context.household.deviceAccess == required)
            case let .resource(field, low, high):
                let value = field.value(in: state.resources)
                return check("resource.\(field.rawValue)", String(value), "\(low)...\(high)", value >= low && value <= high)
            case let .relationship(person, fact, present):
                let recorded = state.directorHistory?.relationships.last { $0.personID == person && $0.factID == fact }
                var result = check("relationship.\(person).\(fact)", recorded.map { String($0.present) } ?? "unknown",
                                   String(present), recorded.map { $0.present == present } ?? false)
                result.originOccurrenceIDs = recorded.map { [$0.originOccurrenceID] } ?? []
                return result
            case let .historyChoice(event, choice):
                let records = state.decisions.filter { $0.eventID == event }
                let choices = records.map(\.choiceID)
                var result = check("history.choice.\(event)", choices.joined(separator: ","), choice, choices.contains(choice))
                result.originOccurrenceIDs = records.filter { $0.choiceID == choice }.compactMap(\.occurrenceID)
                return result
            case let .historyEvent(event, present):
                let records = state.decisions.filter { $0.eventID == event }
                var result = check("history.event.\(event)", String(!records.isEmpty), String(present), !records.isEmpty == present)
                result.originOccurrenceIDs = records.compactMap(\.occurrenceID)
                return result
            }
        }
    }
}

public enum WeightedEventSelector {
    public static let version = "stable-id-integer-cumulative-v1"
    public static let maximumTotalWeight = 9_007_199_254_740_991
    public static func totalWeight(_ candidates: [EligibleEvent]) throws -> Int {
        guard !candidates.isEmpty, Set(candidates.map(\.eventID)).count == candidates.count else {
            throw ModelError.invalid("empty/duplicate weighted pool")
        }
        var total = 0
        for candidate in candidates {
            guard !candidate.eventID.isEmpty, candidate.weight > 0 else { throw ModelError.invalid("weight must be positive") }
            let (next, overflow) = total.addingReportingOverflow(candidate.weight)
            guard !overflow, next <= maximumTotalWeight else { throw ModelError.invalid("weight sum overflow or precision loss") }
            total = next
        }
        return total
    }
    public static func select(candidates: [EligibleEvent], seed: UInt64, slotID: String, age: Int) throws -> SelectionResult {
        guard !slotID.isEmpty, (0...100).contains(age) else { throw ModelError.invalid("selection slot") }
        let sorted = candidates.sorted { $0.eventID < $1.eventID }
        let total = try totalWeight(sorted)
        let key = KeyedRandom.key(eventID: slotID, age: age, channel: "event-director:\(version)")
        let draw = KeyedRandom.draw(seed: seed, key: key)
        let ticket = min(total - 1, Int(draw * Double(total)))
        var cumulative = 0
        for candidate in sorted {
            cumulative += candidate.weight
            if ticket < cumulative {
                return .init(algorithm: "\(version)/\(KeyedRandom.version)", key: key, draw: draw,
                             totalWeight: total, selectedEventID: candidate.eventID)
            }
        }
        throw ModelError.invalid("unreachable weighted selection")
    }
}

public enum EventDirector {
    public static let version = "lc-director-1"
    public static func offer(state: LifeState, slot: LifeSlot, catalog: EventCatalog) throws -> DirectedOffer {
        try catalog.validate(); try state.validate(catalog: catalog.model, directedCatalog: catalog)
        guard state.age == slot.age, catalog.slots.contains(slot),
              !(state.directorHistory?.occurrences.contains(where: { $0.slotID == slot.id }) ?? false) else {
            throw ModelError.invalid("director slot not available")
        }
        let candidates = try catalog.events.sorted { $0.id < $1.id }.map { event in
            CandidateEvaluation(eventID: event.id, weight: event.weight,
                                eligibility: try EventEligibility.evaluate(event: event, state: state, catalog: catalog))
        }
        let eligible = candidates.filter { $0.eligibility.eligible }.map { EligibleEvent(eventID: $0.eventID, weight: $0.weight) }
        guard !eligible.isEmpty else { throw ModelError.unavailable("no eligible event at slot \(slot.id)") }
        let selection = try WeightedEventSelector.select(candidates: eligible, seed: state.seed, slotID: slot.id, age: slot.age)
        let ordinal = (state.directorHistory?.occurrences.filter { $0.eventID == selection.selectedEventID }.count ?? 0) + 1
        let occurrence = EventOccurrence(eventID: selection.selectedEventID, slotID: slot.id, age: slot.age, ordinal: ordinal)
        let trace = EventSelectionTrace(directorVersion: version, catalogVersion: catalog.version,
            dataVersion: catalog.model.dataVersion, contentVersion: catalog.model.contentVersion,
            seed: state.seed, countryCode: state.countryCode, householdID: state.householdID,
            slotID: slot.id, age: slot.age, candidates: candidates, selection: selection, occurrence: occurrence)
        return .init(occurrence: occurrence, trace: trace)
    }
}
