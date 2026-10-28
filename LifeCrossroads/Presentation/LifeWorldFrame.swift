import LifeDomain

public enum LifeWorldMomentKind: String, Sendable { case living, eventPaused, committedOutcome, ending }
public struct WorldActorProjection: Equatable, Sendable {
    public let personID: String
    public let role: String
    public let evidenceEventID: String?
}
public struct WorldChangeProjection: Equatable, Sendable {
    public enum Kind: String, Sendable { case resourceChange, relationship, memory, occurredChance, pendingClue, delayedConsequence, livedFocus }
    public let kind: Kind
    public let caption: String
    public let sourceEventID: String
    public let sourceChoiceID: String
    public let sourceAge: Int
    public let isOccurred: Bool
    public var factKey: String? = nil
    public var factValue: String? = nil
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
    /// Present only for an applied, saved trace. Rendering cannot infer an action from resources.
    public var committedChoiceID: String? = nil

    /// Only presentation may override the moment; authoritative age and evidence stay unchanged.
    public func presenting(_ moment: LifeWorldMomentKind) -> Self {
        .init(stage: stage, age: age, visualFromAge: visualFromAge, sceneID: sceneID,
              actors: actors, worldChanges: worldChanges, moment: moment, eventID: eventID, environmentGaps: environmentGaps, committedChoiceID: committedChoiceID)
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
            if let person = personID(event.recurringPerson) {
                actors.append(.init(personID: person, role: "inviter", evidenceEventID: event.id))
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
            // These saved choices name the recipient/participant in their actual resolved
            // story even when no relationship delta was applied. Presence is not support.
            if trace.age == 32, trace.eventID == "adult-boundary-calendar", trace.choiceID == "ask",
               personID(trace.recurringPerson) == "cheng" {
                actors.append(.init(personID: "cheng", role: "recipient", evidenceEventID: trace.eventID))
            }
            if trace.age == 72, trace.eventID == "later-reconnect", ["invest", "ask"].contains(trace.choiceID),
               let person = personID(trace.recurringPerson),
               (person == "ahe" && trace.storyVariantID == "later-reconnect-old-friend") ||
               (person == "cheng" && trace.storyVariantID == "later-reconnect-new-neighbor") {
                actors.append(.init(personID: person, role: "participant", evidenceEventID: trace.eventID))
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
            changes.append(.init(kind: .memory, caption: "故事記憶：\(memoryCaption(fact))（\(fact.age)歲）",
                sourceEventID: fact.eventID, sourceChoiceID: fact.choiceID, sourceAge: fact.age, isOccurred: true,
                factKey: fact.key, factValue: fact.value))
        }
        if let focus = state.focusHistory.last {
            changes.append(.init(kind: .livedFocus, caption: focus.caption, sourceEventID: "", sourceChoiceID: "",
                                 sourceAge: focus.fromAge, isOccurred: true, factKey: "lifeFocus", factValue: focus.focus.rawValue))
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
            sceneID: scene, actors: actors, worldChanges: changes, moment: moment, eventID: eventID, environmentGaps: gaps,
            committedChoiceID: session.phase == .reflecting ? session.traces.last?.choiceID : nil)
    }

    public static func memoryCaption(_ fact: StoryFact) -> String {
        switch (fact.key, fact.value) {
        case ("learning", "online"): "留下線上創作經驗"
        case ("learning", "paper"): "留下紙本創作經驗"
        case ("learning", "none"): "這次未建立作品，仍可重新尋找起點"
        case ("friendship", "connected"): "保留與阿禾的連結"
        case ("friendship", "paused"): "暫緩聯絡，仍可建立新連結"
        case ("care", "shared"): "建立共同照顧安排"
        case ("care", "paused"): "先為照顧責任留出休息"
        case ("budget", "staged"): "整理預算，約定分段添購工具"
        case ("support", "requested"): "已提出求助，尚未確認協助安排"
        case ("support", "arranged"): "和夥伴確認了一段協助時間"
        case ("support", "reciprocal"): "自願和曾經互助的夥伴分擔一小段工作"
        case ("recovery", "protected"): "留下一段休息空白，沒有答應額外負擔"
        case ("recovery", "paced"): "試過短時段參與，找到自己的步調"
        case ("recovery", "returned"): "把適合自己的步調帶回共同活動"
        case ("careAccess", "reserved"): "預留看診時間與材料，尚未代表治療結果"
        case ("careAccess", "shared"): "列好共同預備清單，尚未完成預約"
        case ("careAccess", "followed"): "重新核對了先前的生活與看診安排"
        case ("tools", "powered"): "在現場練過電動工具的安全檢查"
        case ("tools", "portable"): "備好手動攜帶箱，練過分段修理"
        case ("tools", "manual"): "用手動工具練過基本檢查"
        case ("tools", "cooperating"): "用實際練過的方法參與一份修理合作"
        case (_, "seeking"): "已說出需要，正在尋找協助"
        case ("repair", "practiced"): "留下修理練習"
        case ("kitchen", "shared"): "參與共食安排"
        case ("garden", "tending"): "留下照顧花園的經驗"
        case ("nature", "observing"): "留下觀察自然的經驗"
        default: "留下這次行動的記錄"
        }
    }

    /// Known display names and stable IDs only; generic partners cannot become invented people.
    public static func personID(_ name: String) -> String? {
        switch name {
        case "mumu", "沐沐": "mumu"
        case "ahe", "阿禾": "ahe"
        case "teacher", "樹老師": "teacher"
        case "cheng", "小澄": "cheng"
        default: nil
        }
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
