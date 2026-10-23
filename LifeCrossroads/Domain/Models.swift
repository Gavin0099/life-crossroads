import Foundation

public enum ModelError: Error, Equatable {
    case invalid(String)
    case missing(String)
    case unavailable(String)
}

public struct ResourceValues: Codable, Equatable, Sendable {
    public var health: Int
    public var financial: Int
    public var relationships: Int
    public var skills: Int

    public init(health: Int = 0, financial: Int = 0, relationships: Int = 0, skills: Int = 0) {
        self.health = health; self.financial = financial
        self.relationships = relationships; self.skills = skills
    }
    public static let zero = ResourceValues()
    public var values: [Int] { [health, financial, relationships, skills] }
    public func validate(in range: ClosedRange<Int>) throws {
        guard values.allSatisfy(range.contains) else { throw ModelError.invalid("resources") }
    }
    public static func + (lhs: Self, rhs: Self) -> Self {
        .init(health: lhs.health + rhs.health, financial: lhs.financial + rhs.financial,
              relationships: lhs.relationships + rhs.relationships, skills: lhs.skills + rhs.skills)
    }
    public static func - (lhs: Self, rhs: Self) -> Self {
        .init(health: lhs.health - rhs.health, financial: lhs.financial - rhs.financial,
              relationships: lhs.relationships - rhs.relationships, skills: lhs.skills - rhs.skills)
    }
    public var clamped: Self {
        .init(health: min(100, max(0, health)), financial: min(100, max(0, financial)),
              relationships: min(100, max(0, relationships)), skills: min(100, max(0, skills)))
    }
}

public enum LifeStage: String, Codable, CaseIterable, Sendable {
    case childhood, adolescence, youngAdult, middleAge, laterLife
    public static func at(age: Int) throws -> Self {
        switch age {
        case 0...12: .childhood
        case 13...22: .adolescence
        case 23...40: .youngAdult
        case 41...60: .middleAge
        case 61...100: .laterLife
        default: throw ModelError.invalid("age")
        }
    }
    public var timeBudget: Int {
        switch self { case .childhood: 4; case .middleAge, .laterLife: 5; default: 6 }
    }
    public var energyBudget: Int { self == .childhood || self == .laterLife ? 5 : 6 }
}

public struct SourceRecord: Codable, Equatable, Sendable {
    public let id: String
    public let publisher: String
    public let indicator: String
    public let url: String
    public let downloadURL: String
    public let license: String
    public let licenseURL: String
    public let licenseEvidenceURL: String
    public let attribution: String
    public let retrievedAt: String
    public let version: String
    public let rawPath: String
    public let sha256: String
    public let missingPolicy: String
    public let transformation: String
}

public struct DesignAssumption: Codable, Equatable, Sendable {
    public let id: String
    public let version: String
    public let statement: String
    public let limitation: String
}

public struct IndicatorObservation: Codable, Equatable, Sendable {
    public var indicator: String
    public var value: Double?
    public var year: Int
    public var region: String
    public var unit: String
    public var sourceID: String
    public var dataVersion: String
}

public enum DataStatus: String, Codable, Sendable { case ready, blocked }

public struct CountryProfile: Codable, Equatable, Sendable {
    public var code: String
    public var name: String
    public var dataStatus: DataStatus
    public var indicators: [IndicatorObservation]
    public var gaps: [String]
    public static let requiredIndicators = ["IT.NET.USER.ZS", "EG.ELC.ACCS.ZS"]
}

public enum DeviceAccess: String, Codable, Sendable {
    case own, shared, community
    public var schedulingCost: Int {
        switch self { case .own: 0; case .shared: 1; case .community: 2 }
    }
}

public struct HouseholdProfile: Codable, Equatable, Sendable {
    public var id: String
    public var countryCode: String
    public var templateID: String
    public var label: String
    public var deviceAccess: DeviceAccess
    public var travelCost: Int
    public var careLoad: Int
    public var mentorSupport: Int
    public var materialBudget: Int
    public var initialResources: ResourceValues
    public var assumptionIDs: [String]

    public func hasSameConditions(as other: Self) -> Bool {
        templateID == other.templateID && deviceAccess == other.deviceAccess && travelCost == other.travelCost
            && careLoad == other.careLoad && mentorSupport == other.mentorSupport
            && materialBudget == other.materialBudget && initialResources == other.initialResources
    }
}

public enum DecisionControl: String, Codable, Sendable {
    case personal, sharedWithAdult, adultResponsibility
}

public enum ChoiceKind: String, Codable, Sendable {
    case learn, rest, askSupport, work, care, share
}

public struct ChoiceDefinition: Codable, Equatable, Sendable {
    public var id: String
    public var title: String
    public var kind: ChoiceKind
    public var control: DecisionControl
    public var minimumAge: Int
    public var timeCost: Int
    public var energyCost: Int
    public var materialCost: Int
    public var effect: ResourceValues
    public var requiresDigitalAccess: Bool
    public var delayedHook: String?
    public var assumptionIDs: [String]
}

public struct DecisionSkeleton: Codable, Equatable, Sendable {
    public var id: String
    public var age: Int
    public var title: String
    public var recurringPerson: String
    public var storyQuestion: String
    public var choices: [ChoiceDefinition]
}

public struct ModelCatalog: Codable, Equatable, Sendable {
    public var schemaVersion: Int
    public var dataVersion: String
    public var contentVersion: String
    public var referenceYear: Int
    public var sources: [SourceRecord]
    public var assumptions: [DesignAssumption]
    public var countries: [CountryProfile]
    public var households: [HouseholdProfile]
    public var decisions: [DecisionSkeleton]

    public func validate() throws {
        guard schemaVersion == 2, !dataVersion.isEmpty, !contentVersion.isEmpty,
              (1960...2100).contains(referenceYear) else { throw ModelError.invalid("catalog version") }
        func unique(_ ids: [String]) throws {
            guard ids.allSatisfy({ !$0.isEmpty }), Set(ids).count == ids.count else {
                throw ModelError.invalid("duplicate or empty ID")
            }
        }
        try unique(sources.map(\.id)); try unique(assumptions.map(\.id))
        try unique(countries.map(\.code)); try unique(households.map(\.id)); try unique(decisions.map(\.id))
        let sourceMap = Dictionary(uniqueKeysWithValues: sources.map { ($0.id, $0) })
        let assumptionSet = Set(assumptions.map(\.id))
        let ruleAssumptions: Set<String> = ["macro-friction", "household-scenarios", "life-stages", "agency",
            "support-network", "choice-effects", "cost-fatigue", "luck-encouragement", "resource-bounds", "story-callback", "learning-channels"]
        guard ruleAssumptions.isSubset(of: assumptionSet) else { throw ModelError.missing("rule assumption") }
        func checkAssumptions(_ ids: [String]) throws {
            guard !ids.isEmpty, ids.allSatisfy(assumptionSet.contains) else {
                throw ModelError.missing("design assumption")
            }
        }
        for a in assumptions {
            guard !a.version.isEmpty, !a.statement.isEmpty, !a.limitation.isEmpty else {
                throw ModelError.invalid("assumption metadata")
            }
        }
        for s in sources {
            guard [s.url, s.downloadURL, s.licenseURL, s.licenseEvidenceURL].allSatisfy({ $0.hasPrefix("https://") }),
                  s.license == "CC-BY-4.0", !s.attribution.isEmpty, !s.publisher.isEmpty,
                  !s.retrievedAt.isEmpty, !s.version.isEmpty, !s.missingPolicy.isEmpty,
                  !s.transformation.isEmpty, s.sha256.count == 64,
                  s.sha256.allSatisfy({ $0.isHexDigit }), s.rawPath.hasPrefix("raw/"),
                  !s.rawPath.contains("..") else { throw ModelError.invalid("source metadata") }
        }
        for c in countries {
            try unique(c.indicators.map(\.indicator))
            guard !c.name.isEmpty else { throw ModelError.invalid("country name") }
            for i in c.indicators {
                guard let s = sourceMap[i.sourceID], s.indicator == i.indicator,
                      i.region == c.code, i.year == referenceYear, i.dataVersion == s.version,
                      i.unit == "% of population" else { throw ModelError.invalid("indicator provenance") }
                if let value = i.value {
                    guard value.isFinite, (0...100).contains(value) else { throw ModelError.invalid("indicator value") }
                }
            }
            if c.dataStatus == .ready {
                for indicator in CountryProfile.requiredIndicators {
                    guard c.indicators.contains(where: { $0.indicator == indicator && $0.value != nil }) else {
                        throw ModelError.missing("\(c.code):\(indicator)")
                    }
                }
            } else if c.gaps.isEmpty { throw ModelError.missing("blocked country gap") }
        }
        var templates: [String: HouseholdProfile] = [:]
        for h in households {
            guard countries.contains(where: { $0.code == h.countryCode }),
                  (0...2).contains(h.travelCost), (0...2).contains(h.careLoad),
                  (0...2).contains(h.mentorSupport), (0...4).contains(h.materialBudget),
                  !h.label.isEmpty, !h.templateID.isEmpty else { throw ModelError.invalid("household") }
            try h.initialResources.validate(in: 0...100)
            try checkAssumptions(h.assumptionIDs)
            if let previous = templates[h.templateID], !h.hasSameConditions(as: previous) {
                throw ModelError.invalid("inconsistent household template")
            }
            templates[h.templateID] = h
        }
        for c in countries { try unique(households.filter { $0.countryCode == c.code }.map(\.templateID)) }
        var previousAge = -1
        for d in decisions {
            _ = try LifeStage.at(age: d.age)
            guard d.age > previousAge, !d.choices.isEmpty, !d.recurringPerson.isEmpty,
                  !d.storyQuestion.isEmpty else { throw ModelError.invalid("decision sequence") }
            previousAge = d.age
            try unique(d.choices.map(\.id))
            for choice in d.choices {
                guard (0...100).contains(choice.minimumAge), (0...8).contains(choice.timeCost),
                      (0...8).contains(choice.energyCost), (0...4).contains(choice.materialCost) else {
                    throw ModelError.invalid("choice cost")
                }
                try choice.effect.validate(in: -20...20)
                try checkAssumptions(choice.assumptionIDs)
            }
            guard d.choices.contains(where: {
                $0.kind == .rest && $0.timeCost == 0 && $0.energyCost == 0 && $0.materialCost == 0
                    && !$0.requiresDigitalAccess && $0.control == .personal && $0.minimumAge <= d.age
            }) else {
                throw ModelError.missing("cost-free recovery choice")
            }
        }
    }
}
