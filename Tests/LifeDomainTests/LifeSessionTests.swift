import XCTest
import LifeData
import LifeDomain

final class LifeSessionTests: XCTestCase {
    func testEveryDecisionHasOriginalStoryText() throws {
        let c = try StatisticsRepository.bundled()
        XCTAssertEqual(Set(EventNarratives.texts.keys), Set(c.decisions.map(\.id)))
        XCTAssertTrue(EventNarratives.texts.values.allSatisfy { $0.count >= 60 })
        XCTAssertEqual(c.contentVersion, "lc02-story-1")
    }
    func testFourCountryEightFamilyPlaythroughsReachReviewAndCannotRepeat() throws {
        let c = try StatisticsRepository.bundled()
        for code in ["JPN", "USA", "IND", "KEN"] {
            for family in 1...2 {
                var session = try LifeSession.start(catalog: c, countryCode: code, householdID: "\(code.lowercased())-\(family)", seed: 42)
                for age in [8, 10, 12, 13, 17, 21, 25, 32, 39, 45, 52, 59, 65, 72, 80] {
                    XCTAssertEqual(try session.event(catalog: c).age, age)
                    let preview = try session.preview(choiceID: "invest", catalog: c)
                    let choice = preview.applied ? "invest" : "ask"
                    try session.choose(choice, catalog: c)
                    XCTAssertEqual(session.phase, .reflecting)
                    XCTAssertThrowsError(try session.choose(choice, catalog: c))
                    try session.continueLife(catalog: c)
                }
                XCTAssertEqual(session.phase, .ended)
                XCTAssertEqual(session.traces.count, 15)
                XCTAssertEqual(session.state.memories.count, 3)
                XCTAssertThrowsError(try session.continueLife(catalog: c))
                XCTAssertThrowsError(try session.event(catalog: c))
            }
        }
    }

    func testUnavailableChoiceDoesNotAdvanceSessionAndRestRemainsPossible() throws {
        let c = try StatisticsRepository.bundled()
        var session = try LifeSession.start(catalog: c, countryCode: "KEN", householdID: "ken-2", seed: 42)
        let original = session
        XCTAssertFalse(try session.preview(choiceID: "invest", catalog: c).applied)
        XCTAssertThrowsError(try session.choose("invest", catalog: c))
        XCTAssertEqual(session, original)
        XCTAssertThrowsError(try session.continueLife(catalog: c))
        try session.choose("rest", catalog: c)
        try session.continueLife(catalog: c)
        XCTAssertEqual(session.state.age, 10)
    }

    func testComparisonHoldsChoiceSeedAndPastResourcesFixed() throws {
        let c = try StatisticsRepository.bundled()
        let session = try LifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-2", seed: 42)
        let comparisons = try session.compare(choiceID: "invest", countryCodes: ["USA", "JPN", "IND", "KEN"], catalog: c)
        XCTAssertEqual(comparisons.map(\.finalCost.time), [3, 4, 4, 5])
        XCTAssertEqual(Set(comparisons.map(\.seed)), [42])
        XCTAssertTrue(comparisons.allSatisfy { $0.resourcesBefore == session.state.resources && $0.choiceID == "invest" })
        XCTAssertEqual(comparisons.map(\.applied), [true, true, true, false])
        XCTAssertEqual(session.phase, .choosing)
        XCTAssertTrue(session.traces.isEmpty)
    }

    func testSameBackgroundReplayUsesSameTraceAndSessionCodableResumes() throws {
        let c = try StatisticsRepository.bundled()
        var first = try LifeSession.start(catalog: c, countryCode: "IND", householdID: "ind-1", seed: .max)
        let replay = first
        try first.choose("invest", catalog: c)
        var restored = try JSONDecoder().decode(LifeSession.self, from: JSONEncoder().encode(first))
        XCTAssertEqual(restored, first)
        try restored.continueLife(catalog: c)
        try first.continueLife(catalog: c)
        XCTAssertEqual(restored, first)
        var second = replay
        try second.choose("invest", catalog: c)
        XCTAssertEqual(second.traces.first, first.traces.first)
    }

    func testDecodedCorruptSessionCannotIndexBeyondCatalog() throws {
        let c = try StatisticsRepository.bundled()
        var session = try LifeSession.start(catalog: c, countryCode: "USA", householdID: "usa-1", seed: 42)
        try session.choose("rest", catalog: c)
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(session)) as? [String: Any])
        let trace = try XCTUnwrap((object["traces"] as? [Any])?.first)
        object["traces"] = Array(repeating: trace, count: 16)
        var corrupt = try JSONDecoder().decode(LifeSession.self, from: JSONSerialization.data(withJSONObject: object))
        XCTAssertThrowsError(try corrupt.continueLife(catalog: c))
    }
}
