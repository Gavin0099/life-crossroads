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
                if swipe { openActionsIfNeeded(choice, app) }
                let action = swipe ? action(choice, app) : app.buttons["choice.\(choice)"]
                reveal(action, app); XCTAssertTrue(action.isEnabled); action.tap()
                XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
                XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, choice)
                if swipe { assertImmersive(app, outcome: true) }
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
            // A vertical movement on the fixed stage must not submit.
            assertImmersive(app, outcome: false)
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
        openDecisionMenu(app, expecting: "decisionUI.standard")
        app.buttons["decisionUI.standard"].tap()
        XCTAssertTrue(app.buttons["choice.offline"].waitForExistence(timeout: 5))
        XCTAssertEqual(try checksum(app), before)
        openDecisionMenu(app, expecting: "decisionUI.swipe")
        app.buttons["decisionUI.swipe"].tap()
        XCTAssertTrue(app.buttons["swipeDetails"].waitForExistence(timeout: 5))
        XCTAssertEqual(try checksum(app), before)
        XCUIDevice.shared.press(.home); app.activate()
        XCTAssertTrue(app.buttons["swipeChoice.ask"].waitForExistence(timeout: 5))
        XCTAssertEqual(try checksum(app), before)
        let ask = app.buttons["swipeChoice.ask"].firstMatch; reveal(ask, app); ask.tap()
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
        if large {
            let prompt = app.staticTexts["swipeIntent"]
            XCTAssertEqual(prompt.label, "你想從哪裡開始創作？")
            XCTAssertGreaterThan(prompt.frame.height, 80, "Maximum text must wrap, not squeeze into the old fixed card")
            XCTAssertFalse(app.staticTexts["swipeStatus"].exists, "Full buttons replace redundant swipe instructions")
        }
        if !large {
            assertImmersive(app, outcome: false)
            XCTAssertFalse(app.buttons["swipeChoice.offline"].exists)
            XCTAssertFalse(app.buttons["swipeChoice.invest"].exists)
            for id in ["ask", "rest"] {
                let button = app.buttons["swipeChoice.\(id)"]
                XCTAssertTrue(button.isHittable); XCTAssertGreaterThanOrEqual(button.frame.height, 44)
            }
            app.buttons["swipeDetails"].tap()
        }
        var titles: [String] = []
        for id in ["offline", "invest", "ask", "rest"] {
            let button = action(id, app)
            reveal(button, app)
            XCTAssertTrue(button.isHittable); XCTAssertGreaterThanOrEqual(button.frame.width, 44)
            XCTAssertGreaterThanOrEqual(button.frame.height, 44)
            XCTAssertFalse(button.label.isEmpty); titles.append(button.label)
        }
        XCTAssertEqual(try checksum(app), before)
        shot("all-actions", app)
        if large {
            let details = app.buttons["swipeDetails"]; reveal(details, app)
            XCTAssertGreaterThanOrEqual(details.frame.width, 44); XCTAssertGreaterThanOrEqual(details.frame.height, 44)
            details.tap()
        }
        XCTAssertTrue(app.buttons["closeSwipeDetails"].waitForExistence(timeout: 5))
        for title in titles { XCTAssertTrue(app.buttons[title].exists, "Full option wording remains available as an action") }
        XCTAssertTrue(app.staticTexts["swipeDigitalContext.invest"].exists)
        for id in ["offline", "ask", "rest"] {
            XCTAssertFalse(app.staticTexts["swipeDigitalContext.\(id)"].exists)
        }
        shot("preparation-details", app)
        app.buttons["closeSwipeDetails"].tap()
        XCTAssertEqual(try checksum(app), before)
        reveal(app.buttons["swipeChoice.rest"], app); app.buttons["swipeChoice.rest"].tap()
        XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "rest")
        if !large { assertImmersive(app, outcome: true) }
        shot("rest-saved", app)
        // Published result remains on this stage until explicit continuation, including after a detail visit.
        let after = try checksum(app)
        reveal(app.buttons["swipeDetails"], app); app.buttons["swipeDetails"].tap()
        XCTAssertTrue(app.buttons["closeSwipeDetails"].waitForExistence(timeout: 5)); app.buttons["closeSwipeDetails"].tap()
        XCTAssertEqual(try checksum(app), after)
        reveal(app.buttons["continueLife"], app); app.buttons["continueLife"].tap()
        XCTAssertTrue(app.buttons["skipLiving"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.otherElements["immersiveCard"].exists)
        app.terminate()
    }

    func testHeldPreviewCancellationPreservesArchive() throws {
        continueAfterFailure = false
        let app = try open(swipe: true)
        let before = try checksum(app)
        for (side, distance) in [("left", -80.0), ("right", 80.0)] {
            let frame = app.otherElements["lifeWorldScene"].frame
            let origin = app.coordinate(withNormalizedOffset: .zero)
            print("RC_PREVIEW_HOLD_\(side)"); fflush(stdout)
            origin.withOffset(CGVector(dx: frame.midX, dy: frame.midY)).press(forDuration: 0.2,
                thenDragTo: origin.withOffset(CGVector(dx: frame.midX + distance, dy: frame.midY)),
                withVelocity: .slow, thenHoldForDuration: 4)
            XCTAssertEqual(try checksum(app), before)
            XCTAssertFalse(app.staticTexts["chosenAction"].exists)
        }
        app.terminate()
    }

    func testNormalPlayOutcomeWaitsForExplicitContinuation() throws {
        continueAfterFailure = false
        let app = try open(swipe: true)
        relaunchWithoutCapture(app)
        XCTAssertTrue(app.buttons["swipeChoice.ask"].waitForExistence(timeout: 5))
        app.buttons["swipeChoice.ask"].tap()
        XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "ask")
        try assertPublishedOutcomeWaits(app)
        shot("normal-outcome-held", app)
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.buttons["skipLiving"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.otherElements["immersiveCard"].exists)
        app.terminate()
    }

    func testNormalBranchEntryOutcomeWaitsForExplicitContinuation() throws {
        continueAfterFailure = false
        let directory = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "interaction-fixtures", withExtension: nil))
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-visual-loop-capture", "-reset-save", "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
        app.launchEnvironment["LIFE_VISUAL_ARCHIVE_PATH"] = directory.appendingPathComponent("72-neighbor-before.json").path
        app.launch(); XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10)); app.buttons["resumeLife"].tap()
        // Finish the actual saved life through its two remaining decisions.
        for index in 0..<2 {
            if index > 0 {
                XCTAssertTrue(app.buttons["skipLiving"].waitForExistence(timeout: 5)); app.buttons["skipLiving"].tap()
            }
            let rest = app.buttons["choice.rest"]; reveal(rest, app); rest.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5)); app.buttons["continueLife"].tap()
        }
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        // A fresh normal launch has no capture pause. Branch creation is a separate entry
        // from a swipe: GameStore.startBranch publishes the saved 13-year outcome directly.
        relaunchWithoutCapture(app)
        let fork = app.buttons["openForkPicker"]; reveal(fork, app); fork.tap()
        let point = app.buttons["forkPoint.3"]; reveal(point, app); point.tap()
        let paper = app.buttons["forkChoice.offline"]; reveal(paper, app); paper.tap()
        XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "offline")
        try assertPublishedOutcomeWaits(app)
        shot("normal-branch-outcome-held", app)
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.buttons["skipLiving"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.otherElements["immersiveCard"].exists)
        app.terminate()
    }

    private func relaunchWithoutCapture(_ app: XCUIApplication) {
        app.terminate()
        app.launchArguments.removeAll { ["-visual-loop-capture", "-reset-save"].contains($0) }
        app.launchEnvironment.removeValue(forKey: "LIFE_VISUAL_ARCHIVE_PATH")
        app.launch(); XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10)); app.buttons["resumeLife"].tap()
    }

    private func assertPublishedOutcomeWaits(_ app: XCUIApplication) throws {
        let saved = try checksum(app)
        let disappeared = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"),
                                                     object: app.otherElements["immersiveCard"])
        disappeared.isInverted = true
        // The existing automatic outcome interval is two seconds. With capture mode removed,
        // the visible outcome and persisted bytes must survive beyond that interval.
        wait(for: [disappeared], timeout: 3.5)
        XCTAssertEqual(try checksum(app), saved)
        assertImmersive(app, outcome: true)
    }

    private func assertImmersive(_ app: XCUIApplication, outcome: Bool) {
        let card = app.otherElements["immersiveCard"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        XCTAssertEqual(app.navigationBars.count, 0)
        XCTAssertEqual(app.scrollViews.count, 0)
        let hud = app.staticTexts["immersiveHUD"].frame
        let controls = app.buttons[outcome ? "continueLife" : "swipeDetails"].frame
        let usable = controls.maxY - hud.minY
        XCTAssertGreaterThanOrEqual(card.frame.height / usable, 0.65, "Owner minimum card proportion")
        XCTAssertGreaterThan(card.frame.minY, hud.maxY)
        XCTAssertLessThanOrEqual(card.frame.maxY, controls.minY)
        XCTAssertLessThanOrEqual(controls.maxY, app.frame.maxY)
        let prompt = app.staticTexts[outcome ? "chosenAction" : "swipeIntent"].frame
        XCTAssertLessThanOrEqual(prompt.height, 58, "Normal-size prompt must remain at most two lines")
        XCTAssertFalse(app.descendants(matching: .any)["worldPlaybackControls"].exists)
        print("RC_LAYOUT outcome=\(outcome) screen=\(app.frame) hud=\(hud) card=\(card.frame) scene=\(app.otherElements["lifeWorldScene"].frame) prompt=\(prompt) controls=\(controls) ratio=\(card.frame.height / usable)")
    }
    private func openDecisionMenu(_ app: XCUIApplication, expecting actionID: String) {
        let menu = app.buttons["decisionUIMenu"]
        XCTAssertTrue(menu.waitForExistence(timeout: 5))
        let bounds = menu.frame
        if actionID == "decisionUI.standard" {
            // The new fullscreen HUD promises 44pt controls. The original UI uses
            // the system navigation toolbar, whose reported frame differs by OS.
            XCTAssertGreaterThanOrEqual(bounds.width, 44)
            XCTAssertGreaterThanOrEqual(bounds.height, 44)
        } else {
            XCTAssertGreaterThan(bounds.width, 0)
            XCTAssertGreaterThan(bounds.height, 0)
        }
        XCTAssertTrue(app.frame.contains(bounds), "Never tap an offscreen menu by coordinates")
        // iOS 18.5 reports this SwiftUI Menu's AX hit point as {-1,-1} despite a
        // visible 44pt frame. Exercise a real touch at its measured center, then
        // require the actual menu action before continuing; no synthetic store action.
        app.coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: bounds.midX, dy: bounds.midY)).tap()
        XCTAssertTrue(app.buttons[actionID].waitForExistence(timeout: 5))
        shot("menu-open-" + actionID, app)
    }
    private func action(_ id: String, _ app: XCUIApplication) -> XCUIElement {
        let sheet = app.scrollViews["swipeActionsSheet"]
        return (sheet.exists ? sheet.buttons : app.buttons)["swipeChoice.\(id)"].firstMatch
    }
    private func openActionsIfNeeded(_ id: String, _ app: XCUIApplication) {
        if !app.buttons["swipeChoice.\(id)"].exists { app.buttons["swipeDetails"].tap() }
    }

    private func open(swipe: Bool, failSave: Bool = false) throws -> XCUIApplication {
        let directory = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "interaction-fixtures", withExtension: nil))
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-visual-loop-capture", "-reset-save", "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
        if !swipe { app.launchArguments.append("-decision-ui-original") }
        if failSave { app.launchArguments += ["-ui-fail-save-at", "1"] }
        if ProcessInfo.processInfo.environment["RC_VARIANT"] == "accessible" { app.launchArguments += ["-reducedLifeMotion", "YES"] }
        app.launchEnvironment["LIFE_VISUAL_ARCHIVE_PATH"] = directory.appendingPathComponent("13-before.json").path
        app.launch(); XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10)); app.buttons["resumeLife"].tap()
        XCTAssertTrue(app.buttons["decisionUIMenu"].waitForExistence(timeout: 5))
        if swipe { XCTAssertTrue(app.buttons["swipeDetails"].waitForExistence(timeout: 5)) }
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
            let sheet = app.scrollViews["swipeActionsSheet"]
            let scroll = sheet.exists ? sheet : drawer.exists ? drawer : app.scrollViews.firstMatch
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
        let scene = app.otherElements["lifeWorldScene"]
        if scene.exists && !app.scrollViews["swipeActionsSheet"].exists {
            let crop = XCTAttachment(screenshot: scene.screenshot())
            crop.name = "rc-scene-" + name; crop.lifetime = .keepAlways; add(crop)
        }
    }
}
#endif
