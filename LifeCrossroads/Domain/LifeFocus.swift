import Foundation

/// Fictional allocation: completed intervals create story readiness, never per-tick resource points.
public enum LifeFocus: String, Codable, CaseIterable, Sendable {
    case balanced, learning, relationships, recovery, stability
    public var title: String {
        switch self {
        case .balanced: "順其自然"
        case .learning: "留時間學習"
        case .relationships: "維繫關係"
        case .recovery: "照顧自己"
        case .stability: "穩定財務"
        }
    }
    public static func available(at age: Int) -> [Self] {
        allCases.filter { $0 != .stability || age >= 23 }
    }
    /// Direction creates story readiness; resource changes belong to actual decisions.
    public var benefit: ResourceValues { .zero }
    public var explanation: String {
        switch self {
        case .balanced: "先照現在的步調生活，遇到事情再調整。"
        case .learning: "留下一點練習時間；以後遇到分享草稿的活動，會有可帶去的準備。"
        case .relationships: "記得問候與聯絡；日後遇到邀約，可以接續這段用心。"
        case .recovery: "練習為休息留位置；日後重新參與活動時，可以提出自己的步調。"
        case .stability: "整理花費與預備金；遇到新的支出時，可以帶著準備一起商量。"
        }
    }
}

/// Completed intervals, not promises or a substitute for the focus-selection replay log.
public struct LifeFocusMemory: Codable, Equatable, Sendable {
    public static let currentVersion = "focus-story-1"
    public let version: String
    public let focus: LifeFocus
    public let fromAge: Int
    public let toAge: Int
    public var caption: String { "\(fromAge)～\(toAge)歲，你為「\(focus.title)」留了一段時間。" }
    init(focus: LifeFocus, fromAge: Int, toAge: Int) {
        version = Self.currentVersion; self.focus = focus; self.fromAge = fromAge; self.toAge = toAge
    }
}

public struct FocusContinuation: Codable, Equatable, Sendable {
    public var focus: LifeFocus
    public var minimumIntervals: Int
    public var unlockedChoiceID: String
    public var activeTitle: String
    public var firstTitle: String
}

enum LifeFocusStoryRules {
    static func project(_ base: StoryProjection, state: LifeState) -> StoryProjection {
        guard let route = base.event.focusContinuation else { return base }
        let memories = state.focusHistory.filter { $0.focus == route.focus }
        let ready = memories.count >= route.minimumIntervals
        let source = memories.last
        var event = base.event
        event.title = ready ? route.activeTitle : route.firstTitle
        event.storyVariantID = event.id + (ready ? "-focus-prepared" : "-focus-first-step")
        if !ready { event.choices.removeAll { $0.id == route.unlockedChoiceID } }
        let origin = source.map { $0.caption } ?? "你還沒有為這個方向留出一段固定時間。"
        event.storyQuestion = origin + event.storyQuestion
        return .init(event: event, evaluation: .init(ruleID: "story.focus.\(route.focus.rawValue)",
            sourceEventID: "", sourceChoiceID: nil, sourceAge: source?.fromAge,
            resourceChecks: [], variantID: event.storyVariantID!, offeredChoiceIDs: event.choices.map(\.id),
            explanation: origin + "這個活動讀取已完成的生活安排；有\(route.minimumIntervals)段準備才開放延續選項。邀請不是已參與，也不保證結果。",
            assumptionID: "life-focus-story", focusSource: source))
    }
}

public struct LifeFocusSelection: Codable, Equatable, Sendable {
    public static let currentVersion = "life-focus-2"
    public let version: String
    public let decisionIndex: Int
    public let phase: SessionPhase
    public let focus: LifeFocus
    init(index: Int, phase: SessionPhase, focus: LifeFocus) {
        version = Self.currentVersion; decisionIndex = index; self.phase = phase; self.focus = focus
    }
}

public struct LifeFocusEffect: Codable, Equatable, Sendable {
    public let version: String
    public let focus: LifeFocus
    public let requested: ResourceValues
    public let actual: ResourceValues
    public var explanation: String {
        "這段選擇「\(focus.title)」。完成的生活安排可以影響後續機會與可選行動，沒有直接加分；實際事件才改變資源。這是遊戲設計假設，不保證抽到機會或成功。"
    }
}
