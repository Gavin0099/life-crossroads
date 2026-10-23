import Foundation

/// Fictional story conditions, kept separate from the numerical cost/effect explanation.
public struct StoryResourceCheck: Codable, Equatable, Sendable {
    public let resource: String
    public let value: Int
    public let minimum: Int
    public let met: Bool
}

public struct StoryBranchEvaluation: Codable, Equatable, Sendable {
    public let ruleID: String
    public let sourceEventID: String
    public let sourceChoiceID: String?
    public let resourceChecks: [StoryResourceCheck]
    public let variantID: String
    public let offeredChoiceIDs: [String]
    public let explanation: String
    public let assumptionID: String
}

public struct StoryProjection: Equatable, Sendable {
    public let event: DecisionSkeleton
    public let evaluation: StoryBranchEvaluation?
}

/// Pure projections of actual decision history and current resources. Country names never select a route.
public enum StoryBranchEngine {
    /// These choices are removed by the existing story prerequisites. A catalog must not count
    /// them as its guaranteed recovery route, even if a caller changes the choice kind.
    static func isConditionallyHidden(eventID: String, choiceID: String) -> Bool {
        (eventID == "teen-direction" && choiceID == "leadWorkshop")
            || (eventID == "middle-support" && choiceID == "shareShift")
    }

    public static func project(event original: DecisionSkeleton, state: LifeState) -> StoryProjection {
        var event = original
        var sourceEventID: String
        var sourceChoice: String?
        var checks: [StoryResourceCheck] = []
        var explanation: String
        var ruleID: String
        func previous(_ id: String) -> String? { state.decisions.first { $0.eventID == id }?.choiceID }
        func rename(_ id: String, _ title: String) {
            if let index = event.choices.firstIndex(where: { $0.id == id }) { event.choices[index].title = title }
        }
        switch original.id {
        case "teen-direction":
            sourceEventID = "teen-project"; sourceChoice = previous(sourceEventID)
            ruleID = "story.learning-route"
            let hasProject = sourceChoice == "invest" || sourceChoice == "offline"
            let experienced = state.resources.skills >= 28
            checks = [.init(resource: "skills", value: state.resources.skills, minimum: 28, met: experienced)]
            if sourceChoice == "offline" {
                event.storyVariantID = "teen-direction-paper"
                event.title = "樹老師帶來紙本工作坊的邀請"
                event.recurringPerson = "樹老師"
                event.storyQuestion = "手作經驗能怎麼分享，也能繼續學什麼？"
                explanation = "13歲選了紙本創作，留下了與樹老師練習的經驗，所以這次從面對面的工作坊接續故事。"
                rename("offline", "帶著紙本作品，向樹老師學新做法")
            } else if sourceChoice == "invest" {
                event.storyVariantID = "teen-direction-online"
                event.title = "樹老師邀你重開線上作品"
                event.recurringPerson = "樹老師"
                event.storyQuestion = "要繼續連網修改作品，還是換一種練習方式？"
                explanation = "13歲選了線上創作，留下了修改作品的經驗，所以樹老師這次邀你繼續交流。"
            } else {
                event.storyVariantID = "teen-direction-first-steps"
                event.title = "和小澄找到第一個學習起點"
                event.recurringPerson = "小澄"
                event.storyQuestion = "沒有舊作品，也能從哪一件小事開始？"
                explanation = "13歲沒有選擇製作作品，這次沒有舊作品的邀請；小澄陪你找一個新的學習起點。"
                rename("offline", "和小澄借入門圖解，試做第一個模型")
            }
            if !hasProject || !experienced { event.choices.removeAll { isConditionallyHidden(eventID: original.id, choiceID: $0.id) } }
            explanation += "帶領小工作坊需有13歲的作品經驗及技能至少28；本次技能為\(state.resources.skills)，因此" +
                (hasProject && experienced ? "故事開放帶領選項，仍需安排本回合成本。" : "先保留參與、求助與休息的路線。")
        case "middle-support":
            sourceEventID = "adult-care"; sourceChoice = previous(sourceEventID)
            ruleID = "story.care-network"
            let sharedPlan = sourceChoice == "invest"
            let enoughEnergy = state.resources.health >= 55
            checks = [.init(resource: "health", value: state.resources.health, minimum: 55, met: enoughEnergy)]
            event.recurringPerson = "小澄"
            if sharedPlan {
                event.storyVariantID = "middle-support-reciprocal"
                event.title = "和小澄再打開照顧輪班表"
                event.storyQuestion = "以前一起安排的支持，這次能如何調整？"
                rename("invest", "和小澄核對輪班表，重新分配工作")
                rename("ask", "請互助夥伴先接手，說出自己的限制")
                explanation = "39歲選了共同安排照顧，建立了輪班約定；52歲小澄因此帶著原來的安排來商量。"
            } else {
                event.storyVariantID = "middle-support-first-request"
                event.title = "和小澄第一次尋找照顧支持"
                event.storyQuestion = "沒有現成輪班表，能先向誰說出需要？"
                rename("invest", "和小澄整理照顧需求，開始找夥伴")
                rename("ask", "請小澄陪你詢問社區的協助方式")
                explanation = "39歲沒有建立共同輪班約定，這次從整理需要、認識支持夥伴開始；不會假定已有人能接班。"
            }
            if !sharedPlan || !enoughEnergy { event.choices.removeAll { isConditionallyHidden(eventID: original.id, choiceID: $0.id) } }
            explanation += "接下一小段既有輪班需原來的約定及健康至少55；本次健康為\(state.resources.health)，因此" +
                (sharedPlan && enoughEnergy ? "故事開放自願接一小段的選項，仍需安排本回合成本。" : "保留求助與免費休息，不要求勉強承擔。")
        case "later-reconnect":
            sourceEventID = "child-friend"; sourceChoice = previous(sourceEventID)
            ruleID = "story.childhood-connection"
            let keptConnection = sourceChoice == "invest" || sourceChoice == "ask"
            if keptConnection {
                event.storyVariantID = "later-reconnect-old-friend"
                event.title = "阿禾找回那架雙人風車"
                event.recurringPerson = "阿禾"
                event.storyQuestion = "10歲留下的約定，今天想怎麼再續一頁？"
                rename("invest", "和阿禾修補風車，再做一張合照")
                rename("ask", "請阿禾一起找適合現在體力的活動")
                rename("rest", "和阿禾約改天，今天先安靜休息")
                explanation = "10歲選擇和阿禾一起完成作品或調整見面方式，留下了聯絡的約定；這是阿禾在72歲重新出現的故事條件。"
            } else {
                event.storyVariantID = "later-reconnect-new-neighbor"
                event.title = "和小澄擺一張社區風車桌"
                event.recurringPerson = "小澄"
                event.storyQuestion = "沒有那份童年約定，也能從今天開始認識誰？"
                rename("invest", "和小澄在社區桌旁做一架新風車")
                rename("ask", "請小澄介紹附近能慢慢聊天的地方")
                rename("rest", "向小澄道別，留一天給自己的步調")
                explanation = "10歲沒有留下和阿禾聯絡的約定，因此這次不出現童年重逢；改和現在的社區夥伴小澄一起開張風車桌，認識新的鄰居。這條路也有新的連結。"
            }
        default:
            return .init(event: event, evaluation: nil)
        }
        guard let variantID = event.storyVariantID else { return .init(event: event, evaluation: nil) }
        return .init(event: event, evaluation: .init(ruleID: ruleID, sourceEventID: sourceEventID,
            sourceChoiceID: sourceChoice, resourceChecks: checks, variantID: variantID,
            offeredChoiceIDs: event.choices.map(\.id), explanation: explanation, assumptionID: "story-branches"))
    }
}
