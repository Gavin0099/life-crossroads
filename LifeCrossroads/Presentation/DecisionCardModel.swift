import LifeDomain

/// Ephemeral input state. No life, RNG, clock or persistence mutation lives here.
public struct DecisionCardModel: Equatable, Sendable {
    public enum Phase: String, Sendable { case idle, dragging, preview, commitRequested, saved, failed }
    public static let threshold: Double = 96
    public private(set) var phase: Phase = .idle
    public private(set) var offset: Double = 0
    public private(set) var previewID: String?
    public private(set) var pendingID: String?
    public private(set) var cancelled = false
    private var interruptedDrag = false
    private var verticalGesture = false
    public init() {}

    public static func supports(_ event: DecisionSkeleton) -> Bool {
        event.id == "teen-project" && event.age == 13 && event.choices.count == 4
            && Set(event.choices.map(\.id)) == Set(["offline", "invest", "ask", "rest"])
    }
    public mutating func beginDrag() {
        guard phase != .commitRequested && phase != .saved else { return }
        interruptedDrag = false; verticalGesture = false; cancelled = false
        phase = .dragging; offset = 0; previewID = nil
    }
    public mutating func drag(x: Double, y: Double) {
        guard !interruptedDrag, phase == .dragging || phase == .preview else { return }
        guard x.isFinite && y.isFinite else { cancel(); return }
        if abs(y) > 20 && abs(y) > abs(x) { verticalGesture = true }
        guard !verticalGesture, abs(x) > abs(y) * 1.2, abs(x) >= 12 else {
            offset = 0; previewID = nil; phase = .dragging; return
        }
        offset = min(150, max(-150, x))
        previewID = x < 0 ? "offline" : "invest"
        phase = .preview
    }
    /// Release uses actual final displacement, never predicted velocity/end translation.
    public mutating func release(x: Double, y: Double, previews: [ConsequenceTrace]) -> String? {
        guard !interruptedDrag, !verticalGesture, phase == .dragging || phase == .preview else { cancel(); return nil }
        drag(x: x, y: y)
        guard let id = previewID, abs(offset) >= Self.threshold else { cancel(); return nil }
        return request(id, previews: previews)
    }
    public mutating func request(_ id: String, previews: [ConsequenceTrace]) -> String? {
        guard phase != .commitRequested && phase != .saved,
              ["offline", "invest", "ask", "rest"].contains(id) else { return nil }
        previewID = id; offset = 0; cancelled = false
        guard let trace = previews.first(where: { $0.choiceID == id && $0.eventID == "teen-project" && $0.age == 13 }),
              trace.applied else { phase = .preview; return nil }
        pendingID = id; phase = .commitRequested; cancelled = false
        return id
    }
    /// Caller may acknowledge success only after the authoritative GameStore has published a saved trace.
    public mutating func resolved(saved: Bool) {
        guard phase == .commitRequested else { return }
        phase = saved ? .saved : .failed
        pendingID = nil; offset = 0
    }
    public mutating func cancel() {
        guard phase != .commitRequested && phase != .saved else { return }
        interruptedDrag = true; offset = 0; previewID = nil; pendingID = nil; phase = .idle; cancelled = true
    }
}
