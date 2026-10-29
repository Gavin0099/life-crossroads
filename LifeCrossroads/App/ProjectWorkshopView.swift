import SwiftUI
import LifeDomain
import LifePresentation

/// One authored event stage. The illustration is a fictional workshop shared by all countries.
struct ProjectWorkshopView: View {
    let moment: ProjectMoment?
    var compact = false
    var showArtwork = true
    var showMetrics = true
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var entered = false

    @ViewBuilder var body: some View {
        if compact {
            workshop.clipShape(RoundedRectangle(cornerRadius: 12)).accessibilityHidden(true)
        } else {
            VStack(alignment: .leading, spacing: 10) {
                if showArtwork && !typeSize.isAccessibilitySize {
                    workshop
                        .frame(height: moment == nil ? 144 : 184)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .accessibilityHidden(true)
                }
                Text(moment?.caption ?? "創作桌上有圖解、有材料，也留著可以先休息的位置。")
                    .font(.subheadline.weight(.medium)).fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("projectSceneCaption")
                if let moment {
                    if showMetrics {
                    Text("時間 \(moment.cost.time) · 精力 \(moment.cost.energy) · 材料 \(moment.cost.materials)")
                        .font(.caption.weight(.semibold)).monospacedDigit()
                        .accessibilityIdentifier("projectSpent")
                    }
                    if let person = moment.person {
                        Label("與\(person)留下互動紀錄", systemImage: "person.2")
                            .font(.caption).accessibilityIdentifier("projectPerson")
                    }
                    if let memory = moment.memory {
                        Text(memory).font(.subheadline).accessibilityIdentifier("projectMemory")
                    }
                    ForEach(moment.support, id: \.self) { support in
                        Label(support, systemImage: "hands.sparkles").font(.subheadline)
                            .accessibilityIdentifier("projectSupport")
                    }
                    if let chance = moment.chance {
                        Label(chance, systemImage: "sparkle").font(.subheadline)
                            .accessibilityIdentifier("projectChance")
                    }
                    if moment.pendingCount > 0 {
                        Label("留下\(moment.pendingCount)條延後線索，還沒發生；不是獲獎或邀請保證。", systemImage: "clock")
                            .font(.caption).accessibilityIdentifier("projectPending")
                    }
                    if !moment.gaps.isEmpty {
                        Text("部分環境成本未知；圖中的設備不代表這個家庭實際擁有，也不能推論國家的服務。")
                            .font(.caption).accessibilityIdentifier("projectGap")
                    }
                    Text("本次實際參與：" + moment.influences.joined(separator: "、"))
                        .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
                        .accessibilityIdentifier("projectInfluences")
                    Text("取自這次已保存的選擇紀錄；作品是否完成、後續機會仍待後面的故事。")
                        .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
                        .accessibilityIdentifier("projectReceipt").accessibilityValue(testReceipt)
                }
                Text("共用的想像工作室 · 不是各國實景")
                    .font(.caption2).foregroundStyle(StoryPalette.secondaryInk)
            }
            .padding(14)
            .background(StoryPalette.illustratedPaper, in: RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(StoryPalette.sceneInk.opacity(0.16), lineWidth: 1))
        }
    }

    private var workshop: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: [Color(red: 0.96, green: 0.91, blue: 0.79), Color(red: 0.87, green: 0.87, blue: 0.73)],
                               startPoint: .top, endPoint: .bottom)
                // Window, shelves and tabletop are repo-native SwiftUI shapes, not new raster assets.
                RoundedRectangle(cornerRadius: 34)
                    .fill(Color(red: 0.72, green: 0.83, blue: 0.79))
                    .overlay(alignment: .topTrailing) { Circle().fill(.white.opacity(0.55)).frame(width: 32).padding(13) }
                    .overlay { Rectangle().fill(.white.opacity(0.65)).frame(width: 5) }
                    .frame(width: geometry.size.width * 0.38, height: geometry.size.height * 0.64)
                    .offset(x: geometry.size.width * 0.26, y: -20)
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .bottom, spacing: 3) {
                        ForEach(0..<5) { index in
                            RoundedRectangle(cornerRadius: 2).fill(index.isMultiple(of: 2) ? StoryPalette.sceneInk.opacity(0.65) : StoryPalette.amber)
                                .frame(width: 9, height: CGFloat(20 + index * 3))
                        }
                    }
                    RoundedRectangle(cornerRadius: 2).fill(StoryPalette.sceneInk.opacity(0.25)).frame(width: 86, height: 5)
                }.offset(x: -geometry.size.width * 0.29, y: -geometry.size.height * 0.28)
                Ellipse().fill(StoryPalette.sceneInk.opacity(0.09)).frame(width: geometry.size.width * 0.88, height: 30)
                    .offset(y: geometry.size.height * 0.39)
                HStack(alignment: .bottom, spacing: 0) {
                    StoryPortrait(character: .protagonist(age: moment?.age ?? 13))
                        .frame(width: geometry.size.width * 0.32)
                        .rotationEffect(.degrees(moment?.activity == .rest ? -7 : 0))
                    Spacer(minLength: 0)
                    if moment == nil || moment?.person != nil {
                        StoryPortrait(character: .teacher).frame(width: geometry.size.width * 0.30)
                    }
                }.padding(.horizontal, 8).offset(y: 13)
                RoundedRectangle(cornerRadius: 9).fill(Color(red: 0.65, green: 0.47, blue: 0.31))
                    .frame(width: geometry.size.width * 0.43, height: 14)
                    .overlay(alignment: .bottom) {
                        HStack { Rectangle().frame(width: 7); Spacer(); Rectangle().frame(width: 7) }
                            .foregroundStyle(Color(red: 0.56, green: 0.39, blue: 0.25)).frame(height: 33)
                            .padding(.horizontal, 12).offset(y: 32)
                    }
                    .offset(y: geometry.size.height * 0.25)
                activityProp
                    .id(moment?.activity.rawValue ?? "invitation")
                    .scaleEffect(compact ? 0.52 : 1)
                    .scaleEffect(reduceMotion || entered ? 1 : 0.94)
                    .offset(y: geometry.size.height * 0.04)
            }
            .onAppear {
                withAnimation(reduceMotion ? nil : .easeOut(duration: 0.25)) { entered = true }
            }
        }
    }

    private var testReceipt: String {
#if targetEnvironment(simulator)
        if ProcessInfo.processInfo.arguments.contains("-ui-testing") { return moment?.receipt ?? "" }
#endif
        return ""
    }

    private var activityProp: some View {
        VStack(spacing: 5) {
            Image(systemName: symbol).font(.system(size: 36, weight: .medium))
            Text(propTitle).font(.caption2.bold())
        }
        .foregroundStyle(StoryPalette.sceneInk)
        .frame(width: 96, height: 66)
        .background(Color(red: 0.99, green: 0.97, blue: 0.91), in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.7)))
    }

    private var symbol: String {
        switch moment?.activity {
        case .online: "laptopcomputer"
        case .paper: "book.pages"
        case .ask: "bubble.left.and.text.bubble.right"
        case .rest: "leaf"
        case nil: "pencil.and.outline"
        }
    }
    private var propTitle: String {
        switch moment?.activity {
        case .online: "線上圖解"
        case .paper: "紙本練習"
        case .ask: "先問一小步"
        case .rest: "留白也可以"
        case nil: "這次怎麼開始？"
        }
    }
}
