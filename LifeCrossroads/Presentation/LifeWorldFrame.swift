import LifeDomain

public enum LifeWorldMomentKind: String, Sendable { case living, eventPaused, committedOutcome, ending }
public struct WorldActorProjection: Equatable, Sendable {
    public let personID: String
    public let role: String
    public let evidenceEventID: String?
}
public struct WorldChangeProjection: Equatable, Sendable {
    public enum Kind: String, Sendable { case resourceChange, relationship, memory, occurredChance, pendingClue, delayedConsequence }
    public let kind: Kind
    public let caption: String
    public let sourceEventID: String
    public let sourceChoiceID: String
    public let sourceAge: Int
    public let isOccurred: Bool
}
public struct LifeWorldFrame: Equatable, Sendable {
    public let stage: LifeStage
    public let age: Int
    public let visualFromAge: Int?
    public let sceneID: String
    public let actors: [WorldActorProjection]
    public let worldChanges: [WorldChangeProjection]
    public let moment: LifeWorldMomentKind
    public let eventID: String?
    public let environmentGaps: [String]

    /// Only presentation may override the moment; authoritative age and evidence stay unchanged.
    public func presenting(_ moment: LifeWorldMomentKind) -> Self {
        .init(stage: stage, age: age, visualFromAge: visualFromAge, sceneID: sceneID,
              actors: actors, worldChanges: worldChanges, moment: moment, eventID: eventID, environmentGaps: environmentGaps)
    }
}

public enum WorldMomentProjector {
    public static func project(session: LifeSession, catalog: ModelCatalog) throws -> LifeWorldFrame {
        let state = session.state
        let stage = try LifeStage.at(age: state.age)
        var actors = [WorldActorProjection(personID: "mumu", role: "protagonist", evidenceEventID: nil)]
        var changes: [WorldChangeProjection] = []
        let eventID: String?
        var gaps: [String] = []
        let moment: LifeWorldMomentKind
        switch session.phase {
        case .choosing:
            let event = try session.event(catalog: catalog)
            eventID = event.id; moment = .eventPaused
            // An inviter can be present without having helped the player yet.
            if !event.recurringPerson.isEmpty {
                actors.append(.init(personID: event.recurringPerson, role: "inviter", evidenceEventID: event.id))
            }
        case .reflecting:
            guard let trace = session.traces.last, trace.applied else { throw ModelError.invalid("missing committed outcome") }
            eventID = trace.eventID; moment = .committedOutcome; gaps = trace.environmentGaps
            let delta = trace.resourcesAfter - trace.resourcesBefore
            if delta != .zero {
                changes.append(.init(kind: .resourceChange,
                    caption: "本次實際變化：健康\(signed(delta.health))、財務\(signed(delta.financial))、人際\(signed(delta.relationships))、技能\(signed(delta.skills))",
                    sourceEventID: trace.eventID, sourceChoiceID: trace.choiceID, sourceAge: trace.age, isOccurred: true))
            }
            for relation in trace.changedRelationships {
                guard relation.interactions.contains(where: { $0.eventID == trace.eventID && $0.choiceID == trace.choiceID && $0.age == trace.age }) else { continue }
                actors.append(.init(personID: relation.personID, role: "interacted", evidenceEventID: trace.eventID))
                changes.append(.init(kind: .relationship, caption: "與\(personName(relation.personID))留下互動紀錄。",
                    sourceEventID: trace.eventID, sourceChoiceID: trace.choiceID, sourceAge: trace.age, isOccurred: true))
            }
            if trace.randomTrial?.occurred == true {
                for step in trace.effectSteps where step.influence == .randomness && step.delta != .zero {
                    changes.append(.init(kind: .occurredChance, caption: step.explanation,
                        sourceEventID: trace.eventID, sourceChoiceID: trace.choiceID, sourceAge: trace.age, isOccurred: true))
                }
            }
        case .ended: eventID = nil; moment = .ending
        }
        // Persistent objects are backed by retained facts, including rest/recovery facts.
        for fact in state.story.flags {
            changes.append(.init(kind: .memory, caption: "故事記憶：\(fact.key)＝\(fact.value)（\(fact.age)歲）",
                sourceEventID: fact.eventID, sourceChoiceID: fact.choiceID, sourceAge: fact.age, isOccurred: true))
        }
        for hook in state.pendingHooks {
            changes.append(.init(kind: .pendingClue, caption: "留下線索，尚未實現：\(hook.text)",
                sourceEventID: hook.originEventID, sourceChoiceID: hook.originChoiceID, sourceAge: hook.originAge, isOccurred: false))
        }
        for hook in session.jumps.last?.triggeredHooks ?? [] {
            changes.append(.init(kind: .delayedConsequence, caption: "\(hook.dueAge)歲的呼應：\(hook.text)",
                sourceEventID: hook.originEventID, sourceChoiceID: hook.originChoiceID, sourceAge: hook.originAge, isOccurred: true))
        }
        let scene = state.age == 13 && eventID == "teen-project" ? "workshop" : stage == .childhood ? "river" : "community"
        return .init(stage: stage, age: state.age, visualFromAge: session.jumps.last?.fromAge,
            sceneID: scene, actors: actors, worldChanges: changes, moment: moment, eventID: eventID, environmentGaps: gaps)
    }

    public static func personName(_ id: String) -> String {
        switch id { case "mumu": "沐沐"; case "ahe": "阿禾"; case "teacher": "樹老師"; case "cheng": "小澄"; default: id }
    }
    private static func signed(_ n: Int) -> String { n > 0 ? "+\(n)" : "\(n)" }
}

/// Rendering-only input. Supplied by Gameplay's accumulated clock; never draw game randomness here.
public struct PresentationMotionFrame: Equatable, Sendable {
    public let elapsedMs: Double
    public let frozen: Bool
    public let reduceMotion: Bool
    public let phase: LifeWorldMomentKind
    public let phaseToken: String
    public let phaseElapsedMs: Double
    public init(elapsedMs: Double, frozen: Bool, reduceMotion: Bool, phase: LifeWorldMomentKind,
                phaseToken: String, phaseElapsedMs: Double) {
        self.elapsedMs = elapsedMs; self.frozen = frozen; self.reduceMotion = reduceMotion
        self.phase = phase; self.phaseToken = phaseToken; self.phaseElapsedMs = phaseElapsedMs
    }
}
