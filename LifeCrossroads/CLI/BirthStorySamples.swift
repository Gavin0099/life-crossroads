import Foundation
import LifeDomain

struct BirthStorySample: Codable {
    let countryCode: String
    let householdID: String
    let projectChoice: String
    let seed: UInt64
    let online: ConsequenceTrace
    let paper: ConsequenceTrace
    let life: [BirthStoryStep]
    let replayMatches: Bool
}
struct BirthStoryStep: Codable {
    let age: Int
    let eventID: String
    let eventTitle: String
    let choiceID: String
    let choiceTitle: String
    let person: String
    let storyVariantID: String?
    let actualStoryReason: String?
    let facts: [StoryFact]
    let callbacks: [StoryHook]
    let resources: ResourceValues
}
struct BirthStoryEvidence: Codable {
    let scope: String
    let seedSearch: String
    let selectedSeed: UInt64
    let samples: [BirthStorySample]
}
enum BirthStorySamples {
    static func life(catalog: ModelCatalog, code: String, seed: UInt64, project: String) throws -> BirthStorySample {
        var life = try LifeSession.start(catalog: catalog, countryCode: code, householdID: "\(code.lowercased())-1", seed: seed)
        var online: ConsequenceTrace?, paper: ConsequenceTrace?
        while life.phase != .ended {
            let event = try life.event(catalog: catalog)
            if event.id == "teen-project" {
                online = try life.preview(choiceID: "invest", catalog: catalog)
                paper = try life.preview(choiceID: "offline", catalog: catalog)
            }
            let preferred = event.id == "teen-project" ? project : "rest"
            let choice = try life.preview(choiceID: preferred, catalog: catalog).applied ? preferred : "rest"
            try life.choose(choice, catalog: catalog); try life.continueLife(catalog: catalog)
        }
        guard let online, let paper else { throw ModelError.missing("creative wish") }
        let restored = try LifeSession.restore(from: JSONEncoder().encode(life), catalog: catalog)
        return .init(countryCode: code, householdID: life.state.householdID, projectChoice: project, seed: seed,
                     online: online, paper: paper, life: life.traces.enumerated().map { index, trace in
                        .init(age: trace.age, eventID: trace.eventID, eventTitle: trace.eventTitle,
                              choiceID: trace.choiceID, choiceTitle: trace.choiceTitle, person: trace.recurringPerson,
                              storyVariantID: trace.storyVariantID, actualStoryReason: trace.storyBranch?.explanation,
                              facts: trace.recordedStoryFacts, callbacks: life.jumps[index].triggeredHooks, resources: trace.resourcesAfter)
                     }, replayMatches: restored == life)
    }
    static func run(catalog: ModelCatalog) throws -> BirthStoryEvidence {
        // A bounded, disclosed witness search, not a claim about typical continuation probability.
        for seed in UInt64(0)..<64 {
            let online = try life(catalog: catalog, code: "JPN", seed: seed, project: "invest")
            let paper = try life(catalog: catalog, code: "JPN", seed: seed, project: "offline")
            guard online.life[4].eventID == "teen-direction", paper.life[4].eventID == "teen-direction" else { continue }
            var samples: [BirthStorySample] = []
            for country in catalog.countries.sorted(by: { $0.code < $1.code }) {
                for choice in ["invest", "offline", "ask", "rest"] {
                    samples.append(try life(catalog: catalog, code: country.code, seed: seed, project: choice))
                }
            }
            return .init(scope: "同Seed、家庭模板一、其餘選擇休息；四種13歲行動，八國各完整15決策。示範見證，不是抽樣遊戲性驗收，也不強制每局遇到17歲邀請。",
                         seedSearch: "按0..<64找到第一個日本線上/紙本均實際抽到teen-direction的Seed。未修改事件權重或插入事件。",
                         selectedSeed: seed, samples: samples)
        }
        throw ModelError.missing("bounded teen continuation witness")
    }
}
