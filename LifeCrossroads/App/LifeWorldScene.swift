import SwiftUI
import UIKit
import LifePresentation

/// WORLD-ART-01. Rendering only: the caller owns time, events, facts and persistence.
/// `progress` moves the actor along the porch; the local timeline only adds small gestures.
struct LifeWorldScene: View {
    let state: LifeWorldViewState
    @Environment(\.accessibilityReduceMotion) private var systemReducedMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var inspected: LifeWorldChange?

    private var reduceMotion: Bool {
        #if DEBUG
        systemReducedMotion || ProcessInfo.processInfo.arguments.contains("-reduce-motion")
        #else
        systemReducedMotion
        #endif
    }
    private var animates: Bool { !reduceMotion && !state.isMotionPaused && scenePhase == .active }

    var body: some View {
        GeometryReader { geometry in
            if state.sceneID == "river-home" {
                TimelineView(.animation(minimumInterval: 1.0 / 20, paused: !animates)) { timeline in
                    let beat = animates ? timeline.date.timeIntervalSinceReferenceDate : 0
                    stage(size: geometry.size, beat: beat)
                }
            } else {
                ContentUnavailableView("場景尚未準備好", systemImage: "leaf",
                    description: Text("保留目前的人生紀錄，等待可用的場景。"))
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("lifeWorldScene")
        .sheet(item: $inspected) { change in
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Label(change.title, systemImage: symbol(change)).font(.title2.bold())
                    Text("這件物件來自 \(change.source.age) 歲留下的選擇紀錄。")
                    Text("這段經歷已留下紀錄，未來還可以有不同選擇。")
                        .font(.footnote)
                    Button("回到生活場景") { inspected = nil }.buttonStyle(.borderedProminent)
                }.padding(24).fixedSize(horizontal: false, vertical: true)
            }.presentationDetents([.medium, .large])
        }
    }

    private func stage(size: CGSize, beat: Double) -> some View {
        let floor = size.height * 0.88
        let spriteSize = min(size.width * 0.82, size.height * 0.68)
        let progress = state.progress.isFinite ? min(1, max(0, state.progress)) : 0
        return ZStack {
            Image("LifeWorldHome").resizable().scaledToFill()
                .frame(width: size.width, height: size.height).clipped().accessibilityHidden(true)
            if state.light == .evening {
                Color(red: 0.14, green: 0.18, blue: 0.36).opacity(0.28).allowsHitTesting(false)
                RadialGradient(colors: [.orange.opacity(0.24), .clear], center: .topLeading,
                    startRadius: 1, endRadius: size.height * 0.8).allowsHitTesting(false)
            }
            // A shelf of actual memories, never a forecast of prizes or future success.
            if !state.visibleChanges.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom, spacing: 5) {
                    ForEach(state.visibleChanges) { change in
                        Button { inspected = change } label: {
                            Image(systemName: symbol(change))
                                .font(.system(size: 23, weight: .medium))
                                .foregroundStyle(ink(change))
                                .frame(minWidth: 44, minHeight: 48)
                                .background(Color(red: 0.96, green: 0.88, blue: 0.68),
                                    in: UnevenRoundedRectangle(topLeadingRadius: 3, bottomLeadingRadius: 2,
                                        bottomTrailingRadius: 2, topTrailingRadius: 7))
                                .rotationEffect(.degrees(change.kind == .friendship ? -5 : 3))
                                .shadow(color: .black.opacity(0.2), radius: 2, y: 3)
                        }.buttonStyle(.plain)
                        .accessibilityLabel(change.title)
                        .accessibilityHint("查看這件物件的實際選擇來源")
                        .accessibilityIdentifier("worldObject-\(change.kind.rawValue)")
                    }
                }
                .padding(.horizontal, 7).padding(.bottom, 7)
                .background(alignment: .bottom) { Rectangle().fill(.brown).frame(height: 6) }
                .frame(height: 62)
                }
                .frame(width: size.width - 24, height: 62)
                .position(x: size.width * 0.5, y: size.height * 0.27)
            }
            ForEach(Array(state.characters.enumerated()), id: \.element.id) { index, character in
                let lead = character.actor == .mumu
                let sharedGesture = character.behavior == .interacting && (character.actor == .ahe || character.actor == .teacher)
                let width = lead || sharedGesture ? spriteSize : spriteSize * 0.82
                let x = lead ? size.width * (character.behavior == .walking ? 0.34 + progress * 0.18 : 0.39)
                    : size.width * (0.78 - Double(max(0, index - 1)) * 0.2)
                let sway = animates ? sin(beat * (character.behavior == .walking ? 7 : 2)) : 0
                ZStack(alignment: .bottom) {
                    Ellipse().fill(.black.opacity(0.17)).frame(width: width * 0.46, height: 9)
                        .offset(y: -width * 0.025)
                    actor(character)
                        .frame(width: width, height: width)
                        .overlay {
                            if lead && character.behavior == .interacting {
                                RoundedRectangle(cornerRadius: 2).fill(Color(red: 0.98, green: 0.94, blue: 0.82))
                                    .overlay { Rectangle().fill(.brown.opacity(0.45)).frame(width: width * 0.07, height: 1) }
                                    .frame(width: width * 0.13, height: width * 0.07)
                                    .rotationEffect(.degrees(-8))
                                    .position(x: width * 0.72, y: width * 0.545)
                                    .accessibilityHidden(true)
                            }
                        }
                        .offset(y: lead && (13...22).contains(character.age) ? width * 0.025 : 0)
                        .scaleEffect(x: lead ? 1 : -1, y: character.expression == .resting ? 0.94 : 1, anchor: .bottom)
                        .rotationEffect(.degrees(character.behavior == .interacting ? -2 : sway * 0.5), anchor: .bottom)
                        .offset(y: character.behavior == .walking ? -abs(sway) * 2 : -sway * 0.6)
                }
                .frame(width: width, height: width)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(name(character.actor))\(lead ? "，\(character.age)歲" : "")，\(behavior(character.behavior))\(character.expression == .resting ? "，休息中" : "")")
                .accessibilityIdentifier("worldActor-\(character.actor.rawValue)")
                .position(x: x, y: floor - width * 0.5)
                .allowsHitTesting(false)
            }
        }.frame(width: size.width, height: size.height).clipped()
    }

    @ViewBuilder private func actor(_ character: LifeWorldCharacter) -> some View {
        if character.actor == .mumu && character.age <= 22 {
            AtlasCell(asset: "LifeWorldPoses", columns: 3, rows: 2,
                column: character.behavior == .idle ? 0 : (character.behavior == .walking ? 1 : 2),
                row: character.age <= 12 ? 0 : 1)
        } else if character.behavior == .interacting && (character.actor == .ahe || character.actor == .teacher) {
            AtlasCell(asset: "LifeWorldCompanions", columns: 2, rows: 1,
                column: character.actor == .ahe ? 0 : 1, row: 0)
        } else {
            let cell = character.actor == .mumu ? (character.age <= 40 ? 2 : character.age <= 60 ? 3 : 4)
                : character.actor == .ahe ? 5 : character.actor == .teacher ? 6 : 7
            AtlasCell(asset: "StoryCast", columns: 4, rows: 2, column: cell % 4, row: cell / 4)
        }
    }

    private func symbol(_ change: LifeWorldChange) -> String {
        switch (change.kind, change.value) {
        case (.friendship, "connected"): "person.2.fill"
        case (.learning, "paper"): "book.closed.fill"
        case (.learning, "online"): "laptopcomputer"
        case (.care, "shared"), (.kitchen, "shared"): "list.clipboard.fill"
        case (.repair, "practiced"): "wrench.and.screwdriver.fill"
        case (.garden, "tending"): "leaf.fill"
        case (.nature, "observing"): "binoculars.fill"
        default: "note.text"
        }
    }
    private func ink(_ change: LifeWorldChange) -> Color {
        change.value == "seeking" || change.value == "none" || change.value == "paused" ? .brown : Color(red: 0.16, green: 0.34, blue: 0.29)
    }
    private func name(_ actor: LifeWorldActor) -> String {
        switch actor { case .mumu: "沐沐"; case .ahe: "阿禾"; case .teacher: "樹老師"; case .cheng: "小澄" }
    }
    private func behavior(_ behavior: LifeWorldBehavior) -> String {
        switch behavior { case .idle: "停留觀察"; case .walking: "沿著門廊移動"; case .interacting: "分享手邊的便條" }
    }
}

private struct AtlasCell: View {
    let asset: String
    let columns: Int
    let rows: Int
    let column: Int
    let row: Int
    @ViewBuilder var body: some View {
        if let image = croppedImage {
            Image(uiImage: image).resizable().scaledToFit().accessibilityHidden(true)
        } else {
            Color.clear.accessibilityHidden(true)
        }
    }

    private var croppedImage: UIImage? {
        guard let source = UIImage(named: asset)?.cgImage else { return nil }
        // Texture crop at render time: source files stay intact. Unlike a large offset
        // Image, this cannot expand accessibility/hit bounds beyond the visible cell.
        let seam = 497.0 / 1024
        let span = asset == "LifeWorldPoses" ? (row == 0 ? seam : 1 - seam) : 1 / Double(rows)
        let origin = asset == "LifeWorldPoses" ? (row == 0 ? 0 : seam) : Double(row) / Double(rows)
        let rect = CGRect(x: Double(column * source.width) / Double(columns),
            y: origin * Double(source.height), width: Double(source.width) / Double(columns),
            height: span * Double(source.height)).integral
        guard let cell = source.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cell)
    }
}
