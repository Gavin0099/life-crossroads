import SwiftUI

// Presentation-only fixtures. These values never enter LifeDomain or a save file.
enum VisualDirection: String, CaseIterable, Identifiable {
    case paper = "A 暖紙敘事", midnight = "B 靛夜冒險"
    var id: String { rawValue }
    var background: Color { self == .paper ? Color(hex: 0xF5F0E6) : Color(hex: 0x101D30) }
    var surface: Color { self == .paper ? Color(hex: 0xFFFCF5) : Color(hex: 0x1D3049) }
    var ink: Color { self == .paper ? Color(hex: 0x243A39) : Color(hex: 0xF5F0E6) }
    var secondary: Color { self == .paper ? Color(hex: 0x526460) : Color(hex: 0xBECAD5) }
    var accent: Color { self == .paper ? Color(hex: 0x245D56) : Color(hex: 0xBDE4DA) }
    var onAccent: Color { self == .paper ? .white : Color(hex: 0x152D35) }
    var scene: String { self == .paper ? "scene-A" : "scene-B" }
}

enum VisualScreen: String, CaseIterable, Identifiable {
    case event = "岔路", feedback = "後果", compare = "環境比較", why = "為什麼"
    var id: String { rawValue }
}

struct VisualChoice: Identifiable {
    let id: String
    let title: String
    let cost: String
    let symbol: String
    let outcome: String
}

enum PreviewFixtures {
    static let choices = [
        VisualChoice(id: "team", title: "和朋友做簡易作品", cost: "2 格精力 · 使用共享材料", symbol: "person.2", outcome: "你們完成第一個模型，也發現一個需要重做的地方。"),
        VisualChoice(id: "help", title: "先找老師一起想辦法", cost: "1 格精力 · 先尋找支持", symbol: "bubble.left.and.bubble.right", outcome: "老師幫你列出可借的材料。你還沒報名，卻多了一條準備路線。")
    ]
}

extension Color {
    init(hex: UInt32) {
        self.init(.sRGB, red: Double((hex >> 16) & 255) / 255,
                  green: Double((hex >> 8) & 255) / 255,
                  blue: Double(hex & 255) / 255, opacity: 1)
    }
}
