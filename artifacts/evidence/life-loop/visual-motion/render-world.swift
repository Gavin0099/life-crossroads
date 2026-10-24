import AppKit
import Foundation
import SwiftUI
import LifeDomain
import LifePresentation

// Offline-only asset adapter. It uses the exact existing PNG, cell mapping and crop formula.
// It is not compiled into the App and does not replace StoryVisuals.swift.
enum StoryPalette { static let forest = Color(red: 0.15, green: 0.36, blue: 0.29) }
enum StoryCharacter: Int {
    case child, teen, adult, middle, elder, ahe, teacher, xiaocheng
    static func protagonist(age: Int) -> Self {
        switch age { case ...12: .child; case ...22: .teen; case ...40: .adult; case ...60: .middle; default: .elder }
    }
}
struct StoryPortrait: View {
    let character: StoryCharacter
    var body: some View {
        GeometryReader { geometry in
            Image(nsImage: RendererAssets.cast).resizable()
                .frame(width: geometry.size.width * 4, height: geometry.size.height * 2)
                .offset(x: -CGFloat(character.rawValue % 4) * geometry.size.width,
                        y: -CGFloat(character.rawValue / 4) * geometry.size.height)
        }.aspectRatio(1, contentMode: .fit).clipped()
    }
}
@MainActor enum RendererAssets {
    static let root = URL(fileURLWithPath: CommandLine.arguments[1])
    static let cast = NSImage(contentsOf: root.appendingPathComponent("LifeCrossroads/App/Assets.xcassets/StoryCast.imageset/story-cast.png"))!
}

@main struct RenderWorld {
    @MainActor static func main() throws {
        let root = RendererAssets.root
        let out = root.appendingPathComponent("artifacts/evidence/life-loop/visual-motion")
        let catalog = try JSONDecoder().decode(ModelCatalog.self,
            from: Data(contentsOf: root.appendingPathComponent("LifeCrossroads/Data/Resources/catalog.json")))
        try catalog.validate()
        var session = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        var manifest: [[String: Any]] = []

        func render(_ name: String, session: LifeSession, moment: LifeWorldMomentKind? = nil,
                    time: Double = 0, phaseTime: Double = 480, reduced: Bool = false, height: CGFloat = 290) throws {
            let projected = try WorldMomentProjector.project(session: session, catalog: catalog)
            let frame = projected.presenting(moment ?? projected.moment)
            let motion = PresentationMotionFrame(elapsedMs: time, frozen: frame.moment != .living,
                reduceMotion: reduced, phase: frame.moment,
                phaseToken: "offline-\(session.state.age)-\(session.traces.count)", phaseElapsedMs: phaseTime)
            // Image("RiverCrossroads") is resolved from a temporary app bundle by the build script.
            let view = LifeWorldScene(frame: frame, motion: motion).frame(width: 375, height: height)
                .environment(\.colorScheme, .light)
            let renderer = ImageRenderer(content: view); renderer.scale = 2
            guard let image = renderer.cgImage,
                  let data = NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:]) else {
                throw NSError(domain: "OfflineRenderer", code: 1)
            }
            try data.write(to: out.appendingPathComponent(name + ".png"))
            var entry: [String: Any] = ["file": name + ".png", "country": "JPN", "household": "jpn-1", "seed": 0,
                "age": frame.age, "eventID": frame.eventID ?? "", "moment": frame.moment.rawValue,
                "elapsedMs": time, "phaseElapsedMs": phaseTime, "reduceMotion": reduced,
                "sizePoints": [375, Int(height)], "renderScale": 2,
                "source": "Actual catalog, LifeSession.choose/continueLife and WorldMomentProjector; actual production scene with offline PNG adapter. Not iOS UI or persisted file proof."]
            entry["pastDecisionCount"] = session.traces.count
            if frame.moment == .committedOutcome, let last = session.traces.last {
                entry["choiceID"] = last.choiceID; entry["traceApplied"] = last.applied
            }
            entry["changes"] = frame.worldChanges.map { ["kind": $0.kind.rawValue, "caption": $0.caption,
                "eventID": $0.sourceEventID, "choiceID": $0.sourceChoiceID,
                "age": $0.sourceAge, "isOccurred": $0.isOccurred] as [String: Any] }
            manifest.append(entry)
        }

        for time in [0.0, 1000, 2000, 4000] {
            try render("loop-\(Int(time))ms", session: session, moment: .living, time: time)
        }
        try render("loop-control-0ms", session: session, moment: .living, time: 0)
        try render("child-event", session: session, height: 230)
        while session.state.age < 13 {
            let event = try session.event(catalog: catalog)
            let choice = try ["invest", "ask", "rest"].first { id in
                guard event.choices.contains(where: { $0.id == id }) else { return false }
                return try session.preview(choiceID: id, catalog: catalog).applied
            }!
            try session.choose(choice, catalog: catalog); try session.continueLife(catalog: catalog)
        }
        let original = session
        let controlEncoder = JSONEncoder(); controlEncoder.outputFormatting = .sortedKeys
        let originalBytes = try controlEncoder.encode(original)
        try render("teen-before", session: original, height: 230)
        for choice in ["invest", "offline", "ask", "rest"] {
            var fork = original
            try fork.choose(choice, catalog: catalog)
            try render("teen-\(choice)", session: fork)
            try render("teen-\(choice)-reduced", session: fork, reduced: true)
            if choice == "offline" { try render("teen-offline-frozen-first", session: fork, phaseTime: 0) }
        }
        let originalBytesAfter = try controlEncoder.encode(original)
        precondition(originalBytesAfter == originalBytes)
        try session.choose("offline", catalog: catalog); try session.continueLife(catalog: catalog)
        while session.state.age < 39 {
            let event = try session.event(catalog: catalog)
            let choice = try event.choices.first { try session.preview(choiceID: $0.id, catalog: catalog).applied }!
            try session.choose(choice.id, catalog: catalog); try session.continueLife(catalog: catalog)
        }
        try render("adult-community", session: session, moment: .living, time: 1000)
        try render("compact-90pt", session: session, height: 90)
        let metadata: [String: Any] = ["render": "offline macOS ImageRenderer; not Simulator", "baseDTO": "6f5e3c1",
            "sourceCheckpointReplayed": original == (try LifeSession.restore(from: originalBytes, catalog: catalog)),
            "images": manifest]
        try JSONSerialization.data(withJSONObject: metadata, options: [.prettyPrinted, .sortedKeys])
            .write(to: out.appendingPathComponent("offline-render-manifest.json"))
        print("Rendered \(manifest.count) real-Session projection frames; offline only.")
    }
}
