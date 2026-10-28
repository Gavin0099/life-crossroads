import LifeDomain

/// A read-only casting decision. A person in a scene is never proof of support or success.
/// The App supplies the frame only after its normal save-before-publish boundary.
public struct WorldCastScene: Equatable, Sendable {
    public enum Kind: String, Sendable {
        case invitation, conversation, requesting, explaining, sharedMaking
        case remoteExchange, planning, pacedParticipation, reunion, newConnection, natureNotes
    }
    public let kind: Kind
    public let personID: String
    public let age: Int
    public let eventID: String
    public let choiceID: String?
    public var background: String {
        switch age { case 10, 32, 72: "VL2Garden"; case 25: "VL2Workshop"; default: "VL2Studio" }
    }
    public var description: String {
        let name = WorldMomentProjector.personName(personID)
        switch kind {
        case .invitation: return "沐沐與\(name)面向彼此，正在聽這次邀請，尚未決定或開始合作。"
        case .conversation: return "沐沐與\(name)面對面交談，留下這次友誼的互動。"
        case .requesting: return "沐沐向\(name)說出需要；畫面呈現聆聽，尚未確認協助安排。"
        case .explaining: return "沐沐練習紙本作品，\(name)在旁講解。"
        case .sharedMaking: return "沐沐和\(name)面向同一張製作桌，討論並分段共作。"
        case .remoteExchange: return "沐沐坐在工作位，與螢幕裡的\(name)交流草稿。"
        case .natureNotes: return "沐沐與阿禾在戶外分段記錄沿路植物。"
        case .planning: return "沐沐與\(name)商量安排，沒有把討論畫成已獲得協助。"
        case .pacedParticipation: return "沐沐與\(name)一起參與一小段工作，按照自己的步調分工。"
        case .reunion: return "年老的沐沐與阿禾再相聚，一起做風車，延續先前留下的友誼。"
        case .newConnection: return "年老的沐沐與小澄在社區桌旁做新風車；這是現在的新連結，不是童年朋友重聚。"
        }
    }

    public static func project(_ frame: LifeWorldFrame) -> Self? {
        guard let event = frame.eventID else { return nil }
        let supported: [(Int, String)] = [(10,"child-friend"),(13,"teen-project"),(17,"teen-direction"),
            (25,"adult-learning"),(32,"adult-local-trail"),(32,"adult-boundary-calendar"),(72,"later-reconnect")]
        guard supported.contains(where: { $0.0 == frame.age && $0.1 == event }) else { return nil }
        func actor(_ id: String, role: String) -> Bool {
            frame.actors.contains { $0.personID == id && $0.role == role && $0.evidenceEventID == event }
        }
        if frame.moment == .eventPaused || frame.moment == .living {
            guard frame.committedChoiceID == nil,
                  let inviter = frame.actors.first(where: { $0.role == "inviter" && $0.evidenceEventID == event && ["ahe","teacher","cheng"].contains($0.personID) }) else { return nil }
            return .init(kind: .invitation, personID: inviter.personID, age: frame.age, eventID: event, choiceID: nil)
        }
        guard frame.moment == .committedOutcome, let choice = frame.committedChoiceID else { return nil }
        let person: String, kind: Kind
        switch (frame.age, choice) {
        case (10,"invest"), (10,"ask"): person = "ahe"; kind = .conversation
        case (13,"ask"): person = "teacher"; kind = .requesting
        case (13,"offline"): person = "teacher"; kind = .explaining
        case (17,"remoteStudio"): person = "teacher"; kind = .remoteExchange
        case (17,"mentorRelay"), (17,"leadWorkshop"): person = "teacher"; kind = .sharedMaking
        case (25,"cooperate"): person = "teacher"; kind = .sharedMaking
        case (32,"record") where event == "adult-local-trail": person = "ahe"; kind = .natureNotes
        case (32,"ask") where event == "adult-boundary-calendar": person = "cheng"; kind = .requesting
        case (32,"pacedRole") where event == "adult-boundary-calendar": person = "cheng"; kind = .pacedParticipation
        case (72,"invest"), (72,"ask"):
            // The resolver's saved story variant and participant are projected explicitly. A
            // retained friendship flag alone cannot invent a meeting in an unrelated event.
            guard let p = frame.actors.first(where: { $0.role == "participant" && $0.evidenceEventID == event && ["ahe","cheng"].contains($0.personID) }) else { return nil }
            person = p.personID
            kind = choice == "ask" ? .planning : person == "ahe" ? .reunion : .newConnection
            return .init(kind: kind, personID: person, age: frame.age, eventID: event, choiceID: choice)
        default: return nil
        }
        guard actor(person, role: "interacted") || (frame.age == 32 && choice == "ask" && actor(person, role: "recipient")) else { return nil }
        return .init(kind: kind, personID: person, age: frame.age, eventID: event, choiceID: choice)
    }
}
