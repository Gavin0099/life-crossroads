import SwiftUI
import LifeDomain
import LifePresentation

struct BranchPickerView: View {
    let original: LifeSession
    let catalog: ModelCatalog
    let begin: (Int, String) -> Bool
    @Environment(\.dismiss) private var dismiss
    @State private var checkpoint: LifeSession?
    @State private var selectedIndex: Int?
    @State private var error: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("原來的人生會留在回憶冊。選一個日子，換個行動，再親自走完後面的故事。")
                    Text("同樣的背景與種子；共有機會使用相同亂數。行動改變後，能遇到的故事與可用選項也可能改變。")
                        .font(.footnote).foregroundStyle(.secondary)
                    if let error { Text(error).foregroundStyle(.red) }
                    if let checkpoint, let index = selectedIndex {
                        Text("\(original.traces[index].age)歲 · \(original.traces[index].eventTitle)").font(.title2.bold())
                        Text("原來選了：\(original.traces[index].choiceTitle)")
                        if let event = try? checkpoint.event(catalog: catalog) {
                            ForEach(event.choices, id: \.id) { choice in
                                if let preview = try? checkpoint.preview(choiceID: choice.id, catalog: catalog) {
                                    let same = choice.id == original.traces[index].choiceID
                                    Button {
                                        if begin(index, choice.id) { dismiss() }
                                    } label: {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(choice.title).font(.headline)
                                            Text(same ? "原來的選擇" : "時間\(preview.finalCost.time) · 精力\(preview.finalCost.energy) · 材料\(preview.finalCost.materials)")
                                                .font(.subheadline)
                                            if !preview.applied { Text(preview.unavailableReasons.joined(separator: "、")).font(.footnote) }
                                        }.frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                                    }.buttonStyle(.bordered).disabled(same || !preview.applied)
                                        .accessibilityIdentifier("forkChoice.\(choice.id)")
                                }
                            }
                        }
                        Button("換一個日子") { self.checkpoint = nil; selectedIndex = nil }
                    } else {
                        ForEach(Array(original.traces.enumerated()), id: \.offset) { index, trace in
                            Button {
                                do { checkpoint = try original.beforeDecision(at: index, catalog: catalog); selectedIndex = index }
                                catch { self.error = "無法重建這個日子的紀錄：\(error)" }
                            } label: {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(trace.age)歲 · \(trace.eventTitle)").font(.headline)
                                    Text(trace.choiceTitle).font(.subheadline)
                                }.frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                            }.buttonStyle(.bordered).accessibilityIdentifier("forkPoint.\(index)")
                        }
                    }
                }.padding()
            }.navigationTitle("回到哪個岔路？").navigationBarTitleDisplayMode(.inline)
                .toolbar { Button("關閉") { dismiss() }.accessibilityIdentifier("closeForkPicker") }
        }
    }
}

struct BranchComparisonView: View {
    let rows: [BranchComparisonRow]
    let scope: String
    let originalFinal: ResourceValues
    let alternativeFinal: ResourceValues
    let title: String
    let backgrounds: String?
    init(comparison: BranchComparison) {
        self.init(rows: comparison.rows, scope: comparison.scopeExplanation, originalFinal: comparison.originalFinal,
                  alternativeFinal: comparison.alternativeFinal, title: "如果當年選了另一條路")
    }
    init(rows: [BranchComparisonRow], scope: String, originalFinal: ResourceValues, alternativeFinal: ResourceValues, title: String, backgrounds: String? = nil) {
        self.rows = rows; self.scope = scope; self.originalFinal = originalFinal; self.alternativeFinal = alternativeFinal; self.title = title; self.backgrounds = backgrounds
    }
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(title).font(.title2.bold()).accessibilityIdentifier("branchComparisonTitle")
                    if let backgrounds {
                        Text(backgrounds).font(.subheadline).accessibilityIdentifier("parallelBackgrounds")
                    }
                    DisclosureGroup {
                        Text(scope).font(.subheadline).accessibilityIdentifier("branchComparisonScope")
                    } label: { Text("比較方式與限制").accessibilityIdentifier("comparisonMethod") }
                    Text("從\(rows.first?.original.age ?? 0)歲到晚年，共\(rows.count)段對照")
                        .accessibilityIdentifier("branchComparisonCount").accessibilityValue(String(rows.count))
                    Text("先看重要的兩三個轉折").font(.headline)
                    if LifeStoryComparison.highlights(rows).isEmpty { Text("這次記錄沒有不同的故事或選擇；不為比較而編造差異。") }
                    ForEach(LifeStoryComparison.highlights(rows), id: \.decisionIndex) { row in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(row.original.age)歲").font(.headline)
                            story("原本的人生", trace: row.original, arrival: row.originalArrival)
                            story("另一段人生", trace: row.alternative, arrival: row.alternativeArrival)
                            if row.sameAction && !row.storyChanged {
                                Text("這一頁遇見相同情境，也做了相同選擇；不同出身不一定讓每件事都不同。").font(.caption)
                            }
                        }.padding().background(StoryPalette.page, in: RoundedRectangle(cornerRadius: 16))
                            .accessibilityIdentifier("storyHighlight.\(row.decisionIndex)")
                    }
                    DisclosureGroup("晚年處境的數值紀錄") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("原來：\(resources(originalFinal))")
                            Text("另一條路：\(resources(alternativeFinal))")
                            Text("資源描述處境，不是人生分數。").font(.footnote)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                    DisclosureGroup {
                    ForEach(rows, id: \.decisionIndex) { row in
                        GroupBox("\(row.original.age)歲 · \(row.storyChanged ? "故事走向不同" : "遇見相同的故事情境")") {
                            VStack(alignment: .leading, spacing: 14) {
                                route("原來的人生", prefix: "branch.\(row.decisionIndex).original", trace: row.original, arrival: row.originalArrival)
                                Divider()
                                route("另一段人生", prefix: "branch.\(row.decisionIndex).alternative", trace: row.alternative, arrival: row.alternativeArrival)
                            }
                        }.accessibilityIdentifier("branchRow.\(row.decisionIndex)")
                    }
                    } label: { Text("展開完整人生紀錄").accessibilityIdentifier("fullLifeTimeline") }
                    Text("回顧結束不代表這個年齡死亡。相同種子也不保證遇到相同事件，因為先前選擇會改變資格與權重。")
                        .font(.footnote).foregroundStyle(.secondary)
                }.padding()
            }.navigationTitle("人生故事對照").navigationBarTitleDisplayMode(.inline)
                .toolbar { Button("關閉") { dismiss() }.accessibilityIdentifier("closeBranchComparison") }
        }
    }

    private func story(_ label: String, trace: ConsequenceTrace, arrival: TimeJumpTrace) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).font(.subheadline.bold())
            Text(trace.eventTitle).font(.headline)
            Text(trace.choiceTitle).font(.body)
            ForEach(Array(LifeStoryComparison.consequences(trace, arrival: arrival).enumerated()), id: \.offset) { _, text in
                Text(text).font(.subheadline)
            }
        }
    }

    private func route(_ label: String, prefix: String, trace: ConsequenceTrace, arrival: TimeJumpTrace) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label).font(.headline)
            if let focus = arrival.focusEffect {
                Text("\(arrival.fromAge)～\(arrival.toAge)歲的生活重心：\(focus.focus.title)")
                    .font(.subheadline)
                Text(focus.explanation).font(.footnote)
            }
            Text(trace.eventTitle).font(.headline)
                .accessibilityIdentifier("\(prefix).event").accessibilityValue(trace.eventID)
            Text("和\(trace.recurringPerson) · \(trace.choiceTitle)")
                .accessibilityIdentifier("\(prefix).choice").accessibilityValue(trace.choiceID)
            ForEach(arrival.triggeredHooks, id: \.id) { hook in
                Text("\(hook.originAge)歲留下的回聲：\(hook.text)").font(.subheadline)
            }
            DisclosureGroup {
                VStack(alignment: .leading, spacing: 8) {
                    Text("選前：\(resources(trace.resourcesBefore))").font(.caption)
                        .accessibilityIdentifier("\(prefix).before")
                    Text("選後：\(resources(trace.resourcesAfter))").font(.caption)
                        .accessibilityIdentifier("\(prefix).after")
                    Text(trace.influenceSummary)
                    ForEach(Array(trace.explanation.enumerated()), id: \.offset) { _, text in Text(text) }
                    Text(trace.eventSelection.summary)
                    ForEach(trace.scheduledHooks, id: \.id) { hook in
                        Text("留下線索：預定\(hook.dueAge)歲後呼應 · \(hook.text)")
                    }
                }.font(.footnote).padding(.top, 6)
            } label: { Text("這一頁的實際原因與線索").accessibilityIdentifier("\(prefix).details") }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }

    private func resources(_ value: ResourceValues) -> String {
        "健康\(value.health) · 財務\(value.financial) · 人際\(value.relationships) · 技能\(value.skills)"
    }
}
