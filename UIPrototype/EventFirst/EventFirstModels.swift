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

struct OutcomeViewDTO {
    let optionID: String
    let title: String
    let immediate: [String]
    let pending: [String]
    let factors: [TraceFactorViewDTO]
    let evidenceLabel: String
}

struct ComparisonContextDTO: Identifiable {
    let id: String
    let label: String
    let conditions: String
    let cost: String
    let support: String
}

struct ComparisonViewDTO {
    let selectedChoice: String
    let fixedConditions: String
    let changedConditions: String
    let contexts: [ComparisonContextDTO]
    let limitation: String
}

struct LifeMapViewDTO {
    let stages: [String]
    let currentStage: String
    let nodes: [String]
}

enum PlayScreen { case event, outcome, reason, comparison, review }
enum DetailPage: String, CaseIterable, Identifiable {
    case profile = "人物與家庭", map = "人生地圖", history = "人生紀錄"
    var id: String { rawValue }
}

struct RecordedChoice: Identifiable {
    let id: String
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
    private let events: [EventViewDTO]
    private let outcomes: [String: OutcomeViewDTO]

    init(events: [EventViewDTO] = UIFixtures.events,
         outcomes: [String: OutcomeViewDTO] = UIFixtures.outcomes) {
        self.events = events
        self.outcomes = outcomes
    }

    var event: EventViewDTO? { events.indices.contains(index) ? events[index] : nil }
    var progressLabel: String { events.isEmpty ? "沒有待選事件" : "事件 \(index + 1) / \(events.count)" }

    func select(_ id: String) {
        guard screen == .event, let event,
              let option = event.options.first(where: { $0.id == id }), option.isAvailable else { return }
        guard let provided = outcomes[id], provided.optionID == id else {
            message = "這個選擇的後果尚未提供，請保留在這個岔路。"
            return
        }
        chosen = option
        outcome = provided
        message = nil
        history.append(.init(id: event.id, age: event.age, eventTitle: event.title,
                             choiceTitle: option.title, facts: provided.immediate))
        screen = .outcome
    }

    func showReason() { if outcome != nil { screen = .reason } }
    func showComparison() { if outcome != nil { screen = .comparison } }
    func showOutcome() { if outcome != nil { screen = .outcome } }

    func advance() {
        guard screen != .event, screen != .review, outcome != nil else { return }
        guard index + 1 < events.count else { screen = .review; return }
        index += 1
        chosen = nil
        outcome = nil
        message = nil
        screen = .event
    }

    func restart() {
        index = 0; chosen = nil; outcome = nil; message = nil; history = []; screen = .event
    }

    var comparison: ComparisonViewDTO? {
        guard let chosen, event?.id == "bridge" else { return nil }
        return UIFixtures.comparison(choice: chosen.title)
    }

    var map: LifeMapViewDTO {
        .init(stages: ["童年", "青少年", "青年", "中年", "晚年"],
              currentStage: event?.stage ?? "尚未開始", nodes: history.map { "\($0.age) · \($0.eventTitle)" })
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
    static let outcomes: [String: OutcomeViewDTO] = [
        "bridge-team": .init(optionID: "bridge-team", title: "先一起試一次。", immediate: ["你和朋友完成第一個模型，也發現一個需要重做的地方。", "這次使用了 2 格精力。"], pending: ["和這位朋友合作的故事尚未觸發後續事件。"], factors: [.init(id: "choice-team", kind: "選擇", explanation: "你選擇先做簡易作品。", evidenceLabel: "示範依據：選項 bridge-team"), .init(id: "support-team", kind: "支持", explanation: "朋友提供共享材料。", evidenceLabel: "示範依據：這個家庭情境的支持設定")], evidenceLabel: "原型敘事，尚未接真實後果紀錄"),
        "bridge-help": .init(optionID: "bridge-help", title: "找到一雙援手。", immediate: ["老師和你列出能借的工具。你還沒報名，但多了一條準備路線。", "這次使用了 1 格精力。"], pending: [], factors: [.init(id: "support-teacher", kind: "支持", explanation: "老師協助整理工具清單。", evidenceLabel: "示範依據：選項 bridge-help")], evidenceLabel: "原型敘事，尚未接真實後果紀錄"),
        "time-friends": .init(optionID: "time-friends", title: "替相處留一個位置。", immediate: ["你和朋友約好每週見面練習。", "一個放學時段已安排給共同作品。"], pending: [], factors: [], evidenceLabel: "原型敘事，尚未提供原因紀錄"),
        "time-rest": .init(optionID: "time-rest", title: "留一點，給自己。", immediate: ["你與家人重新安排這週的時間。", "作品暫時放慢，休息時間保留下來。"], pending: [], factors: [], evidenceLabel: "原型敘事，尚未提供原因紀錄")
    ]
    static func comparison(choice: String) -> ComparisonViewDTO {
        .init(selectedChoice: choice, fixedConditions: "同一個人、同年齡、同一選擇", changedConditions: "交通時間、工具取得方式與可用支持", contexts: [
            .init(id: "context-a", label: "日本 · 示範家庭 A", conditions: "工作空間在社區附近", cost: "交通占用 1 格時間", support: "可以借工具，需配合開放時間"),
            .init(id: "context-b", label: "肯亞 · 示範家庭 B", conditions: "工作空間較遠，學校有材料支援", cost: "交通占用 2 格時間", support: "可以請老師協助，需提早安排")
        ], limitation: "這是虛構家庭條件的介面示範，不代表國家平均或實際計算。只換國名而不換條件時，結果應相同。")
    }

    @MainActor static func makeFlow(arguments: [String]) -> EventFirstFlow {
        if arguments.contains("-empty-events") { return EventFirstFlow(events: []) }
        if arguments.contains("-empty-options") {
            let e = events[0]
            return EventFirstFlow(events: [.init(id: e.id, characterName: e.characterName, age: e.age, year: e.year, stage: e.stage, title: e.title, narrative: e.narrative, artworkID: e.artworkID, options: [], statuses: e.statuses)])
        }
        if arguments.contains("-missing-outcome") { return EventFirstFlow(outcomes: [:]) }
        if arguments.contains("-missing-trace") {
            var changed = outcomes
            let o = outcomes["bridge-team"]!
            changed["bridge-team"] = .init(optionID: o.optionID, title: o.title, immediate: o.immediate, pending: o.pending, factors: [], evidenceLabel: o.evidenceLabel)
            return EventFirstFlow(outcomes: changed)
        }
        return EventFirstFlow()
    }
}
