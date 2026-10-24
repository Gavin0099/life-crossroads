import AppKit
import Foundation
import SwiftUI
import LifeDomain
import LifePresentation
import LifePersistence

// Offline adapter only. The actual Scene reads the existing compiled asset catalogue.
enum StoryPalette { static let forest = Color(red: 0.15, green: 0.36, blue: 0.29) }
enum StoryCharacter: Int {
    case child, teen, adult, middle, elder, ahe, teacher, xiaocheng
    static func protagonist(age: Int) -> Self {
        switch age { case ...12: .child; case ...22: .teen; case ...40: .adult; case ...60: .middle; default: .elder }
    }
}

@main struct RenderTraceWorld {
    @MainActor static func main() throws {
        let root = URL(fileURLWithPath: CommandLine.arguments[1])
        let output = URL(fileURLWithPath: CommandLine.arguments[2])
        let saveRoot = URL(fileURLWithPath: CommandLine.arguments[3])
        let catalog = try JSONDecoder().decode(ModelCatalog.self,
            from: Data(contentsOf: root.appendingPathComponent("LifeCrossroads/Data/Resources/catalog.json")))
        try catalog.validate()
        let initial = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        var entries: [[String: Any]] = []
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        var checks = 0

        // Expected props come from the reviewed catalogue choices and LL07_HANDOFF,
        // not a second implementation of activityEvidence or WorldMomentProjector.
        func render(_ name: String, _ session: LifeSession, expected: String?, echo: Bool = false,
                    moment: LifeWorldMomentKind? = nil, compact: Bool = false, reduced: Bool = false) throws {
            let repository = SaveRepository(fileURL: saveRoot.appendingPathComponent(name + ".json"))
            try repository.save(.single(session), catalog: catalog)
            let before = try Data(contentsOf: repository.fileURL)
            guard let restored = try repository.load(catalog: catalog) else { fatalError("Missing saved fixture") }
            precondition(restored.activeSession == session, "Actual saved session must round trip")
            let projection = try WorldMomentProjector.project(session: restored.activeSession, catalog: catalog)
            let frame = projection.presenting(moment ?? projection.moment)
            #if WORLD_TRACE_CANDIDATE
            let observed = LifeWorldScene.activityEvidence(in: frame)?.prop.rawValue
            let actualEcho = LifeWorldScene.projectEcho(in: frame) != nil
            precondition(observed == expected, "\(name): wrong physical activity prop")
            precondition(actualEcho == echo, "\(name): unearned/missing occurred echo")
            checks += 2
            #else
            let observed: String? = nil
            let actualEcho = false
            #endif
            if name == "13-rest" || name == "8-rest" {
                precondition(!frame.actors.contains { $0.personID == "teacher" && $0.role == "interacted" }, "Rest must not invent teacher interaction")
                checks += 1
            }
            if name == "13-invest" {
                precondition(frame.worldChanges.contains { $0.kind == .pendingClue && !$0.isOccurred })
                precondition(!frame.worldChanges.contains { $0.kind == .delayedConsequence && $0.isOccurred })
                checks += 2
            }
            let motion = PresentationMotionFrame(elapsedMs: 1_000, frozen: true,
                reduceMotion: reduced, phase: frame.moment, phaseToken: name, phaseElapsedMs: 480)
            let height: CGFloat = compact ? 150 : 260
            let view = LifeWorldScene(frame: frame, motion: motion).frame(width: 375, height: height)
                .environment(\.colorScheme, .light)
                .environment(\.dynamicTypeSize, compact ? .accessibility5 : .large)
            let renderer = ImageRenderer(content: view); renderer.scale = 2
            guard let image = renderer.cgImage,
                  let bytes = NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:]) else {
                fatalError("Render failed")
            }
            try bytes.write(to: output.appendingPathComponent(name + ".png"))
            let after = try Data(contentsOf: repository.fileURL)
            let originalSession = try encoder.encode(session)
            let restoredSession = try encoder.encode(restored.activeSession)
            precondition(after == before, "Drawing may not rewrite archive")
            precondition(originalSession == restoredSession)
            checks += 3
            entries.append(["file": name + ".png", "age": frame.age, "eventID": frame.eventID ?? "",
                "moment": frame.moment.rawValue, "expectedActivity": expected ?? "none",
                "observedActivity": observed ?? "none", "occurredEcho": actualEcho,
                "savedArchive": repository.fileURL.path, "saveBytesUnchangedByRender": true,
                "sizePoints": [375, Int(height)], "reducedMotion": reduced,
                "actors": frame.actors.map { ["personID": $0.personID, "role": $0.role] },
                "changes": frame.worldChanges.map { ["kind": $0.kind.rawValue, "eventID": $0.sourceEventID,
                    "choiceID": $0.sourceChoiceID, "sourceAge": $0.sourceAge,
                    "occurred": $0.isOccurred, "caption": $0.caption] as [String: Any] }])
        }

        try render("8-before", initial, expected: nil)
        for (choice, prop) in [("invest", "cardboardPractice"), ("ask", "requestNote"), ("rest", "storedBox")] {
            var life = initial; try life.choose(choice, catalog: catalog)
            try render("8-" + choice, life, expected: prop)
        }
        var teen = initial
        while teen.state.age < 13 {
            try teen.choose("rest", catalog: catalog); try teen.continueLife(catalog: catalog)
        }
        precondition(teen.state.age == 13)
        try render("13-before", teen, expected: nil)
        for (choice, prop) in [("invest", "onlineGuide"), ("offline", "paperGuide"), ("ask", "requestNote"), ("rest", "pausedWork")] {
            var life = teen; try life.choose(choice, catalog: catalog)
            try render("13-" + choice, life, expected: prop)
            if choice == "offline" {
                try render("13-paper-large-reduced", life, expected: prop, compact: true, reduced: true)
            }
            if choice == "invest" {
                try render("13-pending-large", life, expected: prop, compact: true, reduced: true)
            }
            if choice == "invest" || choice == "rest" {
                try life.continueLife(catalog: catalog)
                while life.state.age < 17 {
                    try life.choose("rest", catalog: catalog); try life.continueLife(catalog: catalog)
                }
                precondition(life.state.age == 17)
                try render("17-" + choice, life, expected: prop, echo: choice == "invest", moment: .living)
                if choice == "invest" {
                    try render("17-echo-large", life, expected: prop, echo: true, moment: .living, compact: true, reduced: true)
                }
            }
        }
        let manifest: [String: Any] = ["kind": "offline macOS production-view render; not iOS or real-device acceptance",
            "source": "actual JPN/jpn-1/Seed0 LifeSession, SaveRepository atomic save/load, WorldMomentProjector",
            "checks": checks, "images": entries]
        try JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted, .sortedKeys])
            .write(to: output.appendingPathComponent("manifest.json"))
        print("Rendered \(entries.count) saved-source frames; \(checks) integrity/guard checks. No Simulator.")
    }
}
