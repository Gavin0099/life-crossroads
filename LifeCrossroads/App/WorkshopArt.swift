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
                let width=min(max(1,box.size.width-16),max(1,box.size.height-12)*1.5)
                ZStack {
                    Image(art.image).resizable().scaledToFit()
                    if art == .team { WorkshopPaperFacing() }
                }.frame(width:width,height:width/1.5)
            }
        }
        .clipped().allowsHitTesting(false)
        .accessibilityElement(children:.ignore)
        .accessibilityLabel(art.title)
        .accessibilityIdentifier("workshop-art-\(art.id)")
    }
}

/// Native paper surfaces registered to the existing 1536×1024 composition.
/// Only the prop's front faces are covered; the source character PNG and hand contacts are unchanged.
private struct WorkshopPaperFacing: View {
    var body: some View {
        Canvas { context,size in
            var context=context
            context.scaleBy(x:size.width/1536,y:size.height/1024)
            // Folded strips follow the original open truss; no opaque panel or character masking.
            func strip(_ a: CGPoint,_ b: CGPoint,_ width: CGFloat) {
                let length=hypot(b.x-a.x,b.y-a.y),nx = -(b.y-a.y)/length*width/2,ny=(b.x-a.x)/length*width/2
                var face=Path();face.addLines([.init(x:a.x+nx,y:a.y+ny),.init(x:b.x+nx,y:b.y+ny),.init(x:b.x-nx,y:b.y-ny),.init(x:a.x-nx,y:a.y-ny)]);face.closeSubpath()
                var shadow=context;shadow.addFilter(.shadow(color:.brown.opacity(0.24),radius:1,x:1,y:2))
                shadow.fill(face,with:.linearGradient(Gradient(colors:[Color(red:1,green:0.98,blue:0.88),Color(red:0.85,green:0.83,blue:0.70)]),startPoint:a,endPoint:b))
                var crease=Path();crease.move(to:a);crease.addLine(to:b)
                context.stroke(crease,with:.color(.white.opacity(0.75)),lineWidth:1.5)
            }
            let joints: [CGPoint]=[.init(x:608,y:687),.init(x:650,y:617),.init(x:686,y:688),.init(x:744,y:618),.init(x:815,y:689),.init(x:873,y:630),.init(x:927,y:691),.init(x:958,y:638)]
            for i in 0..<(joints.count-1) { strip(joints[i],joints[i+1],13) }
            strip(.init(x:606,y:693),.init(x:948,y:697),9)
            // Doubled thin deck lip and visible fold seams on the kraft-paper supports.
            strip(.init(x:553,y:615),.init(x:999,y:633),5)
            var seams=Path();seams.move(to:.init(x:482,y:687));seams.addLine(to:.init(x:482,y:711))
            seams.move(to:.init(x:1062,y:689));seams.addLine(to:.init(x:1070,y:717))
            context.stroke(seams,with:.color(.white.opacity(0.6)),style:StrokeStyle(lineWidth:1.5,dash:[5,2]))
        }.allowsHitTesting(false).accessibilityHidden(true)
    }
}

/// An interactive inspection diagram, not a new character image or a simulated construction result.
struct WorkshopPaperStudy: View {
    let folded: Bool
    let checklist: Bool
    var body: some View {
        Canvas { context,size in
            var context=context
            context.scaleBy(x:size.width/360,y:size.height/180)
            let ink=Color(red:0.25,green:0.43,blue:0.42)
            if checklist {
                let sheet=Path(roundedRect:CGRect(x:65,y:12,width:230,height:156),cornerRadius:2)
                context.fill(sheet,with:.color(.white));context.stroke(sheet,with:.color(ink),lineWidth:1.5)
                for i in 0..<4 {
                    let y=35+CGFloat(i)*30
                    context.stroke(Path(CGRect(x:85,y:y,width:13,height:13)),with:.color(ink),lineWidth:1.5)
                    var line=Path();line.move(to:.init(x:111,y:y+7));line.addLine(to:.init(x:270,y:y+7))
                    context.stroke(line,with:.color(ink.opacity(0.4)),lineWidth:2)
                }
            } else if folded {
                for i in 0..<8 {
                    let x=25+CGFloat(i)*38
                    var front=Path();front.addLines([.init(x:x,y:90),.init(x:x+19,y:37),.init(x:x+19,y:109),.init(x:x,y:153)]);front.closeSubpath()
                    context.fill(front,with:.color(.white));context.stroke(front,with:.color(ink),lineWidth:1)
                    var back=Path();back.addLines([.init(x:x+19,y:37),.init(x:x+38,y:90),.init(x:x+38,y:153),.init(x:x+19,y:109)]);back.closeSubpath()
                    context.fill(back,with:.color(Color(red:0.82,green:0.89,blue:0.88)));context.stroke(back,with:.color(ink),lineWidth:1)
                }
            } else {
                var sheet=Path();sheet.addLines([.init(x:32,y:24),.init(x:306,y:24),.init(x:330,y:48),.init(x:330,y:154),.init(x:32,y:154)]);sheet.closeSubpath()
                context.fill(sheet,with:.color(.white));context.stroke(sheet,with:.color(ink),lineWidth:1.5)
                var corner=Path();corner.addLines([.init(x:306,y:24),.init(x:306,y:48),.init(x:330,y:48)])
                context.stroke(corner,with:.color(ink),lineWidth:1)
                for x in stride(from:CGFloat(70),through:298,by:38) {
                    var crease=Path();crease.move(to:.init(x:x,y:32));crease.addLine(to:.init(x:x,y:147))
                    context.stroke(crease,with:.color(ink.opacity(0.5)),style:StrokeStyle(lineWidth:1,dash:[4,5]))
                }
            }
        }
        .accessibilityElement(children:.ignore)
        .accessibilityLabel(checklist ? "尚未勾選的準備清單":folded ? "連續摺線與薄紙邊的摺紙結構":"攤開的紙面與虛線摺痕")
        .accessibilityIdentifier("workshop-paper-study")
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
