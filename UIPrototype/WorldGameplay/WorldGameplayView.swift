import SwiftUI
import Combine

private enum WorldPalette {
    static let ink = Color(red: 0.13, green: 0.24, blue: 0.24)
    static let paper = Color(red: 0.98, green: 0.96, blue: 0.90)
    static let teal = Color(red: 0.12, green: 0.35, blue: 0.34)
    static let ochre = Color(red: 0.66, green: 0.37, blue: 0.15)
}

struct WorldGameplayView: View {
    @StateObject private var flow: WorldFlow
    @State private var isEventOpen = true
    @State private var isResourcesOpen = false
    @State private var firstScreenHeights: [WorldFirstScreenRegion: CGFloat] = [:]
    @State private var detail: WorldDetail?
    @State private var pendingOptionID: String?
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @AccessibilityFocusState private var reactionFocused: Bool
    private var reduceMotion: Bool { systemReduceMotion || ProcessInfo.processInfo.arguments.contains("-reduce-motion") }
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dynamicTypeSize) private var typeSize
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(fixture: WorldFixture? = nil) {
        var source = fixture ?? .demo
        if ProcessInfo.processInfo.arguments.contains("-missing-route") {
            source.routes.removeValue(forKey: WorldChoiceKey(eventID: source.event.id, optionID: "team"))
        }
        if ProcessInfo.processInfo.arguments.contains("-missing-next") {
            let key = WorldChoiceKey(eventID: source.event.id, optionID: "team")
            source.routes[key]?.beats.removeValue(forKey: .nextDay)
        }
        _flow = StateObject(wrappedValue: WorldFlow(fixture: source))
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        identity.padding(.horizontal, 20).padding(.vertical, 8)
                            .background { measureFirstScreenHeight(.identity) }
                            .id("world-top")
                        if typeSize.isAccessibilitySize && flow.phase == .awaitingChoice && isEventOpen {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(flow.event.title).font(.headline)
                                Button {
                                    openDetail(.decisions)
                                } label: {
                                    Label("前往選擇", systemImage: "arrow.up.right.square")
                                        .frame(maxWidth: .infinity, minHeight: 44)
                                }
                                .buttonStyle(WorldActionStyle())
                                .accessibilityHint("閱讀兩個做法與各自的代價")
                                .accessibilityIdentifier("world-decisions-entry")
                            }.padding(.horizontal, 20).padding(.bottom, 16)
                        }
                        // Fit the world around the actual text and navigation, including wrapped costs.
                        // The cast scales with this height, so a shorter world keeps ears and hands.
                        scene(height: sceneHeight(in: geometry.size.height))
                        eventPanel
                            .background { measureFirstScreenHeight(.event) }
                            .id("world-event")
                            .padding(.horizontal, 14)
                            .padding(.top, -12)
                        resources.padding(.horizontal, 20).padding(.top, 14)
                        trail.padding(.horizontal, 22).padding(.vertical, 18)
                        if typeSize.isAccessibilitySize { navigation }
                        Text("劇本示範 · 狀態與年份為預寫片段")
                            .font(.caption).foregroundStyle(.secondary)
                            .padding(.bottom, 18)
                    }
                }
                .background(WorldPalette.paper)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    if !typeSize.isAccessibilitySize {
                        navigation.background { measureFirstScreenHeight(.navigation) }
                    }
                }
                .onChange(of: flow.snapshot.id) { _, _ in
                    isResourcesOpen = false
                    withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.45)) {
                        proxy.scrollTo(typeSize.isAccessibilitySize && flow.phase != .awaitingChoice ? "world-event" : "world-top", anchor: .top)
                    }
                    if flow.phase == .reacting || flow.phase == .adultReturn { reactionFocused = true }
                }
                .onChange(of: flow.phase) { _, phase in
                    if phase == .blocked {
                        proxy.scrollTo("world-event", anchor: .top)
                    } else if phase == .passingYears {
                        proxy.scrollTo(typeSize.isAccessibilitySize ? "world-event" : "world-top", anchor: .top)
                    }
                }
            }
        }
        .onPreferenceChange(WorldFirstScreenHeightKey.self) { [heights = $firstScreenHeights] value in
            heights.wrappedValue = value
        }
        .foregroundStyle(WorldPalette.ink)
        .preferredColorScheme(.light)
        .sheet(item: $detail, onDismiss: finishPendingChoice) { item in detailSheet(item) }
        .onReceive(ticker) { _ in
            guard scenePhase == .active, detail == nil else { return }
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.65)) { flow.tick() }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active && flow.isPlaying { flow.togglePlayback() }
        }
    }

    private func measureFirstScreenHeight(_ region: WorldFirstScreenRegion) -> some View {
        GeometryReader { area in
            Color.clear.preference(key: WorldFirstScreenHeightKey.self, value: [region: area.size.height])
        }
    }

    private func sceneHeight(in availableHeight: CGFloat) -> CGFloat {
        if typeSize.isAccessibilitySize { return 190 }
        guard flow.phase == .awaitingChoice, isEventOpen,
              let identityHeight = firstScreenHeights[.identity],
              let eventHeight = firstScreenHeights[.event],
              let navigationHeight = firstScreenHeights[.navigation] else {
            return max(170, min(300, availableHeight - 470))
        }
        // The panel overlaps the world by 12pt; leave that much clearance above navigation.
        // Keep a visible world when larger text needs more than one screen, and allow scrolling.
        return max(128, min(300, availableHeight - identityHeight - eventHeight - navigationHeight))
    }

    private var identity: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .firstTextBaseline) {
                Text(flow.phase == .passingYears ? "13 歲的阿澄 · 回憶" : "阿澄 · \(flow.snapshot.age) 歲")
                    .font(typeSize.isAccessibilitySize ? .caption.weight(.bold) : .subheadline.weight(.bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("identity")
                if !typeSize.isAccessibilitySize {
                    Spacer(minLength: 8)
                    Text(String(flow.presentationYear)).font(.caption.monospacedDigit().weight(.bold))
                        .accessibilityIdentifier("year")
                }
            }
            if typeSize.isAccessibilitySize {
                Text(String(flow.presentationYear)).font(.caption2.monospacedDigit())
                    .accessibilityIdentifier("year")
            }
            Text(flow.phase == .passingYears ? "時光過場" : flow.snapshot.timeLabel)
                .font(.caption2).foregroundStyle(WorldPalette.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var resources: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) { isResourcesOpen.toggle() }
            } label: {
                HStack {
                    Label("四項近況", systemImage: "leaf")
                    Spacer(minLength: 8)
                    Image(systemName: isResourcesOpen ? "chevron.up" : "chevron.down")
                }.font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
            }.buttonStyle(.plain)
                .accessibilityValue(isResourcesOpen ? "已展開" : "已收合")
                .accessibilityHint("健康、財務安全、人際關係、技能與能力")
                .accessibilityIdentifier("world-resources")
            if isResourcesOpen {
                VStack(alignment: .leading, spacing: 18) { resourceItems }.padding(.top, 12)
            }
        }
        .padding(12)
        .background(.white.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
    }

    private var resourceItems: some View {
        ForEach(Array(flow.snapshot.resources.enumerated()), id: \.offset) { index, resource in
            VStack(alignment: .leading, spacing: 4) {
                Label(resource.title, systemImage: resource.symbol)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(WorldPalette.teal)
                Text(resource.value).font(.subheadline).fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("resource-\(index)")
            }.frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                .accessibilityIdentifier("world-resource-\(resource.id)")
        }
    }

    private func scene(height: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            if let actingState {
                ActorStageVisual(state: actingState)
            } else {
                GeometryReader { area in
                    let width = area.size.width
                    let castScale = min(1, height / 280)
                    Image("community-workshop").resizable().scaledToFill()
                        .frame(width: width, height: height).clipped()
                        .overlay(Color.orange.opacity(flow.phase == .nextDay ? 0.10 : 0))
                    LinearGradient(colors: [.black.opacity(0.18), .clear, WorldPalette.ink.opacity(0.20)], startPoint: .top, endPoint: .bottom)
                    // Sprite positions belong to presentation, not simulation or outcome calculation.
                    if flow.snapshot.actors.contains(.caregiver) {
                        cast(.caregiver, size: width * 0.32 * castScale, name: "家人在附近")
                            .position(x: width * 0.80, y: height * 0.49)
                    }
                    if flow.snapshot.actors.contains(.friend) {
                        cast(.friend, size: width * 0.46 * castScale, name: "小禾 · 朋友")
                            .rotationEffect(.degrees(isTeam ? -3 : 0))
                            .position(x: width * (isTeam ? 0.27 : 0.18), y: height * 0.60)
                    }
                    if flow.snapshot.actors.contains(.teacher) {
                        cast(.teacher, size: width * 0.46 * castScale, name: "工坊老師")
                            .position(x: width * 0.76, y: height * 0.60)
                            .transition(reduceMotion ? .identity : .move(edge: .trailing).combined(with: .opacity))
                    }
                    cast(flow.snapshot.character == .adult ? .adult : .teen,
                         size: width * 0.55 * castScale, name: flow.phase == .passingYears ? "回憶中的 13 歲" : "阿澄")
                        .rotationEffect(.degrees(flow.phase == .reacting && isTeam ? 3 : 0))
                        .position(x: width * (isTeam ? 0.60 : 0.46), y: height * 0.56)
                        .id(flow.snapshot.character)
                        .transition(.opacity)
                    if flow.snapshot.object != .none {
                        memento.frame(width: 88, height: 66)
                            .position(x: width * (isTeam ? 0.47 : 0.68), y: height * 0.78)
                            .transition(reduceMotion ? .opacity : .scale.combined(with: .opacity))
                    }
                }
                .accessibilityHidden(true)
            }
            if !isEventOpen && !typeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: 6) {
                Label("河岸社區 · 共用工坊", systemImage: "mappin.and.ellipse")
                    .font(.caption.weight(.semibold))
            }
            .padding(11).background(WorldPalette.paper.opacity(0.94), in: RoundedRectangle(cornerRadius: 14))
            .padding(16)
            }
            if flow.phase == .passingYears && !typeSize.isAccessibilitySize {
                timePassage.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(height: height)
        // Atlas/backdrop images can extend beyond their clipped drawing bounds.
        // The scene is descriptive; its pixels must never intercept nearby controls.
        .allowsHitTesting(false)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibleScene)
        .accessibilityIdentifier("living-world")

    }

    // Select only after WorldFlow has accepted the route and applied its authored snapshot.
    // A blocked initial choice keeps the initial acting; later scenes use the existing fallback.
    private var actingState: ActorStageVisualState? {
        guard flow.event.id == "workshop-2027" else { return nil }
        if flow.snapshot.id == "workshop-start", flow.selectedKey == nil { return .initial }
        guard flow.selectedKey?.eventID == flow.event.id else { return nil }
        switch (flow.snapshot.id, flow.selectedKey?.optionID) {
        case ("team-reaction", "team"): return .team
        case ("help-reaction", "help"): return .help
        default: return nil
        }
    }

    private var isTeam: Bool { flow.selectedKey?.optionID == "team" }
    private var sceneCaption: String {
        switch flow.phase {
        case .awaitingChoice: "放學後，還有一點時間。"
        case .reacting: "你的一個決定，讓這裡不太一樣了。"
        case .nextDay: "隔天，昨天留下的東西還在。"
        case .adultReturn, .complete: "多年以後，同一個地方。"
        default: "故事留在這個地方。"
        }
    }
    private var reactionText: String? {
        let text = flow.snapshot.reaction
        return text.isEmpty ? nil : text
    }
    private var timePassage: some View {
        VStack(spacing: 8) {
            Text(String(flow.presentationYear)).font(.largeTitle.monospacedDigit().bold())
            Text("時光略過").font(.headline)
            Text("這段沒有新增劇情紀錄").font(.caption)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(WorldPalette.paper.opacity(0.96), in: RoundedRectangle(cornerRadius: 18))
    }
    private var accessibleScene: String {
        switch flow.snapshot.object {
        case .none: "你、朋友與家人在工坊"
        case .paperBridge: "朋友靠近了 · 紙橋留在桌上"
        case .toolList: flow.snapshot.actors.contains(.teacher) ? "老師來了 · 工具清單留在手邊" : "家人陪你 · 工具清單留在手邊"
        case .bridgeKeepsake: "成年阿澄 · 紙橋成為紀念"
        case .toolKeepsake: "成年阿澄 · 借用清單成為紀念"
        }
    }

    private func cast(_ member: CastMember, size: CGFloat, name: String) -> some View {
        VStack(spacing: -12) {
            CastSprite(member: member).frame(width: size, height: size)
                .shadow(color: .black.opacity(0.15), radius: 3, y: 5)
            if member != .teen && member != .adult && !typeSize.isAccessibilitySize {
                Text(name).font(.caption2.weight(.bold)).padding(.horizontal, 7).padding(.vertical, 3)
                    .background(WorldPalette.paper.opacity(0.92), in: Capsule())
            }
        }
    }

    private var memento: some View {
        ZStack {
            Ellipse().fill(.black.opacity(0.12)).frame(height: 14).offset(y: 24)
            if isTeam {
                PaperBridge().fill(Color(red: 0.99, green: 0.87, blue: 0.59))
                    .overlay(PaperBridge().stroke(WorldPalette.ochre, lineWidth: 2))
                    .rotationEffect(.degrees(-8)).padding(7)
            } else {
                RoundedRectangle(cornerRadius: 4).fill(.white)
                    .overlay(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(0..<3) { _ in HStack(spacing: 5) {
                                Image(systemName: "square").font(.system(size: 8))
                                Rectangle().frame(height: 2)
                            } }
                        }.foregroundStyle(WorldPalette.teal).padding(9)
                    }
                    .rotationEffect(.degrees(9)).padding(9)
            }
        }
    }

    private var eventPanel: some View {
        VStack(alignment: .leading, spacing: flow.phase == .awaitingChoice ? 10 : 14) {
            if flow.phase == .passingYears && typeSize.isAccessibilitySize {
                timePassage
            } else if isEventOpen && flow.selectedKey != nil, let reaction = reactionText {
                HStack(alignment: .center, spacing: 12) {
                    if let actingState {
                        ActorPortrait(emotion: actingState.expression)
                            .frame(width: 76, height: 76).accessibilityHidden(true)
                    }
                    Text(reaction).font(.title3.weight(.medium))
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("scene-reaction")
                        .accessibilityFocused($reactionFocused)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 15))
            }
            HStack(alignment: .top, spacing: 8) {
                if flow.selectedKey == nil || !isEventOpen, let actingState {
                    ActorPortrait(emotion: actingState.expression)
                        .frame(width: 64, height: 64).accessibilityHidden(true)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(accessibleScene)
                        .font(.caption.weight(.bold)).foregroundStyle(WorldPalette.ochre)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("scene-state")
                    if isEventOpen {
                        Text(flow.phase == .awaitingChoice ? flow.event.title : flow.snapshot.title)
                            .font(.title3.weight(.bold))
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityIdentifier("beat-title")
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                Button { isEventOpen.toggle() } label: {
                    Image(systemName: isEventOpen ? "chevron.down" : "chevron.up")
                        .frame(minWidth: 44, minHeight: 44)
                }.accessibilityLabel(isEventOpen ? "收起事件，看看世界" : "展開目前事件")
                    .accessibilityIdentifier("toggle-event")
            }
            if isEventOpen {
                Text(flow.snapshot.narrative).font(.subheadline).lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                if let error = flow.error {
                    Label(error, systemImage: "exclamationmark.triangle")
                        .font(.subheadline).foregroundStyle(.red).accessibilityIdentifier("world-error")
                }
                if flow.phase == .awaitingChoice {
                    if !typeSize.isAccessibilitySize { choices }
                } else {
                    if !flow.snapshot.pending.isEmpty {
                        Label(flow.snapshot.pending, systemImage: "ellipsis.bubble")
                            .font(.caption).lineSpacing(3).foregroundStyle(WorldPalette.teal)
                    }
                    if flow.phase == .complete || flow.phase == .blocked {
                        Button("再走另一條路", systemImage: "arrow.counterclockwise") {
                            flow.restart(); isEventOpen = true
                        }.buttonStyle(WorldActionStyle()).accessibilityIdentifier("world-restart")
                    } else {
                        Button(nextTitle, systemImage: "arrow.right") {
                            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.6)) { flow.advance() }
                        }.buttonStyle(WorldActionStyle()).accessibilityIdentifier("world-next")
                            .disabled(flow.phase == .blocked)
                    }
                    HStack {
                        Button("為什麼？") { openDetail(.reason) }.accessibilityIdentifier("world-reason")
                        Spacer()
                        Button("換個環境呢？") { openDetail(.comparison) }.accessibilityIdentifier("world-comparison")
                    }.font(.caption.weight(.semibold)).padding(.top, 3)
                }
            } else {
                Text(flow.phase == .awaitingChoice ? "時間已停下，等你回來作決定。" : flow.snapshot.title)
                    .font(.subheadline).padding(.bottom, 6)
            }
        }
        .padding(.horizontal, 18).padding(.bottom, 18).padding(.top, 4)
        .background(WorldPalette.paper, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.8), lineWidth: 1))
        .shadow(color: WorldPalette.ink.opacity(0.14), radius: 10, y: 3)
    }

    private var choices: some View {
        VStack(spacing: 10) {
            ForEach(flow.event.options) { option in
                Button {
                    if detail == .decisions {
                        pendingOptionID = option.id
                        detail = nil
                    } else {
                        selectOption(option.id)
                    }
                } label: {
                    HStack(alignment: .top, spacing: 10) {
                        if !typeSize.isAccessibilitySize {
                            Image(systemName: option.symbol).frame(width: 23).padding(.top, 3)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(option.title).font(.headline)
                            Text(option.detail).font(.footnote)
                                .accessibilityIdentifier("world-cost-\(option.id)")
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        if !typeSize.isAccessibilitySize {
                            Image(systemName: "arrow.up.right").font(.caption.bold()).padding(.top, 5)
                        }
                    }.frame(minHeight: 44).padding(12).foregroundStyle(.white)
                        .background(option.id == "team" ? WorldPalette.teal : WorldPalette.ink,
                                    in: RoundedRectangle(cornerRadius: 15))
                }.buttonStyle(.plain).accessibilityIdentifier("world-choice-\(option.id)")
            }
        }
    }

    private var nextTitle: String {
        switch flow.phase {
        case .reacting: "看看隔天留下了什麼"
        case .nextDay: "讓時光走向 22 歲"
        case .passingYears: "往下一年"
        case .adultReturn: "收藏這段回憶"
        default: "繼續故事"
        }
    }

    private var trail: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("時光的足跡").font(.caption.weight(.bold)).tracking(2)
                Spacer()
                Text(flow.phase == .awaitingChoice ? "等待選擇" : flow.isPlaying ? "正在播放" : "已暫停")
                    .font(.caption).accessibilityIdentifier("playback-state")
            }
            HStack(spacing: 0) {
                ForEach(0..<10) { step in
                    VStack(spacing: 6) {
                        Circle().fill(2027 + step <= flow.presentationYear ? WorldPalette.teal : WorldPalette.teal.opacity(0.14))
                            .frame(width: step == 0 || step == 9 ? 10 : 5, height: 10)
                    }.frame(maxWidth: .infinity)
                }
            }.accessibilityElement(children: .ignore).accessibilityLabel("年軸，2027 到 2036，目前 \(flow.presentationYear) 年")
            HStack { Text("13 歲"); Spacer(); Text("22 歲") }.font(.caption2)
            HStack(spacing: 12) {
                Button { flow.togglePlayback() } label: {
                    Label(flow.isPlaying ? "暫停" : "播放片段", systemImage: flow.isPlaying ? "pause.fill" : "play.fill")
                }.accessibilityIdentifier("world-play")
                    .disabled([.awaitingChoice, .complete, .blocked].contains(flow.phase))
                Spacer()
                Button { flow.cycleSpeed() } label: { Text(flow.speed == .normal ? "1×" : "3×").monospacedDigit() }
                    .accessibilityLabel(flow.speed == .normal ? "播放速度 1 倍" : "播放速度 3 倍")
                    .accessibilityIdentifier("world-speed")
            }.font(.subheadline.weight(.semibold)).buttonStyle(.bordered).tint(WorldPalette.teal)
        }
    }

    private var navigation: some View {
        Group {
            if typeSize.isAccessibilitySize {
                VStack(spacing: 4) { navigationItems }
            } else {
                HStack(spacing: 0) { navigationItems }
            }
        }
        .padding(.vertical, 6).background(WorldPalette.paper.opacity(0.98))
        .overlay(alignment: .top) { Rectangle().fill(WorldPalette.teal.opacity(0.15)).frame(height: 1) }
    }
    private var navigationItems: some View {
        Group {
            navButton(.records, title: "人生紀錄", icon: "book.closed")
            navButton(.people, title: "家人與朋友", icon: "person.2")
            navButton(.map, title: "人生地圖", icon: "point.topleft.down.to.point.bottomright.curvepath")
        }
    }
    private func navButton(_ item: WorldDetail, title: String, icon: String) -> some View {
        Button { openDetail(item) } label: {
            if typeSize.isAccessibilitySize {
                Label(title, systemImage: icon).font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .padding(.horizontal, 20).padding(.vertical, 8)
            } else {
                VStack(spacing: 5) { Image(systemName: icon).font(.body); Text(title).font(.caption2) }
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
        }.accessibilityIdentifier("world-\(item.rawValue)")
    }
    private func openDetail(_ item: WorldDetail) {
        if flow.isPlaying { flow.togglePlayback() }
        detail = item
    }

    private func selectOption(_ optionID: String) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
            flow.select(optionID: optionID)
        }
    }

    private func finishPendingChoice() {
        guard let optionID = pendingOptionID else { return }
        pendingOptionID = nil
        // Wait until the world is visible before its reaction focus and scroll.
        // Cancelling the sheet never sets an option or advances the story.
        selectOption(optionID)
    }

    private func detailSheet(_ item: WorldDetail) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    if item == .decisions {
                        choices
                        Text(flow.event.title).font(.headline)
                    } else if item == .people {
                        Text(flow.snapshot.character == .adult ? "留在回憶裡的人" : "有人和你一起生活").font(.title2.bold())
                        ForEach(flow.snapshot.relationships) { relationship in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(relationship.name).font(.headline)
                                Text(relationship.detail).font(.body)
                            }
                            Divider()
                        }
                    } else if item == .reason {
                        Text("這段故事如何安排").font(.title2.bold())
                        ForEach(flow.route?.reasons ?? []) { reason in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(reason.title).font(.headline)
                                Text(reason.detail)
                            }
                        }
                        if let source = flow.route?.evidenceLabel {
                            Text(source).font(.caption).foregroundStyle(.secondary)
                        } else { Text("目前沒有原因資料。") }
                        Text("這是預寫劇本的說明，尚未接入正式引擎的原因紀錄。")
                            .font(.caption).foregroundStyle(.secondary)
                    } else if item == .comparison {
                        Text("同一選擇，支持可以不同").font(.title2.bold())
                        if let comparison = flow.route?.comparison {
                            Text("你選了：" + comparison.choiceTitle).font(.headline)
                            ForEach(comparison.contexts) { context in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(context.title).font(.headline)
                                    Text(context.detail)
                                }
                            }
                            Text(comparison.limitation).font(.caption)
                            Text(comparison.evidenceLabel).font(.caption).foregroundStyle(.secondary)
                        } else { Text("目前沒有比較資料。") }
                        Text("情境示範，不代表任何國家的平均家庭，也不是實際模擬結果。")
                            .font(.caption).foregroundStyle(.secondary).accessibilityIdentifier("comparison-end")
                    } else {
                        Text(item == .map ? "你走過的地方" : "留下來的小事").font(.title2.bold())
                        if flow.history.isEmpty {
                            Text("這段人生還沒有選擇紀錄。")
                        }
                        ForEach(flow.history) { record in
                            HStack(alignment: .top, spacing: 14) {
                                Image(systemName: "circle.inset.filled").foregroundStyle(WorldPalette.ochre)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(record.year) · \(record.age) 歲").font(.caption.bold()).foregroundStyle(WorldPalette.ochre)
                                    Text(record.title).font(.headline)
                                    Text(record.summary).font(.subheadline)
                                }
                            }
                        }
                        if item == .map {
                            Text("童年 · 青少年 · 青年 · 中年 · 晚年").font(.caption)
                            Text("本片段只展示 13 歲與 22 歲的已寫故事；其他階段尚未接入。")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }.padding(24).frame(maxWidth: .infinity, alignment: .leading)
            }.background(WorldPalette.paper)
                .accessibilityIdentifier("world-detail-scroll")
                .navigationTitle(item.title).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) {
                    Button("回到生活") { detail = nil }.accessibilityIdentifier("close-world-detail")
                } }
        }.tint(WorldPalette.teal).presentationDragIndicator(.visible)
            .presentationDetents([.large])
    }
}

// Acting v1.1 is presentation only. These catalogs drive the game and the native catalog.
enum ActorEmotion: String, CaseIterable, Identifiable, Sendable {
    case neutral, thinking, hopeful, tired
    var id: String { rawValue }
    var title: String {
        switch self {
        case .neutral: "平靜"
        case .thinking: "思考"
        case .hopeful: "有了主意"
        case .tired: "有點累"
        }
    }
    // Manifest: original 1254 × 1254, four exact 627 × 627 cells.
    var cell: CGPoint {
        switch self {
        case .neutral: CGPoint(x: 0, y: 0)
        case .thinking: CGPoint(x: 1, y: 0)
        case .hopeful: CGPoint(x: 0, y: 1)
        case .tired: CGPoint(x: 1, y: 1)
        }
    }
    static let assetID = "va-otter-emotions-v1"
}

enum ActorPose: String, CaseIterable, Identifiable, Sendable {
    case idle, collaborating, asking
    var id: String { rawValue }
    var title: String {
        switch self {
        case .idle: "選擇前 · 看著材料"
        case .collaborating: "和小禾一起試做"
        case .asking: "向老師詢問借用"
        }
    }
    var assetID: String {
        switch self {
        case .idle: "world-cast"
        case .collaborating: "va-friend-worktable-v2"
        case .asking: "va-teacher-worktable-v2"
        }
    }
    var previewState: ActorStageVisualState {
        switch self {
        case .idle: .initial
        case .collaborating: .team
        case .asking: .help
        }
    }
}

struct ActorStageVisualState: Equatable, Sendable {
    let expression: ActorEmotion
    let pose: ActorPose
    let optionID: String?
    let propID: String

    static let initial = Self(expression: .thinking, pose: .idle, optionID: nil, propID: "paper-bridge-materials")
    static let team = Self(expression: .hopeful, pose: .collaborating, optionID: "team", propID: "paper-bridge-prototype")
    static let help = Self(expression: .neutral, pose: .asking, optionID: "help", propID: "borrow-tools-list")

    var description: String {
        switch pose {
        case .idle: "阿澄正在思考，與小禾和家人在工坊看著紙橋材料，還沒選擇做法。"
        case .collaborating: "阿澄有了主意，與小禾一起扶住試做的紙橋，仍需修改。"
        case .asking: "阿澄平靜地向老師詢問，和小禾整理待借用清單，尚未取得工具。"
        }
    }
    var accessibilityJSON: String {
        actingJSON([
            "event_id": "bridge", "source_event_id": "workshop-2027", "character_id": "otter-acheng",
            "option_id": optionID.map { $0 as Any } ?? NSNull(),
            "expression_id": expression.rawValue, "pose_id": pose.rawValue, "prop_id": propID,
            "asset_ids": [pose.assetID, ActorEmotion.assetID] + (pose == .idle ? ["va-materials-table-v1"] : [])
        ])
    }
    static var catalogJSON: String {
        actingJSON([
            "schema_version": "1.1", "event_id": "bridge", "source_event_id": "workshop-2027",
            "character_id": "otter-acheng",
            "expression_catalog": ActorEmotion.allCases.map(\.rawValue),
            "pose_catalog": ActorPose.allCases.map(\.rawValue)
        ])
    }
}

private func actingJSON(_ value: [String: Any]) -> String {
    guard let data = try? JSONSerialization.data(withJSONObject: value, options: [.sortedKeys]),
          let text = String(data: data, encoding: .utf8) else { return "{}" }
    return text
}

private struct ActorPortrait: View {
    let emotion: ActorEmotion
    var body: some View {
        // Crop in memory; source pixels stay intact and accessibility bounds
        // describe the visible cell instead of an oversized, offset image.
        if let atlas = UIImage(named: ActorEmotion.assetID)?.cgImage,
           let cell = atlas.cropping(to: CGRect(x: emotion.cell.x * 627,
                                               y: emotion.cell.y * 627,
                                               width: 627, height: 627)) {
            Image(uiImage: UIImage(cgImage: cell)).resizable().scaledToFit()
        } else {
            Image(systemName: "person.crop.square.badge.exclamationmark")
                .accessibilityLabel("角色圖片無法載入")
        }
    }
}

private struct ActorStageVisual: View {
    let state: ActorStageVisualState
    var body: some View {
        GeometryReader { box in
            ZStack {
                Image("community-workshop").resizable().scaledToFill()
                    .frame(width: box.size.width, height: box.size.height).clipped()
                ActorPoseVisual(pose: state.pose)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(state.description)
        .accessibilityValue(ProcessInfo.processInfo.arguments.contains("-acting-proof")
            ? state.accessibilityJSON : state.expression.title)
        .accessibilityIdentifier("world-actor")
    }
}

private struct ActorPoseVisual: View {
    let pose: ActorPose
    var body: some View {
        GeometryReader { box in
            if pose == .idle {
                let width = box.size.width
                let height = box.size.height
                let scale = min(width / 393, height / 270)
                CastSprite(member: .caregiver).frame(width: 116 * scale, height: 150 * scale)
                    .position(x: width * 0.82, y: height * 0.47)
                CastSprite(member: .friend).frame(width: 132 * scale, height: 190 * scale)
                    .position(x: width * 0.19, y: height * 0.48)
                CastSprite(member: .teen).frame(width: 180 * scale, height: 225 * scale)
                    .position(x: width * 0.52, y: height * 0.47)
                Image("va-materials-table-v1").resizable().scaledToFit()
                    .frame(width: width * 0.88, height: height * 0.48)
                    .position(x: width * 0.47, y: height * 0.76)
            } else {
                // Each supplied image already contains hands, actors, prop and worktable.
                // Fit the complete foreground; never stack the old cast or floating prop over it.
                Image(pose.assetID).resizable().scaledToFit()
                    .frame(width: box.size.width - 16, height: box.size.height - 24)
                    .position(x: box.size.width / 2, y: box.size.height / 2 - 4)
            }
        }.accessibilityHidden(true)
    }
}

struct ActingContactSheet: View {
    var body: some View {
        GeometryReader { box in
            let poseHeight = max(98, min(158, (box.size.height - 270) / 3))
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("阿澄 · 工坊演出").font(.title3.bold())
                        .accessibilityValue(ProcessInfo.processInfo.arguments.contains("-acting-proof")
                            ? ActorStageVisualState.catalogJSON : "四種表情、三種姿勢")
                        .accessibilityIdentifier("acting-catalog")
                    HStack(spacing: 8) {
                        ForEach(ActorEmotion.allCases) { emotion in
                            VStack(spacing: 3) {
                                ActorPortrait(emotion: emotion).aspectRatio(1, contentMode: .fit)
                                Text(emotion.title).font(.caption2)
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(emotion.title)
                            .accessibilityIdentifier("acting-expression-\(emotion.id)")
                        }
                    }
                    ForEach(ActorPose.allCases) { pose in
                        ActorStageVisual(state: pose.previewState)
                            .frame(height: poseHeight)
                            .overlay(alignment: .topLeading) {
                                Text(pose.title).font(.caption2.bold())
                                    .padding(5).background(WorldPalette.paper.opacity(0.94), in: RoundedRectangle(cornerRadius: 6))
                                    .padding(6).accessibilityHidden(true)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .accessibilityIdentifier("acting-pose-\(pose.id)")
                    }
                    Text("候選素材 · 試做與詢問都還沒有保證結果")
                        .font(.caption2).fixedSize(horizontal: false, vertical: true)
                }.padding(12)
            }
        }
        .background(WorldPalette.paper).foregroundStyle(WorldPalette.ink)
        .preferredColorScheme(.light)
    }
}

private enum WorldFirstScreenRegion: Hashable, Sendable {
    case identity, event, navigation
}

private struct WorldFirstScreenHeightKey: PreferenceKey {
    static var defaultValue: [WorldFirstScreenRegion: CGFloat] { [:] }
    static func reduce(value: inout [WorldFirstScreenRegion: CGFloat], nextValue: () -> [WorldFirstScreenRegion: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { _, latest in latest })
    }
}

private enum WorldDetail: String, Identifiable {
    case records, people, map, reason, comparison, decisions
    var id: String { rawValue }
    var title: String {
        switch self {
        case .records: "人生紀錄"
        case .people: "家人與朋友"
        case .map: "人生地圖"
        case .reason: "原因"
        case .comparison: "環境比較"
        case .decisions: "選擇做法"
        }
    }
}
private enum CastMember: Int {
    case teen, adult, friend, caregiver, teacher
    // Measured alpha-safe source rectangles; the generator did not keep a uniform grid.
    var sourceRect: CGRect {
        switch self {
        case .teen: CGRect(x: 100, y: 65, width: 345, height: 470)
        case .adult: CGRect(x: 580, y: 20, width: 330, height: 535)
        case .friend: CGRect(x: 180, y: 537, width: 265, height: 509)
        case .caregiver: CGRect(x: 580, y: 560, width: 375, height: 510)
        case .teacher: CGRect(x: 150, y: 1046, width: 320, height: 488)
        }
    }
}
private struct CastSprite: View {
    let member: CastMember
    var body: some View {
        GeometryReader { box in
            let rect = member.sourceRect
            let scale = min(box.size.width / rect.width, box.size.height / rect.height)
            ZStack(alignment: .topLeading) {
                Image("world-cast").resizable()
                    .frame(width: 1024 * scale, height: 1536 * scale)
                    .offset(x: -rect.minX * scale, y: -rect.minY * scale)
            }
            .frame(width: rect.width * scale, height: rect.height * scale, alignment: .topLeading)
            .clipped()
            .frame(width: box.size.width, height: box.size.height)
        }.clipped()
    }
}
private struct PaperBridge: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: 0, y: rect.height))
            p.addLine(to: CGPoint(x: rect.width * 0.22, y: rect.height * 0.25))
            p.addLine(to: CGPoint(x: rect.width * 0.78, y: rect.height * 0.25))
            p.addLine(to: CGPoint(x: rect.width, y: rect.height))
            p.addLine(to: CGPoint(x: rect.width * 0.77, y: rect.height * 0.88))
            p.addLine(to: CGPoint(x: rect.width * 0.68, y: rect.height * 0.52))
            p.addLine(to: CGPoint(x: rect.width * 0.32, y: rect.height * 0.52))
            p.addLine(to: CGPoint(x: rect.width * 0.23, y: rect.height * 0.88))
            p.closeSubpath()
        }
    }
}
private struct WorldActionStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline).frame(maxWidth: .infinity).padding(15)
            .foregroundStyle(.white).background(WorldPalette.teal.opacity(configuration.isPressed ? 0.7 : 1),
                                                in: RoundedRectangle(cornerRadius: 14))
    }
}

#Preview("生活世界 · 13 歲") { WorldGameplayView() }
#Preview("小螢幕・大字") { WorldGameplayView().dynamicTypeSize(.accessibility3) }
