import SwiftUI
import LifeDomain
import LifeData
import LifePresentation
import LifePersistence

/// Standalone review fixture. No Domain, playback controller, or gameplay commands.
@main struct VisualFixtureApp: App {
    var body: some Scene { WindowGroup {
        if ProcessInfo.processInfo.arguments.contains("-formal") { FormalWorldScreen() }
        else { VisualFixtureScreen() }
    } }
}

private struct VisualFixtureScreen: View {
    @State private var age = 8
    private let reduced = ProcessInfo.processInfo.arguments.contains("-fixture-reduced")
    var body: some View {
        GeometryReader { geometry in
          VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("場景預覽（非正式遊戲）").font(.caption)
                    LifeWorldScenePreview(model: .init(age: age, elapsedMs: 1250,
                        frozen: true, reducedMotion: reduced, committedOutcome: age == 13,
                        outcomeElapsedMs: 450), showsNotes: false)
                        .frame(height: max(300, geometry.size.height * 0.52))
                    Text("\(age)歲 · \(reduced ? "減少動態取樣" : "固定時間取樣")")
                        .accessibilityIdentifier("fixture-status")
                    Text("這裡只檢查場景大小與文字；正式事件、選項、成本及後果尚待 Gameplay 接入。")
                        .font(.body).fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("fixture-boundary")
                }.padding(12)
            }
                Button("切換年齡") { age = age == 8 ? 13 : age == 13 ? 39 : 8 }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("fixture-stage")
                    .padding(8).frame(maxWidth: .infinity)
                    .background(Color(red: 0.96, green: 0.94, blue: 0.88))
          }.background(Color(red: 0.96, green: 0.94, blue: 0.88))
        }
    }
}

private struct FormalWorldScreen: View {
    @State private var route = 0
    @State private var inspecting = false
    @State private var frame: LifeWorldFrame?
    @State private var failed = false
    @State private var inspectedChange: WorldChangeProjection?
    private let modes = ["offline", "rest", "ask", "adult", "child"]
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("正式 DTO 隔離檢查，尚未接入主流程").font(.caption)
                    if let frame {
                        LifeWorldScene(frame: frame,
                            motion: .init(elapsedMs: 1250, frozen: true,
                                reduceMotion: ProcessInfo.processInfo.arguments.contains("-fixture-reduced"),
                                phase: frame.moment, phaseToken: modes[route], phaseElapsedMs: 450))
                            .frame(height: 300)
                        ForEach(Array(frame.worldChanges.enumerated()), id: \.offset) { index, change in
                            Button { inspectedChange = change; inspecting = true } label: {
                                Label(change.caption, systemImage: LifeWorldScene.tokenSymbol(change))
                                    .fixedSize(horizontal: false, vertical: true)
                            }.buttonStyle(.plain).accessibilityIdentifier("world-change-\(index)")
                        }
                    } else if failed { Text("來源載入失敗").accessibilityIdentifier("formal-error") }
                    else { Text("讀取已保存的測試人生") }
                    Text(modes[route]).font(.caption).accessibilityIdentifier("formal-route-status")
                    Text(inspecting ? "來源檢視開啟" : "來源檢視關閉").font(.caption)
                        .accessibilityIdentifier("inspection-status")
                }.padding(12)
            }
            Button("切換路線") { route = (route + 1) % modes.count }
                .buttonStyle(.borderedProminent).padding(8).accessibilityIdentifier("formal-route")
        }.background(Color(red: 0.96, green: 0.94, blue: 0.88))
            .sheet(isPresented: Binding(get: { inspectedChange != nil }, set: { if !$0 { inspectedChange = nil } }),
                onDismiss: { inspecting = false }) {
                if let change = inspectedChange {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(change.caption).fixedSize(horizontal: false, vertical: true)
                            Text("來源：\(change.sourceAge)歲的選擇紀錄。")
                            Button("回到生活場景") { inspectedChange = nil }.buttonStyle(.borderedProminent)
                        }.padding(20)
                    }
                }
            }
            .task(id: route) {
                do { frame = try savedFrame(modes[route]); failed = false }
                catch { frame = nil; failed = true }
            }
    }
    private func savedFrame(_ mode: String) throws -> LifeWorldFrame {
        let catalog = try StatisticsRepository.bundled()
        var session = try LifeSession.start(catalog: catalog, countryCode: "JPN", householdID: "jpn-1", seed: 0)
        let target = mode == "child" ? 8 : mode == "adult" ? 39 : 13
        while session.state.age < target {
            try session.choose("rest", catalog: catalog)
            try session.continueLife(catalog: catalog)
        }
        if target == 13 { try session.choose(mode, catalog: catalog) }
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("VisualFixture", isDirectory: true)
        let repository = SaveRepository(fileURL: directory.appendingPathComponent("\(mode)-save.json"))
        try repository.save(.single(session), catalog: catalog)
        guard let restored = try repository.load(catalog: catalog)?.activeSession, restored == session else {
            throw NSError(domain: "FixtureRoundTrip", code: 1)
        }
        let frame = try WorldMomentProjector.project(session: restored, catalog: catalog)
        let evidence: [String: Any] = ["scope": "isolated saved-session renderer, not formal GameStore or playback",
            "contractCommit": "7040802846d8829ca969d98ff7023d51fb11913d", "mode": mode,
            "saveRoundTripEqual": true, "age": frame.age, "moment": frame.moment.rawValue,
            "actors": frame.actors.map { ["personID": $0.personID, "role": $0.role] },
            "changes": frame.worldChanges.map { ["kind": $0.kind.rawValue, "caption": $0.caption,
                "sourceEventID": $0.sourceEventID, "sourceChoiceID": $0.sourceChoiceID,
                "sourceAge": $0.sourceAge, "isOccurred": $0.isOccurred,
                "symbol": LifeWorldScene.tokenSymbol($0)] as [String: Any] },
            "session": try JSONSerialization.jsonObject(with: JSONEncoder().encode(restored))]
        try JSONSerialization.data(withJSONObject: evidence, options: [.sortedKeys, .prettyPrinted])
            .write(to: directory.appendingPathComponent("\(mode)-source.json"), options: .atomic)
        return frame
    }
}
