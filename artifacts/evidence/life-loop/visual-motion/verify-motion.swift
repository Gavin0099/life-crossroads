import Foundation

/// Focused check of the actual App helper, compiled in the same invocation as LifeWorldMotion.swift.
/// Independent expectations: MOTION.md's 4s loop and the selected 1.25pt/0.65degree amplitude;
/// cubic ease-out at the halfway point = 7/8, then a held final frame.
@main struct MotionChecks {
    static func near(_ actual: Double, _ expected: Double, _ label: String) {
        precondition(abs(actual - expected) < 0.000_000_001, "\(label): \(actual), expected \(expected)")
    }
    static func main() throws {
        let points: [(Double, Double)] = [(0, 0), (1_000, -1.25), (2_000, 0), (4_000, 0)]
        for (time, expectedVertical) in points {
            near(LifeWorldMotion.pose(elapsedMs: time, reduceMotion: false).vertical, expectedVertical, "loop point \(time)")
        }
        near(LifeWorldMotion.pose(elapsedMs: 1_000, reduceMotion: false).leanDegrees, 0.65, "lean quarter")
        near(LifeWorldMotion.pose(elapsedMs: 1_000, reduceMotion: false).rippleHorizontal, 2, "ripple quarter")
        for index in 0..<4 {
            let first = LifeWorldMotion.pose(elapsedMs: 0, reduceMotion: false, actorIndex: index)
            let last = LifeWorldMotion.pose(elapsedMs: 4_000, reduceMotion: false, actorIndex: index)
            near(first.vertical, last.vertical, "loop seam actor \(index)")
            near(first.leanDegrees, last.leanDegrees, "lean seam actor \(index)")
            near(first.rippleHorizontal, last.rippleHorizontal, "water seam")
            let left = LifeWorldMotion.pose(elapsedMs: 3_999.99, reduceMotion: false, actorIndex: index)
            let right = LifeWorldMotion.pose(elapsedMs: 4_000.01, reduceMotion: false, actorIndex: index)
            precondition(abs(left.vertical - right.vertical) < 0.001, "continuity across loop")
        }
        let atPause = LifeWorldMotion.pose(elapsedMs: 1_375, reduceMotion: false)
        precondition(atPause == LifeWorldMotion.pose(elapsedMs: 1_375, reduceMotion: false), "same accumulated time preserves pose")
        let resumed = LifeWorldMotion.pose(elapsedMs: 1_375.01, reduceMotion: false)
        precondition(abs(atPause.vertical - resumed.vertical) < 0.001, "resuming from accumulated phase")
        for time in [0.0, 1_000, 4_000, 20_000] {
            let reduced = LifeWorldMotion.pose(elapsedMs: time, reduceMotion: true, actorIndex: 3)
            near(reduced.vertical, 0, "reduced body")
            near(reduced.leanDegrees, 0, "reduced lean")
            near(reduced.rippleHorizontal, 0, "reduced environment")
        }
        near(LifeWorldMotion.arrival(phaseElapsedMs: 0, reduceMotion: false), 0, "one-shot first")
        near(LifeWorldMotion.arrival(phaseElapsedMs: 240, reduceMotion: false), 0.875, "one-shot half")
        near(LifeWorldMotion.arrival(phaseElapsedMs: 480, reduceMotion: false), 1, "one-shot final")
        near(LifeWorldMotion.arrival(phaseElapsedMs: 2_000, reduceMotion: false), 1, "one-shot holds")
        near(LifeWorldMotion.arrival(phaseElapsedMs: 0, reduceMotion: true), 1, "reduced committed final")
        near(LifeWorldMotion.committedTokenOpacity(arrival: 0), 0.45, "frozen committed first-frame token stays visible")
        near(LifeWorldMotion.committedTokenOpacity(arrival: 1), 1, "committed final token opaque")
        for invalid in [-1.0, Double.nan, Double.infinity] {
            let pose = LifeWorldMotion.pose(elapsedMs: invalid, reduceMotion: false)
            precondition(pose.vertical.isFinite && pose.leanDegrees.isFinite && pose.rippleHorizontal.isFinite)
            near(LifeWorldMotion.arrival(phaseElapsedMs: invalid, reduceMotion: false), 0, "invalid one-shot time")
        }
        let frames = points.map { time, _ in
            ["elapsedMs": time, "pose": ["vertical": LifeWorldMotion.pose(elapsedMs: time, reduceMotion: false).vertical,
                                        "leanDegrees": LifeWorldMotion.pose(elapsedMs: time, reduceMotion: false).leanDegrees,
                                        "rippleHorizontal": LifeWorldMotion.pose(elapsedMs: time, reduceMotion: false).rippleHorizontal]] as [String: Any]
        }
        let report: [String: Any] = ["result": "PASS", "source": "actual App/LifeWorldMotion.swift", "frames": frames,
                                   "boundary": "Pure visual functions only; Gameplay integration must verify clock pause/speed/background and authoritative life equality."]
        let data = try JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys])
        FileHandle.standardOutput.write(data)
        print()
    }
}
