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
    @Published private(set) var playback = WorldPlayback()
    @Published var worldPreviewEnabled = !ProcessInfo.processInfo.arguments.contains("-legacy-event-first")
    private var now: Double { ProcessInfo.processInfo.systemUptime }
    @Published private(set) var projectedWorld: LifeWorldFrame?
    var world: LifeWorldFrame? {
        guard session != nil, !viewingOriginal else { return nil }
        return projectedWorld?.presenting(playback.phase)
    }
    var canAnimateWorld: Bool {
        worldPreviewEnabled && session != nil && !viewingOriginal && errorMessage == nil && playback.isRunning
    }
    func setWorldSceneVisible(_ value: Bool) { playback.setOffscreen(!value, now: now) }
    func suspendWorld(_ value: Bool) { playback.setSuspended(value, now: now) }
    func pauseWorld(_ value: Bool) { playback.setPaused(value, now: now) }
    func speedWorld(_ value: WorldPlayback.Speed) { playback.setSpeed(value, now: now) }
    func pulseWorld() {
        guard canAnimateWorld else { return }
        if let ticket = playback.tick(now: now) { advanceWorld(ticket) }
    }
    func skipWorld() {
        guard worldPreviewEnabled, session != nil, !viewingOriginal else { return }
        if let ticket = playback.skip(now: now) { advanceWorld(ticket) }
    }
    private func bindWorld(restoring: Bool = false, reset: Bool = false) {
        if let session, let catalog {
            // Project once from the saved/restored session, never from presentation ticks.
            projectedWorld = try? WorldMomentProjector.project(session: session, catalog: catalog)
            playback.bind(session, now: now, restoring: restoring, reset: reset)
#if VISUAL_LOOP_CAPTURE && targetEnvironment(simulator)
            if ProcessInfo.processInfo.arguments.contains("-visual-loop-capture") {
                playback.setPaused(true, now: now)
            }
#endif
        }
    }
    private func advanceWorld(_ ticket: WorldAdvanceTicket) {
        guard let session, !viewingOriginal, playback.accepts(ticket, session: session),
              let catalog, var active = journey else { return }
        do {
            try active.continueLife(catalog: catalog)
            if commit(active) { bindWorld() }
            else { playback.commitFailed(now: now) }
        } catch { playback.commitFailed(now: now); errorMessage = "暫時無法推進：\(error)" }
    }
    static let firstCountries = ["TWN", "JPN", "USA", "DEU", "IND", "BRA", "VNM", "KEN"]
    @Published private(set) var journey: LifeJourney?
    @Published var showingHome = true
    @Published var viewingOriginal = false
    @Published private(set) var restoreFailed = false
    private let saves: SaveRepository
    var session: LifeSession? {
        guard !showingHome else { return nil }
        return viewingOriginal ? journey?.comparisonOriginal : journey?.activeSession
    }
    var experiment: BranchExperiment? { journey?.experiment }
    var parallelExperiment: ParallelLifeExperiment? { journey?.parallelExperiment }
    var comparisonOriginal: LifeSession? { journey?.comparisonOriginal }
    @Published var showBirthReveal = false
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
#if targetEnvironment(simulator)
            // Each automated fresh-life launch has explicit presentation inputs too.
            // A normal relaunch without -reset-save preserves the player's preference.
            UserDefaults.standard.removeObject(forKey: "reducedLifeMotion")
#endif
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
#if VISUAL_LOOP_CAPTURE && targetEnvironment(simulator)
            // Capture builds only: load a real, replay-validated archive into the isolated UI-test file.
            // Normal CI, devices and production builds do not compile this fixture ingress.
            if arguments.contains("-ui-testing"), arguments.contains("-visual-loop-capture"),
               let path = ProcessInfo.processInfo.environment["LIFE_VISUAL_ARCHIVE_PATH"] {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let fixture = try JSONDecoder().decode(JourneySave.self, from: data)
                    try fixture.validate(catalog: catalog)
                    try saves.save(fixture.journey, catalog: catalog)
                } catch { errorMessage = "視覺取證存檔無效：\(error)"; return }
            }
#endif
            do { journey = try saves.load(catalog: catalog) }
            catch { restoreFailed = true; errorMessage = "存檔無法讀取或版本不相容，原檔仍保留。若為舊版人生，本版創作機會規則已不同，可在原版本續玩；或明確選擇建立新人生取代紀錄。\(error)" }
        }
    }

    var countries: [CountryProfile] {
        catalog?.countries.filter { Self.firstCountries.contains($0.code) } ?? []
    }
    var selectedHousehold: HouseholdProfile? {
        catalog?.households.first { $0.id == "\(countryCode.lowercased())-\(familyNumber)" }
    }
    @discardableResult
    func setFocus(_ focus: LifeFocus) -> Bool {
        guard let catalog, var next = journey, !viewingOriginal else { return false }
        do {
            try next.chooseFocus(focus, catalog: catalog)
            // Do not bind/reset the presentation clock or reselect an event.
            return commit(next)
        } catch { errorMessage = "這次重心沒有變更：\(error)"; return false }
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

    /// SwiftUI can write the alert binding again during its dismissal update.
    /// The explicit acknowledgement has already cleared it; never publish that no-op.
    func dismissError() {
        guard errorMessage != nil else { return }
        errorMessage = nil
    }

    func resume() { viewingOriginal = false; showingHome = false; bindWorld(restoring: true) }
    func home() { playback.setSuspended(true, now: now); showingHome = true }

    func start(replay: Bool = false, randomBirth: Bool = false) {
        guard let catalog else { return }
        guard !invalidLaunchSeed else {
            errorMessage = "開發測試種子格式錯誤，請在-life-seed後提供一個非負整數。"
            return
        }
        do {
            let next: LifeSession
            if replay, let old = journey?.activeSession {
                next = try old.restarting(catalog: catalog)
            } else {
                let seed: UInt64 = launchSeed ?? .random(in: .min ... .max)
                next = try randomBirth ? .startRandom(catalog: catalog, seed: seed) : .start(catalog: catalog, countryCode: countryCode,
                                  householdID: "\(countryCode.lowercased())-\(familyNumber)", seed: seed)
            }
            if commit(.single(next)) { viewingOriginal = false; showingHome = false; showBirthReveal = randomBirth; bindWorld(reset: true) }
        } catch { errorMessage = "暫時無法開始：\(error)" }
    }

    func replayWithNewSeed() {
        guard let catalog, let previous = journey?.activeSession else { return }
        let draw = UInt64.random(in: .min ... .max)
        let differentSeed = draw == previous.state.seed ? draw &+ 1 : draw
        do {
            let next = try LifeSession.start(catalog: catalog, countryCode: previous.state.countryCode,
                householdID: previous.state.householdID, seed: differentSeed)
            if commit(.single(next)) { viewingOriginal = false; showingHome = false; bindWorld(reset: true) }
        } catch { errorMessage = "暫時無法重新開始：\(error)" }
    }
    func choose(_ choiceID: String) {
        guard let catalog, var active = journey, !viewingOriginal else { return }
        do { try active.choose(choiceID, catalog: catalog); if commit(active) { bindWorld() } }
        catch { errorMessage = "這次選擇尚無法進行：\(error)" }
    }
    func next() {
        guard let catalog, var active = journey, !viewingOriginal else { return }
        do { try active.continueLife(catalog: catalog); if commit(active) { bindWorld() } }
        catch { errorMessage = "暫時無法推進：\(error)" }
    }
    @discardableResult
    func startBranch(at index: Int, choiceID: String) -> Bool {
        guard let catalog, let original = journey?.activeSession, comparisonOriginal == nil else { return false }
        do {
            let next = try BranchExperiment.start(original: original, decisionIndex: index, choiceID: choiceID, catalog: catalog)
            if commit(.branch(next)) { viewingOriginal = false; showingHome = false; bindWorld(); return true }
        } catch { errorMessage = "這個岔路尚無法改選：\(error)" }
        return false
    }
    @discardableResult
    func startParallel(countryCode: String, householdID: String, sameTemplateOnly: Bool = true) -> Bool {
        guard let catalog, let original = journey?.activeSession, comparisonOriginal == nil else { return false }
        do {
            let pair = try ParallelLifeExperiment.start(original: original, countryCode: countryCode, householdID: householdID, catalog: catalog, sameTemplateOnly: sameTemplateOnly)
            if commit(.parallel(pair)) {
                viewingOriginal = false; showingHome = false; bindWorld(reset: true); return true
            }
        } catch { errorMessage = "這個出身尚無法開始：\(error)" }
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
