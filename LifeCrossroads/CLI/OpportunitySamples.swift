import Foundation
import LifeDomain

struct OpportunitySample: Codable {
    let country: String
    let householdID: String
    let templateID: String
    let policy: String
    let seed: UInt64
    let steps: [OpportunityStep]
    let replayMatches: Bool
}
struct OpportunityStep: Codable {
    let age: Int
    let event: String
    let title: String
    let choice: String
    let action: String
    let cost: Cost
    let sourceAge: Int?
    let sourceChoice: String?
    let opportunity: CreativeOpportunity?
    let offered: [String]
    let gaps: [String]
}
enum OpportunitySamples {
    static func run(catalog: ModelCatalog) throws -> [OpportunitySample] {
        var result: [OpportunitySample] = []
        for family in catalog.households.sorted(by: { $0.id < $1.id }) {
            for policy in ["pursue", "ask", "rest", "paper"] {
                var life = try LifeSession.start(catalog: catalog, countryCode: family.countryCode, householdID: family.id, seed: 34)
                while life.phase != .ended {
                    let event = try life.event(catalog: catalog)
                    var preferences = ["rest"]
                    if [13,17,25].contains(life.state.age) {
                        switch policy {
                        case "pursue": preferences = ["remoteStudio", "mentorRelay", "portfolio", "cooperate", "invest", "ask", "rest"]
                        case "ask": preferences = ["ask", "seekGuide", "rest"]
                        case "paper": preferences = ["leadWorkshop", "cooperate", "offline", "ask", "rest"]
                        default: break
                        }
                    }
                    let available = try event.choices.filter { try life.preview(choiceID: $0.id, catalog: catalog).applied }.map(\.id)
                    guard let choice = preferences.first(where: available.contains) else { throw ModelError.invalid("sample dead end") }
                    try life.choose(choice, catalog: catalog); try life.continueLife(catalog: catalog)
                }
                let restored = try LifeSession.restore(from: JSONEncoder().encode(life), catalog: catalog)
                result.append(.init(country: family.countryCode, householdID: family.id, templateID: family.templateID,
                    policy: policy, seed: 34, steps: life.traces.map {
                        .init(age: $0.age, event: $0.eventID, title: $0.eventTitle, choice: $0.choiceID, action: $0.choiceTitle,
                              cost: $0.finalCost, sourceAge: $0.storyBranch?.sourceAge, sourceChoice: $0.storyBranch?.sourceChoiceID,
                              opportunity: $0.storyBranch?.opportunity, offered: $0.storyBranch?.offeredChoiceIDs ?? [], gaps: $0.environmentGaps)
                    }, replayMatches: restored == life))
            }
        }
        return result
    }
}
