import Foundation
import LifeDomain
import LifePersistence

@main struct Fixtures {
    static func main() throws {
        let root = URL(fileURLWithPath: CommandLine.arguments[1])
        let out = root.appendingPathComponent("artifacts/evidence/visual-loop-02/fixtures")
        let catalog = try JSONDecoder().decode(ModelCatalog.self, from: Data(contentsOf: root.appendingPathComponent("LifeCrossroads/Data/Resources/catalog.json")))
        try catalog.validate()
        var entries: [[String: Any]] = []
        func save(_ name: String, _ s: LifeSession) throws {
            let file = out.appendingPathComponent(name + ".json")
            let repo = SaveRepository(fileURL: file)
            try repo.save(.single(s), catalog: catalog)
            let restored = try repo.load(catalog: catalog); precondition(restored?.activeSession == s)
            entries.append(["name": name, "age": s.state.age, "country": s.state.countryCode,
                "household": s.state.householdID, "seed": s.state.seed, "phase": s.phase.rawValue,
                "event": s.phase == .choosing ? try s.event(catalog: catalog).id : s.traces.last?.eventID ?? "",
                "choice": s.phase == .reflecting ? s.traces.last?.choiceID ?? "" : "",
                "decisionCount": s.traces.count])
        }
        func action(_ s: LifeSession, preferred: String? = nil) throws -> String {
            let e = try s.event(catalog: catalog)
            let ids = [preferred, "rest", "ask", "invest"].compactMap { $0 } + e.choices.map(\.id)
            for id in ids where e.choices.contains(where: { $0.id == id }) {
                if try s.preview(choiceID: id, catalog: catalog).applied { return id }
            }
            throw ModelError.invalid("no feasible fixture choice")
        }
        func reach(_ age: Int, country: String, seed: UInt64, project: String, teen: String? = nil) throws -> LifeSession {
            var s = try LifeSession.start(catalog: catalog, countryCode: country, householdID: country.lowercased() + "-1", seed: seed)
            while s.state.age < age {
                let preferred = s.state.age == 13 ? project : s.state.age == 17 ? teen : nil
                try s.choose(action(s, preferred: preferred), catalog: catalog)
                if s.state.age == 25 { try s.chooseFocus(.recovery, catalog: catalog) }
                try s.continueLife(catalog: catalog)
            }
            return s
        }
        let child = try reach(8, country: "JPN", seed: 34, project: "invest")
        try save("08-arrival", child)
        let at13 = try reach(13, country: "JPN", seed: 34, project: "invest")
        try save("13-before", at13)
        for (id, label) in [("invest", "online"), ("offline", "paper"), ("ask", "ask"), ("rest", "rest")] {
            var s = at13; try s.choose(id, catalog: catalog); try save("13-" + label, s)
        }
        for (country, teen, adult, label) in [("JPN", "remoteStudio", "portfolio", "remote"), ("KEN", "mentorRelay", "cooperate", "collective")] {
            var s = try reach(17, country: country, seed: 34, project: "invest")
            let eligibleTeen = try action(s, preferred: teen); precondition(eligibleTeen == teen)
            try s.choose(teen, catalog: catalog); try save("17-" + label, s)
            s = try reach(25, country: country, seed: 34, project: "invest", teen: teen)
            let eligibleAdult = try action(s, preferred: adult); precondition(eligibleAdult == adult)
            try s.choose(adult, catalog: catalog); try save("25-" + label, s)
        }
        var recovery: LifeSession?
        for seed in UInt64(0)..<128 {
            let s = try reach(32, country: "JPN", seed: seed, project: "rest")
            if try s.event(catalog: catalog).id == "adult-boundary-calendar", try action(s, preferred: "pacedRole") == "pacedRole" { recovery = s; break }
        }
        guard var s = recovery else { throw ModelError.invalid("no real recovery witness") }
        try save("32-prepared", s)
        try s.choose("pacedRole", catalog: catalog); try save("32-participating", s)
        for age in [65, 80] {
            let s = try reach(age, country: "JPN", seed: 34, project: "invest", teen: "remoteStudio")
            try save("\(age)-arrival", s)
        }
        try JSONSerialization.data(withJSONObject: ["baseline": "81371e0aa257233fadd0355faf36ba8e0edcdc64", "source": "Actual unmodified LifeSession and SaveRepository; no forced events or state edits", "fixtures": entries], options: [.prettyPrinted, .sortedKeys]).write(to: out.appendingPathComponent("manifest.json"))
        print("Saved and restored \(entries.count) real sessions")
    }
}
