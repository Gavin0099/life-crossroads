import XCTest

final class EventFirstTests: XCTestCase {
    @MainActor private func capture(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }

    @MainActor private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<16 {
            if element.isHittable { return }
            app.swipeUp()
        }
    }

    @MainActor func testChoiceToOutcomeReasonCompareAndNextEvent() {
        let app = XCUIApplication(); app.launch()
        XCTAssertTrue(app.staticTexts["你會怎麼做？"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["choice-bridge-team"].isHittable)
        capture("01-home-event-first")
        let team = app.buttons["choice-bridge-team"]; reveal(team, in: app); team.tap()
        XCTAssertTrue(app.staticTexts["先一起試一次。"].exists)
        XCTAssertTrue(app.staticTexts["這次使用了 2 格精力。"].exists)
        capture("02-outcome")
        app.buttons["showReason"].tap()
        XCTAssertTrue(app.staticTexts["你選擇先做簡易作品。"].exists)
        XCTAssertFalse(app.staticTexts["運氣"].exists)
        capture("03-reason")
        app.buttons["showComparison"].tap()
        XCTAssertTrue(app.staticTexts["日本 · 示範家庭 A"].exists)
        XCTAssertTrue(app.staticTexts["肯亞 · 示範家庭 B"].exists)
        capture("04-comparison")
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.staticTexts["阿澄・15 歲"].exists)
        XCTAssertTrue(app.staticTexts["放學後，留一點空間。"].exists)
        XCTAssertFalse(app.staticTexts["先一起試一次。"].exists)
        capture("05-next-event")
        let rest = app.buttons["choice-time-rest"]; reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.staticTexts["留一點，給自己。"].exists)
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.staticTexts["你的選擇，有跡可循。"].exists)
        capture("06-review")
        app.buttons["restart"].tap()
        XCTAssertTrue(app.staticTexts["阿澄・13 歲"].exists)
        XCTAssertTrue(app.buttons["choice-bridge-team"].exists)
    }

    @MainActor func testUnavailableChoiceCannotAdvanceAndSecondChoiceIsUncovered() {
        let app = XCUIApplication(); app.launch()
        let unavailable = app.buttons["choice-bridge-buy"]
        reveal(unavailable, in: app)
        XCTAssertTrue(unavailable.exists)
        XCTAssertFalse(unavailable.isEnabled)
        XCTAssertTrue(app.staticTexts["目前不可選：材料預算不足"].exists)
        let help = app.buttons["choice-bridge-help"]
        // Scroll down then back toward this card if necessary; inspect a real tappable option.
        if !help.isHittable { app.swipeDown() }
        XCTAssertTrue(help.isHittable)
        capture("second-choice-visible")
        help.tap()
        XCTAssertTrue(app.staticTexts["找到一雙援手。"].exists)
        XCTAssertTrue(app.staticTexts["這次使用了 1 格精力。"].exists)
        XCTAssertFalse(app.staticTexts["這次使用了 2 格精力。"].exists)
    }

    @MainActor func testMissingTraceDoesNotInventFactors() {
        let app = XCUIApplication(); app.launchArguments = ["-missing-trace"]; app.launch()
        let team = app.buttons["choice-bridge-team"]; reveal(team, in: app); team.tap()
        app.buttons["showReason"].tap()
        XCTAssertTrue(app.staticTexts["目前沒有原因紀錄"].exists)
        XCTAssertFalse(app.staticTexts["你選擇先做簡易作品。"].exists)
        capture("missing-trace")
    }

    @MainActor func testMissingOutcomeStaysAtDecision() {
        let app = XCUIApplication(); app.launchArguments = ["-missing-outcome"]; app.launch()
        let team = app.buttons["choice-bridge-team"]; reveal(team, in: app); team.tap()
        XCTAssertTrue(app.staticTexts["這個選擇的後果尚未提供，請保留在這個岔路。"].exists)
        XCTAssertFalse(app.buttons["continueLife"].exists)
        XCTAssertTrue(app.buttons["choice-bridge-help"].exists)
    }

    @MainActor func testEmptyEventAndOptionListsHaveHonestEmptyStates() {
        let app = XCUIApplication(); app.launchArguments = ["-empty-events"]; app.launch()
        XCTAssertTrue(app.staticTexts["這裡還沒有待選事件"].exists)
        XCTAssertFalse(app.buttons["continueLife"].exists)
        capture("empty-events")
        app.terminate(); app.launchArguments = ["-empty-options"]; app.launch()
        XCTAssertTrue(app.staticTexts["選項尚未準備好"].exists)
        XCTAssertFalse(app.buttons["choice-bridge-team"].exists)
    }

    @MainActor func testDetailsDoNotReplaceMainGameAndMapHasFiveStages() {
        let app = XCUIApplication(); app.launch()
        app.buttons["details"].tap()
        XCTAssertTrue(app.staticTexts["阿澄的起點"].exists)
        capture("profile-secondary-page")
        app.buttons["closeDetails"].tap()
        let map = app.buttons["lifeMap"]; reveal(map, in: app); map.tap()
        for stage in ["童年", "青少年", "青年", "中年", "晚年"] {
            XCTAssertTrue(app.staticTexts[stage].exists)
        }
        capture("life-map-secondary-page")
        app.buttons["closeDetails"].tap()
        XCTAssertTrue(app.buttons["choice-bridge-team"].exists)
    }

    @MainActor func testMaximumTypeCanReadCostAndSelectSecondOption() {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch(); capture("maximum-type-home")
        let help = app.buttons["choice-bridge-help"]; reveal(help, in: app)
        XCTAssertTrue(help.isHittable)
        capture("maximum-type-second-choice")
        help.tap()
        XCTAssertTrue(app.staticTexts["這次使用了 1 格精力。"].exists)
        XCTAssertTrue(app.buttons["showReason"].isHittable)
    }

    @MainActor func testOtherTwoStructureStudiesAreReviewable() {
        let app = XCUIApplication()
        for mode in ["novel", "map"] {
            app.launchArguments = ["-study-\(mode)"]; app.launch()
            XCTAssertTrue(app.staticTexts[mode == "novel" ? "第二章 · 一個新點子" : "沿著人生，找到下一個岔路。"].exists)
            capture("structure-\(mode)"); app.terminate()
        }
    }
}
