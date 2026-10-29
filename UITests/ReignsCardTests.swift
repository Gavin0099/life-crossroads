import XCTest

#if VISUAL_LOOP_CAPTURE
@MainActor final class ReignsCardTests: XCTestCase {
    func testFourChoicesMatchOriginalUIAndColdRestore() throws {
        continueAfterFailure = false
        var expected: [String: String] = [:]
        for swipe in [false, true] {
            for choice in ["offline", "invest", "ask", "rest"] {
                let app = try open(swipe: swipe)
                let before = try checksum(app)
                shot("\(swipe ? "card" : "original")-\(choice)-before", app)
                let action = app.buttons["\(swipe ? "swipeChoice" : "choice").\(choice)"]
                reveal(action, app); XCTAssertTrue(action.isEnabled); action.tap()
                XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
                XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, choice)
                XCTAssertFalse(app.buttons["decisionUIMenu"].exists)
                let after = try checksum(app)
                XCTAssertNotEqual(before, after)
                if !swipe { expected[choice] = after }
                else { XCTAssertEqual(after, expected[choice], "Card and original UI must save identical bytes") }
                if choice == "ask" { XCTAssertTrue(app.otherElements["lifeWorldScene"].label.contains("尚未確認協助安排")) }
                shot("\(swipe ? "card" : "original")-\(choice)-saved", app)
                print("RC_SAVED ui=\(swipe ? "card" : "original") choice=\(choice) before=\(before) after=\(after)")
                app.terminate(); app.launchArguments.removeAll { $0 == "-reset-save" }
                app.launchEnvironment.removeValue(forKey: "LIFE_VISUAL_ARCHIVE_PATH")
                app.launch(); XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10)); app.buttons["resumeLife"].tap()
                XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
                XCTAssertEqual(try checksum(app), after)
                XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, choice)
                app.terminate()
            }
        }
        XCTAssertEqual(Set(expected.values).count, 4)
    }

    func testRealSwipeDirectionsCancelAndVerticalScroll() throws {
        continueAfterFailure = false
        for (distance, choice) in [(-125.0, "offline"), (125.0, "invest")] {
            let app = try open(swipe: true)
            let before = try checksum(app)
            drag(app, x: 45, y: 0)
            XCTAssertEqual(try checksum(app), before); XCTAssertFalse(app.staticTexts["chosenAction"].exists)
            XCTAssertEqual(app.staticTexts["swipeStatus"].label, "已取消，還沒有做決定。")
            shot("cancelled", app)
            drag(app, x: 15, y: -60)
            XCTAssertEqual(try checksum(app), before); XCTAssertFalse(app.staticTexts["chosenAction"].exists)
            app.swipeDown() // Restore the card after a real vertical scroll.
            drag(app, x: distance, y: 0)
            XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
            XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, choice)
            shot("swipe-\(choice)-saved", app)
            app.terminate()
        }
    }

    func testFailedSaveBackgroundModeSwitchAndRetryPreserveOriginal() throws {
        continueAfterFailure = false
        let app = try open(swipe: true, failSave: true)
        let before = try checksum(app)
        app.buttons["decisionUIMenu"].tap(); app.buttons["decisionUI.standard"].tap()
        XCTAssertEqual(try checksum(app), before)
        app.buttons["decisionUIMenu"].tap(); app.buttons["decisionUI.swipe"].tap()
        XCTAssertEqual(try checksum(app), before)
        XCUIDevice.shared.press(.home); app.activate()
        XCTAssertTrue(app.buttons["swipeChoice.ask"].waitForExistence(timeout: 5))
        XCTAssertEqual(try checksum(app), before)
        let ask = app.buttons["swipeChoice.ask"]; reveal(ask, app); ask.tap()
        let alert = app.alerts["需要留意"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5)); shot("save-failed", app)
        alert.buttons["知道了"].tap()
        XCTAssertEqual(try checksum(app), before)
        XCTAssertFalse(app.staticTexts["chosenAction"].exists)
        XCTAssertTrue(app.otherElements["lifeWorldScene"].label.contains("尚未決定"))
        XCTAssertEqual(app.staticTexts["swipeStatus"].label, "尚未保存；可以再試一次。")
        ask.tap()
        XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "ask")
        XCTAssertNotEqual(try checksum(app), before)
        shot("retry-saved", app); app.terminate()
    }

    func testFirstScreenAndAllButtonAlternativesAccessible() throws {
        continueAfterFailure = false
        let app = try open(swipe: true)
        let before = try checksum(app)
        shot("first-screen", app)
        let large = ProcessInfo.processInfo.environment["RC_VARIANT"] == "accessible"
        let first = app.buttons["swipeChoice.offline"]
        if !large { XCTAssertTrue(first.isHittable); XCTAssertLessThan(first.frame.maxY, app.frame.maxY) }
        var titles: [String] = []
        for id in ["offline", "invest", "ask", "rest"] {
            let button = app.buttons["swipeChoice.\(id)"]
            reveal(button, app)
            XCTAssertTrue(button.isHittable); XCTAssertGreaterThanOrEqual(button.frame.width, 44)
            XCTAssertGreaterThanOrEqual(button.frame.height, 44)
            XCTAssertFalse(button.label.isEmpty); titles.append(button.label)
        }
        XCTAssertEqual(try checksum(app), before)
        shot("all-actions", app)
        let details = app.buttons["swipeDetails"]; reveal(details, app)
        XCTAssertGreaterThanOrEqual(details.frame.width, 44); XCTAssertGreaterThanOrEqual(details.frame.height, 44)
        details.tap(); XCTAssertTrue(app.buttons["closeSwipeDetails"].waitForExistence(timeout: 5))
        for title in titles { XCTAssertTrue(app.staticTexts[title].exists, "Full option wording remains readable") }
        XCTAssertTrue(app.staticTexts["swipeDigitalContext.invest"].exists)
        for id in ["offline", "ask", "rest"] {
            XCTAssertFalse(app.staticTexts["swipeDigitalContext.\(id)"].exists, "Paper/help/rest do not require the digital preparation story")
        }
        shot("preparation-details", app)
        app.buttons["closeSwipeDetails"].tap()
        XCTAssertEqual(try checksum(app), before)
        reveal(app.buttons["swipeChoice.rest"], app); app.buttons["swipeChoice.rest"].tap()
        XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "rest")
        shot("rest-saved", app); app.terminate()
    }

    private func open(swipe: Bool, failSave: Bool = false) throws -> XCUIApplication {
        let directory = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "interaction-fixtures", withExtension: nil))
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-visual-loop-capture", "-reset-save", "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
        if swipe { app.launchArguments.append("-decision-ui-swipe") }
        if failSave { app.launchArguments += ["-ui-fail-save-at", "1"] }
        if ProcessInfo.processInfo.environment["RC_VARIANT"] == "accessible" { app.launchArguments += ["-reducedLifeMotion", "YES"] }
        app.launchEnvironment["LIFE_VISUAL_ARCHIVE_PATH"] = directory.appendingPathComponent("13-before.json").path
        app.launch(); XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10)); app.buttons["resumeLife"].tap()
        XCTAssertTrue(app.buttons["decisionUIMenu"].waitForExistence(timeout: 5))
        if swipe { XCTAssertTrue(app.buttons["swipeChoice.offline"].waitForExistence(timeout: 5)) }
        return app
    }
    private func drag(_ app: XCUIApplication, x: Double, y: Double) {
        let frame = app.otherElements["lifeWorldScene"].frame
        let origin = app.coordinate(withNormalizedOffset: .zero)
        let start = origin.withOffset(CGVector(dx: frame.midX, dy: frame.midY))
        let end = origin.withOffset(CGVector(dx: frame.midX + x, dy: frame.midY + y))
        start.press(forDuration: 0.15, thenDragTo: end)
    }
    // Use actual scroll/footer bounds: XCTest can report an offscreen original option as hittable.
    private func reveal(_ element: XCUIElement, _ app: XCUIApplication) {
        for _ in 0..<24 {
            let drawer = app.scrollViews["worldDecisionDrawer"]
            let scroll = drawer.exists ? drawer : app.scrollViews.firstMatch
            let footer = app.descendants(matching: .any).matching(identifier: "worldPlaybackControls").firstMatch
            let top = max(app.frame.minY + 90, scroll.exists ? scroll.frame.minY + 8 : 90)
            let bottom = min(footer.exists ? footer.frame.minY - 8 : app.frame.maxY - 24,
                             scroll.exists ? scroll.frame.maxY - 8 : app.frame.maxY - 24)
            if element.exists && element.isHittable && element.frame.midY > top && element.frame.midY < bottom { return }
            let height = max(44, bottom - top)
            let distance = element.exists ? element.frame.midY - (top + bottom) / 2 : height
            let delta = min(height * 0.5, max(-height * 0.5, distance))
            let startY = top + height * (delta >= 0 ? 0.78 : 0.22)
            let origin = app.coordinate(withNormalizedOffset: .zero)
            origin.withOffset(CGVector(dx: app.frame.midX, dy: startY)).press(forDuration: 0.05,
                thenDragTo: origin.withOffset(CGVector(dx: app.frame.midX, dy: startY - delta)),
                withVelocity: .slow, thenHoldForDuration: 0.2)
        }
        shot("unreachable-" + element.identifier, app)
        XCTFail("Could not reveal unobscured action: \(element.identifier)")
    }
    private func checksum(_ app: XCUIApplication) throws -> String {
        let value = try XCTUnwrap(app.staticTexts["uiTestArchiveChecksum"].value as? String)
        XCTAssertEqual(value.count, 64); return value
    }
    private func shot(_ name: String, _ app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "rc-" + name; attachment.lifetime = .keepAlways; add(attachment)
    }
}
#endif
