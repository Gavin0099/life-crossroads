import XCTest

final class WorldGameplayTests: XCTestCase {
    @MainActor private func capture(_ name: String) {
        // Let the explicit scene/scroll transition finish before recording visual evidence.
        Thread.sleep(forTimeInterval: 1)
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }
    @MainActor private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<12 {
            let footer = app.buttons["world-records"]
            let bottom = footer.exists ? footer.frame.minY - 12 : app.frame.maxY - 28
            let visibleTop = max(element.frame.minY, 95)
            let visibleBottom = min(element.frame.maxY, bottom)
            if element.isHittable && visibleBottom - visibleTop >= min(44, element.frame.height) { return }
            if element.exists && element.frame.maxY < 95 { app.swipeDown() } else { app.swipeUp() }
        }
        XCTFail("Cannot reveal \(element.identifier)")
    }
    @MainActor private func tap(_ id: String, in app: XCUIApplication) {
        let button = app.buttons[id]
        if ["world-records", "world-people", "world-map", "close-world-detail"].contains(id) {
            button.tap(); return
        }
        reveal(button, in: app)
        let footer = app.buttons["world-records"]
        let bottom = footer.exists ? footer.frame.minY - 12 : app.frame.maxY - 28
        let top = max(button.frame.minY, 95)
        let visibleBottom = min(button.frame.maxY, bottom)
        let fraction = ((top + visibleBottom) / 2 - button.frame.minY) / button.frame.height
        button.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: fraction)).tap()
    }
    @MainActor private func top(_ app: XCUIApplication) {
        for _ in 0..<5 { app.swipeDown() }
    }
    @MainActor private func waitFor(_ value: String, id: String, in app: XCUIApplication, seconds: Double = 15) {
        let predicate = NSPredicate(format: "label CONTAINS %@", value)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: app.staticTexts[id])
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: seconds), .completed)
    }
    @MainActor private func advanceToAdult(_ app: XCUIApplication) {
        tap("world-next", in: app) // next day → first omitted year
        XCTAssertEqual(app.staticTexts["year"].label, "2028")
        XCTAssertTrue(app.staticTexts["這段沒有新增劇情紀錄"].exists)
        capture("07-time-passage")
        tap("world-speed", in: app)
        tap("world-play", in: app)
        waitFor("22 歲", id: "identity", in: app)
        XCTAssertEqual(app.staticTexts["year"].label, "2036")
        XCTAssertEqual(app.staticTexts["playback-state"].label, "已暫停")
        top(app)
    }

    @MainActor func testTeamSceneGrowsIntoAdultMemory() {
        let app = XCUIApplication(); app.launch()
        XCTAssertTrue(app.staticTexts["identity"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.otherElements["living-world"].exists)
        XCTAssertTrue(app.staticTexts["scene-state"].label.contains("家人"))
        capture("01-world-home")
        tap("world-choice-team", in: app)
        XCTAssertTrue(app.otherElements["living-world"].exists)
        XCTAssertEqual(app.staticTexts["scene-reaction"].label, "原來歪掉的地方，也可以一起修好。")
        XCTAssertTrue(app.staticTexts["scene-state"].label.contains("紙橋"))
        capture("02-team-reaction")
        tap("world-reason", in: app)
        XCTAssertTrue(app.staticTexts["把這個下午用在和朋友一起拆開重做。"].exists)
        capture("team-reason")
        tap("close-world-detail", in: app)
        tap("world-next", in: app)
        XCTAssertEqual(app.staticTexts["beat-title"].label, "小禾記得那個歪掉的地方")
        capture("03-team-next-day")
        advanceToAdult(app)
        XCTAssertTrue(app.staticTexts["scene-state"].label.contains("成年阿澄 · 紙橋"))
        capture("08-team-adult")
        tap("world-next", in: app)
        tap("world-records", in: app)
        XCTAssertTrue(app.staticTexts["紙橋上多了兩雙手"].exists)
        XCTAssertTrue(app.staticTexts["小禾記得那個歪掉的地方"].exists)
        XCTAssertTrue(app.staticTexts["那個下午，還留在這裡"].exists)
        XCTAssertFalse(app.staticTexts["老師走到桌邊"].exists)
        capture("09-team-records")
        tap("close-world-detail", in: app)
        tap("world-restart", in: app)
        tap("world-records", in: app)
        XCTAssertTrue(app.staticTexts["這段人生還沒有選擇紀錄。"].exists)
    }

    @MainActor func testHelpHasDifferentActorsObjectComparisonAndMemory() {
        let app = XCUIApplication(); app.launch()
        tap("world-choice-help", in: app)
        XCTAssertEqual(app.staticTexts["scene-reaction"].label, "還沒開始做，但我知道可以找誰幫忙了。")
        XCTAssertTrue(app.staticTexts["scene-state"].label.contains("老師來了"))
        capture("04-help-reaction-cat-teacher")
        tap("world-people", in: app)
        XCTAssertTrue(app.staticTexts["工坊老師"].exists)
        XCTAssertTrue(app.staticTexts["家人"].exists)
        capture("people-and-support")
        tap("close-world-detail", in: app)
        tap("world-comparison", in: app)
        XCTAssertTrue(app.staticTexts["你選了：向工坊老師求助"].exists)
        let end = app.staticTexts["comparison-end"]; reveal(end, in: app)
        XCTAssertLessThanOrEqual(end.frame.maxY, app.frame.maxY - 20)
        XCTAssertTrue(app.buttons["close-world-detail"].isHittable)
        capture("help-environment-comparison")
        tap("close-world-detail", in: app)
        tap("world-next", in: app)
        XCTAssertTrue(app.staticTexts["scene-state"].label.contains("家人陪你"))
        XCTAssertFalse(app.staticTexts["scene-state"].label.contains("老師來了"))
        capture("05-help-next-day")
        advanceToAdult(app)
        XCTAssertTrue(app.staticTexts["scene-state"].label.contains("借用清單成為紀念"))
        capture("10-help-adult")
        tap("world-map", in: app)
        XCTAssertTrue(app.staticTexts["老師走到桌邊"].exists)
        XCTAssertFalse(app.staticTexts["紙橋上多了兩雙手"].exists)
        capture("help-life-map")
    }

    @MainActor func testFoldGatePauseAndBackgroundFreezeTime() {
        let app = XCUIApplication(); app.launch()
        tap("toggle-event", in: app)
        XCTAssertFalse(app.buttons["world-choice-team"].exists)
        XCTAssertTrue(app.staticTexts["時間已停下，等你回來作決定。"].exists)
        XCTAssertFalse(app.buttons["world-play"].isEnabled)
        capture("world-with-event-folded")
        tap("toggle-event", in: app)
        tap("world-choice-team", in: app)
        tap("world-next", in: app)
        tap("world-next", in: app)
        tap("world-play", in: app)
        waitFor("2029", id: "year", in: app)
        tap("world-play", in: app)
        let pausedYear = app.staticTexts["year"].label
        let pause = expectation(description: "Allow timer to fire while paused")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { pause.fulfill() }
        wait(for: [pause], timeout: 5)
        XCTAssertEqual(app.staticTexts["year"].label, pausedYear)
        tap("world-play", in: app)
        tap("world-records", in: app)
        tap("close-world-detail", in: app)
        XCTAssertEqual(app.staticTexts["playback-state"].label, "已暫停")
        tap("world-play", in: app)
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertEqual(app.staticTexts["playback-state"].label, "已暫停")
        capture("paused-passage")
    }

    @MainActor func testLargestTextAndReducedMotionKeepChoiceAndDetailReachable() {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL", "-reduce-motion"]
        app.launch()
        capture("accessibility-home")
        tap("world-choice-help", in: app)
        XCTAssertEqual(app.staticTexts["beat-title"].label, "老師走到桌邊")
        XCTAssertTrue(app.otherElements["living-world"].exists)
        capture("accessibility-reaction")
        tap("world-comparison", in: app)
        let end = app.staticTexts["comparison-end"]; reveal(end, in: app)
        for _ in 0..<6 {
            if end.frame.maxY <= app.frame.maxY - 28 { break }
            app.swipeUp()
        }
        if end.frame.height < app.frame.height - 140 { XCTAssertGreaterThan(end.frame.minY, 60) }
        XCTAssertLessThanOrEqual(end.frame.maxY, app.frame.maxY - 20)
        XCTAssertTrue(app.buttons["close-world-detail"].isHittable)
        capture("accessibility-comparison-end")
        tap("close-world-detail", in: app)
        tap("world-next", in: app)
        XCTAssertEqual(app.staticTexts["beat-title"].label, "清單沒有被丟在一旁")
    }

    @MainActor func testMissingRouteDoesNotProduceLifeAndCanRestart() {
        let app = XCUIApplication(); app.launchArguments = ["-missing-route"]; app.launch()
        tap("world-choice-team", in: app)
        XCTAssertTrue(app.staticTexts["world-error"].label.contains("沒有產生人生結果"))
        XCTAssertEqual(app.staticTexts["identity"].label, "阿澄 · 13 歲")
        XCTAssertTrue(app.staticTexts["scene-state"].label.contains("家人"))
        capture("missing-route")
        tap("world-records", in: app)
        XCTAssertTrue(app.staticTexts["這段人生還沒有選擇紀錄。"].exists)
        tap("close-world-detail", in: app)
        tap("world-restart", in: app)
        tap("world-choice-help", in: app)
        XCTAssertTrue(app.staticTexts["scene-state"].label.contains("老師來了"))
    }

    @MainActor func testMissingNextRetainsLastSceneWithoutInventingYears() {
        let app = XCUIApplication(); app.launchArguments = ["-missing-next"]; app.launch()
        tap("world-choice-team", in: app)
        tap("world-next", in: app)
        XCTAssertTrue(app.staticTexts["world-error"].label.contains("不跳過缺漏內容"))
        XCTAssertEqual(app.staticTexts["year"].label, "2027")
        XCTAssertTrue(app.staticTexts["scene-state"].label.contains("紙橋"))
        XCTAssertFalse(app.buttons["world-next"].exists)
        capture("missing-next-beat")
    }
}
