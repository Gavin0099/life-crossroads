import XCTest

@MainActor final class WorkshopGameplayTests: XCTestCase {
    override func setUp() { super.setUp();continueAfterFailure=false }
    private func launch(_ extra: [String] = []) -> XCUIApplication {
        let app=XCUIApplication();app.launchArguments=["-ui-testing","-workshop","-workshop-proof","-workshop-reset"] + extra
        app.launch();return app
    }
    private func tap(_ id: String,_ app: XCUIApplication) {
        let element=app.buttons[id]
        // Toolbar and safeAreaInset controls are fixed; scrolling cannot change their frame.
        // In particular, the SE dock has 12pt padding, so a 20pt scroll-content margin rejects a visible button.
        let fixedControls=["workshop-catalog","workshop-panel-close","workshop-actions","workshop-advance","workshop-restart"]
        if fixedControls.contains(id),element.isHittable { element.tap();return }
        for _ in 0..<10 {
            if element.isHittable && element.frame.maxY <= app.frame.maxY - 20 && element.frame.minY >= 60 { element.tap();return }
            let sheet=app.scrollViews["workshop-panel-scroll"]
            (sheet.exists ? sheet:app).swipeUp()
        }
        XCTFail("Cannot reach \(id)")
    }
    private func capture(_ name: String) {
        let shot=XCTAttachment(screenshot:XCUIScreen.main.screenshot());shot.name=name;shot.lifetime = .keepAlways;add(shot)
    }
    private func observation(_ app: XCUIApplication) throws -> [String:Any] {
        let element=app.staticTexts["workshop-age"]
        XCTAssertTrue(element.waitForExistence(timeout:8))
        let raw=try XCTUnwrap(element.value as? String), data=try XCTUnwrap(raw.data(using:.utf8))
        return try XCTUnwrap(JSONSerialization.jsonObject(with:data) as? [String:Any])
    }
    private func state(_ app: XCUIApplication) throws -> [String:Any] { try XCTUnwrap(observation(app)["state"] as? [String:Any]) }
    private func choice(_ id: String,_ app: XCUIApplication) { tap("workshop-actions",app);tap("workshop-choice-"+id,app) }
    private func attach(_ name: String,_ value: [String:Any]) throws {
        let data=try JSONSerialization.data(withJSONObject:value,options:[.sortedKeys,.prettyPrinted])
        let a=XCTAttachment(data:data,uniformTypeIdentifier:"public.json");a.name=name;a.lifetime = .keepAlways;add(a)
    }
    func testObserveWithoutSpendingAndKeepSameWorkshopAfterChoice() throws {
        let app=launch();let before=try observation(app)
        capture("sim-01-initial")
        tap("inspect-materials",app);capture("sim-02-observe-materials");tap("workshop-panel-close",app)
        tap("inspect-people",app);tap("workshop-panel-close",app)
        XCTAssertEqual(try observation(app) as NSDictionary,before as NSDictionary)
        choice("team",app)
        XCTAssertEqual(try state(app)["age"] as? Int,13)
        XCTAssertEqual((try observation(app)["traces"] as? [Any])?.count,1)
        XCTAssertTrue(app.descendants(matching:.any)["workshop-art-team"].firstMatch.exists)
        capture("sim-03-team-world")
    }
    func testTeamOpensPlayableLeadingAtFifteenAndRetainsHistory() throws {
        let app=launch();choice("team",app);let thirteen=try observation(app)
        tap("workshop-advance",app)
        XCTAssertEqual(try state(app)["age"] as? Int,15)
        XCTAssertTrue(app.otherElements["workshop-art-team"].exists)
        tap("workshop-actions",app)
        XCTAssertTrue(app.buttons["workshop-choice-lead"].exists)
        XCTAssertFalse(app.buttons["workshop-choice-borrow"].exists)
        capture("sim-04-team-age15-opportunities")
        tap("workshop-choice-lead",app)
        let fifteen=try observation(app)
        XCTAssertEqual((fifteen["traces"] as? [Any])?.count,2)
        try attach("team-life-observations.json",["age13":thirteen,"age15":fifteen])
        tap("workshop-advance",app)
        XCTAssertTrue(app.buttons["workshop-restart"].exists)
    }
    func testHelpOpensBorrowingAndIsPlayableWithImagesOff() throws {
        let app=launch();choice("help",app);capture("sim-05-help-world")
        let before=try observation(app)
        let toggle=app.switches["workshop-images"]
        for _ in 0..<6 { if toggle.isHittable { break };app.swipeUp() }
        toggle.tap()
        XCTAssertEqual(try observation(app) as NSDictionary,before as NSDictionary)
        app.swipeDown();app.swipeDown()
        XCTAssertFalse(app.descendants(matching:.any)["workshop-art-help"].firstMatch.exists)
        capture("sim-06-graphics-off")
        tap("workshop-advance",app)
        tap("workshop-actions",app)
        XCTAssertTrue(app.buttons["workshop-choice-borrow"].exists)
        XCTAssertFalse(app.buttons["workshop-choice-lead"].exists)
        capture("sim-07-help-age15-opportunities")
        tap("workshop-choice-borrow",app)
        XCTAssertTrue(app.staticTexts["workshop-object"].label.contains("仍待確認"))
        XCTAssertEqual((try observation(app)["traces"] as? [Any])?.count,2)
        try attach("help-graphics-off-observations.json",try observation(app))
    }
    func testRelaunchPreservesWorldAndFutureOpportunities() throws {
        let app=launch();choice("help",app);let original=try observation(app)
        app.terminate();app.launchArguments.removeAll { $0 == "-workshop-reset" };app.launch()
        XCTAssertEqual(try observation(app) as NSDictionary,original as NSDictionary)
        tap("workshop-advance",app);tap("workshop-actions",app)
        XCTAssertTrue(app.buttons["workshop-choice-borrow"].exists)
        XCTAssertFalse(app.buttons["workshop-choice-lead"].exists)
        capture("sim-08-restored-world")
    }
    func testLargestTextReducedMotionCanObserveCancelAndChoose() throws {
        let app=launch(["-UIPreferredContentSizeCategoryName","UICTContentSizeCategoryAccessibilityXXXL","-reduce-motion"])
        XCTAssertTrue(app.buttons["workshop-actions"].waitForExistence(timeout:8))
        XCTAssertTrue(app.buttons["workshop-actions"].isHittable)
        let stage=app.descendants(matching:.any)["workshop-art-idle"].firstMatch
        XCTAssertTrue(stage.exists)
        XCTAssertGreaterThanOrEqual(stage.frame.height,200,"Keep the existing scene size at the largest text setting")
        XCTAssertGreaterThanOrEqual(stage.frame.minY,0)
        XCTAssertLessThanOrEqual(stage.frame.maxY,app.buttons["workshop-actions"].frame.minY,"The full cast must be above the decision dock on entry")
        let original=try observation(app)
        capture("sim-09-largest-entry")
        tap("workshop-actions",app);tap("workshop-panel-close",app)
        XCTAssertEqual(try observation(app) as NSDictionary,original as NSDictionary)
        choice("help",app);tap("workshop-advance",app);tap("workshop-actions",app)
        capture("sim-10-largest-opportunities")
        tap("workshop-choice-borrow",app)
        XCTAssertEqual((try observation(app)["traces"] as? [Any])?.count,2)
    }
    func testCorruptSaveBlocksWithoutInventingNewLife() {
        let app=launch(["-workshop-corrupt"])
        XCTAssertTrue(app.staticTexts["workshop-error"].waitForExistence(timeout:8))
        XCTAssertFalse(app.staticTexts["workshop-age"].exists)
        XCTAssertTrue(app.buttons["workshop-explicit-restart"].exists)
        app.terminate()
    }
    func testProductionHomeCanEnterWorkshopAndReturnToCompleteLife() throws {
        let app=XCUIApplication()
        app.launchArguments=["-ui-testing","-workshop-proof","-workshop-reset"]
        app.launch()
        XCTAssertTrue(app.buttons["openWorkshop"].waitForExistence(timeout:8))
        app.buttons["openWorkshop"].tap()
        XCTAssertEqual(try state(app)["age"] as? Int,13)
        app.buttons["workshop-close"].tap()
        XCTAssertTrue(app.buttons["openWorkshop"].waitForExistence(timeout:8))
        XCTAssertTrue(app.buttons["startLife"].exists)
    }
    func testLargestTextCanReadAndChooseLastFreeRecoveryAction() throws {
        let app=launch(["-UIPreferredContentSizeCategoryName","UICTContentSizeCategoryAccessibilityXXXL","-reduce-motion"])
        choice("help",app);tap("workshop-advance",app);tap("workshop-actions",app)
        let rest=app.buttons["workshop-choice-rest"]
        for _ in 0..<10 {
            if rest.isHittable && rest.frame.minY >= 60 && rest.frame.maxY <= app.frame.maxY-20 { break }
            app.scrollViews["workshop-panel-scroll"].swipeUp()
        }
        XCTAssertTrue(rest.isHittable)
        XCTAssertGreaterThanOrEqual(rest.frame.minY,60)
        XCTAssertLessThanOrEqual(rest.frame.maxY,app.frame.maxY-20)
        XCTAssertTrue(rest.label.contains("時間 0"))
        XCTAssertTrue(rest.label.contains("精力 0"))
        XCTAssertTrue(rest.label.contains("材料 0"))
        capture("sim-12-largest-last-action")
        rest.tap()
        let saved=try observation(app)
        XCTAssertEqual((saved["traces"] as? [Any])?.count,2)
        let state=try XCTUnwrap(saved["state"] as? [String:Any])
        let story=try XCTUnwrap(state["story"] as? [String:Any])
        let flags=try XCTUnwrap(story["flags"] as? [[String:Any]])
        XCTAssertTrue(flags.contains { $0["key"] as? String == "workshop" && $0["value"] as? String == "plan" })
    }
    func testExistingFourExpressionsAndThreeStatesHaveNativeCatalog() {
        let app=launch();tap("workshop-catalog",app)
        for art in ["idle","team","help"] {
            XCTAssertTrue(app.descendants(matching:.any)["workshop-art-"+art].firstMatch.waitForExistence(timeout:3))
        }
        capture("sim-11-acting-catalog")
    }
}
