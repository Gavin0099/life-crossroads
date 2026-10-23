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

    init() {
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
        do {
            if replay, let old = session {
                session = try .start(catalog: catalog, countryCode: old.state.countryCode,
                                     householdID: old.state.householdID, seed: old.state.seed)
            } else {
                let seed: UInt64 = ProcessInfo.processInfo.arguments.contains("-ui-testing") ? 42 : .random(in: .min ... .max)
                session = try .start(catalog: catalog, countryCode: countryCode,
                                     householdID: "\(countryCode.lowercased())-\(familyNumber)", seed: seed)
            }
        } catch { errorMessage = "暫時無法開始：\(error)" }
    }
    func choose(_ choiceID: String) {
        guard let catalog, var active = session else { return }
        do { try active.choose(choiceID, catalog: catalog); session = active }
        catch { errorMessage = "這次選擇尚無法進行：\(error)" }
    }
    func next() {
        guard let catalog, var active = session else { return }
        do { try active.continueLife(catalog: catalog); session = active }
        catch { errorMessage = "暫時無法推進：\(error)" }
    }
    func preview(_ choiceID: String) -> ConsequenceTrace? {
        guard let catalog, let session else { return nil }
        return try? session.preview(choiceID: choiceID, catalog: catalog)
    }
    func compare(choiceID: String) -> [ConsequenceTrace] {
        guard let catalog, let session else { return [] }
        do { return try session.compare(choiceID: choiceID, countryCodes: Self.firstCountries, catalog: catalog) }
        catch { errorMessage = "暫時無法比較：\(error)"; return [] }
    }
    func name(_ country: String) -> String { catalog?.countries.first { $0.code == country }?.name ?? country }
    func title(_ event: String) -> String { catalog?.decisions.first { $0.id == event }?.title ?? event }
    func choiceTitle(_ trace: ConsequenceTrace) -> String {
        trace.choiceTitle
    }
}
