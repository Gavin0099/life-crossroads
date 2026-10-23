import SwiftUI

// These DTOs carry display text. An integration adapter supplies values and outcomes;
// neither the view nor this fixture store calculates life outcomes or probabilities.
struct OptionViewDTO: Identifiable {
    let id: String
    let title: String
    let cost: String
    let support: String
    let uncertainty: String
    let isAvailable: Bool
    let unavailableReason: String?
}

struct EventViewDTO: Identifiable {
    let id: String
    let characterName: String
    let age: String
    let year: String
    let stage: String
    let title: String
    let narrative: String
    let artworkID: String?
    let options: [OptionViewDTO]
    let statuses: [StatusViewDTO]
}

struct StatusViewDTO: Identifiable {
    let id: String
    let label: String
    let value: String
    let symbol: String
}

struct TraceFactorViewDTO: Identifiable {
    let id: String
    let kind: String
    let explanation: String
    let evidenceLabel: String
}

struct ChoiceKey: Hashable {
    let eventID: String
    let optionID: String
}

struct StatusChangeDTO: Identifiable {
    let id: String
    let label: String
    let before: String
    let after: String
}

struct ChoiceFeedbackDTO {
    let reaction: String
    let symbol: String
    let changes: [StatusChangeDTO]
    let statusesAfter: [StatusViewDTO]
}

struct EventContinuationDTO {
    let eventID: String
    let title: String
    let reminder: String
    let statuses: [StatusViewDTO]
}

struct OutcomeViewDTO {
    let key: ChoiceKey
    let title: String
    let immediate: [String]
    let pending: [String]
    let factors: [TraceFactorViewDTO]
    let evidenceLabel: String
    var feedback: ChoiceFeedbackDTO? = nil
    var continuation: EventContinuationDTO? = nil
}

struct ComparisonContextDTO: Identifiable {
    let id: String
    let label: String
    let conditions: String
    let cost: String
    let support: String
}

struct ComparisonViewDTO {
    let key: ChoiceKey
    let fixedConditions: String
    let changedConditions: String
    let contexts: [ComparisonContextDTO]
    let limitation: String
}

struct LifeMapViewDTO {
    let stages: [String]
    let currentStage: String
    let nodes: [RecordedChoice]
}

enum PlayScreen { case event, outcome, reason, comparison, review }
enum DetailPage: String, CaseIterable, Identifiable {
    case profile = "人物與家庭", map = "人生地圖", history = "人生紀錄"
    var id: String { rawValue }
}

struct RecordedChoice: Identifiable {
    let id: ChoiceKey
    let age: String
    let eventTitle: String
    let choiceTitle: String
    let facts: [String]
}

@MainActor final class EventFirstFlow: ObservableObject {
    @Published private(set) var index = 0
    @Published private(set) var screen: PlayScreen = .event
    @Published private(set) var outcome: OutcomeViewDTO?
    @Published private(set) var chosen: OptionViewDTO?
    @Published private(set) var history: [RecordedChoice] = []
    @Published private(set) var message: String?
    @Published private(set) var continuation: EventContinuationDTO?
    private let events: [EventViewDTO]
    private let outcomes: [ChoiceKey: OutcomeViewDTO]
    private let comparisons: [ChoiceKey: ComparisonViewDTO]

    init(events: [EventViewDTO] = UIFixtures.events,
         outcomes: [ChoiceKey: OutcomeViewDTO] = UIFixtures.outcomes,
         comparisons: [ChoiceKey: ComparisonViewDTO] = UIFixtures.comparisons) {
        self.events = events
        self.outcomes = outcomes
        self.comparisons = comparisons
    }

    var event: EventViewDTO? { events.indices.contains(index) ? events[index] : nil }
    var progressLabel: String { events.isEmpty ? "沒有待選事件" : "事件 \(index + 1) / \(events.count)" }
    var stateLabel: String {
        switch screen {
        case .event: return "等待你的選擇"
        case .outcome: return "看看選擇留下了什麼"
        case .reason: return "正在回看原因"
        case .comparison: return "正在比較環境"
        case .review: return "本段旅程完成"
        }
    }
    var nextActionLabel: String {
        guard events.indices.contains(index + 1) else { return "查看本段回顧" }
        return "前往 \(events[index + 1].age)的岔路"
    }
    var displayedStatuses: [StatusViewDTO] {
        outcome?.feedback?.statusesAfter ?? continuation?.statuses ?? event?.statuses ?? []
    }
    var statusHeading: String {
        if outcome?.feedback != nil { return "這次選擇後的狀態 · 示範" }
        return continuation == nil ? "目前的你 · 示範" : "上個岔路留下的狀態 · 示範"
    }

    func select(_ id: String) {
        guard screen == .event, let event,
              let option = event.options.first(where: { $0.id == id }), option.isAvailable else { return }
        let key = ChoiceKey(eventID: event.id, optionID: id)
        guard let provided = outcomes[key], provided.key == key else {
            message = "這個選擇的後果尚未提供，請保留在這個岔路。"
            return
        }
        chosen = option
        outcome = provided
        message = nil
        history.append(.init(id: key, age: event.age, eventTitle: event.title,
                             choiceTitle: option.title, facts: provided.immediate))
        screen = .outcome
    }

    private var canInspect: Bool { outcome != nil && screen != .event && screen != .review }
    func showReason() { if canInspect { screen = .reason } }
    func showComparison() { if canInspect { screen = .comparison } }
    func showOutcome() { if canInspect { screen = .outcome } }

    func advance() {
        guard screen != .event, screen != .review, outcome != nil else { return }
        guard index + 1 < events.count else { screen = .review; return }
        let next = outcome?.continuation
        index += 1
        continuation = next?.eventID == event?.id ? next : nil
        chosen = nil
        outcome = nil
        message = nil
        screen = .event
    }

    func restart() {
        index = 0; chosen = nil; outcome = nil; continuation = nil; message = nil; history = []; screen = .event
    }

    var comparison: ComparisonViewDTO? {
        guard let chosen, let event else { return nil }
        let key = ChoiceKey(eventID: event.id, optionID: chosen.id)
        guard let provided = comparisons[key], provided.key == key else { return nil }
        return provided
    }

    var map: LifeMapViewDTO {
        .init(stages: ["童年", "青少年", "青年", "中年", "晚年"],
              currentStage: event?.stage ?? "尚未開始", nodes: history)
    }
}

// Explicitly authored, fictional UI fixtures. Numeric labels are not country averages.
enum UIFixtures {
    static let statuses: [StatusViewDTO] = [
        .init(id: "health", label: "健康", value: "精神尚可", symbol: "heart"),
        .init(id: "finance", label: "財務安全", value: "材料預算有限", symbol: "wallet.pass"),
        .init(id: "relations", label: "人際關係", value: "朋友願意支持", symbol: "person.2"),
        .init(id: "skills", label: "技能與能力", value: "動手探索中", symbol: "wrench.and.screwdriver")
    ]
    static let firstOptions: [OptionViewDTO] = [
        .init(id: "bridge-team", title: "和朋友做簡易作品", cost: "用 2 格精力", support: "朋友共享材料", uncertainty: "可能需要重做", isAvailable: true, unavailableReason: nil),
        .init(id: "bridge-help", title: "先找老師想辦法", cost: "用 1 格精力", support: "一起找可借的工具", uncertainty: "還需要安排時間", isAvailable: true, unavailableReason: nil),
        .init(id: "bridge-buy", title: "自己買全套材料", cost: "超出目前材料預算", support: "尚無額外支援", uncertainty: "先找其他準備方法", isAvailable: false, unavailableReason: "目前不可選：材料預算不足")
    ]
    static let secondOptions: [OptionViewDTO] = [
        .init(id: "time-friends", title: "和朋友約固定練習日", cost: "每週留 1 個放學時段", support: "朋友互相提醒", uncertainty: "需要配合彼此時間", isAvailable: true, unavailableReason: nil),
        .init(id: "time-rest", title: "先留一點休息空間", cost: "這週減少練習", support: "與家人討論安排", uncertainty: "作品進度可能較慢", isAvailable: true, unavailableReason: nil)
    ]
    static let events: [EventViewDTO] = [
        .init(id: "bridge", characterName: "阿澄", age: "13 歲", year: "2027 年", stage: "青少年", title: "一座紙橋，一個新點子。", narrative: "社區創作展開始報名了。你想做紙橋，但材料和放學後的時間有限。", artworkID: "workshop", options: firstOptions, statuses: statuses),
        .init(id: "after-school", characterName: "阿澄", age: "15 歲", year: "2029 年", stage: "青少年", title: "放學後，留一點空間。", narrative: "新的學期開始了。你想繼續做作品，也希望留下和朋友相處、休息的時間。", artworkID: nil, options: secondOptions, statuses: statuses)
    ]
    static let teamKey = ChoiceKey(eventID: "bridge", optionID: "bridge-team")
    static let helpKey = ChoiceKey(eventID: "bridge", optionID: "bridge-help")
    static let teamStatuses: [StatusViewDTO] = [
        .init(id: "health", label: "健康", value: "想歇一下再動手", symbol: "heart"),
        statuses[1],
        .init(id: "relations", label: "人際關係", value: "多了一次合作經驗", symbol: "person.2"),
        .init(id: "skills", label: "技能與能力", value: "找到紙橋要補強的位置", symbol: "wrench.and.screwdriver")
    ]
    static let helpStatuses: [StatusViewDTO] = [
        .init(id: "health", label: "健康", value: "還有精神整理工具", symbol: "heart"),
        statuses[1],
        .init(id: "relations", label: "人際關係", value: "找到可以求助的老師", symbol: "person.2"),
        .init(id: "skills", label: "技能與能力", value: "有了一張借用工具清單", symbol: "wrench.and.screwdriver")
    ]
    static let outcomes: [ChoiceKey: OutcomeViewDTO] = [
        teamKey: .init(key: teamKey, title: "先一起試一次。",
            immediate: ["你和朋友完成第一個模型，也發現一個需要重做的地方。", "這次使用了 2 格精力。"],
            pending: ["下次還想一起做作品嗎？朋友還沒有和你約好時間。"],
            factors: [.init(id: "choice-team", kind: "選擇", explanation: "你選擇先做簡易作品。", evidenceLabel: "示範依據：選項 bridge-team"), .init(id: "support-team", kind: "支持", explanation: "朋友提供共享材料。", evidenceLabel: "示範依據：這個家庭情境的支持設定")],
            evidenceLabel: "原型敘事，尚未接真實後果紀錄",
            feedback: .init(reaction: "原來歪掉的地方，也可以一起修好。", symbol: "person.2.fill", changes: [
                .init(id: "relations", label: "人際關係", before: "朋友願意支持", after: "多了一次合作經驗"),
                .init(id: "skills", label: "技能與能力", before: "動手探索中", after: "找到紙橋要補強的位置")
            ], statusesAfter: teamStatuses),
            continuation: .init(eventID: "after-school", title: "那座一起重做的紙橋", reminder: "你還記得和朋友一起找問題的經驗。這次，要怎麼安排相處與休息？", statuses: teamStatuses)),
        helpKey: .init(key: helpKey, title: "找到一雙援手。",
            immediate: ["老師和你列出能借的工具。你還沒報名，但多了一條準備路線。", "這次使用了 1 格精力。"],
            pending: ["工具能不能借到，還要確認開放時間。參展也還沒決定。"],
            factors: [.init(id: "support-teacher", kind: "支持", explanation: "老師協助整理工具清單。", evidenceLabel: "示範依據：選項 bridge-help")],
            evidenceLabel: "原型敘事，尚未接真實後果紀錄",
            feedback: .init(reaction: "還沒開始做，但我知道可以找誰幫忙了。", symbol: "lightbulb.fill", changes: [
                .init(id: "relations", label: "人際關係", before: "朋友願意支持", after: "找到可以求助的老師"),
                .init(id: "skills", label: "技能與能力", before: "動手探索中", after: "有了一張借用工具清單")
            ], statusesAfter: helpStatuses),
            continuation: .init(eventID: "after-school", title: "那張借用工具清單", reminder: "你留下了老師一起整理的清單，借用還要安排。這次，要替準備與休息留下多少空間？", statuses: helpStatuses)),
        .init(eventID: "after-school", optionID: "time-friends"): .init(key: .init(eventID: "after-school", optionID: "time-friends"), title: "替相處留一個位置。", immediate: ["你和朋友約好每週見面練習。", "一個放學時段已安排給共同作品。"], pending: [], factors: [], evidenceLabel: "原型敘事，尚未提供原因紀錄"),
        .init(eventID: "after-school", optionID: "time-rest"): .init(key: .init(eventID: "after-school", optionID: "time-rest"), title: "留一點，給自己。", immediate: ["你與家人重新安排這週的時間。", "作品暫時放慢，休息時間保留下來。"], pending: [], factors: [], evidenceLabel: "原型敘事，尚未提供原因紀錄")
    ]
    static let comparisons: [ChoiceKey: ComparisonViewDTO] = [
        teamKey: .init(key: teamKey, fixedConditions: "同一個人、同年齡、和朋友做簡易作品", changedConditions: "朋友共享材料的地點、集合交通與開放時間", contexts: [
            .init(id: "context-a", label: "日本 · 示範家庭 A", conditions: "朋友在附近社區共享材料", cost: "集合交通占用 1 格時間", support: "朋友能帶紙材，工作桌需預約"),
            .init(id: "context-b", label: "肯亞 · 示範家庭 B", conditions: "朋友在較遠的學校共享材料", cost: "集合交通占用 2 格時間", support: "學校提供紙材，朋友需配合放學時間")
        ], limitation: comparisonLimitation),
        helpKey: .init(key: helpKey, fixedConditions: "同一個人、同年齡、先找老師想辦法", changedConditions: "老師可協助的時段、工具借用條件", contexts: [
            .init(id: "context-a", label: "日本 · 示範家庭 A", conditions: "老師能在當天放學後討論", cost: "先留一個討論時段", support: "老師提供社區工具目錄；仍需自行預約"),
            .init(id: "context-b", label: "肯亞 · 示範家庭 B", conditions: "老師下週才有空，校內工具可借", cost: "等待下週並安排借用", support: "老師協助校內借用；仍要確認開放時間")
        ], limitation: comparisonLimitation)
    ]
    static let comparisonLimitation = "這是虛構家庭條件的介面示範，不代表國家平均或實際計算。只換國名而不換條件時，結果應相同。"

    @MainActor static func makeFlow(arguments: [String]) -> EventFirstFlow {
        if arguments.contains("-empty-events") { return EventFirstFlow(events: []) }
        if arguments.contains("-empty-options") {
            let e = events[0]
            return EventFirstFlow(events: [.init(id: e.id, characterName: e.characterName, age: e.age, year: e.year, stage: e.stage, title: e.title, narrative: e.narrative, artworkID: e.artworkID, options: [], statuses: e.statuses)])
        }
        if arguments.contains("-missing-outcome") { return EventFirstFlow(outcomes: [:]) }
        if arguments.contains("-missing-comparison") { return EventFirstFlow(comparisons: [:]) }
        if arguments.contains("-missing-trace") {
            var changed = outcomes
            let o = outcomes[teamKey]!
            changed[teamKey] = .init(key: o.key, title: o.title, immediate: o.immediate, pending: o.pending, factors: [], evidenceLabel: o.evidenceLabel, feedback: o.feedback, continuation: o.continuation)
            return EventFirstFlow(outcomes: changed)
        }
        return EventFirstFlow()
    }
}
