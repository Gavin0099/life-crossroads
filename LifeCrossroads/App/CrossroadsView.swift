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
    @State private var showForkPicker = false
    @State private var branchComparison: BranchComparison?
    @State private var restartAction: RestartAction?
    private enum RestartAction { case newLife, sameSeed, newSeed }

    @State private var comparisonPresentation: ComparisonPresentation?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if let session = store.session {
                        switch session.phase {
                        case .ended: ending(session)
                        case .choosing:
                            progress(session)
                            if let event = store.currentEvent {
                                decision(event, session)
                            } else {
                                Text("目前無法取得下一件事，請回首頁重新開始。")
                                    .accessibilityIdentifier("missingEvent")
                            }
                        case .reflecting:
                            progress(session)
                            if let trace = session.traces.last { feedback(trace) }
                            else { Text("目前沒有已執行的選擇紀錄。").accessibilityIdentifier("missingOutcome") }
                        }
                    } else { home }
                }
                .padding(18)
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
                        Button("首頁", systemImage: "house") { store.home() }
                            .accessibilityLabel("回首頁，保留目前進度")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("說明與資料", systemImage: "info.circle") { showSources = true }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if store.session != nil {
                        Menu {
                            Button("同背景、同種子重新開始") { restartAction = .sameSeed }
                                .accessibilityIdentifier("restartSame")
                            Button("同背景、換個運氣重新開始") { restartAction = .newSeed }
                                .accessibilityIdentifier("restartNewSeed")
                        } label: { Label("重新開始這段人生", systemImage: "arrow.counterclockwise") }
                            .accessibilityIdentifier("restartMenu")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if store.session?.phase == .reflecting {
                    Button(store.session.map { $0.traces.count == $0.plannedDecisionCount } == true ? "翻開人生回憶冊" : "走向下一段") { store.next() }
                        .buttonStyle(JourneyButtonStyle())
                        .accessibilityIdentifier("continueLife")
                        .padding().background(.bar)
                }
            }
            .sheet(isPresented: $showForkPicker) {
                if let original = store.session, let catalog = store.catalog {
                    BranchPickerView(original: original, catalog: catalog) { store.startBranch(at: $0, choiceID: $1) }
                }
            }
            .sheet(isPresented: Binding(get: { branchComparison != nil }, set: { if !$0 { branchComparison = nil } })) {
                if let branchComparison { BranchComparisonView(comparison: branchComparison) }
            }
            .confirmationDialog("建立新人生會取代本機的這組人生紀錄", isPresented: Binding(get: { restartAction != nil }, set: { if !$0 { restartAction = nil } }), titleVisibility: .visible) {
                Button("取代紀錄並開始", role: .destructive) {
                    switch restartAction {
                    case .sameSeed: store.start(replay: true)
                    case .newSeed: store.replayWithNewSeed()
                    case .newLife: store.start()
                    case nil: break
                    }
                    restartAction = nil
                }.accessibilityIdentifier("confirmRestart")
            } message: { Text("回首頁或關閉 App 都能保留進度；只有建立新人生才取代原局與試走路線。") }
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
            if store.journey != nil {
                Button("繼續已保存的人生", systemImage: "book") { store.resume() }
                    .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("resumeLife")
            }
            StoryEyebrow(title: "一本由你參與的人生故事", icon: "book.closed")
            HStack(spacing: 12) {
                Text("如果人生，\n走向另一條路？")
                    .font(.system(.title, design: .rounded).bold())
                Spacer(minLength: 0)
                if !dynamicTypeSize.isAccessibilitySize {
                    CompactStoryScene(age: 8, person: "", sceneID: "birthScene")
                        .frame(width: 100, height: 84)
                }
            }
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
            Button("陪沐沐開始一段人生", systemImage: "pawprint") {
                if store.journey != nil || store.restoreFailed { restartAction = .newLife } else { store.start() }
            }
                .buttonStyle(JourneyButtonStyle()).disabled(store.catalog == nil)
                .accessibilityIdentifier("startLife")
            if let catalog = store.catalog,
               let country = store.countries.first(where: { $0.code == store.countryCode }) {
                DisclosureGroup {
                    CountryContextCard(country: country, catalog: catalog).padding(.top, 12)
                } label: {
                    Text("認識\(country.name)的資料背景").accessibilityIdentifier("countryContextToggle")
                }
            }
            Toggle("使用較短的故事文字", isOn: $shortText).font(.subheadline)
            Text("15段選擇，沒有唯一的好人生。環境影響機會，選擇留下故事，也有些事不由自己控制。")
                .font(.subheadline).foregroundStyle(.secondary)
            Text("動物角色演出虛構故事；所有國家共用這座想像的河畔舞台，不是各國生活的實景。包含工作變動與照顧情境，可休息或回首頁。每次操作自動保存一組人生；關閉後可續玩。建立新人生會先詢問是否取代紀錄。")
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
        VStack(alignment: .leading, spacing: 7) {
            if let experiment = store.experiment {
                Text("另一條路 · 從\(experiment.snapshot.session.state.age)歲改選，原人生已保留")
                    .font(.subheadline).accessibilityIdentifier("branchInProgress")
                Button("看看保留的原人生") { store.viewingOriginal = true }
                    .accessibilityIdentifier("viewOriginal")
            }
            HStack(alignment: .firstTextBaseline) {
                Text("沐沐 · \(session.state.age)歲").font(.system(.title3, design: .rounded).bold())
                Spacer(minLength: 8)
                Text("\(min(session.plannedDecisionCount, session.traces.count + (session.phase == .choosing ? 1 : 0))) / \(session.plannedDecisionCount)")
                    .font(.caption.monospacedDigit()).foregroundStyle(.secondary)
            }
            Text("\(store.name(session.state.countryCode)) · \(stageName(session.state.age))")
                .font(.caption).foregroundStyle(.secondary)
            ProgressView(value: Double(session.traces.count), total: Double(session.plannedDecisionCount))
                .accessibilityLabel("已完成\(session.traces.count)段，共\(session.plannedDecisionCount)段")
        }
    }

    private func decision(_ event: DecisionSkeleton, _ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 11) {
                HStack(alignment: .center, spacing: 12) {
                    Text(event.title).font(.title2.bold()).accessibilityIdentifier("eventTitle")
                        .accessibilityValue(event.id).accessibilityAddTraits(.isHeader)
                    if !dynamicTypeSize.isAccessibilitySize {
                        Spacer(minLength: 0)
                        CompactStoryScene(age: session.state.age, person: event.recurringPerson, sceneID: "decisionScene")
                            .frame(width: 88, height: 68)
                    }
                }
                Text(shortStory(event)).lineSpacing(3).fixedSize(horizontal: false, vertical: true)
                Text(event.storyQuestion).font(.subheadline.weight(.semibold))
            }
            Text("你會怎麼安排？").font(.headline).accessibilityAddTraits(.isHeader)
            ViewThatFits(in: .horizontal) {
                budget(session, vertical: false)
                budget(session, vertical: true)
            }
            ForEach(event.choices, id: \.id) { choice in
                if let preview = store.preview(choice.id) {
                    Button { store.choose(choice.id) } label: {
                        VStack(alignment: .leading, spacing: 7) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(choice.title).font(.headline)
                                Spacer(minLength: 0)
                                Image(systemName: preview.applied ? "arrow.up.right" : "lock").accessibilityHidden(true)
                            }
                            Text("時間\(preview.finalCost.time) · 精力\(preview.finalCost.energy) · 材料\(preview.finalCost.materials)")
                                .font(.subheadline.weight(.semibold))
                            Text("基本影響：\(deltaText(choice.effect))").font(.caption).foregroundStyle(.secondary)
                            if !preview.applied {
                                Text(preview.unavailableReasons.joined(separator: "\n")).font(.footnote)
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading).card()
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(preview.applied ? Color.primary : Color.secondary)
                    .disabled(!preview.applied).accessibilityIdentifier("choice.\(choice.id)")
                }
            }
            Menu {
                ForEach(event.choices, id: \.id) { choice in
                    Button(choice.title) { presentComparison(choice.id) }
                        .accessibilityIdentifier("compare.\(choice.id)")
                }
            } label: {
                Label("同一行動，換個環境？", systemImage: "arrow.triangle.branch")
                    .font(.subheadline.weight(.semibold)).frame(minHeight: 44)
            }.accessibilityIdentifier("compareChoice")
            if event.id == "teen-project" {
                Text("試算線上與紙本選項：只有需要網路的行動，才會使用數位環境規則。比較不會替你選擇。")
                    .font(.footnote).foregroundStyle(.secondary).accessibilityIdentifier("digitalLearningGuide")
            }
            if !shortText {
                DisclosureGroup("多讀一點故事") { Text(storyText(event)).lineSpacing(4).padding(.top, 10) }
            }
            if let selection = session.currentSelection { selectionDetails(selection) }
            if let jump = session.jumps.last, !jump.triggeredHooks.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    StoryEyebrow(title: "上個岔路留下的回聲", icon: "leaf")
                    ForEach(jump.triggeredHooks, id: \.id) { Text($0.text) }
                }.card()
            }
            DisclosureGroup {
                Text("這一頁的人物：\(event.recurringPerson)").font(.subheadline).padding(.top, 10)
                ResourcePanel(resources: session.state.resources).padding(.top, 14)
            } label: { Label("人物與近況", systemImage: "person.crop.rectangle").font(.subheadline.weight(.semibold)) }
            Text("額度每回合重新安排；健康、人際、技能與財務及選擇紀錄會延續。基本影響之外，實際支持或機會事件會在選後說明。")
                .font(.caption).foregroundStyle(.secondary)
            Text("人生種子：\(String(session.state.seed))").font(.caption2.monospaced()).foregroundStyle(.secondary)
                .accessibilityIdentifier("lifeSeed").accessibilityValue(String(session.state.seed))
        }
    }

    private func selectionDetails(_ selection: EventSelectionTrace) -> some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 10) {
                Text(selection.summary).font(.subheadline).accessibilityIdentifier("eventSelectionSummary")
                if let selected = selection.candidates.first(where: { $0.eventID == selection.selectedEventID }) {
                    if selected.conditions.isEmpty {
                        Text("這個情境沒有額外的家庭、資源或先前選擇門檻。")
                            .font(.subheadline)
                    } else {
                        ForEach(selected.conditions, id: \.condition.id) { evaluation in
                            Text(selectionConditionText(evaluation)).font(.subheadline)
                                .accessibilityIdentifier("selectedCondition.\(evaluation.condition.id)")
                        }
                    }
                } else {
                    Text("目前沒有這個事件的入選條件紀錄，不補上推測。").font(.subheadline)
                }
                if let selected = selection.candidates.first(where: { $0.eventID == selection.selectedEventID }) {
                    if selected.weightSteps.contains(where: { $0.ruleID == "story-continuity" }) { Text("先前留下的故事讓這類後續邀請更容易出現，仍不保證一定遇見。").font(.subheadline) }
                    if selected.weightSteps.contains(where: { $0.ruleID == "recent-category" }) { Text("最近已遇過相近的事情，這次讓其他類型也多一些機會。").font(.subheadline) }
                }
                Text("這份紀錄說明事件如何入選；它不表示本次行動的成本或資源一定受運氣影響。")
                    .font(.footnote).foregroundStyle(.secondary)
                Text("種子：\(String(selection.seed)) · 候選\(selection.candidates.count)件 · 符合條件\(selection.eligibleEventIDs.count)件")
                    .font(.caption).foregroundStyle(.secondary)
            }.padding(.top, 10)
        } label: {
            Text("怎麼遇到這件事？").accessibilityIdentifier("eventSelectionDetails")
        }
    }

    private func selectionConditionText(_ evaluation: EventConditionEvaluation) -> String {
        let condition = evaluation.condition
        switch condition.kind {
        case .resourceAtLeast, .resourceAtMost, .householdAtLeast:
            guard let actual = evaluation.actualValue, let threshold = condition.threshold else {
                return "這項入選條件沒有完整的數值紀錄。"
            }
            let names = ["health": "健康", "financial": "財務安全", "relationships": "人際關係", "skills": "技能",
                         "mentorSupport": "家庭情境中的指導支持", "careLoad": "家庭照顧安排",
                         "travelCost": "交通時間安排", "materialBudget": "材料額度"]
            let relation = condition.kind == .resourceAtMost ? "不超過" : "至少"
            return "\(names[condition.key] ?? condition.key)：入選前實際為\(actual)，這個情境需\(relation)\(threshold)；\(evaluation.matched ? "本次符合" : "本次未符合")。"
        case .storyFlag:
            let names = ["friendship":"與朋友的約定", "learning":"作品經驗", "care":"共同照顧安排", "repair":"修理經驗", "kitchen":"共煮經驗", "garden":"花圃經驗", "nature":"自然觀察"]
            return "\(names[condition.key] ?? "故事記錄")：\(evaluation.matched ? "已有符合這次邀請的經驗" : "還沒有這次邀請需要的經驗")。可在前面的選擇記錄找到來源。"
        case .relationshipAtLeast:
            return "先前互動留下的熟悉程度為\(evaluation.actualValue ?? 0)，這次邀請需要至少\(condition.threshold ?? 0)。這是故事條件，不是對人的評分。"
        case .priorChoice:
            guard let actualChoice = evaluation.actualChoiceID else { return "這項條件沒有記錄到先前的選擇。" }
            let actual = store.session?.traces.first { $0.eventID == condition.key }
            let eventName = actual?.eventTitle ?? store.title(condition.key)
            let choiceName = actual?.choiceTitle ?? store.catalog?.decisions.first { $0.id == condition.key }?
                .choices.first { $0.id == actualChoice }?.title ?? actualChoice
            return "先前在「\(eventName)」選了「\(choiceName)」；\(evaluation.matched ? "符合這個情境的先前選擇條件" : "未符合這個情境的先前選擇條件")。"
        }
    }

    private func presentComparison(_ choiceID: String) {
        let traces = store.compare(choiceID: choiceID)
        if !traces.isEmpty { comparisonPresentation = .init(traces: traces) }
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
        VStack(alignment: .leading, spacing: 16) {
            StoryEyebrow(title: "這次選擇之後", icon: "bookmark")
            HStack(spacing: 12) {
                Text(trace.choiceTitle).font(.title2.bold()).accessibilityIdentifier("chosenAction")
                    .accessibilityValue(trace.choiceID)
                if !dynamicTypeSize.isAccessibilitySize {
                    Spacer(minLength: 0)
                    CompactStoryScene(age: trace.age, person: trace.recurringPerson, sceneID: "reflectionScene")
                        .frame(width: 88, height: 68)
                }
            }
            Text(trace.eventTitle).font(.subheadline).foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 13) {
                Label("已發生的變化", systemImage: "checkmark.circle").font(.headline)
                Text(deltaText(trace.resourcesAfter - trace.resourcesBefore)).font(.headline)
                Text("這一段日子，沐沐用了\(trace.finalCost.time)格時間，有\(trace.budgetAfter.time)格沒有用在這個行動上。")
                    .lineSpacing(3).accessibilityIdentifier("roundTimeFeedback")
                if trace.randomTrial?.occurred == true {
                    Label("這次，也意外收到別人的鼓勵。", systemImage: "sparkle")
                }
            }.card()
            Button("為什麼會這樣？", systemImage: "questionmark.circle") { showTrace = true }
                .buttonStyle(.bordered).controlSize(.large).accessibilityIdentifier("whyResult")
            Button("比較剛才的行動", systemImage: "arrow.triangle.branch") { presentComparison(trace.choiceID) }
                .buttonStyle(.bordered).controlSize(.large).accessibilityIdentifier("compareChosen")
            if let branch = trace.storyBranch {
                VStack(alignment: .leading, spacing: 10) {
                    StoryEyebrow(title: "過去的選擇，如何走到這一頁", icon: "arrow.triangle.branch")
                    Text(branch.explanation).font(.subheadline).lineSpacing(4)
                        .accessibilityIdentifier("storyBranchExplanation")
                }.card()
            }
            if !trace.recordedStoryFacts.isEmpty {
                Label("這個選擇已留下故事記錄，可能影響未來的邀請與行動；仍不保證一定遇見。", systemImage: "book.closed")
                    .font(.subheadline).accessibilityIdentifier("recordedStoryMemory")
            }
            if trace.effectSteps.contains(where: { $0.ruleID == "resource.clamp" && $0.delta.values.contains(where: { $0 < 0 }) }) {
                Text("部分資源已到上限；上方只顯示實際增加的數量，故事記錄仍會保留。")
                    .font(.footnote).accessibilityIdentifier("resourceCapExplanation")
            }
            if !trace.scheduledHooks.isEmpty {
                VStack(alignment: .leading, spacing: 9) {
                    Label("已留下的線索 · 還沒發生", systemImage: "clock").font(.headline)
                    Text("這次的行動已記入延後故事；到了後面的年齡，才會知道這段線索如何接續。")
                }.card()
            }
            selectionDetails(trace.eventSelection)
            Text("時間、精力和材料額度只用於這一回合；下一回合會重新安排，剩下的格數不會累積。")
                .font(.footnote).foregroundStyle(.secondary).accessibilityIdentifier("roundBudgetExplanation")
            Text("健康、財務安全、人際與技能會延續；選擇也會留下紀錄。沒有唯一正確的答案，下一段仍能調整或求助。")
                .font(.footnote).foregroundStyle(.secondary)
        }
    }

    private func ending(_ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            StoryEyebrow(title: "沐沐的人生回憶冊", icon: "book.pages")
            Text("那些岔路，\n成了我的故事。")
                .font(.system(.largeTitle, design: .rounded).bold())
                .accessibilityIdentifier("journeyComplete")
            if !dynamicTypeSize.isAccessibilitySize {
                CompactStoryScene(age: session.state.age, person: session.traces.last?.recurringPerson ?? "", sceneID: "endingScene")
                    .frame(width: 160, height: 100)
            }
            Text("人生種子：\(String(session.state.seed))").font(.caption.monospaced()).foregroundStyle(.secondary)
                .accessibilityIdentifier("endingSeed").accessibilityValue(String(session.state.seed))
            branchActions
            Button("同背景、同種子，再走一次", systemImage: "arrow.counterclockwise") { restartAction = .sameSeed }
                .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("replaySame")
            Text("同樣的背景與運氣；做相同選擇才會重現，也可以嘗試改選。").font(.footnote).foregroundStyle(.secondary)
            Button("同背景，換個運氣", systemImage: "shuffle") { restartAction = .newSeed }
                .buttonStyle(.bordered).controlSize(.large).accessibilityIdentifier("replayNewSeed")
            Text("保留國家與家庭，改用新的種子；有些事件仍可能一樣。").font(.footnote).foregroundStyle(.secondary)
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
            ForEach(session.traces, id: \.age) { trace in
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
            Button("換個環境，開始新人生") { store.home() }.frame(maxWidth: .infinity)
            Text("人生種子：\(String(session.state.seed))").font(.caption.monospaced()).foregroundStyle(.secondary)
            Text("晚年回顧是本版故事收束，不表示角色在這個年齡死亡。")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var branchActions: some View {
        if let experiment = store.experiment {
            Text(store.viewingOriginal ? "這是保留的原人生，紀錄不會因改選而改寫。" : "這是你親自走完的另一條路，原人生仍在。")
                .font(.headline).accessibilityIdentifier("preservedOriginalStatus")
            if store.viewingOriginal {
                Button(experiment.alternative.phase == .ended ? "回到改選後的人生" : "繼續試走另一條路") { store.viewingOriginal = false }
                    .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("resumeBranch")
            } else {
                Button("看看保留的原人生") { store.viewingOriginal = true }
                    .buttonStyle(.bordered).accessibilityIdentifier("viewOriginal")
            }
            if experiment.alternative.phase == .ended {
                Button("比較完整後半生", systemImage: "arrow.left.arrow.right") {
                    guard let catalog = store.catalog else { return }
                    do { branchComparison = try BranchComparisonEngine.compare(experiment, catalog: catalog) }
                    catch { store.errorMessage = "比較紀錄無法驗證：\(error)" }
                }.buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("compareBranches")
            }
        } else {
            Button("回到一個重大岔路", systemImage: "arrow.triangle.branch") { showForkPicker = true }
                .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("openForkPicker")
            Text("原人生會保留。回到選擇前改選，接下來每一步仍由你決定。").font(.footnote)
        }
    }

    private var traceSheet: some View {
        Group {
            if let trace = store.session?.traces.last {
                DetailSheet(title: "為什麼會這樣？", closeID: "closeTrace") {
                    Text("我的選擇造成什麼變化？").font(.title3.bold())
                    Text(trace.influenceSummary).font(.headline).accessibilityIdentifier("actualInfluences")
                    if trace.randomTrial?.occurred == false {
                        Text("這次有檢查機會事件，但未觸發額外後果。").font(.footnote)
                    }
                    ForEach(Array((trace.costSteps.map(\.explanation) + trace.effectSteps.map(\.explanation)).enumerated()), id: \.offset) { _, line in
                        Text(line).padding(.vertical, 5)
                    }
                    if let branch = trace.storyBranch {
                        Text("故事如何接續？").font(.headline)
                        Text(branch.explanation).font(.subheadline)
                    }
                    selectionDetails(trace.eventSelection)
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
            Text("固定：這個實際事件、選項、年齡、家庭模板、選擇前的資源與種子。改變：環境指標，以及由它產生的模型成本。")
                .font(.footnote)
            if let selected = presentation.traces.first {
                Text("選前資源：健康\(selected.resourcesBefore.health) · 財務\(selected.resourcesBefore.financial) · 人際\(selected.resourcesBefore.relationships) · 技能\(selected.resourcesBefore.skills)")
                    .font(.caption).foregroundStyle(.secondary).accessibilityIdentifier("comparisonPreState")
                    .accessibilityValue("health=\(selected.resourcesBefore.health);financial=\(selected.resourcesBefore.financial);relationships=\(selected.resourcesBefore.relationships);skills=\(selected.resourcesBefore.skills)")
            }
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
            ForEach(session.traces, id: \.age) { trace in
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
        EventNarratives.texts[event.storyVariantID ?? event.id] ?? event.storyQuestion
    }

    private func shortStory(_ event: DecisionSkeleton) -> String {
        let text = storyText(event)
        return String(text.split(separator: "\n").first ?? Substring(text))
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
