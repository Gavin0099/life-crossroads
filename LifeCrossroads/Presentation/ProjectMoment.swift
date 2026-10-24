import LifeDomain

/// Read-only presentation of a committed teen-project trace. Never resolves a choice or draws randomness.
/// Intent illustrations describe the chosen activity, not completion, winning or a future invitation.
/// The caller supplies the published reflecting trace: `applied` alone is not proof of persistence,
/// since a hypothetical resolver preview can also be applied. The App's save-before-publish guards that boundary.
public struct ProjectMoment: Equatable, Sendable {
    public enum Activity: String, Sendable { case online, paper, ask, rest }
    public let activity: Activity
    public let age: Int
    public let caption: String
    public let person: String?
    public let cost: Cost
    public let actualChange: ResourceValues
    public let memory: String?
    public let support: [String]
    public let chance: String?
    public let pendingCount: Int
    public let gaps: [String]
    public let influences: [String]
    public let receipt: String

    public init?(trace: ConsequenceTrace) {
        guard trace.eventID == "teen-project", trace.applied else { return nil }
        switch trace.choiceID {
        case "invest":
            activity = .online
            caption = "沐沐把線上圖解放上創作桌，留下一次練習。"
        case "offline":
            activity = .paper
            caption = "沐沐打開借來的紙本圖解，留下一次練習。"
        case "ask":
            activity = .ask
            caption = "沐沐先說出需要，從詢問創作起點開始。"
        case "rest":
            activity = .rest
            caption = "沐沐先收起創作材料，把這段時間留給自己。"
        default: return nil
        }
        age = trace.age
        // A recurring-person label alone is not evidence that the person helped this choice.
        let teacherInteraction = trace.changedRelationships.contains {
            $0.personID == "teacher" && $0.interactions.contains {
                $0.eventID == trace.eventID && $0.choiceID == trace.choiceID && $0.age == trace.age
            }
        }
        person = teacherInteraction && trace.recurringPerson == "樹老師" ? trace.recurringPerson : nil
        cost = trace.finalCost
        actualChange = trace.resourcesAfter - trace.resourcesBefore
        let fact = trace.recordedStoryFacts.first {
            $0.key == "learning" && $0.eventID == trace.eventID && $0.choiceID == trace.choiceID && $0.age == trace.age
        }
        switch fact?.value {
        case "online": memory = "故事記錄：留下線上創作經驗。"
        case "paper": memory = "故事記錄：留下紙本創作經驗。"
        case "none": memory = "故事記錄：這次未建立作品經驗，未來仍可重新尋找起點。"
        default: memory = nil
        }
        support = trace.effectSteps.filter { $0.influence == .otherPeople && $0.delta != .zero }.map(\.explanation)
        chance = trace.randomTrial?.occurred == true
            ? trace.effectSteps.first { $0.influence == .randomness && $0.delta != .zero }?.explanation : nil
        pendingCount = trace.scheduledHooks.count
        gaps = trace.environmentGaps
        influences = trace.contributingInfluences.map(\.title)
        receipt = "\(trace.eventID)/\(trace.age)/\(trace.choiceID)/\(trace.seed)"
    }
}
