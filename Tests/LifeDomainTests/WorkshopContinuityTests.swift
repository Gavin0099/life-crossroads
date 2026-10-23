import XCTest
import LifeDomain
import LifeData

final class WorkshopContinuityTests: XCTestCase {
    private func start(_ country: String = "JPN", _ family: Int = 1, seed: UInt64 = 42) throws -> LifeSession {
        try .start(catalog: WorkshopCatalog.bundled(), countryCode: country, householdID: country.lowercased() + "-\(family)", seed: seed)
    }
    private func route(_ choice: String, country: String = "JPN", family: Int = 1, seed: UInt64 = 42) throws -> LifeSession {
        let catalog = try WorkshopCatalog.bundled()
        var play = try start(country, family, seed: seed)
        try play.choose(choice, catalog: catalog)
        try play.continueLife(catalog: catalog)
        return play
    }
    func testSameStartingWorldLeadsToDifferentPlayableOpportunities() throws {
        let catalog = try WorkshopCatalog.bundled()
        let team = try route("team"), help = try route("help")
        XCTAssertEqual(team.state.age, 15); XCTAssertEqual(help.state.age, 15)
        let teamIDs = Set(try team.event(catalog: catalog).choices.map(\.id))
        let helpIDs = Set(try help.event(catalog: catalog).choices.map(\.id))
        XCTAssertTrue(teamIDs.contains("lead")); XCTAssertFalse(teamIDs.contains("borrow"))
        XCTAssertTrue(helpIDs.contains("borrow")); XCTAssertFalse(helpIDs.contains("lead"))
        XCTAssertEqual(team.state.story.fact("workshop")?.value, "prototype")
        XCTAssertEqual(help.state.story.fact("workshop")?.value, "plan")
        XCTAssertEqual(team.state.resources.skills, 24) //20 initial +3 practice +1 actual family support
        XCTAssertEqual(help.state.resources.skills, 21) //20 initial +1 asking
        XCTAssertEqual(team.state.story.relationships.first { $0.personID == "ahe" }?.familiarity, 2)
        XCTAssertEqual(help.state.story.relationships.first { $0.personID == "teacher" }?.familiarity, 2)
    }
    func testUnavailableFutureChoiceCannotBeForgedAndDoesNotSpendAnything() throws {
        let catalog = try WorkshopCatalog.bundled()
        var help = try route("help");let before = help
        XCTAssertThrowsError(try help.choose("lead", catalog: catalog))
        XCTAssertEqual(help, before)
        let trace = try help.preview(choiceID: "lead", catalog: catalog)
        XCTAssertFalse(trace.applied);XCTAssertEqual(trace.resourcesBefore, trace.resourcesAfter)
        XCTAssertEqual(trace.storyBranch?.sourceEventID, "workshop-bridge")
        XCTAssertEqual(trace.storyBranch?.sourceChoiceID, "help")
        XCTAssertEqual(trace.storyBranch?.sourceAge, 13)
        XCTAssertEqual(trace.storyBranch?.assumptionID,"workshop-continuity")
        XCTAssertTrue(catalog.assumptions.contains { $0.id == trace.storyBranch?.assumptionID })
        XCTAssertFalse(trace.storyBranch?.offeredChoiceIDs.contains("lead") ?? true)
    }
    func testBothRoutesHaveExecutableDifferentFutureActionsAndCanFinish() throws {
        let catalog = try WorkshopCatalog.bundled()
        for (first, next) in [("team","lead"),("help","borrow"),("rest","practice")] {
            var play = try route(first)
            try play.choose(next, catalog: catalog)
            XCTAssertTrue(try XCTUnwrap(play.traces.last).applied)
            XCTAssertEqual(play.state.decisions.map(\.choiceID), [first,next])
            try play.continueLife(catalog: catalog)
            XCTAssertEqual(play.phase, .ended)
            try play.validate(catalog: catalog)
        }
    }
    func testLowResourcesHaveFreeRecoveryAndAskingAcrossCountriesAndSeeds() throws {
        let catalog = try WorkshopCatalog.bundled()
        for country in ["JPN","USA","IND","KEN"] {
            for family in 1...2 {
                for seed in UInt64(0)..<8 {
                    for first in ["team","help","rest"] {
                        let play = try route(first,country:country,family:family,seed:seed)
                        XCTAssertTrue(try play.preview(choiceID: "rest", catalog: catalog).applied)
                        XCTAssertTrue(try play.preview(choiceID: "ask", catalog: catalog).applied)
                    }
                }
            }
        }
    }
    func testSkillThresholdUsesActualResourcesAndKeepsRecovery() throws {
        let catalog = try WorkshopCatalog.bundled(), play = try route("team")
        var below = play.state; below.resources.skills = 23
        let denied = try DecisionResolver.resolve(state:below,eventID:"workshop-return",choiceID:"lead",catalog:catalog)
        XCTAssertFalse(denied.trace.applied);XCTAssertEqual(denied.state,below)
        XCTAssertEqual(denied.trace.storyBranch?.resourceChecks.first?.value,23)
        XCTAssertEqual(denied.trace.storyBranch?.resourceChecks.first?.minimum,24)
        XCTAssertTrue(try DecisionResolver.resolve(state:below,eventID:"workshop-return",choiceID:"rest",catalog:catalog).trace.applied)
        var ready = below;ready.resources.skills = 24
        XCTAssertTrue(try DecisionResolver.resolve(state:ready,eventID:"workshop-return",choiceID:"lead",catalog:catalog).trace.applied)
    }
    func testRestoreAndDeterministicReplayPreserveFullWorldAndOpportunities() throws {
        let catalog = try WorkshopCatalog.bundled()
        for first in ["team","help","rest"] {
            var original = try start();try original.choose(first,catalog:catalog)
            let restored = try LifeSession.restore(from:JSONEncoder().encode(original),catalog:catalog)
            XCTAssertEqual(original,restored)
            try original.continueLife(catalog:catalog)
            XCTAssertEqual(original,try route(first))
            XCTAssertEqual(original,try LifeSession.restore(from:JSONEncoder().encode(original),catalog:catalog))
        }
    }
    func testRejectCorruptedVersionForgedFactsAndForgedTimeline() throws {
        let catalog = try WorkshopCatalog.bundled(), play = try route("team")
        let data = try JSONEncoder().encode(play)
        XCTAssertThrowsError(try LifeSession.restore(from:Data("broken".utf8),catalog:catalog))
        for key in ["scheduledAges","state"] {
            var object = try XCTUnwrap(JSONSerialization.jsonObject(with:data) as? [String:Any])
            if key == "scheduledAges" { object[key] = [13,16] }
            else {
                var state = try XCTUnwrap(object[key] as? [String:Any]);state["contentVersion"]="rng-v2-story-1";object[key]=state
            }
            XCTAssertThrowsError(try LifeSession.restore(from:JSONSerialization.data(withJSONObject:object),catalog:catalog))
        }
        var forged = try XCTUnwrap(JSONSerialization.jsonObject(with:data) as? [String:Any])
        var forgedState = try XCTUnwrap(forged["state"] as? [String:Any])
        var story = try XCTUnwrap(forgedState["story"] as? [String:Any])
        var flags = try XCTUnwrap(story["flags"] as? [[String:Any]])
        flags[0]["value"] = "plan"; story["flags"] = flags
        forgedState["story"] = story;forged["state"] = forgedState
        XCTAssertThrowsError(try LifeSession.restore(from:JSONSerialization.data(withJSONObject:forged),catalog:catalog))
        XCTAssertThrowsError(try LifeSession.restore(from:data,catalog:StatisticsRepository.bundled()))
    }
    func testRejectInvalidTimelinesAndKeepDefaultCompleteLifeUnchanged() throws {
        var catalog = try WorkshopCatalog.bundled()
        for ages in [[15,13],[13,13],[],[13,101]] {
            catalog.timeline?.ages=ages
            XCTAssertThrowsError(try catalog.validate())
        }
        let full = try StatisticsRepository.bundled()
        XCTAssertNil(full.timeline);XCTAssertEqual(full.decisionAges,[8,10,12,13,17,21,25,32,39,45,52,59,65,72,80])
        let session = try LifeSession.start(catalog:full,countryCode:"JPN",householdID:"jpn-1",seed:42)
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with:JSONEncoder().encode(session)) as? [String:Any])
        object.removeValue(forKey:"scheduledAges") // Original valid session encoding before this feature.
        XCTAssertEqual(session,try LifeSession.restore(from:JSONSerialization.data(withJSONObject:object),catalog:full))
    }
    func testRestDoesNotEraseEarnedExperienceOrRelationshipHistory() throws {
        let catalog = try WorkshopCatalog.bundled();var play = try route("team")
        let fact = play.state.story.fact("workshop"), people = play.state.story.relationships
        try play.choose("rest",catalog:catalog)
        XCTAssertEqual(play.state.story.fact("workshop"),fact)
        XCTAssertEqual(play.state.story.relationships,people)
        XCTAssertEqual(play.state.decisions.count,2)
    }
}
