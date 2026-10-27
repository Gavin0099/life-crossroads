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
    public private(set) var birthDraw: BirthDraw? = nil
    private var focusLog: [LifeFocusSelection]? = nil
    public var focusSelections: [LifeFocusSelection] { focusLog ?? [] }
    public var activeFocus: LifeFocus { focusSelections.last?.focus ?? .balanced }
    public var canChooseFocus: Bool {
        phase != .ended && (phase == .choosing ? traces.count : traces.count - 1) < plannedDecisionCount - 1
    }
    private var needsReplayValidation: Bool
    private enum CodingKeys: String, CodingKey { case state, phase, traces, jumps, selectionTraces, focusLog, birthDraw }

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
        focusLog = try box.decodeIfPresent([LifeFocusSelection].self, forKey: .focusLog)
        birthDraw = try box.decodeIfPresent(BirthDraw.self, forKey: .birthDraw)
        needsReplayValidation = true
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.state == rhs.state && lhs.phase == rhs.phase && lhs.traces == rhs.traces
            && lhs.jumps == rhs.jumps && lhs.selectionTraces == rhs.selectionTraces && lhs.focusSelections == rhs.focusSelections && lhs.birthDraw == rhs.birthDraw
    }

    public static func start(catalog: ModelCatalog, countryCode: String, householdID: String, seed: UInt64) throws -> Self {
        guard let firstAge = decisionAges.first else { throw ModelError.missing("first decision age") }
        let born = try LifeState.born(catalog: catalog, countryCode: countryCode, householdID: householdID, seed: seed)
        let (state, jump) = try SimulationEngine.advance(born, to: firstAge, catalog: catalog)
        let selection = try EventSelector.select(state: state, catalog: catalog)
        return .init(state: state, phase: .choosing, traces: [], jumps: [jump], selectionTraces: [selection])
    }

    public static func startRandom(catalog: ModelCatalog, seed: UInt64) throws -> Self {
        let receipt = try BirthDraw.draw(catalog: catalog, seed: seed)
        var life = try start(catalog: catalog, countryCode: receipt.countryCode, householdID: receipt.householdID, seed: seed)
        life.birthDraw = receipt
        return life
    }

    /// Recreate the birth through its original mode, validating its receipt instead of trusting saved metadata.
    public func restarting(catalog: ModelCatalog) throws -> Self {
        if let birthDraw {
            let fresh = try Self.startRandom(catalog: catalog, seed: state.seed)
            guard fresh.birthDraw == birthDraw, fresh.state.countryCode == state.countryCode,
                  fresh.state.householdID == state.householdID else { throw ModelError.invalid("birth receipt mismatch") }
            return fresh
        }
        return try Self.start(catalog: catalog, countryCode: state.countryCode, householdID: state.householdID, seed: state.seed)
    }

    public static func restore(from data: Data, catalog: ModelCatalog) throws -> Self {
        var restored = try JSONDecoder().decode(Self.self, from: data)
        try restored.validate(catalog: catalog)
        restored.needsReplayValidation = false
        return restored
    }

    /// Reconstruct the actual pre-choice state, including pending callbacks and selection draws.
    /// A past event ID alone is insufficient: repeatable events can occur at different ages.
    public func beforeDecision(at index: Int, catalog: ModelCatalog) throws -> Self {
        try validate(catalog: catalog)
        guard traces.indices.contains(index) else { throw ModelError.invalid("decision checkpoint index") }
        var replay = try restarting(catalog: catalog)
        for (slot, trace) in traces.prefix(index).enumerated() {
            try replayFocus(on: &replay, at: slot, phase: .choosing, catalog: catalog)
            try replay.choose(trace.choiceID, catalog: catalog)
            try replayFocus(on: &replay, at: slot, phase: .reflecting, catalog: catalog)
            try replay.continueLife(catalog: catalog)
        }
        try replayFocus(on: &replay, at: index, phase: .choosing, catalog: catalog)
        return replay
    }

    /// Full, catalog-backed replay checks every selected event, condition, random draw, outcome and time jump.
    /// Run at the restore boundary; trusted in-memory operations only check the current slot.
    public func validate(catalog: ModelCatalog) throws {
        try catalog.validate(); try state.validate(catalog: catalog)
        guard focusSelections.count <= 2 * (plannedDecisionCount - 1),
              traces.count <= plannedDecisionCount, selectionTraces.count <= plannedDecisionCount,
              traces.count == state.decisions.count else { throw ModelError.invalid("session history length") }
        var replay = try restarting(catalog: catalog)
        for (index, trace) in traces.enumerated() {
            guard replay.phase == .choosing else { throw ModelError.invalid("session phase history") }
            try replayFocus(on: &replay, at: index, phase: .choosing, catalog: catalog)
            try replay.choose(trace.choiceID, catalog: catalog)
            try replayFocus(on: &replay, at: index, phase: .reflecting, catalog: catalog)
            if index + 1 < traces.count || phase != .reflecting { try replay.continueLife(catalog: catalog) }
        }
        if phase == .choosing { try replayFocus(on: &replay, at: traces.count, phase: .choosing, catalog: catalog) }
        guard replay == self else { throw ModelError.invalid("session replay mismatch") }
    }

    /// Changing direction commits no resources and cannot reselect the revealed event.
    public mutating func chooseFocus(_ focus: LifeFocus, catalog: ModelCatalog) throws {
        if needsReplayValidation { try validate(catalog: catalog); needsReplayValidation = false }
        guard canChooseFocus, LifeFocus.available(at: state.age).contains(focus) else { throw ModelError.unavailable("focus stage") }
        let index = phase == .choosing ? traces.count : traces.count - 1
        var records = focusSelections
        records.removeAll { $0.decisionIndex == index && $0.phase == phase }
        records.append(.init(index: index, phase: phase, focus: focus))
        focusLog = records
    }

    private func replayFocus(on session: inout Self, at index: Int, phase: SessionPhase, catalog: ModelCatalog) throws {
        for record in focusSelections where record.decisionIndex == index && record.phase == phase {
            guard record.version == LifeFocusSelection.currentVersion else { throw ModelError.invalid("focus version") }
            try session.chooseFocus(record.focus, catalog: catalog)
        }
    }

    public func event(catalog: ModelCatalog) throws -> DecisionSkeleton {
        if needsReplayValidation { try validate(catalog: catalog) }
        guard phase == .choosing, traces.count < plannedDecisionCount,
              traces.count == state.decisions.count, selectionTraces.count == traces.count + 1,
              state.age == Self.decisionAges[traces.count],
              let selection = selectionTraces.last,
              selection == (try EventSelector.select(state: state, catalog: catalog)),
              let selected = catalog.decisions.first(where: { $0.id == selection.selectedEventID && $0.selection.includes(state.age) }) else {
            throw ModelError.invalid("not choosing a valid selected event")
        }
        return try StoryBranchEngine.project(event: selected, state: state, catalog: catalog).event
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
            let (next, jump) = try SimulationEngine.advance(state, to: Self.decisionAges[traces.count], catalog: catalog, focus: focusSelections.isEmpty ? nil : activeFocus)
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
    /// Snapshot comparison, not a claim about being born in a different household.
    /// Past resources/history remain fixed; only the current arrangements/material allowance change.
    public func compareHouseholds(choiceID: String, catalog: ModelCatalog) throws -> [ConsequenceTrace] {
        let event = try event(catalog: catalog)
        return try catalog.households.filter { $0.countryCode == state.countryCode }.sorted { $0.id < $1.id }.map { family in
            var alternative = state
            alternative.householdID = family.id
            alternative.remainingMaterials = family.materialBudget
            return try DecisionResolver.resolve(state: alternative, eventID: event.id, choiceID: choiceID, catalog: catalog).trace
        }
    }

}
