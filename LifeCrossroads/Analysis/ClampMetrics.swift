import Foundation
import LifeDomain

private struct ClampObservation {
    let before: ResourceValues
    let after: ResourceValues
    let requested: ResourceValues
    let clamp: ResourceValues
    let kind: ClampAttributionKind
    let age: Int
    let fromAge: Int?
    let eventID: String?
    let choiceID: String?
    let originHooks: [HookOrigin]
}

private struct AttributionIdentity: Codable {
    let kind: ClampAttributionKind
    let resource: ResourceName
    let age: Int
    let fromAge: Int?
    let eventID: String?
    let choiceID: String?
    let originHooks: [HookOrigin]
}

private struct AttributionAccumulator {
    let identity: AttributionIdentity
    var positiveSteps = 0
    var clippedSteps = 0
    var requestedPoints = 0
    var lostPoints = 0
}

extension BatchAnalyzer {
    static func clampSummary(runs: [BatchRun], isJump: Bool) throws -> ClampSummary {
        let observations: [ClampObservation]
        if isJump {
            observations = runs.flatMap(\.timeJumps).map { jump in
                .init(before: jump.resourcesBefore, after: jump.resourcesAfter, requested: jump.requestedDeltaBeforeClamp,
                      clamp: jump.clampAdjustment, kind: jump.originHooks.count == 1 ? .singleHookJump : .aggregateHookJump,
                      age: jump.toAge, fromAge: jump.fromAge, eventID: nil, choiceID: nil,
                      originHooks: jump.originHooks.sorted { $0.hookID < $1.hookID })
            }
        } else {
            observations = runs.flatMap(\.steps).map { step in
                .init(before: step.resourcesBefore, after: step.resourcesAfter, requested: step.requestedDeltaBeforeClamp,
                      clamp: step.clampAdjustment, kind: .decision, age: step.age, fromAge: nil,
                      eventID: step.eventID, choiceID: step.choiceID, originHooks: [])
            }
        }
        var attribution: [String: AttributionAccumulator] = [:]
        let summaries = try ResourceName.allCases.map { resource in
            var positiveSteps = 0, clippedSteps = 0, fullyOffset = 0, requestedPoints = 0, lostPoints = 0, lowerPoints = 0
            for point in observations {
                let request = resource.read(point.requested)
                let signedClamp = resource.read(point.clamp)
                lowerPoints += max(0, signedClamp)
                // Net requested gain is the unit. +4 and -4 is zero, not four points erased by a cap.
                guard request > 0 else { continue }
                let loss = max(0, -signedClamp)
                guard loss <= request else { throw ModelError.invalid("analysis upper loss exceeds net request") }
                positiveSteps += 1; requestedPoints += request; lostPoints += loss
                if loss > 0 {
                    clippedSteps += 1
                    if resource.read(point.after) == resource.read(point.before) { fullyOffset += 1 }
                }
                let identity = AttributionIdentity(kind: point.kind, resource: resource, age: point.age, fromAge: point.fromAge,
                                                   eventID: point.eventID, choiceID: point.choiceID, originHooks: point.originHooks)
                let key = try canonical(identity)
                var item = attribution[key] ?? AttributionAccumulator(identity: identity)
                item.positiveSteps += 1; item.requestedPoints += request; item.lostPoints += loss
                if loss > 0 { item.clippedSteps += 1 }
                attribution[key] = item
            }
            return ClampResourceSummary(resource: resource, positiveNetGainSteps: positiveSteps,
                                        clippedAcrossAllSteps: .init(clippedSteps, of: observations.count),
                                        clippedPositiveSteps: .init(clippedSteps, of: positiveSteps),
                                        fullyOffsetPositiveSteps: .init(fullyOffset, of: positiveSteps),
                                        requestedPositivePoints: requestedPoints,
                                        lostPositivePoints: .init(lostPoints, of: requestedPoints), lowerBoundAdjustmentPoints: lowerPoints)
        }
        let attributions = attribution.keys.sorted().compactMap { key -> ClampAttribution? in
            guard let item = attribution[key], item.lostPoints > 0 else { return nil }
            return .init(kind: item.identity.kind, resource: item.identity.resource, age: item.identity.age,
                         fromAge: item.identity.fromAge, eventID: item.identity.eventID, choiceID: item.identity.choiceID,
                         originHooks: item.identity.originHooks, clippedOccurrences: .init(item.clippedSteps, of: item.positiveSteps),
                         lostPositivePoints: .init(item.lostPoints, of: item.requestedPoints))
        }
        return .init(totalObservations: observations.count,
                     observationsWithHooks: isJump ? observations.filter { !$0.originHooks.isEmpty }.count : nil,
                     resources: summaries, attributions: attributions)
    }
}
