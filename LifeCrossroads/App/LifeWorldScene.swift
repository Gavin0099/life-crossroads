import SwiftUI
import LifePresentation

/// A shared fictional place. The scene has no timer, randomness, simulation or persistence access.
/// Movement is choreography supplied by Gameplay; remembered objects come only from committed facts.
struct LifeWorldScene: View {
    let state: LifeWorldViewState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Group {
            if state.sceneID == "river-home" {
                landscape
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(sceneDescription)
                    .accessibilityValue(memoryDescription)
                    .accessibilityIdentifier("lifeWorldScene")
            } else {
                Text("這個生活場景尚未提供。")
                    .font(.subheadline)
                    .accessibilityIdentifier("lifeWorldUnknownScene")
            }
        }
        // An interruption cancels interpolation instead of leaving a repeat animation running.
        .transaction { transaction in
            if reduceMotion || state.isMotionPaused { transaction.animation = nil }
        }
    }

    private var landscape: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack {
                sky
                Circle().fill(state.light == .day ? Color(red: 1, green: 0.87, blue: 0.55) : Color(red: 1, green: 0.93, blue: 0.77))
                    .frame(width: min(40, size.height * 0.17), height: min(40, size.height * 0.17))
                    .position(x: size.width * 0.76, y: size.height * 0.17)
                cloud.frame(width: 65, height: 26).scaleEffect(min(1, size.height / 220))
                    .position(x: size.width * 0.29, y: size.height * 0.15)
                cloud.frame(width: 46, height: 19).scaleEffect(min(1, size.height / 220))
                    .position(x: size.width * 0.90, y: size.height * 0.29)
                hill(size: size, foreground: false)
                hill(size: size, foreground: true)
                river(size: size)
                nearBank(size: size)
                WorldTree().frame(width: size.width * 0.31, height: size.height * 0.55)
                    .position(x: size.width * 0.12, y: size.height * 0.46)
                riverHouse.frame(width: size.width * 0.31, height: size.height * 0.36)
                    .position(x: size.width * 0.78, y: size.height * 0.45)
                path(size: size)
                bench.frame(width: 62, height: 32).scaleEffect(min(1, size.height / 220))
                    .position(x: size.width * 0.19, y: size.height * 0.76)
                ForEach(Array(state.characters.enumerated()), id: \.element.id) { index, character in
                    worldCharacter(character, index: index, size: size)
                }
                if !state.visibleChanges.isEmpty {
                    rememberedObjects
                        .scaleEffect(min(1, size.height / 250))
                        .frame(maxWidth: size.width * 0.78)
                        .position(x: size.width * 0.59, y: size.height * 0.92)
                }
                // Evening is a presentation cue. It is unrelated to a country's real time or weather.
                Color(red: 0.25, green: 0.20, blue: 0.32)
                    .opacity(state.light == .evening ? 0.12 : 0)
                    .allowsHitTesting(false)
            }
            .animation(motionAnimation, value: state.progress)
            .animation(motionAnimation, value: state.light)
        }
    }

    private var motionAnimation: Animation? {
        reduceMotion || state.isMotionPaused ? nil : .linear(duration: 0.22)
    }

    private var sky: some View {
        LinearGradient(colors: state.light == .day
            ? [Color(red: 0.72, green: 0.88, blue: 0.91), Color(red: 0.96, green: 0.95, blue: 0.80)]
            : [Color(red: 0.65, green: 0.68, blue: 0.83), Color(red: 1, green: 0.81, blue: 0.64)],
            startPoint: .top, endPoint: .bottom)
    }

    private var cloud: some View {
        ZStack {
            Capsule().fill(.white.opacity(0.65)).frame(height: 12).offset(y: 5)
            Circle().fill(.white.opacity(0.65)).frame(width: 25).offset(x: -9, y: -2)
            Circle().fill(.white.opacity(0.65)).frame(width: 19).offset(x: 9, y: 1)
        }
    }

    private func hill(size: CGSize, foreground: Bool) -> some View {
        Path { path in
            let top = size.height * (foreground ? 0.49 : 0.39)
            path.move(to: CGPoint(x: 0, y: top))
            path.addCurve(to: CGPoint(x: size.width, y: top - 3),
                          control1: CGPoint(x: size.width * 0.24, y: top - (foreground ? 52 : 40)),
                          control2: CGPoint(x: size.width * 0.60, y: top + 25))
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            path.closeSubpath()
        }.fill(foreground ? Color(red: 0.48, green: 0.65, blue: 0.46) : Color(red: 0.62, green: 0.75, blue: 0.63))
    }

    private func river(size: CGSize) -> some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 0, y: size.height * 0.58))
                path.addCurve(to: CGPoint(x: size.width, y: size.height * 0.48),
                              control1: CGPoint(x: size.width * 0.38, y: size.height * 0.65),
                              control2: CGPoint(x: size.width * 0.58, y: size.height * 0.41))
                path.addLine(to: CGPoint(x: size.width, y: size.height * 0.77))
                path.addLine(to: CGPoint(x: 0, y: size.height * 0.86))
                path.closeSubpath()
            }.fill(Color(red: 0.43, green: 0.72, blue: 0.75))
            ForEach(0..<5) { index in
                Capsule().fill(.white.opacity(0.33))
                    .frame(width: CGFloat(19 + index * 6), height: 2)
                    .position(x: size.width * (0.12 + Double(index) * 0.19),
                              y: size.height * (0.66 - Double(index % 3) * 0.033))
            }
        }
    }

    private func nearBank(size: CGSize) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: size.height * 0.77))
            path.addCurve(to: CGPoint(x: size.width, y: size.height * 0.67),
                          control1: CGPoint(x: size.width * 0.3, y: size.height * 0.62),
                          control2: CGPoint(x: size.width * 0.7, y: size.height * 0.82))
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            path.closeSubpath()
        }.fill(Color(red: 0.71, green: 0.77, blue: 0.49))
    }

    private func path(size: CGSize) -> some View {
        Path { path in
            path.move(to: CGPoint(x: -8, y: size.height * 0.86))
            path.addCurve(to: CGPoint(x: size.width + 8, y: size.height * 0.82),
                          control1: CGPoint(x: size.width * 0.35, y: size.height * 0.76),
                          control2: CGPoint(x: size.width * 0.65, y: size.height * 0.90))
        }.stroke(Color(red: 0.88, green: 0.81, blue: 0.59), style: StrokeStyle(lineWidth: 29, lineCap: .round))
    }

    private var riverHouse: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 6).fill(Color(red: 0.93, green: 0.84, blue: 0.65))
                    .frame(width: size.width * 0.83, height: size.height * 0.66)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: size.height * 0.39))
                    path.addLine(to: CGPoint(x: size.width * 0.5, y: 0))
                    path.addLine(to: CGPoint(x: size.width, y: size.height * 0.39))
                    path.closeSubpath()
                }.fill(Color(red: 0.65, green: 0.39, blue: 0.29))
                HStack(alignment: .bottom, spacing: 10) {
                    RoundedRectangle(cornerRadius: 10).fill(StoryPalette.forest.opacity(0.75))
                        .frame(width: size.width * 0.24, height: size.height * 0.42)
                    RoundedRectangle(cornerRadius: 4).fill(Color(red: 0.72, green: 0.85, blue: 0.81))
                        .frame(width: size.width * 0.24, height: size.height * 0.23)
                        .overlay { Rectangle().fill(.white.opacity(0.65)).frame(width: 2) }
                        .padding(.bottom, 12)
                }.padding(.bottom, 2)
            }
        }
    }

    private var bench: some View {
        ZStack(alignment: .bottom) {
            HStack { Rectangle().frame(width: 5); Spacer(); Rectangle().frame(width: 5) }
                .frame(width: 47, height: 18)
            RoundedRectangle(cornerRadius: 3).frame(height: 7).offset(y: -13)
            RoundedRectangle(cornerRadius: 3).frame(height: 9).offset(y: -25)
        }.foregroundStyle(Color(red: 0.53, green: 0.37, blue: 0.26))
    }

    private func worldCharacter(_ character: LifeWorldCharacter, index: Int, size: CGSize) -> some View {
        let protagonist = character.actor == .mumu
        // A pause changes the actor's reported behavior to idle. Keep its last travel pose/position.
        let walking = character.behavior == .walking || (protagonist && state.phase == .living)
        let progress = reduceMotion ? 0.5 : min(1, max(0, state.progress))
        let stride = reduceMotion || !walking ? 0 : sin(progress * .pi * 16)
        let horizontal = protagonist ? (walking ? 0.27 + progress * 0.22 : 0.49) : 0.72 - Double(index - 1) * 0.13
        let scale = min(1, size.height / 270)
        return ZStack(alignment: .bottom) {
            Ellipse().fill(StoryPalette.forest.opacity(0.19)).frame(width: 54 * scale, height: 9 * scale)
            if protagonist {
                WorldOtter(age: character.age, expression: character.expression,
                           behavior: character.behavior, stride: stride)
                    .frame(width: 100, height: 145)
                    .scaleEffect(scale, anchor: .bottom)
                    .frame(width: 100 * scale, height: 145 * scale, alignment: .bottom)
                    .offset(y: (-2 - abs(stride) * 2) * scale)
            } else {
                StoryPortrait(character: portrait(character.actor))
                    .frame(width: 96 * scale, height: 96 * scale)
                    .rotationEffect(.degrees(character.behavior == .interacting ? -3 : 0))
                    .offset(y: -3 * scale)
            }
        }
        .frame(width: 104 * scale, height: 148 * scale, alignment: .bottom)
        .position(x: size.width * horizontal, y: size.height * 0.85 - 74 * scale)
    }

    private func portrait(_ actor: LifeWorldActor) -> StoryCharacter {
        switch actor {
        case .mumu: .protagonist(age: state.age)
        case .ahe: .ahe
        case .teacher: .teacher
        case .cheng: .xiaocheng
        }
    }

    private var rememberedObjects: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(state.visibleChanges) { change in
                Image(systemName: objectSymbol(change))
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(StoryPalette.forest)
                    .frame(width: 26, height: 27)
                    .background(Color(red: 0.99, green: 0.96, blue: 0.84), in: RoundedRectangle(cornerRadius: 5))
                    .rotationEffect(.degrees(change.kind == .learning ? -6 : 0))
            }
        }
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(red: 0.61, green: 0.43, blue: 0.29))
                .frame(height: 6)
        }
    }

    private var memoryDescription: String {
        guard !state.visibleChanges.isEmpty else { return "尚無故事物件；場景不預告結果。" }
        return state.visibleChanges.map { change in
            var description = "\(change.source.age)歲留下的記號：\(change.title)"
#if targetEnvironment(simulator)
            if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
                description += "；\(change.kind.rawValue)=\(change.value)，\(change.source.eventID)/\(change.source.choiceID)"
            }
#endif
            return description
        }.joined(separator: "。")
    }

    /// Objects are memory tokens, never an assertion that a project succeeded or support was received.
    private func objectSymbol(_ change: LifeWorldChange) -> String {
        switch (change.kind, change.value) {
        case (.friendship, "connected"): "envelope"
        case (.learning, "online"): "laptopcomputer"
        case (.learning, "paper"): "book.closed"
        case (.care, "shared"): "calendar"
        case (.repair, "practiced"): "wrench.and.screwdriver"
        case (.kitchen, "shared"): "list.bullet.clipboard"
        case (.garden, "tending"): "leaf"
        case (.nature, "observing"): "binoculars"
        default: "note.text"
        }
    }

    private var sceneDescription: String {
        let people = state.characters.map { character in
            let name: String = switch character.actor {
            case .mumu: "沐沐"
            case .ahe: "阿禾"
            case .teacher: "樹老師"
            case .cheng: "小澄"
            }
            let action: String = switch character.behavior {
            case .idle: character.expression == .resting ? "安靜歇一會兒" : "停在河岸"
            case .walking: "沿著河岸走動"
            case .interacting: "在河岸留下一次互動"
            }
            return "\(name)\(action)"
        }.joined(separator: "；")
        let light = state.light == .day ? "白天" : "傍晚"
        return "\(state.age)歲的想像河畔，\(light)。\(people)。\(state.isMotionPaused ? "畫面已停住。" : "生活片段播放中。")這是共用想像舞台，不是各國實景。"
    }
}

private struct WorldTree: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.50, green: 0.37, blue: 0.26))
                    .frame(width: geometry.size.width * 0.19, height: geometry.size.height * 0.68)
                Ellipse().fill(Color(red: 0.26, green: 0.49, blue: 0.34))
                    .frame(height: geometry.size.height * 0.70).offset(y: -geometry.size.height * 0.3)
                Ellipse().fill(Color(red: 0.38, green: 0.58, blue: 0.36))
                    .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.48)
                    .offset(x: -10, y: -geometry.size.height * 0.50)
            }
        }
    }
}

/// Original SwiftUI layers retain the existing otter's teal clothing and amber scarf.
/// Limbs, tail and face are independently placed; their poses have no outcome semantics.
private struct WorldOtter: View {
    let age: Int
    let expression: LifeWorldExpression
    let behavior: LifeWorldBehavior
    let stride: Double
    private let fur = Color(red: 0.52, green: 0.34, blue: 0.22)
    private let cream = Color(red: 0.95, green: 0.85, blue: 0.65)

    var body: some View {
        ZStack {
            Ellipse().fill(fur.opacity(0.90))
                .frame(width: 60, height: 17)
                .rotationEffect(.degrees(-18 + stride * 4))
                .offset(x: -24, y: 48)
            foot.offset(x: -12, y: 59).rotationEffect(.degrees(stride * 13), anchor: .top)
            foot.offset(x: 12, y: 59).rotationEffect(.degrees(-stride * 13), anchor: .top)
            RoundedRectangle(cornerRadius: 23)
                .fill(StoryPalette.forest).frame(width: 47, height: 61).offset(y: 25)
            RoundedRectangle(cornerRadius: 5)
                .fill(cream).frame(width: 12, height: 40).offset(y: 25)
            arm.rotationEffect(.degrees(-8 - stride * 18), anchor: .top)
                .offset(x: -27, y: 29)
            arm.rotationEffect(.degrees(behavior == .interacting ? -53 : 10 + stride * 18), anchor: .top)
                .offset(x: 27, y: behavior == .interacting ? 17 : 29)
            Circle().fill(StoryPalette.amber).frame(width: 7).offset(x: 7, y: 28)
            head.offset(y: -24)
            Capsule().fill(StoryPalette.amber).frame(width: 42, height: 9).offset(y: 0)
            RoundedRectangle(cornerRadius: 3).fill(StoryPalette.amber)
                .frame(width: 10, height: 24).rotationEffect(.degrees(-22)).offset(x: 13, y: 11)
            if age > 60 {
                HStack(spacing: 2) {
                    Circle().stroke(StoryPalette.forest, lineWidth: 1.3)
                    Circle().stroke(StoryPalette.forest, lineWidth: 1.3)
                }.frame(width: 36, height: 17).offset(y: -28)
            }
        }
        .scaleEffect(age <= 12 ? 0.9 : 1, anchor: .bottom)
    }

    private var foot: some View {
        Capsule().fill(fur).frame(width: 22, height: 12)
    }
    private var arm: some View {
        Capsule().fill(fur).frame(width: 13, height: 32)
            .overlay(alignment: .top) {
                Capsule().fill(StoryPalette.forest).frame(width: 14, height: 21)
            }
    }
    private var head: some View {
        ZStack {
            Circle().fill(fur).frame(width: 19).offset(x: -28, y: -15)
            Circle().fill(fur).frame(width: 19).offset(x: 28, y: -15)
            Ellipse().fill(fur).frame(width: 65, height: 56)
            Ellipse().fill(cream).frame(width: 49, height: 32).offset(y: 10)
            eye.offset(x: -12, y: -4)
            eye.offset(x: 12, y: -4)
            Ellipse().fill(Color(red: 0.20, green: 0.16, blue: 0.13))
                .frame(width: 11, height: 8).offset(y: 8)
            Path { path in
                path.move(to: CGPoint(x: 46, y: 88))
                path.addQuadCurve(to: CGPoint(x: 54, y: 88), control: CGPoint(x: 50, y: 92))
            }.stroke(fur, style: StrokeStyle(lineWidth: 1.3, lineCap: .round))
                .frame(width: 100, height: 145)
        }
    }
    @ViewBuilder private var eye: some View {
        if expression == .resting {
            Capsule().fill(Color(red: 0.20, green: 0.16, blue: 0.13)).frame(width: 9, height: 2)
        } else {
            Ellipse().fill(Color(red: 0.20, green: 0.16, blue: 0.13))
                .frame(width: expression == .attentive ? 7 : 6, height: 9)
                .overlay(alignment: .topTrailing) { Circle().fill(.white).frame(width: 2).padding(1) }
        }
    }
}
