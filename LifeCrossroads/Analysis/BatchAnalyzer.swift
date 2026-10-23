import Foundation
import LifeDomain

public enum BatchAnalyzer {
    public static let analysisVersion = "rng-v2-analysis-2"
    public static let policyVersion = "lc05-policies-1"
    public static let countryCodes = ["JPN", "USA", "IND", "KEN"]
    public static let varietyChannel = "analysis-policy-seeded-variety-v1"

    public static func run(catalog: ModelCatalog, seeds: [UInt64]) throws -> BatchReport {
        try catalog.validate()
        guard !seeds.isEmpty, Set(seeds).count == seeds.count else { throw ModelError.invalid("empty or duplicate analysis seed set") }
        let orderedSeeds = seeds.sorted()
        var backgrounds: [BatchBackground] = []
        for code in countryCodes {
            guard catalog.countries.contains(where: { $0.code == code && $0.dataStatus == .ready }) else {
                throw ModelError.missing("analysis country \(code)")
            }
            let families = catalog.households.filter { $0.countryCode == code }.sorted { $0.id < $1.id }
            guard families.count == 2 else { throw ModelError.invalid("analysis requires two families per country") }
            backgrounds += families.map { .init(countryCode: code, householdID: $0.id, templateID: $0.templateID) }
        }
        var runs: [BatchRun] = []
        for background in backgrounds {
            for policy in BatchPolicy.allCases {
                for seed in orderedSeeds {
                    runs.append(try simulate(catalog: catalog, background: background, policy: policy, seed: seed))
                }
            }
        }
        let cohorts = try backgrounds.flatMap { background in
            try BatchPolicy.allCases.map { policy in
                try summarizeCohort(catalog: catalog, background: background, policy: policy,
                                    runs: runs.filter { $0.background == background && $0.policy == policy })
            }
        }
        var comparisons: [PolicyPairComparison] = []
        let policies = BatchPolicy.allCases
        for background in backgrounds {
            for first in policies.indices {
                for second in policies.indices where second > first {
                    let left = runs.filter { $0.background == background && $0.policy == policies[first] }.sorted { $0.seed < $1.seed }
                    let right = runs.filter { $0.background == background && $0.policy == policies[second] }.sorted { $0.seed < $1.seed }
                    guard left.map(\.seed) == orderedSeeds, right.map(\.seed) == orderedSeeds else {
                        throw ModelError.invalid("unpaired analysis policy samples")
                    }
                    comparisons.append(.init(background: background, firstPolicy: policies[first], secondPolicy: policies[second],
                                             pairedSeeds: orderedSeeds, differences: try pairDifferences(Array(zip(left, right)))))
                }
            }
        }
        return .init(schemaVersion: 2, analysisVersion: analysisVersion, policyVersion: policyVersion,
                     engineVersion: LifeState.engineVersion, dataVersion: catalog.dataVersion, contentVersion: catalog.contentVersion,
                     seeds: orderedSeeds, policies: policies, policyDefinitions: policies.map(definition), countryCodes: countryCodes,
                     decisionAges: LifeSession.decisionAges, runCount: runs.count, cohorts: cohorts,
                     policyComparisons: comparisons, runs: runs,
                     claimBoundary: "固定四國、每國兩個虛構家庭、明列策略與Seed的模型批次；不是全球分布、真實事件率、現實因果或娛樂性證明。0次只表示本批次未觀察到，不能據此判定不可達。首次到100指記錄到的初始、跳躍後或決策後狀態；跳躍中沒有逐年觀測。")
    }

    public static func definition(_ policy: BatchPolicy) -> PolicyDefinition {
        let priority: [String]
        let kinds: [ChoiceKind]
        let secondary: [String]
        switch policy {
        case .investFirst: priority = ["invest"]; kinds = [.learn, .work, .share, .care]; secondary = ["ask", "rest"]
        case .supportFirst: priority = ["ask"]; kinds = [.askSupport]; secondary = ["invest", "rest"]
        case .restFirst: priority = ["rest"]; kinds = [.rest]; secondary = ["ask", "invest"]
        case .seededVariety: priority = []; kinds = []; secondary = []
        }
        return .init(policy: policy, priorityChoiceIDs: priority, preferredChoiceKinds: kinds, fallbackChoiceIDs: secondary,
                     fallback: "available primary IDs in order, then preferred kinds in order (ties by choice ID), then fallback IDs in order, finally ascending choice ID; seededVariety uniformly chooses sorted available IDs instead",
                     randomChannel: policy == .seededVariety ? varietyChannel : nil)
    }

    static func choose(policy: BatchPolicy, available: [ChoiceDefinition], seed: UInt64, eventID: String, age: Int) throws -> String {
        let ordered = available.sorted { $0.id < $1.id }
        guard !ordered.isEmpty else { throw ModelError.unavailable("analysis found no available choice") }
        if policy == .seededVariety {
            let key = KeyedRandom.key(eventID: eventID, age: age, channel: varietyChannel)
            let draw = KeyedRandom.draw(seed: seed, key: key)
            return ordered[min(ordered.count - 1, Int(draw * Double(ordered.count)))].id
        }
        let rule = definition(policy)
        for id in rule.priorityChoiceIDs where ordered.contains(where: { $0.id == id }) { return id }
        for kind in rule.preferredChoiceKinds {
            if let choice = ordered.first(where: { $0.kind == kind }) { return choice.id }
        }
        for id in rule.fallbackChoiceIDs where ordered.contains(where: { $0.id == id }) { return id }
        guard let first = ordered.first else { throw ModelError.unavailable("analysis choice missing") }
        return first.id
    }

    private static func simulate(catalog: ModelCatalog, background: BatchBackground, policy: BatchPolicy, seed: UInt64) throws -> BatchRun {
        var session = try LifeSession.start(catalog: catalog, countryCode: background.countryCode,
                                            householdID: background.householdID, seed: seed)
        guard let initial = session.jumps.first?.resourcesBefore else { throw ModelError.missing("analysis birth observation") }
        var steps: [BatchStep] = []
        while session.phase != .ended {
            guard session.phase == .choosing, steps.count < session.plannedDecisionCount else {
                throw ModelError.invalid("analysis playthrough cannot progress")
            }
            let event = try session.event(catalog: catalog)
            let ordered = event.choices.sorted { $0.id < $1.id }
            var available: [ChoiceDefinition] = []
            for choice in ordered {
                if try session.preview(choiceID: choice.id, catalog: catalog).applied { available.append(choice) }
            }
            let choiceID = try choose(policy: policy, available: available, seed: seed, eventID: event.id, age: event.age)
            try session.choose(choiceID, catalog: catalog)
            guard let trace = session.traces.last, trace.applied else { throw ModelError.invalid("analysis decision was not applied") }
            let requested = trace.effectSteps.filter { $0.ruleID != "resource.clamp" }.reduce(ResourceValues.zero) { $0 + $1.delta }
            let clamp = trace.effectSteps.filter { $0.ruleID == "resource.clamp" }.reduce(ResourceValues.zero) { $0 + $1.delta }
            guard let chosen = ordered.first(where: { $0.id == trace.choiceID }) else { throw ModelError.missing("analysis chosen option") }
            steps.append(.init(age: trace.age, eventID: trace.eventID, storyVariantID: trace.storyVariantID, choiceID: trace.choiceID,
                               chosenKind: chosen.kind, storyBranch: trace.storyBranch,
                               offeredChoiceIDs: ordered.map(\.id), availableChoiceIDs: available.map(\.id),
                               resourcesBefore: trace.resourcesBefore, resourcesAfter: trace.resourcesAfter,
                               requestedDeltaBeforeClamp: requested, clampAdjustment: clamp,
                               candidates: trace.eventSelection.candidates.map { .init(eventID: $0.eventID, eligible: $0.eligible, conditions: $0.conditions, selection: $0) }, eventCategory: event.selection.category))
            try session.continueLife(catalog: catalog)
        }
        guard steps.count == session.plannedDecisionCount, session.state.decisions.count == steps.count else {
            throw ModelError.invalid("analysis incomplete playthrough")
        }
        // Extract the final ledger once. Re-reading the accumulated ledger after every turn would count early jumps repeatedly.
        let jumps = session.jumps.map { jump in
            BatchJump(fromAge: jump.fromAge, toAge: jump.toAge, resourcesBefore: jump.resourcesBefore,
                      resourcesAfter: jump.resourcesAfter,
                      requestedDeltaBeforeClamp: jump.triggeredHooks.reduce(.zero) { $0 + $1.effect },
                      clampAdjustment: jump.clampAdjustment,
                      originHooks: jump.triggeredHooks.sorted { $0.id < $1.id }.map {
                          .init(hookID: $0.id, eventID: $0.originEventID, choiceID: $0.originChoiceID,
                                dueAge: $0.dueAge, requestedEffect: $0.effect)
                      })
        }
        let linked = Set(steps.compactMap { step -> String? in
            guard let branch = step.storyBranch, let age = branch.sourceAge,
                  steps.contains(where: { $0.age == age && $0.age < step.age && $0.eventID == branch.sourceEventID && $0.choiceID == branch.sourceChoiceID }),
                  ["teen-direction-paper", "teen-direction-online", "middle-support-reciprocal", "later-reconnect-old-friend"].contains(branch.variantID) || (branch.variantID.hasSuffix("-continuation") && step.availableChoiceIDs.contains("lead")) else { return nil }
            return branch.ruleID
        }).sorted()
        let run = BatchRun(runID: "\(background.countryCode)/\(background.householdID)/\(policy.rawValue)/\(seed)",
                           background: background, policy: policy, seed: seed, initialResources: initial,
                           finalResources: session.state.resources, steps: steps, timeJumps: jumps, linkedStoryChains: linked)
        try validateObservations(run)
        return run
    }
}
