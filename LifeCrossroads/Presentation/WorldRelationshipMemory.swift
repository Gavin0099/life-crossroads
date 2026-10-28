import LifeDomain

/// Two actual saved choices, not a generated explanation or a new persistent story flag.
public struct WorldRelationshipMemory: Equatable, Sendable {
    public struct Receipt: Equatable, Sendable {
        public let age: Int
        public let eventID: String
        public let choiceID: String
        public let choiceTitle: String
    }
    public let past: Receipt
    public let present: Receipt
    public let keptFriendship: Bool
    public let presentPersonID: String
    public var description: String {
        "回看\(past.age)歲：\(past.choiceTitle)。現在\(present.age)歲：\(present.choiceTitle)。" +
        (keptFriendship ? "先前的聯絡記錄是這次阿禾重逢的故事條件。" : "先前沒有留下那份童年約定；今天與小澄建立新的社區連結。")
    }
    public static func project(session: LifeSession) -> Self? {
        guard session.phase == .reflecting, let now = session.traces.last, now.applied,
              session.state.age == now.age, now.age == 72, now.eventID == "later-reconnect",
              now.choiceID == "invest", let branch = now.storyBranch,
              branch.ruleID == "story.childhood-connection", branch.flagKey == "friendship",
              branch.variantID == now.storyVariantID, branch.sourceEventID == "child-friend",
              branch.sourceAge == 10, let choice = branch.sourceChoiceID,
              let past = session.traces.dropLast().last(where: {
                  $0.applied && $0.age == 10 && $0.eventID == branch.sourceEventID && $0.choiceID == choice
              }), WorldMomentProjector.personID(past.recurringPerson) == "ahe",
              let fact = past.recordedStoryFacts.first(where: {
                  $0.key == "friendship" && $0.age == past.age && $0.eventID == past.eventID && $0.choiceID == past.choiceID
              }) else { return nil }
        let connected = fact.value == "connected"
        guard (connected && ["invest", "ask"].contains(past.choiceID) && now.storyVariantID == "later-reconnect-old-friend" && WorldMomentProjector.personID(now.recurringPerson) == "ahe") ||
              (fact.value == "paused" && past.choiceID == "rest" && now.storyVariantID == "later-reconnect-new-neighbor" && WorldMomentProjector.personID(now.recurringPerson) == "cheng") else { return nil }
        func receipt(_ t: ConsequenceTrace) -> Receipt {
            .init(age: t.age, eventID: t.eventID, choiceID: t.choiceID, choiceTitle: t.choiceTitle)
        }
        return .init(past: receipt(past), present: receipt(now), keptFriendship: connected,
                     presentPersonID: connected ? "ahe" : "cheng")
    }
}

/// Speaking/listening is an illustration of an already-recorded request, never an agreement.
/// One supplied clock; no timer, random draw, state mutation or additional wait.
public enum WorldRequestBeat: String, Sendable {
    case expressing, listening
    public static func project(frame: LifeWorldFrame, motion: PresentationMotionFrame) -> Self? {
        guard WorldCastScene.project(frame)?.kind == .requesting else { return nil }
        if motion.reduceMotion { return .expressing }
        return motion.phaseElapsedMs.isFinite && motion.phaseElapsedMs >= 1_100 ? .listening : .expressing
    }
}
