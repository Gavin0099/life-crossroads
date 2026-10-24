import Foundation

struct EnvironmentContext {
    let observations: [IndicatorObservation]
    let household: HouseholdProfile
    func observation(_ id: String) -> IndicatorObservation? {
        observations.first { $0.indicator == id && $0.value != nil && $0.usage == "ruleInput" }
    }
}

enum EnvironmentRules {
    static func context(catalog: ModelCatalog, countryCode: String, householdID: String) throws -> EnvironmentContext {
        guard let country = catalog.countries.first(where: { $0.code == countryCode }),
              let household = catalog.households.first(where: { $0.id == householdID }),
              household.countryCode == countryCode else { throw ModelError.missing("background") }
        guard country.dataStatus != .blocked else { throw ModelError.unavailable("country data incomplete: \(countryCode)") }
        if country.dataStatus == .ready {
            for id in CountryProfile.requiredIndicators {
                guard let observation = country.indicators.first(where: { $0.indicator == id }),
                      let value = observation.value, value.isFinite, (0...100).contains(value),
                      IndicatorContract.valid(observation) else { throw ModelError.missing(id) }
            }
        }
        return .init(observations: country.indicators, household: household)
    }
}

public enum DecisionResolver {
    public static func resolve(state: LifeState, eventID: String, choiceID: String, catalog: ModelCatalog) throws -> DecisionResult {
        try catalog.validate(); try state.validate(catalog: catalog)
        let selection = try EventSelector.select(state: state, catalog: catalog)
        guard let original = catalog.decisions.first(where: { $0.id == eventID }),
              let originalChoice = original.choices.first(where: { $0.id == choiceID }) else { throw ModelError.missing("decision/choice") }
        let projection = StoryBranchEngine.project(event: original, state: state)
        let event = projection.event
        let availableChoice = event.choices.first(where: { $0.id == choiceID })
        let choice = availableChoice ?? originalChoice
        guard original.selection.includes(state.age), !state.decisions.contains(where: { $0.age == state.age }) else {
            throw ModelError.invalid("event age or repeated decision")
        }
        let context = try EnvironmentRules.context(catalog: catalog, countryCode: state.countryCode, householdID: state.householdID)
        let h = context.household
        var costSteps: [CostStep] = []
        var environmentGaps: [String] = []
        let baseCost = Cost(time: choice.timeCost, energy: choice.energyCost, materials: choice.materialCost)
        var cost = baseCost
        func adjust(_ rule: String, _ influence: Influence, _ delta: Cost, _ inputs: [String: Double],
                    _ sources: [String], _ assumptions: [String], _ explanation: String) {
            cost = cost + delta
            costSteps.append(.init(ruleID: rule, influence: influence, inputs: inputs, adjustment: delta,
                                   sourceIDs: sources, assumptionIDs: assumptions, explanation: explanation))
        }
        if choice.requiresDigitalAccess {
            // National rates are contextual indices, not household probabilities. This mapping is a design assumption.
            if let internetObservation = context.observation("IT.NET.USER.ZS"),
               let electricityObservation = context.observation("EG.ELC.ACCS.ZS"),
               let internet = internetObservation.value, let electricity = electricityObservation.value {
                let informationFriction = internet >= 90 ? 0 : (internet >= 60 ? 1 : 2)
                let materialFriction = electricity >= 95 ? 0 : 1
                adjust("context.digital", .socialEnvironment,
                       .init(time: informationFriction, materials: materialFriction),
                       ["internetPct": internet, "electricityPct": electricity],
                       [internetObservation.sourceID, electricityObservation.sourceID], ["macro-friction"],
                       "模型把環境資料轉為準備成本：多用 \(informationFriction) 格時間、\(materialFriction) 格材料。這是遊戲假設。")
            } else {
                environmentGaps.append("缺少同口徑網路/電力輸入；僅估算行動與家庭安排，未知環境成本不是0，也不表示不能上網。")
                adjust("context.digital.unestimated", .modelRule, .init(), [:], [], ["partial-environment"], environmentGaps.last!)
            }
            adjust("family.device", .family, .init(time: h.deviceAccess.schedulingCost),
                   ["deviceScheduling": Double(h.deviceAccess.schedulingCost)], [], h.assumptionIDs,
                   "這個虛構家庭的設備安排，多需要 \(h.deviceAccess.schedulingCost) 格時間。")
        } else if choice.kind == .learn {
            adjust("learning.offline", .modelRule, .init(), [:], [], ["learning-channels"],
                   "這次使用紙本或面對面學習；成本只依本次材料、交通與協助安排計算。")
        }
        if choice.kind == .learn || choice.kind == .work || choice.kind == .care {
            let careCost = state.age >= 23 ? h.careLoad : 0
            adjust("family.schedule", .family, .init(time: h.travelCost + careCost),
                   ["travelCost": Double(h.travelCost), "adultCareCost": Double(careCost)], [], ["household-scenarios", "agency"],
                   "交通安排多用 \(h.travelCost) 格時間；這回合由角色承擔的成人照顧安排為 \(careCost) 格。")
        }
        if (choice.kind == .learn || choice.kind == .askSupport || choice.kind == .care) && h.mentorSupport > 0 {
            adjust("support.shared-preparation", .otherPeople, .init(time: -h.mentorSupport),
                   ["support": Double(h.mentorSupport)], [], ["support-network"],
                   "有人一起準備，幫你節省 \(h.mentorSupport) 格時間。")
        }
        if choice.requiresCareFinancing == true {
            if let observation = context.observation("SH.XPD.OOPC.CH.ZS"), let value = observation.value {
                let materials = value < 20 ? 1 : (value < 40 ? 2 : 3)
                adjust("context.care-financing", .socialEnvironment, .init(materials: materials),
                       ["oopShareOfCHE": value], [observation.sourceID], ["care-financing"],
                       "這個醫療安排情境預留 \(materials) 格材料。全國直接自付份額只是情境背景，門檻為遊戲假設，不是個人帳單或治療效果。")
            } else {
                environmentGaps.append("缺少可比的直接自付/CHE；含商保理賠的資料不可代用。家庭試算未估計此項環境成本。")
                adjust("context.care-financing.unestimated", .modelRule, .init(), [:], [], ["partial-environment"], environmentGaps.last!)
            }
        }
        let boundedCost = Cost(time: max(0, cost.time), energy: max(0, cost.energy), materials: max(0, cost.materials))
        if cost != boundedCost {
            adjust("cost.floor", .modelRule,
                   .init(time: boundedCost.time - cost.time, energy: boundedCost.energy - cost.energy,
                         materials: boundedCost.materials - cost.materials), [:], [], ["resource-bounds"],
                   "協助可以減少成本，但不會憑空增加回合時間。")
        }
        var reasons: [String] = []
        if selection.selectedEventID != event.id {
            reasons.append("這次遇見的是另一個情境；不能直接跳到未入選的事件。")
        }
        if availableChoice == nil {
            reasons.append("這個故事條件尚未具備；可以選擇畫面上提供的參與、求助或免費休息。")
        }
        if state.age < choice.minimumAge || (choice.control == .adultResponsibility && state.age < 23) {
            reasons.append("這項成人責任不由目前年齡的角色承擔；可以選擇表達需要或尋求協助。")
        }
        if state.age <= 12 && choice.control == .personal && choice.kind != .rest && choice.kind != .askSupport {
            reasons.append("童年階段需要與可信任的大人共同安排。")
        }
        if cost.time > state.remainingTime { reasons.append("時間不足；可改選休息或求助，這不是你的過錯。") }
        if cost.energy > state.remainingEnergy { reasons.append("精力不足；可以休息。") }
        if cost.materials > state.remainingMaterials { reasons.append("材料預算不足；可以尋求支持。") }
        var next = state
        var effects: [EffectStep] = []
        var randomTrial: RandomTrial?
        var hooks: [StoryHook] = []
        func effect(_ rule: String, _ influence: Influence, _ delta: ResourceValues, _ assumptions: [String], _ text: String) {
            next.resources = next.resources + delta
            effects.append(.init(ruleID: rule, influence: influence, delta: delta, assumptionIDs: assumptions, explanation: text))
        }
        if reasons.isEmpty {
            next.remainingTime -= cost.time; next.remainingEnergy -= cost.energy; next.remainingMaterials -= cost.materials
            effect("choice.\(choice.kind.rawValue)", .playerChoice, choice.effect, choice.assumptionIDs,
                   "你選了「\(choice.title)」，付出 \(cost.time) 格時間和 \(cost.energy) 格精力。")
            if choice.control == .sharedWithAdult {
                effect("agency.shared", .family, .zero, ["agency"], "你表達自己的想法，具體安排由可信任的大人共同負責。")
            }
            if choice.kind == .learn && h.mentorSupport > 0 {
                effect("support.encouragement", .otherPeople, .init(relationships: 1, skills: 1),
                       ["support-network"], "一起準備的人陪你練習，也成為這段故事裡的重要夥伴。")
            }
            if choice.kind == .learn && cost.time >= 5 {
                effect("cost.fatigue", .modelRule, .init(health: -2), ["cost-fatigue"],
                       "這次準備佔去較多時間，你需要休息；限制來自情境和安排，不是努力不夠。")
            }
            if choice.kind == .learn {
                let key = KeyedRandom.key(eventID: event.id, age: state.age, channel: "unexpected-encouragement")
                let draw = KeyedRandom.draw(seed: state.seed, key: key)
                let occurred = draw < 0.25
                randomTrial = .init(algorithm: KeyedRandom.version, key: key, draw: draw, threshold: 0.25,
                                    occurred: occurred, assumptionID: "luck-encouragement")
                effect("luck.encouragement", .randomness, occurred ? .init(relationships: 1) : .zero,
                       ["luck-encouragement"], occurred ? "這次意外收到別人的鼓勵。這是遊戲中的機會事件。" : "這次沒有額外的機會事件；好的選擇也不保證好運。")
            }
            if let hook = StoryRules.callback(event: event, choice: choice) {
                hooks = [hook]
                next.pendingHooks.append(contentsOf: hooks)
            }
            let clamp = next.resources.clamped - next.resources
            effect("resource.clamp", .modelRule, clamp, ["resource-bounds"], "四項資源維持在 0～100，沒有合成人生總分。")
            next.decisions.append(.init(eventID: event.id, choiceID: choice.id, age: state.age))
            next.story = try StoryMemory.rebuild(next.decisions, catalog: catalog)
        }
        try next.validate(catalog: catalog)
        return .init(state: next, trace: .init(
            engineVersion: state.engineVersion, dataVersion: state.dataVersion, contentVersion: state.contentVersion, seed: state.seed,
            eventID: event.id, choiceID: choice.id, eventTitle: event.title, choiceTitle: choice.title,
            recurringPerson: event.recurringPerson, storyVariantID: event.storyVariantID, storyBranch: projection.evaluation,
            eventSelection: selection,
            age: state.age, countryCode: state.countryCode,
            householdID: state.householdID, control: choice.control, applied: reasons.isEmpty, unavailableReasons: reasons,
            observations: context.observations, baseCost: baseCost, costSteps: costSteps, finalCost: cost,
            budgetBefore: .init(time: state.remainingTime, energy: state.remainingEnergy, materials: state.remainingMaterials),
            budgetAfter: .init(time: next.remainingTime, energy: next.remainingEnergy, materials: next.remainingMaterials),
            effectSteps: effects, randomTrial: randomTrial, resourcesBefore: state.resources,
            resourcesAfter: next.resources, scheduledHooks: hooks,
            recordedStoryFacts: reasons.isEmpty ? next.story.flags.filter { $0.age == state.age && $0.eventID == event.id && $0.choiceID == choice.id } : [],
            changedRelationships: reasons.isEmpty ? next.story.relationships.filter { nextPerson in state.story.relationships.first { $0.personID == nextPerson.personID } != nextPerson } : [],
            environmentGaps: environmentGaps))
    }
}
