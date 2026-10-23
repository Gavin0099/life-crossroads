import Foundation

/// Opt-in directed play. Legacy LifeSession remains the fixed-story compatibility mode.
public struct DirectedLifeSession: Codable, Equatable, Sendable {
    public private(set) var state: LifeState
    public private(set) var phase: SessionPhase
    public private(set) var traces: [ConsequenceTrace]
    public private(set) var jumps: [TimeJumpTrace]
    public private(set) var selections: [EventSelectionTrace]
    public private(set) var currentOffer: DirectedOffer?

    public static func start(catalog: EventCatalog, countryCode: String, householdID: String, seed: UInt64) throws -> Self {
        try catalog.validate()
        guard let slot = catalog.slots.first else { throw ModelError.missing("first directed slot") }
        var born = try LifeState.born(catalog: catalog.model, countryCode: countryCode, householdID: householdID, seed: seed)
        born.directorHistory = .init(catalogVersion: catalog.version)
        born.engineVersion = LifeState.directedEngineVersion
        let (state, jump) = try SimulationEngine.advance(born, to: slot.age, catalog: catalog.model, directedCatalog: catalog)
        let offer = try EventDirector.offer(state: state, slot: slot, catalog: catalog)
        return .init(state: state, phase: .choosing, traces: [], jumps: [jump], selections: [offer.trace], currentOffer: offer)
    }

    public func event(catalog: EventCatalog) throws -> DecisionSkeleton {
        try checkStructure(catalog: catalog)
        guard phase == .choosing, let currentOffer else { throw ModelError.invalid("not choosing directed event") }
        let definition = try catalog.event(currentOffer.occurrence.eventID)
        var projected = StoryBranchEngine.project(event: LifeState.directedDecision(definition.decision, at: state.age), state: state).event
        projected.choices = try projected.choices.filter { choice in
            try EventEligibility.choiceChecks(choiceID: choice.id, event: definition, state: state, catalog: catalog).allSatisfy(\.met)
        }
        return projected
    }

    public func preview(choiceID: String, catalog: EventCatalog) throws -> ConsequenceTrace {
        try checkStructure(catalog: catalog)
        guard phase == .choosing, let currentOffer else { throw ModelError.invalid("not choosing directed preview") }
        return try DecisionResolver.resolve(state: state, eventID: currentOffer.occurrence.eventID, choiceID: choiceID,
            catalog: catalog.model, directedCatalog: catalog, occurrence: currentOffer.occurrence).trace
    }

    public mutating func choose(_ choiceID: String, catalog: EventCatalog) throws {
        try checkStructure(catalog: catalog)
        guard phase == .choosing, let currentOffer else { throw ModelError.invalid("not choosing directed choice") }
        let result = try DecisionResolver.resolve(state: state, eventID: currentOffer.occurrence.eventID, choiceID: choiceID,
            catalog: catalog.model, directedCatalog: catalog, occurrence: currentOffer.occurrence)
        guard result.trace.applied else { throw ModelError.unavailable(result.trace.unavailableReasons.joined(separator: "\n")) }
        state = result.state; traces.append(result.trace); phase = .reflecting
    }

    public mutating func continueLife(catalog: EventCatalog) throws {
        try checkStructure(catalog: catalog)
        guard phase == .reflecting else { throw ModelError.invalid("not reflecting directed life") }
        if traces.count == catalog.slots.count {
            phase = .ended; currentOffer = nil
        } else {
            let slot = catalog.slots[traces.count]
            let (next, jump) = try SimulationEngine.advance(state, to: slot.age, catalog: catalog.model, directedCatalog: catalog)
            let offer = try EventDirector.offer(state: next, slot: slot, catalog: catalog)
            state = next; jumps.append(jump); selections.append(offer.trace); currentOffer = offer; phase = .choosing
        }
    }

    /// Event and choice are fixed. The counterfactual rechecks eligibility instead of drawing a new event.
    public func compare(choiceID: String, countryCodes: [String], catalog: EventCatalog) throws -> [DirectedComparison] {
        try checkStructure(catalog: catalog)
        guard phase == .choosing, let currentOffer,
              let family = catalog.model.households.first(where: { $0.id == state.householdID }) else {
            throw ModelError.invalid("directed comparison requires pre-choice state")
        }
        let definition = try catalog.event(currentOffer.occurrence.eventID)
        guard definition.decision.choices.contains(where: { $0.id == choiceID }) else { throw ModelError.missing("comparison choice") }
        return try countryCodes.map { code in
            guard let country = catalog.model.countries.first(where: { $0.code == code }), country.dataStatus == .ready,
                  let other = catalog.model.households.first(where: { $0.countryCode == code && $0.templateID == family.templateID }),
                  family.hasSameConditions(as: other) else {
                return .init(countryCode: code, comparable: false, reasons: ["缺少可用國家資料或相同家庭條件。"], eligibility: nil, trace: nil)
            }
            var alternative = state; alternative.countryCode = code; alternative.householdID = other.id
            let eligibility = try EventEligibility.evaluate(event: definition, state: alternative, catalog: catalog)
            guard eligibility.eligible else {
                return .init(countryCode: code, comparable: false, reasons: eligibility.rejectionReasons, eligibility: eligibility, trace: nil)
            }
            let result = try DecisionResolver.resolve(state: alternative, eventID: definition.id, choiceID: choiceID,
                catalog: catalog.model, directedCatalog: catalog, occurrence: currentOffer.occurrence)
            return .init(countryCode: code, comparable: true, reasons: [], eligibility: eligibility, trace: result.trace)
        }
    }

    /// Codable only parses. Use restore/validate at a persistence boundary to verify the full replay.
    public static func restore(_ data: Data, catalog: EventCatalog) throws -> Self {
        let restored = try JSONDecoder().decode(Self.self, from: data)
        try restored.validate(catalog: catalog)
        return restored
    }

    public func validate(catalog: EventCatalog) throws {
        try checkStructure(catalog: catalog)
        var replay = try Self.start(catalog: catalog, countryCode: state.countryCode, householdID: state.householdID, seed: state.seed)
        for (index, trace) in traces.enumerated() {
            guard replay.currentOffer?.occurrence.id == trace.occurrenceID,
                  replay.currentOffer?.occurrence.eventID == trace.eventID else { throw ModelError.invalid("director replay selection") }
            try replay.choose(trace.choiceID, catalog: catalog)
            if index < traces.count - 1 || phase != .reflecting { try replay.continueLife(catalog: catalog) }
        }
        guard replay == self else { throw ModelError.invalid("director replay state/trace mismatch") }
    }

    private func checkStructure(catalog: EventCatalog) throws {
        try catalog.validate(); try state.validate(catalog: catalog.model, directedCatalog: catalog)
        guard traces.count == state.decisions.count, traces.count <= catalog.slots.count,
              phase != .choosing || traces.count < catalog.slots.count,
              selections.count == jumps.count,
              selections.count == traces.count + (phase == .choosing ? 1 : 0),
              phase != .reflecting || !traces.isEmpty,
              phase != .ended || traces.count == catalog.slots.count else { throw ModelError.invalid("director session structure") }
        for (index, trace) in traces.enumerated() {
            let record = state.decisions[index]
            guard trace.applied, trace.occurrenceID == record.occurrenceID, trace.eventID == record.eventID,
                  trace.choiceID == record.choiceID, trace.age == record.age,
                  selections[index].occurrence.id == record.occurrenceID,
                  selections[index].slotID == catalog.slots[index].id else { throw ModelError.invalid("director trace/history mismatch") }
        }
        if phase == .ended {
            guard currentOffer == nil else { throw ModelError.invalid("ended offer") }
        } else {
            guard let currentOffer, currentOffer.trace == selections.last,
                  currentOffer.occurrence == selections.last?.occurrence,
                  currentOffer.occurrence.age == state.age else { throw ModelError.invalid("director current offer") }
        }
        if phase == .choosing {
            let expected = try EventDirector.offer(state: state, slot: catalog.slots[traces.count], catalog: catalog)
            guard expected == currentOffer else { throw ModelError.invalid("forged director offer") }
            guard jumps.last?.resourcesAfter == state.resources else { throw ModelError.invalid("director resources differ from time jump") }
        } else if let last = traces.last {
            guard last.resourcesAfter == state.resources,
                  last.budgetAfter == Cost(time: state.remainingTime, energy: state.remainingEnergy, materials: state.remainingMaterials) else {
                throw ModelError.invalid("director resources differ from executed decision")
            }
        }
    }
}
