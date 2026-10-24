import XCTest

@MainActor final class VisualFixtureUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

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
        capture("04-largest-first-screen", app)
        let stage = app.buttons["fixture-stage"]
        for _ in 0..<8 where !stage.isHittable { app.swipeUp() }
        XCTAssertTrue(stage.isHittable); stage.tap()
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
