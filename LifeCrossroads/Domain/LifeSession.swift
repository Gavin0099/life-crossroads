import Foundation

public enum SessionPhase: String, Codable, Sendable { case choosing, reflecting, ended }

/// A value-type playthrough controller. UI owns presentation; this type owns legal progression.
public struct LifeSession: Codable, Equatable, Sendable {
    public static let decisionAges = EventSchedule.decisionAges
    public var plannedDecisionCount: Int { Self.decisionAges.count }
    public private(set) var state: LifeState
    public private(set) var phase: SessionPhase
    public private(set) var traces: [ConsequenceTrace]
    public private(set) var jumps: [TimeJumpTrace]
    public private(set) var selectionTraces: [EventSelectionTrace]
    public var currentSelection: EventSelectionTrace? { phase == .ended ? nil : selectionTraces.last }
    private var needsReplayValidation: Bool
    private enum CodingKeys: String, CodingKey { case state, phase, traces, jumps, selectionTraces }

    private init(state: LifeState, phase: SessionPhase, traces: [ConsequenceTrace], jumps: [TimeJumpTrace],
                 selectionTraces: [EventSelectionTrace]) {
        self.state = state; self.phase = phase; self.traces = traces; self.jumps = jumps
        self.selectionTraces = selectionTraces; self.needsReplayValidation = false
    }

    /// Raw decoding is untrusted until a catalog-backed replay succeeds. Public operations enforce that boundary.
    public init(from decoder: Decoder) throws {
        let box = try decoder.container(keyedBy: CodingKeys.self)
        state = try box.decode(LifeState.self, forKey: .state)
        phase = try box.decode(SessionPhase.self, forKey: .phase)
        traces = try box.decode([ConsequenceTrace].self, forKey: .traces)
        jumps = try box.decode([TimeJumpTrace].self, forKey: .jumps)
        selectionTraces = try box.decode([EventSelectionTrace].self, forKey: .selectionTraces)
        needsReplayValidation = true
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.state == rhs.state && lhs.phase == rhs.phase && lhs.traces == rhs.traces
            && lhs.jumps == rhs.jumps && lhs.selectionTraces == rhs.selectionTraces
    }

    public static func start(catalog: ModelCatalog, countryCode: String, householdID: String, seed: UInt64) throws -> Self {
        guard let firstAge = decisionAges.first else { throw ModelError.missing("first decision age") }
        let born = try LifeState.born(catalog: catalog, countryCode: countryCode, householdID: householdID, seed: seed)
        let (state, jump) = try SimulationEngine.advance(born, to: firstAge, catalog: catalog)
        let selection = try EventSelector.select(state: state, catalog: catalog)
        return .init(state: state, phase: .choosing, traces: [], jumps: [jump], selectionTraces: [selection])
    }

    public static func restore(from data: Data, catalog: ModelCatalog) throws -> Self {
        var restored = try JSONDecoder().decode(Self.self, from: data)
        try restored.validate(catalog: catalog)
        restored.needsReplayValidation = false
        return restored
    }

    /// Full, catalog-backed replay checks every selected event, condition, random draw, outcome and time jump.
    /// Run at the restore boundary; trusted in-memory operations only check the current slot.
    public func validate(catalog: ModelCatalog) throws {
        try catalog.validate(); try state.validate(catalog: catalog)
        guard traces.count <= plannedDecisionCount, selectionTraces.count <= plannedDecisionCount,
              traces.count == state.decisions.count else { throw ModelError.invalid("session history length") }
        var replay = try Self.start(catalog: catalog, countryCode: state.countryCode, householdID: state.householdID, seed: state.seed)
        for (index, trace) in traces.enumerated() {
            guard replay.phase == .choosing else { throw ModelError.invalid("session phase history") }
            try replay.choose(trace.choiceID, catalog: catalog)
            if index + 1 < traces.count || phase != .reflecting { try replay.continueLife(catalog: catalog) }
        }
        guard replay == self else { throw ModelError.invalid("session replay mismatch") }
    }

    public func event(catalog: ModelCatalog) throws -> DecisionSkeleton {
        if needsReplayValidation { try validate(catalog: catalog) }
        guard phase == .choosing, traces.count < plannedDecisionCount,
              traces.count == state.decisions.count, selectionTraces.count == traces.count + 1,
              state.age == Self.decisionAges[traces.count],
              let selection = selectionTraces.last,
              selection == (try EventSelector.select(state: state, catalog: catalog)),
              let selected = catalog.decisions.first(where: { $0.id == selection.selectedEventID && $0.age == state.age }) else {
            throw ModelError.invalid("not choosing a valid selected event")
        }
        return StoryBranchEngine.project(event: selected, state: state).event
    }

    public func preview(choiceID: String, catalog: ModelCatalog) throws -> ConsequenceTrace {
        let event = try event(catalog: catalog)
        return try DecisionResolver.resolve(state: state, eventID: event.id, choiceID: choiceID, catalog: catalog).trace
    }

    public mutating func choose(_ choiceID: String, catalog: ModelCatalog) throws {
        if needsReplayValidation { try validate(catalog: catalog); needsReplayValidation = false }
        let event = try event(catalog: catalog)
        let result = try DecisionResolver.resolve(state: state, eventID: event.id, choiceID: choiceID, catalog: catalog)
        guard result.trace.applied else { throw ModelError.unavailable(result.trace.unavailableReasons.joined(separator: "\n")) }
        state = result.state; traces.append(result.trace); phase = .reflecting
    }

    public mutating func continueLife(catalog: ModelCatalog) throws {
        if needsReplayValidation { try validate(catalog: catalog); needsReplayValidation = false }
        try catalog.validate()
        try state.validate(catalog: catalog)
        guard phase == .reflecting, !traces.isEmpty, traces.count <= plannedDecisionCount,
              traces.count == state.decisions.count, selectionTraces.count == traces.count,
              state.age == Self.decisionAges[traces.count - 1],
              traces.last?.eventSelection == selectionTraces.last,
              traces.last?.eventID == state.decisions.last?.eventID else {
            throw ModelError.invalid("no valid decision to continue")
        }
        if traces.count == plannedDecisionCount {
            phase = .ended
        } else {
            let (next, jump) = try SimulationEngine.advance(state, to: Self.decisionAges[traces.count], catalog: catalog)
            let selection = try EventSelector.select(state: next, catalog: catalog)
            state = next; jumps.append(jump); selectionTraces.append(selection); phase = .choosing
        }
    }

    /// Keep the actual selected event, past state, Seed, choice and family template fixed; change contextual indicators.
    public func compare(choiceID: String, countryCodes: [String], catalog: ModelCatalog) throws -> [ConsequenceTrace] {
        let event = try event(catalog: catalog)
        guard let current = catalog.households.first(where: { $0.id == state.householdID }) else {
            throw ModelError.missing("family comparison template")
        }
        return try countryCodes.map { code in
            guard let family = catalog.households.first(where: { $0.countryCode == code && $0.templateID == current.templateID }),
                  current.hasSameConditions(as: family) else { throw ModelError.missing("comparable family") }
            var alternative = state
            alternative.countryCode = code; alternative.householdID = family.id
            return try DecisionResolver.resolve(state: alternative, eventID: event.id, choiceID: choiceID, catalog: catalog).trace
        }
    }
}
