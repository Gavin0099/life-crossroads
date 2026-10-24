import SwiftUI
import LifeDomain

private enum WorkshopPanel: String, Identifiable {
    case actions, people, history, causes, catalog
    var id: String { rawValue }
    var title: String {
        switch self { case .actions:"安排今天";case .people:"身邊的人";case .history:"留下的經驗";case .causes:"機會從哪裡來";case .catalog:"演出圖錄" }
    }
}
private enum WorkshopFocus: Equatable { case materials, people }
struct WorkshopWorldView: View {
    @StateObject private var world=WorkshopStore()
    @State private var panel: WorkshopPanel?
    @State private var images=true
    @State private var focus: WorkshopFocus?
    @State private var foldedPaper=false
    @State private var remembering=false
    @Environment(\.accessibilityReduceMotion) private var systemReducedMotion
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.dismiss) private var dismiss
    private var reducedMotion: Bool { systemReducedMotion || ProcessInfo.processInfo.arguments.contains("-reduce-motion") }
    private let ink=Color(red:0.12,green:0.25,blue:0.24)
    private let paper=Color(red:0.98,green:0.96,blue:0.90)
    private var remembered: ConsequenceTrace? { remembering ? world.origin:nil }
    private var viewedAge: Int { remembered?.age ?? world.session?.state.age ?? 13 }
    private var viewedArt: WorkshopArt {
        guard let remembered else { return world.art }
        switch remembered.recordedStoryFacts.first(where: { $0.key == "workshop" })?.value {
        case "prototype":return .team
        case "plan":return .help
        default:return .idle
        }
    }
    private var viewedObject: String {
        guard remembered != nil else { return world.object }
        switch viewedArt {
        case .team:return "那時留下試作紀錄；紙橋仍可調整"
        case .help:return "那時留下借用清單；工具尚待詢問"
        case .idle:return "那時先留下時間休息，還沒開始試做"
        }
    }
    private func viewedFamiliarity(_ id: String) -> Int {
        remembered == nil ? world.familiarity(id):world.recordedFamiliarity(id,through:viewedAge)
    }
    private func update(_ action: () -> Void) {
        var transaction=Transaction(animation:reducedMotion ? nil:.easeInOut(duration:0.2))
        transaction.disablesAnimations=reducedMotion
        withTransaction(transaction,action)
    }
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment:.leading,spacing:16) {
                    if let session=world.session {
                        if typeSize.isAccessibilitySize {
                            worldScene
                            identity(session)
                            eventHeading(session)
                        } else {
                            identity(session)
                            eventHeading(session)
                            worldScene
                        }
                        Text(viewedObject).font(.subheadline.weight(.medium)).fixedSize(horizontal:false,vertical:true)
                            .accessibilityIdentifier("workshop-object")
                            .accessibilityValue(ProcessInfo.processInfo.arguments.contains("-workshop-proof") ? world.proof:"")
                        resourceBoard(remembered?.resourcesAfter ?? session.state.resources)
                        if let trace=remembered ?? session.traces.last {
                            VStack(alignment:.leading,spacing:6) {
                                Text("\(trace.age)歲 · \(trace.choiceTitle)").font(.subheadline.bold())
                                Text("時間 \(trace.budgetBefore.time) → \(trace.budgetAfter.time)　精力 \(trace.budgetBefore.energy) → \(trace.budgetAfter.energy)")
                                    .font(.footnote).fixedSize(horizontal:false,vertical:true)
                                Text("這次經驗會留在人際與作品紀錄中；沒有保證完成作品。").font(.caption)
                            }.padding(.leading,12).overlay(alignment:.leading) { Rectangle().fill(.teal).frame(width:3) }
                        }
                        if !remembering,session.state.age == 15,session.phase == .choosing {
                            Text("今天遇見的機會").font(.headline)
                            ForEach(world.event?.choices ?? [],id:\.id) { choice in
                                HStack(alignment:.top) {
                                    Image(systemName:"arrow.turn.down.right").foregroundStyle(.teal)
                                    Text(choice.title).fixedSize(horizontal:false,vertical:true)
                                }.font(.subheadline).accessibilityIdentifier("opportunity-\(choice.id)")
                            }
                            Button("看看這些機會的來處") { panel = .causes }
                                .accessibilityIdentifier("workshop-causes")
                        }
                        HStack {
                            Button("人物與關係") { panel = .people }.accessibilityIdentifier("workshop-people")
                            Spacer()
                            Button("人生紀錄") { panel = .history }.accessibilityIdentifier("workshop-history")
                        }.font(.subheadline)
                        Toggle("顯示插圖",isOn:$images).accessibilityIdentifier("workshop-images")
                        Text("玩法試玩：從13歲開始，未模擬前段童年。13→15歲之間沒有另行模擬年度事件；已有關係與經驗持續保留。資源數字是設計單位，沒有合成人生總分。")
                            .font(.caption).foregroundStyle(.secondary).fixedSize(horizontal:false,vertical:true)
                    }
                    if let error=world.error {
                        Text(error).foregroundStyle(.red).accessibilityIdentifier("workshop-error")
                        if world.session == nil {
                            Button("建立新的工坊生活，取代原紀錄") { world.restart() }
                                .accessibilityIdentifier("workshop-explicit-restart")
                        }
                    }
                }.padding(18)
            }
            .background(paper).foregroundStyle(ink)
            .safeAreaInset(edge:.bottom,spacing:0) { actionDock.frame(maxWidth:.infinity).padding(12).background(paper) }
            .navigationTitle("紙橋工坊").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.topBarLeading) { Button("回到人生") { dismiss() }.accessibilityIdentifier("workshop-close") }
                ToolbarItem(placement:.topBarTrailing) { Button { panel = .catalog } label: { Image(systemName:"person.crop.rectangle.stack") }.accessibilityLabel("角色演出圖錄").accessibilityIdentifier("workshop-catalog") }
            }
            .sheet(item:$panel) { item in
                if item == .catalog { WorkshopArtCatalog() }
                else { detail(item) }
            }
            .onChange(of:focus) { _,value in
                proxy.scrollTo(value == nil ? "workshop-scene-anchor":"workshop-inspection-anchor",anchor:.top)
            }
            .onChange(of:remembering) { _,_ in proxy.scrollTo("workshop-scene-anchor",anchor:.top) }
            }
        }
    }
    private func identity(_ session: LifeSession) -> some View {
        VStack(alignment:.leading,spacing:5) {
            Text(remembering ? "阿澄 · \(viewedAge)歲記錄":"阿澄 · \(session.state.age) 歲").font(.title2.bold()).accessibilityIdentifier("workshop-age")
                .accessibilityValue(ProcessInfo.processInfo.arguments.contains("-workshop-proof") ? world.proof:"")
            Text(session.state.age == 13 ? "放學後 · 河岸社區工坊":"兩年後 · 仍是這間工坊").font(.subheadline)
        }
    }
    private func eventHeading(_ session: LifeSession) -> some View {
        Text(remembered?.eventTitle ?? world.event?.title ?? (session.phase == .ended ? "經驗留在這裡，下一次還能再試":"你讓工坊多了一點不同"))
            .font(.headline).fixedSize(horizontal:false,vertical:true)
            .frame(maxWidth:.infinity,alignment:.leading)
    }
    private var sceneYear: some View {
        Label("\(viewedAge)歲 · \(remembering ? "記錄":"現在")",systemImage:remembering ? "clock.arrow.circlepath":"sun.max")
            .fixedSize(horizontal:true,vertical:false)
    }
    @ViewBuilder private var presentYear: some View {
        if remembering { Text("現在：\(world.session?.state.age ?? 15)歲").fixedSize(horizontal:true,vertical:false) }
    }
    private var worldScene: some View {
        VStack(spacing:0) {
            ViewThatFits(in:.horizontal) {
                HStack(alignment:.firstTextBaseline) { sceneYear;Spacer(minLength:8);presentYear }
                VStack(alignment:.leading,spacing:4) { sceneYear;presentYear }.frame(maxWidth:.infinity,alignment:.leading)
            }.font(.caption.bold()).padding(.bottom,8).accessibilityIdentifier("workshop-scene-year")
            if images {
                WorkshopStage(art:viewedArt).frame(height:typeSize.isAccessibilitySize ? 210:260)
            } else {
                VStack(alignment:.leading,spacing:12) {
                    Label("同一張工作桌",systemImage:"table.furniture").font(.title3.bold())
                    Text(viewedObject).fixedSize(horizontal:false,vertical:true)
                    Text("阿禾熟悉度 \(viewedFamiliarity("ahe"))　老師熟悉度 \(viewedFamiliarity("teacher"))")
                        .font(.footnote).fixedSize(horizontal:false,vertical:true)
                }.frame(maxWidth:.infinity,alignment:.leading).padding(18)
                    .background(.teal.opacity(0.08))
            }
            HStack(spacing:8) {
                Button { focus = .materials } label: { Label(typeSize.isAccessibilitySize ? "材料":"看材料",systemImage:"square.stack.3d.up") }
                    .accessibilityIdentifier("inspect-materials")
                Spacer(minLength:4)
                Button { focus = .people } label: { Label(typeSize.isAccessibilitySize ? "夥伴":"看夥伴",systemImage:"person.2") }
                    .accessibilityIdentifier("inspect-people")
            }.font(.subheadline).buttonStyle(.bordered).tint(.teal).padding(.top,10)
            if focus != nil { inspection.padding(.top,14).id("workshop-inspection-anchor") }
            if let origin=world.origin { continuity(origin).padding(.top,14) }
        }
        .accessibilityElement(children:.contain)
        .accessibilityValue(ProcessInfo.processInfo.arguments.contains("-workshop-proof") ? world.proof:world.object)
        .accessibilityIdentifier("workshop-world")
        .id("workshop-scene-anchor")
    }
    private var inspection: some View {
        VStack(alignment:.leading,spacing:12) {
            HStack(alignment:.top) {
                Label(focus == .materials ? "工作桌近看":"我們的連結",systemImage:focus == .materials ? "viewfinder":"person.2")
                    .font(.headline)
                Spacer(minLength:8)
                Button("收起") { focus=nil }.accessibilityIdentifier("workshop-panel-close")
                    .buttonStyle(.bordered).font(.subheadline)
            }
            if focus == .materials {
                WorkshopPaperStudy(folded:foldedPaper,checklist:viewedArt == .help).frame(height:170)
                if viewedArt != .help {
                    Button(foldedPaper ? "攤開紙面":"沿摺線看看",systemImage:"square.3.layers.3d") { foldedPaper.toggle() }
                        .accessibilityIdentifier("workshop-fold-paper")
                    Text(foldedPaper ? "薄紙邊與連續摺線；這是材料觀察，不代表完成作品。":"虛線是摺痕；可先攤開紙面，再觀察摺起後的結構。")
                        .font(.caption).fixedSize(horizontal:false,vertical:true)
                } else { Text("清單還沒勾選：先核對需求，不代表工具已借到。").font(.caption) }
                if let session=world.session {
                    let budget=remembered?.budgetAfter ?? .init(time:session.state.remainingTime,energy:session.state.remainingEnergy,materials:session.state.remainingMaterials)
                    HStack(alignment:.top) {
                        budgetMark("時間",budget.time,"clock")
                        budgetMark("精力",budget.energy,"bolt")
                        budgetMark("材料",budget.materials,"square.stack")
                    }.accessibilityIdentifier("workshop-material-budget")
                }
                Text("觀察不花費資源；採取行動後才更新。").font(.caption)
            } else {
                ViewThatFits(in:.horizontal) {
                    HStack { personMark("阿禾","ahe");Image(systemName:"link");personMark("樹老師","teacher") }
                    VStack { personMark("阿禾","ahe");Image(systemName:"link");personMark("樹老師","teacher") }
                }
                Text("熟悉度來自實際互動紀錄，不是人的價值。").font(.caption).fixedSize(horizontal:false,vertical:true)
            }
        }.padding(14).background(ink.opacity(0.055)).accessibilityElement(children:.contain).accessibilityIdentifier("workshop-inspection")
    }
    private func budgetMark(_ title: String,_ value: Int,_ icon: String) -> some View {
        VStack(alignment:.leading,spacing:4) { Image(systemName:icon);Text(String(value)).bold().monospacedDigit();Text(title) }
            .font(.subheadline).frame(maxWidth:.infinity,alignment:.leading).accessibilityElement(children:.combine)
    }
    private func personMark(_ name: String,_ id: String) -> some View {
        VStack(alignment:.leading,spacing:6) {
            Label(name,systemImage:id == "ahe" ? "person":"person.badge.key")
            Text("熟悉度 \(viewedFamiliarity(id))").font(.subheadline.bold())
            HStack(spacing:4) {
                ForEach(0..<10) { index in Circle().fill(index < viewedFamiliarity(id) ? ink:ink.opacity(0.12)).frame(width:8,height:8) }
            }.accessibilityHidden(true)
        }.frame(maxWidth:.infinity,alignment:.leading).accessibilityElement(children:.combine)
    }
    private func continuity(_ origin: ConsequenceTrace) -> some View {
        VStack(alignment:.leading,spacing:10) {
            let layout=typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment:.leading,spacing:8)):AnyLayout(HStackLayout(spacing:8))
            layout {
                Button { if world.session?.state.age == 15 { focus=nil;remembering=true } } label: {
                    timelineLabel("\(origin.age)歲紀錄","pin.fill")
                }.accessibilityIdentifier("workshop-memory-13")
                if !typeSize.isAccessibilitySize { Rectangle().fill(ink.opacity(0.3)).frame(width:24,height:1).accessibilityHidden(true) }
                Button { focus=nil;remembering=false } label: {
                    timelineLabel("15歲\(world.session?.state.age == 15 ? "現在":"再訪")","arrow.right.circle.fill")
                }.disabled(world.session?.state.age != 15).accessibilityIdentifier("workshop-memory-now")
            }.buttonStyle(.plain).tint(ink)
            Text(world.session?.state.age == 15 ? "同一間工坊 · 已跨過兩年；中間年度未模擬":"這次經驗會留在工坊；下一次再訪是15歲")
                .font(.caption).fixedSize(horizontal:false,vertical:true)
            if remembering {
                Text("當時：\(origin.choiceTitle)").font(.subheadline.bold()).fixedSize(horizontal:false,vertical:true)
                    .accessibilityIdentifier("workshop-memory-choice")
                HStack(alignment:.top) {
                    budgetMark("當時技能",origin.resourcesAfter.skills,"pencil.and.ruler")
                    Image(systemName:"arrow.right")
                    budgetMark("現在技能",world.session?.state.resources.skills ?? origin.resourcesAfter.skills,"pencil.and.ruler")
                }
                Text("只查看已發生的記錄，不重走或改寫人生。").font(.caption)
            }
        }.foregroundStyle(ink).accessibilityElement(children:.contain).accessibilityIdentifier("workshop-continuity")
    }
    private func timelineLabel(_ title: String,_ icon: String) -> some View {
        HStack(spacing:8) {
            if !typeSize.isAccessibilitySize { Image(systemName:icon) }
            Text(title).fixedSize(horizontal:false,vertical:true)
        }.font(.subheadline.bold()).frame(maxWidth:.infinity,alignment:.leading).padding(.vertical,8)
    }
    private func originCue(_ origin: ConsequenceTrace) -> some View {
        VStack(alignment:.leading,spacing:6) {
            Label("\(origin.age)歲的記錄",systemImage:"pin.fill").font(.caption.bold())
            Text(origin.choiceTitle).font(.caption).fixedSize(horizontal:false,vertical:true)
        }.foregroundStyle(ink).padding(.leading,12)
            .overlay(alignment:.leading) { Rectangle().fill(ink.opacity(0.4)).frame(width:2) }
            .accessibilityElement(children:.combine).accessibilityIdentifier("workshop-opportunity-origin")
            .accessibilityValue("\(origin.eventID)|\(origin.choiceID)|\(origin.age)")
    }
    private func resourceBoard(_ resources: ResourceValues) -> some View {
        let values=[("健康",resources.health),("財務安全",resources.financial),("人際",resources.relationships),("技能",resources.skills)]
        return LazyVGrid(columns:Array(repeating:GridItem(.flexible(),alignment:.leading),count:typeSize.isAccessibilitySize ? 1:2),alignment:.leading,spacing:10) {
            ForEach(values,id:\.0) { name,value in
                HStack { Text(name);Spacer();Text(String(value)).monospacedDigit().bold() }
                    .accessibilityElement(children:.combine).accessibilityIdentifier("workshop-resource-\(name)")
            }
        }.font(.subheadline).padding(.vertical,8)
    }
    @ViewBuilder private var actionDock: some View {
        if let session=world.session {
            if remembering {
                Button(typeSize.isAccessibilitySize ? "回到現在":"回到\(session.state.age)歲繼續",systemImage:"arrow.uturn.forward") { remembering=false;focus=nil }
                    .accessibilityLabel("回到\(session.state.age)歲繼續").accessibilityIdentifier("workshop-memory-return").buttonStyle(.borderedProminent).tint(ink).controlSize(.large)
            } else {
            switch session.phase {
            case .choosing:
                Button(typeSize.isAccessibilitySize ? "選行動":"安排今天的行動",systemImage:"hand.tap") { panel = .actions }
                    .accessibilityLabel("安排今天的行動")
                    .accessibilityIdentifier("workshop-actions")
                    .buttonStyle(.borderedProminent).tint(ink).controlSize(.large)
                    .frame(maxWidth:.infinity)
            case .reflecting:
                Button(session.state.age == 13 ? (typeSize.isAccessibilitySize ? "到15歲":"讓時間走到15歲") : (typeSize.isAccessibilitySize ? "收好經驗":"收好這段經驗"),systemImage:"clock.arrow.circlepath") {
                    update { focus=nil;world.advance() }
                }.accessibilityLabel(session.state.age == 13 ? "讓時間走到15歲":"收好這段經驗")
                    .accessibilityIdentifier("workshop-advance").buttonStyle(.borderedProminent).tint(ink).controlSize(.large)
            case .ended:
                Button(typeSize.isAccessibilitySize ? "重試":"從同一起點，試試另一條路") { update { focus=nil;world.restart() } }
                    .accessibilityLabel("從同一起點，試試另一條路")
                    .accessibilityIdentifier("workshop-restart").buttonStyle(.borderedProminent).tint(ink).controlSize(.large)
            }
            }
        }
    }
    private func detail(_ item: WorkshopPanel) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading,spacing:item == .actions ? 12:18) {
                    if item == .actions {
                        if let origin=world.opportunityOrigin { originCue(origin) }
                        ForEach(world.event?.choices ?? [],id:\.id) { choice in
                            if let preview=world.preview(choice.id) {
                                let continuation=choice.id == "lead" || choice.id == "borrow"
                                if choice.id == "practice" { Text("也能從今天開始").font(.subheadline.bold()).padding(.top,8) }
                                Button {
                                    update { focus=nil;world.choose(choice.id);panel=nil }
                                } label: {
                                    VStack(alignment:.leading,spacing:8) {
                                        Text(choice.title).font(.headline)
                                        Text("時間 \(preview.finalCost.time) · 精力 \(preview.finalCost.energy) · 材料 \(preview.finalCost.materials)").font(.subheadline)
                                        if !preview.applied { Text(preview.unavailableReasons.joined(separator:"\n")).font(.caption) }
                                    }.fixedSize(horizontal:false,vertical:true).frame(maxWidth:.infinity,alignment:.leading).padding(14)
                                        .background(continuation ? ink.opacity(0.08):Color.clear)
                                        .overlay(alignment:.leading) { if continuation { Rectangle().fill(ink).frame(width:3) } }
                                        .overlay(alignment:.bottom) { if !continuation { Rectangle().fill(ink.opacity(0.16)).frame(height:1) } }
                                }.buttonStyle(.plain).disabled(!preview.applied).accessibilityIdentifier("workshop-choice-\(choice.id)")
                            }
                        }
                    } else if item == .people {
                        Text("阿禾 · 熟悉度 \(world.familiarity("ahe"))").font(.headline)
                        Text("樹老師 · 熟悉度 \(world.familiarity("teacher"))").font(.headline)
                        ForEach(world.session?.state.story.relationships ?? [],id:\.personID) { person in
                            ForEach(person.interactions,id:\.eventID) { fact in
                                Text("\(fact.age)歲留下的互動：\(fact.value == "prototype" ? "一起試作":"準備與詢問")")
                            }
                        }
                        Text("熟悉度是遊戲記錄，不是人際價值或道德評分。")
                    } else if item == .history {
                        if world.session?.traces.isEmpty != false { Text("還沒有採取行動；工坊保留原狀。") }
                        ForEach(Array((world.session?.traces ?? []).enumerated()),id:\.offset) { _,trace in
                            Text("\(trace.age)歲 · \(trace.choiceTitle)").font(.headline)
                            Text("技能 \(trace.resourcesBefore.skills) → \(trace.resourcesAfter.skills)；人際 \(trace.resourcesBefore.relationships) → \(trace.resourcesAfter.relationships)")
                        }
                    } else if item == .causes,let session=world.session,let catalog=world.catalog {
                        if let event=world.event {
                            Text(StoryBranchEngine.project(event:event,state:session.state).evaluation?.explanation ?? "目前還沒有先前的工坊經驗。")
                        }
                        Text("先前的準備、與夥伴的互動及目前技能共同影響可用行動；國名沒有直接決定成功。這是遊戲設計規則。")
                        ForEach(session.traces.last?.effectSteps ?? [],id:\.ruleID) { step in Text(step.explanation).font(.subheadline) }
                        Text("內容版本：\(catalog.contentVersion)").font(.caption)
                    }
                }.padding(22).frame(maxWidth:.infinity,alignment:.leading)
            }.background(paper).accessibilityIdentifier("workshop-panel-scroll")
                .navigationTitle(item.title).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement:.confirmationAction) {
                    Button("回到工坊") { update { panel=nil } }.accessibilityIdentifier("workshop-panel-close")
                } }
        }.presentationDetents([.large]).presentationDragIndicator(.visible)
    }
}
#Preview { WorkshopWorldView() }
#Preview("最大字級") { WorkshopWorldView().environment(\.dynamicTypeSize,.accessibility5) }
