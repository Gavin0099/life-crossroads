#if VISUAL_LOOP_CAPTURE
import XCTest

@MainActor final class MultiCastCaptureTests: XCTestCase {
    func testReplayValidatedNativeScenes() throws {
        continueAfterFailure = false
        let bundle = Bundle(for: Self.self)
        let directory = try XCTUnwrap(bundle.url(forResource: "cast-fixtures", withExtension: nil))
        let data = try Data(contentsOf: directory.appendingPathComponent("manifest.json"))
        let manifest = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let fixtures = try XCTUnwrap(manifest["fixtures"] as? [[String: Any]])
        let variants = ProcessInfo.processInfo.environment["LIFE_CAPTURE_VARIANTS"]?.split(separator: ",").map(String.init) ?? ["normal"]
        let filter = ProcessInfo.processInfo.environment["LIFE_CAPTURE_FILTER"]
        for variant in variants {
            for fixture in fixtures {
                let name = try XCTUnwrap(fixture["name"] as? String)
                if variant != "normal" && !["10-friend", "13-ask", "17-remote", "25-collective", "32-participating", "72-ahe", "72-neighbor"].contains(name) { continue }
                if let filter, !filter.split(separator: ",").contains(Substring(name)) { continue }
                let app = XCUIApplication()
                app.launchArguments = ["-ui-testing", "-visual-loop-capture", "-reset-save", "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
                if variant == "large" { app.launchArguments += ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"] }
                app.launchEnvironment["LIFE_VISUAL_ARCHIVE_PATH"] = directory.appendingPathComponent(name + ".json").path
                if variant == "reduced" { app.launchArguments += ["-reducedLifeMotion", "YES"] }
                app.launch()
                let resume = app.buttons["resumeLife"]
                XCTAssertTrue(resume.waitForExistence(timeout: 10), "Validated archive must restore")
                resume.tap()
                let scene = app.otherElements["lifeWorldScene"]
                XCTAssertTrue(scene.waitForExistence(timeout: 5))
                let checksum = app.staticTexts["uiTestArchiveChecksum"].value as? String
                XCTAssertEqual(checksum?.count, 64)
                XCTAssertGreaterThan(scene.frame.width, 200)
                XCTAssertGreaterThan(scene.frame.height, 70)
                let presentation = app.staticTexts["worldPlaybackState"].value as? String ?? ""
                if variant == "reduced" { XCTAssertTrue(presentation.contains("reduceMotion=true")) }
                if variant == "large" { XCTAssertTrue(presentation.contains("largeType=true")) }
                let full = XCTAttachment(screenshot: app.screenshot()); full.name = "\(name)-\(variant)-screen"; full.lifetime = .keepAlways; add(full)
                // Native element crop removes UI title/age/choice text without editing generated art.
                let blind = XCTAttachment(screenshot: scene.screenshot()); blind.name = "\(name)-\(variant)-scene"; blind.lifetime = .keepAlways; add(blind)
                XCTAssertEqual(checksum, app.staticTexts["uiTestArchiveChecksum"].value as? String)
                print("VISUAL_CAPTURE \(name) \(variant) archive=\(checksum ?? "missing") rect=\(scene.frame) scene=\(scene.label) value=\(scene.value ?? "")")
                let controls = app.buttons.matching(NSPredicate(format: "identifier == 'continueLife' OR identifier BEGINSWITH 'choice.'"))
                let control = controls.matching(NSPredicate(format: "enabled == true")).firstMatch
                for _ in 0..<7 where !control.isHittable { app.swipeUp() }
                XCTAssertTrue(control.isHittable, "A feasible action must remain reachable at every tested text size")
                XCTAssertEqual(checksum, app.staticTexts["uiTestArchiveChecksum"].value as? String)
                print("VISUAL_CONTROL \(name) \(variant) \(control.identifier) hittable=true \(presentation)")
                app.terminate()
            }
        }
    }
    func testCastSaveFailureKeepsOriginalInvitation() throws {
        continueAfterFailure = false
        let directory = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "cast-fixtures", withExtension: nil))
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-visual-loop-capture", "-reset-save", "-ui-fail-save-at", "1", "-AppleLanguages", "(zh-Hant)"]
        app.launchEnvironment["LIFE_VISUAL_ARCHIVE_PATH"] = directory.appendingPathComponent("10-before.json").path
        app.launch()
        XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10)); app.buttons["resumeLife"].tap()
        let scene = app.otherElements["lifeWorldScene"]
        XCTAssertTrue(scene.waitForExistence(timeout: 5))
        let original = scene.label
        let checksum = app.staticTexts["uiTestArchiveChecksum"].value as? String
        XCTAssertEqual(checksum?.count, 64)
        XCTAssertTrue(original.contains("尚未決定"))
        let invest = app.buttons["choice.invest"]
        for _ in 0..<6 where !invest.isHittable { app.swipeUp() }
        invest.tap()
        let alert = app.alerts["需要留意"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5)); alert.buttons["知道了"].tap()
        XCTAssertEqual(scene.label, original)
        XCTAssertEqual(app.staticTexts["uiTestArchiveChecksum"].value as? String, checksum)
        XCTAssertFalse(app.staticTexts["chosenAction"].exists)
        let failure = XCTAttachment(screenshot: scene.screenshot()); failure.name = "10-savefailure-normal-scene"; failure.lifetime = .keepAlways; add(failure)
        invest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertNotEqual(app.staticTexts["uiTestArchiveChecksum"].value as? String, checksum)
        XCTAssertTrue(scene.label.contains("友誼的互動"))
        let saved = XCTAttachment(screenshot: scene.screenshot()); saved.name = "10-retry-normal-scene"; saved.lifetime = .keepAlways; add(saved)
        print("CAST_SAVE_FAILURE oldFileAndInvitationUnchanged=true retrySaved=true")
        app.terminate()
    }

}
#endif
