import Foundation

/// Uniform over supported fictional households, never a population/birth-rate estimate.
public struct BirthDraw: Codable, Equatable, Sendable {
    public static let currentVersion = "demo-birth-1"
    public let version: String
    public let randomVersion: String
    public let dataVersion: String
    public let seed: UInt64
    public let candidateIDs: [String]
    public let householdID: String
    public let countryCode: String
    public let selectedDraw: Double
    public static let scope = "八國示範情境隨機抽選；各虛構家庭等機會，不代表全球出生機率，也不是任何國家的典型家庭。"

    public static func draw(catalog: ModelCatalog, seed: UInt64) throws -> Self {
        try catalog.validate()
        let supported = Set(catalog.countries.filter { $0.dataStatus != .blocked }.map(\.code))
        let candidates = catalog.households.filter { supported.contains($0.countryCode) }.sorted { $0.id < $1.id }
        guard !candidates.isEmpty else { throw ModelError.missing("birth candidates") }
        func value(_ household: HouseholdProfile) -> Double {
            KeyedRandom.draw(seed: seed, key: "\(currentVersion)|household|\(household.id)")
        }
        // Independent equal-weight draws: reordering candidates cannot change the outcome.
        let selected = candidates.min { value($0) == value($1) ? $0.id < $1.id : value($0) < value($1) }!
        return .init(version: currentVersion, randomVersion: KeyedRandom.version, dataVersion: catalog.dataVersion,
                     seed: seed, candidateIDs: candidates.map(\.id), householdID: selected.id,
                     countryCode: selected.countryCode, selectedDraw: value(selected))
    }
}
