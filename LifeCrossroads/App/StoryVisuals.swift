import SwiftUI

enum StoryPalette {
    static let forest = Color(red: 0.15, green: 0.36, blue: 0.29)
    static let amber = Color(red: 0.87, green: 0.63, blue: 0.27)
    static let page = Color(.systemGroupedBackground)
}

/// The same fictional cast accompanies every country. Species never encode nationality.
enum StoryCharacter: Int {
    case child, teen, adult, middle, elder, ahe, teacher, xiaocheng

    static func protagonist(age: Int) -> Self {
        switch age {
        case ...12: .child
        case ...22: .teen
        case ...40: .adult
        case ...60: .middle
        default: .elder
        }
    }

    static func companion(named name: String) -> Self? {
        if name.contains("阿禾") { return .ahe }
        if name.contains("樹老師") { return .teacher }
        if name.contains("小澄") { return .xiaocheng }
        return nil
    }
}

/// Crops a cell at display time; the generated PNG and its transparent alpha remain intact.
struct StoryPortrait: View {
    let character: StoryCharacter

    var body: some View {
        GeometryReader { geometry in
            Image("StoryCast")
                .resizable()
                .frame(width: geometry.size.width * 4, height: geometry.size.height * 2)
                .offset(x: -CGFloat(character.rawValue % 4) * geometry.size.width,
                        y: -CGFloat(character.rawValue / 4) * geometry.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipped()
        .accessibilityHidden(true)
    }
}

/// An allegorical stage, with cast chosen from the engine's actual current person or trace.
struct StoryScene: View {
    let age: Int
    let person: String
    let chapter: String
    let sceneID: String

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Image("RiverCrossroads")
                    .resizable().scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height).clipped()
                LinearGradient(colors: [.black.opacity(0.12), .clear, .black.opacity(0.23)],
                               startPoint: .top, endPoint: .bottom)
                HStack(alignment: .bottom, spacing: 8) {
                    StoryPortrait(character: .protagonist(age: age))
                        .frame(width: min(165, geometry.size.width * 0.46))
                    if let companion = StoryCharacter.companion(named: person) {
                        StoryPortrait(character: companion)
                            .frame(width: min(142, geometry.size.width * 0.39))
                    }
                }.padding(.bottom, 5)
            }
            .overlay(alignment: .topLeading) {
                Text(chapter).font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(StoryPalette.forest, in: Capsule())
                    .padding(14)
            }
        }
        .frame(height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(age)歲的沐沐\(StoryCharacter.companion(named: person) == nil ? "獨自站在" : "與\(person)站在")河畔故事場景")
        .accessibilityIdentifier(sceneID)
    }
}

struct StoryEyebrow: View {
    let title: String
    let icon: String
    var body: some View {
        Label(title, systemImage: icon)
            .font(.caption.weight(.bold))
            .foregroundStyle(.secondary)
    }
}

struct BudgetToken: View {
    let title: String
    let value: Int
    let icon: String
    var body: some View {
        Label("\(title) \(value)", systemImage: icon)
            .font(.subheadline.weight(.semibold)).monospacedDigit()
            .padding(.horizontal, 10).padding(.vertical, 8)
            .background(StoryPalette.amber.opacity(0.14), in: RoundedRectangle(cornerRadius: 10))
            .accessibilityLabel("\(title)還有\(value)格")
    }
}
