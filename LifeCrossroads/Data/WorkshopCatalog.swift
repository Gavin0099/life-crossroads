import Foundation
import LifeDomain

/// Original two-event content uses the exact same rules and source-checked national data as the complete-life game.
public enum WorkshopCatalog {
    private struct Content: Decodable {
        let timeline: DecisionTimeline
        let decisions: [DecisionSkeleton]
        let assumptions: [DesignAssumption]
    }
    public static func bundled() throws -> ModelCatalog {
        var catalog = try StatisticsRepository.bundled()
        guard let resources = Bundle.module.url(forResource: "Resources", withExtension: nil) else {
            throw ModelError.missing("workshop resources")
        }
        let content = try JSONDecoder().decode(Content.self, from: Data(contentsOf: resources.appendingPathComponent("workshop-slice.json")))
        catalog.timeline = content.timeline
        catalog.contentVersion += "+" + content.timeline.id
        catalog.decisions = content.decisions
        catalog.assumptions += content.assumptions
        try catalog.validate()
        return catalog
    }
}
