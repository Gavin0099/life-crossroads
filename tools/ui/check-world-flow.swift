import Foundation

// Expected values come from docs/gameplay/fixture-contract.md, written first.
// Compile this file together with the actual WorldModels.swift; no mock model.
@main
struct WorldFlowChecks {
    @MainActor static func main() {
        var assertions = 0
        var scenarios = 0
        func expect(_ condition: @autoclosure () -> Bool, _ message: String) {
            assertions += 1
            guard condition() else {
                FileHandle.standardError.write(Data("FAIL: \(message)\n".utf8))
                exit(1)
            }
        }
        func scenario(_ title: String) {
            scenarios += 1
            print("PASS: \(title)")
        }
        let teamKey = WorldChoiceKey(eventID: "workshop-2027", optionID: "team")
        let helpKey = WorldChoiceKey(eventID: "workshop-2027", optionID: "help")

        let gate = WorldFlow()
        let initial = gate.snapshot
        gate.advance()
        gate.togglePlayback()
        for _ in 0..<30 { gate.tick() }
        expect(gate.phase == .awaitingChoice && gate.snapshot == initial, "choice gate keeps initial world")
        expect(!gate.isPlaying && gate.history.isEmpty && gate.selectedKey == nil, "choice gate cannot start playback or invent history")
        scenario("waiting for choice blocks manual and automatic progression")

        let team = WorldFlow()
        team.select(optionID: "team")
        expect(team.selectedKey == teamKey && team.phase == .reacting, "team choice keyed by event and option")
        expect(team.snapshot.reaction == "原來歪掉的地方，也可以一起修好。", "team authored reaction")
        expect(team.snapshot.object == .paperBridge && team.snapshot.actors == [.friend, .caregiver], "team scene object and actors")
        expect(team.snapshot.resources.first(where: { $0.id == "relationships" })?.value == "多了一次合作經驗", "team visible relationship state")
        expect(team.history.count == 1 && !team.isPlaying, "reaction is recorded once and paused")
        scenario("team choice changes visible world with authored snapshot")

        let help = WorldFlow()
        help.select(optionID: "help")
        expect(help.selectedKey == helpKey && help.snapshot.object == .toolList, "help scene has a tool list")
        expect(help.snapshot.reaction == "還沒開始做，但我知道可以找誰幫忙了。", "help authored reaction")
        expect(help.snapshot.actors.contains(.teacher), "teacher appears on help route")
        expect(help.snapshot.resources.first(where: { $0.id == "skills" })?.value == "有了一張借用工具清單", "help skills show list, not invented numerical increase")
        expect(help.snapshot.pending.contains("仍待確認"), "tool acquisition remains unresolved")
        expect(help.route?.comparison.choiceTitle == "向工坊老師求助", "comparison preserves selected choice")
        expect(help.route?.comparison.contexts.first?.detail != team.route?.comparison.contexts.first?.detail, "comparison descriptions actually differ by choice")
        scenario("help route differs in object, reaction, actors and comparison")

        let paused = team.snapshot
        for _ in 0..<50 { team.tick() }
        expect(team.snapshot == paused && team.history.count == 1, "paused ticks cannot change world or history")
        team.togglePlayback()
        team.tick()
        team.tick()
        expect(team.phase == .reacting, "normal playback waits three ticks")
        team.tick()
        expect(team.phase == .nextDay && team.snapshot.age == 13 && team.snapshot.year == 2027, "third tick advances to authored next day")
        team.pause()
        for _ in 0..<6 { team.tick() }
        expect(team.phase == .nextDay && team.history.count == 2, "pause during playback holds next day")
        scenario("pause and normal playback preserve authored beat boundaries")

        help.advance()
        expect(help.snapshot.title == "清單沒有被丟在一旁" && help.snapshot.age == 13, "help next-day echo")
        expect(!help.snapshot.actors.contains(.teacher), "waiting day does not falsely show a teacher reply")
        expect(help.snapshot.pending.contains("沒有提供結果"), "next-day support is not an invented success")
        let echo = help.snapshot
        help.advance()
        expect(help.phase == .passingYears && help.transitionYear == 2028, "first transition year is 2028")
        expect(help.snapshot == echo && help.history.count == 2, "transition preserves memory snapshot and history")
        help.cycleSpeed()
        expect(help.speed == .fast, "speed cycles to fast")
        help.togglePlayback()
        help.tick()
        expect(help.transitionYear == 2029, "fast playback advances exactly one year per tick")
        for year in 2030...2035 {
            help.tick()
            expect(help.transitionYear == year && help.presentationYear == year, "year axis is continuous through \(year)")
            expect(help.snapshot == echo && help.history.count == 2, "empty year \(year) cannot invent life changes")
        }
        help.tick()
        expect(help.phase == .adultReturn && help.transitionYear == nil, "last transition reveals adult snapshot")
        expect(help.snapshot.age == 22 && help.snapshot.year == 2036 && help.snapshot.character == .adult, "adult appearance and time are authored")
        expect(help.snapshot.object == .toolKeepsake && !help.isPlaying, "adult keepsake differs and reveal pauses")
        expect(help.history.map(\.age) == [13, 13, 22] && help.history.map(\.year) == [2027, 2027, 2036], "only three authored snapshots are recorded")
        expect(help.snapshot.resources.first(where: { $0.id == "finance" })?.value == "成年近況尚未提供", "adult unknown finances never carry over as fact")
        scenario("continuous year axis never invents skipped-year states or records")

        team.advance()
        for _ in 0..<8 { team.advance() }
        expect(team.phase == .adultReturn && team.snapshot.object == .bridgeKeepsake, "team route reaches distinct adult keepsake")
        expect(team.snapshot.reaction == "原來我還記得，我們是怎麼一起重做的。", "team adult memory is authored")
        expect(team.history.map(\.title) == ["紙橋上多了兩雙手", "小禾記得那個歪掉的地方", "那個下午，還留在這裡"], "team records preserve visible scene sequence")
        scenario("team adult return keeps its own memory and record sequence")

        let final = help.snapshot
        help.advance()
        expect(help.phase == .complete && !help.isPlaying, "ending stops playback")
        help.advance()
        help.togglePlayback()
        for _ in 0..<20 { help.tick() }
        expect(help.phase == .complete && help.snapshot == final && help.history.count == 3, "ending never loops or duplicates records")
        help.select(optionID: "team")
        expect(help.selectedKey == helpKey && help.snapshot == final, "cannot overwrite completed choice")
        scenario("ending retains world and prevents duplicate choice or records")

        let repeated = WorldFlow()
        repeated.select(optionID: "team")
        let firstReaction = repeated.snapshot
        repeated.select(optionID: "team")
        repeated.select(optionID: "help")
        expect(repeated.snapshot == firstReaction && repeated.history.count == 1 && repeated.selectedKey == teamKey, "repeated taps cannot append or switch branch")
        repeated.cycleSpeed()
        repeated.togglePlayback()
        repeated.restart()
        expect(repeated.snapshot == initial && repeated.history.isEmpty && repeated.selectedKey == nil, "restart clears branch and records")
        expect(repeated.phase == .awaitingChoice && repeated.speed == .normal && repeated.error == nil && !repeated.isPlaying && repeated.transitionYear == nil, "restart clears all playback and error state")
        repeated.select(optionID: "help")
        expect(repeated.snapshot.object == .toolList && repeated.history.count == 1, "new route works after restart")
        scenario("repeat protection and restart give both paths the same starting conditions")

        let invalid = WorldFlow()
        invalid.select(optionID: "unknown")
        expect(invalid.phase == .blocked && invalid.error != nil && invalid.snapshot == initial && invalid.history.isEmpty, "unknown option fails without outcome")
        invalid.restart()
        expect(invalid.phase == .awaitingChoice && invalid.error == nil, "restart recovers from invalid input")
        scenario("unknown option reports an error without changing world")

        var missingRoute = WorldFixture.demo
        missingRoute.routes.removeValue(forKey: teamKey)
        let noRoute = WorldFlow(fixture: missingRoute)
        noRoute.select(optionID: "team")
        expect(noRoute.phase == .blocked && noRoute.history.isEmpty && noRoute.selectedKey == nil, "missing route cannot resolve by option alone")
        var wrongEvent = WorldFixture.demo
        wrongEvent.event.id = "another-event"
        let wrongEventFlow = WorldFlow(fixture: wrongEvent)
        wrongEventFlow.select(optionID: "team")
        expect(wrongEventFlow.phase == .blocked && wrongEventFlow.snapshot == initial, "event identity is required for reused option ID")
        var wrongPayload = WorldFixture.demo
        wrongPayload.routes[teamKey]?.key = helpKey
        let wrongPayloadFlow = WorldFlow(fixture: wrongPayload)
        wrongPayloadFlow.select(optionID: "team")
        expect(wrongPayloadFlow.phase == .blocked && wrongPayloadFlow.history.isEmpty, "dictionary key and payload key must agree")
        scenario("missing and mismatched event-option pairs fail closed")

        var missingDetails = WorldFixture.demo
        missingDetails.routes[teamKey]?.comparison.contexts = []
        let noDetails = WorldFlow(fixture: missingDetails)
        noDetails.select(optionID: "team")
        expect(noDetails.phase == .blocked && noDetails.history.isEmpty, "missing comparison cannot present a made-up explanation")
        var wrongComparison = WorldFixture.demo
        wrongComparison.routes[teamKey]?.comparison.choiceTitle = "向工坊老師求助"
        let wrongComparisonFlow = WorldFlow(fixture: wrongComparison)
        wrongComparisonFlow.select(optionID: "team")
        expect(wrongComparisonFlow.phase == .blocked, "comparison must describe the actual selected option")
        scenario("missing or unrelated explanations cannot masquerade as choice evidence")

        var missingReaction = WorldFixture.demo
        missingReaction.routes[teamKey]?.beats.removeValue(forKey: .reaction)
        let noReaction = WorldFlow(fixture: missingReaction)
        noReaction.select(optionID: "team")
        expect(noReaction.phase == .blocked && noReaction.snapshot == initial && noReaction.history.isEmpty, "missing first beat leaves initial scene")
        var missingDay = WorldFixture.demo
        missingDay.routes[teamKey]?.beats.removeValue(forKey: .nextDay)
        let noDay = WorldFlow(fixture: missingDay)
        noDay.select(optionID: "team")
        let preserved = noDay.snapshot
        noDay.togglePlayback()
        for _ in 0..<3 { noDay.tick() }
        expect(noDay.phase == .blocked && !noDay.isPlaying && noDay.snapshot == preserved && noDay.history.count == 1, "missing next day stops at last valid scene")
        noDay.advance()
        noDay.tick()
        expect(noDay.snapshot == preserved && noDay.history.count == 1, "failure cannot silently skip to adult")
        scenario("missing reaction and next-day beats preserve the last valid world")

        var missingAdult = WorldFixture.demo
        missingAdult.routes[helpKey]?.beats.removeValue(forKey: .adultReturn)
        let noAdult = WorldFlow(fixture: missingAdult)
        noAdult.select(optionID: "help")
        noAdult.advance()
        let lastDay = noAdult.snapshot
        noAdult.advance()
        expect(noAdult.phase == .blocked && noAdult.transitionYear == nil && noAdult.snapshot == lastDay && noAdult.history.count == 2, "missing adult beat cannot start invented years")
        scenario("missing adult return blocks before the time transition")

        var incompleteResources = WorldFixture.demo
        incompleteResources.routes[teamKey]?.beats[.nextDay]?.resources.removeLast()
        let incomplete = WorldFlow(fixture: incompleteResources)
        incomplete.select(optionID: "team")
        incomplete.advance()
        expect(incomplete.phase == .blocked && incomplete.history.count == 1, "partial resource snapshots cannot be filled in from prior state")
        var invalidInitial = WorldFixture.demo
        invalidInitial.initial.resources = []
        let badStart = WorldFlow(fixture: invalidInitial)
        expect(badStart.phase == .blocked && badStart.error != nil, "invalid initial snapshot starts blocked")
        badStart.restart()
        expect(badStart.phase == .blocked, "restart cannot make invalid fixture usable")
        scenario("complete four-resource snapshots are required, including initial state")

        var backwards = WorldFixture.demo
        backwards.routes[teamKey]?.beats[.nextDay]?.year = 2026
        let backwardsFlow = WorldFlow(fixture: backwards)
        backwardsFlow.select(optionID: "team")
        backwardsFlow.advance()
        expect(backwardsFlow.phase == .blocked && backwardsFlow.snapshot.year == 2027, "backward year is rejected")
        var duplicate = WorldFixture.demo
        duplicate.routes[teamKey]?.beats[.nextDay]?.id = "team-reaction"
        let duplicateFlow = WorldFlow(fixture: duplicate)
        duplicateFlow.select(optionID: "team")
        duplicateFlow.advance()
        expect(duplicateFlow.phase == .blocked && duplicateFlow.history.count == 1, "duplicate beat identity cannot become a second record")
        scenario("non-monotonic and duplicate authored beats are rejected")

        print("WorldFlow: \(scenarios) scenarios, \(assertions) assertions passed.")
    }
}
