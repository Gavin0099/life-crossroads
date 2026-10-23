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

    @MainActor private func assertState(_ text: String, in app: XCUIApplication) {
        XCTAssertTrue(app.staticTexts["flowState"].label.contains(text))
    }

    @MainActor private func revealComparisonEnd(in app: XCUIApplication) {
        let last = app.staticTexts["comparisonLastLine"]
        let next = app.buttons["continueLife"]
        for _ in 0..<20 {
            if last.exists && last.frame.minY >= 25 && last.frame.maxY <= next.frame.minY - 10 { break }
            app.scrollViews.firstMatch.swipeUp()
        }
        XCTAssertTrue(last.isHittable)
        XCTAssertGreaterThanOrEqual(last.frame.minY, 25, "Last paragraph must be fully below the top safe area")
        XCTAssertLessThanOrEqual(last.frame.maxY, next.frame.minY - 10, "Entire last paragraph must clear the fixed footer")
        XCTAssertTrue(next.isHittable)
    }

    @MainActor func testChoiceToOutcomeReasonCompareAndNextEvent() {
        let app = XCUIApplication(); app.launch()
        XCTAssertTrue(app.staticTexts["你會怎麼做？"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["choice-bridge-team"].isHittable)
        assertState("等待你的選擇", in: app)
        capture("01-home-event-first")
        let team = app.buttons["choice-bridge-team"]; reveal(team, in: app); team.tap()
        XCTAssertTrue(app.staticTexts["先一起試一次。"].exists)
        XCTAssertTrue(app.staticTexts["這次使用了 2 格精力。"].exists)
        assertState("看看選擇留下了什麼", in: app)
        XCTAssertEqual(app.buttons["continueLife"].label, "前往 15 歲的岔路")
        XCTAssertEqual(app.staticTexts["characterReaction"].label, "「原來歪掉的地方，也可以一起修好。」")
        capture("02-outcome")
        reveal(app.staticTexts["故事的下一條線 · 還沒發生"], in: app)
        XCTAssertTrue(app.staticTexts["下次還想一起做作品嗎？朋友還沒有和你約好時間。"].exists)
        capture("team-changes-and-foreshadow")
        app.buttons["showReason"].tap()
        assertState("正在回看原因", in: app)
        XCTAssertTrue(app.staticTexts["你選擇先做簡易作品。"].exists)
        XCTAssertFalse(app.staticTexts["運氣"].exists)
        capture("03-reason")
        app.buttons["showComparison"].tap()
        assertState("正在比較環境", in: app)
        XCTAssertTrue(app.staticTexts["日本 · 示範家庭 A"].exists)
        XCTAssertTrue(app.staticTexts["肯亞 · 示範家庭 B"].exists)
        XCTAssertTrue(app.staticTexts["朋友能帶紙材，工作桌需預約"].exists)
        XCTAssertFalse(app.staticTexts["老師提供社區工具目錄；仍需自行預約"].exists)
        capture("04-comparison")
        revealComparisonEnd(in: app)
        capture("comparison-last-line-visible")
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.staticTexts["阿澄・15 歲"].exists)
        XCTAssertTrue(app.staticTexts["放學後，留一點空間。"].exists)
        XCTAssertFalse(app.staticTexts["先一起試一次。"].exists)
        let reminder = app.staticTexts["continuationTitle"]; reveal(reminder, in: app)
        XCTAssertEqual(reminder.label, "那座一起重做的紙橋")
        capture("05-next-event")
        app.swipeDown()
        let rest = app.buttons["choice-time-rest"]; reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.staticTexts["留一點，給自己。"].exists)
        XCTAssertEqual(app.buttons["continueLife"].label, "查看本段回顧")
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.staticTexts["你的選擇，有跡可循。"].exists)
        assertState("本段旅程完成", in: app)
        capture("06-review")
        app.buttons["restart"].tap()
        XCTAssertTrue(app.staticTexts["阿澄・13 歲"].exists)
        XCTAssertTrue(app.buttons["choice-bridge-team"].exists)
        XCTAssertFalse(app.staticTexts["continuationTitle"].exists)
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
        XCTAssertEqual(app.staticTexts["characterReaction"].label, "「還沒開始做，但我知道可以找誰幫忙了。」")
        capture("help-reaction")
        reveal(app.staticTexts["故事的下一條線 · 還沒發生"], in: app)
        capture("help-changes-and-foreshadow")
        app.buttons["showReason"].tap(); app.buttons["showComparison"].tap()
        XCTAssertTrue(app.staticTexts["老師提供社區工具目錄；仍需自行預約"].exists)
        XCTAssertFalse(app.staticTexts["朋友能帶紙材，工作桌需預約"].exists)
        capture("help-comparison")
        app.buttons["continueLife"].tap()
        let reminder = app.staticTexts["continuationTitle"]; reveal(reminder, in: app)
        XCTAssertEqual(reminder.label, "那張借用工具清單")
        XCTAssertFalse(app.staticTexts["那座一起重做的紙橋"].exists)
        capture("help-next-event")
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
        XCTAssertTrue(app.staticTexts["尚未留下選擇紀錄"].exists)
        capture("life-map-secondary-page")
        app.buttons["closeDetails"].tap()
        XCTAssertTrue(app.buttons["choice-bridge-team"].exists)
        let team = app.buttons["choice-bridge-team"]; if !team.isHittable { app.swipeDown() }; team.tap()
        app.buttons["continueLife"].tap()
        let nextMap = app.buttons["lifeMap"]; reveal(nextMap, in: app); nextMap.tap()
        XCTAssertTrue(app.staticTexts["你選了：和朋友做簡易作品"].exists)
        XCTAssertFalse(app.staticTexts["你選了：先留一點休息空間"].exists)
        capture("map-completed-choice")
        app.buttons["closeDetails"].tap()
        let rest = app.buttons["choice-time-rest"]; if !rest.isHittable { app.swipeDown() }; rest.tap()
        app.buttons["continueLife"].tap()
        app.buttons["details"].tap()
        // Use the menu in this sheet to reach the map after completion.
        app.buttons["人生資料、人物與家庭"].tap(); app.buttons["人生地圖"].tap()
        XCTAssertTrue(app.staticTexts["你選了：和朋友做簡易作品"].exists)
        XCTAssertTrue(app.staticTexts["你選了：先留一點休息空間"].exists)
        capture("map-two-completed-choices")
        app.buttons["closeDetails"].tap(); app.buttons["restart"].tap()
        reveal(app.buttons["lifeMap"], in: app); app.buttons["lifeMap"].tap()
        XCTAssertTrue(app.staticTexts["尚未留下選擇紀錄"].exists)
        XCTAssertFalse(app.staticTexts["你選了：和朋友做簡易作品"].exists)
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
            XCTAssertTrue(app.staticTexts["staticStudyNotice"].isHittable)
            XCTAssertFalse(app.buttons["choice-bridge-team"].exists)
            XCTAssertFalse(app.buttons["進入目前岔路"].exists)
            capture("structure-\(mode)"); app.terminate()
        }
    }

    @MainActor func testMaximumTypeComparisonLastParagraphClearsFooter() {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        let team = app.buttons["choice-bridge-team"]; reveal(team, in: app); team.tap()
        app.buttons["showReason"].tap(); app.buttons["showComparison"].tap()
        revealComparisonEnd(in: app)
        capture("maximum-type-comparison-end")
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.staticTexts["阿澄・15 歲"].exists)
    }

    @MainActor func testMissingComparisonDoesNotBorrowAnotherChoice() {
        let app = XCUIApplication(); app.launchArguments = ["-missing-comparison"]; app.launch()
        let team = app.buttons["choice-bridge-team"]; reveal(team, in: app); team.tap()
        app.buttons["showReason"].tap(); app.buttons["showComparison"].tap()
        XCTAssertTrue(app.staticTexts["此事件尚無可比環境資料"].exists)
        XCTAssertFalse(app.staticTexts["日本 · 示範家庭 A"].exists)
        capture("missing-comparison")
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.staticTexts["阿澄・15 歲"].exists)
    }
}
