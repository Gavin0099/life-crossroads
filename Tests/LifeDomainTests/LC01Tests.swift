import Foundation
import XCTest
@testable import LifeDomain
import LifeData

final class LC01Tests: XCTestCase {
    private func catalog() throws -> ModelCatalog { try StatisticsRepository.bundled() }

    private func state(_ catalog: ModelCatalog, country: String = "USA", family: Int = 2,
                       age: Int = 13, seed: UInt64 = 42) throws -> LifeState {
        let born = try LifeState.born(catalog: catalog, countryCode: country,
                                     householdID: "\(country.lowercased())-\(family)", seed: seed)
        return try SimulationEngine.advance(born, to: age, catalog: catalog).0
    }

    private func resolve(_ state: LifeState, _ catalog: ModelCatalog,
                         event: String = "teen-project", choice: String = "invest") throws -> DecisionResult {
        try DecisionResolver.resolve(state: state, eventID: event, choiceID: choice, catalog: catalog)
    }

    func testEightCountriesSixteenFamiliesAndHonestReadiness() throws {
        let c = try catalog()
        XCTAssertEqual(Set(c.countries.map(\.code)), ["TWN", "JPN", "USA", "DEU", "IND", "BRA", "VNM", "KEN"])
        XCTAssertEqual(c.households.count, 16)
        for country in c.countries {
            XCTAssertEqual(c.households.filter { $0.countryCode == country.code }.count, 2)
        }
        XCTAssertEqual(c.countries.filter { $0.dataStatus == .ready }.count, 7)
        let taiwan = try XCTUnwrap(c.countries.first { $0.code == "TWN" })
        XCTAssertEqual(taiwan.dataStatus, .limited)
        XCTAssertEqual(taiwan.indicators.count, 3)
        XCTAssertFalse(taiwan.gaps.isEmpty)
        XCTAssertNoThrow(try LifeState.born(catalog: c, countryCode: "TWN", householdID: "twn-1", seed: 42))
    }

    func testOfflineChildActivityNeverUsesNationalDigitalRates() throws {
        let c = try catalog()
        for code in ["JPN", "USA", "IND", "KEN"] {
            let result = try resolve(state(c, country: code, age: 8), c, event: "child-interest")
            XCTAssertTrue(result.trace.applied)
            XCTAssertEqual(result.trace.finalCost, Cost(time: 3, energy: 2, materials: 1))
            XCTAssertFalse(result.trace.costSteps.contains { $0.ruleID == "context.digital" || $0.ruleID == "family.device" })
            XCTAssertTrue(result.trace.costSteps.filter { $0.influence == .socialEnvironment }.isEmpty)
        }
    }

    func testOfflineLearningIgnoresDigitalThresholdsAndHasSupport() throws {
        var c = try catalog()
        let index = try XCTUnwrap(c.countries.firstIndex { $0.code == "KEN" })
        for i in c.countries[index].indicators.indices { c.countries[index].indicators[i].value = 0 }
        let original = try resolve(state(c, country: "KEN", family: 1, age: 8), c, event: "child-interest")
        for i in c.countries[index].indicators.indices { c.countries[index].indicators[i].value = 100 }
        let changed = try resolve(state(c, country: "KEN", family: 1, age: 8), c, event: "child-interest")
        XCTAssertEqual(original.trace.finalCost, changed.trace.finalCost)
        XCTAssertEqual(original.state.resources, changed.state.resources)
        XCTAssertTrue(original.trace.costSteps.contains { $0.ruleID == "support.shared-preparation" })
    }

    func testDigitalLearningOffersAnIndependentOfflineRoute() throws {
        let c = try catalog(), before = try state(c, country: "KEN")
        let online = try resolve(before, c)
        let offline = try resolve(before, c, choice: "offline")
        XCTAssertTrue(offline.trace.applied)
        XCTAssertTrue(online.trace.costSteps.contains { $0.ruleID == "context.digital" })
        XCTAssertFalse(offline.trace.costSteps.contains { $0.ruleID == "context.digital" })
        XCTAssertLessThan(offline.trace.finalCost.time, online.trace.finalCost.time)
        XCTAssertEqual(offline.trace.finalCost.materials, 1)
    }

    func testHouseholdTemplatesStayComparableWhenArraysMove() throws {
        let c = try catalog()
        var reordered = c; reordered.households.reverse()
        XCTAssertNoThrow(try reordered.validate())
        let usa = try XCTUnwrap(c.households.first { $0.id == "usa-2" })
        let kenya = try XCTUnwrap(c.households.first { $0.id == "ken-2" })
        XCTAssertEqual(usa.templateID, "own-equipment-long-commute")
        XCTAssertTrue(usa.hasSameConditions(as: kenya))
        var corrupt = c
        let index = try XCTUnwrap(corrupt.households.firstIndex { $0.id == "ken-2" })
        corrupt.households[index].initialResources.health += 1
        XCTAssertThrowsError(try corrupt.validate())
        corrupt = c; corrupt.households[index].templateID = ""
        XCTAssertThrowsError(try corrupt.validate())
    }

    func testPinnedRealStatisticsHaveIndependentExpectedValues() throws {
        let c = try catalog()
        let kenya = try XCTUnwrap(c.countries.first { $0.code == "KEN" })
        XCTAssertEqual(kenya.indicators.first { $0.indicator == "IT.NET.USER.ZS" }?.value, 32.07040024)
        XCTAssertEqual(kenya.indicators.first { $0.indicator == "EG.ELC.ACCS.ZS" }?.value, 76.2)
        let japan = try XCTUnwrap(c.countries.first { $0.code == "JPN" })
        XCTAssertEqual(japan.indicators.first { $0.indicator == "IT.NET.USER.ZS" }?.value, 85.00990295)
        XCTAssertEqual(c.sources.count, 7)
        XCTAssertEqual(c.sources.filter { $0.license == "CC-BY-4.0" }.count, 4)
        XCTAssertEqual(c.sources.filter { $0.license == "OGDL-Taiwan-1.0" }.count, 3)
        XCTAssertTrue(c.sources.allSatisfy { !$0.attribution.isEmpty })
    }

    func testCatalogAndStateAndTraceCodableRoundTrip() throws {
        let c = try catalog()
        XCTAssertEqual(try StatisticsRepository.decode(JSONEncoder().encode(c)), c)
        let result = try resolve(state(c), c)
        XCTAssertEqual(try JSONDecoder().decode(DecisionResult.self, from: JSONEncoder().encode(result)), result)
        try result.state.validate(catalog: c)
    }

    func testMissingValueCannotBecomeVerifiedZero() throws {
        var c = try catalog()
        c.countries[2].indicators[0].value = nil
        XCTAssertThrowsError(try c.validate())
        XCTAssertThrowsError(try StatisticsRepository.decode(JSONEncoder().encode(c)))
        c.countries[2].indicators[0].value = 0 // an explicitly observed zero is valid, absence is not
        XCTAssertNoThrow(try c.validate())
        c.countries[2].indicators.removeAll()
        XCTAssertThrowsError(try c.validate())
    }

    func testBadIndicatorRangesAndSourceReferencesAreRejected() throws {
        for bad in [-1.0, 100.01, .infinity, .nan] {
            var c = try catalog(); c.countries[2].indicators[0].value = bad
            XCTAssertThrowsError(try c.validate())
        }
        var c = try catalog(); c.countries[2].indicators[0].sourceID = "unknown"
        XCTAssertThrowsError(try c.validate())
        c = try catalog(); c.countries[2].indicators[0].year = 2022
        XCTAssertThrowsError(try c.validate())
        c = try catalog(); c.households[0].assumptionIDs = ["missing"]
        XCTAssertThrowsError(try c.validate())
        c = try catalog(); c.countries.append(c.countries[0])
        XCTAssertThrowsError(try c.validate()) // rejects duplicates before dictionary construction
    }

    func testCorruptJSONAndUnknownSchemaFailExplicitly() throws {
        XCTAssertThrowsError(try StatisticsRepository.decode(Data("{not json}".utf8)))
        XCTAssertThrowsError(try StatisticsRepository.decode(Data("{}".utf8)))
        var c = try catalog(); c.schemaVersion = 999
        XCTAssertThrowsError(try c.validate())
    }

    func testRepositoryRejectsAbsentAndTamperedEvidence() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        XCTAssertThrowsError(try StatisticsRepository.load(directory: directory))
        try FileManager.default.createDirectory(at: directory.appendingPathComponent("raw"), withIntermediateDirectories: true)
        let c = try catalog()
        try JSONEncoder().encode(c).write(to: directory.appendingPathComponent("catalog.json"))
        XCTAssertThrowsError(try StatisticsRepository.load(directory: directory))
        for source in c.sources {
            try Data("[]".utf8).write(to: directory.appendingPathComponent(source.rawPath))
        }
        XCTAssertThrowsError(try StatisticsRepository.load(directory: directory)) { error in
            guard case ModelError.invalid(let reason) = error else { return XCTFail("expected hash rejection") }
            XCTAssertTrue(reason.contains("SHA256"))
        }
    }

    func testFiveStageBoundaries() throws {
        let expected: [(Int, LifeStage)] = [(0, .childhood), (12, .childhood), (13, .adolescence),
            (22, .adolescence), (23, .youngAdult), (40, .youngAdult), (41, .middleAge),
            (60, .middleAge), (61, .laterLife), (100, .laterLife)]
        for (age, stage) in expected { XCTAssertEqual(try LifeStage.at(age: age), stage) }
        XCTAssertThrowsError(try LifeStage.at(age: -1))
        XCTAssertThrowsError(try LifeStage.at(age: 101))
    }

    func testRepositoryRejectsAlteredObservationEvenWithIntactSourceHash() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let original = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().appendingPathComponent("LifeCrossroads/Data/Resources")
        try FileManager.default.copyItem(at: original, to: directory)
        var c = try catalog(); c.countries[2].indicators[0].value = 1
        try JSONEncoder().encode(c).write(to: directory.appendingPathComponent("catalog.json"))
        XCTAssertThrowsError(try StatisticsRepository.load(directory: directory)) { error in
            guard case ModelError.invalid(let reason) = error else { return XCTFail("expected observation rejection") }
            XCTAssertTrue(reason.contains("source/observation mismatch"))
        }
    }

    func testSameChoiceAcrossCountriesHasExplainableCosts() throws {
        let c = try catalog()
        let usa = try resolve(state(c, country: "USA"), c)
        let japan = try resolve(state(c, country: "JPN"), c)
        let india = try resolve(state(c, country: "IND"), c)
        let kenya = try resolve(state(c, country: "KEN"), c)
        XCTAssertEqual([usa, japan, india, kenya].map { $0.trace.finalCost.time }, [3, 4, 4, 5])
        XCTAssertEqual([usa, japan, india, kenya].map { $0.trace.finalCost.materials }, [1, 1, 1, 2])
        XCTAssertEqual(usa.trace.resourcesAfter.health - usa.trace.resourcesBefore.health, 0)
        XCTAssertEqual(kenya.trace.resourcesAfter.health - kenya.trace.resourcesBefore.health, -2)
        XCTAssertEqual(usa.trace.randomTrial?.draw, kenya.trace.randomTrial?.draw) // common opportunity key
        XCTAssertTrue(kenya.trace.explanation.contains { $0.contains("遊戲假設") })
    }

    func testCountryNamesAndCodesCannotSetSuccessMultipliers() throws {
        let c = try catalog()
        let original = try resolve(state(c), c)
        var renamed = c
        let index = try XCTUnwrap(renamed.countries.firstIndex { $0.code == "USA" })
        renamed.countries[index].name = "任意名稱"
        renamed.countries[index].code = "ZZZ"
        for i in renamed.countries[index].indicators.indices { renamed.countries[index].indicators[i].region = "ZZZ" }
        for i in renamed.households.indices where renamed.households[i].countryCode == "USA" {
            renamed.households[i].countryCode = "ZZZ"
        }
        var renamedState = try state(c); renamedState.countryCode = "ZZZ"
        let result = try resolve(renamedState, renamed)
        XCTAssertEqual(result.trace.finalCost, original.trace.finalCost)
        XCTAssertEqual(result.trace.effectSteps, original.trace.effectSteps)
        XCTAssertEqual(result.trace.randomTrial, original.trace.randomTrial)
        XCTAssertEqual(result.state.resources, original.state.resources)
    }

    func testDigitalThresholdBoundaries() throws {
        let fixture: [(Double, Double, Int, Int)] = [(90, 95, 3, 1), (89.999, 95, 4, 1),
            (60, 95, 4, 1), (59.999, 95, 5, 1), (90, 94.999, 3, 2)]
        for (internet, electricity, time, materials) in fixture {
            var c = try catalog()
            let index = try XCTUnwrap(c.countries.firstIndex { $0.code == "USA" })
            for i in c.countries[index].indicators.indices {
                let code = c.countries[index].indicators[i].indicator
                c.countries[index].indicators[i].value = code == "IT.NET.USER.ZS" ? internet : electricity
            }
            let result = try resolve(state(c), c)
            XCTAssertEqual(result.trace.finalCost, Cost(time: time, energy: 2, materials: materials))
        }
    }

    func testSameCountryFamiliesHaveDifferentTradeoffsAndSupport() throws {
        let c = try catalog()
        let supported = try resolve(state(c, country: "KEN", family: 1), c)
        let ownDevice = try resolve(state(c, country: "KEN", family: 2), c)
        XCTAssertEqual(supported.trace.finalCost.time, 4)
        XCTAssertEqual(ownDevice.trace.finalCost.time, 5)
        XCTAssertEqual(supported.state.resources.skills - supported.trace.resourcesBefore.skills, 5)
        XCTAssertEqual(ownDevice.state.resources.skills - ownDevice.trace.resourcesBefore.skills, 5)
        XCTAssertLessThan(supported.trace.resourcesBefore.financial, ownDevice.trace.resourcesBefore.financial)
        XCTAssertGreaterThan(supported.trace.resourcesBefore.relationships, ownDevice.trace.resourcesBefore.relationships)
        XCTAssertTrue(supported.trace.costSteps.contains { $0.influence == .otherPeople && $0.adjustment.time == -2 })
    }

    func testEnvironmentCanChangeFeasibilityWithoutConsumingUnavailableChoice() throws {
        let c = try catalog()
        var usa = try state(c); usa.remainingTime = 4
        var kenya = try state(c, country: "KEN"); kenya.remainingTime = 4
        XCTAssertTrue(try resolve(usa, c).trace.applied)
        let blocked = try resolve(kenya, c)
        XCTAssertFalse(blocked.trace.applied)
        XCTAssertEqual(blocked.state, kenya)
        XCTAssertTrue(blocked.trace.effectSteps.isEmpty)
        XCTAssertTrue(blocked.trace.scheduledHooks.isEmpty)
        XCTAssertNil(blocked.trace.randomTrial)
        XCTAssertFalse(blocked.trace.unavailableReasons.isEmpty)
        let rest = try resolve(kenya, c, choice: "rest")
        XCTAssertTrue(rest.trace.applied)
        XCTAssertEqual(rest.trace.finalCost, Cost())
    }

    func testChildAgencyDoesNotTransferAdultCareResponsibility() throws {
        var c = try catalog()
        var child = try state(c, country: "KEN", family: 1, age: 8)
        let event = try XCTUnwrap(c.decisions.firstIndex { $0.id == "child-interest" })
        let normal = try resolve(child, c, event: "child-interest")
        XCTAssertEqual(normal.trace.control, .sharedWithAdult)
        XCTAssertTrue(normal.trace.effectSteps.contains { $0.ruleID == "agency.shared" })
        let schedule = try XCTUnwrap(normal.trace.costSteps.first { $0.ruleID == "family.schedule" })
        XCTAssertEqual(schedule.inputs["adultCareCost"], 0)
        c.decisions[event].choices[0].control = .adultResponsibility
        let rejected = try resolve(child, c, event: "child-interest")
        XCTAssertFalse(rejected.trace.applied)
        XCTAssertEqual(rejected.state, child)
        child.remainingTime = 0; child.remainingEnergy = 0; child.remainingMaterials = 0
        XCTAssertTrue(try resolve(child, c, event: "child-interest", choice: "rest").trace.applied)
    }

    func testAgeCostsAndResourceInputsFailBeforeArithmetic() throws {
        let c = try catalog()
        var bad = try state(c); bad.resources.health = Int.max
        XCTAssertThrowsError(try resolve(bad, c))
        bad = try state(c); bad.remainingTime = -1
        XCTAssertThrowsError(try resolve(bad, c))
        bad = try state(c); bad.age = 101
        XCTAssertThrowsError(try resolve(bad, c))
        var badCatalog = c; badCatalog.decisions[0].choices[0].timeCost = Int.max
        XCTAssertThrowsError(try badCatalog.validate())
        badCatalog = c; badCatalog.households[0].mentorSupport = -1
        XCTAssertThrowsError(try badCatalog.validate())
    }

    func testTraceExactlyReconcilesCostEffectsAndProvenance() throws {
        let c = try catalog()
        let before = try state(c, country: "KEN")
        let result = try resolve(before, c)
        let t = result.trace
        XCTAssertEqual(t.costSteps.reduce(t.baseCost) { $0 + $1.adjustment }, t.finalCost)
        XCTAssertEqual(t.effectSteps.reduce(t.resourcesBefore) { $0 + $1.delta }, t.resourcesAfter)
        XCTAssertEqual(before.remainingTime - result.state.remainingTime, t.finalCost.time)
        XCTAssertEqual(before.remainingEnergy - result.state.remainingEnergy, t.finalCost.energy)
        XCTAssertEqual(before.remainingMaterials - result.state.remainingMaterials, t.finalCost.materials)
        let sourceIDs = Set(c.sources.map(\.id)), assumptions = Set(c.assumptions.map(\.id))
        for step in t.costSteps {
            XCTAssertTrue(step.sourceIDs.allSatisfy(sourceIDs.contains))
            XCTAssertTrue(step.assumptionIDs.allSatisfy(assumptions.contains))
        }
        for step in t.effectSteps { XCTAssertTrue(step.assumptionIDs.allSatisfy(assumptions.contains)) }
        let environment = try XCTUnwrap(t.costSteps.first { $0.ruleID == "context.digital" })
        XCTAssertEqual(environment.inputs["internetPct"], 32.07040024)
        XCTAssertEqual(environment.sourceIDs.count, 2)
        XCTAssertTrue(t.effectSteps.contains { $0.influence == .playerChoice })
        XCTAssertTrue(t.effectSteps.contains { $0.influence == .randomness })
    }

    func testResourceClampingIsVisibleAndCostsCannotGoNegative() throws {
        let c = try catalog()
        var before = try state(c); before.resources = .init(health: 100, financial: 0, relationships: 100, skills: 99)
        let result = try resolve(before, c)
        XCTAssertEqual(result.state.resources.financial, 0)
        XCTAssertEqual(result.state.resources.skills, 100)
        XCTAssertEqual(result.state.resources.relationships, 100)
        XCTAssertEqual(result.trace.effectSteps.last?.ruleID, "resource.clamp")
        XCTAssertLessThan(try XCTUnwrap(result.trace.effectSteps.last).delta.skills, 0)
        let supported = try state(c, family: 1)
        let ask = try resolve(supported, c, choice: "ask")
        XCTAssertEqual(ask.trace.finalCost.time, 0)
        XCTAssertEqual(ask.state.remainingTime, supported.remainingTime)
        XCTAssertTrue(ask.trace.costSteps.contains { $0.ruleID == "cost.floor" })
    }

    func testKeyedRandomHasStableGoldenVectorAndNoSharedStream() throws {
        XCTAssertEqual(KeyedRandom.mix(0), 0xe220a8397b1dcdaf) // published SplitMix64 zero-seed vector
        let key = KeyedRandom.key(eventID: "teen-project", age: 13, channel: "unexpected-encouragement")
        let original = KeyedRandom.draw(seed: 42, key: key)
        for i in 0..<100 { _ = KeyedRandom.draw(seed: UInt64(i), key: "unrelated-event") }
        XCTAssertEqual(KeyedRandom.draw(seed: 42, key: key), original)
        XCTAssertNotEqual(KeyedRandom.draw(seed: 43, key: key), original)
        XCTAssertGreaterThanOrEqual(original, 0); XCTAssertLessThan(original, 1)
    }

    func testSameSeedAndSerializedResumeProduceIdenticalTrace() throws {
        let c = try catalog()
        let before = try state(c, country: "KEN")
        let first = try resolve(before, c)
        let resumed = try JSONDecoder().decode(LifeState.self, from: JSONEncoder().encode(before))
        XCTAssertEqual(try resolve(resumed, c), first)
        XCTAssertEqual(try resolve(state(c, country: "KEN"), c), first)
    }

    func testChoiceChangeCreatesActualDelayedStoryDifference() throws {
        let c = try catalog(), before = try state(c)
        let invest = try resolve(before, c)
        let rest = try resolve(before, c, choice: "rest")
        XCTAssertEqual(invest.state.pendingHooks.count, 1)
        XCTAssertTrue(rest.state.pendingHooks.isEmpty)
        let (later, trace) = try SimulationEngine.advance(invest.state, to: 17, catalog: c)
        let (alternative, alternativeTrace) = try SimulationEngine.advance(rest.state, to: 17, catalog: c)
        XCTAssertEqual(trace.triggeredHooks.first?.originChoiceID, "invest")
        XCTAssertEqual(trace.triggeredHooks.first?.person, "樹老師")
        XCTAssertEqual(later.resources.skills - invest.state.resources.skills, 1)
        XCTAssertEqual(later.resources.relationships - invest.state.resources.relationships, 0)
        XCTAssertTrue(alternativeTrace.triggeredHooks.isEmpty)
        XCTAssertEqual(alternative.resources, rest.state.resources)
        let (_, secondJump) = try SimulationEngine.advance(later, to: 21, catalog: c)
        XCTAssertTrue(secondJump.triggeredHooks.isEmpty)
    }

    func testInvalidTimeDuplicateDecisionAndVersionAreRejected() throws {
        let c = try catalog(), before = try state(c)
        XCTAssertThrowsError(try SimulationEngine.advance(before, to: 13, catalog: c))
        XCTAssertThrowsError(try SimulationEngine.advance(before, to: 12, catalog: c))
        XCTAssertThrowsError(try resolve(before, c, event: "child-interest"))
        XCTAssertThrowsError(try resolve(before, c, choice: "unknown"))
        let applied = try resolve(before, c).state
        XCTAssertThrowsError(try resolve(applied, c))
        var badVersion = before; badVersion.dataVersion = "old"
        XCTAssertThrowsError(try resolve(badVersion, c))
    }

    func testForgedOrDuplicateStoryHooksCannotGrantResources() throws {
        let c = try catalog()
        var current = try resolve(state(c), c).state
        let real = try XCTUnwrap(current.pendingHooks.first)
        current.pendingHooks.append(real)
        XCTAssertThrowsError(try current.validate(catalog: c))
        current.pendingHooks = [.init(id: real.id, originEventID: real.originEventID, originChoiceID: real.originChoiceID, originAge: real.originAge,
                                      dueAge: real.dueAge, person: real.person, text: real.text,
                                      effect: .init(skills: 20), assumptionID: real.assumptionID)]
        XCTAssertThrowsError(try SimulationEngine.advance(current, to: 17, catalog: c))
    }

    func testFifteenSkeletonDecisionsCoverEveryStageAndThreeCallbacks() throws {
        let c = try catalog()
        XCTAssertEqual(c.decisions.filter(\.isFallback).count, 15)
        XCTAssertEqual(c.decisions.count, 52)
        XCTAssertEqual(Set(try c.decisions.map { try LifeStage.at(age: $0.age) }), Set(LifeStage.allCases))
        XCTAssertEqual(c.decisions.filter { $0.choices.contains { $0.delayedHook != nil } }.count, 3)
        XCTAssertEqual(c.decisions.filter(\.isFallback).map(\.age), [8, 10, 12, 13, 17, 21, 25, 32, 39, 45, 52, 59, 65, 72, 80])
    }

    func testManySeededSkeletonLivesStayValidAndCanAlwaysAdvance() throws {
        let c = try catalog()
        for country in c.countries where country.dataStatus == .ready {
            for household in c.households where household.countryCode == country.code {
                for seed: UInt64 in 0..<40 {
                    var current = try LifeState.born(catalog: c, countryCode: country.code, householdID: household.id, seed: seed)
                    for age in LifeSession.decisionAges {
                        (current, _) = try SimulationEngine.advance(current, to: age, catalog: c)
                        let selectedEventID = try EventSelector.select(state: current, catalog: c).selectedEventID
                        let event = try XCTUnwrap(c.decisions.first { $0.id == selectedEventID })
                        let selected = event.choices[Int(seed % UInt64(event.choices.count))].id
                        var result = try resolve(current, c, event: event.id, choice: selected)
                        if !result.trace.applied { result = try resolve(current, c, event: event.id, choice: "rest") }
                        XCTAssertTrue(result.trace.applied)
                        current = result.state
                        try current.validate(catalog: c)
                    }
                    XCTAssertEqual(current.age, 80)
                    XCTAssertEqual(current.decisions.count, 15)
                    XCTAssertTrue(current.pendingHooks.isEmpty)
                }
            }
        }
    }
}
