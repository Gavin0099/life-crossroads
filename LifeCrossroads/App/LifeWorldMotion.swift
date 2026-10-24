import Foundation

/// Original, clock-free drawing calculations. General small-amplitude/one-shot principles were
/// reviewed in rossark-motion-skill@9b20964; no upstream source or clock was copied.
enum LifeWorldMotion {
    static let loopMs: Double = 4_000
    static let arrivalMs: Double = 480

    struct Pose: Equatable, Codable {
        let vertical: Double
        let leanDegrees: Double
        let rippleHorizontal: Double
    }

    /// Caller owns elapsed time. In particular, `frozen` must not substitute zero for this input.
    /// Only Reduce Motion selects frame zero, where the complete original PNG remains readable.
    static func pose(elapsedMs: Double, reduceMotion: Bool, actorIndex: Int = 0) -> Pose {
        let time = reduceMotion || !elapsedMs.isFinite ? 0 : max(0, elapsedMs)
        let phase = time.truncatingRemainder(dividingBy: loopMs) / loopMs * 2 * Double.pi
        let actorPhase = reduceMotion ? 0 : Double(actorIndex) * Double.pi / 2
        return .init(vertical: -1.25 * sin(phase + actorPhase),
                     leanDegrees: 0.65 * sin(phase + actorPhase),
                     rippleHorizontal: 2 * sin(phase))
    }

    /// A committed token settles in once, then holds. There is no onAppear, clock or callback here.
    /// The caller must separately establish that this is a committed outcome, not a pending clue.
    static func arrival(phaseElapsedMs: Double, reduceMotion: Bool) -> Double {
        if reduceMotion { return 1 }
        let time = phaseElapsedMs.isFinite ? max(0, phaseElapsedMs) : 0
        let fraction = min(1, time / arrivalMs)
        let remaining = 1 - fraction
        return 1 - remaining * remaining * remaining
    }

    static func committedTokenOpacity(arrival: Double) -> Double {
        0.45 + min(1, max(0, arrival)) * 0.55
    }
}
