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
    @State private var detail: WorldDetail?
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
                        identity.padding(.horizontal, 20).padding(.top, 10).id("world-top")
                        resources.padding(.horizontal, 20).padding(.vertical, 14)
                        scene(height: geometry.size.width < 380 ? 300 : 350)
                        eventPanel
                            .padding(.horizontal, 14)
                            .padding(.top, -28)
                        trail.padding(.horizontal, 22).padding(.vertical, 18)
                        Text("劇本示範 · 狀態與年份為預寫片段")
                            .font(.caption).foregroundStyle(.secondary)
                            .padding(.bottom, 18)
                    }
                }
                .background(WorldPalette.paper)
                .safeAreaInset(edge: .bottom, spacing: 0) { navigation }
                .onChange(of: flow.snapshot.id) { _, _ in
                    withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.45)) {
                        proxy.scrollTo("world-top", anchor: .top)
                    }
                    if flow.phase == .reacting || flow.phase == .adultReturn { reactionFocused = true }
                }
            }
        }
        .foregroundStyle(WorldPalette.ink)
        .preferredColorScheme(.light)
        .sheet(item: $detail) { item in detailSheet(item) }
        .onReceive(ticker) { _ in
            guard scenePhase == .active, detail == nil else { return }
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.65)) { flow.tick() }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active && flow.isPlaying { flow.togglePlayback() }
        }
    }

    private var identity: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text("人生岔路").font(.caption.weight(.semibold)).tracking(4)
                    .foregroundStyle(WorldPalette.ochre)
                Text(flow.phase == .passingYears ? "13 歲的阿澄 · 回憶" : "阿澄 · \(flow.snapshot.age) 歲")
                    .font(.title2.weight(.bold)).accessibilityIdentifier("identity")
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(flow.presentationYear)).font(.title3.monospacedDigit().weight(.bold))
                    .accessibilityIdentifier("year")
                Text(flow.phase == .passingYears ? "時光過場" : flow.snapshot.timeLabel)
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    private var resources: some View {
        Group {
            if !typeSize.isAccessibilitySize {
                HStack(alignment: .top, spacing: 10) { resourceItems }
            } else { LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 12) {
                resourceItems
            } }
        }
    }

    private var resourceItems: some View {
        ForEach(Array(flow.snapshot.resources.enumerated()), id: \.offset) { index, resource in
            VStack(alignment: .leading, spacing: 4) {
                Label(resource.title, systemImage: resource.symbol)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(WorldPalette.teal)
                Text(resource.value).font(.caption2).fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("resource-\(index)")
            }.frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
        }
    }

    private func scene(height: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { area in
                let width = area.size.width
                Image("community-workshop").resizable().scaledToFill()
                    .frame(width: width, height: height).clipped()
                    .overlay(Color.orange.opacity(flow.phase == .nextDay ? 0.10 : 0))
                LinearGradient(colors: [.black.opacity(0.18), .clear, WorldPalette.ink.opacity(0.20)], startPoint: .top, endPoint: .bottom)
                // Sprite positions belong to presentation, not simulation or outcome calculation.
                if flow.snapshot.actors.contains(.caregiver) {
                    cast(.caregiver, size: width * 0.32, name: "家人在附近")
                        .position(x: width * 0.80, y: height * 0.49)
                }
                if flow.snapshot.actors.contains(.friend) {
                    cast(.friend, size: width * 0.46, name: "小禾 · 朋友")
                        .rotationEffect(.degrees(isTeam ? -3 : 0))
                        .position(x: width * (isTeam ? 0.27 : 0.18), y: height * 0.60)
                }
                if flow.snapshot.actors.contains(.teacher) {
                    cast(.teacher, size: width * 0.46, name: "工坊老師")
                        .position(x: width * 0.76, y: height * 0.60)
                        .transition(reduceMotion ? .identity : .move(edge: .trailing).combined(with: .opacity))
                }
                cast(flow.snapshot.character == .adult ? .adult : .teen,
                     size: width * 0.55, name: flow.phase == .passingYears ? "回憶中的 13 歲" : "阿澄")
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
            if typeSize.isAccessibilitySize || !isEventOpen {
            VStack(alignment: .leading, spacing: 6) {
                Label("河岸社區 · 共用工坊", systemImage: "mappin.and.ellipse")
                    .font(.caption.weight(.semibold))
            }
            .padding(11).background(WorldPalette.paper.opacity(0.94), in: RoundedRectangle(cornerRadius: 14))
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge).padding(16)
            }
            if flow.phase == .passingYears {
                VStack(spacing: 8) {
                    Text(String(flow.presentationYear)).font(.largeTitle.monospacedDigit().bold())
                    Text("時光略過").font(.headline)
                    Text("這段沒有新增劇情紀錄").font(.caption)
                }
                .padding(22).background(WorldPalette.paper.opacity(0.96), in: RoundedRectangle(cornerRadius: 18))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if isEventOpen && !typeSize.isAccessibilitySize, let reaction = reactionText {
                Text(reaction).font(.subheadline.weight(.medium))
                    .padding(12).background(.white.opacity(0.97), in: RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 20).padding(.top, 10)
                    .frame(maxWidth: .infinity)
                    .accessibilityIdentifier("scene-reaction")
                    .accessibilityFocused($reactionFocused)
            }
        }
        .frame(height: height)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("living-world")

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
            if member != .teen && member != .adult {
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
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(accessibleScene)
                    .font(.caption.weight(.bold)).foregroundStyle(WorldPalette.ochre)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                    .accessibilityIdentifier("scene-state")
                Spacer()
                Button { isEventOpen.toggle() } label: {
                    Image(systemName: isEventOpen ? "chevron.down" : "chevron.up")
                        .frame(width: 44, height: 44)
                }.accessibilityLabel(isEventOpen ? "收起事件，看看世界" : "展開目前事件")
                    .accessibilityIdentifier("toggle-event")
            }.padding(.bottom, -12)
            if isEventOpen {
                if typeSize.isAccessibilitySize, let reaction = reactionText {
                    Text(reaction).font(.title3.weight(.medium))
                        .accessibilityIdentifier("scene-reaction").accessibilityFocused($reactionFocused)
                }
                Text(flow.snapshot.title).font(.title2.weight(.bold))
                    .accessibilityIdentifier("beat-title")
                Text(flow.snapshot.narrative).font(.subheadline).lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                if let error = flow.error {
                    Label(error, systemImage: "exclamationmark.triangle")
                        .font(.subheadline).foregroundStyle(.red).accessibilityIdentifier("world-error")
                }
                if flow.phase == .awaitingChoice {
                    ForEach(flow.event.options) { option in
                        Button {
                            withAnimation(reduceMotion ? nil : .spring(response: 0.6, dampingFraction: 0.8)) {
                                flow.select(optionID: option.id)
                            }
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: option.id == "team" ? "person.2.fill" : "hand.raised.fingers.spread.fill")
                                    .frame(width: 23).padding(.top, 3)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(option.title).font(.headline)
                                    Text(option.detail).font(.caption).opacity(0.85)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "arrow.up.right").font(.caption.bold()).padding(.top, 5)
                            }.padding(14).foregroundStyle(.white)
                                .background(option.id == "team" ? WorldPalette.teal : WorldPalette.ink,
                                            in: RoundedRectangle(cornerRadius: 15))
                        }.buttonStyle(.plain).accessibilityIdentifier("world-choice-\(option.id)")
                    }
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
        HStack(spacing: 0) {
            navButton(.records, title: "人生紀錄", icon: "book.closed")
            navButton(.people, title: "家人與朋友", icon: "person.2")
            navButton(.map, title: "人生地圖", icon: "point.topleft.down.to.point.bottomright.curvepath")
        }
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .padding(.vertical, 6).background(WorldPalette.paper.opacity(0.98))
        .overlay(alignment: .top) { Rectangle().fill(WorldPalette.teal.opacity(0.15)).frame(height: 1) }
    }
    private func navButton(_ item: WorldDetail, title: String, icon: String) -> some View {
        Button { openDetail(item) } label: {
            VStack(spacing: 5) { Image(systemName: icon).font(.body); Text(title).font(.caption2) }
                .frame(maxWidth: .infinity, minHeight: 44)
        }.accessibilityIdentifier("world-\(item.rawValue)")
    }
    private func openDetail(_ item: WorldDetail) {
        if flow.isPlaying { flow.togglePlayback() }
        detail = item
    }

    private func detailSheet(_ item: WorldDetail) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    if item == .people {
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
                .navigationTitle(item.title).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) {
                    Button("回到生活") { detail = nil }.accessibilityIdentifier("close-world-detail")
                } }
        }.tint(WorldPalette.teal).presentationDragIndicator(.visible)
    }
}

private enum WorldDetail: String, Identifiable {
    case records, people, map, reason, comparison
    var id: String { rawValue }
    var title: String {
        switch self {
        case .records: "人生紀錄"
        case .people: "家人與朋友"
        case .map: "人生地圖"
        case .reason: "原因"
        case .comparison: "環境比較"
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
