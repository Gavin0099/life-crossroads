import Foundation

// Executes the actual prototype flow; expected text and guards come from
// docs/ui/ui-11-12.md and the owner's review, not a second outcome algorithm.
@main struct EventFirstFlowChecks {
    @MainActor static func main() {
        var checks = 0
        func expect(_ condition: @autoclosure () -> Bool, _ description: String) {
            guard condition() else { print("FAIL: \(description)"); exit(1) }
            checks += 1
        }
        func event(_ id: String) -> EventViewDTO {
            .init(id: id, characterName: "Test", age: "13 歲", year: "2027", stage: "青少年", title: id,
                  narrative: "fixture", artworkID: nil, options: [
                    .init(id: "shared", title: "shared choice", cost: "fixture", support: "fixture", uncertainty: "fixture", isAvailable: true, unavailableReason: nil)
                  ], statuses: [])
        }
        func outcome(_ key: ChoiceKey, _ title: String) -> OutcomeViewDTO {
            .init(key: key, title: title, immediate: [title], pending: [], factors: [], evidenceLabel: "test fixture")
        }

        let first = ChoiceKey(eventID: "first", optionID: "shared")
        let second = ChoiceKey(eventID: "second", optionID: "shared")
        let repeated = EventFirstFlow(events: [event("first"), event("second")],
            outcomes: [first: outcome(first, "FIRST ONLY"), second: outcome(second, "SECOND ONLY")], comparisons: [:])
        repeated.select("shared")
        expect(repeated.outcome?.title == "FIRST ONLY", "first event selects first outcome")
        repeated.advance(); repeated.select("shared")
        expect(repeated.outcome?.title == "SECOND ONLY", "same option ID in second event selects second outcome")
        expect(repeated.map.nodes.map(\.id) == [first, second], "map retains distinct event/option identities")
        print("PASS: repeated option IDs across events")

        let missing = EventFirstFlow(events: [event("first")], outcomes: [second: outcome(second, "WRONG EVENT")])
        missing.select("shared")
        expect(missing.screen == .event && missing.history.isEmpty && missing.outcome == nil, "other event outcome cannot satisfy lookup")
        expect(missing.message != nil, "missing outcome is observable")
        let mismatch = EventFirstFlow(events: [event("first")], outcomes: [first: outcome(second, "WRONG PAYLOAD")])
        mismatch.select("shared"); mismatch.advance()
        expect(mismatch.screen == .event && mismatch.index == 0 && mismatch.history.isEmpty, "payload identity mismatch cannot advance")
        print("PASS: missing and mismatched outcome identity")

        let invalid = EventFirstFlow()
        invalid.advance(); invalid.showReason(); invalid.select("unknown"); invalid.select("bridge-buy")
        expect(invalid.screen == .event && invalid.history.isEmpty, "invalid transitions and unavailable option are inert")
        invalid.select("bridge-team"); invalid.select("bridge-help")
        expect(invalid.history.count == 1 && invalid.chosen?.id == "bridge-team", "double submit does not replace choice")
        print("PASS: invalid state and duplicate submission")

        let team = EventFirstFlow(); team.select("bridge-team")
        expect(team.comparison?.contexts[0].support == "朋友能帶紙材，工作桌需預約", "team comparison contains shared material support")
        let help = EventFirstFlow(); help.select("bridge-help")
        expect(help.comparison?.contexts[0].support == "老師提供社區工具目錄；仍需自行預約", "help comparison contains teacher support")
        let wrongComparison = EventFirstFlow(comparisons: [UIFixtures.teamKey: UIFixtures.comparisons[UIFixtures.helpKey]!])
        wrongComparison.select("bridge-team")
        expect(wrongComparison.comparison == nil, "comparison payload mismatch fails closed")
        let noComparison = EventFirstFlow(comparisons: [:]); noComparison.select("bridge-team")
        expect(noComparison.comparison == nil, "absent comparison stays absent")
        print("PASS: paired, missing and mismatched comparisons")

        expect(team.outcome?.feedback?.reaction == "原來歪掉的地方，也可以一起修好。", "team authored reaction")
        expect(help.outcome?.feedback?.reaction == "還沒開始做，但我知道可以找誰幫忙了。", "help authored reaction")
        team.showReason(); team.showComparison(); team.showOutcome()
        expect(team.history.count == 1, "inspection cannot apply feedback twice")
        team.advance(); help.advance()
        expect(team.continuation?.title == "那座一起重做的紙橋", "team continuation")
        expect(help.continuation?.title == "那張借用工具清單", "help continuation")
        expect(team.displayedStatuses.first(where: { $0.id == "relations" })?.value == "多了一次合作經驗", "provided team state carried forward")
        expect(help.displayedStatuses.first(where: { $0.id == "relations" })?.value == "找到可以求助的老師", "provided help state carried forward")
        expect(team.statusHeading == "上個岔路留下的狀態 · 示範", "old snapshot is not called current state")
        print("PASS: branch-specific feedback and continuation")

        var mismatchedOutcomes = UIFixtures.outcomes
        mismatchedOutcomes[UIFixtures.teamKey]?.continuation = .init(eventID: "unrelated", title: "WRONG", reminder: "WRONG", statuses: [])
        let wrongContinuation = EventFirstFlow(outcomes: mismatchedOutcomes)
        wrongContinuation.select("bridge-team"); wrongContinuation.advance()
        expect(wrongContinuation.continuation == nil, "continuation for another event is dropped")
        var noFeedbackOutcomes = UIFixtures.outcomes
        noFeedbackOutcomes[UIFixtures.teamKey]?.feedback = nil
        noFeedbackOutcomes[UIFixtures.teamKey]?.continuation = nil
        let noFeedback = EventFirstFlow(outcomes: noFeedbackOutcomes)
        noFeedback.select("bridge-team")
        expect(noFeedback.outcome?.feedback == nil, "missing feedback remains absent")
        noFeedback.advance()
        expect(noFeedback.continuation == nil, "missing continuation is not invented")
        print("PASS: missing feedback and unrelated continuation")

        expect(team.nextActionLabel == "查看本段回顧", "last event announces review")
        team.select("time-rest"); team.advance()
        expect(team.stateLabel == "本段旅程完成", "review label")
        expect(team.map.nodes.count == 2, "only completed choices appear on map")
        team.showReason(); team.showComparison(); team.select("time-friends"); team.advance()
        expect(team.screen == .review && team.map.nodes.count == 2, "review is terminal until restart")
        team.restart()
        expect(team.history.isEmpty && team.continuation == nil && team.outcome == nil && team.chosen == nil, "restart clears route state")
        expect(team.displayedStatuses.first(where: { $0.id == "relations" })?.value == "朋友願意支持", "restart restores supplied initial snapshot")
        expect(team.nextActionLabel == "前往 15 歲的岔路", "first event announces actual next age")
        print("PASS: final-event boundary and restart")

        let empty = EventFirstFlow(events: [])
        empty.advance(); empty.select("shared"); empty.restart()
        expect(empty.event == nil && empty.map.nodes.isEmpty && empty.continuation == nil, "empty session remains empty")
        print("PASS: empty event boundary")
        print("PASS: 8 flow scenarios, \(checks) assertions")
    }
}
