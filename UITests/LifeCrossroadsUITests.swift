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
        attachScreenshot("birth-scene", app: app)
        let context = app.staticTexts["countryStageBoundary"]
        reveal(context, in: app)
        XCTAssertTrue(context.label.contains("不是"))
        attachScreenshot("country-context", app: app)
        reveal(start, in: app); start.tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        attachScreenshot("decision-scene", app: app)
        let compare = app.buttons["compareChoice"]
        reveal(compare, in: app); compare.tap()
        app.buttons["compare.invest"].tap()
        XCTAssertTrue(app.staticTexts["換一個環境呢？"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["comparisonChoiceTitle"].exists)
        XCTAssertEqual(app.staticTexts["comparisonChoiceTitle"].value as? String, "invest")
        XCTAssertEqual(app.staticTexts["comparisonCostExplanation"].value as? String, "same")
        XCTAssertTrue(app.staticTexts["digitalComparisonInvitation"].exists)
        for name in ["日本", "美國", "印度", "肯亞"] {
            XCTAssertTrue(app.staticTexts[name].exists, "Comparison must contain actual row: \(name)")
        }
        let comparisonShot = XCTAttachment(screenshot: app.screenshot())
        comparisonShot.name = "model-comparison"; comparisonShot.lifetime = .keepAlways; add(comparisonShot)
        app.buttons["closeComparison"].tap()
        for index in 0..<15 {
            XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
            if index == 3 {
                XCTAssertTrue(app.staticTexts["digitalLearningGuide"].exists)
                for (choiceID, expectation) in [("invest", "different"), ("offline", "same")] {
                    reveal(compare, in: app); compare.tap()
                    app.buttons["compare.\(choiceID)"].tap()
                    let explanation = app.staticTexts["comparisonCostExplanation"]
                    XCTAssertTrue(explanation.waitForExistence(timeout: 5))
                    XCTAssertEqual(explanation.value as? String, expectation)
                    attachScreenshot("teen-comparison-\(choiceID)", app: app)
                    app.buttons["closeComparison"].tap()
                }
            }
            let choice = try XCTUnwrap(["leadWorkshop", "shareShift", "invest", "offline", "ask", "rest"].map { app.buttons["choice.\($0)"] }
                .first { $0.exists && $0.isEnabled }, "Each actual story variant must offer a feasible choice")
            reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            if index == 0 {
                let budget = app.staticTexts["roundBudgetExplanation"]
                reveal(budget, in: app)
                XCTAssertTrue(budget.label.contains("不會累積"))
                attachScreenshot("reflection-scene", app: app)
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

    func testRestComparisonAndExplanationUseTheActualChoice() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments += ["-ui-testing", "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
        app.launch()
        let start = app.buttons["startLife"]
        XCTAssertTrue(start.waitForExistence(timeout: 10))
        reveal(start, in: app); start.tap()
        let compare = app.buttons["compareChoice"]
        reveal(compare, in: app); compare.tap()
        app.buttons["compare.rest"].tap()
        let comparedChoice = app.staticTexts["comparisonChoiceTitle"]
        XCTAssertTrue(comparedChoice.waitForExistence(timeout: 5))
        XCTAssertFalse(comparedChoice.label.isEmpty)
        XCTAssertEqual(comparedChoice.value as? String, "rest")
        app.buttons["closeComparison"].tap()
        let rest = app.buttons["choice.rest"]
        reveal(rest, in: app); rest.tap()
        let why = app.buttons["whyResult"]
        reveal(why, in: app); why.tap()
        let actual = app.staticTexts["actualInfluences"]
        if !actual.waitForExistence(timeout: 5) {
            print("WHY_PRESENTATION_FAILURE\n\(app.debugDescription)")
            let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("pr2-why-failure.png")
            try app.screenshot().pngRepresentation.write(to: path)
            print("WHY_SCREENSHOT_PATH=\(path.path)")
            XCTFail("The executed explanation must be visible")
        }
        XCTAssertTrue(actual.label.contains("你的選擇"))
        for absent in ["環境條件", "他人的協助", "機會事件", "家庭安排"] {
            XCTAssertFalse(actual.label.contains(absent), "Rest must not imply unused cause: \(absent)")
        }
        let dataUsage = app.staticTexts["dataUsage"]
        reveal(dataUsage, in: app)
        XCTAssertTrue(dataUsage.label.contains("未使用"))
        attachScreenshot("rest-actual-influences", app: app)
    }

    private func attachScreenshot(_ name: String, app: XCUIApplication) {
        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = name; shot.lifetime = .keepAlways; add(shot)
    }

    private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<15 {
            let bottomClearance: CGFloat = app.buttons["continueLife"].exists && !app.buttons["closeTrace"].exists ? 110 : 24
            if element.isHittable && element.frame.midY > 100 && element.frame.midY < app.frame.maxY - bottomClearance { return }
            if element.exists && element.frame.midY < 100 { app.swipeDown() }
            else { app.swipeUp() }
        }
        XCTFail("Could not reveal an unobscured tap target: \(element.identifier)")
    }
}
