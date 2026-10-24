import SwiftUI
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

/// CONTRACT.md §D permits an explicitly isolated fixture before LL-01 is published.
/// This has no Domain state, event inference, clock, persistence or gameplay callbacks.
struct LifeWorldScenePreviewModel {
    let age: Int
    let elapsedMs: Double
    let frozen: Bool
    let reducedMotion: Bool
    let committedOutcome: Bool
    let outcomeElapsedMs: Double
}

/// Pure sampling of an externally supplied presentation time. Frozen means retain
/// that supplied time, never replace it with zero. Gameplay owns accumulation/speed.
enum WorldPreviewMotion {
    struct Pose: Equatable { let stretch: Double; let leafAngle: Double; let arrival: Double }
    static func sample(_ model: LifeWorldScenePreviewModel) -> Pose {
        let safeTime = model.elapsedMs.isFinite ? max(0, model.elapsedMs) : 0
        let time = model.reducedMotion ? 0 : safeTime
        let wave = sin(time / 4000 * 2 * .pi)
        let outcome = model.outcomeElapsedMs.isFinite ? max(0, model.outcomeElapsedMs) : 0
        let progress = model.committedOutcome ? (model.reducedMotion ? 1 : min(1, outcome / 450)) : 0
        return Pose(stretch: 1 + 0.004 * wave, leafAngle: 1.5 * wave,
                    arrival: 1 - pow(1 - progress, 3))
    }
}

struct LifeWorldPreviewAssets {
    let background: CGImage?
    let cast: CGImage?
    static var bundled: Self {
        #if canImport(UIKit)
        Self(background: UIImage(named: "RiverCrossroads")?.cgImage, cast: UIImage(named: "StoryCast")?.cgImage)
        #else
        Self(background: NSImage(named: "RiverCrossroads")?.cgImage(forProposedRect: nil, context: nil, hints: nil),
             cast: NSImage(named: "StoryCast")?.cgImage(forProposedRect: nil, context: nil, hints: nil))
        #endif
    }
}

/// Static/externally sampled Preview only. Not the formal LifeWorldFrame adapter.
struct LifeWorldScenePreview: View {
    let model: LifeWorldScenePreviewModel
    var assets: LifeWorldPreviewAssets = .bundled
    var body: some View {
        VStack(spacing: 8) {
            Text("\(model.age)歲 · 視覺取樣示意，尚未接正式人生")
                .font(.caption).fixedSize(horizontal: false, vertical: true)
            GeometryReader { geometry in
                let pose = WorldPreviewMotion.sample(model)
                let actorWidth = min(geometry.size.width * 0.70, geometry.size.height * 0.76)
                ZStack(alignment: .bottom) {
                    if let background = assets.background {
                        Image(decorative: background, scale: 1).resizable().scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height).clipped()
                    } else { Color(red: 0.78, green: 0.85, blue: 0.71) }
                    // One quiet environmental loop; no per-leaf clock or random values.
                    HStack(spacing: -2) {
                        ForEach(0..<3) { index in
                            Ellipse().fill(Color(red: 0.31, green: 0.47, blue: 0.23))
                                .frame(width: 6, height: 13)
                                .rotationEffect(.degrees(Double(index * 24 - 24) + pose.leafAngle), anchor: .bottom)
                        }
                    }.opacity(0.75).position(x: geometry.size.width * 0.87, y: geometry.size.height * 0.12)
                    Ellipse().fill(.black.opacity(0.13)).frame(width: actorWidth * 0.45, height: 6)
                        .padding(.bottom, geometry.size.height * 0.10 + actorWidth * 0.018)
                    VStack(spacing: 0) {
                        if let portrait = portrait {
                            Image(decorative: portrait, scale: 1).resizable().scaledToFit()
                                .frame(width: actorWidth, height: actorWidth)
                                .scaleEffect(x: 1, y: pose.stretch, anchor: .bottom)
                        }
                    }.padding(.bottom, geometry.size.height * 0.10)
                    if model.committedOutcome {
                        VStack(spacing: 2) {
                            Image(systemName: "book.closed").font(.system(size: 27))
                            Text("記憶物件示意").font(.caption2)
                        }.padding(8)
                            .foregroundStyle(Color(red: 0.15, green: 0.34, blue: 0.28))
                            .background(Color(red: 0.94, green: 0.86, blue: 0.65), in: RoundedRectangle(cornerRadius: 3))
                            .scaleEffect(0.96 + 0.04 * pose.arrival, anchor: .bottom)
                            .offset(x: -geometry.size.width * 0.31, y: -geometry.size.height * 0.30)
                    }
                }.frame(width: geometry.size.width, height: geometry.size.height).clipped()
            }.accessibilityElement(children: .ignore)
                .accessibilityLabel("\(model.age)歲角色的大型虛構河畔場景預覽；不是人生結果")
                .accessibilityIdentifier("visual-fixture-scene")
            Text("只使用既有角色；沒有眼睛、手臂或尾巴骨架。")
                .font(.caption2).fixedSize(horizontal: false, vertical: true)
        }
    }
    private var portrait: CGImage? {
        guard let cast = assets.cast else { return nil }
        let index = model.age <= 12 ? 0 : model.age <= 22 ? 1 : model.age <= 40 ? 2 : model.age <= 60 ? 3 : 4
        return cast.cropping(to: CGRect(x: Double(index % 4) * Double(cast.width) / 4,
            y: Double(index / 4) * Double(cast.height) / 2,
            width: Double(cast.width) / 4, height: Double(cast.height) / 2).integral)
    }
}

#Preview("8歲：未接線示意") {
    LifeWorldScenePreview(model: .init(age: 8, elapsedMs: 1000, frozen: false, reducedMotion: false,
        committedOutcome: false, outcomeElapsedMs: 0)).frame(height: 420)
}
#Preview("13歲：已發生結果的視覺示意") {
    LifeWorldScenePreview(model: .init(age: 13, elapsedMs: 1000, frozen: true, reducedMotion: true,
        committedOutcome: true, outcomeElapsedMs: 450)).frame(height: 420)
}
