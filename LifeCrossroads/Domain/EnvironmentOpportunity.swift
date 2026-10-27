import Foundation

/// Identical costs are consumed by decision feasibility and the fictional route offer.
struct CarePreparation {
    let observation: IndicatorObservation
    let materials: Int
    static func evaluate(_ context: EnvironmentContext) -> Self? {
        guard let observation = context.observation("SH.XPD.OOPC.CH.ZS"), let value = observation.value else { return nil }
        return .init(observation: observation, materials: value < 20 ? 1 : (value < 40 ? 2 : 3))
    }
}
struct PowerPreparation {
    let observation: IndicatorObservation
    let extra: Int
    static func evaluate(_ context: EnvironmentContext) -> Self? {
        guard let observation = context.observation("EG.ELC.ACCS.ZS"), let value = observation.value else { return nil }
        return .init(observation: observation, extra: value >= 95 ? 0 : 1)
    }
}
public struct EnvironmentOpportunity: Codable, Equatable, Sendable {
    public static let version = "environment-opportunities-1"
    public let ruleVersion: String
    public let axis: String
    public let route: String
    public let observations: [IndicatorObservation]
    public let preparation: Cost?
    public let householdInputs: [String: Int]
    public let assumptionIDs: [String]
    public let explanation: String
}
enum EnvironmentOpportunityRules {
    static func project(_ base: StoryProjection, state: LifeState, catalog: ModelCatalog) throws -> StoryProjection {
        let ids = ["adult-care-map", "middle-care-followup", "young-power-table", "adult-tools-coop"]
        guard ids.contains(base.event.id) else { return base }
        var event = base.event
        let care = event.id == "adult-care-map" || event.id == "middle-care-followup"
        let key = care ? "careAccess" : "tools"
        let source = state.story.fact(key)
        var observations: [IndicatorObservation] = [], preparation: Cost?
        var inputs: [String: Int] = [:], route = "unknown", explanation = ""
        func remove(_ ids: [String]) { event.choices.removeAll { ids.contains($0.id) } }
        let context = try EnvironmentRules.context(catalog: catalog, countryCode: state.countryCode, householdID: state.householdID)
        switch event.id {
        case "adult-care-map":
            if let care = CarePreparation.evaluate(context), let choice = event.choices.first(where: { $0.id == "reserveVisit" }) {
                inputs = ["materialsAvailable": state.remainingMaterials]
                observations = [care.observation]; preparation = .init(materials: care.materials)
                let enough = care.materials + choice.materialCost <= state.remainingMaterials
                route = enough ? "reserve" : "prepareTogether"
                remove(enough ? ["sharedPlan"] : ["reserveVisit"])
                event.title = enough ? "先留出看診的時間與預備支出" : "預備支出還差一段，先一起想辦法"
                explanation = "同一個看診安排需要行動材料\(choice.materialCost)格，加環境預備\(care.materials)格；家庭本回合可用\(state.remainingMaterials)格。"
                    + (enough ? "因此可以先預留安排，仍須確認時間與預約；不是已看診或已康復。" : "因此先開放共同準備清單，並未假定別人已替你付費；詢問協助與休息仍可選。")
            } else {
                remove(["reserveVisit", "sharedPlan"])
                explanation = "缺少可比直接自付資料；不能推定安排可負擔或困難。可以先詢問費用與協助。"
            }
        case "young-power-table":
            if let power = PowerPreparation.evaluate(context) {
                observations = [power.observation]; preparation = .init(time: power.extra, materials: power.extra)
                if power.extra > 0 { inputs = ["preparationSupport": context.household.mentorSupport] }
                if power.extra == 0 {
                    route = "powered"; remove(["portableKit"])
                    explanation = "這個離線工具情境依電力背景計入0格額外準備，提供現場電動工具練習；手動入門仍保留。沒有讀取網路指標。"
                } else if context.household.mentorSupport > 0 {
                    route = "portable"; remove(["poweredBench"])
                    explanation = "電動工具在模型中多需1格時間與材料；家庭情境有備料支持，因此這次提供手動攜帶箱的替代安排。這不是某國人的能力差異。"
                } else {
                    route = "manual"; remove(["poweredBench", "portableKit"])
                    explanation = "模型需要額外工具準備，家庭此次也無備料支持；保留借一件手動工具、求助與休息，不假定已有攜帶箱。"
                }
            } else {
                remove(["poweredBench", "portableKit"])
                explanation = "缺少可比電力輸入；不推定特別工具管道，手動入門與求助仍保留。"
            }
        case "middle-care-followup":
            switch source?.value {
            case "reserved": route = "reserved"; remove(["reviewShared"])
            case "shared": route = "shared"; remove(["reviewVisit"])
            default: route = "restart"; remove(["reviewShared", "reviewVisit"])
            }
            explanation = source.map { "接續\($0.age)歲實際留下的安排；" } ?? "沒有先前的預備安排；"
            explanation += route == "restart" ? "先重新詢問支持，不憑空出現預約或共同清單。" : "這次核對那份安排，沒有推論治療結果或身體已康復。"
        default:
            switch source?.value {
            case "powered": route = "bench"; remove(["mobileRepair"])
            case "portable": route = "mobile"; remove(["benchWork"])
            default: route = "restart"; remove(["benchWork", "mobileRepair"])
            }
            explanation = source.map { "接續\($0.age)歲真正做過的工具練習；" } ?? "目前沒有那兩種工具練習記錄；"
            explanation += route == "restart" ? "先保留手動練習、求助與休息，沒有憑空的接案邀請。" : "因此出現相應的桌邊或分站修理工作，接下仍需付出時間，不是保證長期就業。"
        }
        event.storyVariantID = event.id + "-environment-" + route
        let situation: String
        switch route {
        case "reserve": situation = "這次的預備支出可以先留出來，但工作與預約的時間還要確認。"
        case "prepareTogether": situation = "這次預留的支出比手上的材料多。你可以先列出需要，找人一起想辦法。"
        case "powered": situation = "這個情境提供現場電動工具的練習，也能從手動工具開始。"
        case "portable": situation = "準備電動工具比較費力，家人能一起備好手動攜帶箱；你可以換一種方式練習。"
        case "manual": situation = "家裡這次無法幫忙備工具箱；還能先借一件手動工具，或詢問協助。"
        case "unknown": situation = "這段環境資料還不完整，先問清楚需要的安排，不替你假定便利或困難。"
        case "reserved": situation = "你先前預留過看診的安排，今天想再對一次時間。"
        case "shared": situation = "你先前列過共同預備清單，今天可以再確認誰方便幫哪一小段。"
        case "bench": situation = "你練過的電動工具安全檢查，帶來一份桌邊修理邀請。"
        case "mobile": situation = "你練過的手動攜帶箱，帶來一段分站修理邀請。"
        default: situation = "目前沒有可接續的舊安排；從今天重新詢問或練習也可以。"
        }
        event.storyQuestion = situation + " " + event.storyQuestion
        let receipt = EnvironmentOpportunity(ruleVersion: EnvironmentOpportunity.version, axis: care ? "carePreparation" : "offlineTools",
            route: route, observations: observations, preparation: preparation, householdInputs: inputs,
            assumptionIDs: ["environment-opportunities", "household-scenarios"] + (care && !observations.isEmpty ? ["care-financing"] : [])
                + (route == "unknown" ? ["partial-environment"] : []),
            explanation: explanation + " 這是遊戲機會規則，不是現實個人風險或國家排名。")
        let isFollowup = ["middle-care-followup", "adult-tools-coop"].contains(event.id)
        return .init(event: event, evaluation: .init(ruleID: "story.environment.\(key)", sourceEventID: isFollowup ? source?.eventID ?? "" : "",
            sourceChoiceID: isFollowup ? source?.choiceID : nil, sourceAge: isFollowup ? source?.age : nil, flagKey: key,
            resourceChecks: [], variantID: event.storyVariantID!, offeredChoiceIDs: event.choices.map(\.id),
            explanation: receipt.explanation, assumptionID: "environment-opportunities", environmentOpportunity: receipt))
    }
}
