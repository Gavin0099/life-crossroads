import LifeDomain

/// Counts a usable continuation with a verified earlier source, not a changed title or resource gain.
public struct StoryConnection: Codable, Equatable, Sendable {
    public let category: String
    public let ruleID: String
    public let sourceAge: Int
    public let outcomeAge: Int
    public let availableContinuations: [String]
    public let accepted: Bool
}
public enum StoryConnections {
    public static func evaluate(_ session: LifeSession, catalog: ModelCatalog) throws -> [StoryConnection] {
        var result: [StoryConnection] = []
        for (index, trace) in session.traces.enumerated() {
            guard let branch = trace.storyBranch, let event = catalog.decisions.first(where: { $0.id == trace.eventID }) else { continue }
            let sourceAge: Int, category: String, continuations: [String]
            if let focus = branch.focusSource, focus.toAge <= trace.age,
               session.state.focusHistory.contains(focus), let route = event.focusContinuation {
                sourceAge = focus.fromAge
                category = route.focus == .relationships ? "relationship" : route.focus == .recovery ? "recovery" : "growth"
                continuations = [route.unlockedChoiceID]
            } else {
                guard let age = branch.sourceAge, age < trace.age,
                      session.traces.prefix(index).contains(where: { $0.age == age && $0.eventID == branch.sourceEventID && $0.choiceID == branch.sourceChoiceID }) else { continue }
                sourceAge = age
                if let route = event.continuation {
                    category = route.flag == "support" ? "support" : route.flag == "recovery" ? "recovery" : "growth"
                    continuations = route.unlockedChoices
                } else if branch.environmentOpportunity != nil {
                    category = "environment"; continuations = ["reviewVisit","reviewShared","benchWork","mobileRepair"]
                } else if branch.opportunity != nil {
                    category = "environment"; continuations = ["remoteStudio","mentorRelay","portfolio","cooperate","leadWorkshop"]
                } else {
                    category = branch.flagKey == "friendship" ? "relationship" : branch.flagKey == "care" ? "support" : "growth"
                    continuations = branch.flagKey == "friendship" && branch.variantID == "later-reconnect-old-friend" ? ["invest","ask"] : ["leadWorkshop","shareShift"]
                }
            }
            // Rebuild only when a continuation is actually offered. Unaffordable offers are not counted.
            let offered = continuations.filter { branch.offeredChoiceIDs.contains($0) }
            guard !offered.isEmpty else { continue }
            let checkpoint = try session.beforeDecision(at: index, catalog: catalog)
            let available = try offered.filter { try checkpoint.preview(choiceID: $0, catalog: catalog).applied }
            guard !available.isEmpty else { continue }
            result.append(.init(category: category, ruleID: branch.ruleID, sourceAge: sourceAge, outcomeAge: trace.age,
                                availableContinuations: available, accepted: available.contains(trace.choiceID)))
        }
        return result
    }
}
