import XCTest
@testable import LifeDomain
import LifeData
import LifePersistence
import LifePresentation

final class ExperienceCompletionTests: XCTestCase {
    private func state(_ age: Int, code: String = "JPN", family: Int = 1, seed: UInt64 = 34, catalog: ModelCatalog) throws -> LifeState {
        try SimulationEngine.advance(LifeState.born(catalog: catalog, countryCode: code, householdID: "\(code.lowercased())-\(family)", seed: seed), to: age, catalog: catalog).0
    }
    private func project(_ id: String, _ state: LifeState, _ c: ModelCatalog) throws -> StoryProjection {
        try StoryBranchEngine.project(event: XCTUnwrap(c.decisions.first { $0.id == id }), state: state, catalog: c)
    }
    func testFourCompletedFocusIntervalsUnlockDistinctActionsWithoutPromisingParticipation() throws {
        let c = try StatisticsRepository.bundled()
        let cases: [(LifeFocus, String, String)] = [(.learning,"child-lending-notebook","shareDraft"),
            (.relationships,"teen-friend-return","makeTime"),(.recovery,"adult-boundary-calendar","pacedRole"),(.stability,"adult-buffer-envelope","stagedPlan")]
        for (focus,id,choice) in cases {
            let before = try state(25, catalog: c)
            XCTAssertFalse(try project(id, before, c).event.choices.contains { $0.id == choice })
            let after = try SimulationEngine.advance(before, to: 32, catalog: c, focus: focus).0
            let p = try project(id, after, c)
            XCTAssertTrue(p.event.choices.contains { $0.id == choice })
            XCTAssertEqual(p.evaluation?.focusSource?.fromAge,25)
            XCTAssertEqual(p.evaluation?.focusSource?.toAge,32)
            XCTAssertNil(p.evaluation?.sourceChoiceID)
            XCTAssertTrue(after.story.flags.isEmpty)
            let unrelated = try SimulationEngine.advance(before, to: 32, catalog: c, focus: .balanced).0
            XCTAssertFalse(try project(id, unrelated, c).event.choices.contains { $0.id == choice })
        }
    }
    func testPowerBoundaryIsOfflineAndMissingSupportDoesNotInventKit() throws {
        let original = try StatisticsRepository.bundled()
        for (electricity, support, expected) in [(95.0,0,"powered"),(94.999,1,"portable"),(94.999,0,"manual")] {
            var c = original
            for i in c.households.indices where c.households[i].templateID == "shared-equipment-near-support" { c.households[i].mentorSupport=support }
            let ci = try XCTUnwrap(c.countries.firstIndex { $0.code == "JPN" })
            let oi = try XCTUnwrap(c.countries[ci].indicators.firstIndex { $0.indicator == "EG.ELC.ACCS.ZS" })
            c.countries[ci].indicators[oi].value=electricity
            let s = try state(25,catalog:c), p = try project("young-power-table",s,c)
            XCTAssertEqual(p.evaluation?.environmentOpportunity?.route,expected)
            XCTAssertEqual(p.evaluation?.environmentOpportunity?.observations.map(\.indicator),["EG.ELC.ACCS.ZS"])
            XCTAssertEqual(p.event.choices.contains { $0.id == "poweredBench" },expected == "powered")
            XCTAssertEqual(p.event.choices.contains { $0.id == "portableKit" },expected == "portable")
            let internet = try XCTUnwrap(c.countries[ci].indicators.firstIndex { $0.indicator == "IT.NET.USER.ZS" })
            c.countries[ci].indicators[internet].value=1
            c.countries[ci].name="任意顯示名稱"; c.decisions.reverse()
            XCTAssertEqual(try project("young-power-table",s,c),p)
        }
        let missing = try project("young-power-table",state(25,code:"TWN",catalog:original),original)
        XCTAssertEqual(missing.evaluation?.environmentOpportunity?.route,"unknown")
        XCTAssertNil(missing.evaluation?.environmentOpportunity?.preparation)
        XCTAssertTrue(missing.event.choices.contains { $0.id == "manualPractice" })
    }
    func testCareBoundaryUsesSameMaterialBudgetAndKeepsUnknownDistinct() throws {
        let original=try StatisticsRepository.bundled()
        for (value,expected,extra) in [(19.999,"reserve",1),(20.0,"prepareTogether",2),(39.999,"prepareTogether",2),(40.0,"prepareTogether",3)] {
            var c=original
            let ci=try XCTUnwrap(c.countries.firstIndex { $0.code == "JPN" })
            let oi=try XCTUnwrap(c.countries[ci].indicators.firstIndex { $0.indicator == "SH.XPD.OOPC.CH.ZS" })
            c.countries[ci].indicators[oi].value=value
            let s=try state(32,catalog:c), p=try project("adult-care-map",s,c)
            XCTAssertEqual(s.remainingMaterials,2) // Reviewed template budget; reserveVisit base material = 1.
            XCTAssertEqual(p.evaluation?.environmentOpportunity?.route,expected)
            XCTAssertEqual(p.evaluation?.environmentOpportunity?.preparation?.materials,extra)
            XCTAssertEqual(p.event.choices.contains { $0.id == "reserveVisit" },expected == "reserve")
        }
        let p=try project("adult-care-map",state(32,code:"TWN",catalog:original),original)
        XCTAssertEqual(p.evaluation?.environmentOpportunity?.route,"unknown")
        XCTAssertNil(p.evaluation?.environmentOpportunity?.preparation)
    }
    func testNoHistoryCannotFabricateSupportRecoveryOrEnvironmentContinuation() throws {
        let c=try StatisticsRepository.bundled(), s=try state(52,catalog:c)
        for (id,forbidden) in [("adult-support-revisit",["returnHelp"]),("middle-return-slowly",["shortReturn"]),
            ("later-rest-circle-invite",["adaptedPlace"]),("middle-care-followup",["reviewVisit","reviewShared"]),
            ("adult-tools-coop",["benchWork","mobileRepair"])] {
            let p=try project(id,s,c)
            XCTAssertTrue(p.event.choices.allSatisfy { !forbidden.contains($0.id) })
            XCTAssertNil(p.evaluation?.sourceChoiceID)
            XCTAssertTrue(p.event.choices.contains { $0.id == "rest" })
        }
        let purchase=try XCTUnwrap(c.decisions.first { $0.id == "adult-buffer-envelope" }?.choices.first { $0.id == "stagedPlan" })
        XCTAssertEqual(purchase.storyChanges.map(\.key),["budget"])
    }
    func testRecordedSupportAndRestUnlockDifferentVoluntaryContinuations() throws {
        let c=try StatisticsRepository.bundled()
        var s=try state(52,catalog:c)
        // Reviewed ledger fixtures; rebuild validates provenance. No country or numerical thresholds are forged.
        for (records,event,offered) in [
            ([DecisionRecord(eventID:"child-interest",choiceID:"ask",age:8)],"teen-asking-again","confirmHelp"),
            ([DecisionRecord(eventID:"teen-asking-again",choiceID:"confirmHelp",age:21)],"adult-support-revisit","returnHelp"),
            ([DecisionRecord(eventID:"child-interest",choiceID:"rest",age:8)],"middle-return-slowly","shortReturn"),
            ([DecisionRecord(eventID:"middle-return-slowly",choiceID:"shortReturn",age:45)],"later-rest-circle-invite","adaptedPlace")
        ] {
            s.decisions=records; s.story=try StoryMemory.rebuild(records,catalog:c)
            try s.validate(catalog:c)
            let p=try project(event,s,c)
            XCTAssertTrue(p.event.choices.contains { $0.id == offered })
            XCTAssertEqual(p.evaluation?.sourceChoiceID,records.last?.choiceID)
            XCTAssertEqual(p.evaluation?.sourceAge,records.last?.age)
            XCTAssertTrue(p.evaluation?.explanation.contains("沒有必須回報") == true)
        }
    }
    func testReviewerNoHistoryAndBudgetCounterexamplesDoNotInventOldSupport() throws {
        let c = try StatisticsRepository.bundled()
        var witnessed: Set<String> = []
        for seed: UInt64 in [0,4,21] {
            var life = try LifeSession.start(catalog:c,countryCode:"JPN",householdID:"jpn-1",seed:seed)
            while life.phase != .ended {
                if seed == 21 && life.state.age >= 25 && life.state.age < 80 { try life.chooseFocus(.stability,catalog:c) }
                let event = try life.event(catalog:c)
                if event.id == "adult-support-revisit", life.state.story.fact("support") == nil {
                    witnessed.insert("support")
                    XCTAssertFalse(event.choices.contains { $0.id == "returnHelp" })
                    XCTAssertFalse(event.storyQuestion.contains("過去獲得的支持可以延續"))
                }
                if event.id == "middle-care-followup", life.state.story.fact("careAccess") == nil {
                    witnessed.insert("care")
                    XCTAssertFalse(event.storyQuestion.contains("上次留下的準備今天還合用嗎"))
                    XCTAssertFalse(event.choices.contains { ["reviewVisit","reviewShared"].contains($0.id) })
                }
                if event.id == "teen-asking-again", life.state.story.fact("support") == nil {
                    XCTAssertFalse(event.storyQuestion.contains("先前說過"))
                }
                let choice = seed == 21 && event.id == "adult-buffer-envelope" && event.choices.contains(where: { $0.id == "stagedPlan" }) ? "stagedPlan" : "rest"
                try life.choose(choice,catalog:c); try life.continueLife(catalog:c)
                if choice == "stagedPlan" {
                    witnessed.insert("budget")
                    XCTAssertNil(life.state.story.fact("support"))
                    XCTAssertEqual(life.state.story.fact("budget")?.value,"staged")
                    XCTAssertFalse(life.state.story.relationships.contains { $0.personID == "teacher" })
                }
            }
        }
        XCTAssertEqual(witnessed, ["support","care","budget"])
    }
    func testLaterRequestsAndRestKeepConfirmedSupportAndPracticedPace() throws {
        let c=try StatisticsRepository.bundled()
        for (key,first,firstAge,second,secondAge,event,offered) in [
            ("support",DecisionRecord(eventID:"teen-asking-again",choiceID:"confirmHelp",age:21),21,DecisionRecord(eventID:"adult-care",choiceID:"ask",age:39),39,"adult-support-revisit","returnHelp"),
            ("recovery",DecisionRecord(eventID:"middle-return-slowly",choiceID:"shortReturn",age:52),52,DecisionRecord(eventID:"middle-rhythm",choiceID:"rest",age:59),59,"later-rest-circle-invite","adaptedPlace")
        ] {
            var s=try state(65,catalog:c)
            s.decisions=[first,second]; s.story=try StoryMemory.rebuild(s.decisions,catalog:c)
            try s.validate(catalog:c)
            XCTAssertEqual(s.story.fact(key)?.age,firstAge)
            XCTAssertTrue(s.decisions.contains { $0.age==secondAge && $0.choiceID==second.choiceID })
            let p=try project(event,s,c)
            XCTAssertTrue(p.event.choices.contains { $0.id==offered })
            XCTAssertEqual(p.evaluation?.sourceChoiceID,first.choiceID)
            XCTAssertEqual(p.evaluation?.sourceAge,firstAge)
        }
        // The independent review found these failures through complete official-template lives.
        for seed: UInt64 in [17,63] {
            var life=try LifeSession.start(catalog:c,countryCode:"JPN",householdID:"jpn-1",seed:seed)
            var originalFact: StoryFact?
            let key = seed == 17 ? "support" : "recovery"
            while life.phase != .ended {
                let e=try life.event(catalog:c)
                let available=try e.choices.filter { try life.preview(choiceID:$0.id,catalog:c).applied }
                let wanted = seed == 17 ? "confirmHelp" : "shortReturn"
                let chosen: String
                if available.contains(where: { $0.id==wanted }) { chosen=wanted }
                else if seed == 17 { chosen=available.first { $0.kind == .askSupport }?.id ?? "rest" }
                else { chosen="rest" }
                try life.choose(chosen,catalog:c)
                if chosen==wanted && originalFact==nil { originalFact=life.state.story.fact(key) }
                if let originalFact { XCTAssertEqual(life.state.story.fact(key),originalFact) }
                try life.continueLife(catalog:c)
            }
            XCTAssertNotNil(originalFact)
            XCTAssertEqual(try LifeSession.restore(from:JSONEncoder().encode(life),catalog:c),life)
        }
    }
    func testFullFocusSaveReplayBranchKeepsOriginalAndRejectsForgedMemories() throws {
        let c=try StatisticsRepository.bundled()
        var original=try LifeSession.start(catalog:c,countryCode:"JPN",householdID:"jpn-1",seed:34)
        while original.phase != .ended {
            if original.state.age < 80 { try original.chooseFocus(original.state.age < 23 ? .learning : .stability,catalog:c) }
            try original.choose("rest",catalog:c); try original.continueLife(catalog:c)
        }
        let encoder=JSONEncoder(); encoder.outputFormatting=[.sortedKeys]
        let originalBytes=try encoder.encode(original)
        XCTAssertEqual(original.state.focusHistory.count,14)
        XCTAssertEqual(try LifeSession.restore(from:originalBytes,catalog:c),original)
        let frame=try WorldMomentProjector.project(session:original,catalog:c)
        XCTAssertTrue(frame.worldChanges.contains { $0.kind == .livedFocus && $0.isOccurred && $0.sourceChoiceID.isEmpty })
        var journey=LifeJourney.branch(try BranchExperiment.start(original:original,decisionIndex:3,choiceID:"offline",catalog:c))
        let dir=FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at:dir) }
        let repo=SaveRepository(fileURL:dir.appendingPathComponent("life.json"))
        while journey.activeSession.phase != .ended {
            if journey.activeSession.phase == .choosing {
                if journey.activeSession.state.age < 80 { try journey.chooseFocus(.recovery,catalog:c) }
                try journey.choose(journey.activeSession.state.age == 13 ? "offline" : "rest",catalog:c)
            } else { try journey.continueLife(catalog:c) }
            try repo.save(journey,catalog:c); journey=try XCTUnwrap(repo.load(catalog:c))
            XCTAssertEqual(try encoder.encode(XCTUnwrap(journey.comparisonOriginal)),originalBytes)
        }
        XCTAssertEqual(try BranchComparisonEngine.compare(XCTUnwrap(journey.experiment),catalog:c).rows.count,12)
        var object=try XCTUnwrap(JSONSerialization.jsonObject(with:originalBytes) as? [String:Any])
        var saved=try XCTUnwrap(object["state"] as? [String:Any])
        saved["focusMemories"]=[]; object["state"]=saved
        XCTAssertThrowsError(try LifeSession.restore(from:JSONSerialization.data(withJSONObject:object),catalog:c))
        let good=try Data(contentsOf:repo.fileURL)
        let old=Data(String(decoding:good,as:UTF8.self).replacingOccurrences(of:LifeState.engineVersion,with:"lx05-opportunity-1").utf8)
        try old.write(to:repo.fileURL); XCTAssertThrowsError(try repo.load(catalog:c))
        XCTAssertEqual(try Data(contentsOf:repo.fileURL),old)
    }
}
