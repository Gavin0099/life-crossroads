import SwiftUI
import LifeDomain

enum StoryPalette {
    static let forest = Color(red: 0.15, green: 0.36, blue: 0.29)
    static let amber = Color(red: 0.87, green: 0.63, blue: 0.27)
    static let page = Color(.systemGroupedBackground)
}

/// The same fictional cast accompanies every country. Species never encode nationality.
enum StoryCharacter: Int {
    case child, teen, adult, middle, elder, ahe, teacher, xiaocheng

    static func protagonist(age: Int) -> Self {
        switch age {
        case ...12: .child
        case ...22: .teen
        case ...40: .adult
        case ...60: .middle
        default: .elder
        }
    }

    static func companion(named name: String) -> Self? {
        if name.contains("阿禾") { return .ahe }
        if name.contains("樹老師") { return .teacher }
        if name.contains("小澄") { return .xiaocheng }
        return nil
    }
}

/// Crops a cell at display time; the generated PNG and its transparent alpha remain intact.
struct StoryPortrait: View {
    let character: StoryCharacter

    var body: some View {
        GeometryReader { geometry in
            Image("StoryCast")
                .resizable()
                .frame(width: geometry.size.width * 4, height: geometry.size.height * 2)
                .offset(x: -CGFloat(character.rawValue % 4) * geometry.size.width,
                        y: -CGFloat(character.rawValue / 4) * geometry.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipped()
        .accessibilityHidden(true)
    }
}

/// An allegorical stage, with cast chosen from the engine's actual current person or trace.
struct StoryScene: View {
    let age: Int
    let person: String
    let chapter: String
    let sceneID: String

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Image("RiverCrossroads")
                    .resizable().scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height).clipped()
                LinearGradient(colors: [.black.opacity(0.12), .clear, .black.opacity(0.23)],
                               startPoint: .top, endPoint: .bottom)
                HStack(alignment: .bottom, spacing: 8) {
                    StoryPortrait(character: .protagonist(age: age))
                        .frame(width: min(165, geometry.size.width * 0.46))
                    if let companion = StoryCharacter.companion(named: person) {
                        StoryPortrait(character: companion)
                            .frame(width: min(142, geometry.size.width * 0.39))
                    }
                }.padding(.bottom, 5)
            }
            .overlay(alignment: .topLeading) {
                Text(chapter).font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(StoryPalette.forest, in: Capsule())
                    .padding(14)
            }
        }
        .frame(height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(age)歲的沐沐\(StoryCharacter.companion(named: person) == nil ? "獨自站在" : "與\(person)站在")河畔故事場景")
        .accessibilityIdentifier(sceneID)
    }
}

struct StoryEyebrow: View {
    let title: String
    let icon: String
    var body: some View {
        Label(title, systemImage: icon)
            .font(.caption.weight(.bold))
            .foregroundStyle(.secondary)
    }
}

/// National observations are shown separately from the fictional family and stage.
struct CountryContextCard: View {
    let country: CountryProfile
    let catalog: ModelCatalog

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("\(country.name) · 真實資料背景", systemImage: "globe")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Text("看看這個國家的整體人口情況。")
                .font(.subheadline)
            ForEach(CountryProfile.requiredIndicators, id: \.self) { indicator in
                observationRow(indicator)
            }
            Text("這些人口比例不能推定沐沐家有沒有設備或電力；同一國家的家庭也可能不同。")
                .font(.footnote).foregroundStyle(.secondary)
            Text("河畔是大家共用的想像舞台，不是\(country.name)的實景。")
                .font(.footnote)
                .accessibilityIdentifier("countryStageBoundary")
            DisclosureGroup("查看數字與來源") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("畫面比例約至小數一位；以下保留資料包的原值。")
                        .font(.caption).foregroundStyle(.secondary)
                    ForEach(CountryProfile.requiredIndicators, id: \.self) { indicator in
                        sourceDetails(indicator)
                    }
                    if !country.gaps.isEmpty {
                        Text(country.gaps.joined(separator: "\n"))
                            .font(.footnote)
                    }
                }.padding(.top, 10)
            }
            .font(.subheadline)
            .accessibilityIdentifier("countryContextSources")
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.background, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(StoryPalette.forest.opacity(0.15), lineWidth: 1))
        .accessibilityIdentifier("countryContextCard")
    }

    private func observationRow(_ indicator: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title(for: indicator)).font(.subheadline.weight(.semibold))
            if let observation = observation(for: indicator), let value = observation.value {
                Text("約 \(value.formatted(.number.precision(.fractionLength(0...1))))\(observation.unit == "% of population" ? "%" : " \(observation.unit)")")
                    .font(.title3.weight(.bold)).monospacedDigit()
                Text("\(String(observation.year))年 · \(observation.unit == "% of population" ? "單位：全國人口百分比" : "單位：\(observation.unit)")")
                    .font(.caption).foregroundStyle(.secondary)
            } else {
                Text("尚無可用資料，待確認來源。")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("countryIndicator.\(indicator)")
    }

    @ViewBuilder
    private func sourceDetails(_ indicator: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title(for: indicator)).font(.subheadline.weight(.semibold))
            if let observation = observation(for: indicator), let value = observation.value {
                Text("原值：\(String(value)) · \(observation.unit) · \(String(observation.year))年")
                    .font(.footnote)
                if let source = catalog.sources.first(where: { $0.id == observation.sourceID }) {
                    Text(source.attribution).font(.caption)
                    Text(source.url).font(.caption).textSelection(.enabled)
                    Text("資料版本：\(observation.dataVersion) · 授權：\(source.license)")
                        .font(.caption).foregroundStyle(.secondary)
                } else {
                    Text("來源紀錄待確認；不能視為已驗證資料。")
                        .font(.footnote)
                }
            } else {
                Text("這個指標仍待補齊可核對的資料。")
                    .font(.footnote)
            }
        }
    }

    private func observation(for indicator: String) -> IndicatorObservation? {
        country.indicators.first { $0.indicator == indicator }
    }

    private func title(for indicator: String) -> String {
        switch indicator {
        case "IT.NET.USER.ZS": "使用網路的人口比例"
        case "EG.ELC.ACCS.ZS": "可取得電力的人口比例"
        default: indicator
        }
    }
}

struct BudgetToken: View {
    let title: String
    let value: Int
    let icon: String
    var body: some View {
        Label("\(title) \(value)", systemImage: icon)
            .font(.subheadline.weight(.semibold)).monospacedDigit()
            .padding(.horizontal, 10).padding(.vertical, 8)
            .background(StoryPalette.amber.opacity(0.14), in: RoundedRectangle(cornerRadius: 10))
            .accessibilityLabel("\(title)還有\(value)格")
    }
}
