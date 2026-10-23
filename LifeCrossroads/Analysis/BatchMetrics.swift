import Foundation
import LifeDomain

private struct StoryRouteToken: Codable {
    let eventID: String
    let storyVariantID: String?
}

extension BatchAnalyzer {
    static func canonical<T: Encodable>(_ value: T) throws -> String {
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        guard let string = String(data: try encoder.encode(value), encoding: .utf8) else { throw ModelError.invalid("analysis signature encoding") }
        return string
    }

    static func validateObservations(_ run: BatchRun) throws {
        let ages = LifeSession.decisionAges
        try run.initialResources.validate(in: 0...100); try run.finalResources.validate(in: 0...100)
        guard run.steps.map(\.age) == ages, run.timeJumps.map(\.toAge) == ages,
              run.timeJumps.map(\.fromAge) == [0] + Array(ages.dropLast()),
              Set(run.timeJumps.flatMap(\.originHooks).map(\.hookID)).count == run.timeJumps.flatMap(\.originHooks).count else {
            throw ModelError.invalid("analysis incomplete or duplicated observation ledger")
        }
        func point(_ before: ResourceValues, _ after: ResourceValues, _ delta: ResourceValues, _ clamp: ResourceValues) throws {
            try before.validate(in: 0...100); try after.validate(in: 0...100)
            try delta.validate(in: -1000...1000); try clamp.validate(in: -1000...1000)
            let raw = before + delta
            guard raw.clamped == after, after - raw == clamp else { throw ModelError.invalid("analysis clamp does not reconcile") }
        }
        for index in ages.indices {
            let step = run.steps[index], jump = run.timeJumps[index]
            try point(step.resourcesBefore, step.resourcesAfter, step.requestedDeltaBeforeClamp, step.clampAdjustment)
            try point(jump.resourcesBefore, jump.resourcesAfter, jump.requestedDeltaBeforeClamp, jump.clampAdjustment)
            guard jump.resourcesBefore == (index == 0 ? run.initialResources : run.steps[index - 1].resourcesAfter),
                  jump.resourcesAfter == step.resourcesBefore,
                  jump.originHooks.reduce(ResourceValues.zero, { $0 + $1.requestedEffect }) == jump.requestedDeltaBeforeClamp,
                  Set(step.offeredChoiceIDs).count == step.offeredChoiceIDs.count,
                  Set(step.availableChoiceIDs).isSubset(of: Set(step.offeredChoiceIDs)),
                  step.availableChoiceIDs.contains(step.choiceID),
                  Set(step.candidates.map(\.eventID)).count == step.candidates.count,
                  step.candidates.contains(where: { $0.eventID == step.eventID && $0.eligible }) else {
                throw ModelError.invalid("analysis observation chain or selected choice invalid")
            }
        }
        guard run.steps.last?.resourcesAfter == run.finalResources else { throw ModelError.invalid("analysis final resources mismatch") }
    }

    static func pairDifferences(_ pairs: [(BatchRun, BatchRun)]) throws -> PairDifferences {
        let count = LifeSession.decisionAges.count
        var eventBins = Array(repeating: 0, count: count + 1)
        var storyBins = eventBins
        for (first, second) in pairs {
            guard first.steps.count == count, second.steps.count == count,
                  first.steps.map(\.age) == second.steps.map(\.age) else { throw ModelError.invalid("analysis Hamming routes not aligned") }
            var events = 0, stories = 0
            for (left, right) in zip(first.steps, second.steps) {
                if left.eventID != right.eventID { events += 1 }
                if left.eventID != right.eventID || left.storyVariantID != right.storyVariantID { stories += 1 }
            }
            eventBins[events] += 1; storyBins[stories] += 1
        }
        return .init(pairCount: pairs.count,
                     eventIDHamming: eventBins.enumerated().map { .init(distance: $0.offset, frequency: .init($0.element, of: pairs.count)) },
                     storyRouteHamming: storyBins.enumerated().map { .init(distance: $0.offset, frequency: .init($0.element, of: pairs.count)) })
    }

    static func summarizeCohort(catalog: ModelCatalog, background: BatchBackground, policy: BatchPolicy, runs: [BatchRun]) throws -> CohortReport {
        let ordered = runs.sorted { $0.seed < $1.seed }
        guard ordered.allSatisfy({ $0.background == background && $0.policy == policy }), Set(ordered.map(\.seed)).count == ordered.count else {
            throw ModelError.invalid("analysis cohort identity or repeated Seed")
        }
        for run in ordered { try validateObservations(run) }
        let allSteps = ordered.flatMap(\.steps)
        let coverage = try catalog.decisions.sorted { $0.age == $1.age ? $0.id < $1.id : $0.age < $1.age }.map { event in
            let ageSteps = allSteps.filter { event.selection.includes($0.age) }
            let candidates = ageSteps.compactMap { $0.candidates.first { $0.eventID == event.id } }
            guard candidates.count == ageSteps.count else { throw ModelError.missing("analysis missing candidate opportunity") }
            let eligible = candidates.filter(\.eligible).count
            let selected = ageSteps.filter { $0.eventID == event.id }.count
            guard selected <= eligible else { throw ModelError.invalid("analysis selected ineligible event") }
            let failures = try event.eligibility.sorted { $0.id < $1.id }.map { condition in
                let observations = candidates.flatMap(\.conditions).filter { $0.condition.id == condition.id }
                guard observations.count == candidates.count else { throw ModelError.missing("analysis condition evaluation") }
                return ConditionFailureFrequency(condition: condition, failed: .init(observations.filter { !$0.matched }.count, of: observations.count))
            }
            var exclusions: [String: Int] = [:]
            for candidate in candidates { for reason in candidate.selection?.exclusions ?? [] { exclusions[reason, default: 0] += 1 } }
            return EventCoverage(eventID: event.id, age: event.age, ageOpportunities: ageSteps.count,
                                 eligible: .init(eligible, of: ageSteps.count), selected: .init(selected, of: ageSteps.count),
                                 selectedWhenEligible: .init(selected, of: eligible),
                                 eligibleButNotSelected: .init(eligible - selected, of: eligible), conditionFailures: failures, ageWindow: [event.selection.minimumAge, event.selection.maximumAge], exclusionCounts: exclusions)
        }
        let choices = catalog.decisions.sorted { $0.id < $1.id }.flatMap { event in
            let eventSteps = allSteps.filter { $0.eventID == event.id }
            return event.choices.sorted { $0.id < $1.id }.map { choice in
                ChoiceFrequency(eventID: event.id, choiceID: choice.id,
                                offeredOpportunities: eventSteps.filter { $0.offeredChoiceIDs.contains(choice.id) }.count,
                                availableOpportunities: eventSteps.filter { $0.availableChoiceIDs.contains(choice.id) }.count,
                                chosen: .init(eventSteps.filter { $0.choiceID == choice.id }.count, of: eventSteps.count))
            }
        }
        var eventSignatures: [String: Int] = [:], storySignatures: [String: Int] = [:]
        for run in ordered {
            eventSignatures[try canonical(run.steps.map(\.eventID)), default: 0] += 1
            storySignatures[try canonical(run.steps.map { StoryRouteToken(eventID: $0.eventID, storyVariantID: $0.storyVariantID) }), default: 0] += 1
        }
        var pairs: [(BatchRun, BatchRun)] = []
        for first in ordered.indices {
            for second in ordered.indices where second > first { pairs.append((ordered[first], ordered[second])) }
        }
        let kinds: [ChoiceKind] = [.learn, .rest, .askSupport, .work, .care, .share]
        let kindHistogram = kinds.map { kind in ChoiceKindFrequency(kind: kind, frequency: .init(allSteps.filter { $0.chosenKind == kind }.count, of: allSteps.count)) }
        var repeated = 0, adjacent = 0
        for run in ordered {
            for (left, right) in zip(run.steps, run.steps.dropFirst()) {
                adjacent += 1
                if left.chosenKind == right.chosenKind { repeated += 1 }
            }
        }
        let chainDefinitions = [("story.childhood-connection", "friendship"), ("story.learning-route", "learning"),
                                ("story.care-network", "care"), ("story.repair", "repair"), ("story.kitchen", "kitchen"),
                                ("story.garden", "garden"), ("story.nature", "nature")]
        let chains = chainDefinitions.map { rule, flag in
            let origins = ordered.filter { run in run.steps.contains { step in
                catalog.decisions.first { $0.id == step.eventID }?.choices.first { $0.id == step.choiceID }?.storyChanges.contains { $0.key == flag } == true
            } }.count
            let traced = allSteps.filter { $0.storyBranch?.ruleID == rule }
            let withTrace = ordered.filter { $0.steps.contains { $0.storyBranch?.ruleID == rule } }.count
            let matches = ordered.filter { run in run.steps.contains { step in
                guard let branch = step.storyBranch, branch.ruleID == rule, let age = branch.sourceAge else { return false }
                return run.steps.contains { $0.age == age && $0.age < step.age && $0.eventID == branch.sourceEventID && $0.choiceID == branch.sourceChoiceID }
            } }.count
            var variants: [String: Int] = [:]
            for step in traced { if let id = step.storyVariantID { variants[id, default: 0] += 1 } }
            return StoryChainCoverage(ruleID: rule, originEventID: "flag:" + flag, outcomeEventID: "rule:" + rule,
                                      originObserved: .init(origins, of: ordered.count), outcomeWithTrace: .init(withTrace, of: ordered.count),
                                      traceMatchesPriorChoice: .init(matches, of: ordered.count),
                                      variants: variants.keys.sorted().map { .init(variantID: $0, frequency: .init(variants[$0, default: 0], of: traced.count)) })
        }
        let chainCounts = (0...7).map { value in ValueBin(value: value, frequency: .init(ordered.filter { $0.linkedStoryChains?.count == value }.count, of: ordered.count)) }
        let repeatedCategories = ordered.reduce(0) { sum, run in
            sum + zip(run.steps, run.steps.dropFirst()).filter { $0.eventCategory == $1.eventCategory }.count
        }
        return .init(background: background, policy: policy, runCount: ordered.count, eventCoverage: coverage, choiceHistogram: choices,
                     choiceKinds: kindHistogram, adjacentSameChoiceKind: .init(repeated, of: adjacent), storyChains: chains,
                     eventRoutes: eventSignatures.keys.sorted().map { .init(signature: $0, frequency: .init(eventSignatures[$0, default: 0], of: ordered.count)) },
                     storyRoutes: storySignatures.keys.sorted().map { .init(signature: $0, frequency: .init(storySignatures[$0, default: 0], of: ordered.count)) },
                     seedPairDifferences: try pairDifferences(pairs), resourceSummaries: try resources(ordered),
                     decisionClamps: try clampSummary(runs: ordered, isJump: false), timeJumpClamps: try clampSummary(runs: ordered, isJump: true),
                     adjacentSameEventCategory: .init(repeatedCategories, of: adjacent), linkedChainCounts: chainCounts,
                     atLeastTwoLinkedChains: .init(ordered.filter { ($0.linkedStoryChains?.count ?? 0) >= 2 }.count, of: ordered.count))
    }

    static func resources(_ runs: [BatchRun]) throws -> [ResourceSummary] {
        try ResourceName.allCases.map { resource in
            var final = Array(repeating: 0, count: 101), firstAges: [Int: Int] = [:]
            var never = 0, ever = 0
            for run in runs {
                final[resource.read(run.finalResources)] += 1
                var first: Int? = resource.read(run.initialResources) == 100 ? 0 : nil
                for (jump, step) in zip(run.timeJumps, run.steps) where first == nil {
                    if resource.read(jump.resourcesAfter) == 100 || resource.read(step.resourcesAfter) == 100 { first = step.age }
                }
                if let first { ever += 1; firstAges[first, default: 0] += 1 } else { never += 1 }
            }
            let allSteps = runs.flatMap(\.steps)
            let byAge = LifeSession.decisionAges.map { age in
                let steps = allSteps.filter { $0.age == age }
                return AgeSaturation(age: age, postDecisionAt100: .init(steps.filter { resource.read($0.resourcesAfter) == 100 }.count, of: steps.count))
            }
            let byStage = try LifeStage.allCases.map { stage in
                let steps = try allSteps.filter { try LifeStage.at(age: $0.age) == stage }
                return StageSaturation(stage: stage, postDecisionAt100: .init(steps.filter { resource.read($0.resourcesAfter) == 100 }.count, of: steps.count))
            }
            return .init(resource: resource,
                         finalValues: final.enumerated().map { .init(value: $0.offset, frequency: .init($0.element, of: runs.count)) },
                         finalAt100: .init(final[100], of: runs.count), everObservedAt100: .init(ever, of: runs.count),
                         firstObservedAt100Age: [.init(age: nil, frequency: .init(never, of: runs.count))]
                            + ([0] + LifeSession.decisionAges).map { .init(age: $0, frequency: .init(firstAges[$0, default: 0], of: runs.count)) },
                         byAge: byAge, byStage: byStage)
        }
    }
}
