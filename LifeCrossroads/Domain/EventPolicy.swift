import Foundation

public struct SelectionRules: Codable, Equatable, Sendable {
    public var version: String
    public var continuityMultiplier: Double
    public var relationshipMultiplier: Double
    public var recentCategoryMultiplier: Double
    public var recentCategoryWindow: Int
}
public struct EventResourceWeight: Codable, Equatable, Sendable {
    public var resource: String
    public var atMost: Int
    public var multiplier: Double
}
public struct EventPolicy: Codable, Equatable, Sendable {
    public var minimumAge: Int
    public var maximumAge: Int
    public var category: String
    public var baseWeight: Double
    public var repeatable: Bool
    public var cooldownDecisions: Int
    public var exclusiveGroup: String?
    public var continuityFlag: String?
    public var continuityValues: [String]
    public var relationshipID: String?
    public var resourceWeights: [EventResourceWeight]
    public var focusAffinity: LifeFocus? = nil
    public func includes(_ age: Int) -> Bool { (minimumAge...maximumAge).contains(age) }
}

extension ModelCatalog {
    func validateEventPolicies() throws {
        let rules = selectionRules
        guard rules.version == "story-race-rules-1", (1...4).contains(rules.continuityMultiplier),
              (1...2).contains(rules.relationshipMultiplier), (0.1...1).contains(rules.recentCategoryMultiplier),
              (1...3).contains(rules.recentCategoryWindow) else { throw ModelError.invalid("selection rules") }
        let categories: Set<String> = ["learning", "friendship", "work", "care", "community", "nature", "reflection", "recovery"]
        for event in decisions {
            let p = event.selection
            guard (8...80).contains(p.minimumAge), (p.minimumAge...80).contains(p.maximumAge), p.includes(event.age),
                  categories.contains(p.category), p.baseWeight.isFinite, (0.1...10).contains(p.baseWeight),
                  (0...14).contains(p.cooldownDecisions), !p.repeatable || p.cooldownDecisions >= 1,
                  p.exclusiveGroup == nil || !(p.exclusiveGroup?.isEmpty ?? true) else { throw ModelError.invalid("event selection policy") }
            if let key = p.continuityFlag {
                guard let allowed = StoryMemory.values[key], !p.continuityValues.isEmpty,
                      Set(p.continuityValues).isSubset(of: allowed) else { throw ModelError.invalid("continuity flag") }
            } else if !p.continuityValues.isEmpty { throw ModelError.invalid("unkeyed continuity values") }
            if let person = p.relationshipID, !StoryMemory.people.contains(person) { throw ModelError.invalid("relationship weight") }
            guard Set(p.resourceWeights.map(\.resource)).count == p.resourceWeights.count else { throw ModelError.invalid("duplicate resource weights") }
            for weight in p.resourceWeights {
                guard ["health", "financial", "relationships", "skills"].contains(weight.resource), (0...100).contains(weight.atMost),
                      weight.multiplier.isFinite, (0.25...4).contains(weight.multiplier) else { throw ModelError.invalid("resource weight") }
            }
            for choice in event.choices {
                if choice.requiresElectricTools == true {
                    guard !choice.requiresDigitalAccess, assumptions.contains(where: { $0.id == "environment-opportunities" }) else { throw ModelError.invalid("offline tools contract") }
                }
                guard Set(choice.storyChanges.map(\.key)).count == choice.storyChanges.count else { throw ModelError.invalid("duplicate choice story key") }
                for change in choice.storyChanges {
                    guard StoryMemory.values[change.key]?.contains(change.value) == true,
                          change.personID.isEmpty || StoryMemory.people.contains(change.personID),
                          (-2...2).contains(change.relationshipDelta), !change.personID.isEmpty || change.relationshipDelta == 0 else {
                        throw ModelError.invalid("choice story mutation")
                    }
                }
            }
            if let continuation = event.continuation {
                guard let allowed = StoryMemory.values[continuation.flag], !continuation.activeValues.isEmpty,
                      Set(continuation.activeValues).isSubset(of: allowed), (0...100).contains(continuation.minimumSkills),
                      !continuation.unlockedChoices.isEmpty,
                      Set(continuation.unlockedChoices).count == continuation.unlockedChoices.count,
                      continuation.unlockedChoices.allSatisfy({ id in event.choices.contains { $0.id == id && $0.kind != .rest } }),
                      !continuation.activeTitle.isEmpty, !continuation.recoveryTitle.isEmpty else { throw ModelError.invalid("story continuation") }
            }
            if let focus = p.focusAffinity {
                guard focus != .balanced, event.focusContinuation?.focus == focus else { throw ModelError.invalid("focus affinity") }
            }
            if let route = event.focusContinuation {
                guard event.continuation == nil, route.focus != .balanced, p.focusAffinity == route.focus, (1...3).contains(route.minimumIntervals),
                      event.choices.contains(where: { $0.id == route.unlockedChoiceID && $0.kind != .rest }),
                      !route.activeTitle.isEmpty, !route.firstTitle.isEmpty,
                      assumptions.contains(where: { $0.id == "life-focus-story" }) else {
                    throw ModelError.invalid("focus continuation")
                }
            }
        }
        // Each slot retains an unused, unconditional recovery-bearing candidate. These are candidates, not forced outcomes.
        for age in EventSchedule.decisionAges {
            guard decisions.filter({ $0.age == age && $0.selection.minimumAge == age && $0.isFallback && $0.eligibility.isEmpty
                && $0.selection.exclusiveGroup == nil }).count == 1 else { throw ModelError.missing("one unconditional fallback per age") }
        }
        for (age, id) in EventSchedule.milestones {
            guard let event = decisions.first(where: { $0.id == id }), event.age == age,
                  event.selection.minimumAge == age, event.selection.maximumAge == age, event.isFallback else { throw ModelError.invalid("milestone") }
        }
    }
}
