import SwiftUI
import Charts
import LifeDomain
import LifeData

private let accent = StoryPalette.forest

struct CrossroadsView: View {
    @StateObject private var store = GameStore()
    @AppStorage("shortStoryText") private var shortText = false
    @State private var showSources = false
    @State private var showTrace = false
    @State private var comparisonPresentation: ComparisonPresentation?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    if let session = store.session {
                        if session.phase == .ended { ending(session) }
                        else {
                            progress(session)
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
            .background(StoryPalette.page)
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
                    Button(store.session?.traces.count == 15 ? "翻開人生回憶冊" : "走向下一段") { store.next() }
                        .buttonStyle(JourneyButtonStyle())
                        .accessibilityIdentifier("continueLife")
                        .padding().background(.bar)
                }
            }
            .sheet(isPresented: $showSources) { sources }
            .sheet(isPresented: $showTrace) { traceSheet }
            .sheet(item: $comparisonPresentation) { presentation in comparisonSheet(presentation) }
            .alert("需要留意", isPresented: Binding(get: { store.errorMessage != nil }, set: { if !$0 { store.errorMessage = nil } })) {
                Button("知道了") { store.errorMessage = nil }
            } message: { Text(store.errorMessage ?? "") }
        }.tint(accent)
    }

    private var home: some View {
        VStack(alignment: .leading, spacing: 22) {
            StoryEyebrow(title: "一本由你參與的人生故事", icon: "book.closed")
            Text("如果人生，\n走向另一條路？")
                .font(.system(.largeTitle, design: .rounded).bold())
            StoryScene(age: 8, person: "", chapter: "旅途還沒開始", sceneID: "birthScene")
            VStack(alignment: .leading, spacing: 9) {
                Text("嗨，我是沐沐。")
                    .font(.title2.weight(.bold))
                Text("陪我從童年走到晚年吧。要留時間給什麼？遇到困難，又能找誰幫忙？")
                    .lineSpacing(4)
            }
            VStack(alignment: .leading, spacing: 18) {
                StoryEyebrow(title: "第一頁 · 選一個起點", icon: "map")
                Text("這次，從哪裡開始？").font(.title3.bold())
                countryPicker
                familyPicker
                if let household = store.selectedHousehold {
                    Text(household.label).font(.subheadline).fixedSize(horizontal: false, vertical: true)
                    Text("兩種家庭各有支持與限制，是虛構示例，不代表這個國家的每個家庭。")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }.card()
            if let catalog = store.catalog,
               let country = store.countries.first(where: { $0.code == store.countryCode }) {
                CountryContextCard(country: country, catalog: catalog)
            }
            Button("陪沐沐開始一段人生", systemImage: "pawprint") { store.start() }
                .buttonStyle(JourneyButtonStyle()).disabled(store.catalog == nil)
                .accessibilityIdentifier("startLife")
            Toggle("使用較短的故事文字", isOn: $shortText).font(.subheadline)
            Text("15段選擇，沒有唯一的好人生。環境影響機會，選擇留下故事，也有些事不由自己控制。")
                .font(.subheadline).foregroundStyle(.secondary)
            Text("動物角色演出虛構故事；所有國家共用這座想像的河畔舞台，不是各國生活的實景。包含工作變動與照顧情境，可休息或回首頁。原型關閉後不保存進度。")
                .font(.footnote).foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var countryPicker: some View {
        if dynamicTypeSize.isAccessibilitySize {
            Picker("出生國家", selection: $store.countryCode) {
                ForEach(store.countries, id: \.code) { Text($0.name).tag($0.code) }
            }.pickerStyle(.menu).accessibilityIdentifier("countryPicker")
        } else {
            Picker("出生國家", selection: $store.countryCode) {
                ForEach(store.countries, id: \.code) { Text($0.name).tag($0.code) }
            }.pickerStyle(.segmented).accessibilityIdentifier("countryPicker")
        }
    }

    @ViewBuilder
    private var familyPicker: some View {
        if dynamicTypeSize.isAccessibilitySize {
            Picker("家庭情境", selection: $store.familyNumber) {
                Text("家庭一").tag(1); Text("家庭二").tag(2)
            }.pickerStyle(.menu).accessibilityIdentifier("familyPicker")
        } else {
            Picker("家庭情境", selection: $store.familyNumber) {
                Text("家庭一").tag(1); Text("家庭二").tag(2)
            }.pickerStyle(.segmented).accessibilityIdentifier("familyPicker")
        }
    }

    private func progress(_ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("沐沐，\(session.state.age)歲").font(.system(.title, design: .rounded).bold())
                Spacer()
                Text(store.name(session.state.countryCode)).font(.subheadline.weight(.semibold))
            }
            HStack(alignment: .firstTextBaseline) {
                Text(stageName(session.state.age)).font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(min(15, session.traces.count + (session.phase == .choosing ? 1 : 0))) / 15")
                    .font(.caption.monospacedDigit()).foregroundStyle(.secondary)
            }
            ProgressView(value: Double(session.traces.count), total: 15)
                .accessibilityLabel("已完成\(session.traces.count)段，共十五段")
        }
    }

    private func decision(_ event: DecisionSkeleton, _ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            StoryScene(age: session.state.age, person: event.recurringPerson,
                       chapter: "故事進行中", sceneID: "decisionScene")
            if !event.recurringPerson.isEmpty {
                Label("這一頁的人物：\(event.recurringPerson)", systemImage: "person.crop.circle")
                    .font(.subheadline.weight(.semibold))
            }
            if let jump = session.jumps.last, !jump.triggeredHooks.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    StoryEyebrow(title: "之前的選擇，傳來了回聲", icon: "leaf")
                    ForEach(jump.triggeredHooks, id: \.id) { Text($0.text) }
                }.card()
            }
            VStack(alignment: .leading, spacing: 14) {
                Text(event.title).font(.title2.bold()).accessibilityIdentifier("eventTitle")
                Text(storyText(event)).lineSpacing(5).fixedSize(horizontal: false, vertical: true)
                Divider()
                Text(event.storyQuestion).font(.headline)
                if event.id == "teen-project" {
                    Text("想接著探索環境嗎？用下方的「同一個行動，換個環境呢？」分別試算線上與紙本選項。比較只幫你看代價，不會替你選擇。")
                        .font(.subheadline).foregroundStyle(.secondary)
                        .accessibilityIdentifier("digitalLearningGuide")
                }
            }.card()
            DisclosureGroup {
                ResourcePanel(resources: session.state.resources).padding(.top, 14)
            } label: { Label("看看我的近況", systemImage: "leaf.circle").font(.subheadline.weight(.semibold)) }
            VStack(alignment: .leading, spacing: 12) {
                StoryEyebrow(title: "這段日子，可以怎麼安排？", icon: "signpost.right.and.left")
                ViewThatFits(in: .horizontal) {
                    budget(session, vertical: false)
                    budget(session, vertical: true)
                }
            }
            ForEach(Array(event.choices.enumerated()), id: \.element.id) { index, choice in
                if let preview = store.preview(choice.id) {
                    Button { store.choose(choice.id) } label: {
                        HStack(alignment: .top, spacing: 13) {
                            Text("\(index + 1)")
                                .font(.subheadline.weight(.heavy))
                                .frame(width: 30, height: 30)
                                .background(accent.opacity(0.1), in: Circle())
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 9) {
                                Text(choice.title).font(.headline)
                                Text("需要：時間\(preview.finalCost.time) · 精力\(preview.finalCost.energy) · 材料\(preview.finalCost.materials)")
                                    .font(.subheadline)
                                Text("基本影響：\(deltaText(choice.effect))").font(.footnote).foregroundStyle(.secondary)
                                if !preview.applied {
                                    Label(preview.unavailableReasons.joined(separator: "\n"), systemImage: "lock")
                                        .font(.footnote)
                                }
                            }.fixedSize(horizontal: false, vertical: true)
                            Spacer(minLength: 0)
                        }.frame(maxWidth: .infinity, alignment: .leading).card()
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(preview.applied ? Color.primary : Color.secondary)
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
            } label: {
                Label("同一個行動，換個環境呢？", systemImage: "arrow.triangle.branch")
                    .font(.subheadline.weight(.semibold))
            }.accessibilityIdentifier("compareChoice")
            Text("代價是這次的模型試算；基本影響之外，實際支持或機會事件會在選擇後說明。")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func budget(_ session: LifeSession, vertical: Bool) -> some View {
        if vertical {
            VStack(alignment: .leading, spacing: 7) { budgetContents(session) }
        } else {
            HStack(spacing: 7) { budgetContents(session) }
        }
    }

    @ViewBuilder
    private func budgetContents(_ session: LifeSession) -> some View {
        BudgetToken(title: "時間", value: session.state.remainingTime, icon: "clock")
        BudgetToken(title: "精力", value: session.state.remainingEnergy, icon: "bolt")
        BudgetToken(title: "材料", value: session.state.remainingMaterials, icon: "shippingbox")
    }

    private func feedback(_ trace: ConsequenceTrace) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            StoryScene(age: trace.age, person: trace.recurringPerson,
                       chapter: "這一頁，留下了…", sceneID: "reflectionScene")
            Button("為什麼會這樣？", systemImage: "questionmark.circle") { showTrace = true }
                .buttonStyle(.bordered).controlSize(.large)
                .accessibilityIdentifier("whyResult")
            VStack(alignment: .leading, spacing: 16) {
                StoryEyebrow(title: "我做的決定", icon: "bookmark")
                Text(trace.choiceTitle).font(.title2.bold())
                Text("這一段日子，沐沐用了\(trace.finalCost.time)格時間，有\(trace.budgetAfter.time)格沒有用在這個行動上。")
                    .lineSpacing(4)
                    .accessibilityIdentifier("roundTimeFeedback")
                Text("時間、精力和材料額度只用於這一回合；下一回合會重新安排，剩下的格數不會累積。")
                    .font(.footnote).foregroundStyle(.secondary)
                    .accessibilityIdentifier("roundBudgetExplanation")
                StoryEyebrow(title: "會帶往後來的變化", icon: "leaf")
                Text(deltaText(trace.resourcesAfter - trace.resourcesBefore)).font(.headline)
                Text("健康、財務安全、人際與技能會延續；這次的選擇也會留下紀錄，可能影響後來的故事。")
                    .font(.footnote).foregroundStyle(.secondary)
                if trace.randomTrial?.occurred == true {
                    Label("這次，也意外收到別人的鼓勵。", systemImage: "sparkle")
                }
                if !trace.scheduledHooks.isEmpty {
                    Text("有人記得一起做過的事。這段故事，還有下一頁。")
                }
                if let branch = trace.storyBranch {
                    Divider()
                    StoryEyebrow(title: "過去的選擇，如何走到這一頁", icon: "arrow.triangle.branch")
                    Text(branch.explanation).font(.subheadline).lineSpacing(4)
                        .accessibilityIdentifier("storyBranchExplanation")
                }
            }.card()
            Text("這只是一段經歷，沒有唯一正確的答案。下一段仍可以調整，也可以找人幫忙。")
                .font(.subheadline).foregroundStyle(.secondary)
        }
    }

    private func ending(_ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            StoryEyebrow(title: "沐沐的人生回憶冊", icon: "book.pages")
            Text("那些岔路，\n成了我的故事。")
                .font(.system(.largeTitle, design: .rounded).bold())
                .accessibilityIdentifier("journeyComplete")
            StoryScene(age: session.state.age, person: session.traces.last?.recurringPerson ?? "",
                       chapter: "把這一段人生，留在心裡", sceneID: "endingScene")
            Text("有選擇，有限制，也有一路相伴的人。這些數字描述故事裡的變化，不評定人生的價值。")
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 14) {
                Text("我現在的模樣").font(.title3.bold())
                ResourcePanel(resources: session.state.resources)
                DisclosureGroup("看看四項資源的歷程") { resourceChart(session).padding(.top, 14) }
                    .font(.subheadline)
            }.card()
            if !session.state.memories.isEmpty {
                Text("一路上，留下的回聲").font(.title2.bold())
                ForEach(session.state.memories, id: \.id) { hook in
                    Label(hook.text, systemImage: "leaf").lineSpacing(4).card()
                }
            }
            Text("翻看那些重要的日子").font(.title2.bold())
            ForEach(session.traces, id: \.eventID) { trace in
                HStack(alignment: .top, spacing: 12) {
                    VStack(spacing: 6) {
                        Text("\(trace.age)").font(.headline.monospacedDigit())
                        Text("歲").font(.caption)
                        Rectangle().fill(accent.opacity(0.2)).frame(width: 2, height: 28)
                    }.frame(width: 38)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(trace.eventTitle).font(.headline)
                        Text(trace.choiceTitle).font(.subheadline)
                        if let branch = trace.storyBranch {
                            Text(branch.explanation).font(.footnote).foregroundStyle(.secondary)
                        }
                        Text(deltaText(trace.resourcesAfter - trace.resourcesBefore))
                            .font(.caption).foregroundStyle(.secondary)
                    }.fixedSize(horizontal: false, vertical: true)
                    if let companion = StoryCharacter.companion(named: trace.recurringPerson) {
                        StoryPortrait(character: companion).frame(width: 48, height: 48)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading).card()
            }
            Button("同背景，再走一次", systemImage: "arrow.counterclockwise") { store.start(replay: true) }
                .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("replaySame")
            Button("換個環境，開始新人生") { store.session = nil }.frame(maxWidth: .infinity)
            Text("人生種子：\(String(session.state.seed))").font(.caption.monospaced()).foregroundStyle(.secondary)
            Text("晚年回顧是本版故事收束，不表示角色在這個年齡死亡。")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    private var traceSheet: some View {
        Group {
            if let trace = store.session?.traces.last {
                DetailSheet(title: "為什麼會這樣？", closeID: "closeTrace") {
                    Text(trace.influenceSummary).font(.headline).accessibilityIdentifier("actualInfluences")
                    if trace.randomTrial?.occurred == false {
                        Text("這次有檢查機會事件，但未觸發額外後果。").font(.footnote)
                    }
                    ForEach(Array(trace.explanation.enumerated()), id: \.offset) { _, line in
                        Text(line).padding(.vertical, 5)
                    }
                    let usedObservations = trace.observations.filter { observation in
                        trace.costSteps.contains { $0.sourceIDs.contains(observation.sourceID) }
                    }
                    Text(usedObservations.isEmpty
                         ? "本次未使用國家統計調整成本。"
                         : "本次檢查了以下統計背景。即使調整為零，也不代表這些背景造成了資源變化；成本規則與個人後果仍是遊戲設計假設。")
                        .font(.footnote).accessibilityIdentifier("dataUsage")
                    ForEach(usedObservations, id: \.indicator) { observation in
                        if let value = observation.value {
                            Text("\(observation.indicator == "IT.NET.USER.ZS" ? "網路使用人口" : "可取得電力人口")：\(value, specifier: "%.2f")%（\(observation.year.formatted(.number.grouping(.never))))")
                                .font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private func comparisonSheet(_ presentation: ComparisonPresentation) -> some View {
        DetailSheet(title: "換一個環境呢？", closeID: "closeComparison") {
            Text("同一個行動，放進不同環境。")
                .font(.title2.bold())
            if let selected = presentation.traces.first {
                Text("比較的選擇：\(selected.choiceTitle)")
                    .accessibilityIdentifier("comparisonChoiceTitle")
                    .accessibilityValue(selected.choiceID)
            }
            Text(presentation.costExplanation)
                .font(.headline)
                .accessibilityIdentifier("comparisonCostExplanation")
                .accessibilityValue(presentation.costsMatch ? "same" : "different")
            if let selected = presentation.traces.first, selected.age < 13 {
                Text("到了13歲，試著比較線上創作與紙本學習：需要網路的行動，才會使用數位環境規則。看看準備成本是否不同，再選自己想走的路。")
                    .font(.subheadline)
                    .accessibilityIdentifier("digitalComparisonInvitation")
            }
            Text("固定：選項、年齡、家庭模板、過去狀態與種子。改變：環境指標，以及由它產生的模型成本。")
                .font(.footnote)
            ForEach(presentation.traces, id: \.countryCode) { trace in
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.name(trace.countryCode)).font(.title3.bold())
                    Text("時間\(trace.finalCost.time) · 精力\(trace.finalCost.energy) · 材料\(trace.finalCost.materials)")
                    Label(trace.applied ? "目前可以安排" : "目前資源不足，還能求助或休息",
                          systemImage: trace.applied ? "checkmark.circle" : "clock.badge.questionmark")
                        .font(.footnote).foregroundStyle(.secondary)
                    if trace.applied { Text(deltaText(trace.resourcesAfter - trace.resourcesBefore)).font(.footnote) }
                }.card()
            }
            Text("這是模型內的情境比較，不能證明現實因果，也不代表哪個國家或人生比較有價值。國內也有不同家庭與可取得的支持。")
                .font(.footnote).foregroundStyle(.secondary)
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
            Text("國家平均不是每個人的命運。家庭、選擇、他人的幫助和運氣可能參與故事；每次實際用了哪些因素，會在原因說明裡列出。")
            Text("沐沐、阿禾、樹老師和小澄是原創動物角色，所有國家共用角色與想像的河畔舞台；物種、服裝與景物不代表國家、族群或真實家庭。插圖由AI生成，故事規則和因果解釋由離線引擎執行。")
            Text("本版只有兩項宏觀背景指標。家庭、成本門檻、資源變動與機會事件都是明示的遊戲設計假設，不是個人的真實成功機率。")
            Text("不含寫實傷害內容；遇到工作或照顧情境，可以選休息或回首頁。短文模式可在首頁開啟。")
            if let catalog = store.catalog {
                ForEach(catalog.sources, id: \.id) { source in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(source.indicator == "IT.NET.USER.ZS" ? "網路使用人口比例" : "可取得電力人口比例").font(.headline)
                        Text("2023年 · \(source.publisher)").font(.subheadline)
                        Text(source.attribution).font(.caption)
                        if let url = URL(string: source.url) { Link("原始來源與授權", destination: url) }
                        if let url = URL(string: source.licenseURL) { Link("World Bank資料條款", destination: url) }
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
        let text = EventNarratives.texts[event.storyVariantID ?? event.id] ?? event.storyQuestion
        return shortText ? String(text.split(separator: "\n").first ?? Substring(text)) : text
    }
}

private struct ComparisonPresentation: Identifiable {
    let id = UUID()
    let traces: [ConsequenceTrace]

    var costsMatch: Bool {
        guard let first = traces.first else { return false }
        return traces.dropFirst().allSatisfy { $0.finalCost == first.finalCost && $0.applied == first.applied }
    }
    var costExplanation: String {
        costsMatch
            ? "這次比較的成本與可行性相同。不是所有選擇都受國家環境影響；相同的結果，也值得看見。"
            : "這次比較的成本或可行性不同。下方顯示同一個行動，在各個環境中的模型試算。"
    }
}

private struct ResourcePanel: View {
    let resources: ResourceValues
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            resource("健康", resources.health, "heart")
            resource("財務安全", resources.financial, "wallet.bifold")
            resource("人際關係", resources.relationships, "person.2")
            resource("技能", resources.skills, "lightbulb")
        }
    }
    private func resource(_ title: String, _ value: Int, _ icon: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            ViewThatFits(in: .horizontal) {
                HStack { Label(title, systemImage: icon); Spacer(); Text("\(value)").monospacedDigit() }
                VStack(alignment: .leading) { Label(title, systemImage: icon); Text("\(value)").monospacedDigit() }
            }.font(.caption)
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
                .background(StoryPalette.page)
                .navigationTitle(title).navigationBarTitleDisplayMode(.inline)
                .toolbar { Button("完成") { dismiss() }.accessibilityIdentifier(closeID) }
        }
    }
}

private struct JourneyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline).frame(maxWidth: .infinity).padding(.vertical, 17)
            .background(accent.opacity(configuration.isPressed ? 0.78 : 1), in: RoundedRectangle(cornerRadius: 18))
            .foregroundStyle(.white).contentShape(Rectangle())
    }
}

private extension View {
    func card() -> some View {
        padding(18)
            .background(.background, in: RoundedRectangle(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.primary.opacity(0.06), lineWidth: 1))
    }
}

private func deltaText(_ delta: ResourceValues) -> String {
    let pairs = [("健康", delta.health), ("財務安全", delta.financial), ("人際", delta.relationships), ("技能", delta.skills)]
    let changes = pairs.filter { $0.1 != 0 }.map { "\($0.0) \($0.1 > 0 ? "+" : "")\($0.1)" }
    return changes.isEmpty ? "這次沒有立即的資源變動" : changes.joined(separator: " · ")
}

private func stageName(_ age: Int) -> String {
    switch age { case ...12: "童年 · 探索與支持"; case ...22: "青少年 · 學習與人際"; case ...40: "青年 · 工作與獨立"; case ...60: "中年 · 責任與轉折"; default: "晚年 · 回顧與傳承" }
}
