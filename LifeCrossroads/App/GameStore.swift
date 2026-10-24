import Foundation
import SwiftUI
import LifeDomain
import LifeData
import LifePersistence
import LifePresentation
#if targetEnvironment(simulator)
import CryptoKit
#endif

@MainActor
final class GameStore: ObservableObject {
    static let firstCountries = ["TWN", "JPN", "USA", "DEU", "IND", "BRA", "VNM", "KEN"]
    @Published private(set) var journey: LifeJourney?
    @Published var showingHome = true
    @Published var viewingOriginal = false
    @Published private(set) var restoreFailed = false
    @Published private(set) var playback = LifePlayback()
    private let saves: SaveRepository
    var session: LifeSession? {
        guard !showingHome else { return nil }
        return viewingOriginal ? journey?.experiment?.original : journey?.activeSession
    }
    var experiment: BranchExperiment? { journey?.experiment }
    @Published var countryCode = "JPN"
    @Published var familyNumber = 1
    @Published var errorMessage: String?
    let catalog: ModelCatalog?
    private let launchSeed: UInt64?
    private let invalidLaunchSeed: Bool
#if targetEnvironment(simulator)
    // Only automated Simulator launches can request faults; device builds have no injection path.
    private var failingSaveAttempts: Set<Int> = []
    private var saveAttempt = 0
    var uiTestArchiveChecksum: String? {
        guard ProcessInfo.processInfo.arguments.contains("-ui-testing") else { return nil }
        guard let data = try? Data(contentsOf: saves.fileURL) else { return "missing" }
        return SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }
#endif

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("LifeCrossroads", isDirectory: true)
        let filename = arguments.contains("-ui-testing") ? "ui-journey.json" : "journey.json"
        saves = SaveRepository(fileURL: directory.appendingPathComponent(filename))
#if targetEnvironment(simulator)
        if arguments.contains("-ui-testing"), let index = arguments.firstIndex(of: "-ui-fail-save-at"), index + 1 < arguments.count {
            failingSaveAttempts = Set(arguments[index + 1].split(separator: ",").compactMap { Int($0) })
        }
#endif
        if arguments.contains("-ui-testing"), arguments.contains("-reset-save") {
            try? FileManager.default.removeItem(at: saves.fileURL)
        }
        if let index = arguments.firstIndex(of: "-life-seed") {
            launchSeed = index + 1 < arguments.count ? UInt64(arguments[index + 1]) : nil
            invalidLaunchSeed = launchSeed == nil
        } else {
            launchSeed = arguments.contains("-ui-testing") ? 42 : nil
            invalidLaunchSeed = false
        }
        do { catalog = try StatisticsRepository.bundled() }
        catch { catalog = nil; errorMessage = "離線資料無法載入：\(error)" }
        if let catalog {
            do { journey = try saves.load(catalog: catalog) }
            catch { restoreFailed = true; errorMessage = "存檔無法讀取或版本不相容，原檔仍保留。請稍後重試，或明確選擇建立新人生取代紀錄。\(error)" }
        }
        if let session = journey?.activeSession { playback.restore(session) }
    }

    var countries: [CountryProfile] {
        catalog?.countries.filter { Self.firstCountries.contains($0.code) } ?? []
    }
    var selectedHousehold: HouseholdProfile? {
        catalog?.households.first { $0.id == "\(countryCode.lowercased())-\(familyNumber)" }
    }
    var currentEvent: DecisionSkeleton? {
        guard let catalog, let session, session.phase == .choosing else { return nil }
        return try? session.event(catalog: catalog)
    }

    /// Publish only after persistence succeeds. A failed write leaves the displayed decision and original intact.
    @discardableResult
    private func commit(_ next: LifeJourney) -> Bool {
        guard let catalog else { return false }
        do {
#if targetEnvironment(simulator)
            saveAttempt += 1
            if failingSaveAttempts.remove(saveAttempt) != nil { throw CocoaError(.fileWriteNoPermission) }
#endif
            try saves.save(next, catalog: catalog)
            journey = next; restoreFailed = false
            return true
        } catch { errorMessage = "進度尚未寫入，這次操作沒有生效；原紀錄仍保留。\(error)"; return false }
    }

    var canAnimateLife: Bool {
        !showingHome && !viewingOriginal && errorMessage == nil && session?.phase == .choosing && playback.isRunning
    }
    var world: LifeWorldViewState? {
        guard let session else { return nil }
        var shownPlayback = playback
        if viewingOriginal { shownPlayback.restore(session) }
        return .init(session: session, playback: shownPlayback, event: currentEvent)
    }
    func pulseLife() { if canAnimateLife { playback.pulse() } }
    func pauseLife() { if playback.isRunning { playback.pause() } }
    func toggleLifePause() { if !showingHome && !viewingOriginal { playback.togglePause() } }
    func setLifeSpeed(_ speed: LifePlaybackSpeed) { playback.setSpeed(speed) }
    func skipToEvent() { if session?.phase == .choosing && !viewingOriginal { playback.skip() } }
    func resume() { viewingOriginal = false; showingHome = false }
    func home() { playback.pause(); showingHome = true }

    private func travel(from age: Int, to session: LifeSession) {
        do { try playback.travel(from: age, to: session.state.age) }
        catch { playback.restore(session) } // Invalid presentation interval cannot prevent a legal saved decision.
    }

    func start(replay: Bool = false) {
        guard let catalog else { return }
        guard !invalidLaunchSeed else {
            errorMessage = "開發測試種子格式錯誤，請在-life-seed後提供一個非負整數。"
            return
        }
        do {
            let next: LifeSession
            if replay, let old = journey?.activeSession {
                next = try .start(catalog: catalog, countryCode: old.state.countryCode,
                                  householdID: old.state.householdID, seed: old.state.seed)
            } else {
                let seed: UInt64 = launchSeed ?? .random(in: .min ... .max)
                next = try .start(catalog: catalog, countryCode: countryCode,
                                  householdID: "\(countryCode.lowercased())-\(familyNumber)", seed: seed)
            }
            if commit(.single(next)) {
                playback = LifePlayback(); travel(from: 0, to: next)
                viewingOriginal = false; showingHome = false
            }
        } catch { errorMessage = "暫時無法開始：\(error)" }
    }

    func replayWithNewSeed() {
        guard let catalog, let previous = journey?.activeSession else { return }
        let draw = UInt64.random(in: .min ... .max)
        let differentSeed = draw == previous.state.seed ? draw &+ 1 : draw
        do {
            let next = try LifeSession.start(catalog: catalog, countryCode: previous.state.countryCode,
                householdID: previous.state.householdID, seed: differentSeed)
            if commit(.single(next)) {
                playback = LifePlayback(); travel(from: 0, to: next)
                viewingOriginal = false; showingHome = false
            }
        } catch { errorMessage = "暫時無法重新開始：\(error)" }
    }
    func choose(_ choiceID: String) {
        guard let catalog, var active = journey, !viewingOriginal, playback.phase == .event else { return }
        do {
            try active.choose(choiceID, catalog: catalog)
            if commit(active) { playback.restore(active.activeSession) }
        }
        catch { errorMessage = "這次選擇尚無法進行：\(error)" }
    }
    func next() {
        guard let catalog, var active = journey, !viewingOriginal, playback.phase == .consequence else { return }
        let previousAge = active.activeSession.state.age
        do {
            try active.continueLife(catalog: catalog)
            if commit(active) {
                if active.activeSession.phase == .choosing { travel(from: previousAge, to: active.activeSession) }
                else { playback.restore(active.activeSession) }
            }
        }
        catch { errorMessage = "暫時無法推進：\(error)" }
    }
    @discardableResult
    func startBranch(at index: Int, choiceID: String) -> Bool {
        guard let catalog, let original = journey?.activeSession, experiment == nil else { return false }
        do {
            let next = try BranchExperiment.start(original: original, decisionIndex: index, choiceID: choiceID, catalog: catalog)
            if commit(.branch(next)) {
                playback.restore(next.alternative)
                viewingOriginal = false; showingHome = false; return true
            }
        } catch { errorMessage = "這個岔路尚無法改選：\(error)" }
        return false
    }
    func preview(_ choiceID: String) -> ConsequenceTrace? {
        guard let catalog, let session else { return nil }
        return try? session.preview(choiceID: choiceID, catalog: catalog)
    }
    func compare(choiceID: String, households: Bool = false) -> [ConsequenceTrace] {
        guard let catalog, let session else { return [] }
        do {
            let before: LifeSession
            if session.phase == .choosing { before = session }
            else if session.phase == .reflecting, session.traces.last?.choiceID == choiceID {
                before = try session.beforeDecision(at: session.traces.count - 1, catalog: catalog)
            } else { throw ModelError.invalid("comparison requires the chosen action") }
            if households { return try before.compareHouseholds(choiceID: choiceID, catalog: catalog) }
            return try before.compare(choiceID: choiceID, countryCodes: Self.firstCountries, catalog: catalog)
        } catch { errorMessage = "暫時無法比較：\(error)"; return [] }
    }
    func alternatives(for trace: ConsequenceTrace) -> [AvailableAction] {
        guard let catalog, let session else { return [] }
        do {
            let before = session.phase == .choosing ? session : try session.beforeDecision(at: session.traces.count - 1, catalog: catalog)
            var state = before.state
            state.countryCode = trace.countryCode; state.householdID = trace.householdID
            state.remainingMaterials = trace.budgetBefore.materials
            return try EnvironmentComparisonEngine.preview(state: state, eventID: trace.eventID, choiceID: trace.choiceID, catalog: catalog).availableAlternatives
        } catch { return [] }
    }
    func name(_ country: String) -> String { catalog?.countries.first { $0.code == country }?.name ?? country }
    func title(_ event: String) -> String { catalog?.decisions.first { $0.id == event }?.title ?? event }
    func choiceTitle(_ trace: ConsequenceTrace) -> String {
        trace.choiceTitle
    }
}
