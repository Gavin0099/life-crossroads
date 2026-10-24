import LifeDomain

/// Canonical progression identity; presentation generations also distinguish restarts of the same Seed.
public struct WorldSessionIdentity: Equatable, Sendable {
    public let country: String
    public let household: String
    public let seed: UInt64
    public let decisionCount: Int
    public let phase: SessionPhase
    public init(_ session: LifeSession) {
        country = session.state.countryCode; household = session.state.householdID
        seed = session.state.seed; decisionCount = session.traces.count; phase = session.phase
    }
}
public struct WorldAdvanceTicket: Equatable, Sendable {
    public let identity: WorldSessionIdentity
    public let generation: UInt64
}

/// Pure, injected-monotonic-clock state machine. It never mutates a life, draws randomness or performs I/O.
/// App owner validates a ticket, saves, then calls bind on the published session. No speculative world state.
public struct WorldPlayback: Equatable, Sendable {
    public enum Speed: Double, Sendable { case normal = 1, fast = 3 }
    public private(set) var identity: WorldSessionIdentity?
    public private(set) var phase: LifeWorldMomentKind = .eventPaused
    public private(set) var generation: UInt64 = 0
    public private(set) var elapsedMs: Double = 0
    public private(set) var phaseElapsedMs: Double = 0
    public private(set) var paused = false
    public private(set) var suspended = false
    public private(set) var offscreen = false
    public private(set) var speed: Speed = .normal
    public private(set) var awaitingCommit = false
    private var previousTime: Double?
    public init() {}
    public var isTimed: Bool { phase == .living || phase == .committedOutcome }
    public var isRunning: Bool { isTimed && !paused && !suspended && !offscreen && !awaitingCommit }
    public var phaseToken: String { "\(generation):\(phase.rawValue)" }
    public var durationMs: Double { phase == .living ? 3000 : 2000 }
    public var progress: Double { min(1, phaseElapsedMs / durationMs) }

    public mutating func bind(_ session: LifeSession, now: Double, restoring: Bool = false, reset: Bool = false) {
        if reset { elapsedMs = 0; paused = false; speed = .normal }
        generation &+= 1; identity = .init(session); awaitingCommit = false
        previousTime = now; phaseElapsedMs = 0
        switch session.phase {
        case .choosing: phase = restoring ? .eventPaused : .living
        case .reflecting: phase = .committedOutcome
        case .ended: phase = .ending
        }
        // A cold restored outcome is read-only until the user explicitly continues.
        paused = paused || (restoring && session.phase == .reflecting)
        if paused && phase == .committedOutcome { phaseElapsedMs = durationMs }
    }
    public mutating func setPaused(_ value: Bool, now: Double) { settle(now); paused = value }
    public mutating func setSuspended(_ value: Bool, now: Double) { settle(now); suspended = value }
    public mutating func setOffscreen(_ value: Bool, now: Double) { settle(now); offscreen = value }
    public mutating func setSpeed(_ value: Speed, now: Double) { settle(now); speed = value }
    private mutating func settle(_ now: Double) {
        if let previousTime, now >= previousTime, isRunning {
            let delta = (now - previousTime) * 1000 * speed.rawValue
            elapsedMs += delta; phaseElapsedMs += delta
        }
        // Wall time is monotonic in App; a backwards injected sample cannot create a future catchup.
        if previousTime == nil || now >= previousTime! { previousTime = now }
    }
    public mutating func tick(now: Double) -> WorldAdvanceTicket? {
        settle(now)
        guard isRunning, phaseElapsedMs >= durationMs else { return nil }
        return finish()
    }
    /// Explicit action is allowed while paused (VoiceOver / restored results); never while covered.
    public mutating func skip(now: Double) -> WorldAdvanceTicket? {
        settle(now)
        guard isTimed, !suspended, !awaitingCommit else { return nil }
        return finish()
    }
    private mutating func finish() -> WorldAdvanceTicket? {
        if phase == .living {
            generation &+= 1; phase = .eventPaused; phaseElapsedMs = 0
            return nil
        }
        guard phase == .committedOutcome, let identity else { return nil }
        awaitingCommit = true
        return .init(identity: identity, generation: generation)
    }
    public func accepts(_ ticket: WorldAdvanceTicket, session: LifeSession) -> Bool {
        awaitingCommit && ticket.generation == generation && ticket.identity == identity
            && ticket.identity == WorldSessionIdentity(session) && session.phase == .reflecting
    }
    public mutating func commitFailed(now: Double) {
        generation &+= 1; previousTime = now; awaitingCommit = false; paused = true
    }
    public func motion(reduceMotion: Bool) -> PresentationMotionFrame {
        .init(elapsedMs: elapsedMs, frozen: !isRunning, reduceMotion: reduceMotion,
              phase: phase, phaseToken: phaseToken, phaseElapsedMs: phaseElapsedMs)
    }
}
