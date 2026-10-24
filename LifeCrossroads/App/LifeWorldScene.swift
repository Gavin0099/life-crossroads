import SwiftUI
import LifePresentation
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

/// Render-only world. Gameplay supplies a committed projection and its single accumulated clock.
/// Existing atlas characters remain whole PNGs: no invented eyes, hands, head or tail rig.
struct LifeWorldScene: View {
    let frame: LifeWorldFrame
    let motion: PresentationMotionFrame
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @Environment(\.dynamicTypeSize) private var typeSize

    private var reduced: Bool { systemReduceMotion || motion.reduceMotion }

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack {
                if let background = croppedBackground(size: size) {
                    Image(decorative: background, scale: 1).resizable()
                        .frame(width: size.width, height: size.height)
                } else { StoryPalette.forest.opacity(0.25) }
                LinearGradient(colors: [.clear, Color(red: 0.97, green: 0.92, blue: 0.78).opacity(0.20)],
                               startPoint: .top, endPoint: .bottom)
                if !typeSize.isAccessibilitySize {
                    riverRipples(size: size)
                    stageFurniture(size: size)
                }
                ForEach(Array(frame.actors.enumerated()), id: \.offset) { index, actor in
                    if let character = portrait(for: actor.personID) {
                        actorView(character, index: index, size: size)
                    }
                }
                activitySurface(size: size)
                if !typeSize.isAccessibilitySize && !visibleTokens.isEmpty {
                    tokenShelf(size: size)
                }
            }
            .frame(width: size.width, height: size.height)
            .clipped()
        }
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(spokenScene)
        .accessibilityValue(spokenChanges)
        .accessibilityIdentifier("lifeWorldScene")
        // No implicit/repeating animation can continue after Gameplay freezes its supplied time.
        .transaction { $0.animation = nil }
    }

    enum ActivityProp: String {
        case cardboardPractice, storedBox, requestNote, onlineGuide, paperGuide, pausedWork

        var title: String {
            switch self {
            case .cardboardPractice: "紙箱練習"
            case .storedBox: "收好紙箱"
            case .requestNote: "求助紀錄"
            case .onlineGuide: "線上圖解"
            case .paperGuide: "紙本練習"
            case .pausedWork: "保留時間"
            }
        }
    }

    struct PropEvidence: Equatable {
        let prop: ActivityProp
        let source: WorldChangeProjection
    }

    /// A drawing interpretation of an existing fact, never a new story state. In particular,
    /// the eight-year activity has no persistent StoryFact and only appears in that outcome.
    static func activityEvidence(in frame: LifeWorldFrame) -> PropEvidence? {
        if frame.age == 8, frame.moment == .committedOutcome, frame.eventID == "child-interest",
           let source = frame.worldChanges.first(where: {
               $0.isOccurred && $0.kind == .resourceChange && $0.sourceEventID == "child-interest" && $0.sourceAge == 8
           }) {
            let prop: ActivityProp?
            switch source.sourceChoiceID {
            case "invest": prop = .cardboardPractice
            case "ask": prop = .requestNote
            case "rest": prop = .storedBox
            default: prop = nil
            }
            return prop.map { .init(prop: $0, source: source) }
        }
        guard frame.age >= 13, let source = frame.worldChanges.last(where: {
            $0.isOccurred && $0.kind == .memory && $0.sourceEventID == "teen-project" && $0.sourceAge == 13
        }) else { return nil }
        let prop: ActivityProp?
        switch source.sourceChoiceID {
        case "invest": prop = .onlineGuide
        case "offline": prop = .paperGuide
        case "ask": prop = .requestNote
        case "rest": prop = .pausedWork
        default: prop = nil
        }
        return prop.map { .init(prop: $0, source: source) }
    }

    static func projectEcho(in frame: LifeWorldFrame) -> WorldChangeProjection? {
        guard frame.age == 17 else { return nil }
        return frame.worldChanges.first {
            $0.isOccurred && $0.kind == .delayedConsequence && $0.sourceEventID == "teen-project" && $0.sourceAge == 13
        }
    }

    @ViewBuilder private func activitySurface(size: CGSize) -> some View {
        if let evidence = Self.activityEvidence(in: frame) {
            let width = min(size.width * 0.36, size.height * 0.66)
            let height = width * 0.72
            ZStack {
                Ellipse().fill(.black.opacity(0.15)).frame(width: width * 0.96, height: height * 0.12)
                    .position(x: width / 2, y: height * 0.94)
                HStack {
                    RoundedRectangle(cornerRadius: 1).frame(width: width * 0.07)
                    Spacer()
                    RoundedRectangle(cornerRadius: 1).frame(width: width * 0.07)
                }
                .foregroundStyle(Color(red: 0.48, green: 0.31, blue: 0.19))
                .frame(width: width * 0.76, height: height * 0.46)
                .position(x: width / 2, y: height * 0.70)
                RoundedRectangle(cornerRadius: 3)
                    .fill(LinearGradient(colors: [Color(red: 0.75, green: 0.54, blue: 0.32), Color(red: 0.48, green: 0.31, blue: 0.19)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: width, height: max(5, height * 0.11))
                    .position(x: width / 2, y: height * 0.44)
                activityDrawing(evidence.prop)
                    .frame(width: width * 0.76, height: height * 0.43)
                    .position(x: width / 2, y: height * 0.22)
                HStack(spacing: 3) {
                    Text("\(evidence.source.sourceAge)歲")
                    Text(evidence.prop.title).fontWeight(.semibold)
                }
                .font(.system(size: min(11, max(9, size.height * 0.043))))
                .foregroundStyle(StoryPalette.forest)
                .padding(.horizontal, 7).padding(.vertical, 3)
                .background(Color(red: 0.99, green: 0.95, blue: 0.82), in: RoundedRectangle(cornerRadius: 3))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(.brown.opacity(0.30), lineWidth: 0.7))
                .position(x: width / 2, y: height * 0.64)
            }
            .frame(width: width, height: height)
            .position(x: size.width * 0.76, y: size.height * 0.96 - height / 2)

            if let echo = Self.projectEcho(in: frame) {
                storyNote(title: "17歲的呼應", symbol: "arrow.turn.down.right", sealed: false)
                    .frame(width: min(100, size.width * 0.28), height: min(45, size.height * 0.26))
                    .position(x: size.width * (typeSize.isAccessibilitySize ? 0.16 : 0.84),
                              y: size.height * (typeSize.isAccessibilitySize ? 0.81 : 0.14))
                    .accessibilityLabel(echo.caption)
            } else if frame.worldChanges.contains(where: {
                $0.kind == .pendingClue && !$0.isOccurred && $0.sourceEventID == "teen-project" && $0.sourceAge == 13
            }) {
                storyNote(title: "線索・尚未發生", symbol: "clock", sealed: true)
                    .frame(width: min(100, size.width * 0.28), height: min(45, size.height * 0.26))
                    .position(x: size.width * (typeSize.isAccessibilitySize ? 0.16 : 0.84),
                              y: size.height * (typeSize.isAccessibilitySize ? 0.81 : 0.14))
            }
        }
    }

    private func storyNote(title: String, symbol: String, sealed: Bool) -> some View {
        VStack(spacing: 3) {
            Image(systemName: symbol).font(.system(size: 16, weight: .medium))
            Text(title).font(.system(size: 9, weight: .semibold))
        }
        .foregroundStyle(StoryPalette.forest)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.99, green: 0.95, blue: 0.82), in: RoundedRectangle(cornerRadius: 3))
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(.brown.opacity(0.45), style: StrokeStyle(lineWidth: 0.8, dash: sealed ? [3, 2] : [])))
        .rotationEffect(.degrees(-4))
        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 2)
    }

    @ViewBuilder private func activityDrawing(_ prop: ActivityProp) -> some View {
        switch prop {
        case .cardboardPractice, .storedBox:
            GeometryReader { g in
                let w = g.size.width, h = g.size.height
                ZStack {
                    Path { p in p.move(to: .init(x: w * 0.1, y: h * 0.35)); for point in [
                        .init(x: w * 0.65, y: h * 0.18), .init(x: w * 0.94, y: h * 0.42),
                        CGPoint(x: w * 0.40, y: h * 0.59)] { p.addLine(to: point) }; p.closeSubpath() }
                        .fill(Color(red: 0.84, green: 0.67, blue: 0.43))
                    Path { p in p.move(to: .init(x: w * 0.10, y: h * 0.35)); for point in [
                        .init(x: w * 0.40, y: h * 0.59), .init(x: w * 0.40, y: h * 0.96), CGPoint(x: w * 0.10, y: h * 0.72)] { p.addLine(to: point) }; p.closeSubpath() }
                        .fill(Color(red: 0.64, green: 0.45, blue: 0.27))
                    Path { p in p.move(to: .init(x: w * 0.40, y: h * 0.59)); for point in [
                        .init(x: w * 0.94, y: h * 0.42), .init(x: w * 0.94, y: h * 0.80), CGPoint(x: w * 0.40, y: h * 0.96)] { p.addLine(to: point) }; p.closeSubpath() }
                        .fill(Color(red: 0.76, green: 0.55, blue: 0.33))
                    if prop == .cardboardPractice {
                        RoundedRectangle(cornerRadius: 1).fill(Color(red: 0.99, green: 0.96, blue: 0.84))
                            .frame(width: w * 0.36, height: h * 0.43).rotationEffect(.degrees(-14))
                            .position(x: w * 0.50, y: h * 0.25)
                        Path { p in p.move(to: .init(x: w * 0.41, y: h * 0.17)); p.addLine(to: .init(x: w * 0.57, y: h * 0.33)) }
                            .stroke(StoryPalette.forest.opacity(0.6), lineWidth: 1)
                    } else {
                        Image(systemName: "leaf").font(.system(size: max(13, h * 0.40)))
                            .foregroundStyle(StoryPalette.forest).position(x: w * 0.54, y: h * 0.43)
                    }
                }
            }
        case .onlineGuide, .paperGuide:
            GeometryReader { g in
                let w = g.size.width, h = g.size.height
                ZStack {
                    RoundedRectangle(cornerRadius: 3).fill(Color(red: 0.54, green: 0.34, blue: 0.22))
                        .frame(width: w * 0.92, height: h * 0.80).offset(y: h * 0.08)
                    HStack(spacing: 1) {
                        Rectangle().fill(Color(red: 1, green: 0.98, blue: 0.88))
                        Rectangle().fill(Color(red: 0.94, green: 0.88, blue: 0.72))
                    }.frame(width: w * 0.86, height: h * 0.76)
                    Path { p in
                        p.move(to: .init(x: w * 0.17, y: h * 0.58)); p.addLine(to: .init(x: w * 0.28, y: h * 0.27))
                        p.addLine(to: .init(x: w * 0.40, y: h * 0.58)); p.addLine(to: .init(x: w * 0.17, y: h * 0.58))
                        p.move(to: .init(x: w * 0.56, y: h * 0.31)); p.addLine(to: .init(x: w * 0.82, y: h * 0.31))
                        p.move(to: .init(x: w * 0.56, y: h * 0.48)); p.addLine(to: .init(x: w * 0.77, y: h * 0.48))
                    }.stroke(StoryPalette.forest.opacity(0.65), lineWidth: 1.2)
                    if prop == .onlineGuide {
                        Image(systemName: "wifi").font(.system(size: max(12, h * 0.35), weight: .semibold))
                            .foregroundStyle(StoryPalette.forest).position(x: w * 0.80, y: h * 0.72)
                    } else {
                        Rectangle().fill(Color(red: 0.68, green: 0.31, blue: 0.22))
                            .frame(width: 4, height: h * 0.80).position(x: w * 0.50, y: h * 0.55)
                    }
                }.rotationEffect(.degrees(-7))
            }
        case .requestNote:
            storyNote(title: "正在找起點", symbol: "questionmark", sealed: false)
                .rotationEffect(.degrees(9)).padding(.horizontal, 10)
        case .pausedWork:
            ZStack {
                RoundedRectangle(cornerRadius: 3).fill(Color(red: 0.79, green: 0.64, blue: 0.42))
                Rectangle().fill(Color(red: 0.93, green: 0.85, blue: 0.66)).frame(height: 5)
                Image(systemName: "leaf").font(.system(size: 24)).foregroundStyle(StoryPalette.forest)
            }.padding(.horizontal, 9).padding(.vertical, 3).rotationEffect(.degrees(-5))
        }
    }

    private func croppedBackground(size: CGSize) -> CGImage? {
        guard let image = WorldSceneBitmaps.background, size.width > 0, size.height > 0 else { return nil }
        let scale = max(size.width / Double(image.width), size.height / Double(image.height))
        let width = size.width / scale, height = size.height / scale
        return image.cropping(to: CGRect(x: (Double(image.width) - width) / 2,
            y: (Double(image.height) - height) / 2, width: width, height: height).integral)
    }
    private func croppedPortrait(_ character: StoryCharacter) -> CGImage? {
        guard let image = WorldSceneBitmaps.cast else { return nil }
        let index = character.rawValue
        return image.cropping(to: CGRect(x: Double(index % 4) * Double(image.width) / 4,
            y: Double(index / 4) * Double(image.height) / 2,
            width: Double(image.width) / 4, height: Double(image.height) / 2).integral)
    }

    private func actorView(_ character: StoryCharacter, index: Int, size: CGSize) -> some View {
        let pose = LifeWorldMotion.pose(elapsedMs: motion.elapsedMs, reduceMotion: reduced, actorIndex: index)
        let protagonist = character.rawValue <= StoryCharacter.elder.rawValue
        let heroFraction = frame.actors.count > 1 ? 0.60 : 0.70
        let width = min(size.width * (protagonist ? heroFraction : 0.36), size.height * 0.83)
        let x = frame.actors.count > 1 ? size.width * (index == 0 ? 0.36 : 0.72) : size.width * 0.50
        return ZStack(alignment: .bottom) {
            Ellipse().fill(StoryPalette.forest.opacity(0.19))
                .frame(width: width * 0.48, height: max(4, width * 0.065))
            if let portrait = croppedPortrait(character) {
                Image(decorative: portrait, scale: 1).resizable().scaledToFit()
                    .frame(width: width, height: width)
                    .rotationEffect(.degrees(pose.leanDegrees), anchor: .bottom)
                    .offset(y: pose.vertical - 3)
            }
        }
        .frame(width: width, height: width, alignment: .bottom)
        .position(x: x, y: size.height * 0.84 - width / 2)
    }

    @ViewBuilder private func stageFurniture(size: CGSize) -> some View {
        if frame.sceneID == "workshop" && Self.activityEvidence(in: frame) == nil {
            // A shared fictional work surface; its existence is not a household equipment claim.
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.63, green: 0.43, blue: 0.29)).frame(height: 10)
                HStack { Rectangle().frame(width: 6); Spacer(); Rectangle().frame(width: 6) }
                    .foregroundStyle(Color(red: 0.50, green: 0.34, blue: 0.23))
                    .padding(.horizontal, 14).frame(height: size.height * 0.13)
            }
            .frame(width: size.width * 0.30)
            .position(x: size.width * 0.82, y: size.height * 0.77)
        } else if frame.sceneID == "community" {
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 2).frame(height: 7)
                RoundedRectangle(cornerRadius: 2).frame(height: 6)
                HStack { Rectangle().frame(width: 5); Spacer(); Rectangle().frame(width: 5) }
                    .padding(.horizontal, 9).frame(height: size.height * 0.07)
            }
            .foregroundStyle(Color(red: 0.55, green: 0.37, blue: 0.25))
            .frame(width: size.width * 0.22)
            .position(x: size.width * 0.15, y: size.height * 0.70)
        }
    }

    private func riverRipples(size: CGSize) -> some View {
        let pose = LifeWorldMotion.pose(elapsedMs: motion.elapsedMs, reduceMotion: reduced)
        return ZStack {
            ForEach(0..<3) { index in
                Capsule().fill(.white.opacity(0.48))
                    .frame(width: CGFloat(14 + index * 6), height: 1.5)
                    .offset(x: pose.rippleHorizontal * (index.isMultiple(of: 2) ? 1 : -1))
                    .position(x: size.width * (0.83 + Double(index % 2) * 0.06),
                              y: size.height * (0.42 + Double(index) * 0.065))
            }
        }
    }

    private var visibleTokens: [WorldChangeProjection] {
        // A pending token is a note about an unresolved clue, never an achieved outcome.
        frame.worldChanges.enumerated().filter { $0.element.isOccurred || $0.element.kind == .pendingClue }
            .sorted {
                let first = tokenPriority($0.element), second = tokenPriority($1.element)
                return first == second ? $0.offset < $1.offset : first < second
            }.map(\.element)
    }

    private func tokenPriority(_ change: WorldChangeProjection) -> Int {
        let current = change.sourceEventID == frame.eventID && change.sourceAge == frame.age
        switch change.kind {
        case .memory: return current ? 0 : 3
        case .relationship: return current ? 1 : 4
        case .occurredChance: return 2
        case .delayedConsequence: return 4
        case .pendingClue: return 5
        case .resourceChange: return 6
        }
    }

    private func tokenShelf(size: CGSize) -> some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(Array(visibleTokens.prefix(4).enumerated()), id: \.offset) { _, change in
                token(change, size: size)
            }
        }
        .padding(.horizontal, 6).padding(.vertical, 4)
        .background(Color(red: 0.99, green: 0.95, blue: 0.82), in: RoundedRectangle(cornerRadius: 3))
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(.brown.opacity(0.35), lineWidth: 0.7))
        .rotationEffect(.degrees(-2))
        .position(x: size.width * 0.19, y: size.height * 0.92)
    }

    private func token(_ change: WorldChangeProjection, size: CGSize) -> some View {
        let currentOutcome = frame.moment == .committedOutcome && motion.phase == .committedOutcome
            && change.isOccurred && change.sourceEventID == frame.eventID && change.sourceAge == frame.age
        let progress = currentOutcome ? LifeWorldMotion.arrival(phaseElapsedMs: motion.phaseElapsedMs, reduceMotion: reduced) : 1
        return Image(systemName: Self.tokenSymbol(change))
            .font(.system(size: min(16, size.height * 0.07), weight: .medium))
            .foregroundStyle(StoryPalette.forest)
            .frame(width: min(22, size.width * 0.065), height: min(24, size.height * 0.09))
            .scaleEffect(0.94 + progress * 0.06)
            .offset(y: (1 - progress) * 4)
            // The fact has already committed: even an immediate pause at frame zero must leave
            // a readable token. Motion only emphasizes its arrival; it never gates the evidence.
            .opacity(LifeWorldMotion.committedTokenOpacity(arrival: progress))
    }

    static func tokenSymbol(_ change: WorldChangeProjection) -> String {
        if !change.isOccurred { return "clock.badge.questionmark" }
        switch change.kind {
        case .relationship: return "bubble.left.and.bubble.right"
        case .pendingClue: return "clock.badge.questionmark"
        case .occurredChance: return "sparkle"
        case .resourceChange: return "list.bullet.rectangle"
        case .delayedConsequence: return "arrow.turn.down.right"
        case .memory:
            // These are selected activity tokens. Neither a laptop nor notebook asserts completion,
            // access ownership, a reward or a future invitation. Unknown memories stay neutral.
            if change.sourceEventID == "teen-project" {
                switch change.sourceChoiceID {
                case "invest": return "laptopcomputer"
                case "offline": return "book.closed"
                case "ask": return "questionmark.bubble"
                case "rest": return "leaf"
                default: break
                }
            }
            return "note.text"
        }
    }

    private func portrait(for personID: String) -> StoryCharacter? {
        switch personID {
        case "mumu": .protagonist(age: frame.age)
        case "ahe", "阿禾": .ahe
        case "teacher", "樹老師": .teacher
        case "cheng", "小澄": .xiaocheng
        default: nil // Do not invent a new person when no reviewed portrait exists.
        }
    }

    private var spokenScene: String {
        let people = frame.actors.map { WorldMomentProjector.personName($0.personID) }.joined(separator: "、")
        let place = frame.sceneID == "workshop" ? "想像工作室" : "想像河畔"
        return "\(frame.age)歲，\(people)在\(place)。跨國共用的虛構舞台，不是當地實景。"
    }

    private var spokenChanges: String {
        let captions = frame.worldChanges.map(\.caption).joined(separator: "。")
        let activity = Self.activityEvidence(in: frame).map { "。場景物件：\($0.source.sourceAge)歲的\($0.prop.title)。" } ?? ""
        return (captions.isEmpty ? "目前沒有新的後果紀錄。" : captions) + activity
    }
}

/// Cache unchanged whole-atlas bitmaps; crop texels before layout so accessibility
/// never receives the bounds of a 4×2 atlas or overflowing scaled-to-fill image.
@MainActor private enum WorldSceneBitmaps {
    static let background = load("RiverCrossroads")
    static let cast = load("StoryCast")
    private static func load(_ name: String) -> CGImage? {
        #if canImport(UIKit)
        UIImage(named: name)?.cgImage
        #else
        NSImage(named: name)?.cgImage(forProposedRect: nil, context: nil, hints: nil)
        #endif
    }
}
