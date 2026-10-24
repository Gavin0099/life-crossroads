import AppKit
import SwiftUI
import Foundation

@main @MainActor struct RenderVisualPreview {
    static func main() throws {
        let root = URL(fileURLWithPath: CommandLine.arguments[1])
        let output = root.appendingPathComponent("artifacts/evidence/life-loop-visual/frames")
        try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
        func load(_ path: String) throws -> CGImage {
            guard let image = NSImage(contentsOf: root.appendingPathComponent(path)),
                  let bitmap = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                throw NSError(domain: "MissingPreviewAsset", code: 1)
            }
            return bitmap
        }
        let assets = try LifeWorldPreviewAssets(
            background: load("LifeCrossroads/App/Assets.xcassets/RiverCrossroads.imageset/river-crossroads.png"),
            cast: load("LifeCrossroads/App/Assets.xcassets/StoryCast.imageset/story-cast.png"))
        func model(_ t: Double, frozen: Bool = false, reduced: Bool = false,
                   committed: Bool = false, outcome: Double = 0, age: Int = 8) -> LifeWorldScenePreviewModel {
            .init(age: age, elapsedMs: t, frozen: frozen, reducedMotion: reduced,
                  committedOutcome: committed, outcomeElapsedMs: outcome)
        }
        var checks: [[String: Any]] = []
        func check(_ name: String, _ passed: Bool) throws {
            checks.append(["name": name, "passed": passed])
            guard passed else { throw NSError(domain: name, code: 2) }
        }
        let zero = WorldPreviewMotion.sample(model(0))
        let seam = WorldPreviewMotion.sample(model(4000))
        try check("4000ms loop closes at the initial pose", abs(zero.stretch - seam.stretch) < 1e-12 && abs(zero.leafAngle - seam.leafAngle) < 1e-12)
        let beforePause = WorldPreviewMotion.sample(model(1250))
        try check("freeze retains supplied phase instead of resetting", beforePause == WorldPreviewMotion.sample(model(1250, frozen: true)))
        let afterResume = WorldPreviewMotion.sample(model(1251))
        try check("next supplied millisecond resumes continuously", abs(afterResume.stretch - beforePause.stretch) < 0.0001)
        try check("reduced-motion loop uses complete static first frame", zero == WorldPreviewMotion.sample(model(1250, reduced: true)))
        try check("reduced committed outcome uses final frame", WorldPreviewMotion.sample(model(1250, reduced: true, committed: true)).arrival == 1)
        try check("uncommitted input cannot animate an outcome", WorldPreviewMotion.sample(model(1250, committed: false, outcome: 450)).arrival == 0)
        try check("invalid time produces finite static values", WorldPreviewMotion.sample(model(.nan)).stretch == 1 && WorldPreviewMotion.sample(model(-100)).leafAngle == 0)
        var frames: [[String: Any]] = []
        let samples: [(String, LifeWorldScenePreviewModel)] = [
            ("loop-0", model(0)), ("loop-25", model(1000)), ("loop-50", model(2000)), ("loop-100", model(4000)),
            ("teen-outcome-start", model(1000, committed: true, outcome: 0, age: 13)),
            ("teen-outcome-final", model(1000, committed: true, outcome: 450, age: 13)),
            ("teen-reduced-final", model(1000, reduced: true, committed: true, age: 13)),
            ("adult", model(1000, age: 39))]
        for (name, input) in samples {
            let renderer = ImageRenderer(content: LifeWorldScenePreview(model: input, assets: assets)
                .frame(width: 390, height: 440).padding(12).background(Color.white))
            renderer.scale = 2
            guard let cg = renderer.cgImage,
                  let png = NSBitmapImageRep(cgImage: cg).representation(using: .png, properties: [:]) else {
                throw NSError(domain: "PreviewRenderFailed", code: 3)
            }
            let target = output.appendingPathComponent(name + ".png")
            try png.write(to: target)
            frames.append(["name": name, "age": input.age, "elapsedMs": input.elapsedMs,
                           "reducedMotion": input.reducedMotion, "committedFixture": input.committedOutcome,
                           "width": cg.width, "height": cg.height])
        }
        let evidence: [String: Any] = ["checks": checks, "frames": frames,
            "scope": "Pure preview sampling and macOS SwiftUI ImageRenderer; not iOS Simulator, formal life data, or Gameplay clock validation",
            "productionDTO": "NOT CONNECTED — waiting for LL-01 published contract",
            "externalCodeCopied": false, "newRasterAssets": false]
        let data = try JSONSerialization.data(withJSONObject: evidence, options: [.prettyPrinted, .sortedKeys])
        try data.write(to: output.deletingLastPathComponent().appendingPathComponent("preview-validation.json"))
        print("7 pure sampling checks passed; 8 SwiftUI preview frames exported. Not integrated gameplay evidence.")
    }
}
