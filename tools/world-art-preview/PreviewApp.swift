import SwiftUI
import LifeDomain
import LifeData
import LifePresentation

/// Isolated review harness. Uses genuine saved-story projection, never shipped as game flow.
@main struct WorldArtPreviewApp: App {
    var body: some Scene { WindowGroup { WorldArtPreview() } }
}

struct WorldArtPreview: View {
    @State private var selection = "idle"
    private let args = ProcessInfo.processInfo.arguments
    private let modes = ["idle", "walking", "interacting", "teen", "elder", "seeking", "paused"]
    var body: some View {
        VStack(spacing: 0) {
            Text("生活場景 · 獨立視覺預覽").font(.caption.bold()).padding(8)
            if let state = try? makeState(selection) {
                LifeWorldScene(state: state)
            } else {
                ContentUnavailableView("預覽資料無法載入", systemImage: "exclamationmark.triangle")
            }
            Menu {
                ForEach(modes, id: \.self) { mode in
                    Button(mode) { selection = mode }.accessibilityIdentifier("preview-\(mode)")
                }
            } label: { Label("切換場景預覽", systemImage: "rectangle.stack") }
                .buttonStyle(.bordered).padding(8).accessibilityIdentifier("preview-selector")
            Text(selection).font(.caption).accessibilityIdentifier("preview-mode")
        }.background(Color(red: 0.94, green: 0.91, blue: 0.83))
    }

    private func makeState(_ mode: String) throws -> LifeWorldViewState {
        let catalog = try StatisticsRepository.bundled()
        var session = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        var playback = LifePlayback()
        if mode == "teen" || mode == "seeking" {
            for _ in 0..<3 {
                try session.choose("rest", catalog: catalog)
                try session.continueLife(catalog: catalog)
            }
            try session.choose(mode == "seeking" ? "ask" : "offline", catalog: catalog)
        } else if mode == "elder" {
            for _ in 0..<13 {
                try session.choose("rest", catalog: catalog)
                try session.continueLife(catalog: catalog)
            }
        } else if mode == "interacting" {
            try session.choose("rest", catalog: catalog)
            try session.continueLife(catalog: catalog)
            try session.choose("invest", catalog: catalog)
        }
        playback.restore(session)
        if mode == "walking" || mode == "paused" {
            try playback.travel(from: 4, to: session.state.age)
            for _ in 0..<16 { playback.pulse() }
            if mode == "paused" { playback.pause() }
        }
        return LifeWorldViewState(session: session, playback: playback,
            event: try? session.event(catalog: catalog))
    }
}

#Preview("大型生活場景") { WorldArtPreview() }
#Preview("最大文字") { WorldArtPreview().dynamicTypeSize(.accessibility5) }
