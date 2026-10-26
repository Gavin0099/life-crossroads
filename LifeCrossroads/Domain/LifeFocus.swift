import Foundation

/// Bounded fictional allocation: one benefit per interval, never per year or presentation tick.
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
    public var benefit: ResourceValues {
        switch self {
        case .balanced: .zero
        case .learning: .init(skills: 1)
        case .relationships: .init(relationships: 1)
        case .recovery: .init(health: 1)
        case .stability: .init(financial: 1)
        }
    }
    public var explanation: String {
        switch self {
        case .balanced: "下一段維持原有發展，不加重心資源。"
        case .learning: "下一段技能嘗試增加1；不取得其他方向的重心加成。"
        case .relationships: "下一段人際嘗試增加1；不取得其他方向的重心加成。"
        case .recovery: "下一段健康嘗試增加1；不取得其他方向的重心加成。"
        case .stability: "下一段財務嘗試增加1；不取得其他方向的重心加成。"
        }
    }
}

public struct LifeFocusSelection: Codable, Equatable, Sendable {
    public static let currentVersion = "life-focus-1"
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
        "這段選擇「\(focus.title)」。重心僅在時間推進時計入一次，實際健康\(actual.health)、財務\(actual.financial)、人際\(actual.relationships)、技能\(actual.skills)；上限會抵銷加成。這是遊戲設計假設，不保證機會或成功。"
    }
}
