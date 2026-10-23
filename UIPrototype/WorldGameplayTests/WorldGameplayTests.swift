import XCTest

final class WorldGameplayTests: XCTestCase {
    @MainActor private func capture(_ name: String) {
        // Let the explicit scene/scroll transition finish before recording visual evidence.
        Thread.sleep(forTimeInterval: 1)
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }
    @MainActor private func contentViewport(in app: XCUIApplication) -> CGRect {
        let sheetScroll = app.scrollViews["world-detail-scroll"]
        if sheetScroll.exists {
            // The presented sheet has its own viewport; the background page's footer
            // can still exist in the hierarchy but does not cover sheet content.
            let frame = sheetScroll.frame.intersection(app.frame)
            let top = max(frame.minY, 95)
            let bottom = min(frame.maxY, app.frame.maxY - 28)
            return CGRect(x: frame.minX, y: top, width: frame.width, height: max(0, bottom - top))
        }
        let footer = app.buttons["world-records"]
        let bottom = min(footer.isHittable ? footer.frame.minY - 12 : app.frame.maxY - 28, app.frame.maxY - 28)
        return CGRect(x: app.frame.minX, y: 95, width: app.frame.width, height: max(0, bottom - 95))
    }
    @MainActor private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<12 {
            let viewport = contentViewport(in: app)
            let visibleTop = max(element.frame.minY, viewport.minY)
            let visibleBottom = min(element.frame.maxY, viewport.maxY)
            if element.isHittable && visibleBottom - visibleTop >= min(44, element.frame.height) { return }
            let sheet = app.scrollViews["world-detail-scroll"]
            let scrollSurface: XCUIElement = sheet.exists ? sheet : app
            if element.exists && element.frame.maxY < viewport.minY { scrollSurface.swipeDown() } else { scrollSurface.swipeUp() }
        }
        XCTFail("Cannot reveal \(element.identifier)")
    }
    @MainActor private func tap(_ id: String, in app: XCUIApplication) {
        let button = app.buttons[id]
        if ["world-records", "world-people", "world-map", "close-world-detail"].contains(id) && button.isHittable {
            button.tap(); return
        }
        reveal(button, in: app)
        let viewport = contentViewport(in: app)
        let top = max(button.frame.minY, viewport.minY)
        let visibleBottom = min(button.frame.maxY, viewport.maxY)
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
        // Normal VoiceOver exposes meaningful Chinese, never proof JSON or technical IDs.
        let actor = app.descendants(matching: .any)["world-actor"].firstMatch
        XCTAssertTrue(actor.exists)
        XCTAssertTrue(actor.label.contains("阿澄"))
        let spokenValue = actor.value as? String ?? ""
        XCTAssertTrue(spokenValue.contains("思考"))
        XCTAssertFalse(spokenValue.contains("{"))
        XCTAssertFalse(spokenValue.contains("_id"))
        let footerTop = app.buttons["world-records"].frame.minY
        for (id, cost) in [("team", "花時間一起試；材料可能還不夠"), ("help", "先問問借用工具；需要等待確認")] {
            let choice = app.buttons["world-choice-\(id)"]
            XCTAssertTrue(choice.isHittable, "Both choices must be available before scrolling")
            XCTAssertGreaterThanOrEqual(choice.frame.minY, app.frame.minY)
            XCTAssertLessThanOrEqual(choice.frame.maxY, footerTop - 4, "The complete choice and cost must clear the navigation")
            XCTAssertTrue(choice.label.contains(cost), "The qualitative cost must stay with its choice")
        }
        capture("01-world-home")
        tap("world-resources", in: app)
        XCTAssertEqual(app.buttons["world-resources"].value as? String, "已展開")
        for (id, value) in [("health", "還有精神動手試"), ("finance", "這次沒有新增花費"), ("relationships", "有人願意陪你想"), ("skills", "正在探索紙橋結構")] {
            let resource = app.descendants(matching: .any)["world-resource-\(id)"]
            reveal(resource, in: app)
            XCTAssertTrue(resource.label.contains(value))
        }
        tap("world-resources", in: app)
        XCTAssertEqual(app.buttons["world-resources"].value as? String, "已收合")
        top(app)
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
        let entry = app.buttons["world-decisions-entry"]
        XCTAssertTrue(entry.waitForExistence(timeout: 8))
        XCTAssertTrue(entry.isHittable, "The first screen needs a decision entrance at maximum text size")
        XCTAssertLessThanOrEqual(entry.frame.maxY, app.frame.maxY - 20)
        capture("accessibility-home")
        tap("world-decisions-entry", in: app)
        XCTAssertTrue(app.scrollViews["world-detail-scroll"].waitForExistence(timeout: 3))
        tap("close-world-detail", in: app)
        XCTAssertTrue(entry.waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["scene-reaction"].exists, "Closing the decision sheet must not make a choice")
        tap("world-decisions-entry", in: app)
        XCTAssertTrue(app.scrollViews["world-detail-scroll"].waitForExistence(timeout: 3))
        let entranceReady = XCTNSPredicateExpectation(predicate: NSPredicate(format: "hittable == true"), object: app.buttons["world-choice-team"])
        XCTAssertEqual(XCTWaiter.wait(for: [entranceReady], timeout: 2), .completed)
        capture("accessibility-decisions")
        XCTAssertTrue(app.buttons["world-choice-team"].isHittable)
        for (id, cost) in [("team", "花時間一起試；材料可能還不夠"), ("help", "先問問借用工具；需要等待確認")] {
            let choice = app.buttons["world-choice-\(id)"]
            reveal(choice, in: app)
            XCTAssertTrue(choice.isHittable)
            XCTAssertTrue(choice.label.contains(cost))
        }
        tap("world-choice-help", in: app)
        let sheetClosed = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: app.scrollViews["world-detail-scroll"])
        XCTAssertEqual(XCTWaiter.wait(for: [sheetClosed], timeout: 3), .completed)
        XCTAssertEqual(app.staticTexts["beat-title"].label, "老師走到桌邊")
        XCTAssertTrue(app.otherElements["living-world"].exists)
        XCTAssertTrue(app.staticTexts["scene-reaction"].isHittable, "The selected reaction should be brought into view")
        capture("accessibility-reaction")
        tap("world-comparison", in: app)
        let end = app.staticTexts["comparison-end"]; reveal(end, in: app)
        for _ in 0..<6 {
            if end.frame.maxY <= app.frame.maxY - 28 { break }
            app.scrollViews["world-detail-scroll"].swipeUp()
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

    // Read what SwiftUI exposes on the actual rendered element. Expected values below
    // are spec assertions only; they are never substituted into the attachment.
    @MainActor private func observedJSON(_ element: XCUIElement) throws -> [String: Any] {
        XCTAssertTrue(element.waitForExistence(timeout: 8))
        let value = try XCTUnwrap(element.value as? String)
        let data = try XCTUnwrap(value.data(using: .utf8))
        return try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
    }

    @MainActor private func actorObservation(in app: XCUIApplication, option: String? = nil) throws -> [String: Any] {
        let actor = app.descendants(matching: .any)["world-actor"].firstMatch
        if let option {
            let changed = XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "value CONTAINS %@", "\"option_id\":\"\(option)\""), object: actor)
            XCTAssertEqual(XCTWaiter.wait(for: [changed], timeout: 2), .completed)
        }
        return try observedJSON(actor)
    }

    @MainActor func testActingBranchesAreVisuallyDistinct() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-acting-contact-sheet", "-acting-proof"]; app.launch()
        var observations = try observedJSON(app.staticTexts["acting-catalog"])
        XCTAssertEqual(observations["expression_catalog"] as? [String], ["neutral", "thinking", "hopeful", "tired"])
        XCTAssertEqual(observations["pose_catalog"] as? [String], ["idle", "collaborating", "asking"])
        app.terminate()

        app.launchArguments = ["-acting-proof"]; app.launch()
        let initial = try actorObservation(in: app)
        XCTAssertTrue(initial["option_id"] is NSNull)
        XCTAssertEqual(initial["expression_id"] as? String, "thinking")
        XCTAssertEqual(initial["pose_id"] as? String, "idle")
        tap("world-choice-team", in: app)
        let team = try actorObservation(in: app, option: "team")
        XCTAssertEqual(team["expression_id"] as? String, "hopeful")
        XCTAssertEqual(team["pose_id"] as? String, "collaborating")
        XCTAssertEqual(team["prop_id"] as? String, "paper-bridge-prototype")
        capture("acting-team-observed")
        app.terminate()

        app.launch()
        XCTAssertEqual(try actorObservation(in: app) as NSDictionary, initial as NSDictionary)
        tap("world-choice-help", in: app)
        let help = try actorObservation(in: app, option: "help")
        XCTAssertTrue(["neutral", "hopeful"].contains(help["expression_id"] as? String ?? ""))
        XCTAssertEqual(help["pose_id"] as? String, "asking")
        XCTAssertEqual(help["prop_id"] as? String, "borrow-tools-list")
        XCTAssertNotEqual(team["asset_ids"] as? [String], help["asset_ids"] as? [String])
        XCTAssertNotEqual(team["prop_id"] as? String, help["prop_id"] as? String)
        capture("acting-help-observed")

        observations["states"] = ["bridge-initial": initial, "bridge-team": team, "bridge-help": help]
        let data = try JSONSerialization.data(withJSONObject: observations, options: [.sortedKeys, .prettyPrinted])
        let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "public.json")
        attachment.name = "acting-state-observations.json"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor func testReducedMotionPreservesOutcome() throws {
        let app = XCUIApplication()
        for option in ["team", "help"] {
            app.launchArguments = ["-acting-proof"]; app.launch()
            tap("world-choice-\(option)", in: app)
            let normal = try actorObservation(in: app, option: option)
            let reaction = app.staticTexts["scene-reaction"].label
            let pending = option == "team" ? "材料還不夠；是否參展，還沒有決定。" : "工具能否借到仍待確認，還沒有拿到新材料。"
            XCTAssertTrue(app.staticTexts[pending].exists)
            app.terminate()
            app.launchArguments = ["-reduce-motion", "-acting-proof"]; app.launch()
            tap("world-choice-\(option)", in: app)
            // No screenshot delay or extra action is needed to reach the same final state.
            let reduced = try actorObservation(in: app, option: option)
            XCTAssertEqual(reduced as NSDictionary, normal as NSDictionary)
            XCTAssertEqual(app.staticTexts["scene-reaction"].label, reaction)
            XCTAssertTrue(app.staticTexts[pending].exists)
            XCTAssertTrue(app.buttons["world-next"].isEnabled)
            capture("acting-reduced-motion-\(option)")
            app.terminate()
        }
    }

    @MainActor func testActingContactSheetShowsCatalog() throws {
        let app = XCUIApplication(); app.launchArguments = ["-acting-contact-sheet", "-acting-proof"]; app.launch()
        let catalog = try observedJSON(app.staticTexts["acting-catalog"])
        let expressions = try XCTUnwrap(catalog["expression_catalog"] as? [String])
        let poses = try XCTUnwrap(catalog["pose_catalog"] as? [String])
        XCTAssertEqual(expressions.count, 4); XCTAssertEqual(poses.count, 3)
        for identifier in expressions.map({ "acting-expression-\($0)" }) + poses.map({ "acting-pose-\($0)" }) {
            let item = app.descendants(matching: .any)[identifier].firstMatch
            XCTAssertTrue(item.exists)
            XCTAssertGreaterThan(item.frame.width, 40)
            XCTAssertGreaterThanOrEqual(item.frame.minY, app.frame.minY)
            XCTAssertLessThanOrEqual(item.frame.maxY, app.frame.maxY - 12, "All seven rendered samples must fit in the contact sheet")
        }
        capture("acting-contact-sheet")
    }

    @MainActor func testMissingRouteKeepsInitialActing() throws {
        let app = XCUIApplication(); app.launchArguments = ["-missing-route", "-acting-proof"]; app.launch()
        let initial = try actorObservation(in: app)
        tap("world-choice-team", in: app)
        XCTAssertTrue(app.staticTexts["world-error"].label.contains("沒有產生人生結果"))
        top(app)
        XCTAssertEqual(try actorObservation(in: app) as NSDictionary, initial as NSDictionary)
        XCTAssertFalse(app.staticTexts["scene-reaction"].exists)
        tap("world-records", in: app)
        XCTAssertTrue(app.staticTexts["這段人生還沒有選擇紀錄。"].exists)
        tap("close-world-detail", in: app)
        tap("world-restart", in: app)
        top(app)
        XCTAssertEqual(try actorObservation(in: app) as NSDictionary, initial as NSDictionary)
    }
}
