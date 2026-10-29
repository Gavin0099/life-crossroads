import SwiftUI
import LifeDomain
import LifeData
import LifePresentation

/// A single scene owns both the decision and its published outcome. Local drag state is never saved.
struct DecisionSwipeCard: View {
    let event: DecisionSkeleton
    let world: LifeWorldFrame
    let motion: PresentationMotionFrame
    let country: String
    let previews: [ConsequenceTrace]
    let context: String
    let reduceMotion: Bool
    let outcome: ConsequenceTrace?
    let submit: (String) -> Bool
    let continueLife: () -> Void
    let home: () -> Void
    let useOriginal: () -> Void
    let sources: () -> Void
    @State private var model = DecisionCardModel()
    @State private var details = false
    @State private var dragInProgress = false
    @GestureState private var touching = false
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOver

    private var buttonLayout: Bool { typeSize.isAccessibilitySize || voiceOver }
    private var selected: ConsequenceTrace? { previews.first { $0.choiceID == model.previewID } }
    private var savedMoment: ProjectMoment? { outcome.flatMap(ProjectMoment.init) }
    private var previewCaption: String {
        if model.phase == .failed { return "尚未保存；可以再試一次。" }
        if model.cancelled { return "已取消，還沒有做決定。" }
        guard let selected else { return "左右拖動，看看不同的路" }
        if !selected.applied { return selected.unavailableReasons.joined(separator: "\n") }
        return abs(model.offset) >= DecisionCardModel.threshold ? "放開就選 · 拖回可取消" : "放開取消 · 繼續拖動選擇"
    }

    var body: some View {
        GeometryReader { viewport in
            Group {
                if buttonLayout {
                    ScrollView {
                        VStack(spacing: 12) {
                            hud
                            stage
                            if outcome == nil {
                                ForEach(["offline", "invest", "ask", "rest"], id: \.self) { fullAction($0) }
                            }
                            footer
                        }.padding(12)
                    }
                } else {
                    VStack(spacing: 8) {
                        hud.frame(height: 44)
                        stage.frame(maxWidth: .infinity, maxHeight: .infinity)
                        footer.frame(height: 52)
                    }.padding(.horizontal, 12).padding(.top, 4).padding(.bottom, 8)
                }
            }
            .frame(width: viewport.size.width, height: viewport.size.height)
            .background(StoryPalette.page.overlay(StoryPalette.forest.opacity(0.08)).ignoresSafeArea())
        }
        .transaction { $0.animation = nil }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { model.cancel(); dragInProgress = false }
        }
        .onChange(of: touching) { _, active in
            if !active && dragInProgress { model.cancel(); dragInProgress = false }
        }
        .onDisappear { model.cancel() }
        .sheet(isPresented: $details) { detailsSheet }
    }

    private var hud: some View {
        HStack(spacing: 4) {
            Button(action: home) { Image(systemName: "house").font(.system(size: 20)).frame(width: 44, height: 44).contentShape(Rectangle()) }
                .accessibilityLabel("回首頁，保留目前進度").accessibilityIdentifier("immersiveHome")
            Spacer(minLength: 0)
            Text("13歲 · \(country)").font(.subheadline.weight(.semibold)).lineLimit(buttonLayout ? nil : 1)
                .fixedSize(horizontal: false, vertical: buttonLayout)
                .accessibilityIdentifier("immersiveHUD")
            Spacer(minLength: 0)
            Menu {
                Button("原本的選項", action: useOriginal).accessibilityIdentifier("decisionUI.standard")
                Button("說明與資料", action: sources)
            } label: { Image(systemName: "ellipsis").font(.system(size: 20)).frame(width: 44, height: 44).contentShape(Rectangle()) }
                .accessibilityLabel("遊戲選單").accessibilityIdentifier("decisionUIMenu")
        }.buttonStyle(.plain).foregroundStyle(StoryPalette.ink)
    }

    private var stage: some View {
        VStack(spacing: 0) {
            Group {
                if let outcome, let savedMoment {
                    Text(savedMoment.caption).accessibilityIdentifier("chosenAction").accessibilityValue(outcome.choiceID)
                } else {
                    Text(model.previewID.map(shortTitle) ?? "你想從哪裡開始創作？")
                        .accessibilityIdentifier("swipeIntent")
                }
            }
            .font(.system(.title3, design: .serif).weight(.semibold))
            .multilineTextAlignment(.center).lineLimit(buttonLayout ? nil : 2)
            .fixedSize(horizontal: false, vertical: buttonLayout)
            .frame(maxWidth: .infinity, minHeight: 52).padding(.horizontal, 14).padding(.vertical, 4)
            .foregroundStyle(StoryPalette.ink).background(StoryPalette.page)
            LifeWorldScene(frame: world, motion: motion, portraitCard: true)
                .frame(height: buttonLayout ? 220 : nil)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if outcome == nil && !buttonLayout {
                VStack(spacing: 3) {
                    HStack {
                        Text("← 紙本練習")
                        Spacer()
                        Text("線上創作 →")
                    }.font(.subheadline.weight(.semibold)).accessibilityHidden(true)
                    Text(previewCaption).font(.caption).lineLimit(buttonLayout ? nil : 2)
                        .accessibilityIdentifier("swipeStatus")
                }.padding(.horizontal, 14).padding(.vertical, 8)
                    .foregroundStyle(StoryPalette.ink).background(StoryPalette.page)
            }
        }
        .background(StoryPalette.page)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(StoryPalette.forest.opacity(0.55), lineWidth: model.previewID == nil ? 1 : 3))
        .shadow(color: StoryPalette.sceneInk.opacity(0.14), radius: 8, y: 4)
        .rotationEffect(.degrees(reduceMotion || outcome != nil ? 0 : model.offset / 22))
        .offset(x: reduceMotion || outcome != nil ? 0 : model.offset * 0.45)
        .contentShape(Rectangle())
        .simultaneousGesture(DragGesture(minimumDistance: 18)
            .updating($touching) { _, active, _ in active = true }
            .onChanged { value in
                guard scenePhase == .active, outcome == nil else { return }
                if !dragInProgress { model.beginDrag(); dragInProgress = true }
                model.drag(x: value.translation.width, y: value.translation.height)
            }.onEnded { value in
                dragInProgress = false
                guard scenePhase == .active, outcome == nil else { model.cancel(); return }
                if let id = model.release(x: value.translation.width, y: value.translation.height, previews: previews) {
                    model.resolved(saved: submit(id))
                }
            })
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("immersiveCard")
    }

    private var footer: some View {
        let layout = buttonLayout ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12)) : AnyLayout(HStackLayout(spacing: 4))
        return layout {
            if outcome == nil {
                if !buttonLayout {
                    compactAction("ask", title: "求助", symbol: "bubble.left")
                    compactAction("rest", title: "休息", symbol: "leaf")
                }
                Button { model.cancel(); details = true } label: {
                    Label(buttonLayout ? "處境與準備" : "全部行動", systemImage: "ellipsis.circle")
                        .font(.subheadline.weight(.medium)).frame(maxWidth: .infinity, minHeight: 44).contentShape(Rectangle())
                }.accessibilityIdentifier("swipeDetails")
            } else {
                Button { details = true } label: {
                    Label("回看", systemImage: "text.alignleft").font(.subheadline).frame(minWidth: 60, minHeight: 44)
                }.accessibilityIdentifier("swipeDetails")
                if !buttonLayout { Spacer(minLength: 6) }
                Button(action: continueLife) {
                    Label("繼續生活", systemImage: "arrow.right").font(.headline)
                        .frame(minWidth: 150, minHeight: 44).contentShape(Rectangle())
                }.accessibilityIdentifier("continueLife")
            }
        }.buttonStyle(.plain).foregroundStyle(StoryPalette.ink)
    }

    private func compactAction(_ id: String, title: String, symbol: String) -> some View {
        Button { choose(id) } label: {
            Label(title, systemImage: symbol).font(.subheadline.weight(.medium))
                .frame(maxWidth: .infinity, minHeight: 44).contentShape(Rectangle())
        }.disabled(!canChoose(id)).accessibilityLabel(choiceTitle(id))
            .accessibilityIdentifier("swipeChoice.\(id)")
    }
    private func fullAction(_ id: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Button { choose(id) } label: {
                Text(choiceTitle(id)).font(.headline).multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading).padding(10).contentShape(Rectangle())
            }.buttonStyle(.plain).background(StoryPalette.page, in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(StoryPalette.forest.opacity(0.5)))
                .disabled(!canChoose(id)).accessibilityIdentifier("swipeChoice.\(id)")
            if let trace = previews.first(where: { $0.choiceID == id }), !trace.applied {
                Text(trace.unavailableReasons.joined(separator: "\n")).font(.subheadline)
            }
        }
    }
    private var detailsSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("共用想像場景，非各國實景").font(.caption)
                    if let outcome, let savedMoment {
                        Text(outcome.choiceTitle).font(.headline)
                        Text(savedMoment.caption)
                        ForEach(Array(outcome.effectSteps.enumerated()), id: \.offset) { _, step in Text(step.explanation) }
                        if !outcome.environmentGaps.isEmpty { Text(outcome.environmentGaps.joined(separator: "\n")) }
                    } else {
                        Text(context)
                        ForEach(event.choices, id: \.id) { choice in
                            VStack(alignment: .leading, spacing: 6) {
                                fullAction(choice.id)
                                if let trace = previews.first(where: { $0.choiceID == choice.id }) {
                                    Text("預計時間\(trace.finalCost.time)、精力\(trace.finalCost.energy)、材料\(trace.finalCost.materials)。尚未使用。")
                                    if choice.requiresDigitalAccess {
                                        Text(BirthStory.creationContext(preview: trace)).accessibilityIdentifier("swipeDigitalContext.\(choice.id)")
                                    }
                                    if !trace.environmentGaps.isEmpty { Text("部分環境成本還不知道；不是零成本。") }
                                } else { Text("目前無法確認這個安排，暫時不能選擇。") }
                            }
                        }
                    }
                }.padding(20)
            }.accessibilityIdentifier("swipeActionsSheet").navigationTitle(outcome == nil ? "所有的路" : "這次選擇之後").navigationBarTitleDisplayMode(.inline)
                .toolbar { Button("回到卡片") { details = false }.accessibilityIdentifier("closeSwipeDetails") }
        }.foregroundStyle(StoryPalette.ink).tint(StoryPalette.forest)
    }
    private func canChoose(_ id: String) -> Bool {
        outcome == nil && previews.first { $0.choiceID == id }?.applied == true && model.phase != .commitRequested && model.phase != .saved
    }
    private func choose(_ id: String) {
        guard scenePhase == .active, outcome == nil, let choice = model.request(id, previews: previews) else { return }
        let saved = submit(choice)
        model.resolved(saved: saved)
        if saved { details = false }
    }
    private func choiceTitle(_ id: String) -> String { event.choices.first { $0.id == id }?.title ?? id }
    private func shortTitle(_ id: String) -> String {
        switch id {
        case "offline": "借紙本圖解，一起練習"
        case "invest": "用線上圖解，試著創作"
        case "ask": "向樹老師說出需要"
        default: "先把時間留給自己"
        }
    }
}
