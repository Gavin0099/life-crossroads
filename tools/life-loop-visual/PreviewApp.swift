import SwiftUI

/// Standalone review fixture. No Domain, playback controller, or gameplay commands.
@main struct VisualFixtureApp: App {
    var body: some Scene { WindowGroup { VisualFixtureScreen() } }
}

private struct VisualFixtureScreen: View {
    @State private var age = 8
    private let reduced = ProcessInfo.processInfo.arguments.contains("-fixture-reduced")
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Visual 場景檢查，非正式遊戲").font(.headline)
                    LifeWorldScenePreview(model: .init(age: age, elapsedMs: 1250,
                        frozen: true, reducedMotion: reduced, committedOutcome: age == 13,
                        outcomeElapsedMs: 450))
                        .frame(height: max(300, geometry.size.height * 0.52))
                    Text("\(age)歲 · \(reduced ? "減少動態取樣" : "固定時間取樣")")
                        .accessibilityIdentifier("fixture-status")
                    Button("切換人生階段預覽") { age = age == 8 ? 13 : age == 13 ? 39 : 8 }
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("fixture-stage")
                    Text("這裡只檢查場景大小與文字；正式事件、選項、成本及後果尚待 Gameplay 接入。")
                        .font(.body).fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("fixture-boundary")
                }.padding(12)
            }.background(Color(red: 0.96, green: 0.94, blue: 0.88))
        }
    }
}
