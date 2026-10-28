#if VISUAL_LOOP_CAPTURE
import XCTest

@MainActor final class VisualLoopCaptureTests: XCTestCase {
    func testReplayValidatedNativeScenes() throws {
        continueAfterFailure = false
        let bundle = Bundle(for: Self.self)
        let directory = try XCTUnwrap(bundle.url(forResource: "fixtures", withExtension: nil))
        let data = try Data(contentsOf: directory.appendingPathComponent("manifest.json"))
        let manifest = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let fixtures = try XCTUnwrap(manifest["fixtures"] as? [[String: Any]])
        let variants = ProcessInfo.processInfo.environment["LIFE_CAPTURE_VARIANTS"]?.split(separator: ",").map(String.init) ?? ["normal"]
        let filter = ProcessInfo.processInfo.environment["LIFE_CAPTURE_FILTER"]
        for variant in variants {
            for fixture in fixtures {
                let name = try XCTUnwrap(fixture["name"] as? String)
                if let filter, !filter.split(separator: ",").contains(Substring(name)) { continue }
                if variant != "normal" && !["13-online", "13-paper", "17-remote", "17-collective", "25-remote", "25-collective", "32-prepared", "32-participating"].contains(name) { continue }
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
}
#endif
