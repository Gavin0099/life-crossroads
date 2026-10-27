import Foundation
import LifeDomain

struct OpportunitySample: Codable {
    let engineVersion: String
    let dataVersion: String
    let contentVersion: String
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
                result.append(.init(engineVersion: life.state.engineVersion, dataVersion: life.state.dataVersion, contentVersion: life.state.contentVersion, country: family.countryCode, householdID: family.id, templateID: family.templateID,
                    policy: policy, seed: 34, steps: life.traces.map { trace in
                        .init(age: trace.age, event: trace.eventID, title: trace.eventTitle, choice: trace.choiceID, action: trace.choiceTitle,
                              cost: trace.finalCost, sourceAge: trace.storyBranch?.sourceAge, sourceChoice: trace.storyBranch?.sourceChoiceID,
                              opportunity: trace.storyBranch?.opportunity, offered: trace.storyBranch?.offeredChoiceIDs ?? catalog.decisions.first(where: { $0.id == trace.eventID })?.choices.map(\.id) ?? [], gaps: trace.environmentGaps)
                    }, replayMatches: restored == life))
            }
        }
        return result
    }
}
