import Foundation
import SwiftUI
import LifeDomain
import LifeData

@MainActor
final class GameStore: ObservableObject {
    static let firstCountries = ["JPN", "USA", "IND", "KEN"]
    @Published var session: LifeSession?
    @Published var countryCode = "JPN"
    @Published var familyNumber = 1
    @Published var errorMessage: String?
    let catalog: ModelCatalog?
    private var comparisonSession: LifeSession?
    private let launchSeed: UInt64?
    private let invalidLaunchSeed: Bool

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        if let index = arguments.firstIndex(of: "-life-seed") {
            launchSeed = index + 1 < arguments.count ? UInt64(arguments[index + 1]) : nil
            invalidLaunchSeed = launchSeed == nil
        } else {
            launchSeed = arguments.contains("-ui-testing") ? 42 : nil
            invalidLaunchSeed = false
        }
        do { catalog = try StatisticsRepository.bundled() }
        catch { catalog = nil; errorMessage = "離線資料無法載入：\(error)" }
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

    func start(replay: Bool = false) {
        guard let catalog else { return }
        guard !invalidLaunchSeed else {
            errorMessage = "開發測試種子格式錯誤，請在-life-seed後提供一個非負整數。"
            return
        }
        do {
            if replay, let old = session {
                session = try .start(catalog: catalog, countryCode: old.state.countryCode,
                                     householdID: old.state.householdID, seed: old.state.seed)
            } else {
                let seed: UInt64 = launchSeed ?? .random(in: .min ... .max)
                session = try .start(catalog: catalog, countryCode: countryCode,
                                     householdID: "\(countryCode.lowercased())-\(familyNumber)", seed: seed)
            }
            comparisonSession = nil
        } catch { errorMessage = "暫時無法開始：\(error)" }
    }

    func replayWithNewSeed() {
        guard let catalog, let previous = session else { return }
        let draw = UInt64.random(in: .min ... .max)
        let differentSeed = draw == previous.state.seed ? draw &+ 1 : draw
        do {
            let restarted = try LifeSession.start(catalog: catalog, countryCode: previous.state.countryCode,
                householdID: previous.state.householdID, seed: differentSeed)
            comparisonSession = nil
            session = restarted
        } catch { errorMessage = "暫時無法重新開始：\(error)" }
    }
    func choose(_ choiceID: String) {
        guard let catalog, var active = session else { return }
        do {
            let before = active
            try active.choose(choiceID, catalog: catalog)
            comparisonSession = before
            session = active
        }
        catch { errorMessage = "這次選擇尚無法進行：\(error)" }
    }
    func next() {
        guard let catalog, var active = session else { return }
        do {
            try active.continueLife(catalog: catalog)
            comparisonSession = nil
            session = active
        }
        catch { errorMessage = "暫時無法推進：\(error)" }
    }
    func preview(_ choiceID: String) -> ConsequenceTrace? {
        guard let catalog, let session else { return nil }
        return try? session.preview(choiceID: choiceID, catalog: catalog)
    }
    func compare(choiceID: String) -> [ConsequenceTrace] {
        guard let catalog, let session else { return [] }
        let before: LifeSession
        if session.phase == .choosing { before = session }
        else if session.phase == .reflecting, let saved = comparisonSession,
                session.traces.last?.choiceID == choiceID { before = saved }
        else { errorMessage = "這個選擇的選前狀態尚未保存，不能補算比較。"; return [] }
        do { return try before.compare(choiceID: choiceID, countryCodes: Self.firstCountries, catalog: catalog) }
        catch { errorMessage = "暫時無法比較：\(error)"; return [] }
    }
    func name(_ country: String) -> String { catalog?.countries.first { $0.code == country }?.name ?? country }
    func title(_ event: String) -> String { catalog?.decisions.first { $0.id == event }?.title ?? event }
    func choiceTitle(_ trace: ConsequenceTrace) -> String {
        trace.choiceTitle
    }
}
