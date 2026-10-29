#if VISUAL_LOOP_CAPTURE
import XCTest

@MainActor final class FinalPolishCaptureTests: XCTestCase {
    func testReplayValidatedNativeScenes() throws {
        continueAfterFailure = false
        let bundle = Bundle(for: Self.self)
        let directory = try XCTUnwrap(bundle.url(forResource: "interaction-fixtures", withExtension: nil))
        let data = try Data(contentsOf: directory.appendingPathComponent("manifest.json"))
        let manifest = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let fixtures = try XCTUnwrap(manifest["fixtures"] as? [[String: Any]])
        let variants = ProcessInfo.processInfo.environment["LIFE_CAPTURE_VARIANTS"]?.split(separator: ",").map(String.init) ?? ["normal"]
        let filter = ProcessInfo.processInfo.environment["LIFE_CAPTURE_FILTER"]
        for variant in variants {
            for fixture in fixtures {
                let name = try XCTUnwrap(fixture["name"] as? String)
                if variant != "normal" && !["13-ask", "17-remote", "17-collective", "32-ask", "32-participating", "72-ahe", "72-neighbor"].contains(name) { continue }
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
                if name == "72-ahe" { XCTAssertTrue(scene.label.contains("回看10歲：和阿禾")) }
                if name == "72-neighbor" { XCTAssertTrue(scene.label.contains("回看10歲：今天自己休息")); XCTAssertFalse(scene.label.contains("童年的小澄")) }
                if ["13-ask", "32-ask"].contains(name) { XCTAssertTrue(scene.label.contains("尚未確認協助安排")) }
                let full = XCTAttachment(screenshot: app.screenshot()); full.name = "\(name)-\(variant)-screen"; full.lifetime = .keepAlways; add(full)
                // Native element crop removes UI title/age/choice text without editing generated art.
                let blind = XCTAttachment(screenshot: scene.screenshot()); blind.name = "\(name)-\(variant)-scene"; blind.lifetime = .keepAlways; add(blind)
                XCTAssertEqual(checksum, app.staticTexts["uiTestArchiveChecksum"].value as? String)
                print("VISUAL_CAPTURE \(name) \(variant) archive=\(checksum ?? "missing") rect=\(scene.frame) scene=\(scene.label) value=\(scene.value ?? "")")
                let controls = app.buttons.matching(NSPredicate(format: "identifier == 'continueLife' OR identifier BEGINSWITH 'choice.'"))
                let control = controls.matching(NSPredicate(format: "enabled == true")).firstMatch
                if control.identifier.hasPrefix("choice.") { reveal(control, in: app) }
                else {
                    // Continue is the pinned footer itself, not a target inside the story drawer.
                    XCTAssertGreaterThan(control.frame.midY, app.frame.minY)
                    XCTAssertLessThan(control.frame.midY, app.frame.maxY)
                }
                XCTAssertTrue(control.isHittable, "A feasible action must remain reachable at every tested text size")
                XCTAssertEqual(checksum, app.staticTexts["uiTestArchiveChecksum"].value as? String)
                print("VISUAL_CONTROL \(name) \(variant) \(control.identifier) hittable=true \(presentation)")
                app.terminate()
            }
        }
    }
    func testCastSaveFailureKeepsOriginalInvitation() throws {
        continueAfterFailure = false
        let directory = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "interaction-fixtures", withExtension: nil))
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

    func testActualSavedRequestHasTwoVisibleBeats() throws {
        continueAfterFailure = false
        let directory = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "interaction-fixtures", withExtension: nil))
        for (name, expectedAge) in [("13-before", 13), ("32-before", 32)] {
            var savedChecksum: String?
            for (threshold, beat) in [(200, "expressing"), (720, "transition"), (900, "handoff"), (1400, "listening")] {
                let app = XCUIApplication()
                app.launchArguments = ["-ui-testing", "-visual-loop-capture", "-reset-save", "-AppleLanguages", "(zh-Hant)"]
                app.launchEnvironment["LIFE_VISUAL_ARCHIVE_PATH"] = directory.appendingPathComponent(name + ".json").path
                app.launchEnvironment["LIFE_CAPTURE_PAUSE_AFTER_MS"] = String(threshold)
                app.launch()
                XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10)); app.buttons["resumeLife"].tap()
                let scene = app.otherElements["lifeWorldScene"]
                XCTAssertTrue(scene.waitForExistence(timeout: 5))
                let before = app.staticTexts["uiTestArchiveChecksum"].value as? String
                let ask = app.buttons["choice.ask"]
                reveal(ask, in: app)
                ask.tap()
                let state = app.staticTexts["worldPlaybackState"]
                let settled = NSPredicate { _, _ in (state.value as? String ?? "").contains("committedOutcome|true|") }
                expectation(for: settled, evaluatedWith: state); waitForExpectations(timeout: 8)
                let evidence = state.value as? String ?? ""
                let elapsed = try XCTUnwrap(Int(evidence.components(separatedBy: "phaseMs=").last ?? ""))
                XCTAssertGreaterThanOrEqual(elapsed, threshold)
                XCTAssertLessThan(elapsed, threshold + 450, "Capture pauses the actual shared clock near the requested observation")
                if beat == "transition" {
                    XCTAssertLessThan(elapsed, 820, "The additional image must observe the real short transition, not hide it with a settled pose")
                }
                XCTAssertTrue(scene.label.contains("尚未確認協助安排"))
                let after = app.staticTexts["uiTestArchiveChecksum"].value as? String
                XCTAssertNotEqual(before, after); XCTAssertEqual(after?.count, 64)
                if let savedChecksum { XCTAssertEqual(after, savedChecksum, "Presentation timing cannot change saved outcome") }
                savedChecksum = after
                let picture = XCTAttachment(screenshot: scene.screenshot()); picture.name = "\(expectedAge)-\(beat)-normal-scene"; picture.lifetime = .keepAlways; add(picture)
                print("VISUAL_REQUEST \(expectedAge) \(beat) archive=\(after ?? "missing") phaseMs=\(elapsed) pause=actual-clock")
                app.terminate()
            }
        }
    }

    private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<32 {
            if ["lifeWorldScene", "resumeBranch", "enterChildhood"].contains(element.identifier), element.exists, element.isHittable { return }
            let sheet = ["closeTrace", "closeComparison", "closeBranchComparison", "closeForkPicker", "closeFullEvent", "cancelParallel", "enterChildhood"].contains { app.buttons[$0].exists }
            let footer = app.buttons["continueLife"].exists && !sheet
            let worldFooter = app.descendants(matching: .any).matching(identifier: "worldPlaybackControls").firstMatch
            let pinnedDrawer = app.scrollViews["worldDecisionDrawer"]
            let comparisonScroll = app.scrollViews.containing(.staticText, identifier: "branchComparisonTitle").firstMatch
            let scroll = comparisonScroll.exists ? comparisonScroll : app.scrollViews["eventStoryScroll"].exists ? app.scrollViews["eventStoryScroll"] : pinnedDrawer.exists && !sheet ? pinnedDrawer : app.scrollViews.firstMatch
            let scrollTop = max(app.frame.minY + 90, scroll.exists ? scroll.frame.minY + 8 : 100)
            let footerTop = worldFooter.exists && !sheet ? worldFooter.frame.minY - 8 : app.frame.maxY - (footer ? 110 : 24)
            let bottom = min(footerTop, scroll.exists ? scroll.frame.maxY - 8 : footerTop)
            if element.exists && element.isHittable && element.frame.midY > scrollTop && element.frame.midY < bottom {
                if pinnedDrawer.exists && !sheet {
                    print("LL07_REVEALED \(element.identifier): target=\(element.frame), visible=\(scrollTop)...\(bottom), controls=\(worldFooter.exists ? worldFooter.frame : .zero)")
                }
                return
            }
            // Drag within the actual scroll viewport, excluding the pinned world and control strip.
            let scrollHeight = max(44, bottom - scrollTop)
            if pinnedDrawer.exists && !sheet {
                // A full-height flick can overshoot an SE target and oscillate forever.
                // Move its observed center toward the viewport center and stop before release.
                let distance = element.exists ? element.frame.midY - (scrollTop + bottom) / 2 : scrollHeight
                let delta = min(scrollHeight * 0.55, max(-scrollHeight * 0.55, distance))
                let fromY = scrollTop + scrollHeight * (delta >= 0 ? 0.78 : 0.22)
                let toY = fromY - delta
                print("LL07_REVEAL \(element.identifier): target=\(element.exists ? element.frame : .zero), viewport=\(scroll.frame), drag=\(fromY)->\(toY)")
                let from = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: (fromY - app.frame.minY) / app.frame.height))
                let to = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: (toY - app.frame.minY) / app.frame.height))
                from.press(forDuration: 0.05, thenDragTo: to, withVelocity: .slow, thenHoldForDuration: 0.2)
                continue
            }
            let upperY = scrollTop + scrollHeight * 0.2
            let lowerY = scrollTop + scrollHeight * 0.8
            let upper = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: (upperY - app.frame.minY) / app.frame.height))
            let lower = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: (lowerY - app.frame.minY) / app.frame.height))
            if element.exists && element.frame.midY < scrollTop { upper.press(forDuration: 0.05, thenDragTo: lower) }
            else { lower.press(forDuration: 0.05, thenDragTo: upper) }
        }
        let failure = XCTAttachment(screenshot: app.screenshot()); failure.name = "unrevealed"; failure.lifetime = .keepAlways; add(failure)
        XCTFail("Could not reveal an unobscured tap target: \(element.identifier); exists=\(element.exists)")
    }
}
#endif

#if VISUAL_LOOP_CAPTURE
/// Uses real restored sessions and OS appearance, not mocked text or screenshots.
@MainActor final class ReadabilityCaptureTests: XCTestCase {
    func testReadableStoryScreensAndUnchangedArchive() throws {
        continueAfterFailure = false
        let variant = ProcessInfo.processInfo.environment["READABILITY_VARIANT"] ?? "light"
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-reset-save", "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
        app.launch()
        XCTAssertTrue(app.buttons["randomBirth"].waitForExistence(timeout: 10))
        try capture("home", app: app, variant: variant)
        reveal(app.buttons["randomBirth"], in: app)
        app.buttons["randomBirth"].tap()
        XCTAssertTrue(app.buttons["enterChildhood"].waitForExistence(timeout: 10))
        try capture("birth", app: app, variant: variant)
        app.terminate()

        let directory = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "interaction-fixtures", withExtension: nil))
        for name in ["13-before", "13-ask", "72-ahe"] {
            app.launchArguments = ["-ui-testing", "-reset-save", "-visual-loop-capture", "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
            app.launchEnvironment["LIFE_VISUAL_ARCHIVE_PATH"] = directory.appendingPathComponent(name + ".json").path
            app.launch()
            XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10)); app.buttons["resumeLife"].tap()
            XCTAssertTrue(app.otherElements["lifeWorldScene"].waitForExistence(timeout: 5))
            let checksum = try XCTUnwrap(app.staticTexts["uiTestArchiveChecksum"].value as? String)
            XCTAssertEqual(checksum.count, 64)
            try capture(name, app: app, variant: variant)
            if name == "13-before" {
                let choice = app.buttons["choice.ask"]
                reveal(choice, in: app)
                XCTAssertTrue(choice.isHittable)
                try capture("choices", app: app, variant: variant)
            }
            if name == "13-ask" {
                let why = app.buttons["whyResult"]
                reveal(why, in: app)
                XCTAssertTrue(why.isHittable); why.tap()
                XCTAssertTrue(app.buttons["closeTrace"].waitForExistence(timeout: 5))
                try capture("explanation", app: app, variant: variant)
                app.buttons["closeTrace"].tap()
            }
            XCTAssertEqual(checksum, app.staticTexts["uiTestArchiveChecksum"].value as? String)
            print("READABILITY_ARCHIVE \(variant) \(name) \(checksum)")
            app.terminate()
        }
    }

    private func capture(_ name: String, app: XCUIApplication, variant: String) throws {
        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = "readability-\(name)-\(variant)-screen"; shot.lifetime = .keepAlways; add(shot)
        // Apple's native audit is additional evidence; the actual named sRGB pairs
        // are also measured independently, including high-contrast variants.
        var findings: [String] = []
        try app.performAccessibilityAudit(for: .contrast) { issue in
            let element = issue.element
            print("READABILITY_ISSUE \(name) \(variant) id=\(element?.identifier ?? "nil") label=\(element?.label ?? "nil") \(issue.compactDescription)")
            // Apple's audit samples the AX rectangle even when the scroll mask or
            // pinned world/footer covers that rectangle. Audit fully visible text;
            // retain clipped findings separately rather than claiming those were tested.
            // The selected action is scrolled completely into view before this audit.
            let drawer = app.scrollViews["worldDecisionDrawer"]
            if let element, element.elementType == .staticText, drawer.exists,
               drawer.staticTexts.matching(NSPredicate(format: "label == %@", element.label)).firstMatch.exists {
                var viewport = drawer.frame
                let footer = app.descendants(matching: .any).matching(identifier: "worldPlaybackControls").firstMatch
                if footer.exists { viewport.size.height = max(0, min(viewport.maxY, footer.frame.minY) - viewport.minY) }
                if !viewport.contains(element.frame) {
                    print("READABILITY_CLIPPED_TEXT_NOT_AUDITED \(name) \(variant) label=\(element.label) frame=\(element.frame) viewport=\(viewport)")
                    return true
                }
            }
            findings.append("\(element?.identifier ?? "nil")|\(element?.label ?? "nil")|\(issue.compactDescription)")
            return true // retain all audit findings; do not stop capture at the first native-tool finding
        }
        let report = XCTAttachment(string: findings.joined(separator: "\n"))
        report.name = "readability-\(name)-\(variant)-audit.txt"; report.lifetime = .keepAlways; add(report)
        print("READABILITY_AUDIT \(name) \(variant) visibleFindings=\(findings.count) result=\(findings.isEmpty ? "PASS" : "FINDINGS_RETAINED")")
    }
    private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<32 {
            if ["lifeWorldScene", "resumeBranch", "enterChildhood"].contains(element.identifier), element.exists, element.isHittable { return }
            let sheet = ["closeTrace", "closeComparison", "closeBranchComparison", "closeForkPicker", "closeFullEvent", "cancelParallel", "enterChildhood"].contains { app.buttons[$0].exists }
            let footer = app.buttons["continueLife"].exists && !sheet
            let worldFooter = app.descendants(matching: .any).matching(identifier: "worldPlaybackControls").firstMatch
            let pinnedDrawer = app.scrollViews["worldDecisionDrawer"]
            let comparisonScroll = app.scrollViews.containing(.staticText, identifier: "branchComparisonTitle").firstMatch
            let scroll = comparisonScroll.exists ? comparisonScroll : app.scrollViews["eventStoryScroll"].exists ? app.scrollViews["eventStoryScroll"] : pinnedDrawer.exists && !sheet ? pinnedDrawer : app.scrollViews.firstMatch
            let scrollTop = max(app.frame.minY + 90, scroll.exists ? scroll.frame.minY + 8 : 100)
            let footerTop = worldFooter.exists && !sheet ? worldFooter.frame.minY - 8 : app.frame.maxY - (footer ? 110 : 24)
            let bottom = min(footerTop, scroll.exists ? scroll.frame.maxY - 8 : footerTop)
            if element.exists && element.isHittable && element.frame.minY >= scrollTop && element.frame.maxY <= bottom {
                if pinnedDrawer.exists && !sheet {
                    print("LL07_REVEALED \(element.identifier): target=\(element.frame), visible=\(scrollTop)...\(bottom), controls=\(worldFooter.exists ? worldFooter.frame : .zero)")
                }
                return
            }
            // Drag within the actual scroll viewport, excluding the pinned world and control strip.
            let scrollHeight = max(44, bottom - scrollTop)
            if pinnedDrawer.exists && !sheet {
                // A full-height flick can overshoot an SE target and oscillate forever.
                // Move its observed center toward the viewport center and stop before release.
                let distance = element.exists ? element.frame.midY - (scrollTop + bottom) / 2 : scrollHeight
                let delta = min(scrollHeight * 0.55, max(-scrollHeight * 0.55, distance))
                let fromY = scrollTop + scrollHeight * (delta >= 0 ? 0.78 : 0.22)
                let toY = fromY - delta
                print("LL07_REVEAL \(element.identifier): target=\(element.exists ? element.frame : .zero), viewport=\(scroll.frame), drag=\(fromY)->\(toY)")
                let from = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: (fromY - app.frame.minY) / app.frame.height))
                let to = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: (toY - app.frame.minY) / app.frame.height))
                from.press(forDuration: 0.05, thenDragTo: to, withVelocity: .slow, thenHoldForDuration: 0.2)
                continue
            }
            let upperY = scrollTop + scrollHeight * 0.2
            let lowerY = scrollTop + scrollHeight * 0.8
            let upper = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: (upperY - app.frame.minY) / app.frame.height))
            let lower = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: (lowerY - app.frame.minY) / app.frame.height))
            if element.exists && element.frame.midY < scrollTop { upper.press(forDuration: 0.05, thenDragTo: lower) }
            else { lower.press(forDuration: 0.05, thenDragTo: upper) }
        }
        let failure = XCTAttachment(screenshot: app.screenshot()); failure.name = "unrevealed"; failure.lifetime = .keepAlways; add(failure)
        XCTFail("Could not reveal an unobscured tap target: \(element.identifier); exists=\(element.exists)")
    }
}
#endif
