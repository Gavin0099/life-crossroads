import Foundation
import LifeDomain

public struct JourneySave: Codable, Equatable, Sendable {
    public static let currentVersion = 2
    public let schemaVersion: Int
    public let journey: LifeJourney

    private var hasFocusHistory: Bool {
        !journey.activeSession.focusSelections.isEmpty || !(journey.experiment?.original.focusSelections.isEmpty ?? true)
    }

    public init(journey: LifeJourney) {
        self.journey = journey
        schemaVersion = !journey.activeSession.focusSelections.isEmpty || !(journey.experiment?.original.focusSelections.isEmpty ?? true) ? Self.currentVersion : 1
    }

    public func validate(catalog: ModelCatalog) throws {
        guard schemaVersion == (hasFocusHistory ? Self.currentVersion : 1) else { throw ModelError.invalid("save schema version") }
        try journey.validate(catalog: catalog)
    }
}

/// Minimal offline archive for LC-04. Atomic replacement commits a validated complete pair of lives.
/// The caller owns the URL and recovery UX; missing files are distinct from corrupt/incompatible saves.
public struct SaveRepository: Sendable {
    public let fileURL: URL
    public init(fileURL: URL) { self.fileURL = fileURL }

    public func load(catalog: ModelCatalog) throws -> LifeJourney? {
        let data: Data
        do { data = try Data(contentsOf: fileURL) }
        catch let error as NSError where error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError { return nil }
        let save = try JSONDecoder().decode(JourneySave.self, from: data)
        try save.validate(catalog: catalog)
        return save.journey
    }

    public func save(_ journey: LifeJourney, catalog: ModelCatalog) throws {
        let save = JourneySave(journey: journey)
        try save.validate(catalog: catalog)
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(save)
        try FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: fileURL, options: .atomic)
    }
}
