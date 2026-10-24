import LifeDomain

public enum LifeWorldActor: String, Equatable, Sendable { case mumu, ahe, teacher, cheng }
public enum LifeWorldBehavior: String, Equatable, Sendable { case idle, walking, interacting }
public enum LifeWorldExpression: String, Equatable, Sendable { case calm, attentive, resting }
public enum LifeWorldLight: String, Equatable, Sendable { case day, evening }
public enum LifeWorldObjectKind: String, Equatable, Sendable { case activity, friendship, learning, care, repair, kitchen, garden, nature }

public struct LifeWorldCharacter: Equatable, Sendable, Identifiable {
    public let actor: LifeWorldActor
    public let age: Int
    public let behavior: LifeWorldBehavior
    public let expression: LifeWorldExpression
    public var id: String { actor.rawValue }
}
public struct LifeWorldSource: Equatable, Sendable {
    public let eventID: String
    public let choiceID: String
    public let age: Int
}
public struct LifeWorldChange: Equatable, Sendable, Identifiable {
    public let kind: LifeWorldObjectKind
    public let value: String
    public let title: String
    public let source: LifeWorldSource
    public var id: String { kind.rawValue }
}

/// Frozen WORLD-ART-01 input. Visuals consume it; no callbacks that choose, draw randomness or save.
/// Age/progress/light during travel are choreography. Event outcomes/facts only come from committed history.
public struct LifeWorldViewState: Equatable, Sendable {
    public static let contractVersion = "life-world-view-1"
    public let age: Int
    public let targetAge: Int
    public let stageID: String
    public let sceneID: String
    public let phase: LifeWorldPhase
    public let characters: [LifeWorldCharacter]
    public let visibleChanges: [LifeWorldChange]
    public let isEventPaused: Bool
    public let isMotionPaused: Bool
    public let progress: Double
    public let light: LifeWorldLight

    public init(session: LifeSession, playback: LifePlayback, event: DecisionSkeleton?) {
        age = playback.displayAge
        targetAge = session.state.age
        stageID = (try? LifeStage.at(age: age).rawValue) ?? "childhood"
        sceneID = "river-home"
        phase = playback.phase
        progress = playback.progress
        light = playback.progress >= 0.55 ? .evening : .day
        isEventPaused = playback.phase == .event
        isMotionPaused = !playback.isRunning
        let trace = session.traces.last
        var cast = [LifeWorldCharacter(actor: .mumu, age: age,
            behavior: playback.isRunning ? .walking : (playback.phase == .consequence && trace?.choiceID != "rest" ? .interacting : .idle),
            expression: playback.phase == .consequence && trace?.choiceID == "rest" ? .resting : .calm)]
        let names: [String: LifeWorldActor] = ["阿禾": .ahe, "樹老師": .teacher, "小澄": .cheng]
        let people: [String: LifeWorldActor] = ["ahe": .ahe, "teacher": .teacher, "cheng": .cheng]
        if playback.phase == .event, let person = event?.recurringPerson, let actor = names[person] {
            cast.append(.init(actor: actor, age: age, behavior: .idle, expression: .attentive))
        } else if let trace {
            for relation in trace.changedRelationships where relation.interactions.contains(where: {
                $0.eventID == trace.eventID && $0.choiceID == trace.choiceID && $0.age == trace.age
            }) {
                if let actor = people[relation.personID] {
                    cast.append(.init(actor: actor, age: age,
                        behavior: playback.phase == .consequence ? .interacting : .idle, expression: .attentive))
                }
            }
        }
        characters = cast
        var changes: [LifeWorldChange] = session.state.story.flags.compactMap { fact in
            guard let kind = LifeWorldObjectKind(rawValue: fact.key) else { return nil }
            return .init(kind: kind, value: fact.value, title: Self.title(kind, fact.value),
                         source: .init(eventID: fact.eventID, choiceID: fact.choiceID, age: fact.age))
        }
        if let trace {
            changes.append(.init(kind: .activity, value: trace.choiceID, title: "\(trace.age)歲：\(trace.choiceTitle)",
                source: .init(eventID: trace.eventID, choiceID: trace.choiceID, age: trace.age)))
        }
        visibleChanges = changes.sorted { $0.id < $1.id }
    }

    private static func title(_ kind: LifeWorldObjectKind, _ value: String) -> String {
        switch (kind, value) {
        case (.activity, _): "上一次的選擇紀錄"
        case (.friendship, "connected"): "留下聯絡約定"
        case (.friendship, _): "保留自己的步調"
        case (.learning, "online"): "線上創作經驗"
        case (.learning, "paper"): "紙本創作經驗"
        case (.learning, _): "尚未製作，可再找起點"
        case (.care, "shared"): "共同照顧安排"
        case (.care, "seeking"): "正在詢問照顧協助"
        case (.care, _): "暫緩照顧安排"
        case (.repair, "practiced"): "修理練習紀錄"
        case (.repair, _): "正在詢問修理方法"
        case (.kitchen, "shared"): "共煮分工紀錄"
        case (.kitchen, _): "正在詢問共煮安排"
        case (.garden, "tending"): "照顧花草紀錄"
        case (.garden, _): "正在詢問花圃安排"
        case (.nature, "observing"): "自然觀察紀錄"
        case (.nature, _): "正在詢問觀察方法"
        }
    }
}
