import XCTest

@MainActor
final class LifeCrossroadsUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testCompleteLifeWithVisibleComparisonAndExecutedExplanation() throws {
        let app = launch(seed: "0")
        attachScreenshot("event-first-birth", app: app)
        let contextToggle = app.descendants(matching: .any).matching(identifier: "countryContextToggle").firstMatch
        reveal(contextToggle, in: app); contextToggle.tap()
        let context = app.staticTexts["countryStageBoundary"]
        reveal(context, in: app)
        XCTAssertTrue(context.label.contains("不是"))
        for indicator in ["IT.NET.USER.ZS", "EG.ELC.ACCS.ZS"] {
            XCTAssertTrue(app.descendants(matching: .any).matching(identifier: "countryIndicator.\(indicator)").firstMatch.exists)
        }
        attachScreenshot("country-context", app: app)
        reveal(contextToggle, in: app); contextToggle.tap()
        start(app)
        let first = app.buttons["choice.invest"]
        XCTAssertTrue(first.exists)
        XCTAssertLessThan(first.frame.minY, app.frame.maxY - 48, "An action must enter the first screen after the short story")
        attachScreenshot("event-first-decision", app: app)
        openComparison("invest", in: app)
        XCTAssertEqual(app.staticTexts["comparisonCostExplanation"].value as? String, "same")
        XCTAssertTrue(app.staticTexts["digitalComparisonInvitation"].exists)
        for country in ["日本", "美國", "印度", "肯亞"] { XCTAssertTrue(app.staticTexts[country].exists) }
        attachScreenshot("model-comparison", app: app)
        app.buttons["closeComparison"].tap()

        var eventIDs: [String] = []
        for index in 0..<15 {
            let title = app.staticTexts["eventTitle"]
            XCTAssertTrue(title.waitForExistence(timeout: 5))
            eventIDs.append(try XCTUnwrap(title.value as? String))
            if index == 3 {
                XCTAssertTrue(app.staticTexts["digitalLearningGuide"].exists)
                for (choiceID, expected) in [("invest", "different"), ("offline", "same")] {
                    openComparison(choiceID, in: app)
                    XCTAssertEqual(app.staticTexts["comparisonCostExplanation"].value as? String, expected)
                    attachScreenshot("teen-comparison-\(choiceID)", app: app)
                    app.buttons["closeComparison"].tap()
                }
            }
            let choice = try policyChoice(in: app)
            let selectedID = String(choice.identifier.dropFirst("choice.".count))
            reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, selectedID)
            if index == 0 {
                let budget = app.staticTexts["roundBudgetExplanation"]
                reveal(budget, in: app)
                XCTAssertTrue(budget.label.contains("不會累積"))
                attachScreenshot("event-first-outcome", app: app)
                openReason(in: app)
                XCTAssertTrue(app.staticTexts["actualInfluences"].label.contains("你的選擇"))
                app.buttons["closeTrace"].tap()
            }
            if [3, 10, 13].contains(index) { attachScreenshot("life-stage-\(index)", app: app) }
            app.buttons["continueLife"].tap()
        }
        XCTAssertEqual(eventIDs.count, 15)
        XCTAssertEqual(Set(eventIDs).count, 15)
        print("UI_EVENT_SEQUENCE_SEED_0=\(eventIDs.joined(separator: ","))")
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["endingSeed"].value as? String, "0")
        XCTAssertTrue(app.buttons["replaySame"].exists)
        let newSeed = app.buttons["replayNewSeed"]
        XCTAssertTrue(newSeed.exists)
        attachScreenshot("event-first-life-review", app: app)
        reveal(newSeed, in: app); newSeed.tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        let changedSeed = try XCTUnwrap(app.staticTexts["lifeSeed"].value as? String)
        XCTAssertNotEqual(changedSeed, "0")
        app.buttons["restartMenu"].tap()
        app.buttons["restartSame"].tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["lifeSeed"].value as? String, changedSeed)
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, eventIDs.first)
    }

    func testRestAfterChoiceComparisonKeepsThePreChoiceState() throws {
        let app = launch(seed: "0")
        start(app)
        let rest = app.buttons["choice.rest"]
        reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "rest")
        let comparison = app.buttons["compareChosen"]
        reveal(comparison, in: app); comparison.tap()
        let selected = app.staticTexts["comparisonChoiceTitle"]
        XCTAssertTrue(selected.waitForExistence(timeout: 5))
        XCTAssertEqual(selected.value as? String, "rest")
        // Reviewed family-one fixture: rest raises health from 66 to 68. Comparison must use 66.
        XCTAssertEqual(app.staticTexts["comparisonPreState"].value as? String,
                       "health=66;financial=35;relationships=65;skills=20")
        XCTAssertEqual(app.staticTexts["comparisonCostExplanation"].value as? String, "same")
        attachScreenshot("post-choice-comparison-pre-state", app: app)
        app.buttons["closeComparison"].tap()
        openReason(in: app)
        let actual = app.staticTexts["actualInfluences"]
        XCTAssertTrue(actual.label.contains("你的選擇"))
        for absent in ["環境條件", "他人的協助", "機會事件", "家庭安排"] {
            XCTAssertFalse(actual.label.contains(absent), "Rest must not imply an unused cost/resource cause: \(absent)")
        }
        let usage = app.staticTexts["dataUsage"]
        reveal(usage, in: app)
        XCTAssertTrue(usage.label.contains("未使用"))
        attachScreenshot("rest-actual-influences", app: app)
    }

    func testSeedZeroOneTwoShowActualSelectedEvents() throws {
        var prefixes: [[String]] = []
        for seed in ["0", "1", "2"] {
            let app = launch(seed: seed)
            start(app)
            var events: [String] = []
            for index in 0..<3 {
                let title = app.staticTexts["eventTitle"]
                XCTAssertTrue(title.waitForExistence(timeout: 5))
                events.append(try XCTUnwrap(title.value as? String))
                if index == 2 {
                    attachScreenshot("seed-\(seed)-actual-twelve-year-event", app: app)
                    let details = app.descendants(matching: .any).matching(identifier: "eventSelectionDetails").firstMatch
                    reveal(details, in: app); details.tap()
                    let summary = app.staticTexts["eventSelectionSummary"]
                    XCTAssertTrue(summary.waitForExistence(timeout: 5))
                    XCTAssertTrue(summary.label.contains("12歲"))
                    if events.last == "child-library-map" {
                        let condition = app.staticTexts["selectedCondition.nearby-guide"]
                        XCTAssertTrue(condition.exists)
                        XCTAssertTrue(condition.label.contains("實際為2"))
                        XCTAssertTrue(condition.label.contains("至少1"))
                    }
                    attachScreenshot("seed-\(seed)-executed-selection-conditions", app: app)
                    break
                }
                let choice = try policyChoice(in: app)
                reveal(choice, in: app); choice.tap()
                XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
                app.buttons["continueLife"].tap()
            }
            XCTAssertEqual(app.staticTexts["lifeSeed"].value as? String, seed)
            prefixes.append(events)
            print("UI_EVENT_PREFIX_SEED_\(seed)=\(events.joined(separator: ","))")
            app.terminate()
        }
        // A short UI prefix need not differ for every pair. Domain/CLI verify all three complete lives.
        XCTAssertGreaterThan(Set(prefixes.map { $0.joined(separator: ",") }).count, 1)
    }

    func testMaximumTextCanReachActionsReasonComparisonAndContinue() throws {
        let app = launch(seed: "0", largestText: true)
        XCTAssertFalse(app.segmentedControls["countryPicker"].exists, "Accessibility text sizes must use the readable menu picker")
        attachScreenshot("maximum-text-birth", app: app)
        start(app)
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        attachScreenshot("maximum-text-event-first", app: app)
        let rest = app.buttons["choice.rest"]
        reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        openReason(in: app)
        XCTAssertTrue(app.staticTexts["actualInfluences"].label.contains("你的選擇"))
        attachScreenshot("maximum-text-reason", app: app)
        app.buttons["closeTrace"].tap()
        let comparison = app.buttons["compareChosen"]
        reveal(comparison, in: app); comparison.tap()
        let selected = app.staticTexts["comparisonChoiceTitle"]
        XCTAssertTrue(selected.waitForExistence(timeout: 5))
        XCTAssertEqual(selected.value as? String, "rest")
        attachScreenshot("maximum-text-comparison", app: app)
        app.buttons["closeComparison"].tap()
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "child-friend")
    }

    func testInvalidDevelopmentSeedDoesNotStartALife() {
        let app = launch(seed: "invalid")
        let start = app.buttons["startLife"]
        reveal(start, in: app); start.tap()
        XCTAssertTrue(app.alerts["需要留意"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.alerts.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "測試種子格式錯誤")).firstMatch.exists)
        XCTAssertFalse(app.staticTexts["eventTitle"].exists)
    }

    private func launch(seed: String, largestText: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-ui-testing", "-life-seed", seed,
                                "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
        if largestText {
            app.launchArguments += ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        }
        app.launch()
        XCTAssertTrue(app.buttons["startLife"].waitForExistence(timeout: 10))
        return app
    }

    private func start(_ app: XCUIApplication) {
        let button = app.buttons["startLife"]
        reveal(button, in: app); button.tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
    }

    private func policyChoice(in app: XCUIApplication) throws -> XCUIElement {
        // Same declared policy as the CLI evidence; no UI-side event selection.
        try XCTUnwrap(["invest", "ask", "rest"].map { app.buttons["choice.\($0)"] }
            .first { $0.exists && $0.isEnabled }, "Every selected event must retain a feasible policy action")
    }

    private func openComparison(_ choiceID: String, in app: XCUIApplication) {
        let button = app.buttons["compareChoice"]
        reveal(button, in: app); button.tap()
        app.buttons["compare.\(choiceID)"].tap()
        let selected = app.staticTexts["comparisonChoiceTitle"]
        XCTAssertTrue(selected.waitForExistence(timeout: 5))
        XCTAssertEqual(selected.value as? String, choiceID)
    }

    private func openReason(in app: XCUIApplication) {
        let button = app.buttons["whyResult"]
        reveal(button, in: app); button.tap()
        if !app.staticTexts["actualInfluences"].waitForExistence(timeout: 5) {
            print("WHY_PRESENTATION_FAILURE\n\(app.debugDescription)")
            attachScreenshot("why-presentation-failure", app: app)
            XCTFail("The executed explanation must be visible")
        }
    }

    private func attachScreenshot(_ name: String, app: XCUIApplication) {
        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = name; shot.lifetime = .keepAlways; add(shot)
    }

    private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<32 {
            let footer = app.buttons["continueLife"].exists && !app.buttons["closeTrace"].exists && !app.buttons["closeComparison"].exists
            let bottomClearance: CGFloat = footer ? 110 : 24
            if element.exists && element.isHittable && element.frame.midY > 100 && element.frame.midY < app.frame.maxY - bottomClearance { return }
            let upper = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.38))
            let lower = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.65))
            if element.exists && element.frame.midY < 100 { upper.press(forDuration: 0.05, thenDragTo: lower) }
            else { lower.press(forDuration: 0.05, thenDragTo: upper) }
        }
        attachScreenshot("unrevealed-\(element.identifier)", app: app)
        XCTFail("Could not reveal an unobscured tap target: \(element.identifier); exists=\(element.exists)")
    }
}
