import LifeDomain

/// Drawing instructions from a saved action, never a new outcome or an eligibility rule.
public struct WorldActivity: Equatable, Sendable {
    public enum Kind: String, Sendable {
        case onlinePractice, paperPractice, asking, resting
        case remoteCollaboration, sharedWorkshop, trialWork, communityWork
        case protectedRest, pacedParticipation
    }
    public let kind: Kind
    public let sourceAge: Int
    public let sourceEventID: String
    public let sourceChoiceID: String
    public let companionID: String?

    public var background: String {
        switch kind {
        case .resting, .protectedRest, .pacedParticipation: "VL2Garden"
        case .trialWork, .communityWork: "VL2Workshop"
        default: "VL2Studio"
        }
    }
    public var atlas: String {
        switch kind {
        case .onlinePractice, .paperPractice, .asking, .resting: "VL2Teen13"
        case .remoteCollaboration, .sharedWorkshop: "VL2Teen17"
        case .trialWork, .communityWork: "VL2Adult25"
        case .protectedRest, .pacedParticipation: "VL2Recovery32"
        }
    }
    public var cell: Int {
        switch kind {
        case .onlinePractice, .remoteCollaboration, .trialWork, .protectedRest: 0
        case .paperPractice, .sharedWorkshop, .communityWork, .pacedParticipation: 1
        case .asking: 2
        case .resting: 3
        }
    }
    public var rows: Int { atlas == "VL2Teen13" ? 2 : 1 }
    public var description: String {
        switch kind {
        case .onlinePractice: "沐沐坐在桌前，對照螢幕練習創作。"
        case .paperPractice: "沐沐低頭在紙上畫圖，手邊放著紙本材料。"
        case .asking: "沐沐轉身說出需要，尚未代表獲得協助。"
        case .resting: "沐沐放下工具，讓自己休息。"
        case .remoteCollaboration: "沐沐透過螢幕討論草稿，練習遠距合作。"
        case .sharedWorkshop: "沐沐在共作桌前分段處理材料。"
        case .trialWork: "沐沐在工作位整理試作草稿，尚未代表正式錄取。"
        case .communityWork: "沐沐在在地製作桌前參與共作。"
        case .protectedRest: "過去留給自己的空間仍在；沐沐還未答應這次活動。"
        case .pacedParticipation: "沐沐已試過一小段工作，依自己的步調參與。"
        }
    }

    /// A setting and a neutral observer are not a chosen action. Keep the same room while
    /// choosing, without borrowing a working pose or implying that an invitation was accepted.
    public static func neutralSetting(_ frame: LifeWorldFrame) -> (background: String, cell: Int)? {
        guard frame.moment == .eventPaused || frame.moment == .living else { return nil }
        switch (frame.age, frame.eventID) {
        case (13, "teen-project"): return ("VL2Studio", 0)
        case (17, "teen-direction"): return ("VL2Studio", 1)
        case (25, "adult-learning"): return ("VL2Workshop", 2)
        case (32, "adult-boundary-calendar"): return ("VL2Garden", 3)
        default: return nil
        }
    }

    public static func project(_ frame: LifeWorldFrame) -> Self? {
        // A completed recovery focus is distinct from accepting today's opportunity.
        if frame.age == 32, frame.eventID == "adult-boundary-calendar",
           frame.moment == .eventPaused || frame.moment == .living,
           let focus = frame.worldChanges.last(where: { $0.kind == .livedFocus && $0.isOccurred && $0.factKey == "lifeFocus" && $0.factValue == "recovery" }) {
            return .init(kind: .protectedRest, sourceAge: focus.sourceAge, sourceEventID: focus.sourceEventID,
                         sourceChoiceID: focus.sourceChoiceID, companionID: nil)
        }
        guard frame.moment == .committedOutcome, let event = frame.eventID,
              let choice = frame.committedChoiceID else { return nil }
        let kind: Kind
        switch (frame.age, event, choice) {
        case (13, "teen-project", "invest"): kind = .onlinePractice
        case (13, "teen-project", "offline"): kind = .paperPractice
        case (13, "teen-project", "ask"): kind = .asking
        case (13, "teen-project", "rest"): kind = .resting
        case (17, "teen-direction", "remoteStudio"): kind = .remoteCollaboration
        case (17, "teen-direction", "mentorRelay"), (17, "teen-direction", "leadWorkshop"): kind = .sharedWorkshop
        case (25, "adult-learning", "portfolio"): kind = .trialWork
        case (25, "adult-learning", "cooperate"): kind = .communityWork
        case (32, "adult-boundary-calendar", "pacedRole"): kind = .pacedParticipation
        default: return nil
        }
        let companion = frame.actors.first(where: { $0.role == "interacted" && $0.evidenceEventID == event && ["teacher", "cheng"].contains($0.personID) })?.personID
        return .init(kind: kind, sourceAge: frame.age, sourceEventID: event, sourceChoiceID: choice, companionID: companion)
    }
}
