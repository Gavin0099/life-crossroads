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
    public var sourceAge: Int? = nil
    public var flagKey: String? = nil
    public let resourceChecks: [StoryResourceCheck]
    public let variantID: String
    public let offeredChoiceIDs: [String]
    public let explanation: String
    public let assumptionID: String
    public var opportunity: CreativeOpportunity? = nil
    public var focusSource: LifeFocusMemory? = nil
    public var environmentOpportunity: EnvironmentOpportunity? = nil
}

public struct StoryProjection: Equatable, Sendable {
    public let event: DecisionSkeleton
    public let evaluation: StoryBranchEvaluation?
}

/// Pure projections of actual decision history and current resources. Country names never select a route.
public enum StoryBranchEngine {
    public static func project(event original: DecisionSkeleton, state: LifeState, catalog: ModelCatalog) throws -> StoryProjection {
        var standard = original
        standard.choices.removeAll { ["remoteStudio", "mentorRelay", "portfolio", "cooperate"].contains($0.id) }
        return try EnvironmentOpportunityRules.project(LifeFocusStoryRules.project(try CreativeOpportunityRules.project(
            legacyProject(event: standard, state: state), state: state, catalog: catalog), state: state), state: state, catalog: catalog)
    }

    private static func legacyProject(event original: DecisionSkeleton, state: LifeState) -> StoryProjection {
        var event = original
        event.age = state.age
        var sourceEventID: String
        var sourceChoice: String?
        var checks: [StoryResourceCheck] = []
        var explanation: String
        var ruleID: String
        var sourceFact: StoryFact?
        func fact(_ key: String) -> StoryFact? { state.story.fact(key) }
        func rename(_ id: String, _ title: String) {
            if let index = event.choices.firstIndex(where: { $0.id == id }) { event.choices[index].title = title }
        }
        switch original.id {
        case "teen-direction":
            sourceFact = fact("learning")
            sourceEventID = sourceFact?.eventID ?? "teen-project"; sourceChoice = sourceFact?.choiceID
            ruleID = "story.learning-route"
            let hasProject = ["online", "paper"].contains(sourceFact?.value ?? "")
            let experienced = state.resources.skills >= 28
            checks = [.init(resource: "skills", value: state.resources.skills, minimum: 28, met: experienced)]
            if sourceFact?.value == "paper" {
                event.storyVariantID = "teen-direction-paper"
                event.title = "樹老師帶來紙本工作坊的邀請"
                event.recurringPerson = "樹老師"
                event.storyQuestion = "手作經驗能怎麼分享，也能繼續學什麼？"
                explanation = "先前選了紙本創作，留下了與樹老師練習的經驗，所以這次從面對面的工作坊接續故事。"
                rename("offline", "帶著紙本作品，向樹老師學新做法")
            } else if sourceFact?.value == "online" {
                event.storyVariantID = "teen-direction-online"
                event.title = "樹老師邀你重開線上作品"
                event.recurringPerson = "樹老師"
                event.storyQuestion = "要繼續連網修改作品，還是換一種練習方式？"
                explanation = "先前選了線上創作，留下了修改作品的經驗，所以樹老師這次邀你繼續交流。"
            } else {
                event.storyVariantID = "teen-direction-first-steps"
                event.title = "和小澄找到第一個學習起點"
                event.recurringPerson = "小澄"
                event.storyQuestion = "沒有舊作品，也能從哪一件小事開始？"
                explanation = "先前沒有選擇製作作品，這次沒有舊作品的邀請；小澄陪你找一個新的學習起點。"
                rename("offline", "和小澄借入門圖解，試做第一個模型")
            }
            if !hasProject || !experienced { event.choices.removeAll { $0.id == "leadWorkshop" } }
            explanation += "帶領小工作坊需有先前的作品經驗及技能至少28；本次技能為\(state.resources.skills)，因此" +
                (hasProject && experienced ? "故事開放帶領選項，仍需安排本回合成本。" : "先保留參與、求助與休息的路線。")
        case "middle-support":
            sourceFact = fact("care")
            sourceEventID = sourceFact?.eventID ?? "adult-care"; sourceChoice = sourceFact?.choiceID
            ruleID = "story.care-network"
            let sharedPlan = sourceFact?.value == "shared"
            let enoughEnergy = state.resources.health >= 55
            checks = [.init(resource: "health", value: state.resources.health, minimum: 55, met: enoughEnergy)]
            event.recurringPerson = "小澄"
            if sharedPlan {
                event.storyVariantID = "middle-support-reciprocal"
                event.title = "和小澄再打開照顧輪班表"
                event.storyQuestion = "以前一起安排的支持，這次能如何調整？"
                rename("invest", "和小澄核對輪班表，重新分配工作")
                rename("ask", "請互助夥伴先接手，說出自己的限制")
                explanation = "先前選了共同安排照顧，建立了輪班約定；這次小澄因此帶著原來的安排來商量。"
            } else {
                event.storyVariantID = "middle-support-first-request"
                event.title = "和小澄第一次尋找照顧支持"
                event.storyQuestion = "沒有現成輪班表，能先向誰說出需要？"
                rename("invest", "和小澄整理照顧需求，開始找夥伴")
                rename("ask", "請小澄陪你詢問社區的協助方式")
                explanation = "先前沒有建立共同輪班約定，這次從整理需要、認識支持夥伴開始；不會假定已有人能接班。"
            }
            if !sharedPlan || !enoughEnergy { event.choices.removeAll { $0.id == "shareShift" } }
            explanation += "接下一小段既有輪班需原來的約定及健康至少55；本次健康為\(state.resources.health)，因此" +
                (sharedPlan && enoughEnergy ? "故事開放自願接一小段的選項，仍需安排本回合成本。" : "保留求助與免費休息，不要求勉強承擔。")
        case "later-reconnect":
            sourceFact = fact("friendship")
            sourceEventID = sourceFact?.eventID ?? "child-friend"; sourceChoice = sourceFact?.choiceID
            ruleID = "story.childhood-connection"
            let keptConnection = sourceFact?.value == "connected"
            if keptConnection {
                event.storyVariantID = "later-reconnect-old-friend"
                event.title = "和阿禾再做一架風車"
                event.recurringPerson = "阿禾"
                event.storyQuestion = "先前留下的約定，今天想怎麼再續一頁？"
                rename("invest", "和阿禾一起做風車，再做一張合照")
                rename("ask", "請阿禾一起找適合現在體力的活動")
                rename("rest", "和阿禾約改天，今天先安靜休息")
                explanation = "先前的選擇留下了與阿禾聯絡的記錄；這是這次阿禾重新出現的故事條件。"
            } else {
                event.storyVariantID = "later-reconnect-new-neighbor"
                event.title = "和小澄擺一張社區風車桌"
                event.recurringPerson = "小澄"
                event.storyQuestion = "沒有那份童年約定，也能從今天開始認識誰？"
                rename("invest", "和小澄在社區桌旁做一架新風車")
                rename("ask", "請小澄介紹附近能慢慢聊天的地方")
                rename("rest", "向小澄道別，留一天給自己的步調")
                explanation = "先前沒有留下和阿禾聯絡的約定，因此這次不出現童年重逢；改和現在的社區夥伴小澄一起開張風車桌，認識新的鄰居。這條路也有新的連結。"
            }
        default:
            guard let route = original.continuation else { return .init(event: event, evaluation: nil) }
            sourceFact = fact(route.flag)
            sourceEventID = sourceFact?.eventID ?? ""
            sourceChoice = sourceFact?.choiceID
            ruleID = "story." + route.flag
            let connected = route.activeValues.contains(sourceFact?.value ?? "")
            let skilled = state.resources.skills >= route.minimumSkills
            checks = [.init(resource: "skills", value: state.resources.skills, minimum: route.minimumSkills, met: skilled)]
            event.storyVariantID = event.id + (connected ? "-continuation" : "-recovery")
            event.title = connected ? route.activeTitle : route.recoveryTitle
            if !connected || !skilled { event.choices.removeAll { route.unlockedChoices.contains($0.id) } }
            if let origin = sourceFact {
                explanation = "你在\(origin.age)歲留下的故事記錄，影響這次能否接續已有安排。"
            } else {
                explanation = "目前沒有這條故事的先前參與記錄；這次可以從求助或小規模嘗試重新開始。"
            }
            if route.minimumSkills == 0 {
                explanation += connected ? "先前的行動讓你可以接續這份安排；也可以重新詢問或休息，沒有必須回報誰的義務。" : "尚無這份安排，保留重新詢問與休息；不能把需要協助當成已獲支持。"
            } else {
                explanation += connected && skilled ? "已有經驗及技能讓你可以接下帶領的工作，也可以選擇休息。" : "帶領選項需要先前參與和技能至少\(route.minimumSkills)；本次保留入門、求助與休息。"
            }
        }
        if event.choices.contains(where: { $0.requiresCareFinancing == true }) {
            event.storyQuestion += " 這次也要安排看診交通與預備支出；可以先詢問費用和可用協助。"
            rename("ask", "請小澄陪你詢問醫療費用與可用協助，先不接新輪班")
        }
        guard let variantID = event.storyVariantID else { return .init(event: event, evaluation: nil) }
        return .init(event: event, evaluation: .init(ruleID: ruleID, sourceEventID: sourceEventID,
            sourceChoiceID: sourceChoice, sourceAge: sourceFact?.age, flagKey: sourceFact?.key, resourceChecks: checks, variantID: variantID,
            offeredChoiceIDs: event.choices.map(\.id), explanation: explanation, assumptionID: "story-branches"))
    }
}
