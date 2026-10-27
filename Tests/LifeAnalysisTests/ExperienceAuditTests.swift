import XCTest
import LifeDomain
import LifeData
import LifeAnalysis

final class ExperienceAuditTests: XCTestCase {
    func testRecoveryIsAnAvailableStoryNotAClaimOfAcceptedHelp() throws {
        let c=try StatisticsRepository.bundled()
        var life=try LifeSession.start(catalog:c,countryCode:"JPN",householdID:"jpn-1",seed:0)
        while life.phase != .ended {
            if life.state.age < 80 { try life.chooseFocus(.recovery,catalog:c) }
            try life.choose("rest",catalog:c); try life.continueLife(catalog:c)
        }
        let links=try StoryConnections.evaluate(life,catalog:c)
        // Authored witness: focus25→32 offers pacedRole; actual rest45→52 offers shortReturn.
        XCTAssertTrue(links.contains { $0.sourceAge==25 && $0.outcomeAge==32 && $0.availableContinuations==["pacedRole"] })
        XCTAssertTrue(links.contains { $0.sourceAge==45 && $0.outcomeAge==52 && $0.availableContinuations==["shortReturn"] })
        XCTAssertTrue(links.allSatisfy { $0.category=="recovery" && !$0.accepted })
        XCTAssertFalse(links.contains { $0.ruleID=="story.support" })
    }
}
