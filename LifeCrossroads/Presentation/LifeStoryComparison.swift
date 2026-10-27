import LifeDomain

/// Read-only story ordering. Every statement refers to an executed trace or an actually triggered callback.
public enum LifeStoryComparison {
    public static func highlights(_ rows: [BranchComparisonRow]) -> [BranchComparisonRow] {
        // Keep the shared wish and its real continuation together, then show other actual differences.
        let wish = rows.filter { $0.original.eventID == "teen-project" || $0.original.age == 17 }
        let changed = rows.filter { row in
            !wish.contains(where: { $0.decisionIndex == row.decisionIndex }) && (row.storyChanged || !row.sameAction)
        }
        return Array((wish + changed).prefix(4)).sorted { $0.decisionIndex < $1.decisionIndex }
    }

    public static func consequences(_ trace: ConsequenceTrace, arrival: TimeJumpTrace) -> [String] {
        var lines: [String] = []
        if let branch = trace.storyBranch {
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
