import Foundation

/// A complete pre-decision checkpoint. The session carries versions, story memory and pending hooks.
public struct LifeSnapshot: Codable, Equatable, Sendable {
    public let decisionIndex: Int
    public let randomVersion: String
    public let session: LifeSession
}

/// One immutable completed life and a separately played alternative. No automatic continuation policy.
public struct BranchExperiment: Codable, Equatable, Sendable {
    public static let currentVersion = "branch-experiment-1"
    public let version: String
    public let original: LifeSession
    public let snapshot: LifeSnapshot
    public let changedChoiceID: String
    public private(set) var alternative: LifeSession
    private var needsValidation: Bool
    private enum CodingKeys: String, CodingKey { case version, original, snapshot, changedChoiceID, alternative }

    public static func start(original: LifeSession, decisionIndex: Int, choiceID: String,
                             catalog: ModelCatalog) throws -> Self {
        guard original.phase == .ended else { throw ModelError.invalid("branch needs a completed original life") }
        let before = try original.beforeDecision(at: decisionIndex, catalog: catalog)
        guard choiceID != original.traces[decisionIndex].choiceID else { throw ModelError.invalid("branch must change the selected choice") }
        var alternative = before
        try alternative.choose(choiceID, catalog: catalog)
        return .init(original: original, snapshot: .init(decisionIndex: decisionIndex,
            randomVersion: KeyedRandom.version, session: before), changedChoiceID: choiceID, alternative: alternative)
    }

    private init(original: LifeSession, snapshot: LifeSnapshot, changedChoiceID: String, alternative: LifeSession) {
        version = Self.currentVersion; self.original = original; self.snapshot = snapshot
        self.changedChoiceID = changedChoiceID; self.alternative = alternative; needsValidation = false
    }

    public init(from decoder: Decoder) throws {
        let box = try decoder.container(keyedBy: CodingKeys.self)
        version = try box.decode(String.self, forKey: .version)
        original = try box.decode(LifeSession.self, forKey: .original)
        snapshot = try box.decode(LifeSnapshot.self, forKey: .snapshot)
        changedChoiceID = try box.decode(String.self, forKey: .changedChoiceID)
        alternative = try box.decode(LifeSession.self, forKey: .alternative)
        needsValidation = true
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.version == rhs.version && lhs.original == rhs.original && lhs.snapshot == rhs.snapshot
            && lhs.changedChoiceID == rhs.changedChoiceID && lhs.alternative == rhs.alternative
    }

    public func validate(catalog: ModelCatalog) throws {
        guard version == Self.currentVersion, snapshot.randomVersion == KeyedRandom.version,
              original.phase == .ended else { throw ModelError.invalid("branch version/original") }
        let before = try original.beforeDecision(at: snapshot.decisionIndex, catalog: catalog)
        guard before == snapshot.session else { throw ModelError.invalid("branch checkpoint mismatch") }
        try alternative.validate(catalog: catalog)
        let index = snapshot.decisionIndex
        let preservedFocus = alternative.focusSelections.filter {
            $0.decisionIndex < index || ($0.decisionIndex == index && $0.phase == .choosing)
        }
        guard preservedFocus == snapshot.session.focusSelections else { throw ModelError.invalid("branch focus prefix") }
        guard alternative.birthDraw == original.birthDraw,
              alternative.state.seed == original.state.seed,
              alternative.state.countryCode == original.state.countryCode,
              alternative.state.householdID == original.state.householdID,
              alternative.traces.count > index,
              alternative.traces.prefix(index) == original.traces.prefix(index),
              alternative.jumps.prefix(index + 1) == original.jumps.prefix(index + 1),
              alternative.selectionTraces.prefix(index + 1) == original.selectionTraces.prefix(index + 1),
              alternative.traces[index].eventID == original.traces[index].eventID,
              alternative.traces[index].choiceID == changedChoiceID,
              changedChoiceID != original.traces[index].choiceID else {
            throw ModelError.invalid("branch history/binding mismatch")
        }
    }

    public mutating func choose(_ choiceID: String, catalog: ModelCatalog) throws {
        if needsValidation { try validate(catalog: catalog) }
        var next = alternative
        try next.choose(choiceID, catalog: catalog)
        alternative = next; needsValidation = false
    }

    public mutating func chooseFocus(_ focus: LifeFocus, catalog: ModelCatalog) throws {
        if needsValidation { try validate(catalog: catalog) }
        var next = alternative
        try next.chooseFocus(focus, catalog: catalog)
        alternative = next; needsValidation = false
    }

    public mutating func continueLife(catalog: ModelCatalog) throws {
        if needsValidation { try validate(catalog: catalog) }
        var next = alternative
        try next.continueLife(catalog: catalog)
        alternative = next; needsValidation = false
    }
}

/// The persisted playing state has one source of truth; a branch never replaces its original life.
public enum LifeJourney: Codable, Equatable, Sendable {
    case single(LifeSession)
    case branch(BranchExperiment)
    case parallel(ParallelLifeExperiment)

    public var activeSession: LifeSession {
        switch self { case .single(let life): life; case .branch(let experiment): experiment.alternative; case .parallel(let pair): pair.alternative }
    }
    public var experiment: BranchExperiment? {
        if case .branch(let experiment) = self { return experiment }; return nil
    }
    public var parallelExperiment: ParallelLifeExperiment? {
        if case .parallel(let pair) = self { return pair }; return nil
    }
    public var comparisonOriginal: LifeSession? { experiment?.original ?? parallelExperiment?.original }
    public func validate(catalog: ModelCatalog) throws {
        switch self {
        case .single(let life): try life.validate(catalog: catalog)
        case .branch(let experiment): try experiment.validate(catalog: catalog)
        case .parallel(let pair): try pair.validate(catalog: catalog)
        }
    }
    public mutating func choose(_ choiceID: String, catalog: ModelCatalog) throws {
        switch self {
        case .single(var life): try life.choose(choiceID, catalog: catalog); self = .single(life)
        case .branch(var experiment): try experiment.choose(choiceID, catalog: catalog); self = .branch(experiment)
        case .parallel(var pair): try pair.choose(choiceID, catalog: catalog); self = .parallel(pair)
        }
    }
    public mutating func chooseFocus(_ focus: LifeFocus, catalog: ModelCatalog) throws {
        switch self {
        case .single(var life): try life.chooseFocus(focus, catalog: catalog); self = .single(life)
        case .branch(var experiment): try experiment.chooseFocus(focus, catalog: catalog); self = .branch(experiment)
        case .parallel(var pair): try pair.chooseFocus(focus, catalog: catalog); self = .parallel(pair)
        }
    }
    public mutating func continueLife(catalog: ModelCatalog) throws {
        switch self {
        case .single(var life): try life.continueLife(catalog: catalog); self = .single(life)
        case .branch(var experiment): try experiment.continueLife(catalog: catalog); self = .branch(experiment)
        case .parallel(var pair): try pair.continueLife(catalog: catalog); self = .parallel(pair)
        }
    }
}
