import Foundation
import CryptoKit
import LifeDomain
import LifePersistence

/// Real engine journeys for visual comparisons. No event, actor, resource or history injection.
@main struct Fixtures {
    static func main() throws {
        let root = URL(fileURLWithPath: CommandLine.arguments[1])
        let out = root.appendingPathComponent("artifacts/evidence/multi-cast-loop/cast-fixtures")
        let catalogURL = root.appendingPathComponent("LifeCrossroads/Data/Resources/catalog.json")
        let catalogData = try Data(contentsOf: catalogURL)
        let catalog = try JSONDecoder().decode(ModelCatalog.self, from: catalogData)
        try catalog.validate()
        var entries: [[String: Any]] = []
        func json<T: Encodable>(_ value: T) throws -> Any {
            try JSONSerialization.jsonObject(with: JSONEncoder().encode(value))
        }
        func sha(_ data: Data) -> String { SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined() }
        func save(_ name: String, _ session: LifeSession) throws {
            let file = out.appendingPathComponent(name + ".json")
            let repository = SaveRepository(fileURL: file)
            try session.validate(catalog: catalog)
            try repository.save(.single(session), catalog: catalog)
            let bytes = try Data(contentsOf: file)
            let restored = try repository.load(catalog: catalog)
            precondition(restored?.activeSession == session, "save/restore mismatch")
            let repeated = try LifeSession.restore(from: JSONEncoder().encode(session), catalog: catalog)
            precondition(repeated == session, "catalog-backed full replay mismatch")
            try repository.save(.single(repeated), catalog: catalog)
            let savedAgain = try Data(contentsOf: file)
            precondition(savedAgain == bytes, "saved bytes changed after full replay")
            let event = session.phase == .choosing ? try session.event(catalog: catalog) : nil
            let trace = session.phase == .reflecting ? session.traces.last : nil
            var entry: [String: Any] = [
                "name": name, "age": session.state.age, "country": session.state.countryCode,
                "household": session.state.householdID, "seed": session.state.seed,
                "phase": session.phase.rawValue, "event": event?.id ?? trace?.eventID ?? "",
                "choice": trace?.choiceID ?? "", "recurringPerson": event?.recurringPerson ?? trace?.recurringPerson ?? "",
                "storyVariantID": event?.storyVariantID ?? trace?.storyVariantID ?? "",
                "decisionCount": session.traces.count, "sha256": sha(bytes),
                "saveRestoreEqual": true, "catalogBackedReplayEqual": true, "replayedSaveBytesEqual": true,
                "decisions": try json(session.state.decisions), "focusSelections": try json(session.focusSelections),
                "storyFacts": try json(session.state.story.flags),
                "currentInteractionIDs": trace?.changedRelationships.filter { relation in
                    relation.interactions.contains { $0.eventID == trace?.eventID && $0.choiceID == trace?.choiceID && $0.age == trace?.age }
                }.map(\.personID) ?? []
            ]
            if let trace { entry["savedTrace"] = try json(trace) }
            entries.append(entry)
        }
        func action(_ session: LifeSession, preferred: String? = nil) throws -> String {
            let event = try session.event(catalog: catalog)
            let ids = [preferred, "rest", "ask", "invest"].compactMap { $0 } + event.choices.map(\.id)
            for id in ids where event.choices.contains(where: { $0.id == id }) {
                if try session.preview(choiceID: id, catalog: catalog).applied { return id }
            }
            throw ModelError.invalid("no feasible fixture choice")
        }
        func reach(_ age: Int, country: String = "JPN", seed: UInt64 = 34,
                   friendship: String = "rest", project: String = "invest", teen: String? = nil) throws -> LifeSession {
            var session = try LifeSession.start(catalog: catalog, countryCode: country,
                                              householdID: country.lowercased() + "-1", seed: seed)
            while session.state.age < age {
                let preferred = session.state.age == 10 ? friendship : session.state.age == 13 ? project : session.state.age == 17 ? teen : nil
                try session.choose(action(session, preferred: preferred), catalog: catalog)
                if session.state.age == 25 { try session.chooseFocus(.recovery, catalog: catalog) }
                try session.continueLife(catalog: catalog)
            }
            precondition(session.state.age == age)
            return session
        }
        func chosen(_ session: LifeSession, _ choice: String) throws -> LifeSession {
            var result = session
            let feasible = try action(result, preferred: choice)
            precondition(feasible == choice, "requested witness action must be feasible")
            try result.choose(choice, catalog: catalog)
            return result
        }

        let at10 = try reach(10)
        let childEvent = try at10.event(catalog: catalog)
        precondition(childEvent.id == "child-friend")
        try save("10-before", at10)
        try save("10-friend", chosen(at10, "invest"))
        try save("10-rest", chosen(at10, "rest"))
        let at13 = try reach(13)
        for (id, label) in [("ask", "ask"), ("offline", "paper"), ("rest", "rest")] {
            try save("13-" + label, chosen(at13, id))
        }
        for (country, teen, label) in [("JPN", "remoteStudio", "remote"), ("KEN", "mentorRelay", "collective")] {
            let at17 = try reach(17, country: country)
            try save("17-" + label, chosen(at17, teen))
        }
        let at25 = try reach(25, country: "KEN", teen: "mentorRelay")
        try save("25-collective", chosen(at25, "cooperate"))

        var recovery: LifeSession?
        for seed in UInt64(0)..<128 {
            let session = try reach(32, seed: seed, project: "rest")
            if try session.event(catalog: catalog).id == "adult-boundary-calendar",
               try action(session, preferred: "pacedRole") == "pacedRole" { recovery = session; break }
        }
        guard let at32 = recovery else { throw ModelError.invalid("no real recovery witness") }
        try save("32-before", at32)
        try save("32-ask", chosen(at32, "ask"))
        try save("32-participating", chosen(at32, "pacedRole"))

        var paired72: (LifeSession, LifeSession)?
        for seed in UInt64(0)..<256 {
            let connected = try reach(72, seed: seed, friendship: "invest")
            let paused = try reach(72, seed: seed, friendship: "rest")
            if try connected.event(catalog: catalog).id == "later-reconnect",
               try paused.event(catalog: catalog).id == "later-reconnect",
               try action(connected, preferred: "invest") == "invest",
               try action(paused, preferred: "invest") == "invest" { paired72 = (connected, paused); break }
        }
        guard let (connected, paused) = paired72 else { throw ModelError.invalid("no paired real reunion witness") }
        precondition(connected.state.seed == paused.state.seed)
        let oldFriend = try connected.event(catalog: catalog)
        precondition(oldFriend.storyVariantID == "later-reconnect-old-friend")
        let newNeighbor = try paused.event(catalog: catalog)
        precondition(newNeighbor.storyVariantID == "later-reconnect-new-neighbor")
        try save("72-ahe-before", connected)
        try save("72-ahe", chosen(connected, "invest"))
        try save("72-neighbor-before", paused)
        try save("72-neighbor", chosen(paused, "invest"))

        // A real adult shared activity, not a letter that merely proposes a future meeting.
        var adultFriend: LifeSession?
        adultSearch: for age in [32, 25, 39, 45, 52, 59] {
            for seed in UInt64(0)..<128 {
                let session = try reach(age, seed: seed, friendship: "invest")
                if try session.event(catalog: catalog).id == "adult-local-trail",
                   try action(session, preferred: "record") == "record" {
                    adultFriend = try chosen(session, "record"); break adultSearch
                }
            }
        }
        guard let adultFriend else { throw ModelError.invalid("no real adult friendship activity witness") }
        try save("\(adultFriend.state.age)-ahe-trail", adultFriend)
        let manifest: [String: Any] = [
            "baseline": "30d60007ca43431a740c093f17c75a5e75dc0fb6",
            "source": "Unmodified LifeSession, StoryBranchEngine and SaveRepository; actual choices only, no forced events or state edits",
            "catalogSHA256": sha(catalogData), "fixtures": entries,
            "claimBoundary": "Mechanism witnesses, not probability estimates or child playtest evidence. 25-collective records teacher, not cheng. Saved 72 invest has recurringPerson and storyVariantID but no changedRelationships."
        ]
        try JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted, .sortedKeys])
            .write(to: out.appendingPathComponent("manifest.json"))
        print("Saved, replayed and restored \(entries.count) real sessions; paired reunion seed \(connected.state.seed), recovery seed \(at32.state.seed); adult friendship age \(adultFriend.state.age) seed \(adultFriend.state.seed)")
    }
}
