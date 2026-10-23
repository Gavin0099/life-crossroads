import XCTest

final class VisualPreviewTests: XCTestCase {
    @MainActor private func capture(_ name: String) {
        let shot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        shot.name = name
        shot.lifetime = .keepAlways
        add(shot)
    }

    @MainActor private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<8 {
            if element.isHittable { return }
            app.swipeUp()
        }
    }

    @MainActor func testBothDirectionsChoiceFeedbackAndComparison() {
        for style in ["A", "B"] {
            let app = XCUIApplication()
            app.launchArguments = style == "B" ? ["-midnight"] : []
            app.launch()
            XCTAssertTrue(app.staticTexts["把想像，做出來。"].waitForExistence(timeout: 5))
            capture("\(style)-event")
            let choice = app.buttons["choice-team"]
            reveal(choice, in: app)
            choice.tap()
            XCTAssertTrue(app.staticTexts["你們完成第一個模型，也發現一個需要重做的地方。"].waitForExistence(timeout: 3))
            XCTAssertTrue(app.staticTexts["精力使用 2 格"].exists)
            capture("\(style)-feedback")
            let why = app.buttons["showWhy"]
            reveal(why, in: app); why.tap()
            XCTAssertTrue(app.staticTexts["示範因素 · 非真實 Trace"].exists)
            capture("\(style)-why")
            app.buttons["compare"].tap()
            XCTAssertTrue(app.staticTexts["日本 · 示範家庭 A"].exists)
            XCTAssertTrue(app.staticTexts["肯亞 · 示範家庭 B"].exists)
            capture("\(style)-compare")
            app.buttons["reset"].tap()
            XCTAssertTrue(app.buttons["choice-help"].exists)
            app.terminate()
        }
    }

    @MainActor func testHelpChoiceHasDistinctObservableOutcome() {
        let app = XCUIApplication(); app.launch()
        let help = app.buttons["choice-help"]
        reveal(help, in: app); help.tap()
        XCTAssertTrue(app.staticTexts["老師幫你列出可借的材料。你還沒報名，卻多了一條準備路線。"].exists)
        XCTAssertTrue(app.staticTexts["精力使用 1 格"].exists)
        XCTAssertFalse(app.staticTexts["精力使用 2 格"].exists)
    }

    @MainActor func testMissingTraceNeverInventsReasons() {
        let app = XCUIApplication(); app.launchArguments = ["-missing-evidence"]; app.launch()
        let choice = app.buttons["choice-team"]
        reveal(choice, in: app); choice.tap()
        let why = app.buttons["showWhy"]
        reveal(why, in: app); why.tap()
        XCTAssertTrue(app.staticTexts["目前沒有原因紀錄"].exists)
        XCTAssertFalse(app.staticTexts["示範因素 · 非真實 Trace"].exists)
        capture("missing-trace")
    }

    @MainActor func testLargestTypeKeepsChoicesReachable() {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        capture("accessibility-XXXL-top")
        let help = app.buttons["choice-help"]
        reveal(help, in: app)
        XCTAssertTrue(help.isHittable)
        capture("accessibility-XXXL-choice")
        help.tap()
        XCTAssertTrue(app.staticTexts["老師幫你列出可借的材料。你還沒報名，卻多了一條準備路線。"].exists)
    }
}
