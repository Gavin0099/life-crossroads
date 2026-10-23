import SwiftUI
import LifeDomain

private enum WorkshopPanel: String, Identifiable {
    case actions, materials, people, history, causes, catalog
    var id: String { rawValue }
    var title: String {
        switch self { case .actions:"安排今天";case .materials:"看看工作桌";case .people:"身邊的人";case .history:"留下的經驗";case .causes:"機會從哪裡來";case .catalog:"演出圖錄" }
    }
}
struct WorkshopWorldView: View {
    @StateObject private var world=WorkshopStore()
    @State private var panel: WorkshopPanel?
    @State private var images=true
    @Environment(\.accessibilityReduceMotion) private var systemReducedMotion
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.dismiss) private var dismiss
    private var reducedMotion: Bool { systemReducedMotion || ProcessInfo.processInfo.arguments.contains("-reduce-motion") }
    private let ink=Color(red:0.12,green:0.25,blue:0.24)
    private let paper=Color(red:0.98,green:0.96,blue:0.90)
    private func update(_ action: () -> Void) {
        var transaction=Transaction(animation:reducedMotion ? nil:.easeInOut(duration:0.2))
        transaction.disablesAnimations=reducedMotion
        withTransaction(transaction,action)
    }
    var body: some View {
        NavigationStack {
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
                        Text(world.object).font(.subheadline.weight(.medium)).fixedSize(horizontal:false,vertical:true)
                            .accessibilityIdentifier("workshop-object")
                            .accessibilityValue(ProcessInfo.processInfo.arguments.contains("-workshop-proof") ? world.proof:"")
                        resourceBoard(session)
                        if let trace=session.traces.last {
                            VStack(alignment:.leading,spacing:6) {
                                Text("\(trace.age)歲 · \(trace.choiceTitle)").font(.subheadline.bold())
                                Text("時間 \(trace.budgetBefore.time) → \(trace.budgetAfter.time)　精力 \(trace.budgetBefore.energy) → \(trace.budgetAfter.energy)")
                                    .font(.footnote).fixedSize(horizontal:false,vertical:true)
                                Text("這次經驗會留在人際與作品紀錄中；沒有保證完成作品。").font(.caption)
                            }.padding(.leading,12).overlay(alignment:.leading) { Rectangle().fill(.teal).frame(width:3) }
                        }
                        if session.state.age == 15,session.phase == .choosing {
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
            .safeAreaInset(edge:.bottom,spacing:0) { actionDock.padding(12).background(paper) }
            .navigationTitle("紙橋工坊").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement:.topBarLeading) { Button("回到人生") { dismiss() }.accessibilityIdentifier("workshop-close") }
                ToolbarItem(placement:.topBarTrailing) { Button { panel = .catalog } label: { Image(systemName:"person.crop.rectangle.stack") }.accessibilityLabel("角色演出圖錄").accessibilityIdentifier("workshop-catalog") }
            }
            .sheet(item:$panel) { item in
                if item == .catalog { WorkshopArtCatalog() }
                else { detail(item) }
            }
        }
    }
    private func identity(_ session: LifeSession) -> some View {
        VStack(alignment:.leading,spacing:5) {
            Text("阿澄 · \(session.state.age) 歲").font(.title2.bold()).accessibilityIdentifier("workshop-age")
                .accessibilityValue(ProcessInfo.processInfo.arguments.contains("-workshop-proof") ? world.proof:"")
            Text(session.state.age == 13 ? "放學後 · 河岸社區工坊":"兩年後 · 仍是這間工坊").font(.subheadline)
        }
    }
    private func eventHeading(_ session: LifeSession) -> some View {
        Text(world.event?.title ?? (session.phase == .ended ? "經驗留在這裡，下一次還能再試":"你讓工坊多了一點不同"))
            .font(.headline).fixedSize(horizontal:false,vertical:true)
            .frame(maxWidth:.infinity,alignment:.leading)
    }
    private var worldScene: some View {
        VStack(spacing:0) {
            if images {
                WorkshopStage(art:world.art).frame(height:typeSize.isAccessibilitySize ? 210:260)
            } else {
                VStack(alignment:.leading,spacing:12) {
                    Label("同一張工作桌",systemImage:"table.furniture").font(.title3.bold())
                    Text(world.object).fixedSize(horizontal:false,vertical:true)
                    Text("阿禾熟悉度 \(world.familiarity("ahe"))　老師熟悉度 \(world.familiarity("teacher"))")
                        .font(.footnote).fixedSize(horizontal:false,vertical:true)
                }.frame(maxWidth:.infinity,alignment:.leading).padding(18)
                    .background(.teal.opacity(0.08))
            }
            HStack(spacing:8) {
                Button { panel = .materials } label: { Label(typeSize.isAccessibilitySize ? "材料":"看材料",systemImage:"square.stack.3d.up") }
                    .accessibilityIdentifier("inspect-materials")
                Spacer(minLength:4)
                Button { panel = .people } label: { Label(typeSize.isAccessibilitySize ? "夥伴":"看夥伴",systemImage:"person.2") }
                    .accessibilityIdentifier("inspect-people")
            }.font(.subheadline).buttonStyle(.bordered).tint(.teal).padding(.top,10)
        }
        .accessibilityElement(children:.contain)
        .accessibilityValue(ProcessInfo.processInfo.arguments.contains("-workshop-proof") ? world.proof:world.object)
        .accessibilityIdentifier("workshop-world")
    }
    private func resourceBoard(_ session: LifeSession) -> some View {
        let values=[("健康",session.state.resources.health),("財務安全",session.state.resources.financial),("人際",session.state.resources.relationships),("技能",session.state.resources.skills)]
        return LazyVGrid(columns:Array(repeating:GridItem(.flexible(),alignment:.leading),count:typeSize.isAccessibilitySize ? 1:2),alignment:.leading,spacing:10) {
            ForEach(values,id:\.0) { name,value in
                HStack { Text(name);Spacer();Text(String(value)).monospacedDigit().bold() }
                    .accessibilityElement(children:.combine).accessibilityIdentifier("workshop-resource-\(name)")
            }
        }.font(.subheadline).padding(.vertical,8)
    }
    @ViewBuilder private var actionDock: some View {
        if let session=world.session {
            switch session.phase {
            case .choosing:
                Button(typeSize.isAccessibilitySize ? "選行動":"安排今天的行動",systemImage:"hand.tap") { panel = .actions }
                    .accessibilityLabel("安排今天的行動")
                    .accessibilityIdentifier("workshop-actions")
                    .buttonStyle(.borderedProminent).tint(ink).controlSize(.large)
                    .frame(maxWidth:.infinity)
            case .reflecting:
                Button(session.state.age == 13 ? (typeSize.isAccessibilitySize ? "到15歲":"讓時間走到15歲") : (typeSize.isAccessibilitySize ? "收好經驗":"收好這段經驗"),systemImage:"clock.arrow.circlepath") {
                    update { world.advance() }
                }.accessibilityLabel(session.state.age == 13 ? "讓時間走到15歲":"收好這段經驗")
                    .accessibilityIdentifier("workshop-advance").buttonStyle(.borderedProminent).tint(ink).controlSize(.large)
            case .ended:
                Button(typeSize.isAccessibilitySize ? "重試":"從同一起點，試試另一條路") { update { world.restart() } }
                    .accessibilityLabel("從同一起點，試試另一條路")
                    .accessibilityIdentifier("workshop-restart").buttonStyle(.borderedProminent).tint(ink).controlSize(.large)
            }
        }
    }
    private func detail(_ item: WorkshopPanel) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading,spacing:18) {
                    if item == .actions {
                        ForEach(world.event?.choices ?? [],id:\.id) { choice in
                            if let preview=world.preview(choice.id) {
                                Button {
                                    update { world.choose(choice.id);panel=nil }
                                } label: {
                                    VStack(alignment:.leading,spacing:8) {
                                        Text(choice.title).font(.headline)
                                        Text("時間 \(preview.finalCost.time) · 精力 \(preview.finalCost.energy) · 材料 \(preview.finalCost.materials)").font(.subheadline)
                                        if !preview.applied { Text(preview.unavailableReasons.joined(separator:"\n")).font(.caption) }
                                    }.fixedSize(horizontal:false,vertical:true).frame(maxWidth:.infinity,alignment:.leading).padding(14)
                                        .background(.teal.opacity(0.09),in:RoundedRectangle(cornerRadius:12))
                                }.buttonStyle(.plain).disabled(!preview.applied).accessibilityIdentifier("workshop-choice-\(choice.id)")
                            }
                        }
                    } else if item == .materials {
                        Text(world.object).font(.headline)
                        if let state=world.session?.state {
                            Text("今天可安排：時間 \(state.remainingTime)、精力 \(state.remainingEnergy)、材料 \(state.remainingMaterials)。")
                            Text("看材料與看夥伴不消耗資源；只有確定採取行動才會改變這些數字。")
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
