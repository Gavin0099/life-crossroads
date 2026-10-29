import XCTest
import Foundation
import LifeDomain
import LifeData
import LifePresentation

final class DecisionCardModelTests: XCTestCase {
    private func fixture() throws -> (ModelCatalog, LifeSession, [ConsequenceTrace]) {
        let catalog = try StatisticsRepository.bundled()
        var session = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 34)
        for _ in 0..<3 {
            try session.choose("rest", catalog: catalog); try session.continueLife(catalog: catalog)
        }
        return (catalog, session, try ["offline", "invest", "ask", "rest"].map { try session.preview(choiceID: $0, catalog: catalog) })
    }
    func testReleaseThresholdAndDirectionUseFinalActualPosition() throws {
        let (_, _, previews) = try fixture()
        // Independent specification: 96pt inclusive, left=paper, right=online; no velocity guess.
        for (x, expected) in [(-95.9, nil), (95.9, nil), (-96, "offline"), (96, "invest")] as [(Double, String?)] {
            var model = DecisionCardModel(); model.beginDrag(); model.drag(x: x, y: 0)
            XCTAssertEqual(model.release(x: x, y: 0, previews: previews), expected)
        }
        var returned = DecisionCardModel(); returned.beginDrag(); returned.drag(x: 140, y: 0)
        XCTAssertEqual(returned.previewID, "invest")
        XCTAssertNil(returned.release(x: 2, y: 0, previews: previews))
        XCTAssertEqual(returned.offset, 0); XCTAssertEqual(returned.phase, .idle)
    }
    func testVerticalDiagonalAndInterruptedGesturesCannotSubmit() throws {
        let (_, _, previews) = try fixture()
        var vertical = DecisionCardModel(); vertical.beginDrag(); vertical.drag(x: 5, y: 30)
        XCTAssertNil(vertical.release(x: 140, y: 32, previews: previews))
        var diagonal = DecisionCardModel(); diagonal.beginDrag()
        XCTAssertNil(diagonal.release(x: 100, y: 90, previews: previews))
        var background = DecisionCardModel(); background.beginDrag(); background.drag(x: 120, y: 0); background.cancel()
        background.drag(x: 140, y: 0)
        XCTAssertNil(background.release(x: 140, y: 0, previews: previews))
        XCTAssertEqual(background.offset, 0)
        background.beginDrag()
        XCTAssertEqual(background.release(x: -120, y: 0, previews: previews), "offline")
        var invalid = DecisionCardModel(); invalid.beginDrag()
        XCTAssertNil(invalid.release(x: .infinity, y: 0, previews: previews))
    }
    func testRepeatedRequestsOnlyCommitOnceAndFailedSaveCanRetry() throws {
        let (_, _, previews) = try fixture()
        var model = DecisionCardModel()
        XCTAssertEqual(model.request("ask", previews: previews), "ask")
        XCTAssertEqual(model.phase, .commitRequested)
        model.beginDrag(); model.cancel()
        XCTAssertNil(model.request("rest", previews: previews))
        XCTAssertNil(model.release(x: 140, y: 0, previews: previews))
        XCTAssertEqual(model.pendingID, "ask")
        model.resolved(saved: false)
        XCTAssertEqual(model.phase, .failed)
        XCTAssertEqual(model.request("ask", previews: previews), "ask")
        model.resolved(saved: true)
        XCTAssertEqual(model.phase, .saved)
        XCTAssertNil(model.request("ask", previews: previews))
        model.beginDrag(); model.cancel()
        XCTAssertEqual(model.phase, .saved)
    }
    func testAllFourButtonsKeepExactChoiceIDsWithoutMutatingLife() throws {
        let (_, session, previews) = try fixture()
        let encoder = JSONEncoder(); encoder.outputFormatting = .sortedKeys
        let before = try encoder.encode(session)
        for id in ["offline", "invest", "ask", "rest"] {
            var model = DecisionCardModel()
            XCTAssertEqual(model.request(id, previews: previews.reversed()), id)
            XCTAssertEqual(model.pendingID, id)
        }
        XCTAssertEqual(try encoder.encode(session), before)
        var model = DecisionCardModel(); model.resolved(saved: true)
        XCTAssertEqual(model.phase, .idle, "Cannot acknowledge an outcome before requesting a save")
        XCTAssertNil(model.request("invented", previews: previews))
        XCTAssertNil(model.request("invest", previews: []))
    }
    func testUnavailablePreviewBlocksButtonsAndSwipesWithActualReason() throws {
        let (catalog, session, previews) = try fixture()
        // Explicit low-budget test state, not a fabricated real-life fixture or country claim.
        var state = session.state; state.remainingTime = 0
        let denied = try DecisionResolver.resolve(state: state, eventID: "teen-project", choiceID: "invest", catalog: catalog).trace
        XCTAssertFalse(denied.applied); XCTAssertFalse(denied.unavailableReasons.isEmpty)
        let mixed = previews.filter { $0.choiceID != "invest" } + [denied]
        var button = DecisionCardModel(); button.cancel()
        XCTAssertNil(button.request("invest", previews: mixed))
        XCTAssertFalse(button.cancelled, "A new unavailable request must show its reason, not a stale cancellation")
        XCTAssertEqual(button.previewID, "invest")
        var swipe = DecisionCardModel(); swipe.beginDrag()
        XCTAssertNil(swipe.release(x: 140, y: 0, previews: mixed))
        XCTAssertEqual(swipe.phase, .preview)
        XCTAssertEqual(swipe.request("rest", previews: mixed), "rest", "Blocked primary choice must retain another path")
    }
    func testOnlyReviewedFourChoiceEventCanEnableSwipe() throws {
        let (catalog, session, _) = try fixture()
        var event = try session.event(catalog: catalog)
        XCTAssertTrue(DecisionCardModel.supports(event))
        event.choices.reverse(); XCTAssertTrue(DecisionCardModel.supports(event))
        event.choices.removeLast(); XCTAssertFalse(DecisionCardModel.supports(event))
        for other in catalog.decisions where other.id != "teen-project" { XCTAssertFalse(DecisionCardModel.supports(other)) }
    }
}
