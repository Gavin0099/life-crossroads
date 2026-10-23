import Foundation

public enum SessionPhase: String, Codable, Sendable { case choosing, reflecting, ended }

/// A value-type playthrough controller. UI owns presentation; this type owns legal progression.
public struct LifeSession: Codable, Equatable, Sendable {
    public private(set) var state: LifeState
    public private(set) var phase: SessionPhase
    public private(set) var traces: [ConsequenceTrace]
    public private(set) var jumps: [TimeJumpTrace]

    public static func start(catalog: ModelCatalog, countryCode: String, householdID: String, seed: UInt64) throws -> Self {
        guard let first = catalog.decisions.first else { throw ModelError.missing("first decision") }
        let born = try LifeState.born(catalog: catalog, countryCode: countryCode, householdID: householdID, seed: seed)
        let (state, jump) = try SimulationEngine.advance(born, to: first.age, catalog: catalog)
        return .init(state: state, phase: .choosing, traces: [], jumps: [jump])
    }

    public func event(catalog: ModelCatalog) throws -> DecisionSkeleton {
        guard phase == .choosing, traces.count < catalog.decisions.count else {
            throw ModelError.invalid("not choosing")
        }
        return StoryBranchEngine.project(event: catalog.decisions[traces.count], state: state).event
    }

    public func preview(choiceID: String, catalog: ModelCatalog) throws -> ConsequenceTrace {
        let event = try event(catalog: catalog)
        return try DecisionResolver.resolve(state: state, eventID: event.id, choiceID: choiceID, catalog: catalog).trace
    }

    public mutating func choose(_ choiceID: String, catalog: ModelCatalog) throws {
        let event = try event(catalog: catalog)
        let result = try DecisionResolver.resolve(state: state, eventID: event.id, choiceID: choiceID, catalog: catalog)
        guard result.trace.applied else { throw ModelError.unavailable(result.trace.unavailableReasons.joined(separator: "\n")) }
        state = result.state; traces.append(result.trace); phase = .reflecting
    }

    public mutating func continueLife(catalog: ModelCatalog) throws {
        guard phase == .reflecting, !traces.isEmpty, traces.count <= catalog.decisions.count,
              traces.count == state.decisions.count else { throw ModelError.invalid("no valid decision to continue") }
        if traces.count == catalog.decisions.count {
            phase = .ended
        } else {
            let (next, jump) = try SimulationEngine.advance(state, to: catalog.decisions[traces.count].age, catalog: catalog)
            state = next; jumps.append(jump); phase = .choosing
        }
    }

    /// A model-only comparison: keep past state, Seed, choice and family template fixed; change contextual indicators.
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
