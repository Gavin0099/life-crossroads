import LifeDomain

/// Display-only prose backed by household settings and executed rules. Never inferred from a country name.
public enum BirthStory {
    public static func household(_ household: HouseholdProfile) -> String {
        let equipment: String
        switch household.deviceAccess {
        case .own: equipment = "家裡有一台可由你安排使用的設備。"
        case .shared: equipment = "家裡的設備要和其他人輪流使用。"
        case .community: equipment = "使用數位設備時，需要安排去社區的時間。"
        }
        let travel = household.travelCost > 0 ? "出門參與活動，得多留一些往返時間。" : "活動就在較近的生活圈，往返負擔比較少。"
        let help = household.mentorSupport > 0 ? "有可以一起準備、商量的社區夥伴；需要時，你能試著開口。" : "身邊暫時沒有固定的準備夥伴，你仍可以尋找新的支持。"
        return equipment + travel + help
    }

    public static func creationContext(preview: ConsequenceTrace) -> String {
        guard preview.eventID == "teen-project" else { return "" }
        if !preview.environmentGaps.isEmpty {
            return "這個示範背景的數位資料尚不足以比較，這次只計入家庭安排；不是認定連線沒有困難。"
        }
        let digital = preview.costSteps.first { $0.ruleID == "context.digital" }
        if let digital, digital.adjustment.time > 0 || digital.adjustment.materials > 0 {
            let connection = digital.adjustment.time >= 2 ? "線上圖解需要較多連線準備；紙本是另一個起點。" : "線上圖解需要多留一段連線準備時間。"
            let power = digital.adjustment.materials > 0 ? "設備與供電安排也增加了材料準備。" : "這次沒有額外的供電材料負擔。"
            return connection + power + "這是環境指標搭配遊戲假設的安排，不是全國每個孩子的實況。"
        }
        return "這次的環境規則沒有增加線上準備負擔；仍要安排家裡的設備和課後時間。紙本與線上各有自己的取捨。"
    }
}
