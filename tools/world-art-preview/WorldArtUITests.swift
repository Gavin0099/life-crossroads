import XCTest
import UIKit

@MainActor final class WorldArtUITests: XCTestCase {
    override func setUp() { continueAfterFailure = false }

    func testThreeBehaviorsAndPersistentObjectSource() throws {
        let app = XCUIApplication(); app.launch()
        XCTAssertTrue(app.otherElements["lifeWorldScene"].waitForExistence(timeout: 15))
        XCTAssertTrue(app.otherElements["worldActor-mumu"].label.contains("停留觀察"))
        XCTAssertGreaterThan(app.otherElements["worldActor-mumu"].frame.height, 200)
        XCTAssertLessThanOrEqual(app.otherElements["worldActor-mumu"].frame.width, app.frame.width,
            "A clipped atlas must not expose its entire texture as an accessibility frame")
        capture("01-idle", app)
        select("walking", app)
        XCTAssertTrue(app.otherElements["worldActor-mumu"].label.contains("移動"))
        capture("02-walking", app)
        select("interacting", app)
        XCTAssertTrue(app.otherElements["worldActor-mumu"].label.contains("分享"))
        let memory = app.buttons["worldObject-friendship"]
        XCTAssertTrue(memory.exists)
        capture("03-interacting", app)
        memory.tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "選擇紀錄")).firstMatch.waitForExistence(timeout: 5))
        capture("04-source", app)
    }

    func testAdolescentAndElderRemainInSameScene() throws {
        let app = XCUIApplication(); app.launch()
        select("teen", app)
        XCTAssertTrue(app.otherElements["worldActor-mumu"].label.contains("13歲"))
        XCTAssertTrue(app.buttons["worldObject-learning"].exists)
        capture("05-teen", app)
        select("elder", app)
        XCTAssertTrue(app.otherElements["worldActor-mumu"].label.contains("歲"))
        capture("06-elder", app)
    }

    func testLargestTypeCanInspectAndDismissWithoutLosingActor() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch(); select("interacting", app)
        XCTAssertGreaterThan(app.otherElements["worldActor-mumu"].frame.height, 200)
        capture("07-largest", app)
        app.buttons["worldObject-friendship"].tap()
        let close = app.buttons["回到生活場景"]
        for _ in 0..<5 where !close.isHittable { app.swipeUp() }
        XCTAssertTrue(close.isHittable); close.tap()
        XCTAssertTrue(app.otherElements["worldActor-mumu"].waitForExistence(timeout: 5))
    }

    func testReducedMotionRetainsWalkingPoseAndFacts() throws {
        let app = XCUIApplication(); app.launchArguments = ["-reduce-motion"]; app.launch()
        select("walking", app)
        XCTAssertTrue(app.otherElements["worldActor-mumu"].label.contains("移動"))
        let actor = app.otherElements["worldActor-mumu"]
        XCTAssertEqual(pixels(actor), pixels(actor),
            "Reduced motion must keep the actor still while preserving the walking pose")
        capture("08-reduced-motion-walking", app)
        select("seeking", app)
        XCTAssertTrue(app.buttons["worldObject-learning"].label.contains("尚未"))
        capture("09-seeking", app)
    }

    func testPauseKeepsActorStillAndRetainsScene() throws {
        let app = XCUIApplication(); app.launch(); select("paused", app)
        let actor = app.otherElements["worldActor-mumu"]
        XCTAssertTrue(actor.label.contains("停留"))
        XCTAssertEqual(pixels(actor), pixels(actor))
        capture("10-paused", app)
    }

    private func select(_ name: String, _ app: XCUIApplication) {
        app.buttons["preview-selector"].tap()
        let button = app.buttons["preview-\(name)"]
        XCTAssertTrue(button.isHittable); button.tap()
        XCTAssertEqual(app.staticTexts["preview-mode"].label, name)
    }
    private func pixels(_ actor: XCUIElement) -> Data {
        let image = actor.screenshot().image.cgImage!
        return image.dataProvider!.data! as Data
    }
    private func capture(_ name: String, _ app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot()); attachment.name = name
        attachment.lifetime = .keepAlways; add(attachment)
    }
}
