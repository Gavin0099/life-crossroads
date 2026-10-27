import LifeDomain

/// Read-only story ordering. Every statement refers to an executed trace or an actually triggered callback.
public enum LifeStoryComparison {
    public static func highlights(_ rows: [BranchComparisonRow]) -> [BranchComparisonRow] {
        // Rank recorded continuations and changed opportunities, never resource totals or nationality.
        func importance(_ row: BranchComparisonRow) -> Int {
            let a = row.original.storyBranch, b = row.alternative.storyBranch
            let changed = row.storyChanged || !row.sameAction
            guard changed else { return 0 }
            let sourceChanged = a?.sourceEventID != b?.sourceEventID || a?.sourceChoiceID != b?.sourceChoiceID
            let opportunitiesChanged = a?.offeredChoiceIDs != b?.offeredChoiceIDs
            let remembered = [a, b].compactMap { $0?.sourceAge }.contains { $0 < row.original.age }
            return (row.storyChanged ? 4 : 1) + (sourceChanged ? 4 : 0) + (opportunitiesChanged ? 4 : 0)
                + (remembered ? 3 : 0) + (row.originalArrival.triggeredHooks != row.alternativeArrival.triggeredHooks ? 2 : 0)
        }
        return Array(rows.filter { importance($0) > 0 }.sorted {
            importance($0) == importance($1) ? $0.decisionIndex > $1.decisionIndex : importance($0) > importance($1)
        }.prefix(3)).sorted { $0.decisionIndex < $1.decisionIndex }
    }

    public static func consequences(_ trace: ConsequenceTrace, arrival: TimeJumpTrace) -> [String] {
        var lines: [String] = []
        if let branch = trace.storyBranch, let opportunity = branch.opportunity {
            let origin = branch.sourceAge.map { "這一頁接續了你\($0)歲真正做過的選擇。" } ?? "這次是重新尋找創作起點。"
            let channel: String
            switch opportunity.route {
            case "remote": channel = "出現了遠距協作的機會；是否接下來，仍由你決定。"
            case "relay", "collective": channel = "出現了和夥伴面對面共作的機會。"
            case "unknown": channel = "環境資料尚不足，不能推定特別的協作管道。"
            default: channel = "目前沒有現成協作邀請，仍可學習、求助或休息。"
            }
            lines.append(origin + channel)
        }
        if let branch = trace.storyBranch, branch.opportunity == nil {
            switch branch.variantID {
            case "teen-direction-paper": lines.append("那次和樹老師做紙本練習的經驗，接上了今天的工作坊邀請。")
            case "teen-direction-online": lines.append("那次線上創作留下了修改作品的經驗，樹老師這次邀你重新打開它。")
            case "teen-direction-first-steps": lines.append("沒有舊作品的邀請，小澄仍陪你找到一個新的學習起點。")
            default:
                if let age = branch.sourceAge {
                    lines.append("這一頁接續了你\(age)歲留下的選擇：\(trace.eventTitle)。")
                }
            }
            if branch.offeredChoiceIDs.contains("leadWorkshop") {
                lines.append("這次出現了帶領工作坊的邀請；接不接下來，還要看時間與準備。")
            }
        }
        lines += arrival.triggeredHooks.map { "\($0.originAge)歲的選擇，在\(arrival.toAge)歲有了呼應：\($0.text)" }
        for fact in trace.recordedStoryFacts {
            if fact.key == "learning" {
                switch fact.value {
                case "online": lines.append("你留下了線上創作的練習記錄。")
                case "paper": lines.append("你留下了紙本創作的練習記錄。")
                default: lines.append(fact.choiceID == "ask" ? "你先說出自己的需要，這次尚未留下作品經驗。" : "你把這段時間留給自己，這次尚未留下作品經驗。")
                }
            }
        }
        for step in trace.effectSteps where step.ruleID == "support.encouragement" {
            lines.append(step.explanation)
        }
        return lines
    }
}
