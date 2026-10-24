import SwiftUI
import LifePresentation

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
                Image("RiverCrossroads").resizable().scaledToFill()
                    .frame(width: size.width, height: size.height).clipped()
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

    private func actorView(_ character: StoryCharacter, index: Int, size: CGSize) -> some View {
        let pose = LifeWorldMotion.pose(elapsedMs: motion.elapsedMs, reduceMotion: reduced, actorIndex: index)
        let protagonist = character.rawValue <= StoryCharacter.elder.rawValue
        let width = min(size.width * (protagonist ? 0.52 : 0.41), size.height * 0.83)
        let x = frame.actors.count > 1 ? size.width * (index == 0 ? 0.36 : 0.72) : size.width * 0.50
        return ZStack(alignment: .bottom) {
            Ellipse().fill(StoryPalette.forest.opacity(0.19))
                .frame(width: width * 0.48, height: max(4, width * 0.065))
            StoryPortrait(character: character)
                .frame(width: width, height: width)
                .rotationEffect(.degrees(pose.leanDegrees), anchor: .bottom)
                .offset(y: pose.vertical - 3)
        }
        .frame(width: width, height: width, alignment: .bottom)
        .position(x: x, y: size.height * 0.84 - width / 2)
    }

    @ViewBuilder private func stageFurniture(size: CGSize) -> some View {
        if frame.sceneID == "workshop" {
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
        frame.worldChanges.filter { $0.isOccurred || $0.kind == .pendingClue }
    }

    private func tokenShelf(size: CGSize) -> some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(Array(visibleTokens.prefix(4).enumerated()), id: \.offset) { _, change in
                token(change, size: size)
            }
        }
        .padding(.horizontal, 8).padding(.vertical, 5)
        .background(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 3).fill(Color(red: 0.57, green: 0.39, blue: 0.26)).frame(height: 5)
        }
        .position(x: size.width * 0.50, y: size.height * 0.92)
    }

    private func token(_ change: WorldChangeProjection, size: CGSize) -> some View {
        let currentOutcome = frame.moment == .committedOutcome && motion.phase == .committedOutcome
            && change.isOccurred && change.sourceEventID == frame.eventID && change.sourceAge == frame.age
        let progress = currentOutcome ? LifeWorldMotion.arrival(phaseElapsedMs: motion.phaseElapsedMs, reduceMotion: reduced) : 1
        return Image(systemName: tokenSymbol(change))
            .font(.system(size: min(21, size.height * 0.09), weight: .medium))
            .foregroundStyle(StoryPalette.forest)
            .frame(width: min(36, size.width * 0.11), height: min(32, size.height * 0.14))
            .background(Color(red: 1, green: 0.97, blue: 0.87), in: RoundedRectangle(cornerRadius: 5))
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(StoryPalette.forest.opacity(0.18), lineWidth: 1))
            .scaleEffect(0.94 + progress * 0.06)
            .offset(y: (1 - progress) * 4)
            .opacity(progress)
    }

    private func tokenSymbol(_ change: WorldChangeProjection) -> String {
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
        return captions.isEmpty ? "目前沒有新的後果紀錄。" : captions
    }
}
