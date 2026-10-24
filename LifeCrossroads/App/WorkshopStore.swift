import Foundation
import SwiftUI
import LifeDomain
import LifeData

/// Application adapter. Costs, time jumps, conditions and results all come from LifeSession.
@MainActor final class WorkshopStore: ObservableObject {
    @Published private(set) var session: LifeSession?
    @Published private(set) var error: String?
    let catalog: ModelCatalog?
    private let saveURL: URL
    private let seed: UInt64
    init() {
        let args=ProcessInfo.processInfo.arguments
        seed=42
        let directory=FileManager.default.urls(for:.applicationSupportDirectory,in:.userDomainMask)[0]
            .appendingPathComponent("WorkshopSlice",isDirectory:true)
        saveURL=directory.appendingPathComponent(args.contains("-ui-testing") ? "test-session.json":"session.json")
        if args.contains("-ui-testing") && args.contains("-workshop-reset") { try? FileManager.default.removeItem(at:saveURL) }
        do { catalog=try WorkshopCatalog.bundled() }
        catch { catalog=nil;self.error="工坊內容無法讀取，尚未建立新的生活。\(error)" }
        guard let catalog else { return }
        do {
            if args.contains("-ui-testing") && args.contains("-workshop-corrupt") {
                try FileManager.default.createDirectory(at:directory,withIntermediateDirectories:true)
                try Data("invalid saved world".utf8).write(to:saveURL,options:.atomic)
            }
            if FileManager.default.fileExists(atPath:saveURL.path) {
                session=try LifeSession.restore(from:Data(contentsOf:saveURL),catalog:catalog)
            } else { restart() }
        } catch { self.error="原紀錄無法讀取或內容版本不同，原檔仍保留。你可以稍後重試，或明確選擇重新開始。\(error)" }
    }
    var event: DecisionSkeleton? {
        guard let catalog,let session,session.phase == .choosing else { return nil }
        return try? session.event(catalog:catalog)
    }
    var fact: StoryFact? { session?.state.story.fact("workshop") }
    var origin: ConsequenceTrace? { session?.traces.first { $0.age == 13 } }
    var branch: StoryBranchEvaluation? {
        guard let event,let session else { return nil }
        return StoryBranchEngine.project(event:event,state:session.state).evaluation
    }
    var opportunityOrigin: ConsequenceTrace? {
        guard let branch else { return nil }
        return session?.traces.first { $0.eventID == branch.sourceEventID && $0.choiceID == branch.sourceChoiceID && $0.age == branch.sourceAge }
    }
    func recordedFamiliarity(_ id: String,through age: Int) -> Int {
        session?.traces.filter { $0.age <= age }.flatMap(\.changedRelationships).last { $0.personID == id }?.familiarity ?? 0
    }
    var art: WorkshopArt {
        switch fact?.value { case "prototype": .team;case "plan": .help;default: .idle }
    }
    var object: String {
        if session?.state.decisions.last?.choiceID == "borrow" { return "借用清單已和老師核對；工具能否借到仍待確認" }
        return switch fact?.value {
        case "prototype": "桌上留下試作紀錄；紙橋仍可調整"
        case "plan": "桌上留下借用清單；工具尚待詢問"
        default: "桌上只有紙條與小摺角，還沒開始試做"
        }
    }
    var proof: String {
        guard let session,let data=try? JSONEncoder().encode(session) else { return "{}" }
        return String(data:data,encoding:.utf8) ?? "{}"
    }
    func preview(_ choice: String) -> ConsequenceTrace? {
        guard let session,let catalog else { return nil }
        return try? session.preview(choiceID:choice,catalog:catalog)
    }
    func familiarity(_ id: String) -> Int { session?.state.story.relationships.first { $0.personID == id }?.familiarity ?? 0 }
    private func publish(_ value: LifeSession) {
        do {
            guard let catalog else { return }
            try value.validate(catalog:catalog)
            let data=try JSONEncoder().encode(value)
            try FileManager.default.createDirectory(at:saveURL.deletingLastPathComponent(),withIntermediateDirectories:true)
            try data.write(to:saveURL,options:.atomic)
            session=value;error=nil
        } catch { self.error="這次變動尚未保存，所以尚未套用；原紀錄仍保留。\(error)" }
    }
    func choose(_ id: String) {
        guard var next=session,let catalog else { return }
        do { try next.choose(id,catalog:catalog);publish(next) }
        catch { self.error="這個行動目前無法進行。\(error)" }
    }
    func advance() {
        guard var next=session,let catalog else { return }
        do { try next.continueLife(catalog:catalog);publish(next) }
        catch { self.error="時間尚未推進，原狀態仍保留。\(error)" }
    }
    func restart() {
        guard let catalog else { return }
        do { publish(try .start(catalog:catalog,countryCode:"JPN",householdID:"jpn-1",seed:seed)) }
        catch { self.error="暫時無法開始工坊生活。\(error)" }
    }
}
