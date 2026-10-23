import SwiftUI

/// Presentation-only reuse of the existing four-expression atlas and three stage compositions.
enum WorkshopArt: String, CaseIterable, Identifiable {
    case idle, team, help
    var id: String { rawValue }
    var image: String {
        switch self { case .idle: "gs05-idle-focus-v2"; case .team: "va-friend-worktable-v2"; case .help: "va-teacher-worktable-v2" }
    }
    var title: String {
        switch self { case .idle: "一起觀察材料"; case .team: "一起試做，作品仍待調整"; case .help: "一起核對清單，工具尚待詢問" }
    }
}
struct WorkshopStage: View {
    let art: WorkshopArt
    var body: some View {
        GeometryReader { box in
            ZStack {
                Image("community-workshop").resizable().scaledToFill()
                    .frame(width:box.size.width,height:box.size.height).clipped()
                Image(art.image).resizable().scaledToFit()
                    .padding(.horizontal,8).padding(.vertical,6)
            }
        }
        .clipped().allowsHitTesting(false)
        .accessibilityElement(children:.ignore)
        .accessibilityLabel(art.title)
        .accessibilityIdentifier("workshop-art-\(art.id)")
    }
}
struct WorkshopExpression: View {
    let index: Int
    var body: some View {
        if let atlas=UIImage(named:"va-otter-emotions-v1")?.cgImage,
           let cell=atlas.cropping(to:CGRect(x:CGFloat((index % 2)*627),y:CGFloat((index / 2)*627),width:627,height:627)) {
            Image(uiImage:UIImage(cgImage:cell)).resizable().scaledToFit()
        }
    }
}
struct WorkshopArtCatalog: View {
    var body: some View {
        GeometryReader { box in
            VStack(spacing:8) {
                Text("阿澄 · 四表情／三個場景狀態").font(.headline)
                HStack {
                    ForEach(Array(["平靜","思考","期待","疲累"].enumerated()),id:\.offset) { index,title in
                        VStack { WorkshopExpression(index:index);Text(title).font(.caption2) }
                    }
                }.frame(height:110)
                ForEach(WorkshopArt.allCases) { art in
                    WorkshopStage(art:art).frame(height:max(100,(box.size.height-195)/3))
                        .overlay(alignment:.topLeading) { Text(art.title).font(.caption2).padding(5).background(.regularMaterial) }
                }
            }.padding(12)
        }.background(Color(red:0.98,green:0.96,blue:0.90))
    }
}
