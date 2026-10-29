import SwiftUI
import LifeDomain
import LifeData

struct BirthRevealView: View {
    let session: LifeSession
    let catalog: ModelCatalog
    let continueLife: () -> Void
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("你的出身 · 人生的起點").font(.title2.bold()).accessibilityIdentifier("birthReveal")
                    Text("出生於" + (catalog.countries.first { $0.code == session.state.countryCode }?.name ?? session.state.countryCode))
                        .font(.title.bold()).accessibilityIdentifier("birthCountry").accessibilityValue(session.state.countryCode)
                    CompactStoryScene(age: 8, person: "", sceneID: "birthStoryScene").frame(height: 180)
                    Text("先翻開出生背景；接著陪沐沐走進童年。這張圖是童年造型與想像場景。")
                        .font(.caption).foregroundStyle(StoryPalette.secondaryInk)
                    if let family = catalog.households.first(where: { $0.id == session.state.householdID }) {
                        Text(BirthStory.household(family)).font(.body)
                        Text("虛構家庭：" + family.label).font(.subheadline)
                            .accessibilityIdentifier("birthHousehold").accessibilityValue(family.id)
                    }
                    Text("出身帶來一些安排與限制，但沒有替你決定往後的故事。").font(.headline)
                    DisclosureGroup("這個出身怎麼來的？") {
                        Text(session.birthDraw != nil ? BirthDraw.scope : "你在探索模式選擇了另一個示範背景；沿用原人生的種子，沒有代替你選擇接下來的行動。")
                        if let draw = session.birthDraw {
                            Text("抽選版本：\(draw.version)；\(draw.candidateIDs.count)個候選情境；種子\(draw.seed)。").font(.caption)
                        }
                        if let country = catalog.countries.first(where: { $0.code == session.state.countryCode }) {
                            CountryContextCard(country: country, catalog: catalog)
                        }
                    }.font(.subheadline)
                }.padding(20)
            }.safeAreaInset(edge: .bottom) {
                Button("走進童年") { continueLife() }.buttonStyle(JourneyButtonStyle())
                    .accessibilityIdentifier("enterChildhood").padding(12).background(.bar)
            }.navigationTitle("人生的第一頁").navigationBarTitleDisplayMode(.inline)
        }.interactiveDismissDisabled()
    }
}

struct ParallelBirthPicker: View {
    let original: LifeSession
    let catalog: ModelCatalog
    let begin: (String, String, Bool) -> Bool
    @State private var advanced = false
    @State private var selectedHouseholdID: String?
    @Environment(\.dismiss) private var dismiss
    private var selected: HouseholdProfile? { catalog.households.first { $0.id == selectedHouseholdID } }
    private var candidates: [HouseholdProfile] {
        advanced ? catalog.households.filter { $0.id != original.state.householdID }
            : ParallelLifeExperiment.matchingHouseholds(original: original, catalog: catalog)
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("如果帶著同一個願望，出生在另一個地方？").font(.title2.bold())
                    Text("\(ParallelLifeExperiment.wish)。你仍可投入、求助或暫緩，沒有指定的正確路線。")
                    Text("原人生完整保留。從童年重新走完15次選擇，使用相同種子；背景與後續行動可能都不同，不能把所有差異歸因於國家。")
                        .font(.subheadline)
                    Text(advanced ? "進階探索：國家與家庭都可能改變，不能單獨判斷國家影響。" : "預設固定同一家庭模板與所有家庭條件，只改出生環境。後續行動仍由你決定。")
                        .accessibilityIdentifier("parallelControl")
                    Toggle("進階：也探索不同家庭", isOn: $advanced)
                        .accessibilityIdentifier("advancedParallel")
                        .onChange(of: advanced) { _, _ in selectedHouseholdID = nil }
                    ForEach(catalog.countries.filter { $0.dataStatus != .blocked }, id: \.code) { country in
                        Text(country.name).font(.headline)
                        ForEach(candidates.filter { $0.countryCode == country.code }, id: \.id) { household in
                            Button { selectedHouseholdID = household.id } label: {
                                HStack {
                                    Text(household.label).multilineTextAlignment(.leading)
                                    Spacer()
                                    if selectedHouseholdID == household.id { Image(systemName: "checkmark.circle.fill") }
                                }.frame(minHeight: 44).contentShape(Rectangle())
                            }.buttonStyle(.bordered).accessibilityIdentifier("parallelHousehold.\(household.id)")
                        }
                    }
                    if let selected {
                        Text(BirthStory.household(selected)).font(.subheadline)
                        if let country = catalog.countries.first(where: { $0.code == selected.countryCode }) {
                            CountryContextCard(country: country, catalog: catalog)
                        }
                        Button("保留原人生，開始另一個出身") {
                            if begin(selected.countryCode, selected.id, !advanced) { dismiss() }
                        }.buttonStyle(JourneyButtonStyle()).accessibilityIdentifier("beginParallel")
                    }
                    Text(BirthDraw.scope).font(.caption)
                }.padding(20)
            }.navigationTitle("探索另一個出身").navigationBarTitleDisplayMode(.inline)
                .toolbar { Button("取消") { dismiss() }.accessibilityIdentifier("cancelParallel") }
        }
    }
}
