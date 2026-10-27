import Foundation

/// The same versioned contextual preparation rule is used by costs and story opportunities.
struct DigitalPreparation {
    let observations: [IndicatorObservation]
    let time: Int
    let materials: Int
    static func evaluate(_ context: EnvironmentContext) -> Self? {
        guard let internet = context.observation("IT.NET.USER.ZS"), let power = context.observation("EG.ELC.ACCS.ZS"),
              let i = internet.value, let p = power.value else { return nil }
        return .init(observations: [internet, power], time: i >= 90 ? 0 : (i >= 60 ? 1 : 2), materials: p >= 95 ? 0 : 1)
    }
}

public struct CreativeOpportunity: Codable, Equatable, Sendable {
    public static let version = "creative-opportunities-1"
    public let ruleVersion: String
    public let route: String
    public let observations: [IndicatorObservation]
    public let preparation: Cost?
    /// Household preparation support used for the relay offer, not the existence of a teacher relationship.
    public let mentorSupport: Int?
    public let assumptionIDs: [String]
    public let explanation: String
}

public enum CreativeOpportunityRules {
    /// Conditional invitations are explicit, not disguised as random selections.
    static func appointment(_ state: LifeState) -> (event: String, origin: DecisionRecord)? {
        if state.age == 17, let origin = state.decisions.first(where: { $0.age == 13 && $0.eventID == "teen-project" }),
           ["invest", "offline", "ask"].contains(origin.choiceID) { return ("teen-direction", origin) }
        if state.age == 25, let origin = state.decisions.first(where: { $0.age == 17 && $0.eventID == "teen-direction" }),
           origin.choiceID != "rest" { return ("adult-learning", origin) }
        return nil
    }

    static func project(_ base: StoryProjection, state: LifeState, catalog: ModelCatalog) throws -> StoryProjection {
        var event = base.event
        guard ["teen-direction", "adult-learning"].contains(event.id) else { return base }
        event.choices.removeAll { ["remoteStudio", "mentorRelay", "portfolio", "cooperate"].contains($0.id) }
        let context = try EnvironmentRules.context(catalog: catalog, countryCode: state.countryCode, householdID: state.householdID)
        var route = "recovery", explanation = "", observations: [IndicatorObservation] = []
        var preparation: Cost?
        var source = state.decisions.last { $0.eventID == "teen-project" }
        var add: String?
        if event.id == "teen-direction" {
            switch source?.choiceID {
            case "invest":
                if let digital = DigitalPreparation.evaluate(context) {
                    observations = digital.observations; preparation = .init(time: digital.time, materials: digital.materials)
                    if digital.time >= 2 || digital.materials >= 1 {
                        route = context.household.mentorSupport > 0 ? "relay" : "seeking"
                        if route == "relay" {
                            add = "mentorRelay"
                            event.title = "把線上的點子帶到共作桌"
                            event.storyQuestion = "樹老師提議分段準備圖解，再一起製作；不用每次都守著連線。你想接續這個安排，還是換個方法？"
                            explanation = "先前選了線上創作；本次模型的數位準備負擔較多，且這個家庭情境有指導支持，因此出現分段備料、面對面共作的邀請。"
                        } else {
                            event.title = "家裡這次無法幫忙備料"
                            event.storyQuestion = "家裡這次無法幫忙分段準備圖解。"
                            explanation = "先前選了線上創作；本次模型準備負擔較多，但家庭備料支持為0，因此沒有分段備料邀請。"
                            // Existing teacher contact is a recorded interaction, independent of household support.
                            let teacherContact = state.story.relationships.first { $0.personID == "teacher" }?.interactions.last {
                                $0.eventID == source?.eventID && $0.choiceID == source?.choiceID && $0.age == source?.age
                            }
                            if let teacherContact {
                                event.storyQuestion += "你和樹老師先前的交流仍在；"
                                explanation += "家庭備料限制不會抹去\(teacherContact.age)歲與樹老師已記錄的交流。"
                            }
                            event.storyQuestion += event.choices.contains { $0.id == "leadWorkshop" }
                                ? "可以一起帶領紙本工作坊，也能先練習、求助或休息。"
                                : "可以先做紙本練習、詢問協助，或留時間休息。"
                            explanation += "一般紙本工作坊仍依既有作品經驗及技能門檻判斷；開放選項不代表已經完成工作坊。"
                        }
                    } else {
                        route = "remote"; add = "remoteStudio"
                        event.title = "第一次和遠方夥伴共同修改作品"
                        event.storyQuestion = "你留下的線上作品，成了共同草稿的起點。遠距練習需要安排設備和時間；也可以把點子帶到紙上。"
                        explanation = "先前選了線上創作；本次模型數位準備負擔較少，開放遠距共同草稿的練習，並不保證完成或得到工作。"
                    }
                } else {
                    route = "unknown"
                    event.title = "先問清楚作品需要哪些安排"
                    event.storyQuestion = "這個情境缺少可比的連線準備資料，還不能判斷遠距或分段共作的安排。紙本、求助與休息仍可選。"
                    explanation = "有先前的線上創作記錄，但缺可比網路／電力輸入；不把未知當便利或困難，也不據此推定特別的協作管道。"
                }
            case "offline":
                route = "paper"; explanation = base.evaluation?.explanation ?? "接續實際紙本練習。"
            default:
                explanation = base.evaluation?.explanation ?? "沒有作品經驗，仍可重新入門。"
            }
        } else {
            source = state.decisions.last { $0.eventID == "teen-direction" }
            switch source?.choiceID {
            case "remoteStudio":
                route = "remote"; add = "portfolio"
                event.title = "共同草稿成為一份試作的起點"
                event.storyQuestion = "遠距夥伴帶來一份小型有酬試作的邀請。你們曾一起修改草稿；接下它仍要付出時間，也不代表從此工作穩定。"
                explanation = "先前實際參與遠距共同草稿，這次才開放以該經驗參與有酬試作；一般進修、求助與休息仍保留。"
            case "mentorRelay", "leadWorkshop", "offline":
                route = "collective"; add = "cooperate"
                event.title = "共作夥伴想一起試辦製作桌"
                event.storyQuestion = "以前一起製作的夥伴，想把共作桌開給附近的人。你可以分擔一小段工作，也可以先商量負擔；收入和關係不是必然雙贏。"
                explanation = "先前實際參與共作、紙本共同練習或帶領工作坊，這次才開放在地製作桌；這不是某國比較擅長合作的假設。"
            default:
                event.title = "替創作留一個重新開始的位置"
                event.storyQuestion = "目前沒有那兩種協作經驗，沒有憑空出現接案邀請。你仍可以重新學習、找人商量安排，或繼續照顧自己的生活。"
                explanation = "先前沒有選擇遠距協作或共作帶領；本次保留重新學習、求助和休息，不把先前暫緩當成永久失敗。"
            }
        }
        if let add, let choice = catalog.decisions.first(where: { $0.id == event.id })?.choices.first(where: { $0.id == add }) {
            event.choices.insert(choice, at: 0)
        }
        // Paper / first-step prose remains the existing three-branch contract; new opportunities are explicit.
        let variant = event.id + "-opportunity-" + route
        if event.id == "teen-direction" && ["paper", "recovery"].contains(route) {
            event.storyVariantID = base.event.storyVariantID
        } else { event.storyVariantID = variant }
        if event.id == "teen-direction", source?.choiceID != "invest" {
            return .init(event: event, evaluation: base.evaluation)
        }
        let receipt = CreativeOpportunity(ruleVersion: CreativeOpportunity.version, route: route, observations: observations,
            preparation: preparation, mentorSupport: ["relay", "seeking"].contains(route) ? context.household.mentorSupport : nil,
            assumptionIDs: ["creative-opportunities"] + (observations.isEmpty ? [] : ["macro-friction"])
                + (["relay", "seeking"].contains(route) ? ["household-scenarios", "support-network"] : [])
                + (route == "seeking" ? ["story-branches"] : [])
                + (route == "unknown" ? ["partial-environment"] : []),
            explanation: explanation + " 這是遊戲情境規則，不能推論真實國家或個人的機會。")
        let evaluation = StoryBranchEvaluation(ruleID: "story.creative-opportunity", sourceEventID: source?.eventID ?? "",
            sourceChoiceID: source?.choiceID, sourceAge: source?.age, flagKey: "creative",
            resourceChecks: base.evaluation?.resourceChecks ?? [], variantID: event.storyVariantID ?? variant,
            offeredChoiceIDs: event.choices.map(\.id), explanation: receipt.explanation, assumptionID: "creative-opportunities", opportunity: receipt)
        return .init(event: event, evaluation: evaluation)
    }
}
