import SwiftUI
import LifeDomain
import LifeData
import LifePresentation

/// One-event PoC. Drag state never becomes a saved consequence by itself.
struct DecisionSwipeCard: View {
    let event: DecisionSkeleton
    let world: LifeWorldFrame
    let motion: PresentationMotionFrame
    let country: String
    let previews: [ConsequenceTrace]
    let context: String
    let reduceMotion: Bool
    let submit: (String) -> Bool
    @State private var model = DecisionCardModel()
    @State private var details = false
    @State private var dragInProgress = false
    @GestureState private var touching = false
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dynamicTypeSize) private var typeSize

    private var selected: ConsequenceTrace? { previews.first { $0.choiceID == model.previewID } }
    private var previewCaption: String {
        if model.phase == .failed { return "尚未保存；可以再試一次。" }
        if model.cancelled { return "已取消，還沒有做決定。" }
        guard let selected else { return "左右拖卡，看到「放開就選」再決定。" }
        if !selected.applied { return selected.unavailableReasons.joined(separator: "\n") }
        return abs(model.offset) >= DecisionCardModel.threshold ? "放開就選這條路；拖回中間可取消。" : "繼續拖動可選擇；現在放開會取消。"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack { Text("沐沐 · 13歲").font(.headline); Spacer(); Text(country).font(.subheadline) }
                Text("共用想像場景，非各國實景").font(.caption).foregroundStyle(StoryPalette.secondaryInk)
                Text("第一件作品，想從哪裡開始？").font(.title3.bold())
                card
                Text(previewCaption).font(.subheadline).foregroundStyle(StoryPalette.secondaryInk)
                    .accessibilityIdentifier("swipeStatus")
                if typeSize.isAccessibilitySize {
                    ForEach(["offline", "invest", "ask", "rest"], id: \.self) { action($0) }
                } else {
                    HStack(spacing: 10) { action("offline"); action("invest") }
                    HStack(spacing: 10) { action("ask"); action("rest") }
                }
                Button { details = true } label: {
                    Label("看看處境與準備", systemImage: "info.circle")
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading).contentShape(Rectangle())
                }.buttonStyle(.plain).foregroundStyle(StoryPalette.forest).accessibilityIdentifier("swipeDetails")
                if previews.contains(where: { !$0.environmentGaps.isEmpty }) {
                    Text("部分環境成本還不知道；不是零成本。").font(.caption)
                }
            }.padding(16).frame(maxWidth: 620).frame(maxWidth: .infinity)
        }
        .transaction { $0.animation = nil }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { model.cancel(); dragInProgress = false }
        }
        .onChange(of: touching) { _, active in
            if !active && dragInProgress { model.cancel(); dragInProgress = false }
        }
        .onDisappear { model.cancel() }
        .sheet(isPresented: $details) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text(context)
                        ForEach(event.choices, id: \.id) { choice in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(choice.title).font(.headline)
                                if let trace = previews.first(where: { $0.choiceID == choice.id }) {
                                    Text("預計時間\(trace.finalCost.time)、精力\(trace.finalCost.energy)、材料\(trace.finalCost.materials)。尚未使用。")
                                    if choice.requiresDigitalAccess {
                                        Text(BirthStory.creationContext(preview: trace))
                                            .accessibilityIdentifier("swipeDigitalContext.\(choice.id)")
                                    }
                                    if !trace.applied { Text(trace.unavailableReasons.joined(separator: "\n")) }
                                } else { Text("目前無法確認這個安排，暫時不能選擇。") }
                            }
                        }
                    }.padding(20)
                }.navigationTitle("這次的安排").navigationBarTitleDisplayMode(.inline)
                    .toolbar { Button("回到卡片") { details = false }.accessibilityIdentifier("closeSwipeDetails") }
            }.foregroundStyle(StoryPalette.ink).tint(StoryPalette.forest)
        }
    }

    private var card: some View {
        VStack(spacing: 0) {
            LifeWorldScene(frame: world, motion: motion)
                .frame(height: typeSize.isAccessibilitySize ? 120 : 180)
            Text(selected?.choiceTitle ?? "和樹老師聊起了創作，你想試試……")
                .font(.headline).frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                .padding(12).foregroundStyle(StoryPalette.ink).background(StoryPalette.page)
                .accessibilityIdentifier("swipeIntent")
        }
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(StoryPalette.forest, lineWidth: model.previewID == nil ? 1 : 3))
        .rotationEffect(.degrees(reduceMotion ? 0 : model.offset / 22))
        .offset(x: reduceMotion ? 0 : model.offset * 0.45)
        .contentShape(Rectangle())
        .simultaneousGesture(DragGesture(minimumDistance: 18)
            .updating($touching) { _, active, _ in active = true }
            .onChanged { value in
                guard scenePhase == .active else { return }
                if !dragInProgress { model.beginDrag(); dragInProgress = true }
                model.drag(x: value.translation.width, y: value.translation.height)
            }.onEnded { value in
                dragInProgress = false
                guard scenePhase == .active else { model.cancel(); return }
                if let id = model.release(x: value.translation.width, y: value.translation.height, previews: previews) {
                    model.resolved(saved: submit(id))
                }
            })
        .accessibilityAction(named: "選擇紙本練習") { choose("offline") }
        .accessibilityAction(named: "選擇線上創作") { choose("invest") }
        // Do not assign a container identifier: SwiftUI can propagate it over child buttons/labels.
    }

    private func action(_ id: String) -> some View {
        let trace = previews.first { $0.choiceID == id }
        let title = event.choices.first { $0.id == id }?.title ?? id
        return VStack(alignment: .leading, spacing: 4) {
            Button { choose(id) } label: {
                Text(shortTitle(id)).font(.subheadline.bold())
                    .frame(maxWidth: .infinity, minHeight: 44).padding(.horizontal, 8).padding(.vertical, 4)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .foregroundStyle(StoryPalette.ink)
            .background(StoryPalette.page, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(StoryPalette.forest, lineWidth: 1))
            .disabled(trace?.applied != true || model.phase == .commitRequested || model.phase == .saved)
            .accessibilityLabel(title).accessibilityHint("選擇後會嘗試保存這個決定")
            .accessibilityIdentifier("swipeChoice.\(id)")
            if trace?.applied != true {
                Text(trace?.unavailableReasons.joined(separator: "\n") ?? "暫時無法確認可行性")
                    .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
            }
        }.frame(maxWidth: .infinity, alignment: .topLeading)
    }
    private func choose(_ id: String) {
        guard scenePhase == .active, let choice = model.request(id, previews: previews) else { return }
        model.resolved(saved: submit(choice))
    }
    private func shortTitle(_ id: String) -> String {
        switch id {
        case "offline": "← 借紙本練習"
        case "invest": "線上創作 →"
        case "ask": "向樹老師求助"
        default: "先休息一下"
        }
    }
}
