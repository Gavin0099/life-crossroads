import SwiftUI
import Charts
import LifeDomain
import LifeData

private let accent = Color.teal

struct CrossroadsView: View {
    @StateObject private var store = GameStore()
    @AppStorage("shortStoryText") private var shortText = false
    @State private var showSources = false
    @State private var showTrace = false
    @State private var comparisonPresentation: ComparisonPresentation?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    if let session = store.session {
                        if session.phase == .ended { ending(session) }
                        else {
                            progress(session)
                            ResourcePanel(resources: session.state.resources)
                            if session.phase == .choosing, let event = store.currentEvent {
                                decision(event, session)
                            } else if let trace = session.traces.last { feedback(trace) }
                        }
                    } else { home }
                }
                .padding(20)
                .frame(maxWidth: 620)
                .frame(maxWidth: .infinity)
            }
            .id(store.session.map { "\($0.phase.rawValue)-\($0.state.age)" } ?? "home")
            .background(Color(.systemGroupedBackground))
            .navigationTitle("人生岔路")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if store.session != nil {
                        Button("首頁", systemImage: "house") { store.session = nil }
                            .accessibilityLabel("回首頁，結束目前這段人生")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("說明與資料", systemImage: "info.circle") { showSources = true }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if store.session?.phase == .reflecting {
                    Button(store.session?.traces.count == 15 ? "打開人生回顧" : "走向下一段") { store.next() }
                        .buttonStyle(JourneyButtonStyle())
                        .accessibilityIdentifier("continueLife")
                        .padding().background(.bar)
                }
            }
            .sheet(isPresented: $showSources) { sources }
            .sheet(isPresented: $showTrace) {
                if let trace = store.session?.traces.last {
                    DetailSheet(title: "為什麼會這樣？", closeID: "closeTrace") {
                        Text(trace.influenceSummary).font(.headline).accessibilityIdentifier("actualInfluences")
                        if trace.randomTrial?.occurred == false {
                            Text("這次有檢查機會事件，但未觸發額外後果。").font(.footnote)
                        }
                        ForEach(Array(trace.explanation.enumerated()), id: \.offset) { _, line in
                            Text(line).padding(.vertical, 5)
                        }
                        Text("以下是實際套用的資料背景；成本與個人後果是遊戲設計假設。").font(.footnote)
                        ForEach(trace.observations, id: \.indicator) { observation in
                            if let value = observation.value {
                                Text("\(observation.indicator == "IT.NET.USER.ZS" ? "網路使用人口" : "可取得電力人口")：\(value, specifier: "%.2f")%（\(observation.year.formatted(.number.grouping(.never))))")
                                    .font(.footnote).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .sheet(item: $comparisonPresentation) { presentation in
                DetailSheet(title: "換一個環境呢？", closeID: "closeComparison") {
                    Text("先固定同一項選擇、家庭情境、過去資源和運氣種子，看看不同背景的成本。").font(.headline)
                    if let selected = presentation.traces.first {
                        Text("比較的選擇：\(store.choiceTitle(selected))").accessibilityIdentifier("comparisonChoiceTitle")
                    }
                    Text("固定：選項、年齡、家庭模板、過去狀態與種子。改變：環境指標，以及由它產生的模型成本。")
                        .font(.footnote)
                    ForEach(presentation.traces, id: \.countryCode) { trace in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(store.name(trace.countryCode)).font(.title3.bold())
                            Text("時間 \(trace.finalCost.time)・精力 \(trace.finalCost.energy)・材料 \(trace.finalCost.materials)")
                            Text(trace.applied ? "目前可以安排" : "目前資源不足，仍可選擇求助或休息")
                                .font(.footnote).foregroundStyle(.secondary)
                            if trace.applied { Text(deltaText(trace.resourcesAfter - trace.resourcesBefore)).font(.footnote) }
                        }.card()
                    }
                    Text("這是模型內的情境比較，不能證明現實因果，也不代表哪個國家或人生比較有價值。國內也有不同家庭與可取得的支持。")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .alert("需要留意", isPresented: Binding(get: { store.errorMessage != nil }, set: { if !$0 { store.errorMessage = nil } })) {
                Button("知道了") { store.errorMessage = nil }
            } message: { Text(store.errorMessage ?? "") }
        }.tint(accent)
    }

    private var home: some View {
        VStack(alignment: .leading, spacing: 22) {
            Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                .font(.system(size: 46)).foregroundStyle(accent).padding(.top, 12).accessibilityHidden(true)
            Text("每段人生，\n都有不同的可能。")
                .font(.system(.largeTitle, design: .rounded).bold())
            Text("環境影響機會，選擇留下故事。\n也有人幫忙，有些事則不由自己控制。")
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 18) {
                Text("這次，從哪裡開始？").font(.title3.bold())
                Picker("出生國家", selection: $store.countryCode) {
                    ForEach(store.countries, id: \.code) { Text($0.name).tag($0.code) }
                }.pickerStyle(.segmented).accessibilityIdentifier("countryPicker")
                Picker("家庭情境", selection: $store.familyNumber) {
                    Text("家庭一").tag(1); Text("家庭二").tag(2)
                }.pickerStyle(.segmented).accessibilityIdentifier("familyPicker")
                if let household = store.selectedHousehold {
                    Text(household.label).font(.subheadline)
                    Text("家庭是虛構示例，不是這個國家每個人的生活。兩種家庭各有支持與限制。")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }.card()
            Button("開始一段人生", systemImage: "sparkle") { store.start() }
                .buttonStyle(JourneyButtonStyle()).disabled(store.catalog == nil)
                .accessibilityIdentifier("startLife")
            Toggle("使用較短的故事文字", isOn: $shortText).font(.subheadline)
            Text("從童年走到晚年回顧，共 15 段重要選擇。包含工作變動與照顧責任的情境，可以選擇休息或回首頁。這個原型關閉後不保存進度。")
                .font(.footnote).foregroundStyle(.secondary)
        }
    }

    private func progress(_ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(session.state.age) 歲").font(.system(.largeTitle, design: .rounded).bold())
                Spacer()
                Text(store.name(session.state.countryCode)).font(.headline)
            }
            HStack {
                Text(stageName(session.state.age)).foregroundStyle(accent)
                Spacer()
                Text("第 \(min(15, session.traces.count + (session.phase == .choosing ? 1 : 0))) / 15 段")
                    .foregroundStyle(.secondary)
            }.font(.subheadline)
            ProgressView(value: Double(session.traces.count), total: 15)
                .accessibilityLabel("已完成 \(session.traces.count) 段，共十五段")
        }
    }

    private func decision(_ event: DecisionSkeleton, _ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            if let jump = session.jumps.last, !jump.triggeredHooks.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Label("幾年後，你們又相遇了", systemImage: "leaf").font(.headline)
                    ForEach(jump.triggeredHooks, id: \.id) { Text($0.text) }
                }.card()
            }
            VStack(alignment: .leading, spacing: 14) {
                Text(event.title).font(.title2.bold()).accessibilityIdentifier("eventTitle")
                Text(storyText(event)).lineSpacing(5)
                Text(event.storyQuestion).font(.headline).foregroundStyle(accent)
            }.card()
            HStack {
                Label("時間 \(session.state.remainingTime)", systemImage: "clock")
                Spacer()
                Label("精力 \(session.state.remainingEnergy)", systemImage: "bolt")
                Spacer()
                Label("材料 \(session.state.remainingMaterials)", systemImage: "shippingbox")
            }.font(.subheadline)
            ForEach(event.choices, id: \.id) { choice in
                if let preview = store.preview(choice.id) {
                    Button { store.choose(choice.id) } label: {
                        VStack(alignment: .leading, spacing: 9) {
                            Text(choice.title).font(.headline)
                            Text("時間 \(preview.finalCost.time)・精力 \(preview.finalCost.energy)・材料 \(preview.finalCost.materials)")
                                .font(.subheadline)
                            Text(deltaText(choice.effect)).font(.footnote)
                            if !preview.applied {
                                Text(preview.unavailableReasons.joined(separator: "\n")).font(.footnote)
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading).card()
                    }
                    .buttonStyle(.plain).foregroundStyle(preview.applied ? Color.primary : Color.secondary)
                    .disabled(!preview.applied).accessibilityIdentifier("choice.\(choice.id)")
                }
            }
            Menu {
                ForEach(event.choices, id: \.id) { choice in
                    Button(choice.title) {
                        let traces = store.compare(choiceID: choice.id)
                        if !traces.isEmpty { comparisonPresentation = .init(traces: traces) }
                    }.accessibilityIdentifier("compare.\(choice.id)")
                }
            } label: { Label("選一個行動，換個環境比較", systemImage: "arrow.triangle.branch") }
                .font(.subheadline).accessibilityIdentifier("compareChoice")
            Text("選項先顯示基本代價與影響；環境、支持和機會也會參與結果。")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    private func feedback(_ trace: ConsequenceTrace) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("這段日子留下了…", systemImage: "book.pages").font(.title2.bold())
            Text(store.choiceTitle(trace)).font(.headline)
            Text(deltaText(trace.resourcesAfter - trace.resourcesBefore)).font(.title3)
            Text("你用了 \(trace.finalCost.time) 格時間，還留下 \(trace.budgetAfter.time) 格生活空間。")
            if trace.randomTrial?.occurred == true { Text("這次也意外收到別人的鼓勵。").foregroundStyle(accent) }
            if !trace.scheduledHooks.isEmpty { Text("有人記得你們一起做過的事。這段故事，可能還沒結束。") }
            Button("為什麼會這樣？", systemImage: "questionmark.circle") { showTrace = true }
                .buttonStyle(.bordered).accessibilityIdentifier("whyResult")
            Text("這只是一段經歷，沒有唯一正確的人生。下一段仍可以調整，也可以找人幫忙。")
                .foregroundStyle(.secondary)
        }.card()
    }

    private func ending(_ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            Label("你走過的一段人生", systemImage: "sun.horizon")
                .font(.largeTitle.bold()).accessibilityIdentifier("journeyComplete")
            Text("有選擇，有限制，也有一路相伴的人。\n這些數字描述故事裡的變化，不評定你的價值。")
                .foregroundStyle(.secondary)
            resourceChart(session)
            Text("一路上，留下的回聲").font(.title2.bold())
            if session.state.memories.isEmpty { Text("這次你保留了不同的生活空間。另一次選擇，也可能留下新的故事。") }
            ForEach(session.state.memories, id: \.id) { hook in Text(hook.text).card() }
            Text("人生時間軸").font(.title2.bold())
            ForEach(session.traces, id: \.eventID) { trace in
                VStack(alignment: .leading, spacing: 7) {
                    Text("\(trace.age) 歲 · \(store.title(trace.eventID))").font(.headline)
                    Text(store.choiceTitle(trace)).font(.subheadline)
                    Text(deltaText(trace.resourcesAfter - trace.resourcesBefore)).font(.caption).foregroundStyle(.secondary)
                }.card()
            }
            Button("同背景，再走一次", systemImage: "arrow.counterclockwise") { store.start(replay: true) }
                .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("replaySame")
            Button("換個環境，開始新人生") { store.session = nil }.frame(maxWidth: .infinity)
            Text("人生種子：\(String(session.state.seed))").font(.caption.monospaced()).foregroundStyle(.secondary)
            Text("晚年回顧是本版故事收束，不表示角色在這個年齡死亡。").font(.caption).foregroundStyle(.secondary)
        }
    }

    private func resourceChart(_ session: LifeSession) -> some View {
        Chart {
            ForEach(session.traces, id: \.eventID) { trace in
                LineMark(x: .value("年齡", trace.age), y: .value("資源", trace.resourcesAfter.health))
                    .foregroundStyle(by: .value("類別", "健康"))
                LineMark(x: .value("年齡", trace.age), y: .value("資源", trace.resourcesAfter.financial))
                    .foregroundStyle(by: .value("類別", "財務安全"))
                LineMark(x: .value("年齡", trace.age), y: .value("資源", trace.resourcesAfter.relationships))
                    .foregroundStyle(by: .value("類別", "人際關係"))
                LineMark(x: .value("年齡", trace.age), y: .value("資源", trace.resourcesAfter.skills))
                    .foregroundStyle(by: .value("類別", "技能"))
            }
        }.chartYScale(domain: 0...100).frame(height: 210)
            .accessibilityLabel("四項資源的歷程，沒有合成人生總分")
    }

    private var sources: some View {
        DetailSheet(title: "故事、資料與限制", closeID: "closeSources") {
            Text("體驗選擇，也理解限制").font(.title2.bold())
            Text("國家、家庭、選擇、他人的幫助和運氣共同參與故事。國家平均不是每個人的命運。")
            Text("本版只有兩項宏觀背景指標。家庭、成本門檻、資源變動與機會事件都是明示的遊戲設計假設，不是個人的真實成功機率。")
            Text("不含寫實傷害內容；遇到工作或照顧情境，可以選休息或回首頁。短文模式可在首頁開啟。")
            if let catalog = store.catalog {
                ForEach(catalog.sources, id: \.id) { source in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(source.indicator == "IT.NET.USER.ZS" ? "網路使用人口比例" : "可取得電力人口比例").font(.headline)
                        Text("2023 年 · \(source.publisher)").font(.subheadline)
                        Text(source.attribution).font(.caption)
                        if let url = URL(string: source.url) { Link("原始來源與授權", destination: url) }
                        if let url = URL(string: source.licenseURL) { Link("World Bank 資料條款", destination: url) }
                    }.card()
                }
                Text("台灣仍待可比資料核對；德國、巴西、越南的情境故事還在整理。本版先開放四國。").font(.footnote)
                DisclosureGroup("查看遊戲設計假設") {
                    ForEach(catalog.assumptions, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.statement); Text(item.limitation).foregroundStyle(.secondary)
                        }.font(.footnote).padding(.vertical, 8)
                    }
                }
            }
        }
    }

    private func storyText(_ event: DecisionSkeleton) -> String {
        let text = EventNarratives.texts[event.id] ?? event.storyQuestion
        return shortText ? String(text.split(separator: "\n").first ?? Substring(text)) : text
    }
}

private struct ComparisonPresentation: Identifiable {
    let id = UUID()
    let traces: [ConsequenceTrace]
}

private struct ResourcePanel: View {
    let resources: ResourceValues
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            resource("健康", resources.health, "heart")
            resource("財務安全", resources.financial, "wallet.bifold")
            resource("人際關係", resources.relationships, "person.2")
            resource("技能", resources.skills, "lightbulb")
        }.card()
    }
    private func resource(_ title: String, _ value: Int, _ icon: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack { Label(title, systemImage: icon); Spacer(); Text("\(value)").monospacedDigit() }.font(.caption)
            ProgressView(value: Double(value), total: 100)
        }.accessibilityElement(children: .ignore).accessibilityLabel("\(title)，\(value)，滿格一百")
    }
}

private struct DetailSheet<Content: View>: View {
    let title: String
    let closeID: String
    @ViewBuilder var content: () -> Content
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ScrollView { VStack(alignment: .leading, spacing: 18, content: content).padding(20) }
                .background(Color(.systemGroupedBackground))
                .navigationTitle(title).navigationBarTitleDisplayMode(.inline)
                .toolbar { Button("完成") { dismiss() }.accessibilityIdentifier(closeID) }
        }
    }
}

private struct JourneyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline).frame(maxWidth: .infinity).padding(.vertical, 17)
            .background(accent.opacity(configuration.isPressed ? 0.7 : 1), in: RoundedRectangle(cornerRadius: 18))
            .foregroundStyle(.white).contentShape(Rectangle())
    }
}

private extension View {
    func card() -> some View { padding(18).background(.background, in: RoundedRectangle(cornerRadius: 22)) }
}

private func deltaText(_ delta: ResourceValues) -> String {
    let pairs = [("健康", delta.health), ("財務安全", delta.financial), ("人際", delta.relationships), ("技能", delta.skills)]
    let changes = pairs.filter { $0.1 != 0 }.map { "\($0.0) \($0.1 > 0 ? "+" : "")\($0.1)" }
    return changes.isEmpty ? "這次沒有立即的資源變動" : changes.joined(separator: " · ")
}

private func stageName(_ age: Int) -> String {
    switch age { case ...12: "童年 · 探索與支持"; case ...22: "青少年 · 學習與人際"; case ...40: "青年 · 工作與獨立"; case ...60: "中年 · 責任與轉折"; default: "晚年 · 回顧與傳承" }
}
