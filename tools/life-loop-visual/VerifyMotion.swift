import Foundation

@main struct VerifyAdoptedMotion {
    static func main() throws {
        var checks: [[String: Any]] = []
        func check(_ name: String, _ passed: Bool) throws {
            checks.append(["name": name, "passed": passed])
            guard passed else { throw NSError(domain: name, code: 1) }
        }
        try check("Loop returns to the same pose at 4000ms, including companion phase",
            (0..<3).allSatisfy { LifeWorldMotion.pose(elapsedMs: 0, reduceMotion: false, actorIndex: $0)
                == LifeWorldMotion.pose(elapsedMs: 4000, reduceMotion: false, actorIndex: $0) })
        try check("Whole PNG motion stays within the small-motion specification",
            stride(from: 0.0, through: 4000.0, by: 125).allSatisfy {
                let p = LifeWorldMotion.pose(elapsedMs: $0, reduceMotion: false)
                return abs(p.vertical) <= 2 && abs(p.leanDegrees) <= 2 && abs(p.rippleHorizontal) <= 3
            })
        let before = LifeWorldMotion.pose(elapsedMs: 1250, reduceMotion: false)
        let after = LifeWorldMotion.pose(elapsedMs: 1251, reduceMotion: false)
        try check("Adjacent supplied times remain continuous", abs(before.vertical - after.vertical) < 0.01)
        try check("Reduced motion selects the full static first pose",
            LifeWorldMotion.pose(elapsedMs: 1250, reduceMotion: true)
            == LifeWorldMotion.pose(elapsedMs: 0, reduceMotion: true))
        try check("Nonfinite time has a finite fallback",
            LifeWorldMotion.pose(elapsedMs: .nan, reduceMotion: false).vertical.isFinite)
        try check("One shot starts at zero and holds the final frame",
            LifeWorldMotion.arrival(phaseElapsedMs: 0, reduceMotion: false) == 0
            && LifeWorldMotion.arrival(phaseElapsedMs: 480, reduceMotion: false) == 1
            && LifeWorldMotion.arrival(phaseElapsedMs: 10000, reduceMotion: false) == 1)
        try check("Reduced committed outcome uses the final frame immediately",
            LifeWorldMotion.arrival(phaseElapsedMs: 0, reduceMotion: true) == 1)
        try check("A committed record remains visible even at a frozen initial frame",
            LifeWorldMotion.committedTokenOpacity(arrival: 0) > 0
            && LifeWorldMotion.committedTokenOpacity(arrival: 1) == 1)
        let result: [String: Any] = ["checks": checks,
            "scope": "Adopted render-only LifeWorldMotion; does not prove Gameplay clock, saving, phase-token ownership, or G1-G6"]
        try JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted, .sortedKeys])
            .write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
        print("\(checks.count) adopted render-only motion checks passed")
    }
}
