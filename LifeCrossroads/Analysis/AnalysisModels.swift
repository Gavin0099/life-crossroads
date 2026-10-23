import Foundation
import LifeDomain

public enum BatchPolicy: String, Codable, CaseIterable, Hashable, Sendable {
    case investFirst, supportFirst, restFirst, seededVariety
}

public enum ResourceName: String, Codable, CaseIterable, Hashable, Sendable {
    case health, financial, relationships, skills
    func read(_ values: ResourceValues) -> Int {
        switch self {
        case .health: values.health
        case .financial: values.financial
        case .relationships: values.relationships
        case .skills: values.skills
        }
    }
}

/// Counts and denominators remain authoritative. A zero denominator has no defined rate.
public struct CountRate: Codable, Equatable, Sendable {
    public let count: Int
    public let denominator: Int
    public let rate: Double?
    init(_ count: Int, of denominator: Int) {
        self.count = count; self.denominator = denominator
        self.rate = denominator == 0 ? nil : Double(count) / Double(denominator)
    }
}

public struct BatchBackground: Codable, Equatable, Hashable, Sendable {
    public let countryCode: String
    public let householdID: String
    public let templateID: String
}

public struct PolicyDefinition: Codable, Equatable, Sendable {
    public let policy: BatchPolicy
    public let priorityChoiceIDs: [String]
    public let preferredChoiceKinds: [ChoiceKind]
    public let fallbackChoiceIDs: [String]
    public let fallback: String
    public let randomChannel: String?
}

public struct CandidateOpportunity: Codable, Equatable, Sendable {
    public let eventID: String
    public let eligible: Bool
    public let conditions: [EventConditionEvaluation]
    public var selection: EventCandidateEvaluation? = nil
}

public struct BatchStep: Codable, Equatable, Sendable {
    public let age: Int
    public let eventID: String
    public let storyVariantID: String?
    public let choiceID: String
    public let chosenKind: ChoiceKind
    public let storyBranch: StoryBranchEvaluation?
    public let offeredChoiceIDs: [String]
    public let availableChoiceIDs: [String]
    public let resourcesBefore: ResourceValues
    public let resourcesAfter: ResourceValues
    public let requestedDeltaBeforeClamp: ResourceValues
    public let clampAdjustment: ResourceValues
    public let candidates: [CandidateOpportunity]
    public var eventCategory: String? = nil
}

public struct HookOrigin: Codable, Equatable, Sendable {
    public let hookID: String
    public let eventID: String
    public let choiceID: String
    public let dueAge: Int
    public let requestedEffect: ResourceValues
}

public struct BatchJump: Codable, Equatable, Sendable {
    public let fromAge: Int
    public let toAge: Int
    public let resourcesBefore: ResourceValues
    public let resourcesAfter: ResourceValues
    public let requestedDeltaBeforeClamp: ResourceValues
    public let clampAdjustment: ResourceValues
    public let originHooks: [HookOrigin]
}

public struct BatchRun: Codable, Equatable, Sendable {
    public let runID: String
    public let background: BatchBackground
    public let policy: BatchPolicy
    public let seed: UInt64
    public let initialResources: ResourceValues
    public let finalResources: ResourceValues
    public let steps: [BatchStep]
    /// Each actual session jump appears once, including birth-to-first-decision.
    public let timeJumps: [BatchJump]
    public var linkedStoryChains: [String]? = nil
}

public struct EventCoverage: Codable, Equatable, Sendable {
    public let eventID: String
    public let age: Int
    public let ageOpportunities: Int
    /// Denominator is the number of runs that reached this event's age slot.
    public let eligible: CountRate
    public let selected: CountRate
    public let selectedWhenEligible: CountRate
    public let eligibleButNotSelected: CountRate
    public let conditionFailures: [ConditionFailureFrequency]
    public var ageWindow: [Int]? = nil
    public var exclusionCounts: [String: Int]? = nil
}

public struct ConditionFailureFrequency: Codable, Equatable, Sendable {
    public let condition: EventCondition
    /// Denominator is evaluations of this condition, not all runs or all events.
    public let failed: CountRate
}

public struct StoryVariantFrequency: Codable, Equatable, Sendable {
    public let variantID: String
    public let frequency: CountRate
}

public struct StoryChainCoverage: Codable, Equatable, Sendable {
    public let ruleID: String
    public let originEventID: String
    public let outcomeEventID: String
    public let originObserved: CountRate
    public let outcomeWithTrace: CountRate
    public let traceMatchesPriorChoice: CountRate
    public let variants: [StoryVariantFrequency]
}

public struct ChoiceKindFrequency: Codable, Equatable, Sendable {
    public let kind: ChoiceKind
    public let frequency: CountRate
}

public struct ChoiceFrequency: Codable, Equatable, Sendable {
    public let eventID: String
    public let choiceID: String
    public let offeredOpportunities: Int
    public let availableOpportunities: Int
    /// Denominator is all encounters with this event, including when the choice was not offered.
    public let chosen: CountRate
}

public struct RouteFrequency: Codable, Equatable, Sendable {
    /// Canonical JSON: eventRoutes encodes [eventID]; storyRoutes encodes [{eventID, storyVariantID}].
    public let signature: String
    public let frequency: CountRate
}

public struct HammingBin: Codable, Equatable, Sendable {
    public let distance: Int
    public let frequency: CountRate
}

public struct PairDifferences: Codable, Equatable, Sendable {
    public let pairCount: Int
    public let eventIDHamming: [HammingBin]
    public let storyRouteHamming: [HammingBin]
}

public struct ValueBin: Codable, Equatable, Sendable {
    public let value: Int
    public let frequency: CountRate
}

public struct FirstSaturationBin: Codable, Equatable, Sendable {
    /// nil means never observed at 100. Age 0 is the initial background.
    public let age: Int?
    public let frequency: CountRate
}

public struct AgeSaturation: Codable, Equatable, Sendable {
    public let age: Int
    public let postDecisionAt100: CountRate
}

public struct StageSaturation: Codable, Equatable, Sendable {
    public let stage: LifeStage
    public let postDecisionAt100: CountRate
}

public struct ResourceSummary: Codable, Equatable, Sendable {
    public let resource: ResourceName
    public let finalValues: [ValueBin]
    public let finalAt100: CountRate
    public let everObservedAt100: CountRate
    public let firstObservedAt100Age: [FirstSaturationBin]
    public let byAge: [AgeSaturation]
    public let byStage: [StageSaturation]
}

public struct ClampResourceSummary: Codable, Equatable, Sendable {
    public let resource: ResourceName
    public let positiveNetGainSteps: Int
    /// Denominator is all decision/jump observations, including net-zero and negative requests.
    public let clippedAcrossAllSteps: CountRate
    /// Denominator is only observations with a net positive pre-clamp request in this resource.
    public let clippedPositiveSteps: CountRate
    public let fullyOffsetPositiveSteps: CountRate
    public let requestedPositivePoints: Int
    /// Denominator is requested net positive points, not the sum of individually positive effects.
    public let lostPositivePoints: CountRate
    public let lowerBoundAdjustmentPoints: Int
}

public enum ClampAttributionKind: String, Codable, Sendable {
    case decision, singleHookJump, aggregateHookJump
}

public struct ClampAttribution: Codable, Equatable, Sendable {
    public let kind: ClampAttributionKind
    public let resource: ResourceName
    public let age: Int
    public let fromAge: Int?
    public let eventID: String?
    public let choiceID: String?
    /// Multi-hook losses belong to the aggregate jump. No per-hook realized gain/loss is invented.
    public let originHooks: [HookOrigin]
    public let clippedOccurrences: CountRate
    public let lostPositivePoints: CountRate
}

public struct ClampSummary: Codable, Equatable, Sendable {
    public let totalObservations: Int
    /// Only defined for time jumps; includes zero-effect hooks.
    public let observationsWithHooks: Int?
    public let resources: [ClampResourceSummary]
    public let attributions: [ClampAttribution]
}

public struct CohortReport: Codable, Equatable, Sendable {
    public let background: BatchBackground
    public let policy: BatchPolicy
    public let runCount: Int
    public let eventCoverage: [EventCoverage]
    public let choiceHistogram: [ChoiceFrequency]
    public let choiceKinds: [ChoiceKindFrequency]
    /// Repetition of actual chosen action kinds, not an invented event-type taxonomy.
    public let adjacentSameChoiceKind: CountRate
    public let storyChains: [StoryChainCoverage]
    public let eventRoutes: [RouteFrequency]
    public let storyRoutes: [RouteFrequency]
    /// All unordered pairs of different Seeds within this background and policy.
    public let seedPairDifferences: PairDifferences
    public let resourceSummaries: [ResourceSummary]
    public let decisionClamps: ClampSummary
    public let timeJumpClamps: ClampSummary
    public var adjacentSameEventCategory: CountRate? = nil
    public var linkedChainCounts: [ValueBin]? = nil
    public var atLeastTwoLinkedChains: CountRate? = nil
}

public struct PolicyPairComparison: Codable, Equatable, Sendable {
    public let background: BatchBackground
    public let firstPolicy: BatchPolicy
    public let secondPolicy: BatchPolicy
    public let pairedSeeds: [UInt64]
    /// Same background and Seed, differing policies. This is separate from cross-Seed pairs.
    public let differences: PairDifferences
}

public struct BatchReport: Codable, Equatable, Sendable {
    public let schemaVersion: Int
    public let analysisVersion: String
    public let policyVersion: String
    public let engineVersion: String
    public let dataVersion: String
    public let contentVersion: String
    public let seeds: [UInt64]
    public let policies: [BatchPolicy]
    public let policyDefinitions: [PolicyDefinition]
    public let countryCodes: [String]
    public let decisionAges: [Int]
    public let runCount: Int
    public let cohorts: [CohortReport]
    public let policyComparisons: [PolicyPairComparison]
    public let runs: [BatchRun]
    public let claimBoundary: String
}
