import Foundation
import Combine

// Presentation-only authored snapshots. No Domain computation or persistence.
struct WorldChoiceKey: Hashable {
    var eventID: String
    var optionID: String
}

enum WorldPhase: String {
    case awaitingChoice, reacting, nextDay, passingYears, adultReturn, complete, blocked
}

enum WorldCharacter: String { case teen, adult }

enum WorldActor: String, Identifiable {
    case friend, caregiver, teacher
    var id: String { rawValue }
    var name: String {
        switch self {
        case .friend: return "小禾"
        case .caregiver: return "阿澄的家人"
        case .teacher: return "工坊老師"
        }
    }
}

enum WorldObject: String {
    case none, paperBridge, toolList, bridgeKeepsake, toolKeepsake
    var title: String {
        switch self {
        case .none: return "還在等一個主意"
        case .paperBridge: return "一起重做的紙橋"
        case .toolList: return "借用工具清單"
        case .bridgeKeepsake: return "留下來的紙橋"
        case .toolKeepsake: return "保存的舊清單"
        }
    }
    var symbol: String {
        switch self {
        case .none: return "lightbulb"
        case .paperBridge, .bridgeKeepsake: return "point.bottomleft.forward.to.point.topright.scurvepath"
        case .toolList, .toolKeepsake: return "list.clipboard"
        }
    }
}

struct WorldResource: Identifiable, Equatable {
    var id: String
    var title: String
    var value: String
    var symbol: String
}

struct WorldRelationship: Identifiable, Equatable {
    var id: String
    var name: String
    var detail: String
}

struct WorldSnapshot: Identifiable, Equatable {
    var id: String
    var age: Int
    var year: Int
    var timeLabel: String
    var title: String
    var narrative: String
    var character: WorldCharacter
    var reaction: String
    var object: WorldObject
    var actors: [WorldActor]
    var resources: [WorldResource]
    var relationships: [WorldRelationship]
    var pending: String
    var evidenceLabel: String = "視覺劇本示範 · 尚未接入人生引擎"
}

struct WorldOption: Identifiable {
    var id: String
    var title: String
    var detail: String
    var symbol: String
}

struct WorldEvent {
    var id: String
    var title: String
    var narrative: String
    var options: [WorldOption]
}

struct WorldReason: Identifiable {
    var id: String
    var title: String
    var detail: String
}

struct WorldContext: Identifiable {
    var id: String
    var title: String
    var detail: String
}

struct WorldComparison {
    var choiceTitle: String
    var contexts: [WorldContext]
    var evidenceLabel: String
    var limitation: String
}

enum WorldBeat: String, CaseIterable { case reaction, nextDay, adultReturn }

struct WorldRoute {
    var key: WorldChoiceKey
    var beats: [WorldBeat: WorldSnapshot]
    var reasons: [WorldReason]
    var comparison: WorldComparison
    var evidenceLabel: String = "來源：GS 視覺劇本 v1；設計說明，非 ConsequenceTrace"
}

struct WorldFixture {
    var event: WorldEvent
    var initial: WorldSnapshot
    var routes: [WorldChoiceKey: WorldRoute]
}

struct WorldRecord: Identifiable, Equatable {
    var id: String
    var title: String
    var summary: String
    var age: Int
    var year: Int
    var timeLabel: String
    var choiceTitle: String
}

enum WorldPlaybackSpeed: String {
    case normal, fast
    var title: String { self == .normal ? "1×" : "3×" }
    var ticksPerBeat: Int { self == .normal ? 3 : 1 }
}

@MainActor
final class WorldFlow: ObservableObject {
    @Published private(set) var snapshot: WorldSnapshot
    @Published private(set) var phase: WorldPhase = .awaitingChoice
    @Published private(set) var history: [WorldRecord] = []
    @Published private(set) var selectedKey: WorldChoiceKey?
    @Published private(set) var error: String?
    @Published private(set) var isPlaying = false
    @Published private(set) var speed: WorldPlaybackSpeed = .normal
    @Published private(set) var transitionYear: Int?

    let fixture: WorldFixture
    private var elapsedTicks = 0
    var event: WorldEvent { fixture.event }
    var presentationYear: Int { transitionYear ?? snapshot.year }
    var canAdvance: Bool { [.reacting, .nextDay, .passingYears, .adultReturn].contains(phase) }
    var selectedOption: WorldOption? { event.options.first { $0.id == selectedKey?.optionID } }
    var route: WorldRoute? {
        guard let selectedKey, let route = fixture.routes[selectedKey], route.key == selectedKey else { return nil }
        return route
    }

    init(fixture: WorldFixture = .demo) {
        self.fixture = fixture
        snapshot = fixture.initial
        if !Self.hasCompleteResources(snapshot) {
            error = "初始場景缺少完整的四項資源，請重新載入劇本。"
            phase = .blocked
        }
    }

    func select(optionID: String) {
        guard phase == .awaitingChoice else { return }
        guard event.options.contains(where: { $0.id == optionID }) else {
            block("找不到這個選項；保留目前場景。")
            return
        }
        let key = WorldChoiceKey(eventID: event.id, optionID: optionID)
        guard let route = fixture.routes[key], route.key == key else {
            block("事件與選項的路線資料缺漏或配對錯誤；沒有產生人生結果。")
            return
        }
        guard !route.reasons.isEmpty, route.comparison.contexts.count == 2,
              !route.evidenceLabel.isEmpty, !route.comparison.evidenceLabel.isEmpty,
              route.comparison.choiceTitle == event.options.first(where: { $0.id == optionID })?.title else {
            block("這個選擇的說明或環境對照資料不完整；沒有產生人生結果。")
            return
        }
        guard let first = route.beats[.reaction], validate(first) else {
            block("缺少有效的當日反應；沒有產生人生結果。")
            return
        }
        selectedKey = key
        isPlaying = false
        elapsedTicks = 0
        apply(first, phase: .reacting)
    }

    func advance() {
        guard canAdvance else { return }
        elapsedTicks = 0
        switch phase {
        case .reacting:
            guard let next = route?.beats[.nextDay], validate(next) else {
                block("缺少有效的隔天劇情；保留最後場景，不跳過缺漏內容。")
                return
            }
            apply(next, phase: .nextDay)
        case .nextDay:
            guard let adult = route?.beats[.adultReturn], validate(adult), adult.year > snapshot.year + 1 else {
                block("缺少有效的重訪劇情；沒有推算中間的人生。")
                return
            }
            transitionYear = snapshot.year + 1
            phase = .passingYears
        case .passingYears:
            guard let adult = route?.beats[.adultReturn], validate(adult), let year = transitionYear else {
                block("時光過場資料不完整；保留回憶場景。")
                return
            }
            if year < adult.year - 1 {
                transitionYear = year + 1
            } else {
                transitionYear = nil
                apply(adult, phase: .adultReturn)
                // Stop at the adult reveal so it cannot vanish behind the ending.
                pause()
            }
        case .adultReturn:
            phase = .complete
            pause()
        default: break
        }
    }

    func tick() {
        guard isPlaying, canAdvance else { return }
        elapsedTicks += 1
        if elapsedTicks >= speed.ticksPerBeat { advance() }
    }

    func togglePlayback() {
        guard canAdvance else { pause(); return }
        isPlaying.toggle()
        elapsedTicks = 0
    }

    func pause() {
        isPlaying = false
        elapsedTicks = 0
    }

    func cycleSpeed() {
        speed = speed == .normal ? .fast : .normal
        elapsedTicks = 0
    }

    func restart() {
        snapshot = fixture.initial
        phase = .awaitingChoice
        history = []
        selectedKey = nil
        error = nil
        transitionYear = nil
        speed = .normal
        pause()
        if !Self.hasCompleteResources(snapshot) { block("初始場景缺少完整的四項資源，請重新載入劇本。") }
    }

    private func apply(_ value: WorldSnapshot, phase: WorldPhase) {
        snapshot = value
        self.phase = phase
        guard let selectedKey else { return }
        let id = "\(selectedKey.eventID)|\(selectedKey.optionID)|\(value.id)"
        guard !history.contains(where: { $0.id == id }) else { return }
        history.append(WorldRecord(id: id, title: value.title, summary: value.narrative,
                                   age: value.age, year: value.year, timeLabel: value.timeLabel,
                                   choiceTitle: selectedOption?.title ?? ""))
    }

    private func validate(_ value: WorldSnapshot) -> Bool {
        !value.id.isEmpty && value.id != snapshot.id &&
        !history.contains(where: { $0.id.hasSuffix("|\(value.id)") }) &&
        value.age >= snapshot.age && value.year >= snapshot.year &&
        !value.reaction.isEmpty && Self.hasCompleteResources(value)
    }

    private static func hasCompleteResources(_ value: WorldSnapshot) -> Bool {
        value.resources.count == 4 && Set(value.resources.map(\.id)) == Set(["health", "finance", "relationships", "skills"]) &&
        value.resources.allSatisfy { !$0.value.isEmpty }
    }

    private func block(_ message: String) {
        error = message
        phase = .blocked
        pause()
    }
}

extension WorldFixture {
    static let demo: WorldFixture = makeDemo()

    private static func makeDemo() -> WorldFixture {
        let event = WorldEvent(id: "workshop-2027", title: "紙橋又歪了一邊",
            narrative: "創作展快到了。你和小禾做的紙橋站不穩，桌上的材料也快用完了。這個下午，你想怎麼做？",
            options: [
                WorldOption(id: "team", title: "和小禾一起重做", detail: "花時間一起試；材料可能還不夠", symbol: "person.2.fill"),
                WorldOption(id: "help", title: "向工坊老師求助", detail: "先問問借用工具；需要等待確認", symbol: "hand.raised.fill")
            ])
        func resources(_ health: String, _ relationships: String, _ skills: String) -> [WorldResource] {
            [WorldResource(id: "health", title: "健康", value: health, symbol: "heart.fill"),
             WorldResource(id: "finance", title: "財務安全", value: "這次沒有新增花費", symbol: "leaf.fill"),
             WorldResource(id: "relationships", title: "人際關係", value: relationships, symbol: "person.2.fill"),
             WorldResource(id: "skills", title: "技能與能力", value: skills, symbol: "sparkles")]
        }
        let family = WorldRelationship(id: "caregiver", name: "家人", detail: "放學後陪你到工坊，願意一起想辦法。")
        let friend = WorldRelationship(id: "friend", name: "小禾", detail: "在旁邊的朋友，也還在想紙橋怎麼站穩。")
        let initial = WorldSnapshot(id: "workshop-start", age: 13, year: 2027, timeLabel: "放學後 · 社區工坊",
            title: "一個還沒決定的下午", narrative: event.narrative, character: .teen,
            reaction: "再試一次？還是先找人幫忙？", object: .none, actors: [.friend, .caregiver],
            resources: resources("還有精神動手試", "有人願意陪你想", "正在探索紙橋結構"),
            relationships: [friend, family], pending: "創作展還沒開始，今天的選擇也還沒發生。")
        let teamKey = WorldChoiceKey(eventID: event.id, optionID: "team")
        let helpKey = WorldChoiceKey(eventID: event.id, optionID: "help")
        let teamRelations = [WorldRelationship(id: "friend", name: "小禾", detail: "和你分工扶住紙橋，一起找到了歪掉的位置。"), family]
        let helpRelations = [friend, family, WorldRelationship(id: "teacher", name: "工坊老師", detail: "先聽你說卡住的地方，給了一張借用工具清單。")]
        let teamReaction = WorldSnapshot(id: "team-reaction", age: 13, year: 2027, timeLabel: "當日下午 · 一起動手",
            title: "紙橋上多了兩雙手", narrative: "小禾扶著橋，你把歪掉的一側拆開重折。家人幫你們留下桌上的紙邊。橋還沒完成，但你們找到下一個可以試的位置。",
            character: .teen, reaction: "原來歪掉的地方，也可以一起修好。", object: .paperBridge,
            actors: [.friend, .caregiver], resources: resources("想歇一下再動手", "多了一次合作經驗", "找到紙橋要補強的位置"),
            relationships: teamRelations, pending: "材料還不夠；是否參展，還沒有決定。")
        let teamNext = WorldSnapshot(id: "team-next-day", age: 13, year: 2027, timeLabel: "隔天放學 · 小小的回聲",
            title: "小禾記得那個歪掉的地方", narrative: "隔天，小禾帶來幾張用剩的厚紙。你們把昨天的折痕攤開，在同一張桌子旁再試了一次。",
            character: .teen, reaction: "你還記得昨天的主意！", object: .paperBridge,
            actors: [.friend, .caregiver], resources: resources("先休息，再一起試", "有人接住昨天的主意", "又試了一種補強方式"),
            relationships: [WorldRelationship(id: "friend", name: "小禾", detail: "帶來用剩的厚紙，接著昨天的主意一起試。"), family],
            pending: "這是一次共同修改，沒有保證紙橋會得獎。")
        let teamAdult = WorldSnapshot(id: "team-adult-return", age: 22, year: 2036, timeLabel: "九年後 · 回到同一個工坊",
            title: "那個下午，還留在這裡", narrative: "九年後，你以成年模樣重訪工坊。展示櫃裡保留著那座紙橋的模型；你想起小禾扶著橋、家人在旁陪伴的下午。中間的人生沒有在這段示範中模擬。",
            character: .adult, reaction: "原來我還記得，我們是怎麼一起重做的。", object: .bridgeKeepsake,
            actors: [], resources: resources("成年近況尚未提供", "記得一次被陪伴的經驗", "記得當年的補強嘗試"),
            relationships: [WorldRelationship(id: "friend", name: "小禾・回憶", detail: "當年一起修紙橋的朋友；成年近況尚未提供。"),
                            WorldRelationship(id: "caregiver", name: "家人・回憶", detail: "記得工坊裡的陪伴；成年近況尚未提供。")],
            pending: "這段重訪只呈現回憶，沒有設定你的職業、收入或人生高低。")
        let helpReaction = WorldSnapshot(id: "help-reaction", age: 13, year: 2027, timeLabel: "當日下午 · 開口求助",
            title: "老師走到桌邊", narrative: "你把站不穩的紙橋指給老師看。老師來到桌邊，一起列出可能借到的工具；小禾在旁邊記下需要詢問的事情。",
            character: .teen, reaction: "還沒開始做，但我知道可以找誰幫忙了。", object: .toolList,
            actors: [.friend, .caregiver, .teacher], resources: resources("還有精神整理工具", "找到可以求助的老師", "有了一張借用工具清單"),
            relationships: helpRelations, pending: "工具能否借到仍待確認，還沒有拿到新材料。")
        let helpNext = WorldSnapshot(id: "help-next-day", age: 13, year: 2027, timeLabel: "隔天放學 · 等待回覆",
            title: "清單沒有被丟在一旁", narrative: "家人陪你看昨天的清單。老師的借用確認還沒回來，你先把要問的問題圈起來。紙橋仍在桌上，這次你知道可以問什麼。",
            character: .teen, reaction: "還要等一下，我可以先把問題寫清楚。", object: .toolList,
            actors: [.friend, .caregiver], resources: resources("按自己的步調整理", "家人陪你等待回覆", "把要問的問題列清楚"),
            relationships: [friend, WorldRelationship(id: "caregiver", name: "家人", detail: "陪你看工具清單，不要求你一個人解決。"),
                            WorldRelationship(id: "teacher", name: "工坊老師", detail: "借用工具仍待確認；尚未保證能提供材料。")],
            pending: "等待不是失敗；借用能否成立，這段示範沒有提供結果。")
        let helpAdult = WorldSnapshot(id: "help-adult-return", age: 22, year: 2036, timeLabel: "九年後 · 回到同一個工坊",
            title: "那張清單，還認得你的字", narrative: "九年後，你以成年模樣重訪工坊。你翻開保存的舊清單，想起那次把問題說出口的下午。工具最後是否借到，以及中間的人生，這段示範沒有補寫。",
            character: .adult, reaction: "當時最難的，好像是說出「我需要幫忙」。", object: .toolKeepsake,
            actors: [], resources: resources("成年近況尚未提供", "記得有人聽你求助", "記得列出問題的方法"),
            relationships: [WorldRelationship(id: "teacher", name: "老師・回憶", detail: "曾陪你列出問題；成年近況尚未提供。"),
                            WorldRelationship(id: "caregiver", name: "家人・回憶", detail: "記得一起等待回覆；成年近況尚未提供。")],
            pending: "開口求助沒有被換算成成年成功；這裡只保留一段回憶。")
        // Adult finance is deliberately unknown, not a carry-over claim across nine years.
        var teamAdultFinal = teamAdult
        var helpAdultFinal = helpAdult
        teamAdultFinal.resources[1].value = "成年近況尚未提供"
        helpAdultFinal.resources[1].value = "成年近況尚未提供"
        func comparison(_ choice: String, _ first: String, _ second: String) -> WorldComparison {
            WorldComparison(choiceTitle: choice,
                contexts: [WorldContext(id: "available", title: "工坊開放、有人可問", detail: first),
                           WorldContext(id: "limited", title: "工坊關閉、交通需安排", detail: second)],
                evidenceLabel: "來源：GS 視覺劇本 v1 的環境示意",
                limitation: "同一選擇在不同條件下可能需要不同安排。這不是國家資料、機率計算或真實因果證據。")
        }
        let teamRoute = WorldRoute(key: teamKey, beats: [.reaction: teamReaction, .nextDay: teamNext, .adultReturn: teamAdultFinal],
            reasons: [WorldReason(id: "choice", title: "你做了什麼", detail: "把這個下午用在和朋友一起拆開重做。"),
                      WorldReason(id: "support", title: "誰提供了支持", detail: "小禾扶住紙橋，家人協助保留材料。"),
                      WorldReason(id: "unknown", title: "還不知道的部分", detail: "材料仍不足，參展與後來的人生都不是這次決策的保證結果。")],
            comparison: comparison("和小禾一起重做", "可以在同一張桌邊分工，請家人保留用剩的材料。", "可能先各自畫草圖，再約下一次能一起試的時間；不保證材料變多。"))
        let helpRoute = WorldRoute(key: helpKey, beats: [.reaction: helpReaction, .nextDay: helpNext, .adultReturn: helpAdultFinal],
            reasons: [WorldReason(id: "choice", title: "你做了什麼", detail: "向老師說明紙橋卡住的地方，開始列工具清單。"),
                      WorldReason(id: "support", title: "誰提供了支持", detail: "老師聽完問題，小禾記錄，家人陪你等待確認。"),
                      WorldReason(id: "unknown", title: "還不知道的部分", detail: "清單不等於工具已借到，也不保證參展或成年職涯。")],
            comparison: comparison("向工坊老師求助", "可以當面說明卡住的地方，但仍要確認工具是否可借。", "可能先留下問題、請家人協助聯絡，等開放時間再確認；支援不是隨時可得。"))
        return WorldFixture(event: event, initial: initial, routes: [teamKey: teamRoute, helpKey: helpRoute])
    }
}
