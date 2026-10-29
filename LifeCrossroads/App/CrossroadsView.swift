import SwiftUI
import Charts
import LifeDomain
import LifeData
import LifePresentation

private let accent = StoryPalette.forest
private let worldPaper = StoryPalette.illustratedPaper

struct CrossroadsView: View {
    @StateObject private var store = GameStore()
    @AppStorage("shortStoryText") private var shortText = false
    private var showsLifeOverview: Bool { !ProcessInfo.processInfo.arguments.contains("-legacy-life-overview") }
    @State private var exploreBirth = false
    @State private var showParallelPicker = false
    @State private var parallelRows: [BranchComparisonRow]?
    @State private var showFocus = false
    @State private var showSources = false
    @State private var showTrace = false
    @State private var showEventStory = false
    @State private var showForkPicker = false
    @State private var branchComparison: BranchComparison?
    @State private var restartAction: RestartAction?
    private enum RestartAction { case newLife, randomLife, sameSeed, newSeed }

    @State private var comparisonPresentation: ComparisonPresentation?
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("reducedLifeMotion") private var reducedLifeMotion = false
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    private var reduceMotion: Bool { systemReduceMotion || reducedLifeMotion }
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOver
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            rootContent
            .background(store.worldPreviewEnabled ? worldPaper : StoryPalette.page)
            .navigationTitle("人生岔路")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if store.viewingOriginal {
                        Button("返回另一段", systemImage: "arrow.uturn.backward") { store.viewingOriginal = false }
                            .accessibilityIdentifier("resumeBranch")
                    } else if store.session != nil {
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
                if store.worldPreviewEnabled && store.session != nil && !store.viewingOriginal && store.session?.phase != .ended {
                    playbackControls
                } else if store.session?.phase == .reflecting {
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
            .sheet(isPresented: $store.showBirthReveal) {
                if let session = store.session, let catalog = store.catalog {
                    BirthRevealView(session: session, catalog: catalog) { store.showBirthReveal = false }
                }
            }
            .sheet(isPresented: $showParallelPicker, onDismiss: {
                // A sheet cannot present another sheet during its own dismissal.
                if store.parallelExperiment != nil { store.showBirthReveal = true }
            }) {
                if let original = store.session, let catalog = store.catalog {
                    ParallelBirthPicker(original: original, catalog: catalog) { country, household, sameTemplateOnly in
                        if store.startParallel(countryCode: country, householdID: household, sameTemplateOnly: sameTemplateOnly) {
                            store.showBirthReveal = false; showParallelPicker = false; return true
                        }
                        return false
                    }
                }
            }
            .sheet(isPresented: Binding(get: { parallelRows != nil }, set: { if !$0 { parallelRows = nil } })) {
                if let rows = parallelRows, let pair = store.parallelExperiment {
                    BranchComparisonView(rows: rows,
                        scope: "同一個願望：\(ParallelLifeExperiment.wish)。原來出生於\(store.name(pair.original.state.countryCode))，另一段出生於\(store.name(pair.alternative.state.countryCode))。家庭安排與後續選擇可能都不同；同種子僅配對共有機會的亂數。差異來自這兩段實際人生，不代表國家排名或現實因果。",
                        originalFinal: pair.original.state.resources, alternativeFinal: pair.alternative.state.resources,
                        title: "同一個願望，不同的出身",
                        backgrounds: "原本：\(store.catalog?.households.first { $0.id == pair.original.state.householdID }?.label ?? store.name(pair.original.state.countryCode))\n另一段：\(store.catalog?.households.first { $0.id == pair.alternative.state.householdID }?.label ?? store.name(pair.alternative.state.countryCode))")
                }
            }
            .confirmationDialog("建立新人生會取代本機的這組人生紀錄", isPresented: Binding(get: { restartAction != nil }, set: { if !$0 { restartAction = nil } }), titleVisibility: .visible, presenting: restartAction) { action in
                Button("取代紀錄並開始", role: .destructive) {
                    switch action {
                    case .sameSeed: store.start(replay: true)
                    case .newSeed: store.replayWithNewSeed()
                    case .newLife: store.start()
                    case .randomLife: store.start(randomBirth: true)
                    }
                    restartAction = nil
                }.accessibilityIdentifier("confirmRestart")
                Button("取消", role: .cancel) { restartAction = nil }.accessibilityIdentifier("cancelRestart")
            } message: { _ in Text("回首頁或關閉 App 都能保留進度；只有建立新人生才取代原局與試走路線。") }
            .sheet(isPresented: $showFocus) { focusSheet }
            .sheet(isPresented: $showSources) { sources }
            .sheet(isPresented: $showTrace) { traceSheet }
            .sheet(isPresented: $showEventStory) {
                if let event = store.currentEvent { fullEventStory(event) }
            }
            .sheet(item: $comparisonPresentation) { presentation in comparisonSheet(presentation) }
            .alert("需要留意", isPresented: Binding(get: { store.errorMessage != nil }, set: { if !$0 { store.dismissError() } })) {
                Button("知道了") { store.dismissError() }
            } message: { Text(store.errorMessage ?? "") }
            .onChange(of: worldSuspended) { _, value in store.suspendWorld(value) }
            .onChange(of: voiceOver) { _, enabled in if enabled { store.pauseWorld(true) } }
            .onDisappear { store.suspendWorld(true) }
            .task(id: worldTaskID) {
                store.suspendWorld(worldSuspended)
                if voiceOver { store.pauseWorld(true) }
                while store.canAnimateWorld && !worldSuspended {
                    do { try await Task.sleep(for: .milliseconds(reduceMotion ? 250 : 50)) }
                    catch { return }
                    guard !Task.isCancelled, !worldSuspended else { return }
                    store.pulseWorld()
                }
            }
        }.foregroundStyle(StoryPalette.ink).tint(accent)
    }

    @ViewBuilder private var rootContent: some View {
        if showsLifeOverview, let session = store.session, let catalog = store.catalog {
            lifeOverview(session, catalog: catalog)
        } else if store.worldPreviewEnabled, !store.viewingOriginal,
           let session = store.session, session.phase != .ended, let world = store.world {
            worldLayout(world, session)
        } else {
            legacyPage
        }
    }

    private var legacyPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let session = store.session { sessionContent(session) }
                else { home }
                archiveChecksum
            }
            .padding(18).frame(maxWidth: 620).frame(maxWidth: .infinity)
        }
        .id(store.session.map { "\($0.phase.rawValue)-\($0.state.age)" } ?? "home")
    }

    /// One pinned world survives phase changes; only the decision drawer scrolls/resets.
    private func worldLayout(_ world: LifeWorldFrame, _ session: LifeSession) -> some View {
        GeometryReader { viewport in
            let sceneHeight = dynamicTypeSize.isAccessibilitySize
                ? min(210, max(160, viewport.size.height * 0.32))
                : min(300, max(210, viewport.size.height * 0.45))
            VStack(spacing: -12) {
                worldStage(world, height: sceneHeight)
                    .padding(.horizontal, 12).padding(.top, 8).padding(.bottom, 16)
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Capsule().fill(accent.opacity(0.25)).frame(width: 36, height: 4)
                            .frame(maxWidth: .infinity).accessibilityHidden(true)
                        if store.playback.phase == .living { living(session) }
                        else { sessionContent(session) }
                        archiveChecksum
                    }
                    .padding(.horizontal, 18).padding(.top, 12).padding(.bottom, 18)
                    .frame(maxWidth: 620).frame(maxWidth: .infinity)
                }
                .id("drawer-\(session.phase.rawValue)-\(session.state.age)-\(store.playback.phase.rawValue)")
                .accessibilityIdentifier("worldDecisionDrawer")
                .frame(maxHeight: .infinity)
                .background(worldPaper, in: UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24))
                .overlay(alignment: .top) {
                    UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                        .stroke(accent.opacity(0.15), lineWidth: 1).allowsHitTesting(false)
                }
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24))
            }
        }
    }

    @ViewBuilder private func sessionContent(_ session: LifeSession) -> some View {
        switch session.phase {
        case .ended: ending(session)
        case .choosing:
            if !showsLifeOverview { progress(session) }
            if let event = store.currentEvent { decision(event, session) }
            else { Text("目前無法取得下一件事，請回首頁重新開始。").accessibilityIdentifier("missingEvent") }
        case .reflecting:
            if !showsLifeOverview { progress(session) }
            if let trace = session.traces.last { feedback(trace) }
            else { Text("目前沒有已執行的選擇紀錄。").accessibilityIdentifier("missingOutcome") }
        }
    }

    @ViewBuilder private var archiveChecksum: some View {
#if targetEnvironment(simulator)
        if let checksum = store.uiTestArchiveChecksum {
            Text("自動化測試存檔校驗").font(.caption2)
                .accessibilityIdentifier("uiTestArchiveChecksum").accessibilityValue(checksum)
        }
#endif
    }

    private var worldSuspended: Bool {
        scenePhase != .active || store.showingHome || store.viewingOriginal || !store.worldPreviewEnabled
            || showParallelPicker || store.showBirthReveal || parallelRows != nil
            || showSources || showTrace || showEventStory || showFocus || showForkPicker || branchComparison != nil
            || comparisonPresentation != nil || restartAction != nil || store.errorMessage != nil
    }
    private var worldTaskID: String {
        "\(worldSuspended)-\(store.canAnimateWorld)-\(store.playback.phaseToken)-\(reduceMotion)-\(voiceOver)"
    }
    private func worldStage(_ world: LifeWorldFrame, height: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            if !dynamicTypeSize.isAccessibilitySize {
                Text("共用想像場景 · 非各國實景")
                    .font(.caption2).foregroundStyle(StoryPalette.secondaryInk).padding(.horizontal, 8)
                    .accessibilityHidden(true) // Also retained in the scene's spoken label.
            }
        LifeWorldScene(frame: world, motion: store.playback.motion(reduceMotion: reduceMotion))
            .frame(height: height)
            // Decorative poses and outcome tokens must not enlarge the VoiceOver hit region.
            .contentShape(.accessibility, Rectangle())
            .overlay(alignment: .topTrailing) {
#if targetEnvironment(simulator)
                if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
                    Text("生活播放狀態").font(.system(size: 1)).foregroundStyle(.clear)
                        .accessibilityIdentifier("worldPlaybackState")
                        .accessibilityValue(Text(verbatim: "\(store.playback.phase.rawValue)|\(store.playback.paused)|\(world.age)|\(store.session?.traces.count ?? -1)|\(store.playback.phaseToken)|sceneHeight=\(height)|reduceMotion=\(reduceMotion)|largeType=\(dynamicTypeSize.isAccessibilitySize)|phaseMs=\(Int(store.playback.phaseElapsedMs))"))
                }
#endif
            }
        }
    }
    private func living(_ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(store.playback.paused ? "生活暫停了" : "生活，還在繼續。")
                .font(.title2.bold()).accessibilityIdentifier("livingTitle")
            Text("\(store.world?.visualFromAge ?? session.state.age)～\(session.state.age)歲 · 走向下一段故事")
                .accessibilityIdentifier("livingInterval")
            ProgressView(value: store.playback.progress).accessibilityLabel("這段生活的播放進度")
            Text("遇到需要決定的事，生活會停下來等你。你也能直接跳至事件。")
            if let world = store.world {
                ForEach(Array(world.worldChanges.enumerated()), id: \.offset) { _, change in
                    Text(change.caption).font(.subheadline)
                        .accessibilityIdentifier("worldChange.\(change.kind.rawValue)")
                }
            }
        }
    }
    private var playbackControls: some View {
        HStack(spacing: 12) {
            Button { store.pauseWorld(!store.playback.paused) } label: {
                Image(systemName: store.playback.paused ? "play.fill" : "pause.fill")
                    .font(.system(size: 20, weight: .semibold)).frame(width: 44, height: 44)
            }
            .accessibilityLabel(store.playback.paused ? "繼續播放" : "暫停播放")
            .accessibilityIdentifier("worldPause")
            if dynamicTypeSize.isAccessibilitySize {
                Menu {
                    Button(store.playback.speed == .normal ? "加速 3×" : "正常 1×") {
                        toggleWorldSpeed()
                    }.accessibilityIdentifier("worldSpeed")
                } label: {
                    Image(systemName: "slider.horizontal.3").font(.system(size: 20))
                        .frame(width: 44, height: 44)
                }.accessibilityLabel("播放設定").accessibilityIdentifier("worldPlaybackOptions")
            } else {
                Button(store.playback.speed == .normal ? "1×" : "3×") { toggleWorldSpeed() }
                    .font(.subheadline.weight(.semibold)).frame(minWidth: 44, minHeight: 44)
                    .accessibilityLabel(store.playback.speed == .normal ? "加速 3×" : "正常 1×")
                    .accessibilityIdentifier("worldSpeed")
            }
            Spacer(minLength: 0)
            if store.playback.phase == .living {
                Button { store.skipWorld() } label: {
                    playbackActionLabel("跳至事件", symbol: "forward.end.fill")
                }.accessibilityLabel("跳至事件").accessibilityIdentifier("skipLiving")
            } else if store.session?.phase == .reflecting {
                Button { store.skipWorld() } label: {
                    playbackActionLabel("繼續生活", symbol: "arrow.right")
                }
                .accessibilityLabel(store.session.map { $0.traces.count == $0.plannedDecisionCount } == true ? "翻開人生回憶冊" : "繼續生活")
                .accessibilityIdentifier("continueLife")
            }
        }
        .frame(height: 44)
        .buttonStyle(.plain)
        .padding(.horizontal, 12).padding(.vertical, 4)
        .background(worldPaper, ignoresSafeAreaEdges: [])
        .overlay(alignment: .top) { Rectangle().fill(accent.opacity(0.2)).frame(height: 1) }
        .contentShape(.accessibility, Rectangle())
        .accessibilityElement(children: .contain).accessibilityIdentifier("worldPlaybackControls")
    }

    @ViewBuilder private func playbackActionLabel(_ title: String, symbol: String) -> some View {
        if dynamicTypeSize.isAccessibilitySize {
            Image(systemName: symbol).font(.system(size: 20, weight: .semibold)).frame(width: 44, height: 44)
        } else {
            Label(title, systemImage: symbol).font(.subheadline.weight(.semibold))
                .frame(minHeight: 44)
        }
    }
    private func toggleWorldSpeed() {
        store.speedWorld(store.playback.speed == .normal ? .fast : .normal)
    }

    private var home: some View {
        VStack(alignment: .leading, spacing: 22) {
            if store.journey != nil {
                Button("繼續已保存的人生", systemImage: "book") { store.resume() }
                    .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("resumeLife")
            }
            StoryEyebrow(title: "一本由你參與的人生故事", icon: "book.closed")
            Text("P1 整合預覽 0.1 · 八國完整人生")
                .font(.caption.weight(.semibold))
                .foregroundStyle(StoryPalette.secondaryInk)
                .accessibilityLabel("P1 整合預覽版，八國完整人生，仍待資料、美術與兒少測試驗收")
                .accessibilityIdentifier("previewBuildStatus")
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
            Button("翻開未知的人生", systemImage: "sparkles") {
                if store.journey != nil || store.restoreFailed { restartAction = .randomLife }
                else { store.start(randomBirth: true) }
            }.buttonStyle(JourneyButtonStyle()).disabled(store.catalog == nil)
                .accessibilityIdentifier("randomBirth")
            Text(BirthDraw.scope).font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
            DisclosureGroup(isExpanded: $exploreBirth) {
                VStack(alignment: .leading, spacing: 18) {
                    StoryEyebrow(title: "第一頁 · 選一個起點", icon: "map")
                    Text("這次，從哪裡開始？").font(.title3.bold())
                    countryPicker
                    familyPicker
                    if let household = store.selectedHousehold {
                        Text(household.label).font(.subheadline).fixedSize(horizontal: false, vertical: true)
                        Text("兩種家庭各有支持與限制，是虛構示例，不代表這個國家的每個家庭。")
                            .font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
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
            } label: { Text("探索指定出身").accessibilityIdentifier("exploreBirth") }
            Toggle("生活世界預覽", isOn: $store.worldPreviewEnabled)
                .accessibilityIdentifier("LifeWorldPreview")
            Toggle("減少動態效果", isOn: $reducedLifeMotion)
                .accessibilityIdentifier("worldReduceMotion")
            Text("關閉可回到事件優先介面；使用同一份人生與存檔。")
                .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
            Toggle("使用較短的故事文字", isOn: $shortText).font(.subheadline)
            Text("15段選擇，沒有唯一的好人生。環境影響機會，選擇留下故事，也有些事不由自己控制。")
                .font(.subheadline).foregroundStyle(StoryPalette.secondaryInk)
            Text("動物角色演出虛構故事；所有國家共用這座想像的河畔舞台，不是各國生活的實景。包含工作變動與照顧情境，可休息或回首頁。每次操作自動保存一組人生；關閉後可續玩。建立新人生會先詢問是否取代紀錄。")
                .font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
        }
    }

    @ViewBuilder
    private var countryPicker: some View {
        if dynamicTypeSize.isAccessibilitySize {
            Picker("出生國家", selection: $store.countryCode) {
                ForEach(store.countries, id: \.code) { Text($0.name).tag($0.code) }
            }.pickerStyle(.menu).accessibilityIdentifier("countryPicker")
        } else {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(store.countries, id: \.code) { country in
                    Button { store.countryCode = country.code } label: {
                        Text(country.name).frame(maxWidth: .infinity, minHeight: 44)
                            .background(store.countryCode == country.code ? Color.accentColor.opacity(0.18) : Color.secondary.opacity(0.06), in: RoundedRectangle(cornerRadius: 10))
                    }.buttonStyle(.plain).accessibilityIdentifier("country.\(country.code)")
                        .accessibilityAddTraits(store.countryCode == country.code ? .isSelected : [])
                }
            }.accessibilityIdentifier("countryPicker")
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

    @ViewBuilder private func progress(_ session: LifeSession) -> some View {
        if store.worldPreviewEnabled {
            HStack {
                Text("沐沐 · \(session.state.age)歲 · \(store.name(session.state.countryCode))").font((dynamicTypeSize.isAccessibilitySize ? Font.caption : .subheadline).weight(.semibold))
                Spacer(minLength: 4)
                Text("\(min(15, session.traces.count + (session.phase == .choosing ? 1 : 0))) / 15").font(.caption.monospacedDigit())
            }
            if store.comparisonOriginal != nil {
                Button("查看保留的原人生") { store.viewingOriginal = true }.accessibilityIdentifier("viewOriginal")
            }
        } else {
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
                    .font(.caption.monospacedDigit()).foregroundStyle(StoryPalette.secondaryInk)
            }
            Text("\(store.name(session.state.countryCode)) · \(stageName(session.state.age))")
                .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
            ProgressView(value: Double(session.traces.count), total: Double(session.plannedDecisionCount))
                .accessibilityLabel("已完成\(session.traces.count)段，共\(session.plannedDecisionCount)段")
        }
        }
    }

    private func decision(_ event: DecisionSkeleton, _ session: LifeSession) -> some View {
        VStack(alignment: .leading, spacing: store.worldPreviewEnabled ? 12 : 16) {
            VStack(alignment: .leading, spacing: 11) {
                HStack(alignment: .center, spacing: 12) {
                    Text(event.title).font(store.worldPreviewEnabled ? .title3.bold() : .title2.bold()).accessibilityIdentifier("eventTitle")
                        .accessibilityValue(event.id).accessibilityAddTraits(.isHeader)
                    if store.worldPreviewEnabled || showsLifeOverview {
                        Spacer(minLength: 0)
                        Button { showEventStory = true } label: {
                            Label("閱讀全文", systemImage: "text.alignleft").font(.caption)
                                .frame(minWidth: 44, minHeight: 44)
                        }
                        .accessibilityLabel("閱讀完整事件")
                        .accessibilityIdentifier("readFullEvent")
                    }
                    if !store.worldPreviewEnabled && !showsLifeOverview && !dynamicTypeSize.isAccessibilitySize {
                        Spacer(minLength: 0)
                        if event.id == "teen-project" {
                            ProjectWorkshopView(moment: nil, compact: true).frame(width: 118, height: 88)
                        } else {
                            CompactStoryScene(age: session.state.age, person: event.recurringPerson, sceneID: "decisionScene")
                                .frame(width: 88, height: 68)
                        }
                    }
                }
                Text(shortStory(event)).font(store.worldPreviewEnabled ? .subheadline : .body).lineSpacing(3).lineLimit(store.worldPreviewEnabled ? 2 : nil)
                    .fixedSize(horizontal: false, vertical: true)
                if !store.worldPreviewEnabled { Text(event.storyQuestion).font(.subheadline.weight(.semibold)) }
                if event.id == "teen-project" && !store.worldPreviewEnabled {
                    Text("創作桌：圖解、材料，也可以先休息。共用想像場景，非各國實景。")
                        .font(.caption).foregroundStyle(StoryPalette.secondaryInk).accessibilityIdentifier("projectSceneCaption")
                }
            }
            if !showsLifeOverview && store.worldPreviewEnabled {
                Text("可用時間\(session.state.remainingTime) · 精力\(session.state.remainingEnergy) · 材料\(session.state.remainingMaterials)").font(.caption)
            } else if !showsLifeOverview {
            Text("你會怎麼安排？").font(.headline).accessibilityAddTraits(.isHeader)
            ViewThatFits(in: .horizontal) {
                budget(session, vertical: false)
                budget(session, vertical: true)
            }
            }
            if showsLifeOverview {
                if event.id == "teen-project", let preview = store.preview("invest") {
                    Text(BirthStory.creationContext(preview: preview)).font(.caption)
                        .accessibilityIdentifier("creationEnvironment")
                }
                DisclosureGroup {
                    Text("本回合可用時間\(session.state.remainingTime)、精力\(session.state.remainingEnergy)、材料\(session.state.remainingMaterials)")
                    ForEach(event.choices, id: \.id) { choice in
                        if let p = store.preview(choice.id) {
                            Text("\(choice.title)：時間\(p.finalCost.time)、精力\(p.finalCost.energy)、材料\(p.finalCost.materials)")
                        }
                    }
                } label: { Text("選擇需要的時間與準備").accessibilityIdentifier("choicePreparation") }
                .font(.caption)
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
                            if !showsLifeOverview {
                                Text("時間\(preview.finalCost.time) · 精力\(preview.finalCost.energy) · 材料\(preview.finalCost.materials)")
                                    .font(.subheadline.weight(.semibold))
                            }
                            if !preview.environmentGaps.isEmpty {
                                Text("家庭試算；部分環境成本未知，不能作跨國總成本比較。")
                                    .font(.caption).accessibilityIdentifier("choiceDataLimit.\(choice.id)")
                            }
                            if !showsLifeOverview { Text("基本影響：\(deltaText(choice.effect))").font(.caption).foregroundStyle(StoryPalette.secondaryInk) }
                            if !preview.applied {
                                Text(preview.unavailableReasons.joined(separator: "\n")).font(.footnote)
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
                        .padding(store.worldPreviewEnabled ? 12 : 18)
                        .background(store.worldPreviewEnabled ? worldPaper : Color(.systemBackground), in: RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(accent.opacity(0.18), lineWidth: 1))
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(preview.applied ? StoryPalette.ink : StoryPalette.secondaryInk)
                    .disabled(!preview.applied).accessibilityIdentifier("choice.\(choice.id)")
                }
            }
            if showsLifeOverview {
                DisclosureGroup("查看各行動的基本影響") {
                    ForEach(event.choices, id: \.id) { choice in
                        Text("\(choice.title)：\(deltaText(choice.effect))").font(.caption)
                    }
                    Text("這是基本試算；支持、機會與上限會影響最後結果。").font(.caption)
                }
            }
            if store.worldPreviewEnabled && !session.traces.isEmpty {
                Button("回看剛才的選擇與原因", systemImage: "clock.arrow.circlepath") { showTrace = true }
                    .frame(minHeight: 44).accessibilityIdentifier("whyPrevious")
            }
            Menu {
                ForEach(event.choices, id: \.id) { choice in
                    Button(choice.title) { presentComparison(choice.id) }
                        .accessibilityIdentifier("compare.\(choice.id)")
                }
            } label: {
                Label("單一事件快比：同一行動，換個環境？", systemImage: "arrow.triangle.branch")
                    .font(.subheadline.weight(.semibold)).frame(minHeight: 44)
            }.accessibilityIdentifier("compareChoice")
            if event.id == "teen-project" {
                Text("試算線上與紙本選項：只有需要網路的行動，才會使用數位環境規則。比較不會替你選擇。")
                    .font(.footnote).foregroundStyle(StoryPalette.secondaryInk).accessibilityIdentifier("digitalLearningGuide")
            }
            if store.worldPreviewEnabled || !shortText {
                DisclosureGroup("完整故事與問題") {
                    Text(storyText(event)).lineSpacing(4).padding(.top, 10)
                    Text(event.storyQuestion).font(.headline)
                }
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
                .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
            Text("人生種子：\(String(session.state.seed))").font(.caption2.monospaced()).foregroundStyle(StoryPalette.secondaryInk)
                .accessibilityIdentifier("lifeSeed").accessibilityValue(String(session.state.seed))
        }
    }

    private func selectionDetails(_ selection: EventSelectionTrace) -> some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 10) {
                Text(selection.summary).font(.subheadline).accessibilityIdentifier("eventSelectionSummary")
                if let selected = selection.candidates.first(where: { $0.eventID == selection.selectedEventID }) {
                    if selection.assumptionID == "creative-opportunities" {
                        Text("這次是先前創作選擇留下的後續商量；其他候選的排除原因列有來源事件。邀請不代表已完成作品或得到工作。")
                    } else if selected.conditions.isEmpty {
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
                    .font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
                Text("種子：\(String(selection.seed)) · 候選\(selection.candidates.count)件 · 符合條件\(selection.eligibleEventIDs.count)件")
                    .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
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

    private func presentComparison(_ choiceID: String, households: Bool = false) {
        let traces = store.compare(choiceID: choiceID, households: households)
        if !traces.isEmpty {
            let alternatives = Dictionary(uniqueKeysWithValues: traces.map { ($0.householdID, store.alternatives(for: $0)) })
            comparisonPresentation = .init(traces: traces, households: households, alternatives: alternatives)
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
        let moment = ProjectMoment(trace: trace)
        return VStack(alignment: .leading, spacing: 16) {
            if !dynamicTypeSize.isAccessibilitySize {
                StoryEyebrow(title: "這次選擇之後", icon: "bookmark")
            }
            HStack(spacing: 12) {
                Text(trace.choiceTitle).font(dynamicTypeSize.isAccessibilitySize ? .headline : .title2.bold())
                    .accessibilityIdentifier("chosenAction")
                    .accessibilityValue(trace.choiceID)
                if !store.worldPreviewEnabled && trace.eventID != "teen-project" && !dynamicTypeSize.isAccessibilitySize {
                    Spacer(minLength: 0)
                    CompactStoryScene(age: trace.age, person: trace.recurringPerson, sceneID: "reflectionScene")
                        .frame(width: 88, height: 68)
                }
            }
            Text(trace.eventTitle).font(.subheadline).foregroundStyle(StoryPalette.secondaryInk)
                .accessibilityIdentifier("outcomeEvent").accessibilityValue(trace.eventID)
            if let moment { ProjectWorkshopView(moment: moment, showArtwork: !store.worldPreviewEnabled, showMetrics: !showsLifeOverview) }
            if showsLifeOverview {
                if moment == nil, let arrival = store.session?.jumps.last {
                    ForEach(Array(LifeStoryComparison.consequences(trace, arrival: arrival).enumerated()), id: \.offset) { _, text in
                        Text(text).font(.subheadline)
                    }
                }
                DisclosureGroup {
                    outcomeCalculation(trace, moment: moment)
                } label: { Text("這次用掉的準備與實際變化").accessibilityIdentifier("outcomeDetails") }
            } else { outcomeCalculation(trace, moment: moment) }
            Button("為什麼會這樣？", systemImage: "questionmark.circle") { showTrace = true }
                .buttonStyle(.bordered).controlSize(.large).accessibilityIdentifier("whyResult")
            Button("比較剛才的行動", systemImage: "arrow.triangle.branch") { presentComparison(trace.choiceID) }
                .buttonStyle(.bordered).controlSize(.large).accessibilityIdentifier("compareChosen")
            if let branch = trace.storyBranch {
                VStack(alignment: .leading, spacing: 10) {
                    StoryEyebrow(title: "過去的選擇，如何走到這一頁", icon: "arrow.triangle.branch")
                    if showsLifeOverview {
                        DisclosureGroup("展開故事接續的規則") {
                            Text(branch.explanation).font(.subheadline).accessibilityIdentifier("storyBranchExplanation")
                        }
                    } else {
                        Text(branch.explanation).font(.subheadline).lineSpacing(4).accessibilityIdentifier("storyBranchExplanation")
                    }
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
            if trace.eventID != "teen-project" && !trace.scheduledHooks.isEmpty {
                VStack(alignment: .leading, spacing: 9) {
                    Label("已留下的線索 · 還沒發生", systemImage: "clock").font(.headline)
                    Text("這次的行動已記入延後故事；到了後面的年齡，才會知道這段線索如何接續。")
                }.card()
            }
            selectionDetails(trace.eventSelection)
            Text("時間、精力和材料額度只用於這一回合；下一回合會重新安排，剩下的格數不會累積。")
                .font(.footnote).foregroundStyle(StoryPalette.secondaryInk).accessibilityIdentifier("roundBudgetExplanation")
            Text("健康、財務安全、人際與技能會延續；選擇也會留下紀錄。沒有唯一正確的答案，下一段仍能調整或求助。")
                .font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
        }
    }

    private func outcomeCalculation(_ trace: ConsequenceTrace, moment: ProjectMoment?) -> some View {
        VStack(alignment: .leading, spacing: 13) {
                Label("已發生的變化", systemImage: "checkmark.circle").font(.headline)
                Text(deltaText(moment?.actualChange ?? (trace.resourcesAfter - trace.resourcesBefore))).font(.headline)
                    .accessibilityIdentifier("outcomeResources")
                    .accessibilityValue(historyResources(trace))
                Text("這一段日子，沐沐用了\(trace.finalCost.time)格時間，有\(trace.budgetAfter.time)格沒有用在這個行動上。")
                    .lineSpacing(3).accessibilityIdentifier("roundTimeFeedback")
                if trace.eventID != "teen-project" && trace.randomTrial?.occurred == true {
                    Label("這次，也意外收到別人的鼓勵。", systemImage: "sparkle")
                }
        }.card()
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
            Text("人生種子：\(String(session.state.seed))").font(.caption.monospaced()).foregroundStyle(StoryPalette.secondaryInk)
                .accessibilityIdentifier("endingSeed").accessibilityValue(String(session.state.seed))
            branchActions
            Button("同背景、同種子，再走一次", systemImage: "arrow.counterclockwise") { restartAction = .sameSeed }
                .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("replaySame")
            Text("同樣的背景與運氣；做相同選擇才會重現，也可以嘗試改選。").font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
            Button("同背景，換個運氣", systemImage: "shuffle") { restartAction = .newSeed }
                .buttonStyle(.bordered).controlSize(.large).accessibilityIdentifier("replayNewSeed")
            Text("保留國家與家庭，改用新的種子；有些事件仍可能一樣。").font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
            Text("有選擇，有限制，也有一路相伴的人。這些數字描述故事裡的變化，不評定人生的價值。")
                .foregroundStyle(StoryPalette.secondaryInk)
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
                            .accessibilityIdentifier("history.\(trace.age).event").accessibilityValue(trace.eventID)
                        Text(trace.choiceTitle).font(.subheadline)
                            .accessibilityIdentifier("history.\(trace.age).choice").accessibilityValue(trace.choiceID)
                        if let branch = trace.storyBranch {
                            Text(branch.explanation).font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
                        }
                        Text(deltaText(trace.resourcesAfter - trace.resourcesBefore))
                            .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
                            .accessibilityIdentifier("history.\(trace.age).resources").accessibilityValue(historyResources(trace))
                    }.fixedSize(horizontal: false, vertical: true)
                    if let companion = StoryCharacter.companion(named: trace.recurringPerson) {
                        StoryPortrait(character: companion).frame(width: 48, height: 48)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading).card()
            }
            Button("換個環境，開始新人生") { store.home() }.frame(maxWidth: .infinity)
            Text("人生種子：\(String(session.state.seed))").font(.caption.monospaced()).foregroundStyle(StoryPalette.secondaryInk)
            Text("晚年回顧是本版故事收束，不表示角色在這個年齡死亡。")
                .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
        }
    }

    @ViewBuilder
    private var branchActions: some View {
        if let experiment = store.experiment {
            Text(store.viewingOriginal ? "這是保留的原人生，紀錄不會因改選而改寫。" : "這是你親自走完的另一條路，原人生仍在。")
                .font(.headline).accessibilityIdentifier("preservedOriginalStatus")
            if store.viewingOriginal {
                Text("隨時可用左上角返回另一段人生。").font(.caption)
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
        } else if let pair = store.parallelExperiment {
            Text("原人生完整保留；另一個出身的每一步仍由你選。").font(.headline)
                .accessibilityIdentifier("preservedOriginalStatus")
            if !store.viewingOriginal {
                Button("看看保留的原人生") { store.viewingOriginal = true }
                    .buttonStyle(.bordered).accessibilityIdentifier("viewOriginal")
            }
            if pair.alternative.phase == .ended {
                Button("看看兩段人生留下的故事") {
                    guard let catalog = store.catalog else { return }
                    do { parallelRows = try pair.comparison(catalog: catalog) }
                    catch { store.errorMessage = "比較紀錄無法驗證：\(error)" }
                }.buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("compareParallel")
            }
        } else {
            Button("帶著同一個願望，換個出身", systemImage: "globe") { showParallelPicker = true }
                .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("openParallelPicker")
            Button("回到一個重大岔路", systemImage: "arrow.triangle.branch") { showForkPicker = true }
                .buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("openForkPicker")
            Text("原人生會保留。回到選擇前改選，接下來每一步仍由你決定。").font(.footnote)
        }
    }

    private func historyResources(_ trace: ConsequenceTrace) -> String {
        func describe(_ value: ResourceValues) -> String {
            "健康\(value.health) · 財務\(value.financial) · 人際\(value.relationships) · 技能\(value.skills)"
        }
        return "選前：\(describe(trace.resourcesBefore))；選後：\(describe(trace.resourcesAfter))"
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
                            Text("\(observation.title ?? observation.indicator)：\(value, specifier: "%.2f") \(observation.unit)（\(observation.year.formatted(.number.grouping(.never))))")
                                .font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
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
                .accessibilityValue(presentation.comparisonStatus)
            if let selected = presentation.traces.first, selected.age < 13 {
                Text("到了13歲，試著比較線上創作與紙本學習：需要網路的行動，才會使用數位環境規則。看看準備成本是否不同，再選自己想走的路。")
                    .font(.subheadline)
                    .accessibilityIdentifier("digitalComparisonInvitation")
            }
            if !presentation.households, let selected = presentation.traces.first {
                Button("也看看同國不同家庭的安排") { presentComparison(selected.choiceID, households: true) }
                    .accessibilityIdentifier("compareHouseholds")
            }
            Text(presentation.households ? "固定事件、年齡、Seed、前史和選前資源，只改當回合家庭安排與材料預算。不是改寫出生家庭後的完整人生。" : "固定：這個實際事件、選項、年齡、家庭模板、選擇前的資源與種子。改變：環境指標，以及由它產生的模型成本。")
                .font(.footnote)
            if let selected = presentation.traces.first {
                Text("選前資源：健康\(selected.resourcesBefore.health) · 財務\(selected.resourcesBefore.financial) · 人際\(selected.resourcesBefore.relationships) · 技能\(selected.resourcesBefore.skills)")
                    .font(.caption).foregroundStyle(StoryPalette.secondaryInk).accessibilityIdentifier("comparisonPreState")
                    .accessibilityValue("health=\(selected.resourcesBefore.health);financial=\(selected.resourcesBefore.financial);relationships=\(selected.resourcesBefore.relationships);skills=\(selected.resourcesBefore.skills)")
            }
            ForEach(presentation.traces, id: \.householdID) { trace in
                VStack(alignment: .leading, spacing: 8) {
                    Text(presentation.households ? (store.catalog?.households.first { $0.id == trace.householdID }?.label ?? trace.householdID) : store.name(trace.countryCode)).font(.title3.bold())
                    if trace.environmentGaps.isEmpty {
                    Text("時間\(trace.finalCost.time) · 精力\(trace.finalCost.energy) · 材料\(trace.finalCost.materials)")
                    Label(trace.applied ? "目前可以安排" : "目前資源不足，還能求助或休息",
                          systemImage: trace.applied ? "checkmark.circle" : "clock.badge.questionmark")
                        .font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
                    if trace.applied { Text(deltaText(trace.resourcesAfter - trace.resourcesBefore)).font(.footnote) }
                    } else {
                        Text("資料不足以比較總成本與可行性。不是成本為0或沒有服務。")
                            .accessibilityIdentifier("comparisonDataLimit.\(trace.countryCode)")
                        Text(trace.environmentGaps.joined(separator: "\n")).font(.footnote)
                    }
                    Text(trace.costSteps.filter { $0.ruleID.hasPrefix("support.") }.map(\.explanation).joined(separator: "\n")).font(.footnote)
                    if !trace.unavailableReasons.isEmpty { Text(trace.unavailableReasons.joined(separator: "\n")).font(.footnote) }
                    ForEach(presentation.alternatives[trace.householdID] ?? [], id: \.id) { action in
                        Text("可行替代：\(action.title)\(action.environmentGaps.isEmpty ? "" : "（家庭試算，環境成本未估）")").font(.footnote)
                    }
                    ForEach(trace.recordedStoryFacts, id: \.key) { fact in
                        Text(storyFactText(fact)).font(.footnote)
                    }
                }.card()
            }
            Text("這是模型內的情境比較，不能證明現實因果，也不代表哪個國家或人生比較有價值。國內也有不同家庭與可取得的支持。")
                .font(.footnote).foregroundStyle(StoryPalette.secondaryInk)
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
            Text("本版包含網路、電力、醫療直接自付及經常醫療支出背景；台灣定義不同的原生指標另列。家庭、成本門檻、資源變動與機會事件是遊戲假設，不是個人成功機率。")
            Text("不含寫實傷害內容；遇到工作或照顧情境，可以選休息或回首頁。短文模式可在首頁開啟。")
            if let catalog = store.catalog {
                ForEach(catalog.sources, id: \.id) { source in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(catalog.countries.flatMap(\.indicators).first { $0.sourceID == source.id }?.title ?? source.indicator).font(.headline)
                        Text("2023年 · \(source.publisher)").font(.subheadline)
                        Text(source.attribution).font(.caption)
                        if let url = URL(string: source.url) { Link("原始來源與授權", destination: url) }
                        if let url = URL(string: source.licenseURL) { Link("授權條款：\(source.license)", destination: url) }
                    }.card()
                }
                Text("八國可玩；台灣部分環境成本未估算，資料不足不代表沒有服務。共用故事未聲稱重現各國制度；仍待在地內容與兒少實測。").font(.footnote)
                DisclosureGroup("查看遊戲設計假設") {
                    ForEach(catalog.assumptions, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.statement); Text(item.limitation).foregroundStyle(StoryPalette.secondaryInk)
                        }.font(.footnote).padding(.vertical, 8)
                    }
                }
            }
        }
    }

    private func storyText(_ event: DecisionSkeleton) -> String {
        if showsLifeOverview, let session = store.session {
            let story = LifeNarrative.text(event: event, state: session.state)
            if event.id == "teen-project", let household = store.catalog?.households.first(where: { $0.id == session.state.householdID }),
               let preview = store.preview("invest") {
                return "你想嘗試做出自己的第一件作品。" + BirthStory.household(household) + "\n" + BirthStory.creationContext(preview: preview) + "\n" + story
            }
            return story
        }
        return EventNarratives.texts[event.storyVariantID ?? event.id] ?? event.storyQuestion
    }

    private func storyFactText(_ fact: StoryFact) -> String {
        let names = ["friendship": "朋友約定", "learning": "作品經驗", "care": "共同照顧安排",
                     "repair": "修理經驗", "kitchen": "共煮經驗", "garden": "花圃經驗", "nature": "自然觀察", "creative": "創作協作經驗"]
        let values = ["online": "線上創作", "paper": "紙本創作", "none": "暫未製作",
                      "shared": "已共同安排", "seeking": "正在尋找協助，尚未保證獲得支持",
                      "paused": "暫緩安排", "connected": "保留聯絡", "practiced": "已練習",
                      "tending": "已參與照料", "observing": "已參與觀察", "remote": "已參與遠距共同草稿", "collective": "已參與面對面共作"]
        return "試算會留下的故事記錄：\(names[fact.key] ?? fact.key)・\(values[fact.value] ?? fact.value)。未來邀請仍有條件與機會限制。"
    }

    private func fullEventStory(_ event: DecisionSkeleton) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(event.title).font(.title2.bold()).accessibilityAddTraits(.isHeader)
                    ForEach(Array(storyText(event).components(separatedBy: "\n").enumerated()), id: \.offset) { index, paragraph in
                        Text(paragraph).fixedSize(horizontal: false, vertical: true)
                            .accessibilityIdentifier("eventStoryParagraph.\(index)")
                    }
                    Text(event.storyQuestion).font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("eventStoryQuestion")
                }
                .padding(20).frame(maxWidth: 620, alignment: .leading).frame(maxWidth: .infinity)
            }
            .accessibilityIdentifier("eventStoryScroll")
            .navigationTitle("完整事件").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("回到選擇") { showEventStory = false }.accessibilityIdentifier("closeFullEvent")
                }
            }
        }
    }

    private func shortStory(_ event: DecisionSkeleton) -> String {
        if showsLifeOverview { return String(storyText(event).split(separator: "\n").first ?? "") }
        if event.id == "teen-project" {
            return "樹老師備好創作圖解。你可以選線上、借紙本、先商量，也可以保留課後時間。"
        }
        let text = storyText(event)
        return String(text.split(separator: "\n").first ?? Substring(text))
    }
}

private extension CrossroadsView {
    func resourceStrip(_ values: ResourceValues) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), alignment: .leading), count: dynamicTypeSize.isAccessibilitySize ? 1 : 2)
        return LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
            ForEach(Array(zip(["健康", "財務安全", "人際關係", "技能與能力"], values.values)), id: \.0) { title, value in
                HStack { Text(title); Spacer(); Text(String(value)).monospacedDigit() }
                    .accessibilityElement(children: .combine)
            }
        }.padding(.top, 8)
    }

    func lifeOverview(_ session: LifeSession, catalog: ModelCatalog) -> some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Text(dynamicTypeSize.isAccessibilitySize ? "\(session.state.age)歲" : "沐沐 · \(session.state.age)歲")
                        .font(.headline).accessibilityLabel("沐沐 · \(session.state.age)歲")
                        .accessibilityIdentifier("lifeIdentity")
                    Spacer()
                    Text(store.name(session.state.countryCode) + (dynamicTypeSize.isAccessibilitySize ? "" : " · " + stageName(session.state.age)))
                        .font(dynamicTypeSize.isAccessibilitySize ? .caption : .subheadline)
                        .accessibilityLabel(store.name(session.state.countryCode) + " · " + stageName(session.state.age))
                        .accessibilityIdentifier("lifeBackground")
                }.padding(.horizontal, 16).padding(.vertical, 6)
                if store.worldPreviewEnabled, !store.viewingOriginal, let world = store.world {
                    worldStage(world, height: dynamicTypeSize.isAccessibilitySize ? 120 : min(210, max(150, geometry.size.height * 0.33)))
                }
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if store.comparisonOriginal != nil && !store.viewingOriginal && session.phase != .ended {
                            Text(store.parallelExperiment != nil ? "同一願望，另一個出身 · 原人生已保留" : "改選後的路 · 原人生已保留")
                                .font(.caption).accessibilityIdentifier("branchInProgress")
                            Button("看看保留的原人生") { store.viewingOriginal = true }.accessibilityIdentifier("viewOriginal")
                        }
                        if store.worldPreviewEnabled && !store.viewingOriginal && store.playback.phase == .living {
                            living(session)
                        } else { sessionContent(session) }
                        if let family = catalog.households.first(where: { $0.id == session.state.householdID }) {
                            DisclosureGroup {
                                Text(BirthStory.household(family))
                                Text("虛構家庭：" + family.label).font(.caption)
                                if let country = catalog.countries.first(where: { $0.code == session.state.countryCode }) {
                                    CountryContextCard(country: country, catalog: catalog)
                                }
                                Text(BirthDraw.scope).font(.caption)
                            } label: { Text("這個出身的生活安排").accessibilityIdentifier("lifeSituation") }
                            .font(.subheadline)
                        }
                        if !store.viewingOriginal && session.canChooseFocus {
                            Button { showFocus = true } label: {
                                Label("生活重心 · " + session.activeFocus.title, systemImage: "leaf")
                                    .frame(minHeight: 44).contentShape(Rectangle())
                            }.accessibilityIdentifier("lifeFocus")
                        }
                        if let effect = session.jumps.last?.focusEffect {
                            DisclosureGroup {
                                Text("上一段重心：\(effect.focus.title)・已留下生活安排")
                                    .accessibilityIdentifier("lifeFocusReceipt")
                                Text(effect.explanation)
                            } label: { Text("上一段生活安排").accessibilityIdentifier("focusReceiptDetails") }
                            .font(.caption)
                        }
                        DisclosureGroup("身體、生活與能力") { resourceStrip(session.state.resources) }
                            .font(.subheadline).accessibilityIdentifier("lifeResources")
                        if !session.traces.isEmpty && session.phase != .ended {
                            Text("最近的人生紀錄").font(.headline)
                            ForEach(Array(session.traces.suffix(3).enumerated()), id: \.offset) { _, trace in
                                Text("\(trace.age)歲 · \(trace.choiceTitle)").font(.subheadline)
                            }
                        }
                        Text("人生走到這裡：\(stageName(session.state.age))；已留下\(session.traces.count)段選擇。")
                            .font(.caption).accessibilityIdentifier("lifeMap")
                        archiveChecksum
                    }.padding(16).frame(maxWidth: 620, alignment: .leading).frame(maxWidth: .infinity)
                }.accessibilityIdentifier("worldDecisionDrawer")
                    .id("life-overview-\(store.viewingOriginal)-\(session.state.age)-\(session.phase.rawValue)")
            }
        }
    }

    var focusSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("想把下一段時間，留給什麼？").font(.title2.bold())
                    Text("這個方向會延續，直到你再調整。每段時間推進只算一次；多點、等待或加速都不會增加效果。這是遊戲假設，不是現實人生的保證。")
                        .font(.subheadline)
                    if let session = store.session {
                        ForEach(LifeFocus.available(at: session.state.age), id: \.rawValue) { focus in
                            Button {
                                if store.setFocus(focus) { showFocus = false }
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(focus.title + (session.activeFocus == focus ? " · 目前方向" : "")).font(.headline)
                                    Text(focus.explanation).font(.subheadline)
                                }.frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                            }.buttonStyle(.bordered).accessibilityIdentifier("focusChoice.\(focus.rawValue)")
                        }
                    }
                }.padding(20)
            }.navigationTitle("這段人生的重心").navigationBarTitleDisplayMode(.inline)
                .toolbar { Button("回到人生") { showFocus = false }.accessibilityIdentifier("closeFocus") }
        }
    }
}

private struct ComparisonPresentation: Identifiable {
    let id = UUID()
    let traces: [ConsequenceTrace]
    var households = false
    var alternatives: [String: [AvailableAction]] = [:]

    var comparisonStatus: String {
        if traces.filter({ $0.environmentGaps.isEmpty }).count < 2 { return "unknown" }
        return costsMatch ? "same" : "different"
    }

    var costsMatch: Bool {
        let qualified = traces.filter { $0.environmentGaps.isEmpty }
        guard let first = qualified.first else { return false }
        return qualified.dropFirst().allSatisfy { $0.finalCost == first.finalCost && $0.applied == first.applied }
    }
    var costExplanation: String {
        if comparisonStatus == "unknown" {
            return "尚無兩個具完整成本資料的情境，不能判斷成本與可行性相同或不同。家庭試算仍可供遊玩，未知環境成本不是0。"
        }
        return (traces.contains { !$0.environmentGaps.isEmpty } ? "部分環境尚無同口徑資料，先保留比較缺口。以下相同或不同的判斷只涵蓋資料足夠的情境。" : "") + (costsMatch
            ? "這次比較的成本與可行性相同。不是所有選擇都受國家環境影響；相同的結果，也值得看見。"
            : "這次比較的成本或可行性不同。下方顯示同一個行動，在各個環境中的模型試算。")
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

struct JourneyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline).frame(maxWidth: .infinity).padding(.vertical, 17)
            .background(configuration.isPressed ? StoryPalette.buttonPressed : StoryPalette.button, in: RoundedRectangle(cornerRadius: 18))
            .foregroundStyle(StoryPalette.onButton).contentShape(Rectangle())
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
