import LifeDomain

public enum LifeWorldPhase: String, Equatable, Sendable { case living, event, consequence, ended }
public enum LifePlaybackSpeed: Int, CaseIterable, Sendable { case normal = 1, fast = 3 }

/// Transient choreography, never a simulation clock or part of a save. One pulse is a presentation beat.
/// No elapsed wall time is accepted, so suspended/offline time cannot advance even this presentation.
public struct LifePlayback: Equatable, Sendable {
    public private(set) var phase: LifeWorldPhase = .event
    public private(set) var fromAge = 0
    public private(set) var targetAge = 0
    public private(set) var progress: Double = 1
    public private(set) var isPaused = true
    public private(set) var speed: LifePlaybackSpeed = .normal
    public var isRunning: Bool { phase == .living && !isPaused }
    public var displayAge: Int { fromAge + Int(Double(targetAge - fromAge) * progress) }
    public init() {}

    public mutating func travel(from age: Int, to nextAge: Int) throws {
        guard (0...100).contains(age), (age...100).contains(nextAge) else {
            throw ModelError.invalid("presentation age interval")
        }
        fromAge = age; targetAge = nextAge; progress = 0; phase = .living; isPaused = false
        if age == nextAge { skip() }
    }
    public mutating func restore(_ session: LifeSession) {
        fromAge = session.state.age; targetAge = session.state.age; progress = 1; isPaused = true
        switch session.phase {
        case .choosing: phase = .event
        case .reflecting: phase = .consequence
        case .ended: phase = .ended
        }
    }
    public mutating func pulse() {
        guard isRunning else { return }
        progress = min(1, progress + Double(speed.rawValue) / 32)
        if progress == 1 { phase = .event; isPaused = true }
    }
    public mutating func skip() {
        guard phase == .living else { return }
        progress = 1; phase = .event; isPaused = true
    }
    public mutating func pause() { isPaused = true }
    public mutating func togglePause() { if phase == .living { isPaused.toggle() } }
    public mutating func setSpeed(_ speed: LifePlaybackSpeed) { self.speed = speed }
}
