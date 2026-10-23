import XCTest

@MainActor
final class LifeCrossroadsUITests: XCTestCase {
    func testCompleteLifeWithVisibleComparisonAndExecutedExplanation() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments += ["-ui-testing", "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
        app.launch()
        let start = app.buttons["startLife"]
        XCTAssertTrue(start.waitForExistence(timeout: 10))
        reveal(start, in: app); start.tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        let compare = app.buttons["compareChoice"]
        reveal(compare, in: app); compare.tap()
        app.buttons["compare.invest"].tap()
        XCTAssertTrue(app.staticTexts["換一個環境呢？"].waitForExistence(timeout: 5))
        for name in ["日本", "美國", "印度", "肯亞"] {
            XCTAssertTrue(app.staticTexts[name].exists, "Comparison must contain actual row: \(name)")
        }
        let comparisonShot = XCTAttachment(screenshot: app.screenshot())
        comparisonShot.name = "model-comparison"; comparisonShot.lifetime = .keepAlways; add(comparisonShot)
        app.buttons["closeComparison"].tap()
        for index in 0..<15 {
            let invest = app.buttons["choice.invest"]
            XCTAssertTrue(invest.waitForExistence(timeout: 5))
            let choice = invest.isEnabled ? invest : app.buttons["choice.ask"]
            reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            if index == 0 {
                let why = app.buttons["whyResult"]
                reveal(why, in: app); why.tap()
                XCTAssertTrue(app.staticTexts["為什麼會這樣？"].waitForExistence(timeout: 5))
                app.buttons["closeTrace"].tap()
            }
            app.buttons["continueLife"].tap()
        }
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        let endingShot = XCTAttachment(screenshot: app.screenshot())
        endingShot.name = "life-review"; endingShot.lifetime = .keepAlways; add(endingShot)
    }

    private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<15 {
            if element.isHittable { return }
            if element.exists && element.frame.midY < 100 { app.swipeDown() }
            else { app.swipeUp() }
        }
        XCTAssertTrue(element.isHittable)
    }
}
