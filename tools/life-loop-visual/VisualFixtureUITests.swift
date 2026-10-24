import XCTest

@MainActor final class VisualFixtureUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    func testCommittedPaperAndRestUseDifferentRealRecords() {
        let app = XCUIApplication(); app.launchArguments = ["-formal"]; app.launch()
        let canvas = app.otherElements["lifeWorldScene"]
        let found = canvas.waitForExistence(timeout: 10)
        if !found { print(app.debugDescription) }
        XCTAssertTrue(found)
        XCTAssertTrue(canvas.label.contains("13歲"))
        XCTAssertGreaterThanOrEqual(canvas.frame.minX, 0)
        XCTAssertLessThanOrEqual(canvas.frame.maxX, app.frame.width)
        XCTAssertTrue(canvas.label.contains("樹老師"))
        capture("07-saved-paper", app)
        app.buttons["formal-route"].tap()
        let route = app.staticTexts["formal-route-status"]
        XCTAssertTrue(route.waitForExistence(timeout: 5))
        XCTAssertTrue(canvas.waitForExistence(timeout: 5))
        wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "NOT(label CONTAINS %@)", "樹老師"), object: canvas)], timeout: 5)
        XCTAssertFalse(canvas.label.contains("樹老師"), "Rest cannot invent another person's support")
        capture("08-saved-rest", app)
        app.buttons["formal-route"].tap() // ask
        wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "label == %@", "ask"), object: route)], timeout: 5)
        app.buttons["formal-route"].tap() // adult
        wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "label CONTAINS %@", "39歲"), object: canvas)], timeout: 5)
        capture("11-saved-adult", app)
        app.buttons["formal-route"].tap() // child
        wait(for: [XCTNSPredicateExpectation(predicate: NSPredicate(format: "label CONTAINS %@", "8歲"), object: canvas)], timeout: 5)
        capture("12-saved-child", app)
    }

    func testRealRecordInspectionLargestTypeRemainsReachable() {
        let app = XCUIApplication()
        app.launchArguments = ["-formal", "-fixture-reduced", "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        XCTAssertTrue(app.otherElements["lifeWorldScene"].waitForExistence(timeout: 10))
        capture("09-formal-largest-first-screen", app)
        let record = app.buttons["world-change-0"]
        for _ in 0..<12 where !record.isHittable { app.swipeUp() }
        XCTAssertTrue(record.isHittable); record.tap()
        let close = app.buttons["回到生活場景"]
        for _ in 0..<12 where !close.isHittable { app.swipeUp() }
        XCTAssertTrue(close.isHittable)
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "來源：13歲")).firstMatch.exists)
        capture("10-formal-source-largest", app)
        close.tap()
        XCTAssertTrue(app.buttons["formal-route"].isHittable)
    }

    func testLargeSceneAndThreeAgeFixtures() {
        let app = XCUIApplication(); app.launch()
        let scene = app.otherElements["visual-fixture-scene"]
        XCTAssertTrue(scene.waitForExistence(timeout: 10))
        XCTAssertGreaterThan(scene.frame.height, 180, "The scene must remain a large surface on SE")
        XCTAssertGreaterThan(scene.frame.width, app.frame.width * 0.85)
        XCTAssertGreaterThanOrEqual(scene.frame.minX, 0)
        XCTAssertLessThanOrEqual(scene.frame.maxX, app.frame.width)
        let stage = app.buttons["fixture-stage"]
        XCTAssertTrue(stage.isHittable, "Ordinary text must leave the preview control visible")
        capture("01-child", app)
        stage.tap(); XCTAssertTrue(scene.label.contains("13歲")); capture("02-teen", app)
        stage.tap(); XCTAssertTrue(scene.label.contains("39歲")); capture("03-adult", app)
    }

    func testLargestTextCanReachStageAndFullBoundaryText() {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        XCTAssertTrue(app.otherElements["visual-fixture-scene"].waitForExistence(timeout: 10))
        XCTAssertGreaterThan(app.otherElements["visual-fixture-scene"].frame.height, 200,
            "Largest type must retain the character canvas, not squeeze it into a strip")
        capture("04-largest-first-screen", app)
        let stage = app.buttons["fixture-stage"]
        XCTAssertTrue(stage.isHittable, "Largest type needs a visible first-screen entry"); stage.tap()
        for _ in 0..<8 where !app.staticTexts["fixture-status"].isHittable { app.swipeUp() }
        XCTAssertTrue(app.staticTexts["fixture-status"].label.contains("13歲"))
        let boundary = app.staticTexts["fixture-boundary"]
        for _ in 0..<8 where !boundary.isHittable { app.swipeUp() }
        XCTAssertTrue(boundary.isHittable)
        XCTAssertTrue(boundary.label.hasSuffix("尚待 Gameplay 接入。"))
        capture("05-largest-reachable-text", app)
    }

    func testReducedFixtureRetainsAgeAndResultBoundary() {
        let app = XCUIApplication(); app.launchArguments = ["-fixture-reduced"]; app.launch()
        let stage = app.buttons["fixture-stage"]
        XCTAssertTrue(stage.waitForExistence(timeout: 10)); stage.tap()
        XCTAssertTrue(app.otherElements["visual-fixture-scene"].label.contains("13歲"))
        XCTAssertTrue(app.staticTexts["fixture-status"].label.contains("減少動態取樣"))
        XCTAssertTrue(app.staticTexts["fixture-boundary"].label.contains("正式事件、選項、成本及後果尚待"))
        capture("06-reduced-teen", app)
    }

    private func capture(_ name: String, _ app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }
}
