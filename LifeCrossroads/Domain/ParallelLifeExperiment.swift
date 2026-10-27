import Foundation

/// Two personally played full lives. Shared external chance keys; different upbringing and later decisions.
public struct ParallelLifeExperiment: Codable, Equatable, Sendable {
    public static let currentVersion = "parallel-birth-1"
    public let version: String
    public let original: LifeSession
    public private(set) var alternative: LifeSession
    private var needsValidation: Bool
    private enum CodingKeys: String, CodingKey { case version, original, alternative }
    public static let wish = "嘗試做出自己的第一件作品"

    public static func matchingHouseholds(original: LifeSession, catalog: ModelCatalog) -> [HouseholdProfile] {
        guard let family = catalog.households.first(where: { $0.id == original.state.householdID }) else { return [] }
        return catalog.households.filter { candidate in candidate.countryCode != family.countryCode && candidate.hasSameConditions(as: family)
            && catalog.countries.first(where: { $0.code == candidate.countryCode })?.dataStatus != .blocked }
            .sorted { $0.id < $1.id }
    }

    public static func start(original: LifeSession, countryCode: String, householdID: String,
                             catalog: ModelCatalog, sameTemplateOnly: Bool = false) throws -> Self {
        try original.validate(catalog: catalog)
        if sameTemplateOnly && !matchingHouseholds(original: original, catalog: catalog).contains(where: { $0.id == householdID }) {
            throw ModelError.invalid("parallel comparison requires identical household conditions")
        }
        guard original.phase == .ended, householdID != original.state.householdID else {
            throw ModelError.invalid("parallel life needs a completed original and another upbringing")
        }
        let alternative = try LifeSession.start(catalog: catalog, countryCode: countryCode,
                                               householdID: householdID, seed: original.state.seed)
        return .init(original: original, alternative: alternative)
    }

    private init(original: LifeSession, alternative: LifeSession) {
        version = Self.currentVersion; self.original = original; self.alternative = alternative; needsValidation = false
    }
    public init(from decoder: Decoder) throws {
        let box = try decoder.container(keyedBy: CodingKeys.self)
        version = try box.decode(String.self, forKey: .version)
        original = try box.decode(LifeSession.self, forKey: .original)
        alternative = try box.decode(LifeSession.self, forKey: .alternative)
        needsValidation = true
    }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.version == rhs.version && lhs.original == rhs.original && lhs.alternative == rhs.alternative
    }
    public func validate(catalog: ModelCatalog) throws {
        guard version == Self.currentVersion, original.phase == .ended,
              original.state.seed == alternative.state.seed,
              original.state.householdID != alternative.state.householdID,
              alternative.birthDraw == nil else { throw ModelError.invalid("parallel birth binding") }
        try original.validate(catalog: catalog)
        try alternative.validate(catalog: catalog)
    }
    public mutating func choose(_ id: String, catalog: ModelCatalog) throws {
        if needsValidation { try validate(catalog: catalog) }
        var next = alternative; try next.choose(id, catalog: catalog)
        alternative = next; needsValidation = false
    }
    public mutating func chooseFocus(_ focus: LifeFocus, catalog: ModelCatalog) throws {
        if needsValidation { try validate(catalog: catalog) }
        var next = alternative; try next.chooseFocus(focus, catalog: catalog)
        alternative = next; needsValidation = false
    }
    public mutating func continueLife(catalog: ModelCatalog) throws {
        if needsValidation { try validate(catalog: catalog) }
        var next = alternative; try next.continueLife(catalog: catalog)
        alternative = next; needsValidation = false
    }
    public func comparison(catalog: ModelCatalog) throws -> [BranchComparisonRow] {
        try validate(catalog: catalog)
        guard alternative.phase == .ended else { throw ModelError.invalid("comparison needs two complete lives") }
        return original.traces.indices.map { i in
            .init(decisionIndex: i, original: original.traces[i], alternative: alternative.traces[i],
                  originalArrival: original.jumps[i], alternativeArrival: alternative.jumps[i])
        }
    }
}
