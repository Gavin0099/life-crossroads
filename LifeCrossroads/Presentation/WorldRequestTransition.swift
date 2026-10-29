/// A short visual handover between two matching request poses. This reads the
/// existing presentation clock; it never advances a session or implies agreement.
public enum WorldRequestTransition {
    public static func listeningOpacity(frame: LifeWorldFrame, motion: PresentationMotionFrame) -> Double {
        guard frame.moment == .committedOutcome, motion.phase == .committedOutcome,
              WorldCastScene.project(frame)?.kind == .requesting,
              !motion.reduceMotion, motion.phaseElapsedMs.isFinite else { return 0 }
        // Keep the initial gesture, then settle over 120 ms. A shared crop keeps
        // the body, notebook/stool and floor anchored while the hand relaxes.
        // The Round 2 400-ms dissolve left a conspicuous double hand. This is a
        // brief pose handover, not continuous limb animation; paused intermediate
        // frames can still show both hand silhouettes.
        let progress = min(1, max(0, (motion.phaseElapsedMs - 700) / 120))
        return progress * progress * (3 - 2 * progress)
    }
}
