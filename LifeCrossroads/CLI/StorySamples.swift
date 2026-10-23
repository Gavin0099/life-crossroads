import Foundation
import LifeData
import LifeDomain

struct StorySampleChoice: Codable, Equatable {
    let id: String
    let title: String
    let available: Bool
    let cost: Cost
    let unavailableReasons: [String]
}

struct StorySampleStep: Codable, Equatable {
    let number: Int
    let age: Int
    let stage: String
    let eventID: String
    let title: String
    let narrative: String
    let person: String
    let storyVariantID: String?
    let choiceID: String
    let choiceTitle: String
    let offeredChoices: [StorySampleChoice]
    let selectionTrace: EventSelectionTrace
    let consequenceTrace: ConsequenceTrace
}

struct StorySampleFinal: Codable {
    let phase: SessionPhase
    let age: Int
    let decisionCount: Int
    let completedStages: [String]
    let resources: ResourceValues
    let triggeredStoryHooks: [StoryHook]
    let pendingStoryHooks: [StoryHook]
}

struct StorySampleVerification: Codable {
    let sameSeedAndPolicyExactSessionAndSteps: Bool
    let recordedChoicesExactSessionAndSteps: Bool
    let codableAfterDecision: Int
    let codableResumeExactSessionAndSteps: Bool
}

struct StorySampleRun: Codable {
    let seed: UInt64
    let steps: [StorySampleStep]
    let finalSummary: StorySampleFinal
    let verification: StorySampleVerification
}

struct StorySampleDifference: Codable {
    let age: Int
    let firstEventID: String
    let firstTitle: String
    let firstPerson: String
    let secondEventID: String
    let secondTitle: String
    let secondPerson: String
}

struct StorySamplePair: Codable {
    let firstSeed: UInt64
    let secondSeed: UInt64
    let differentEvents: [StorySampleDifference]
}

struct StorySampleEvidence: Codable {
    let schemaVersion: Int
    let purpose: String
    let countryCode: String
    let householdID: String
    let policy: [String]
    let engineVersion: String
    let dataVersion: String
    let contentVersion: String
    let catalogEventCount: Int
    let runs: [StorySampleRun]
    let pairwiseComparisons: [StorySamplePair]
    let claimBoundary: String
}

enum StorySampleRunner {
    static let policy = ["invest", "first available learn/work/share/care in offered order", "askSupport", "rest"]
    private static let seeds: [UInt64] = [0, 1, 2]
    private static let countryCode = "JPN"
    private static let householdID = "jpn-1"
    private static let resumeAfterDecision = 7

    /// This fixed action policy is applied independently to every offered set.
    static func choose(from available: [ChoiceDefinition]) throws -> String {
        if available.contains(where: { $0.id == "invest" }) { return "invest" }
        if let active = available.first(where: { [.learn, .work, .share, .care].contains($0.kind) }) { return active.id }
        if let support = available.first(where: { $0.kind == .askSupport }) { return support.id }
        guard let first = available.first else { throw ModelError.invalid("story sample has no available choice") }
        return first.id
    }

    static func evidence(catalog: ModelCatalog) throws -> StorySampleEvidence {
        var reports: [StorySampleRun] = []
        for seed in seeds {
            let original = try play(seed: seed, catalog: catalog)
            let repeated = try play(seed: seed, catalog: catalog)
            guard original.session == repeated.session, original.steps == repeated.steps else {
                throw ModelError.invalid("same Seed/policy did not reproduce complete session and steps: \(seed)")
            }
            let replay = try play(seed: seed, catalog: catalog, recordedSteps: original.steps)
            guard original.session == replay.session, original.steps == replay.steps else {
                throw ModelError.invalid("recorded decisions did not reproduce complete session and steps: \(seed)")
            }
            let resumed = try play(seed: seed, catalog: catalog, recordedSteps: original.steps,
                                   codableAfterDecision: resumeAfterDecision)
            guard original.session == resumed.session, original.steps == resumed.steps else {
                throw ModelError.invalid("Codable resume did not reproduce complete session and steps: \(seed)")
            }
            let session = original.session
            var stages: [String] = []
            for step in original.steps where !stages.contains(step.stage) { stages.append(step.stage) }
            reports.append(.init(seed: seed, steps: original.steps,
                                 finalSummary: .init(phase: session.phase, age: session.state.age,
                                                     decisionCount: session.traces.count, completedStages: stages,
                                                     resources: session.state.resources,
                                                     triggeredStoryHooks: session.state.memories,
                                                     pendingStoryHooks: session.state.pendingHooks),
                                 verification: .init(sameSeedAndPolicyExactSessionAndSteps: true,
                                                     recordedChoicesExactSessionAndSteps: true,
                                                     codableAfterDecision: resumeAfterDecision,
                                                     codableResumeExactSessionAndSteps: true)))
        }
        var pairs: [StorySamplePair] = []
        for firstIndex in reports.indices {
            for secondIndex in reports.indices where secondIndex > firstIndex {
                let first = reports[firstIndex], second = reports[secondIndex]
                let differences = zip(first.steps, second.steps).compactMap { left, right -> StorySampleDifference? in
                    guard left.eventID != right.eventID else { return nil }
                    return .init(age: left.age, firstEventID: left.eventID, firstTitle: left.title,
                                 firstPerson: left.person, secondEventID: right.eventID,
                                 secondTitle: right.title, secondPerson: right.person)
                }
                guard !differences.isEmpty else {
                    throw ModelError.invalid("predeclared Seeds \(first.seed)/\(second.seed) selected identical event routes")
                }
                pairs.append(.init(firstSeed: first.seed, secondSeed: second.seed, differentEvents: differences))
            }
        }
        return .init(schemaVersion: 1,
                     purpose: "同國同家庭、預先指定 Seed 0/1/2、相同選擇策略的完整人生與重播核驗。",
                     countryCode: countryCode, householdID: householdID, policy: policy,
                     engineVersion: LifeState.engineVersion, dataVersion: catalog.dataVersion,
                     contentVersion: catalog.contentVersion, catalogEventCount: catalog.decisions.count,
                     runs: reports, pairwiseComparisons: pairs,
                     claimBoundary: "事件條件、抽選及效果是明示的遊戲設計；不是現實事件機率、國家排名、真人趣味性或兒少教育成效證明。")
    }

    private struct PlayedLife {
        let session: LifeSession
        let steps: [StorySampleStep]
    }

    private static func play(seed: UInt64, catalog: ModelCatalog, recordedSteps: [StorySampleStep]? = nil,
                             codableAfterDecision: Int? = nil) throws -> PlayedLife {
        var session = try LifeSession.start(catalog: catalog, countryCode: countryCode,
                                           householdID: householdID, seed: seed)
        var steps: [StorySampleStep] = []
        while session.phase != .ended {
            guard session.phase == .choosing, steps.count < 15 else {
                throw ModelError.invalid("story sample must progress through exactly 15 decision slots")
            }
            let event = try session.event(catalog: catalog)
            guard let narrative = EventNarratives.texts[event.storyVariantID ?? event.id], !narrative.isEmpty else {
                throw ModelError.missing("story sample narrative: \(event.storyVariantID ?? event.id)")
            }
            guard let selection = session.currentSelection, selection.selectedEventID == event.id else {
                throw ModelError.invalid("displayed event lacks its actual selection trace")
            }
            let previews = try event.choices.map { choice in
                let trace = try session.preview(choiceID: choice.id, catalog: catalog)
                return StorySampleChoice(id: choice.id, title: choice.title, available: trace.applied,
                                         cost: trace.finalCost, unavailableReasons: trace.unavailableReasons)
            }
            let choiceID: String
            if let recordedSteps {
                guard recordedSteps.indices.contains(steps.count),
                      recordedSteps[steps.count].eventID == event.id,
                      recordedSteps[steps.count].age == session.state.age else {
                    throw ModelError.invalid("replay changed the selected event or age")
                }
                choiceID = recordedSteps[steps.count].choiceID
            } else {
                let availableIDs = Set(previews.filter(\.available).map(\.id))
                choiceID = try choose(from: event.choices.filter { availableIDs.contains($0.id) })
            }
            try session.choose(choiceID, catalog: catalog)
            guard let trace = session.traces.last, trace.applied,
                  trace.eventID == event.id, trace.choiceID == choiceID,
                  trace.eventSelection == selection else {
                throw ModelError.invalid("executed choice/selection differs from the displayed event")
            }
            steps.append(.init(number: steps.count + 1, age: trace.age,
                               stage: try LifeStage.at(age: trace.age).rawValue,
                               eventID: trace.eventID, title: trace.eventTitle, narrative: narrative, person: trace.recurringPerson,
                               storyVariantID: trace.storyVariantID, choiceID: trace.choiceID,
                               choiceTitle: trace.choiceTitle, offeredChoices: previews,
                               selectionTrace: selection, consequenceTrace: trace))
            if let codableAfterDecision, steps.count == codableAfterDecision {
                let encoded = try JSONEncoder().encode(session)
                session = try JSONDecoder().decode(LifeSession.self, from: encoded)
                try session.validate(catalog: catalog)
            }
            try session.continueLife(catalog: catalog)
        }
        guard steps.count == 15, session.state.age == 80,
              Set(steps.map(\.stage)) == Set(LifeStage.allCases.map(\.rawValue)) else {
            throw ModelError.invalid("story sample did not finish all five stages and 15 decisions at the age-80 review")
        }
        try session.validate(catalog: catalog)
        return .init(session: session, steps: steps)
    }
}
