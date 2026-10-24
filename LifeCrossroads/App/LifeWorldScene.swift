import SwiftUI
import LifePresentation

/// Read-only renderer of Gameplay's LL-01 contract (6f5e3c1).
/// Caller must project the published, successfully saved Session, never a choice preview.
struct LifeWorldScene: View {
    let frame: LifeWorldFrame
    let motion: PresentationMotionFrame
    var onInspectionChanged: (Bool) -> Void = { _ in }
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var inspectedChange: WorldChangeProjection?

    private let forest = Color(red: 0.15, green: 0.36, blue: 0.29)
    private var sample: LifeWorldScenePreviewModel {
        .init(age: frame.age, elapsedMs: motion.elapsedMs, frozen: motion.frozen,
              reducedMotion: motion.reduceMotion, committedOutcome: false, outcomeElapsedMs: 0)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("沐沐 · \(frame.age)歲").font(.headline)
                Spacer(minLength: 4)
                Text(momentLabel).font(.caption)
            }.fixedSize(horizontal: false, vertical: true)
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                    LifeWorldScenePreview(model: sample, showsNotes: false,
                        canvasIdentifier: "life-world-canvas",
                        canvasDescription: "\(frame.age)歲的沐沐。\(actorDescriptions)。共用虛構舞台。")
                    if !typeSize.isAccessibilitySize {
                        companion(size: geometry.size)
                        HStack(alignment: .bottom, spacing: 8) {
                            ForEach(Array(visibleProps.enumerated()), id: \.offset) { _, change in
                                Image(systemName: Self.symbol(for: change))
                                    .font(.system(size: 25, weight: .medium))
                                    .foregroundStyle(forest)
                                    .padding(9).background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                                    .scaleEffect(propScale(change), anchor: .bottom)
                            }
                        }.padding(12).accessibilityHidden(true)
                    }
                }.frame(width: geometry.size.width, height: geometry.size.height).clipped()
            }.frame(minHeight: 280)
            Text(frame.sceneID == "workshop" ? "創作工坊 · 共用虛構舞台" : "河畔社區 · 共用虛構舞台")
                .font(.caption).foregroundStyle(.secondary)
            ForEach(Array(frame.worldChanges.enumerated()), id: \.offset) { index, change in
                Button { inspectedChange = change; onInspectionChanged(true) } label: {
                    HStack(alignment: .top, spacing: 9) {
                        Image(systemName: Self.symbol(for: change)).font(.system(size: 18))
                            .frame(width: 24).accessibilityHidden(true)
                        Text(change.caption).fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                        Image(systemName: "info.circle").font(.system(size: 18)).accessibilityHidden(true)
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.vertical, 6)
                }.buttonStyle(.plain).foregroundStyle(forest)
                    .accessibilityIdentifier("world-change-\(index)")
                    .accessibilityLabel("\(change.isOccurred ? "已記錄" : "尚未發生")。\(change.caption)。查看來源")
            }
            ForEach(Array(frame.environmentGaps.enumerated()), id: \.offset) { _, gap in
                Label(gap, systemImage: "questionmark.circle").font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }.sheet(isPresented: Binding(get: { inspectedChange != nil }, set: { if !$0 { inspectedChange = nil } }),
            onDismiss: { onInspectionChanged(false) }) {
            if let change = inspectedChange {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(change.isOccurred ? "世界留下的紀錄" : "留下線索，尚未發生").font(.title2.bold())
                        Text(change.caption).fixedSize(horizontal: false, vertical: true)
                        Text("來源：\(change.sourceAge)歲的選擇紀錄。")
                        Button("回到生活場景") { inspectedChange = nil }.buttonStyle(.borderedProminent)
                    }.padding(20)
                }
            }
        }
    }

    private var momentLabel: String {
        switch frame.moment {
        case .living: "生活繼續"
        case .eventPaused: "遇到一個岔路"
        case .committedOutcome: "選擇已留下紀錄"
        case .ending: "回顧這段人生"
        }
    }
    private var actorDescriptions: String {
        frame.actors.filter { $0.role != "protagonist" }.map {
            "\(WorldMomentProjector.personName($0.personID))\($0.role == "interacted" ? "有互動紀錄" : "在場邀請")"
        }.joined(separator: "，")
    }
    private var visibleProps: [WorldChangeProjection] {
        Array(frame.worldChanges.filter { $0.isOccurred && ($0.kind == .memory || $0.kind == .relationship) }.suffix(2))
    }
    static func symbol(for change: WorldChangeProjection) -> String {
        if !change.isOccurred { return "ellipsis.bubble" }
        if change.kind == .memory && change.sourceEventID == "teen-project" {
            switch change.sourceChoiceID {
            case "offline": return "doc.text"
            case "invest": return "rectangle.and.pencil.and.ellipsis"
            case "ask": return "questionmark.bubble"
            case "rest": return "moon"
            default: break
            }
        }
        switch change.kind {
        case .resourceChange: return "slider.horizontal.3"
        case .relationship: return "person.2"
        case .memory: return "bookmark"
        case .occurredChance: return "sparkle"
        case .pendingClue: return "ellipsis.bubble"
        case .delayedConsequence: return "arrow.turn.down.right"
        }
    }
    private func propScale(_ change: WorldChangeProjection) -> Double {
        guard frame.moment == .committedOutcome, motion.phase == .committedOutcome,
              change.isOccurred, change.sourceEventID == frame.eventID,
              change.sourceAge == frame.age else { return 1 }
        let phase = LifeWorldScenePreviewModel(age: frame.age, elapsedMs: motion.elapsedMs,
            frozen: motion.frozen, reducedMotion: motion.reduceMotion,
            committedOutcome: true, outcomeElapsedMs: motion.phaseElapsedMs)
        return 0.96 + 0.04 * WorldPreviewMotion.sample(phase).arrival
    }
    @ViewBuilder private func companion(size: CGSize) -> some View {
        if let actor = frame.actors.first(where: { ["ahe", "teacher", "cheng"].contains($0.personID) && $0.role != "protagonist" }),
           let cast = LifeWorldPreviewAssets.bundled.cast {
            let index = actor.personID == "ahe" ? 5 : actor.personID == "teacher" ? 6 : 7
            if let cell = cast.cropping(to: CGRect(x: Double(index % 4) * Double(cast.width) / 4,
                y: Double(index / 4) * Double(cast.height) / 2,
                width: Double(cast.width) / 4, height: Double(cast.height) / 2).integral) {
                Image(decorative: cell, scale: 1).resizable().scaledToFit()
                    .frame(width: size.width * 0.30, height: size.width * 0.30)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.trailing, 8).padding(.bottom, size.height * 0.10)
                    .accessibilityHidden(true)
            }
        }
    }
}
