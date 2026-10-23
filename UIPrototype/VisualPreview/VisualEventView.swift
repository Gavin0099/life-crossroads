import SwiftUI

struct VisualEventView: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var direction: VisualDirection
    @State private var screen: VisualScreen
    @State private var selectedID: String?
    let hasEvidence: Bool

    init(direction: VisualDirection = .paper, screen: VisualScreen = .event,
         hasEvidence: Bool = true) {
        let args = ProcessInfo.processInfo.arguments
        _direction = State(initialValue: args.contains("-midnight") ? .midnight : direction)
        _screen = State(initialValue: args.contains("-feedback") ? .feedback : screen)
        self.hasEvidence = hasEvidence && !args.contains("-missing-evidence")
    }

    private var chosen: VisualChoice? { PreviewFixtures.choices.first { $0.id == selectedID } }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                header
                VStack(alignment: .leading, spacing: 18) {
                    switch screen {
                    case .event: event
                    case .feedback: feedback
                    case .compare: comparison
                    case .why: explanation
                    }
                    Text("視覺原型 · 情境與數字均為設計假資料")
                        .font(.caption).foregroundStyle(direction.secondary)
                        .accessibilityIdentifier("fixtureNotice")
                }
                .padding(20)
                .frame(maxWidth: 600, alignment: .leading)
                .frame(maxWidth: .infinity)
                }
            }.id(screen)
            footer
        }
        .foregroundStyle(direction.ink)
        .background(direction.background.ignoresSafeArea())
        .preferredColorScheme(direction == .paper ? .light : .dark)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Label("人生岔路", systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                    .font(.headline)
                Spacer()
                if !typeSize.isAccessibilitySize {
                    Text("VISUAL LAB / 01").font(.caption2.monospaced()).tracking(1)
                        .accessibilityHidden(true)
                }
            }
            Picker("美術方向", selection: $direction) {
                ForEach(VisualDirection.allCases) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented).accessibilityIdentifier("directionPicker")
            if typeSize.isAccessibilitySize {
                Text("青少年 · 13 歲（第 2/5 階段）").font(.subheadline)
            } else {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) { stages }
                    VStack(alignment: .leading, spacing: 6) { stages }
                }
            }
        }.padding(.horizontal, 20).padding(.top, 12).padding(.bottom, 12)
    }

    private var stages: some View {
        Group {
            Text("童年").foregroundStyle(direction.secondary)
            Image(systemName: "chevron.right").font(.caption2).accessibilityHidden(true)
            Text("● 青少年 · 13 歲").fontWeight(.semibold)
            Image(systemName: "chevron.right").font(.caption2).accessibilityHidden(true)
            Text("青年 → 中年 → 晚年").foregroundStyle(direction.secondary)
        }.font(.caption)
    }

    private func title(_ eyebrow: String, _ title: String, _ subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(eyebrow).font(.caption.monospaced()).tracking(2).foregroundStyle(direction.secondary)
            Text(title).font(.system(.largeTitle, design: .rounded, weight: .bold))
                .accessibilityAddTraits(.isHeader)
            Text(subtitle).font(.subheadline).foregroundStyle(direction.secondary).lineSpacing(3)
        }
    }

    private func artwork(height: CGFloat) -> some View {
        ZStack(alignment: .bottomLeading) {
            if UIImage(named: direction.scene) != nil {
                Image(direction.scene).resizable().scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(direction.surface)
            } else {
                direction.surface
                Label("場景圖片尚未載入", systemImage: "photo")
                    .foregroundStyle(direction.secondary).padding(20)
            }
        }
        .frame(height: height).clipShape(RoundedRectangle(cornerRadius: 20))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("水獺與朋友在共用工作桌前製作紙板模型。角色與國籍無關。")
    }

    private var event: some View {
        Group {
            title("CHAPTER 02 / 一個新點子", "把想像，做出來。", "社區科學創作展開始報名了。")
            artwork(height: typeSize.isAccessibilitySize ? 125 : 220)
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) { resourceLabels }
                VStack(alignment: .leading, spacing: 8) { resourceLabels }
            }.font(.caption).foregroundStyle(direction.secondary)
            Text("你想做一座紙橋，但材料和放學後的時間都有限。要從哪裡開始？")
                .font(.body).lineSpacing(4)
            VStack(spacing: 10) {
                ForEach(PreviewFixtures.choices) { choice in
                    Button {
                        selectedID = choice.id
                        screen = .feedback
                    } label: {
                        HStack(spacing: 14) {
                            if !typeSize.isAccessibilitySize {
                                Image(systemName: choice.symbol).font(.title3).frame(width: 26)
                                    .accessibilityHidden(true)
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text(choice.title).font(.headline)
                                Text(choice.cost).font(.caption).foregroundStyle(direction.secondary)
                            }
                            Spacer(minLength: 0)
                            if !typeSize.isAccessibilitySize {
                                Image(systemName: "arrow.up.right").font(.caption).accessibilityHidden(true)
                            }
                        }
                        .padding(16).frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
                        .background(direction.surface, in: RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(direction.accent.opacity(0.4)))
                        .contentShape(RoundedRectangle(cornerRadius: 18))
                    }.buttonStyle(.plain).accessibilityIdentifier("choice-\(choice.id)")
                }
            }
        }
    }

    private var feedback: some View {
        Group {
            title("THE NEXT RIPPLE / 接下來的漣漪", selectedID == "help" ? "先找到，一雙援手。" : "一座橋，兩個人。", "選擇留下變化，也留下新的問題。")
            artwork(height: 132)
            card {
                Label("你選擇了", systemImage: "arrow.triangle.branch").font(.caption)
                Text(chosen?.title ?? PreviewFixtures.choices[0].title).font(.headline)
                Divider()
                Text("當下").font(.caption.bold()).foregroundStyle(direction.accent)
                Text(chosen?.outcome ?? PreviewFixtures.choices[0].outcome).lineSpacing(4)
                Label(selectedID == "help" ? "精力使用 1 格" : "精力使用 2 格", systemImage: "bolt")
                    .font(.subheadline)
            }
            card {
                Label("以後可能的呼應", systemImage: "clock.arrow.circlepath").font(.headline)
                Text("這位朋友可能再次出現在你的故事裡。正式遊戲是否觸發，必須由引擎紀錄決定。")
                    .font(.subheadline).foregroundStyle(direction.secondary)
            }
            action("看看為什麼", id: "showWhy", symbol: "text.magnifyingglass") { screen = .why }
            Text("以上為 UI 範例敘事，尚未接入真實後果追蹤。")
                .font(.caption).foregroundStyle(direction.secondary)
        }
    }

    private var explanation: some View {
        Group {
            title("FOLLOW THE THREAD / 找到線索", "為什麼會這樣？", "正式版只顯示實際參與計算的因素。")
            if hasEvidence {
                card {
                    Label("示範因素 · 非真實 Trace", systemImage: "doc.text.magnifyingglass").font(.headline)
                    Text("選擇 → \(chosen?.title ?? PreviewFixtures.choices[0].title)")
                    Text("環境 → 放學後時間有限")
                    Text(selectedID == "help" ? "支持 → 老師提供材料清單" : "支持 → 朋友共享材料")
                    Text("未提供運氣紀錄，因此不顯示運氣解釋。")
                        .font(.caption).foregroundStyle(direction.secondary)
                }
            } else {
                card {
                    Label("目前沒有原因紀錄", systemImage: "questionmark.folder").font(.headline)
                    Text("可以回看選擇；取得後果追蹤前，不推測原因。")
                }.accessibilityIdentifier("missingEvidence")
            }
            action("比較同選擇的環境", id: "showCompare", symbol: "rectangle.split.2x1") { screen = .compare }
        }
    }

    private var comparison: some View {
        Group {
            title("SAME CHOICE / 不同的起點", "同一個你，不同環境。", "固定：13 歲、同一化身、同一選擇。\n改變：交通時間與可取得的支持。")
            Text("和朋友做簡易作品").font(.headline)
            contextCard("日本 · 示範家庭 A", detail: "社區有共用工作空間", cost: "交通占用 1 格時間", support: "可借工具；需配合開放時間")
            contextCard("肯亞 · 示範家庭 B", detail: "工作空間較遠，學校有材料支援", cost: "交通占用 2 格時間", support: "可請老師協助；需提早安排")
            card {
                Label("差異來自條件，沒有國家排名", systemImage: "equal.circle").font(.headline)
                Text("這兩個家庭是虛構 UI fixture，不代表國家平均。只換國名、不換條件時，結果應相同。正式比較由主引擎提供。")
                    .font(.subheadline).foregroundStyle(direction.secondary)
            }
        }
    }

    private func contextCard(_ name: String, detail: String, cost: String, support: String) -> some View {
        card {
            Text(name).font(.headline)
            Text(detail).font(.subheadline).foregroundStyle(direction.secondary)
            Divider()
            Label(cost, systemImage: "clock")
            Label(support, systemImage: "hands.sparkles").font(.subheadline)
        }
    }

    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12, content: content)
            .padding(18).frame(maxWidth: .infinity, alignment: .leading)
            .background(direction.surface, in: RoundedRectangle(cornerRadius: 20))
    }

    private func action(_ text: String, id: String, symbol: String, perform: @escaping () -> Void) -> some View {
        Button(action: perform) {
            Label(text, systemImage: symbol).font(.headline)
                .frame(maxWidth: .infinity, minHeight: 48).padding(.vertical, 4)
                .foregroundStyle(direction.onAccent)
                .background(direction.accent, in: RoundedRectangle(cornerRadius: 16))
        }.buttonStyle(.plain).accessibilityIdentifier(id)
    }

    private var resourceLabels: some View {
        Group {
            Label("可用精力 3 格", systemImage: "bolt")
            Label("朋友願意幫忙", systemImage: "person.2")
        }
    }

    private var footerButtons: some View {
        Group {
            Button { screen = .event; selectedID = nil } label: {
                Label("回到岔路", systemImage: "arrow.uturn.backward")
            }.accessibilityIdentifier("reset")
            Button { screen = screen == .compare ? .event : .compare } label: {
                Label(screen == .compare ? "繼續選擇" : "比較環境", systemImage: "rectangle.split.2x1")
            }.accessibilityIdentifier("compare")
        }.frame(minHeight: 44)
    }

    private var footer: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 24) { footerButtons }
            VStack(spacing: 4) { footerButtons }
        }
        .font(.subheadline.bold()).buttonStyle(.plain)
        .padding(.horizontal, 20).padding(.vertical, 6)
        .frame(maxWidth: .infinity, minHeight: 54)
        .background(direction.surface)
    }
}

#Preview("A · 決策") { VisualEventView() }
#Preview("B · 決策") { VisualEventView(direction: .midnight) }
#Preview("A · 後果") { VisualEventView(screen: .feedback) }
#Preview("B · 比較") { VisualEventView(direction: .midnight, screen: .compare) }
#Preview("缺少原因紀錄") { VisualEventView(screen: .why, hasEvidence: false) }
#Preview("最大文字") { VisualEventView().environment(\.dynamicTypeSize, .accessibility5) }
