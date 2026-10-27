import XCTest

@MainActor
final class LifeCrossroadsUITests: XCTestCase {
    func testBirthStoryRandomReceiptSurvivesFailureAndColdResume() throws {
        let app = launch(seed: "34", failingSaves: "1", world: true, overview: true, randomBirth: true)
        let draw = app.buttons["randomBirth"]; reveal(draw, in: app); draw.tap()
        assertSaveFailure(in: app)
        XCTAssertFalse(app.staticTexts["birthReveal"].exists)
        XCTAssertFalse(app.buttons["resumeLife"].exists)
        draw.tap()
        XCTAssertTrue(app.staticTexts["birthReveal"].waitForExistence(timeout: 8))
        let country = try XCTUnwrap(app.staticTexts["birthCountry"].value as? String)
        let household = try XCTUnwrap(app.staticTexts["birthHousehold"].value as? String)
        attachScreenshot("lx04-birth-reveal", app: app)
        let enter = app.buttons["enterChildhood"]; reveal(enter, in: app); enter.tap()
        if app.buttons["worldPause"].label == "暫停播放" { app.buttons["worldPause"].tap() }
        skipWorldMontage(app)
        let checksum = try archiveChecksum(in: app)
        let scene = app.otherElements["lifeWorldScene"]
        if !scene.exists { print("LX04_SCENE_TREE\n\(app.debugDescription)") }
        XCTAssertTrue(scene.exists); XCTAssertGreaterThan(scene.frame.height, 140)
        attachScreenshot("lx04-world-first", app: app)
        app.terminate(); app.launchArguments.removeAll { $0 == "-reset-save" }; app.launch()
        app.buttons["resumeLife"].tap()
        XCTAssertFalse(app.staticTexts["birthReveal"].exists, "Resuming cannot draw a new birth")
        XCTAssertEqual(try archiveChecksum(in: app), checksum)
        let background = app.buttons["lifeSituation"]; reveal(background, in: app); background.tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", household.hasSuffix("-1") ? "共用設備" : "獨用設備")).firstMatch.exists)
        XCTAssertFalse(country.isEmpty)
    }

    func testBirthStoryWorldAndContextRemainReadableAtMaximumType() throws {
        let app = launch(seed: "34", largestText: true, world: true, overview: true, randomBirth: true)
        let draw = app.buttons["randomBirth"]; reveal(draw, in: app); draw.tap()
        XCTAssertTrue(app.staticTexts["birthReveal"].waitForExistence(timeout: 8))
        let enter = app.buttons["enterChildhood"]; reveal(enter, in: app); enter.tap()
        if app.buttons["worldPause"].label == "暫停播放" { app.buttons["worldPause"].tap() }
        skipWorldMontage(app)
        let scene = app.otherElements["lifeWorldScene"]
        if !scene.exists { print("LX04_SCENE_TREE\n\(app.debugDescription)") }
        XCTAssertTrue(scene.exists); XCTAssertGreaterThanOrEqual(scene.frame.height, 120)
        let read = app.buttons["readFullEvent"]; reveal(read, in: app); read.tap()
        let question = app.staticTexts["eventStoryQuestion"]; reveal(question, in: app)
        XCTAssertTrue(question.isHittable)
        attachScreenshot("lx04-maximum-reader", app: app)
        app.buttons["closeFullEvent"].tap()
        let rest = app.buttons["choice.rest"]; reveal(rest, in: app); XCTAssertTrue(rest.isHittable); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
    }

    func testBirthStoryParallelOriginalSaveFailureAndFullComparison() throws {
        let app = launch(seed: "34", failingSaves: "32", world: true, overview: true)
        startWorldPaused(app)
        var originals: [Int: VisibleRecord] = [:]
        for index in 0..<15 {
            let choice = app.buttons["choice.\(index == 3 ? "offline" : "rest")"]
            reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            if [0, 3, 4, 7, 14].contains(index) { originals[index] = try recordOutcome(in: app) }
            if index == 3 { attachScreenshot("lx04-paper-memory", app: app) }
            app.buttons["continueLife"].tap(); skipWorldMontage(app)
        }
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 8))
        let checksum = try archiveChecksum(in: app)
        let picker = app.buttons["openParallelPicker"]; reveal(picker, in: app); picker.tap()
        let family = app.buttons["parallelHousehold.ken-2"]; reveal(family, in: app); family.tap()
        let begin = app.buttons["beginParallel"]; reveal(begin, in: app); begin.tap()
        assertSaveFailure(in: app)
        XCTAssertFalse(app.staticTexts["birthReveal"].exists)
        app.buttons["cancelParallel"].tap()
        XCTAssertEqual(try archiveChecksum(in: app), checksum)
        picker.tap(); reveal(family, in: app); family.tap(); reveal(begin, in: app); begin.tap()
        XCTAssertTrue(app.staticTexts["birthReveal"].waitForExistence(timeout: 8))
        XCTAssertEqual(app.staticTexts["birthCountry"].value as? String, "KEN")
        let enter = app.buttons["enterChildhood"]; reveal(enter, in: app); enter.tap()
        if app.buttons["worldPause"].label == "暫停播放" { app.buttons["worldPause"].tap() }
        skipWorldMontage(app)
        let pairChecksum = try archiveChecksum(in: app)
        app.terminate(); app.launchArguments.removeAll { $0 == "-reset-save" || $0 == "-ui-fail-save-at" || $0 == "32" }; app.launch()
        app.buttons["resumeLife"].tap()
        XCTAssertEqual(try archiveChecksum(in: app), pairChecksum)
        let original = app.buttons["viewOriginal"]; reveal(original, in: app); original.tap()
        try assertOriginalHistory(originals, in: app)
        XCTAssertEqual(try archiveChecksum(in: app), pairChecksum)
        let resume = app.buttons["resumeBranch"]; reveal(resume, in: app); resume.tap()
        var alternatives: [Int: VisibleRecord] = [:]
        for index in 0..<15 {
            let choice = app.buttons["choice.\(index == 3 ? "invest" : "rest")"]
            reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            if [0, 3, 4, 14].contains(index) { alternatives[index] = try recordOutcome(in: app) }
            app.buttons["continueLife"].tap(); skipWorldMontage(app)
        }
        let compare = app.buttons["compareParallel"]; reveal(compare, in: app); compare.tap()
        XCTAssertEqual(app.staticTexts["branchComparisonCount"].value as? String, "15")
        attachScreenshot("lx04-parallel-stories", app: app)
        for index in [3, 4, 14] {
            try assertComparison(XCTUnwrap(originals[index]), prefix: "branch.\(index).original", in: app)
            try assertComparison(XCTUnwrap(alternatives[index]), prefix: "branch.\(index).alternative", in: app)
        }
    }

    func testLifeOverviewFocusPersistsWithoutRerollingTheVisibleEvent() throws {
        let app = launch(seed: "0", world: true, overview: true)
        start(app)
        if app.buttons["worldPause"].label == "暫停播放" { app.buttons["worldPause"].tap() }
        XCTAssertTrue(app.staticTexts["lifeBackground"].label.contains("日本"))
        XCTAssertTrue(app.buttons["lifeSituation"].exists)
        let event = app.staticTexts["eventTitle"].value as? String
        let before = try archiveChecksum(in: app)
        let focus = app.buttons["lifeFocus"]; reveal(focus, in: app); focus.tap()
        XCTAssertFalse(app.buttons["focusChoice.stability"].exists, "Adult financial direction is not a child's responsibility")
        app.buttons["focusChoice.learning"].tap()
        XCTAssertTrue(app.buttons["lifeFocus"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["lifeFocus"].label.contains("留時間學習"))
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, event)
        let chosen = try archiveChecksum(in: app)
        XCTAssertNotEqual(before, chosen)
        attachScreenshot("lx01-life-overview", app: app)
        app.terminate(); app.launchArguments.removeAll { $0 == "-reset-save" }; app.launch()
        XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 8)); app.buttons["resumeLife"].tap()
        XCTAssertEqual(try archiveChecksum(in: app), chosen)
        XCTAssertTrue(app.buttons["lifeFocus"].label.contains("留時間學習"))
        let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
        app.buttons["continueLife"].tap()
        let details = app.buttons["focusReceiptDetails"]; reveal(details, in: app); details.tap()
        let receipt = app.staticTexts["lifeFocusReceipt"]; XCTAssertTrue(receipt.waitForExistence(timeout: 5))
        XCTAssertTrue(receipt.label.contains("技能 +1"))
        attachScreenshot("lx03-focus-arrival", app: app)
    }

    func testLifeOverviewFocusSaveFailureKeepsArchiveAndDirectionUntilRetry() throws {
        let app = launch(seed: "0", failingSaves: "2", overview: true)
        start(app)
        let before = try archiveChecksum(in: app)
        reveal(app.buttons["lifeFocus"], in: app); app.buttons["lifeFocus"].tap(); reveal(app.buttons["focusChoice.recovery"], in: app); app.buttons["focusChoice.recovery"].tap()
        assertSaveFailure(in: app)
        if app.buttons["closeFocus"].exists { app.buttons["closeFocus"].tap() }
        XCTAssertEqual(try archiveChecksum(in: app), before)
        XCTAssertTrue(app.buttons["lifeFocus"].label.contains("順其自然"))
        reveal(app.buttons["lifeFocus"], in: app); app.buttons["lifeFocus"].tap(); reveal(app.buttons["focusChoice.recovery"], in: app); app.buttons["focusChoice.recovery"].tap()
        XCTAssertTrue(app.buttons["lifeFocus"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["lifeFocus"].label.contains("照顧自己"))
        XCTAssertNotEqual(try archiveChecksum(in: app), before)
    }

    func testLifeOverviewLargeTextReadingAndAllLifeStagesRemainReachable() throws {
        let app = launch(seed: "0", largestText: true, overview: true)
        start(app)
        let read = app.buttons["readFullEvent"]; reveal(read, in: app); read.tap()
        let question = app.staticTexts["eventStoryQuestion"]; reveal(question, in: app)
        XCTAssertTrue(question.isHittable)
        app.buttons["closeFullEvent"].tap()
        attachScreenshot("lx01-largest-reading", app: app)
        for index in 0..<15 {
            XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5), "Decision \(index)")
            let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
            let next = app.buttons["continueLife"]; XCTAssertTrue(next.waitForExistence(timeout: 5)); next.tap()
        }
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        let fork = app.buttons["openForkPicker"]; reveal(fork, in: app)
        XCTAssertTrue(fork.isHittable)
        attachScreenshot("lx01-largest-review", app: app)
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testWorldFullEventReadingPreservesTheDecisionAndArchiveAtNormalAndMaximumText() throws {
        // Literal final paragraphs/questions are reviewed narrative fixtures, not renderer output.
        for largest in [false, true] {
            let app = launch(seed: "0", largestText: largest, world: true)
            startWorldPaused(app)
            for (age, ending, question) in [
                (8, "你可以說出自己的期待，也可以先休息。讓生活運作起來，是大人和社會一起負責的事。", "我可以說出自己想做的事嗎？"),
                (13, "你想走哪條路？兩種作品都可能累積經驗，也能先找人商量或保留課後時間。", "同樣投入，為什麼準備成本不同？")
            ] {
                let before = try archiveChecksum(in: app)
                let eventID = app.staticTexts["eventTitle"].value as? String
                let sceneFrame = app.otherElements["lifeWorldScene"].frame
                let read = app.buttons["readFullEvent"]; reveal(read, in: app); read.tap()
                let finalParagraph = app.staticTexts["eventStoryParagraph.1"]
                XCTAssertTrue(finalParagraph.waitForExistence(timeout: 5))
                XCTAssertEqual(finalParagraph.label, ending)
                let prompt = app.staticTexts["eventStoryQuestion"]; reveal(prompt, in: app)
                XCTAssertEqual(prompt.label, question)
                XCTAssertTrue(prompt.isHittable, "The end of the full story must be reachable")
                let storyScroll = app.scrollViews["eventStoryScroll"]
                let visibleBottom = min(storyScroll.frame.maxY, app.frame.maxY) - 8
                // A hittable middle does not prove the last line can be read. Keep the
                // real final edge visible even if a very long prompt begins above the viewport.
                for _ in 0..<8 {
                    if prompt.frame.maxY <= visibleBottom { break }
                    storyScroll.swipeUp(velocity: .slow)
                }
                XCTAssertLessThanOrEqual(prompt.frame.maxY, visibleBottom, "The final question line must be visible")
                attachScreenshot("ll07-full-event-\(age)-\(largest ? "maximum" : "normal")", app: app)
                app.buttons["closeFullEvent"].tap()
                XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
                XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, eventID)
                XCTAssertEqual(try archiveChecksum(in: app), before)
                XCTAssertFalse(app.staticTexts["chosenAction"].exists)
                XCTAssertEqual(app.otherElements["lifeWorldScene"].frame.height, sceneFrame.height, accuracy: 1)
                if age == 8 {
                    for _ in 0..<3 {
                        let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
                        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
                        app.buttons["continueLife"].tap(); skipWorldMontage(app)
                    }
                }
            }
            app.terminate()
        }
    }

    func testWorldActivityPropsOnlyFollowSavedChoicesAtEightAndThirteen() throws {
        // Labels come from the reviewed LL08 mapping, not from the production renderer.
        for (choice, expectedProp, childChoice, childProp) in [
            ("invest", "線上圖解", "ask", "求助紀錄"),
            ("offline", "紙本練習", "invest", "紙箱練習"),
            ("ask", "求助紀錄", "rest", "收好紙箱"),
            ("rest", "保留時間", "rest", "收好紙箱")
        ] {
            let app = launch(seed: "0", world: true)
            startWorldPaused(app)
            let scene = app.otherElements["lifeWorldScene"]
            XCTAssertFalse((scene.value as? String ?? "").contains("場景物件：8歲"))
            for index in 0..<3 {
                let action = app.buttons["choice.\(index == 0 ? childChoice : "rest")"]
                reveal(action, in: app); action.tap()
                XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
                if index == 0 {
                    XCTAssertTrue((scene.value as? String ?? "").contains("場景物件：8歲的\(childProp)"))
                    attachScreenshot("ll08-eight-\(childChoice)", app: app)
                }
                app.buttons["continueLife"].tap(); skipWorldMontage(app)
            }
            XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "teen-project")
            XCTAssertFalse((scene.value as? String ?? "").contains("場景物件：13歲"))
            let action = app.buttons["choice.\(choice)"]; reveal(action, in: app); action.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            XCTAssertTrue((scene.value as? String ?? "").contains("場景物件：13歲的\(expectedProp)"))
            XCTAssertEqual((scene.value as? String ?? "").contains("留下線索，尚未實現"), choice == "invest")
            if choice == "rest" { XCTAssertFalse(scene.label.contains("樹老師")) }
            attachScreenshot("ll08-thirteen-\(choice)", app: app)
            app.terminate()
        }
    }

    func testWorldKeepsScenePinnedAcrossEventOutcomeAndDrawerScroll() throws {
        let app = launch(seed: "0", world: true)
        let start = app.buttons["startLife"]; reveal(start, in: app); start.tap()
        let pause = app.buttons["worldPause"]
        XCTAssertTrue(pause.waitForExistence(timeout: 5)); pause.tap()
        let scene = app.otherElements["lifeWorldScene"]
        XCTAssertTrue(scene.waitForExistence(timeout: 5))
        let initial = scene.frame
        print("LL07_INITIAL_SCENE=\(initial); STATE=\(app.staticTexts["worldPlaybackState"].value ?? "missing")")
        XCTAssertGreaterThanOrEqual(initial.height, 200, "The world remains legible on an SE during decisions")
        skipWorldMontage(app)
        XCTAssertEqual(scene.frame.height, initial.height, accuracy: 1)
        XCTAssertEqual(scene.frame.minY, initial.minY, accuracy: 1)
        let first = app.buttons["choice.invest"]
        XCTAssertTrue(first.isEnabled && first.isHittable, "A real feasible action must be available on the first screen")
        let controls = app.descendants(matching: .any).matching(identifier: "worldPlaybackControls").firstMatch
        XCTAssertLessThanOrEqual(controls.frame.height, 64)
        attachScreenshot("ll07-event-pinned-world", app: app)
        let saved = try archiveChecksum(in: app)
        reveal(app.buttons["compareChoice"], in: app)
        XCTAssertEqual(scene.frame.minY, initial.minY, accuracy: 1, "Only the drawer scrolls")
        XCTAssertEqual(scene.frame.height, initial.height, accuracy: 1)
        XCTAssertEqual(try archiveChecksum(in: app), saved)
        let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        print("LL07_OUTCOME_SCENE=\(scene.frame); FOOTER=\(controls.frame); STATE=\(app.staticTexts["worldPlaybackState"].value ?? "missing")")
        XCTAssertEqual(scene.frame.height, initial.height, accuracy: 1)
        reveal(app.staticTexts["roundBudgetExplanation"], in: app)
        XCTAssertEqual(scene.frame.minY, initial.minY, accuracy: 1)
        XCTAssertLessThanOrEqual(controls.frame.height, 64)
        attachScreenshot("ll07-outcome-scrolled-world", app: app)
    }

    // New-world acceptance is separate from legacy Event-first regression cases below.
    func testWorldNaturallyRunsTwoEventsAndNeverChoosesForThePlayer() throws {
        let app = launch(seed: "0", world: true)
        let start = app.buttons["startLife"]; reveal(start, in: app); start.tap()
        XCTAssertTrue(app.staticTexts["livingTitle"].waitForExistence(timeout: 3))
        attachScreenshot("world-childhood-living", app: app)
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 6))
        let first = try XCTUnwrap(app.staticTexts["eventTitle"].value as? String)
        let checksum = try archiveChecksum(in: app)
        // Real event pause: speeding presentation does not submit a choice.
        app.buttons["worldSpeed"].tap()
        XCTAssertFalse(app.staticTexts["chosenAction"].exists)
        XCTAssertEqual(try archiveChecksum(in: app), checksum)
        let choice = app.buttons["choice.invest"]; reveal(choice, in: app); choice.tap()
        XCTAssertTrue(app.staticTexts["livingTitle"].waitForExistence(timeout: 8), "Saved outcome returns to living without Continue")
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 8))
        XCTAssertNotEqual(app.staticTexts["eventTitle"].value as? String, first)
        XCTAssertTrue(app.otherElements["lifeWorldScene"].label.contains("10歲"), "World cache must follow the committed session, not the old event")
        attachScreenshot("world-second-real-event", app: app)
        // Normal-speed second outcome must naturally resume too.
        app.buttons["worldSpeed"].tap()
        let nextChoice = app.buttons["choice.rest"]; reveal(nextChoice, in: app); nextChoice.tap()
        XCTAssertTrue(app.staticTexts["livingTitle"].waitForExistence(timeout: 8))
        attachScreenshot("world-next-living", app: app)
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 8))
        let previous = app.buttons["whyPrevious"]; reveal(previous, in: app); previous.tap()
        XCTAssertTrue(app.staticTexts["actualInfluences"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["actualInfluences"].label.contains("你的選擇"))
        app.buttons["closeTrace"].tap()
    }

    func testWorldSaveFailuresDoNotPublishReactionsOrAdvanceAndRetryWorks() throws {
        let app = launch(seed: "0", failingSaves: "2,4", world: true)
        startWorldPaused(app)
        let firstEvent = app.staticTexts["eventTitle"].value as? String
        let firstAction = app.buttons["choice.invest"]
        XCTAssertTrue(firstAction.isHittable)
        XCTAssertLessThan(firstAction.frame.midY, app.frame.maxY - 68, "SE first screen must offer an action above playback controls")
        attachScreenshot("world-se-first-action", app: app)
        let before = try archiveChecksum(in: app)
        let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
        assertSaveFailure(in: app)
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, firstEvent)
        XCTAssertFalse(app.staticTexts["chosenAction"].exists)
        XCTAssertEqual(try archiveChecksum(in: app), before)
        reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        let saved = try archiveChecksum(in: app); XCTAssertNotEqual(saved, before)
        attachScreenshot("world-saved-rest-outcome", app: app)
        app.buttons["continueLife"].tap(); assertSaveFailure(in: app)
        XCTAssertTrue(app.staticTexts["chosenAction"].exists)
        XCTAssertEqual(try archiveChecksum(in: app), saved)
        XCTAssertTrue((app.staticTexts["worldPlaybackState"].value as? String ?? "").contains("committedOutcome|true|8|1|"))
        app.buttons["continueLife"].tap(); skipWorldMontage(app)
        XCTAssertNotEqual(app.staticTexts["eventTitle"].value as? String, firstEvent)
    }

    func testWorldRestorePauseSheetsAndRestartCancelKeepTheStoredOutcome() throws {
        let app = launch(seed: "0", world: true)
        startWorldPaused(app)
        let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        let saved = try archiveChecksum(in: app)
        app.terminate(); app.launchArguments.removeAll { $0 == "-reset-save" }; app.launch()
        XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10)); app.buttons["resumeLife"].tap()
        XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
        XCTAssertTrue((app.staticTexts["worldPlaybackState"].value as? String ?? "").contains("committedOutcome|true|8|1|"))
        openReason(in: app)
        XCTAssertEqual(try archiveChecksum(in: app), saved)
        app.buttons["closeTrace"].tap()
        app.buttons["restartMenu"].tap(); app.buttons["restartSame"].tap()
        let cancel = app.buttons["cancelRestart"]
        if cancel.waitForExistence(timeout: 1) { cancel.tap() }
        else if app.buttons["取消"].exists { app.buttons["取消"].tap() }
        else if app.buttons["Cancel"].exists { app.buttons["Cancel"].tap() }
        else {
            print("NATIVE_RESTART_DIALOG_DISMISS_OUTSIDE\n\(app.debugDescription)")
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.05, dy: 0.25)).tap()
        }
        XCTAssertTrue(app.buttons["confirmRestart"].waitForNonExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["chosenAction"].waitForExistence(timeout: 5))
        XCTAssertEqual(try archiveChecksum(in: app), saved)
        app.buttons["continueLife"].tap(); skipWorldMontage(app)
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "child-friend")
    }

    func testWorldMaximumTextRetainsActionsAndRealProjectConsequences() throws {
        let app = launch(seed: "0", largestText: true, world: true)
        startWorldPaused(app)
        let scene = app.otherElements["lifeWorldScene"]
        XCTAssertGreaterThanOrEqual(scene.frame.height, 150)
        let controls = app.descendants(matching: .any).matching(identifier: "worldPlaybackControls").firstMatch
        XCTAssertLessThanOrEqual(controls.frame.height, 64, "Large text must not expand the fixed playback footer")
        let drawer = app.scrollViews["worldDecisionDrawer"]
        XCTAssertGreaterThanOrEqual(drawer.frame.height, app.frame.height * 0.30)
        attachScreenshot("ll07-maximum-text-layout", app: app)
        let beforeSettings = try archiveChecksum(in: app)
        app.buttons["worldPlaybackOptions"].tap()
        XCTAssertTrue(app.buttons["worldSpeed"].waitForExistence(timeout: 3))
        app.buttons["worldSpeed"].tap()
        app.buttons["worldPlaybackOptions"].tap()
        XCTAssertTrue(app.buttons["worldSpeed"].label.contains("正常 1×"))
        app.buttons["worldSpeed"].tap()
        XCTAssertEqual(try archiveChecksum(in: app), beforeSettings, "Presentation settings cannot submit a life choice")
        for _ in 0..<3 {
            let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5)); app.buttons["continueLife"].tap()
            skipWorldMontage(app)
        }
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "teen-project")
        let paper = app.buttons["choice.offline"]; reveal(paper, in: app); XCTAssertTrue(paper.isHittable)
        attachScreenshot("world-workshop-maximum-text-event", app: app); paper.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        let memory = app.staticTexts["projectMemory"]; reveal(memory, in: app)
        XCTAssertTrue(memory.label.contains("紙本創作"))
        attachScreenshot("world-workshop-maximum-text-outcome", app: app)
        openReason(in: app); XCTAssertTrue(app.staticTexts["actualInfluences"].exists)
    }

    func testWorldDelayedProjectClueBecomesAnOccurredSeventeenYearEcho() throws {
        let app = launch(seed: "0", world: true)
        startWorldPaused(app)
        for _ in 0..<3 {
            let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            app.buttons["continueLife"].tap(); skipWorldMontage(app)
        }
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "teen-project")
        let project = app.buttons["choice.invest"]; reveal(project, in: app); project.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        let scene = app.otherElements["lifeWorldScene"]
        XCTAssertTrue((scene.value as? String ?? "").contains("留下線索，尚未實現"))
        reveal(scene, in: app)
        attachScreenshot("world-thirteen-pending-clue", app: app)
        app.buttons["continueLife"].tap()
        // Remain paused in the actual 13→17 time jump: this text is projected
        // from triggeredHooks, rather than a future invitation invented by the UI.
        let echo = app.staticTexts.matching(identifier: "worldChange.delayedConsequence").firstMatch
        XCTAssertTrue(echo.waitForExistence(timeout: 5))
        reveal(echo, in: app)
        XCTAssertTrue(echo.label.contains("17歲的呼應"))
        XCTAssertFalse(echo.label.contains("尚未實現"))
        attachScreenshot("world-seventeen-occurred-echo", app: app)
        app.buttons["skipLiving"].tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        XCTAssertTrue(scene.label.contains("17歲"))
    }

    func testWorldReducedMotionKeepsSceneFactsAndAccessibleChoices() throws {
        let app = launch(seed: "0", world: true)
        let preference = app.switches["worldReduceMotion"]
        reveal(preference, in: app)
        if preference.value as? String == "0" { preference.tap() }
        XCTAssertEqual(preference.value as? String, "1")
        startWorldPaused(app)
        let scene = app.otherElements["lifeWorldScene"]
        XCTAssertTrue(scene.exists)
        XCTAssertTrue(scene.label.contains("8歲"))
        let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["chosenAction"].exists)
        XCTAssertFalse((scene.value as? String ?? "").contains("這次意外"))
        attachScreenshot("world-reduced-motion-committed", app: app)
        app.buttons["continueLife"].tap(); skipWorldMontage(app)
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "child-friend")
        XCTAssertTrue(scene.label.contains("10歲"))
        // The setting uses the same branch as the system preference, but this case does not
        // claim that iOS VoiceOver focus or the system Settings UI was manually tested.
    }

    private func startWorldPaused(_ app: XCUIApplication) {
        let start = app.buttons["startLife"]; reveal(start, in: app); start.tap()
        let pause = app.buttons["worldPause"]; XCTAssertTrue(pause.waitForExistence(timeout: 5))
        if pause.label == "暫停播放" { pause.tap() }
        skipWorldMontage(app)
        XCTAssertTrue((app.staticTexts["worldPlaybackState"].value as? String ?? "").contains("|true|"), "Pause must remain active before choosing")
    }
    private func skipWorldMontage(_ app: XCUIApplication) {
        if app.staticTexts["eventTitle"].exists { return }
        let skip = app.buttons["skipLiving"]
        if skip.waitForExistence(timeout: 3) { skip.tap() }
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 6))
    }

    func testProjectWorkshopFourReactionsAndRestoredReceipt() throws {
        for (choice, caption, memory) in [("invest", "線上圖解", "線上創作"), ("offline", "紙本圖解", "紙本創作"),
                                          ("ask", "先說出需要", "未建立作品"), ("rest", "留給自己", "未建立作品")] {
            let app = launch(seed: "0")
            reachProject(in: app)
            XCTAssertTrue(app.staticTexts["projectSceneCaption"].label.contains("創作桌"))
            XCTAssertLessThan(app.buttons["choice.invest"].frame.minY, app.frame.maxY - 48,
                              "The event illustration must leave an action in the first screen")
            if choice == "offline" { attachScreenshot("workshop-invitation", app: app) }
            let action = app.buttons["choice.\(choice)"]
            reveal(action, in: app); action.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            XCTAssertTrue(app.staticTexts["projectSceneCaption"].label.contains(caption))
            let recorded = app.staticTexts["projectMemory"]
            reveal(recorded, in: app)
            XCTAssertTrue(recorded.label.contains(memory))
            let savedMemory = recorded.label
            XCTAssertEqual(app.staticTexts["projectPerson"].exists, choice != "rest")
            XCTAssertEqual(app.staticTexts["projectPending"].exists, choice == "invest")
            if choice == "rest" {
                XCTAssertFalse(app.staticTexts["projectChance"].exists)
                XCTAssertFalse(app.staticTexts["projectSupport"].exists)
                XCTAssertEqual(app.staticTexts["projectInfluences"].label, "本次實際參與：你的選擇")
            }
            let receipt = app.staticTexts["projectReceipt"]
            reveal(receipt, in: app)
            XCTAssertEqual(receipt.value as? String, "teen-project/13/\(choice)/0")
            let resources = app.staticTexts["outcomeResources"]
            reveal(resources, in: app)
            let actualResources = try XCTUnwrap(resources.value as? String)
            reveal(app.staticTexts["chosenAction"], in: app)
            attachScreenshot("workshop-\(choice)-committed", app: app)
            if choice == "offline" {
                let checksum = try archiveChecksum(in: app)
                app.terminate()
                app.launchArguments.removeAll { $0 == "-reset-save" }
                app.launch()
                let resume = app.buttons["resumeLife"]
                XCTAssertTrue(resume.waitForExistence(timeout: 10)); resume.tap()
                XCTAssertEqual(app.staticTexts["projectMemory"].label, savedMemory)
                XCTAssertEqual(app.staticTexts["outcomeResources"].value as? String, actualResources)
                let restored = app.staticTexts["projectReceipt"]
                reveal(restored, in: app)
                XCTAssertEqual(restored.value as? String, "teen-project/13/offline/0")
                XCTAssertEqual(try archiveChecksum(in: app), checksum)
            }
            app.terminate()
        }
    }

    func testProjectWorkshopDoesNotReactUntilSaveSucceedsWithLargeText() throws {
        let app = launch(seed: "0", largestText: true, failingSaves: "8")
        reachProject(in: app)
        let checksum = try archiveChecksum(in: app)
        let paper = app.buttons["choice.offline"]
        reveal(paper, in: app); paper.tap()
        assertSaveFailure(in: app)
        XCTAssertFalse(app.staticTexts["projectReceipt"].exists)
        XCTAssertFalse(app.staticTexts["chosenAction"].exists)
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "teen-project")
        XCTAssertEqual(try archiveChecksum(in: app), checksum)
        reveal(paper, in: app); paper.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        let memory = app.staticTexts["projectMemory"]
        reveal(memory, in: app)
        XCTAssertTrue(memory.label.contains("紙本創作"))
        attachScreenshot("workshop-large-text-saved", app: app)
        let receipt = app.staticTexts["projectReceipt"]
        reveal(receipt, in: app)
        XCTAssertEqual(receipt.value as? String, "teen-project/13/offline/0")
        XCTAssertNotEqual(try archiveChecksum(in: app), checksum)
    }

    private func reachProject(in app: XCUIApplication) {
        start(app)
        for _ in 0..<3 {
            let rest = app.buttons["choice.rest"]
            reveal(rest, in: app); rest.tap()
            let next = app.buttons["continueLife"]
            XCTAssertTrue(next.waitForExistence(timeout: 5)); next.tap()
        }
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "teen-project")
    }

    func testEightCountriesAndTaiwanComparisonLimitsAreVisible() throws {
        let app = launch(seed: "0")
        for code in ["TWN", "JPN", "USA", "DEU", "IND", "BRA", "VNM", "KEN"] {
            let country = app.buttons["country.\(code)"]
            reveal(country, in: app)
            XCTAssertTrue(country.isHittable)
            country.tap()
        }
        app.buttons["country.TWN"].tap()
        start(app)
        for _ in 0..<3 {
            let rest = app.buttons["choice.rest"]
            reveal(rest, in: app); rest.tap()
            let next = app.buttons["continueLife"]
            XCTAssertTrue(next.waitForExistence(timeout: 5))
            XCTAssertTrue(next.isHittable)
            next.tap()
        }
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "teen-project")
        XCTAssertTrue(app.staticTexts["choiceDataLimit.invest"].exists)
        openComparison("invest", in: app)
        let limit = app.staticTexts["comparisonDataLimit.TWN"]
        reveal(limit, in: app)
        XCTAssertTrue(limit.label.contains("資料不足"))
        attachScreenshot("lc03-taiwan-comparison-limit", app: app)
        let households = app.buttons["compareHouseholds"]
        reveal(households, in: app); households.tap()
        let boundary = app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "不是改寫出生家庭")).firstMatch
        reveal(boundary, in: app)
        XCTAssertTrue(boundary.exists)
        XCTAssertEqual(app.staticTexts["comparisonCostExplanation"].value as? String, "unknown")
        attachScreenshot("lc03-same-country-households", app: app)
    }

    func testCompleteLifeWithVisibleComparisonAndExecutedExplanation() throws {
        let app = launch(seed: "0")
        attachScreenshot("event-first-birth", app: app)
        let contextToggle = app.descendants(matching: .any).matching(identifier: "countryContextToggle").firstMatch
        reveal(contextToggle, in: app); contextToggle.tap()
        let context = app.staticTexts["countryStageBoundary"]
        reveal(context, in: app)
        XCTAssertTrue(context.label.contains("不是"))
        for indicator in ["IT.NET.USER.ZS", "EG.ELC.ACCS.ZS"] {
            XCTAssertTrue(app.descendants(matching: .any).matching(identifier: "countryIndicator.\(indicator)").firstMatch.exists)
        }
        attachScreenshot("country-context", app: app)
        reveal(contextToggle, in: app); contextToggle.tap()
        start(app)
        let first = app.buttons["choice.invest"]
        XCTAssertTrue(first.exists)
        XCTAssertLessThan(first.frame.minY, app.frame.maxY - 48, "An action must enter the first screen after the short story")
        attachScreenshot("event-first-decision", app: app)
        openComparison("invest", in: app)
        XCTAssertEqual(app.staticTexts["comparisonCostExplanation"].value as? String, "same")
        XCTAssertTrue(app.staticTexts["digitalComparisonInvitation"].exists)
        for country in ["日本", "美國", "印度", "肯亞"] { XCTAssertTrue(app.staticTexts[country].exists) }
        attachScreenshot("model-comparison", app: app)
        app.buttons["closeComparison"].tap()

        var eventIDs: [String] = []
        for index in 0..<15 {
            let title = app.staticTexts["eventTitle"]
            XCTAssertTrue(title.waitForExistence(timeout: 5))
            eventIDs.append(try XCTUnwrap(title.value as? String))
            if index == 3 {
                XCTAssertTrue(app.staticTexts["digitalLearningGuide"].exists)
                for (choiceID, expected) in [("invest", "different"), ("offline", "same")] {
                    openComparison(choiceID, in: app)
                    XCTAssertEqual(app.staticTexts["comparisonCostExplanation"].value as? String, expected)
                    attachScreenshot("teen-comparison-\(choiceID)", app: app)
                    app.buttons["closeComparison"].tap()
                }
            }
            let choice = try policyChoice(in: app)
            let selectedID = String(choice.identifier.dropFirst("choice.".count))
            reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, selectedID)
            if index == 1 || index == 3 {
                let memory = app.staticTexts["recordedStoryMemory"]
                reveal(memory, in: app)
                XCTAssertTrue(memory.exists)
            }
            if index == 0 {
                let budget = app.staticTexts["roundBudgetExplanation"]
                reveal(budget, in: app)
                XCTAssertTrue(budget.label.contains("不會累積"))
                attachScreenshot("event-first-outcome", app: app)
                openReason(in: app)
                XCTAssertTrue(app.staticTexts["actualInfluences"].label.contains("你的選擇"))
                app.buttons["closeTrace"].tap()
            }
            if [3, 10, 13].contains(index) { attachScreenshot("life-stage-\(index)", app: app) }
            app.buttons["continueLife"].tap()
        }
        XCTAssertEqual(eventIDs.count, 15)
        for id in Set(eventIDs) where id != "middle-rest-circle" { XCTAssertEqual(eventIDs.filter { $0 == id }.count, 1) }
        print("UI_EVENT_SEQUENCE_SEED_0=\(eventIDs.joined(separator: ","))")
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["endingSeed"].value as? String, "0")
        XCTAssertTrue(app.buttons["replaySame"].exists)
        let newSeed = app.buttons["replayNewSeed"]
        XCTAssertTrue(newSeed.exists)
        attachScreenshot("event-first-life-review", app: app)
        reveal(newSeed, in: app); newSeed.tap()
        app.buttons.matching(identifier: "confirmRestart").matching(NSPredicate(format: "label == %@", "取代紀錄並開始")).firstMatch.tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        let changedSeed = try XCTUnwrap(app.staticTexts["lifeSeed"].value as? String)
        XCTAssertNotEqual(changedSeed, "0")
        app.buttons["restartMenu"].tap()
        app.buttons["restartSame"].tap()
        app.buttons.matching(identifier: "confirmRestart").matching(NSPredicate(format: "label == %@", "取代紀錄並開始")).firstMatch.tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["lifeSeed"].value as? String, changedSeed)
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, eventIDs.first)
    }

    func testRestAfterChoiceComparisonKeepsThePreChoiceState() throws {
        let app = launch(seed: "0")
        start(app)
        let rest = app.buttons["choice.rest"]
        reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "rest")
        let comparison = app.buttons["compareChosen"]
        reveal(comparison, in: app); comparison.tap()
        let selected = app.staticTexts["comparisonChoiceTitle"]
        XCTAssertTrue(selected.waitForExistence(timeout: 5))
        XCTAssertEqual(selected.value as? String, "rest")
        // Reviewed family-one fixture: rest raises health from 66 to 68. Comparison must use 66.
        XCTAssertEqual(app.staticTexts["comparisonPreState"].value as? String,
                       "health=66;financial=35;relationships=65;skills=20")
        XCTAssertEqual(app.staticTexts["comparisonCostExplanation"].value as? String, "same")
        attachScreenshot("post-choice-comparison-pre-state", app: app)
        app.buttons["closeComparison"].tap()
        openReason(in: app)
        let actual = app.staticTexts["actualInfluences"]
        XCTAssertTrue(actual.label.contains("你的選擇"))
        for absent in ["環境條件", "他人的協助", "機會事件", "家庭安排"] {
            XCTAssertFalse(actual.label.contains(absent), "Rest must not imply an unused cost/resource cause: \(absent)")
        }
        let usage = app.staticTexts["dataUsage"]
        reveal(usage, in: app)
        XCTAssertTrue(usage.label.contains("未使用"))
        attachScreenshot("rest-actual-influences", app: app)
    }

    func testSeedZeroOneTwoShowActualSelectedEvents() throws {
        var prefixes: [[String]] = []
        for seed in ["0", "1", "2"] {
            let app = launch(seed: seed)
            start(app)
            var events: [String] = []
            for index in 0..<3 {
                let title = app.staticTexts["eventTitle"]
                XCTAssertTrue(title.waitForExistence(timeout: 5))
                events.append(try XCTUnwrap(title.value as? String))
                if index == 2 {
                    attachScreenshot("seed-\(seed)-actual-twelve-year-event", app: app)
                    let details = app.descendants(matching: .any).matching(identifier: "eventSelectionDetails").firstMatch
                    reveal(details, in: app); details.tap()
                    let summary = app.staticTexts["eventSelectionSummary"]
                    XCTAssertTrue(summary.waitForExistence(timeout: 5))
                    XCTAssertTrue(summary.label.contains("12歲"))
                    if events.last == "child-library-map" {
                        let condition = app.staticTexts["selectedCondition.nearby-guide"]
                        XCTAssertTrue(condition.exists)
                        XCTAssertTrue(condition.label.contains("實際為2"))
                        XCTAssertTrue(condition.label.contains("至少1"))
                    }
                    attachScreenshot("seed-\(seed)-executed-selection-conditions", app: app)
                    break
                }
                let choice = try policyChoice(in: app)
                reveal(choice, in: app); choice.tap()
                XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
                app.buttons["continueLife"].tap()
            }
            XCTAssertEqual(app.staticTexts["lifeSeed"].value as? String, seed)
            prefixes.append(events)
            print("UI_EVENT_PREFIX_SEED_\(seed)=\(events.joined(separator: ","))")
            app.terminate()
        }
        // A short UI prefix need not differ for every pair. Domain/CLI verify all three complete lives.
        XCTAssertGreaterThan(Set(prefixes.map { $0.joined(separator: ",") }).count, 1)
    }

    func testMaximumTextCanReachActionsReasonComparisonAndContinue() throws {
        let app = launch(seed: "0", largestText: true)
        XCTAssertFalse(app.segmentedControls["countryPicker"].exists, "Accessibility text sizes must use the readable menu picker")
        attachScreenshot("maximum-text-birth", app: app)
        start(app)
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        attachScreenshot("maximum-text-event-first", app: app)
        let rest = app.buttons["choice.rest"]
        reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        openReason(in: app)
        XCTAssertTrue(app.staticTexts["actualInfluences"].label.contains("你的選擇"))
        attachScreenshot("maximum-text-reason", app: app)
        app.buttons["closeTrace"].tap()
        let comparison = app.buttons["compareChosen"]
        reveal(comparison, in: app); comparison.tap()
        let selected = app.staticTexts["comparisonChoiceTitle"]
        XCTAssertTrue(selected.waitForExistence(timeout: 5))
        XCTAssertEqual(selected.value as? String, "rest")
        attachScreenshot("maximum-text-comparison", app: app)
        app.buttons["closeComparison"].tap()
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "child-friend")
    }

    func testInvalidDevelopmentSeedDoesNotStartALife() {
        let app = launch(seed: "invalid")
        let start = app.buttons["startLife"]
        reveal(start, in: app); start.tap()
        XCTAssertTrue(app.alerts["需要留意"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.alerts.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "測試種子格式錯誤")).firstMatch.exists)
        XCTAssertFalse(app.staticTexts["eventTitle"].exists)
    }

    func testDecisionCardWhitespaceIsTappable() {
        let app = launch(seed: "0")
        start(app)
        let choice = app.buttons["choice.invest"]
        reveal(choice, in: app)
        // A visible choice card is one tap target, including the space beside its text.
        choice.coordinate(withNormalizedOffset: CGVector(dx: 0.8, dy: 0.5)).tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "invest")
    }

    func testWorldFullLifeForkPreservesOriginalAndComparesRemainder() throws {
        let app = launch(seed: "0", world: true)
        startWorldPaused(app)
        var originalEvents: [String] = []
        var originalRecords: [Int: VisibleRecord] = [:]
        for index in 0..<15 {
            skipWorldMontage(app)
            originalEvents.append(try XCTUnwrap(app.staticTexts["eventTitle"].value as? String))
            let choice = try policyChoice(in: app)
            reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            if [0, 3, 7, 14].contains(index) { originalRecords[index] = try recordOutcome(in: app) }
            app.buttons["continueLife"].tap()
        }
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        let open = app.buttons["openForkPicker"]; reveal(open, in: app); open.tap()
        let point = app.buttons["forkPoint.3"]; reveal(point, in: app); point.tap()
        let offline = app.buttons["forkChoice.offline"]
        XCTAssertTrue(offline.waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["forkChoice.invest"].isEnabled)
        attachScreenshot("lc04-fork-options", app: app)
        reveal(offline, in: app); offline.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "offline")
        var alternativeRecords = [3: try recordOutcome(in: app)]
        XCTAssertNotEqual(alternativeRecords[3]?.choiceID, originalRecords[3]?.choiceID)
        XCTAssertNotEqual(alternativeRecords[3]?.resources, originalRecords[3]?.resources)
        app.terminate()
        app.launchArguments.removeAll { $0 == "-reset-save" }
        app.launch()
        XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10))
        app.buttons["resumeLife"].tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "offline")
        let original = app.buttons["viewOriginal"]; reveal(original, in: app); original.tap()
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["endingSeed"].value as? String, "0")
        try assertOriginalHistory(originalRecords, in: app)
        let resume = app.buttons["resumeBranch"]; reveal(resume, in: app); resume.tap()
        app.buttons["continueLife"].tap()
        for index in 4..<15 {
            skipWorldMontage(app)
            let choice = app.buttons["choice.rest"]; reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            if [7, 14].contains(index) { alternativeRecords[index] = try recordOutcome(in: app) }
            app.buttons["continueLife"].tap()
        }
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        app.terminate(); app.launch()
        XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10))
        app.buttons["resumeLife"].tap()
        let preserved = app.buttons["viewOriginal"]; reveal(preserved, in: app); preserved.tap()
        try assertOriginalHistory(originalRecords, in: app)
        let returnToBranch = app.buttons["resumeBranch"]; reveal(returnToBranch, in: app); returnToBranch.tap()
        let compare = app.buttons["compareBranches"]; reveal(compare, in: app); compare.tap()
        XCTAssertTrue(app.staticTexts["branchComparisonTitle"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["branchComparisonCount"].value as? String, "12")
        app.buttons["comparisonMethod"].tap()
        XCTAssertTrue(app.staticTexts["branchComparisonScope"].label.contains("沒有自動代選"))
        app.buttons["comparisonMethod"].tap()
        for index in [3, 7, 14] {
            try assertComparison(try XCTUnwrap(originalRecords[index]), prefix: "branch.\(index).original", in: app)
            try assertComparison(try XCTUnwrap(alternativeRecords[index]), prefix: "branch.\(index).alternative", in: app)
        }
        attachScreenshot("lc04-complete-comparison", app: app)
        let last = app.descendants(matching: .any).matching(identifier: "branchRow.14").firstMatch
        reveal(last, in: app)
        XCTAssertTrue(last.exists)
        attachScreenshot("lc04-comparison-last-age", app: app)
        XCTAssertEqual(originalEvents.count, 15)
    }

    func testLifeOverviewFullForkPreservesOriginalAndComparesActualRemainder() throws {
        try exerciseFork(overview: true)
    }

    func testForkPreservesOriginalResumesAfterRelaunchAndComparesFullRemainder() throws {
        try exerciseFork(overview: false)
    }

    private func exerciseFork(overview: Bool) throws {
        let app = launch(seed: "0", overview: overview)
        start(app)
        if overview {
            let focus = app.buttons["lifeFocus"]; reveal(focus, in: app); focus.tap()
            app.buttons["focusChoice.learning"].tap()
        }
        var originalEvents: [String] = []
        var originalRecords: [Int: VisibleRecord] = [:]
        for index in 0..<15 {
            XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
            originalEvents.append(try XCTUnwrap(app.staticTexts["eventTitle"].value as? String))
            let choice = try policyChoice(in: app)
            reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            if [0, 3, 7, 14].contains(index) { originalRecords[index] = try recordOutcome(in: app) }
            app.buttons["continueLife"].tap()
        }
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        let open = app.buttons["openForkPicker"]; reveal(open, in: app); open.tap()
        let point = app.buttons["forkPoint.3"]; reveal(point, in: app); point.tap()
        let offline = app.buttons["forkChoice.offline"]
        XCTAssertTrue(offline.waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["forkChoice.invest"].isEnabled)
        attachScreenshot("lc04-fork-options", app: app)
        reveal(offline, in: app); offline.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "offline")
        var alternativeRecords = [3: try recordOutcome(in: app)]
        XCTAssertNotEqual(alternativeRecords[3]?.choiceID, originalRecords[3]?.choiceID)
        XCTAssertNotEqual(alternativeRecords[3]?.resources, originalRecords[3]?.resources)
        app.terminate()
        app.launchArguments.removeAll { $0 == "-reset-save" }
        app.launch()
        XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10))
        app.buttons["resumeLife"].tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "offline")
        let original = app.buttons["viewOriginal"]; reveal(original, in: app); original.tap()
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["endingSeed"].value as? String, "0")
        try assertOriginalHistory(originalRecords, in: app)
        let resume = app.buttons["resumeBranch"]; reveal(resume, in: app); resume.tap()
        app.buttons["continueLife"].tap()
        for index in 4..<15 {
            XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
            let choice = app.buttons["choice.rest"]; reveal(choice, in: app); choice.tap()
            XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
            if [7, 14].contains(index) { alternativeRecords[index] = try recordOutcome(in: app) }
            app.buttons["continueLife"].tap()
        }
        XCTAssertTrue(app.staticTexts["journeyComplete"].waitForExistence(timeout: 5))
        app.terminate(); app.launch()
        XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10))
        app.buttons["resumeLife"].tap()
        let preserved = app.buttons["viewOriginal"]; reveal(preserved, in: app); preserved.tap()
        try assertOriginalHistory(originalRecords, in: app)
        let returnToBranch = app.buttons["resumeBranch"]; reveal(returnToBranch, in: app); returnToBranch.tap()
        let compare = app.buttons["compareBranches"]; reveal(compare, in: app); compare.tap()
        XCTAssertTrue(app.staticTexts["branchComparisonTitle"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["branchComparisonCount"].value as? String, "12")
        app.buttons["comparisonMethod"].tap()
        XCTAssertTrue(app.staticTexts["branchComparisonScope"].label.contains("沒有自動代選"))
        app.buttons["comparisonMethod"].tap()
        for index in [3, 7, 14] {
            try assertComparison(try XCTUnwrap(originalRecords[index]), prefix: "branch.\(index).original", in: app)
            try assertComparison(try XCTUnwrap(alternativeRecords[index]), prefix: "branch.\(index).alternative", in: app)
        }
        attachScreenshot("lc04-complete-comparison", app: app)
        let last = app.descendants(matching: .any).matching(identifier: "branchRow.14").firstMatch
        reveal(last, in: app)
        XCTAssertTrue(last.exists)
        attachScreenshot("lc04-comparison-last-age", app: app)
        XCTAssertEqual(originalEvents.count, 15)
    }

    func testSaveFailuresKeepScreenAndArchiveThenRetryAndRelaunch() throws {
        // 1=start, 2=failed choice, 3=retry, 4=failed continue, 5=retry.
        let app = launch(seed: "0", failingSaves: "2,4")
        start(app)
        let firstEvent = app.staticTexts["eventTitle"].value as? String
        let originalChecksum = try archiveChecksum(in: app)
        let rest = app.buttons["choice.rest"]; reveal(rest, in: app); rest.tap()
        assertSaveFailure(in: app)
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, firstEvent)
        XCTAssertFalse(app.buttons["continueLife"].exists)
        XCTAssertEqual(try archiveChecksum(in: app), originalChecksum)
        reveal(rest, in: app); rest.tap()
        XCTAssertTrue(app.buttons["continueLife"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "rest")
        let choiceChecksum = try archiveChecksum(in: app)
        XCTAssertNotEqual(choiceChecksum, originalChecksum)
        app.buttons["continueLife"].tap()
        assertSaveFailure(in: app)
        XCTAssertTrue(app.buttons["continueLife"].exists)
        XCTAssertEqual(app.staticTexts["chosenAction"].value as? String, "rest")
        XCTAssertEqual(try archiveChecksum(in: app), choiceChecksum)
        app.buttons["continueLife"].tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "child-friend")
        let continuedChecksum = try archiveChecksum(in: app)
        XCTAssertNotEqual(continuedChecksum, choiceChecksum)
        app.terminate()
        app.launchArguments.removeAll { ["-reset-save", "-ui-fail-save-at", "2,4"].contains($0) }
        app.launch()
        XCTAssertTrue(app.buttons["resumeLife"].waitForExistence(timeout: 10))
        app.buttons["resumeLife"].tap()
        XCTAssertEqual(app.staticTexts["eventTitle"].value as? String, "child-friend")
        XCTAssertEqual(try archiveChecksum(in: app), continuedChecksum)
        print("W2_ARCHIVE_CHECKSUMS=\(originalChecksum),\(choiceChecksum),\(continuedChecksum)")
    }

    private struct VisibleRecord {
        let event: String
        let eventID: String
        let choice: String
        let choiceID: String
        let resources: String
    }

    private func recordOutcome(in app: XCUIApplication) throws -> VisibleRecord {
        let event = app.staticTexts["outcomeEvent"]
        let choice = app.staticTexts["chosenAction"]
        let resources = app.staticTexts["outcomeResources"]
        XCTAssertTrue(resources.waitForExistence(timeout: 5))
        return try VisibleRecord(event: event.label, eventID: XCTUnwrap(event.value as? String),
            choice: choice.label, choiceID: XCTUnwrap(choice.value as? String),
            resources: XCTUnwrap(resources.value as? String))
    }

    private func assertOriginalHistory(_ records: [Int: VisibleRecord], in app: XCUIApplication) throws {
        // Reviewed fixed schedule: first/middle/last decisions are ages 8, 32 and 80.
        for (index, age) in [(0, 8), (7, 32), (14, 80)] {
            let expected = try XCTUnwrap(records[index])
            let event = app.staticTexts["history.\(age).event"]
            reveal(event, in: app)
            XCTAssertEqual(event.label, expected.event)
            XCTAssertEqual(event.value as? String, expected.eventID)
            let choice = app.staticTexts["history.\(age).choice"]
            XCTAssertEqual(choice.label, expected.choice)
            XCTAssertEqual(choice.value as? String, expected.choiceID)
            XCTAssertEqual(app.staticTexts["history.\(age).resources"].value as? String, expected.resources)
        }
    }

    private func assertComparison(_ record: VisibleRecord, prefix: String, in app: XCUIApplication) throws {
        let event = app.staticTexts["\(prefix).event"]
        reveal(event, in: app)
        XCTAssertEqual(event.label, record.event)
        XCTAssertEqual(event.value as? String, record.eventID)
        let choice = app.staticTexts["\(prefix).choice"]
        XCTAssertTrue(choice.label.hasSuffix(record.choice))
        XCTAssertEqual(choice.value as? String, record.choiceID)
        let details = app.buttons["\(prefix).details"]; reveal(details, in: app); details.tap()
        let beforeAndAfter = record.resources.components(separatedBy: "；")
        XCTAssertEqual(beforeAndAfter.count, 2)
        XCTAssertEqual(app.staticTexts["\(prefix).before"].label, beforeAndAfter.first)
        XCTAssertEqual(app.staticTexts["\(prefix).after"].label, beforeAndAfter.last)
    }

    private func archiveChecksum(in app: XCUIApplication) throws -> String {
        let value = try XCTUnwrap(app.staticTexts["uiTestArchiveChecksum"].value as? String)
        XCTAssertEqual(value.count, 64, "Read the actual archived bytes, not a missing-file placeholder")
        return value
    }

    private func assertSaveFailure(in app: XCUIApplication) {
        let alert = app.alerts["需要留意"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        XCTAssertTrue(alert.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "這次操作沒有生效")).firstMatch.exists)
        alert.buttons["知道了"].tap()
    }

    private func launch(seed: String, largestText: Bool = false, failingSaves: String? = nil, world: Bool = false, overview: Bool = false, randomBirth: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-ui-testing", "-legacy-event-first", "-reset-save", "-life-seed", seed,
                                "-AppleLanguages", "(zh-Hant)", "-AppleLocale", "zh_TW"]
        if !overview { app.launchArguments += ["-legacy-life-overview"] }
        if largestText {
            app.launchArguments += ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        }
        if let failingSaves { app.launchArguments += ["-ui-fail-save-at", failingSaves] }
        if world { app.launchArguments.removeAll { $0 == "-legacy-event-first" } }
        app.launch()
        XCTAssertTrue(app.buttons["randomBirth"].waitForExistence(timeout: 10))
        if !randomBirth {
            let explore = app.buttons["exploreBirth"]; reveal(explore, in: app); explore.tap()
            reveal(app.buttons["startLife"], in: app)
        }
        return app
    }

    private func start(_ app: XCUIApplication) {
        let button = app.buttons["startLife"]
        reveal(button, in: app); button.tap()
        XCTAssertTrue(app.staticTexts["eventTitle"].waitForExistence(timeout: 5))
    }

    private func policyChoice(in app: XCUIApplication) throws -> XCUIElement {
        // Prefer a concrete active option, then support/rest; event selection remains in the engine.
        let invest = app.buttons["choice.invest"]
        if invest.exists && invest.isEnabled { return invest }
        let options = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "choice.")).allElementsBoundByIndex
        if let active = options.first(where: { $0.exists && $0.isEnabled && !["choice.rest", "choice.ask", "choice.seekGuide"].contains($0.identifier) }) { return active }
        return try XCTUnwrap(options.first { $0.exists && $0.isEnabled }, "Every event must retain a feasible action")
    }

    private func openComparison(_ choiceID: String, in app: XCUIApplication) {
        let button = app.buttons["compareChoice"]
        reveal(button, in: app); button.tap()
        app.buttons["compare.\(choiceID)"].tap()
        let selected = app.staticTexts["comparisonChoiceTitle"]
        XCTAssertTrue(selected.waitForExistence(timeout: 5))
        XCTAssertEqual(selected.value as? String, choiceID)
    }

    private func openReason(in app: XCUIApplication) {
        let button = app.buttons["whyResult"]
        reveal(button, in: app); button.tap()
        if !app.staticTexts["actualInfluences"].waitForExistence(timeout: 5) {
            print("WHY_PRESENTATION_FAILURE\n\(app.debugDescription)")
            attachScreenshot("why-presentation-failure", app: app)
            XCTFail("The executed explanation must be visible")
        }
    }

    private func attachScreenshot(_ name: String, app: XCUIApplication) {
        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = name; shot.lifetime = .keepAlways; add(shot)
    }

    private func reveal(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<32 {
            if element.identifier == "lifeWorldScene", element.exists, element.isHittable { return }
            let footer = app.buttons["continueLife"].exists && !app.buttons["closeTrace"].exists && !app.buttons["closeComparison"].exists && !app.buttons["closeFullEvent"].exists
            let worldFooter = app.descendants(matching: .any).matching(identifier: "worldPlaybackControls").firstMatch
            let sheet = app.buttons["closeTrace"].exists || app.buttons["closeComparison"].exists || app.buttons["closeFullEvent"].exists
            let pinnedDrawer = app.scrollViews["worldDecisionDrawer"]
            let scroll = app.scrollViews["eventStoryScroll"].exists ? app.scrollViews["eventStoryScroll"] : pinnedDrawer.exists && !sheet ? pinnedDrawer : app.scrollViews.firstMatch
            let scrollTop = max(app.frame.minY + 90, scroll.exists ? scroll.frame.minY + 8 : 100)
            let footerTop = worldFooter.exists && !sheet ? worldFooter.frame.minY - 8 : app.frame.maxY - (footer ? 110 : 24)
            let bottom = min(footerTop, scroll.exists ? scroll.frame.maxY - 8 : footerTop)
            if element.exists && element.isHittable && element.frame.midY > scrollTop && element.frame.midY < bottom {
                if pinnedDrawer.exists && !sheet {
                    print("LL07_REVEALED \(element.identifier): target=\(element.frame), visible=\(scrollTop)...\(bottom), controls=\(worldFooter.frame)")
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
        attachScreenshot("unrevealed-\(element.identifier)", app: app)
        XCTFail("Could not reveal an unobscured tap target: \(element.identifier); exists=\(element.exists)")
    }
}
