import SwiftUI

enum PlayPalette {
    static let background = Color(red: 0.045, green: 0.075, blue: 0.105)
    static let panel = Color(red: 0.10, green: 0.15, blue: 0.19)
    static let muted = Color(red: 0.72, green: 0.79, blue: 0.82)
    static let accent = Color(red: 0.72, green: 0.91, blue: 0.60)
    static let ink = Color(red: 0.06, green: 0.11, blue: 0.13)
}

struct EventFirstView: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @StateObject private var flow: EventFirstFlow
    @State private var detail: DetailPage?
    let studyDirection: String?

    init(flow: EventFirstFlow? = nil, studyDirection: String? = nil) {
        _flow = StateObject(wrappedValue: flow ?? UIFixtures.makeFlow(arguments: ProcessInfo.processInfo.arguments))
        self.studyDirection = studyDirection ?? (ProcessInfo.processInfo.arguments.contains("-study-novel") ? "novel" : ProcessInfo.processInfo.arguments.contains("-study-map") ? "map" : nil)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let event = flow.event {
                    StageHeader(event: event, progress: flow.progressLabel,
                                state: studyDirection == nil ? flow.stateLabel : "不可操作線框") { detail = .profile }
                    if let studyDirection {
                        structureStudy(studyDirection, event: event)
                    } else {
                        switch flow.screen {
                        case .event: eventPage(event)
                        case .outcome: outcomePage
                        case .reason: reasonPage
                        case .comparison: comparisonPage
                        case .review: reviewPage
                        }
                    }
                } else {
                    EmptyPanel(title: "這裡還沒有待選事件", detail: "取得事件後，這段人生才會繼續。", symbol: "tray")
                        .accessibilityIdentifier("emptyEvents")
                }
            }
            .padding(20).frame(maxWidth: 600, alignment: .leading).frame(maxWidth: .infinity)
        }
        .id(flow.screen)
        .background(PlayPalette.background.ignoresSafeArea())
        .foregroundStyle(.white)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if flow.event != nil && studyDirection == nil {
                footer
            }
        }
        .sheet(item: $detail) { page in detailSheet(page) }
        .preferredColorScheme(.dark)
    }

    private func eventPage(_ event: EventViewDTO) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            EventHeroCard(event: event)
            HStack(alignment: .firstTextBaseline) {
                Text("你會怎麼做？").font(.title2.bold()).accessibilityAddTraits(.isHeader)
                Spacer(minLength: 4)
                if !typeSize.isAccessibilitySize {
                    Text("選一個做法").font(.caption).foregroundStyle(PlayPalette.accent)
                }
            }
            if event.options.isEmpty {
                EmptyPanel(title: "選項尚未準備好", detail: "先留在這個岔路，不代替你做選擇。", symbol: "arrow.triangle.branch")
                    .accessibilityIdentifier("emptyOptions")
            }
            ForEach(event.options) { option in
                ChoiceCard(option: option) { flow.select(option.id) }
            }
            if let continuation = flow.continuation {
                panel {
                    Label("上個岔路留下的線索", systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                        .font(.caption).foregroundStyle(PlayPalette.accent)
                    Text(continuation.title).font(.headline).accessibilityIdentifier("continuationTitle")
                    Text(continuation.reminder).font(.subheadline)
                    Text("已發生的經驗會留下來；下一個決定仍由你來做。")
                        .font(.caption).foregroundStyle(PlayPalette.muted)
                }
            }
            if let message = flow.message {
                Label(message, systemImage: "exclamationmark.bubble")
                    .font(.body).padding(16).background(PlayPalette.panel, in: RoundedRectangle(cornerRadius: 14))
                    .accessibilityIdentifier("missingOutcome")
            }
            StatusStrip(statuses: flow.displayedStatuses, heading: flow.statusHeading)
            HStack {
                auxiliaryButton("人物與家庭", id: "profile", symbol: "person.crop.rectangle") { detail = .profile }
                Spacer()
                auxiliaryButton("人生地圖", id: "lifeMap", symbol: "point.topleft.down.to.point.bottomright.curvepath") { detail = .map }
            }
        }
    }

    private var outcomePage: some View {
        VStack(alignment: .leading, spacing: 18) {
            pageHeading("這次選擇之後", flow.outcome?.title ?? "等待後果紀錄")
            if let chosen = flow.chosen, let outcome = flow.outcome {
                if let feedback = outcome.feedback {
                    CharacterReactionCard(name: flow.event?.characterName ?? "", artworkID: flow.event?.artworkID,
                                          feedback: feedback)
                }
                OutcomeCard(chosen: chosen.title, outcome: outcome)
                if let feedback = outcome.feedback {
                    panel {
                        Label("這次留下的改變", systemImage: "arrow.triangle.branch").font(.headline)
                        ForEach(feedback.changes) { change in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(change.label).font(.caption).foregroundStyle(PlayPalette.accent)
                                Text("原先：\(change.before)").font(.subheadline).foregroundStyle(PlayPalette.muted)
                                Text("現在：\(change.after)").font(.headline)
                            }.accessibilityElement(children: .combine)
                        }
                        Text("質性示範敘事；尚未接入真實狀態變化。")
                            .font(.caption).foregroundStyle(PlayPalette.muted)
                    }
                }
                if !outcome.pending.isEmpty {
                    panel {
                        Label("故事的下一條線 · 還沒發生", systemImage: "clock").font(.headline)
                        ForEach(outcome.pending, id: \.self) { Text($0).foregroundStyle(PlayPalette.muted) }
                        Text("可能的後續不等於已經發生的後果。")
                            .font(.caption).foregroundStyle(PlayPalette.muted)
                    }
                }
            }
        }
    }

    private var reasonPage: some View {
        VStack(alignment: .leading, spacing: 18) {
            pageHeading("把結果和解釋分開", "為什麼會這樣？")
            Text("後果是發生的事；原因需要有依據。這裡的內容是示範資料。")
                .foregroundStyle(PlayPalette.muted)
            if let factors = flow.outcome?.factors, !factors.isEmpty {
                ForEach(factors) { ReasonCard(factor: $0) }
            } else {
                EmptyPanel(title: "目前沒有原因紀錄", detail: "你仍可回看已選項目和後果；這裡不補上推測。", symbol: "questionmark.folder")
                    .accessibilityIdentifier("missingTrace")
            }
            auxiliaryButton("回看後果", id: "backOutcome", symbol: "arrow.uturn.backward") { flow.showOutcome() }
        }
    }

    private var comparisonPage: some View {
        VStack(alignment: .leading, spacing: 18) {
            pageHeading("同一選擇，不同條件", "環境改變了什麼？")
            if let comparison = flow.comparison {
                panel {
                    Text(flow.chosen?.title ?? "").font(.headline)
                    Label("固定：\(comparison.fixedConditions)", systemImage: "equal.circle")
                    Label("改變：\(comparison.changedConditions)", systemImage: "slider.horizontal.3")
                }
                ForEach(comparison.contexts) { context in
                    panel {
                        Text(context.label).font(.headline).accessibilityAddTraits(.isHeader)
                        Text(context.conditions).foregroundStyle(PlayPalette.muted)
                        Divider()
                        Label(context.cost, systemImage: "clock")
                        Label(context.support, systemImage: "person.2")
                    }
                }
                Text("比較條件，沒有國家排名").font(.headline).foregroundStyle(PlayPalette.accent)
                Text(comparison.limitation).font(.subheadline).foregroundStyle(PlayPalette.muted)
                    .fixedSize(horizontal: false, vertical: true).accessibilityIdentifier("comparisonLastLine")
            } else {
                EmptyPanel(title: "此事件尚無可比環境資料", detail: "不補上虛構差值。你可以繼續這段人生。", symbol: "rectangle.slash")
            }
        }
    }

    private var reviewPage: some View {
        VStack(alignment: .leading, spacing: 18) {
            pageHeading("兩個岔路，留下了什麼？", "你的選擇，有跡可循。")
            Text("這次原型的兩個事件已結束。正式遊戲仍會從童年走到晚年。")
                .foregroundStyle(PlayPalette.muted)
            historyList
            Text("沒有單一人生總分，也不以財富或壽命評定這段人生。")
                .font(.subheadline).foregroundStyle(PlayPalette.muted)
        }
    }

    private var historyList: some View {
        Group {
            if flow.history.isEmpty {
                EmptyPanel(title: "尚未留下選擇紀錄", detail: "完成一個事件後，這裡才會出現紀錄。", symbol: "book.closed")
            } else {
                ForEach(flow.map.nodes) { entry in
                    panel {
                        Text(entry.age).font(.caption).foregroundStyle(PlayPalette.accent)
                        Text(entry.eventTitle).font(.headline)
                        Text("你選了：\(entry.choiceTitle)")
                        ForEach(entry.facts, id: \.self) { Text($0).font(.subheadline).foregroundStyle(PlayPalette.muted) }
                    }
                }
            }
        }
    }

    private var footer: some View {
        FooterActions(primary: primaryAction, secondary: secondaryAction)
    }

    private var primaryAction: PlayAction? {
        switch flow.screen {
        case .event: return nil
        case .outcome, .reason, .comparison:
            return .init(title: flow.nextActionLabel, id: "continueLife", action: flow.advance)
        case .review: return .init(title: "重新體驗原型", id: "restart", action: flow.restart)
        }
    }

    private var secondaryAction: PlayAction? {
        switch flow.screen {
        case .outcome: return .init(title: "查看原因", id: "showReason", action: flow.showReason)
        case .reason: return .init(title: "比較環境", id: "showComparison", action: flow.showComparison)
        case .comparison: return .init(title: "回看後果", id: "backOutcome", action: flow.showOutcome)
        default: return nil
        }
    }

    private func detailSheet(_ initial: DetailPage) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Picker("人生資料", selection: Binding(get: { detail ?? initial }, set: { detail = $0 })) {
                        ForEach(DetailPage.allCases) { Text($0.rawValue).tag($0) }
                    }.pickerStyle(.menu)
                    switch detail ?? initial {
                    case .profile:
                        panel {
                            Text("阿澄的起點").font(.title2.bold())
                            Text("示範化身：水獺；外觀不決定國籍或能力。")
                            Text("與家人同住，材料預算有限，朋友與老師可提供支持。")
                            Text("這是虛構家庭，不代表任何國家平均。")
                        }
                        StatusStrip(statuses: flow.displayedStatuses, heading: flow.statusHeading)
                    case .map:
                        pageHeading("五階段完整人生", "人生地圖")
                        Text("你走過的岔路").font(.title2.bold()).accessibilityAddTraits(.isHeader)
                        historyList
                        Text("人生階段").font(.title2.bold())
                        ForEach(flow.map.stages, id: \.self) { stage in
                            HStack {
                                Image(systemName: stage == flow.map.currentStage ? "location.circle.fill" : "circle")
                                Text(stage)
                                if stage == flow.map.currentStage { Text("目前").foregroundStyle(PlayPalette.accent) }
                            }.font(.headline).padding(14)
                        }
                        Text("這輪只示範 13 與 15 歲兩個事件，不代表完整人生已完成。")
                            .foregroundStyle(PlayPalette.muted)
                    case .history:
                        pageHeading("只記錄已做的選擇", "人生紀錄")
                        historyList
                    }
                    Text("介面原型・示範資料・尚未接入真實人生引擎")
                        .font(.caption).foregroundStyle(PlayPalette.muted)
                }.padding(20)
            }
            .background(PlayPalette.background).foregroundStyle(.white)
            .navigationTitle(initial.rawValue).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("回到遊戲") { detail = nil }.accessibilityIdentifier("closeDetails") } }
        }.preferredColorScheme(.dark)
    }

    private func structureStudy(_ direction: String, event: EventViewDTO) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("不可操作線框 · 僅供結構比較", systemImage: "square.dashed")
                .font(.headline).foregroundStyle(PlayPalette.accent).accessibilityIdentifier("staticStudyNotice")
            Text("結構研究草圖・\(direction == "novel" ? "章節敘事型" : "人生時間軸型")")
                .font(.caption).foregroundStyle(PlayPalette.accent)
            if direction == "novel" {
                Image("workshop").resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 18))
                Text("第二章 · 一個新點子").font(.caption)
                Text(event.title).font(.largeTitle.bold())
                Text(event.narrative)
                Text("阿澄：先從哪裡開始呢？").padding(20).background(PlayPalette.panel)
                ForEach(event.options.prefix(2)) { option in
                    panel {
                        Text("選項位置示意 · 不可點擊").font(.caption).foregroundStyle(PlayPalette.muted)
                        Text(option.title).font(.headline)
                        Text(option.cost).font(.subheadline)
                    }
                }
            } else {
                Text("沿著人生，找到下一個岔路。").font(.title.bold())
                ForEach(["童年 · 與世界相遇", "青少年 · 紙橋挑戰", "青年 · 尚未抵達", "中年 · 尚未抵達", "晚年 · 回顧這一生"], id: \.self) { stage in
                    Label(stage, systemImage: "circle.inset.filled").padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading).background(PlayPalette.panel, in: RoundedRectangle(cornerRadius: 14))
                }
                EventHeroCard(event: event)
                Text("岔路入口位置示意 · 不可點擊").font(.subheadline).foregroundStyle(PlayPalette.muted)
            }
            Text("比較焦點用的靜態結構研究；可點流程集中在事件主導首頁。")
                .font(.caption).foregroundStyle(PlayPalette.muted)
        }
    }

    private func pageHeading(_ eyebrow: String, _ title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(eyebrow).font(.caption).foregroundStyle(PlayPalette.accent)
            Text(title).font(.largeTitle.bold()).accessibilityAddTraits(.isHeader)
        }
    }

    private func auxiliaryButton(_ title: String, id: String, symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) { Label(title, systemImage: symbol).font(.subheadline).frame(minHeight: 44) }
            .buttonStyle(.plain).foregroundStyle(PlayPalette.muted).accessibilityIdentifier(id)
    }

    private func panel<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12, content: content).padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(PlayPalette.panel, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct StageHeader: View {
    let event: EventViewDTO
    let progress: String
    let state: String
    let showDetails: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(event.characterName)・\(event.age)").font(.title2.bold())
                Spacer(minLength: 4)
                Button(action: showDetails) { Image(systemName: "ellipsis.circle").font(.title2).frame(width: 44, height: 44) }
                    .buttonStyle(.plain).accessibilityLabel("查看人物與人生資料").accessibilityIdentifier("details")
            }
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) { metadata }
                VStack(alignment: .leading, spacing: 6) { metadata }
            }
            Text("介面原型・示範資料").font(.caption2).foregroundStyle(PlayPalette.muted)
        }
    }
    private var metadata: some View {
        Group {
            Text("\(event.year) / \(event.stage)")
            Text("\(progress)・\(state)").foregroundStyle(PlayPalette.accent).accessibilityIdentifier("flowState")
        }.font(.caption)
    }
}

struct CharacterReactionCard: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var appeared = false
    let name: String
    let artworkID: String?
    let feedback: ChoiceFeedbackDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let artworkID, !typeSize.isAccessibilitySize {
                Image(artworkID).resizable().scaledToFit().frame(maxWidth: .infinity, maxHeight: 170)
                    .accessibilityHidden(true)
            }
            Label("\(name)的心聲", systemImage: feedback.symbol).font(.caption.bold())
                .foregroundStyle(PlayPalette.accent)
            Text("「\(feedback.reaction)」").font(.title3.bold()).lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true).accessibilityIdentifier("characterReaction")
        }.padding(18).frame(maxWidth: .infinity, alignment: .leading)
            .background(PlayPalette.panel, in: RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .leading) { RoundedRectangle(cornerRadius: 2).fill(PlayPalette.accent).frame(width: 3).padding(.vertical, 20) }
            .opacity(appeared || reduceMotion ? 1 : 0)
            .onAppear { withAnimation(reduceMotion ? nil : .easeOut(duration: 0.25)) { appeared = true } }
    }
}

struct EventHeroCard: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    let event: EventViewDTO
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Text(event.title).font(.title2.bold()).accessibilityAddTraits(.isHeader)
                if let image = event.artworkID, !typeSize.isAccessibilitySize {
                    Spacer(minLength: 0)
                    Image(image).resizable().scaledToFit().frame(width: 88, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .accessibilityLabel("水獺與朋友在工作桌前嘗試做紙橋")
                }
            }
            Text(event.narrative).font(.body).foregroundStyle(PlayPalette.muted).lineSpacing(3)
        }
    }
}

struct ChoiceCard: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    let option: OptionViewDTO
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Text(option.title).font(.headline)
                    if !typeSize.isAccessibilitySize {
                        Spacer(minLength: 4)
                        Image(systemName: option.isAvailable ? "arrow.up.right" : "lock").accessibilityHidden(true)
                    }
                }
                Text(option.cost).font(.subheadline.bold())
                Text("支持：\(option.support) · 留意：\(option.uncertainty)")
                    .font(.caption).lineSpacing(2)
                if let reason = option.unavailableReason {
                    Text(reason).font(.caption.bold())
                }
            }
            .padding(16).frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .foregroundStyle(option.isAvailable ? PlayPalette.ink : PlayPalette.muted)
            .background(option.isAvailable ? Color.white : PlayPalette.panel, in: RoundedRectangle(cornerRadius: 17))
            .overlay(RoundedRectangle(cornerRadius: 17).stroke(option.isAvailable ? PlayPalette.accent : PlayPalette.muted.opacity(0.4), lineWidth: 2))
        }.buttonStyle(.plain).disabled(!option.isAvailable).accessibilityIdentifier("choice-\(option.id)")
    }
}

struct OutcomeCard: View {
    let chosen: String
    let outcome: OutcomeViewDTO
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("你選了：\(chosen)").font(.subheadline).foregroundStyle(PlayPalette.muted)
            Label("已發生的後果", systemImage: "checkmark.circle").font(.headline)
            ForEach(outcome.immediate, id: \.self) { Text($0).font(.body).lineSpacing(4) }
            Text(outcome.evidenceLabel).font(.caption).foregroundStyle(PlayPalette.muted)
        }.padding(20).frame(maxWidth: .infinity, alignment: .leading)
            .background(PlayPalette.panel, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct ReasonCard: View {
    let factor: TraceFactorViewDTO
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(factor.kind).font(.headline).foregroundStyle(PlayPalette.accent)
            Text(factor.explanation)
            Text(factor.evidenceLabel).font(.caption).foregroundStyle(PlayPalette.muted)
        }.padding(18).frame(maxWidth: .infinity, alignment: .leading)
            .background(PlayPalette.panel, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct StatusStrip: View {
    let statuses: [StatusViewDTO]
    var heading = "目前的你"
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(heading).font(.caption).foregroundStyle(PlayPalette.muted)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 145), alignment: .leading)], alignment: .leading, spacing: 14) {
                ForEach(statuses) { status in
                    VStack(alignment: .leading, spacing: 6) {
                        Label(status.label, systemImage: status.symbol).font(.caption)
                        Text(status.value).font(.caption).foregroundStyle(PlayPalette.muted)
                    }.accessibilityElement(children: .combine)
                }
            }
        }.padding(.top, 6)
    }
}

struct EmptyPanel: View {
    let title: String
    let detail: String
    let symbol: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: symbol).font(.headline)
            Text(detail).foregroundStyle(PlayPalette.muted)
        }.padding(20).frame(maxWidth: .infinity, alignment: .leading)
            .background(PlayPalette.panel, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct PlayAction {
    let title: String
    let id: String
    let action: () -> Void
}

struct FooterActions: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    let primary: PlayAction?
    let secondary: PlayAction?
    var body: some View {
        if let primary {
            VStack(spacing: 4) {
                Button(action: primary.action) {
                    Label(primary.title, systemImage: "arrow.right").font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 48).padding(.vertical, 6)
                        .foregroundStyle(PlayPalette.ink)
                        .background(PlayPalette.accent, in: RoundedRectangle(cornerRadius: 15))
                }.buttonStyle(.plain).accessibilityIdentifier(primary.id)
                if let secondary {
                    Button(secondary.title, action: secondary.action).font(.subheadline)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .buttonStyle(.plain).accessibilityIdentifier(secondary.id)
                }
            }
            .padding(.horizontal, 20).padding(.top, 10)
            .background(PlayPalette.background)
        }
    }
}

#Preview("首頁 v1 · 事件主導") { EventFirstView() }
#Preview("結構 B · 章節敘事") { EventFirstView(studyDirection: "novel") }
#Preview("結構 C · 人生時間軸") { EventFirstView(studyDirection: "map") }
#Preview("首頁最大文字") { EventFirstView().environment(\.dynamicTypeSize, .accessibility5) }
#Preview("沒有事件資料") { EventFirstView(flow: EventFirstFlow(events: [])) }
