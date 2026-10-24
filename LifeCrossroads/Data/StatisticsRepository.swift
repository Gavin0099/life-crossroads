import CryptoKit
import Foundation
import LifeDomain

public enum StatisticsRepository {
    public static func decode(_ data: Data) throws -> ModelCatalog {
        let catalog = try JSONDecoder().decode(ModelCatalog.self, from: data)
        try catalog.validate()
        return catalog
    }

    public static func bundled() throws -> ModelCatalog {
        guard let url = Bundle.module.url(forResource: "Resources", withExtension: nil) else {
            throw ModelError.missing("bundled resources")
        }
        return try load(directory: url)
    }

    public static func load(directory: URL) throws -> ModelCatalog {
        let catalog = try decode(Data(contentsOf: directory.appendingPathComponent("catalog.json")))
        for source in catalog.sources {
            let raw = try Data(contentsOf: directory.appendingPathComponent(source.rawPath))
            let digest = SHA256.hash(data: raw).map { String(format: "%02x", $0) }.joined()
            guard digest == source.sha256 else { throw ModelError.invalid("source SHA256: \(source.id)") }
            if source.format == "taiwan-row" {
                let payload = try JSONDecoder().decode(NationalRow.self, from: raw)
                guard let column = source.column, payload.row.indices.contains(column),
                      payload.downloadURL == source.downloadURL, payload.originalSHA256.count == 64,
                      payload.originalSHA256.allSatisfy({ $0.isHexDigit }), !payload.location.isEmpty,
                      let value = Double(payload.row[column]),
                      source.indicator == "TWN.INTERNET.12PLUS" || (payload.row.count > 20 && payload.row[20] == "2023") else {
                    throw ModelError.invalid("national extraction contract")
                }
                for observation in catalog.countries.flatMap(\.indicators) where observation.sourceID == source.id {
                    guard observation.value == value, observation.region == "TWN", observation.year == 2023,
                          payload.row.first == (source.indicator == "TWN.INTERNET.12PLUS" ? "112" : "112年") else {
                        throw ModelError.invalid("national source/observation mismatch")
                    }
                }
                continue
            }
            let payload = try JSONDecoder().decode(WDIPayload.self, from: raw)
            guard payload.metadata.pages == 1, payload.metadata.total == payload.rows.count else {
                throw ModelError.invalid("incomplete source pagination")
            }
            for country in catalog.countries {
                for observation in country.indicators where observation.sourceID == source.id {
                    let matches = payload.rows.filter {
                        $0.countryiso3code == observation.region && $0.date == String(observation.year)
                            && $0.indicator.id == observation.indicator
                    }
                    guard matches.count == 1, matches[0].value == observation.value else {
                        throw ModelError.invalid("source/observation mismatch: \(country.code)")
                    }
                }
            }
        }
        return catalog
    }
}

private struct WDIPayload: Decodable {
    struct Metadata: Decodable { let pages: Int; let total: Int }
    struct Row: Decodable {
        struct Indicator: Decodable { let id: String }
        let indicator: Indicator
        let countryiso3code: String
        let date: String
        let value: Double?
    }
    let metadata: Metadata
    let rows: [Row]
    init(from decoder: any Decoder) throws {
        var array = try decoder.unkeyedContainer()
        metadata = try array.decode(Metadata.self)
        rows = try array.decode([Row].self)
        guard array.isAtEnd else { throw ModelError.invalid("extra source payload") }
    }
}

private struct NationalRow: Decodable {
    let downloadURL: String
    let originalSHA256: String
    let location: String
    let row: [String]
}
