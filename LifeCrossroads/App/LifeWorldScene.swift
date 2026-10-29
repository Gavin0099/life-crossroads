import SwiftUI
import LifePresentation
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

/// Render-only world. Gameplay supplies a committed projection and its single accumulated clock.
/// Activity atlases contain explicit poses; no independent clock or outcome inference.
struct LifeWorldScene: View {
    let frame: LifeWorldFrame
    let motion: PresentationMotionFrame
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @Environment(\.dynamicTypeSize) private var typeSize

    private var reduced: Bool { systemReduceMotion || motion.reduceMotion }

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack {
                if let cast = WorldCastScene.project(frame) {
                    if let memory = frame.relationshipMemory, frame.moment == .committedOutcome,
                       cast.personID == memory.presentPersonID, cast.choiceID == memory.present.choiceID {
                        relationshipScene(memory, cast: cast, size: size)
                    } else { castScene(cast, size: size) }
                } else if let activity = WorldActivity.project(frame) {
                    illustratedActivity(activity, size: size)
                } else if let setting = WorldActivity.neutralSetting(frame) {
                    neutralScene(background: setting.background, cell: setting.cell, size: size)
                } else {
                if let background = croppedBackground(size: size) {
                    Image(decorative: background, scale: 1).resizable()
                        .frame(width: size.width, height: size.height)
                } else { StoryPalette.sceneInk.opacity(0.25) }
                LinearGradient(colors: [.clear, Color(red: 0.97, green: 0.92, blue: 0.78).opacity(0.20)],
                               startPoint: .top, endPoint: .bottom)
                if !typeSize.isAccessibilitySize {
                    riverRipples(size: size)
                    stageFurniture(size: size)
                }
                ForEach(Array(frame.actors.enumerated()), id: \.offset) { index, actor in
                    if let character = portrait(for: actor.personID) {
                        actorView(character, index: index, size: size)
                    }
                }
                activitySurface(size: size)
                if !typeSize.isAccessibilitySize && !visibleTokens.isEmpty {
                    tokenShelf(size: size)
                }
                }
            }
            .frame(width: size.width, height: size.height)
            .clipped()
        }
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(spokenScene)
        .accessibilityValue(spokenChanges)
        .accessibilityIdentifier("lifeWorldScene")
        // No implicit/repeating animation can continue after Gameplay freezes its supplied time.
        .transaction { $0.animation = nil }
    }

    /// Separate people are selected from actual event evidence. Their contacted paper/tools
    /// remain inside each pose cell; changing a pose never changes a saved story fact.
    @ViewBuilder private func castScene(_ cast: WorldCastScene, size: CGSize) -> some View {
        if cast.kind == .remoteExchange, let activity = WorldActivity.project(frame) {
            illustratedActivity(activity, size: size)
        } else {
            ZStack {
                if let scene = WorldSceneBitmaps.scene(cast.background, size: size) {
                    Image(decorative: scene, scale: 1).resizable().frame(width: size.width, height: size.height)
                }
                let main = castMainPose(cast)
                let other = castCompanionPose(cast)
                let working = [.explaining, .sharedMaking, .pacedParticipation].contains(cast.kind)
                if let companion = WorldSceneBitmaps.cell(other.atlas, index: other.cell, columns: other.columns, rows: other.rows) {
                    grounded(companion, width: size.width * (working ? 0.33 : 0.40), height: size.height * 0.90,
                             x: size.width * (working ? 0.79 : 0.72), floor: size.height * 0.98)
                }
                if cast.kind == .requesting,
                   let asking = WorldSceneBitmaps.requestPose(age: cast.age, listening: false),
                   let listening = WorldSceneBitmaps.requestPose(age: cast.age, listening: true) {
                    let blend = reduced ? 0 : WorldRequestTransition.listeningOpacity(frame: frame, motion: motion)
                    // Both poses use one reviewed crop, scale and floor. No independent
                    // alpha trim, timer or implicit animation may move the held objects.
                    ZStack {
                        grounded(asking, width: size.width * 0.43, height: size.height * 0.94,
                                 x: size.width * 0.29, floor: size.height * 0.98).opacity(1 - blend)
                        grounded(listening, width: size.width * 0.43, height: size.height * 0.94,
                                 x: size.width * 0.29, floor: size.height * 0.98)
                            .opacity(blend).blendMode(.plusLighter)
                    }.compositingGroup()
                } else if let protagonist = WorldSceneBitmaps.cell(main.atlas, index: main.cell, columns: main.columns, rows: main.rows) {
                    grounded(protagonist, width: size.width * (working ? 0.65 : 0.43), height: size.height * 0.94,
                             x: size.width * (working ? 0.39 : 0.29), floor: size.height * 0.98)
                }
            }
        }
    }

    private typealias CastPose = (atlas: String, cell: Int, columns: Int, rows: Int)
    private func castMainPose(_ cast: WorldCastScene) -> CastPose {
        if cast.kind == .invitation {
            if cast.age == 10 { return ("StoryCast", 0, 4, 2) }
            if cast.age == 72 { return ("StoryCast", 4, 4, 2) }
            if cast.age == 32, WorldActivity.project(frame)?.kind == .protectedRest { return ("VL2Recovery32", 0, 2, 1) }
            return neutralPose
        }
        switch cast.kind {
        case .requesting where cast.age == 13: return ("VL2Teen13", 2, 2, 2)
        case .explaining: return ("VL2Teen13", 1, 2, 2)
        case .sharedMaking: return (cast.age == 17 ? "VL2Teen17" : "VL2Adult25", 1, 2, 1)
        case .pacedParticipation: return ("VL2Recovery32", 1, 2, 1)
        case .reunion, .newConnection: return ("MCMumu", 3, 2, 2)
        case .planning: return ("StoryCast", 4, 4, 2)
        default: return ("MCMumu", cast.age == 10 ? 0 : cast.age < 23 ? 1 : 2, 2, 2)
        }
    }
    private func castCompanionPose(_ cast: WorldCastScene) -> CastPose {
        switch cast.personID {
        case "ahe":
            let cell = cast.age < 13 ? (cast.kind == .conversation ? 1 : 0) : cast.age < 61 ? 3 : cast.kind == .reunion ? 5 : 4
            return ("MCAhe", cell, 3, 2)
        case "teacher":
            let cell = cast.kind == .explaining ? 1 : cast.kind == .sharedMaking ? 2 : 0
            return ("MCTeacher", cell, 2, 2)
        default:
            let cell = cast.age == 72 ? (cast.kind == .newConnection ? 5 : 4) : cast.kind == .pacedParticipation ? 3 : cast.kind == .requesting ? 0 : 1
            return ("MCCheng", cell, 3, 2)
        }
    }

    private var neutralPose: CastPose {
        switch frame.stage {
        case .childhood: ("StoryCast", 0, 4, 2)
        case .adolescence: ("IMNeutralStages", 0, 3, 1)
        case .youngAdult: ("IMNeutralStages", 1, 3, 1)
        case .middleAge: ("IMNeutralStages", 2, 3, 1)
        case .laterLife: ("StoryCast", 4, 4, 2)
        }
    }

    /// The smaller panel is an actual earlier choice, not an invented childhood with today's cast.
    private func relationshipScene(_ memory: WorldRelationshipMemory, cast: WorldCastScene, size: CGSize) -> some View {
        HStack(spacing: 3) {
            ZStack(alignment: .topLeading) {
                if let bg = WorldSceneBitmaps.scene("VL2Garden", size: CGSize(width: size.width * 0.32, height: size.height)) {
                    Image(decorative: bg, scale: 1).resizable()
                }
                Color(red: 0.93, green: 0.85, blue: 0.64).opacity(0.25)
                let w = size.width * 0.32
                if let mumu = WorldSceneBitmaps.cell(memory.keptFriendship ? "MCMumu" : "StoryCast", index: 0, columns: memory.keptFriendship ? 2 : 4, rows: 2) {
                    // A shared childhood height cap makes the two histories comparable;
                    // the solo route stays solo instead of inventing a childhood companion.
                    grounded(mumu, width: w * 0.54, height: size.height * 0.42,
                             x: w * (memory.keptFriendship ? 0.30 : 0.5), floor: size.height * 0.91)
                }
                if memory.keptFriendship, let ahe = WorldSceneBitmaps.cell("MCAhe", index: 1, columns: 3, rows: 2) {
                    grounded(ahe, width: w * 0.47, height: size.height * 0.42, x: w * 0.74, floor: size.height * 0.91)
                }
                Text("10歲 · 那時").foregroundStyle(StoryPalette.sceneInk).font(.system(size: 11, weight: .bold, design: .rounded)).lineLimit(1).padding(5)
                    .background(StoryPalette.scenePaper, in: RoundedRectangle(cornerRadius: 7)).padding(4)
            }.frame(width: size.width * 0.32, height: size.height).clipped()
            ZStack(alignment: .topLeading) {
                // Reserve a real caption band. Its compact labels duplicate the full spoken
                // receipt and the large external age; they must never cover either face.
                castScene(cast, size: CGSize(width: size.width * 0.68 - 3, height: size.height - 26))
                    .frame(width: size.width * 0.68 - 3, height: size.height - 26).offset(y: 26)
                Text("72歲 · 現在").foregroundStyle(StoryPalette.sceneInk).font(.system(size: 11, weight: .bold, design: .rounded)).lineLimit(1).padding(5)
                    .background(StoryPalette.scenePaper, in: RoundedRectangle(cornerRadius: 7)).padding(4)
            }.frame(width: size.width * 0.68 - 3, height: size.height, alignment: .topLeading).clipped()
        }.background(StoryPalette.illustratedPaper)
    }

    private func neutralScene(background: String, cell: Int, size: CGSize) -> some View {
        ZStack {
            if let scene = WorldSceneBitmaps.scene(background, size: size) {
                Image(decorative: scene, scale: 1).resizable().frame(width: size.width, height: size.height)
            }
            let pose = neutralPose
            if let actor = WorldSceneBitmaps.cell(pose.atlas, index: pose.cell, columns: pose.columns, rows: pose.rows) {
                grounded(actor, width: size.width * 0.46, height: size.height * 0.91,
                         x: size.width * 0.48, floor: size.height * 0.98)
            }
        }
    }

    /// The foreground is an actual pose with its contacted tools. Companions remain independent
    /// layers so an invitation, failed choice or missing relationship cannot paint a helper.
    @ViewBuilder private func illustratedActivity(_ activity: WorldActivity, size: CGSize) -> some View {
        ZStack {
            if let background = WorldSceneBitmaps.scene(activity.background, size: size) {
                Image(decorative: background, scale: 1).resizable().frame(width: size.width, height: size.height)
            }
            let hasCompanion = activity.companionID != nil && ![.onlinePractice, .paperPractice, .trialWork].contains(activity.kind)
            let remote = activity.kind == .remoteCollaboration
            let foregroundHeight = size.height * 0.94
            if hasCompanion && !remote, let companion = WorldSceneBitmaps.cell("VL2Companions", index: companionCell(activity), columns: 2, rows: 2) {
                grounded(companion, width: size.width * 0.34, height: size.height * 0.96,
                         x: size.width * 0.79, floor: size.height * 0.98)
            }
            if let actor = WorldSceneBitmaps.cell(activity.atlas, index: activity.cell, columns: 2, rows: activity.rows) {
                fitted(actor, width: size.width * (hasCompanion ? 0.69 : 0.82), height: foregroundHeight)
                    .position(x: size.width * (hasCompanion ? 0.43 : 0.50), y: size.height * 0.52)
            }
            if hasCompanion && remote,
               let actor = WorldSceneBitmaps.cell(activity.atlas, index: activity.cell, columns: 2, rows: activity.rows),
               let companion = WorldSceneBitmaps.cell("MCTeacher", index: 0, columns: 2, rows: 2) {
                // Bind the call inset to the monitor within the scaled actor bitmap, not viewport
                // percentages: the world is shorter with Dynamic Type on a small phone.
                let scale = min(size.width * 0.69 / CGFloat(actor.width), foregroundHeight / CGFloat(actor.height))
                let actorWidth = CGFloat(actor.width) * scale
                let actorHeight = CGFloat(actor.height) * scale
                let portrait = companion.cropping(to: CGRect(x: 0, y: 0, width: companion.width, height: Int(Double(companion.height) * 0.64))) ?? companion
                fitted(portrait, width: actorWidth * 0.20, height: actorHeight * 0.26)
                    .padding(1).background(Color(red: 0.93, green: 0.92, blue: 0.82))
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(StoryPalette.sceneInk, lineWidth: 1.5))
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .position(x: size.width * 0.43 + actorWidth * 0.365,
                              y: size.height * 0.52 - actorHeight * 0.18)
            }
            // Shared accumulated time controls only light, not poses, choices or state.
            if !reduced {
                Color.white.opacity(0.012 + 0.006 * LifeWorldMotion.pose(elapsedMs: motion.elapsedMs, reduceMotion: false).rippleHorizontal)
                    .blendMode(.softLight).allowsHitTesting(false)
            }
        }.frame(width: size.width, height: size.height).clipped()
    }

    private func companionCell(_ activity: WorldActivity) -> Int {
        if activity.companionID == "cheng" { return activity.kind == .asking ? 2 : 3 }
        return activity.kind == .asking ? 0 : 1
    }

    private func grounded(_ image: CGImage, width: CGFloat, height: CGFloat, x: CGFloat, floor: CGFloat) -> some View {
        let scale = min(width / CGFloat(image.width), height / CGFloat(image.height))
        return fitted(image, width: width, height: height)
            .position(x: x, y: floor - CGFloat(image.height) * scale / 2)
    }

    private func fitted(_ image: CGImage, width: CGFloat, height: CGFloat) -> some View {
        let scale = min(width / CGFloat(image.width), height / CGFloat(image.height))
        return Image(decorative: image, scale: 1).resizable()
            .frame(width: CGFloat(image.width) * scale, height: CGFloat(image.height) * scale)
    }

    enum ActivityProp: String {
        case cardboardPractice, storedBox, requestNote, onlineGuide, paperGuide, pausedWork, supportCalendar, restCalendar, pacedCard, returnedCalendar, careChecklist, toolBox, poweredTools, portableTools

        var title: String {
            switch self {
            case .cardboardPractice: "紙箱練習"
            case .storedBox: "收好紙箱"
            case .requestNote: "求助紀錄"
            case .onlineGuide: "線上圖解"
            case .paperGuide: "紙本練習"
            case .pausedWork: "保留時間"
            case .supportCalendar: "協助約定"
            case .restCalendar: "留下休息空白"
            case .pacedCard: "試過短時參與"
            case .returnedCalendar: "依步調再參與"
            case .careChecklist: "預備清單"
            case .toolBox: "工具經驗"
            case .poweredTools: "現場工具桌"
            case .portableTools: "手動攜帶箱"
            }
        }
    }

    struct PropEvidence: Equatable {
        let prop: ActivityProp
        let source: WorldChangeProjection
    }

    /// A drawing interpretation of an existing fact, never a new story state. In particular,
    /// the eight-year activity has no persistent StoryFact and only appears in that outcome.
    static func activityEvidence(in frame: LifeWorldFrame) -> PropEvidence? {
        if frame.age == 8, frame.moment == .committedOutcome, frame.eventID == "child-interest",
           let source = frame.worldChanges.first(where: {
               $0.isOccurred && $0.kind == .resourceChange && $0.sourceEventID == "child-interest" && $0.sourceAge == 8
           }) {
            let prop: ActivityProp?
            switch source.sourceChoiceID {
            case "invest": prop = .cardboardPractice
            case "ask": prop = .requestNote
            case "rest": prop = .storedBox
            default: prop = nil
            }
            return prop.map { .init(prop: $0, source: source) }
        }
        if let source = frame.worldChanges.filter({ $0.isOccurred && $0.kind == .memory &&
            ["support", "recovery", "careAccess", "tools"].contains($0.factKey ?? "") }).max(by: { $0.sourceAge < $1.sourceAge }), source.sourceAge > 13 {
            let prop: ActivityProp
            switch source.factKey {
            case "support": prop = source.factValue == "requested" ? .requestNote : .supportCalendar
            case "recovery": prop = source.factValue == "paced" ? .pacedCard : source.factValue == "returned" ? .returnedCalendar : .restCalendar
            case "careAccess": prop = source.factValue == "seeking" ? .requestNote : .careChecklist
            default:
                prop = source.factValue == "powered" || source.sourceChoiceID == "benchWork" ? .poweredTools
                    : source.factValue == "portable" || source.sourceChoiceID == "mobileRepair" ? .portableTools : .toolBox
            }
            return .init(prop: prop, source: source)
        }
        guard frame.age >= 13, let source = frame.worldChanges.last(where: {
            $0.isOccurred && $0.kind == .memory && $0.sourceEventID == "teen-project" && $0.sourceAge == 13
        }) else { return nil }
        let prop: ActivityProp?
        switch source.sourceChoiceID {
        case "invest": prop = .onlineGuide
        case "offline": prop = .paperGuide
        case "ask": prop = .requestNote
        case "rest": prop = .pausedWork
        default: prop = nil
        }
        return prop.map { .init(prop: $0, source: source) }
    }

    static func projectEcho(in frame: LifeWorldFrame) -> WorldChangeProjection? {
        guard frame.age == 17 else { return nil }
        return frame.worldChanges.first {
            $0.isOccurred && $0.kind == .delayedConsequence && $0.sourceEventID == "teen-project" && $0.sourceAge == 13
        }
    }

    @ViewBuilder private func activitySurface(size: CGSize) -> some View {
        if let evidence = Self.activityEvidence(in: frame) {
            let width = min(size.width * 0.36, size.height * 0.66)
            let height = width * 0.72
            ZStack {
                Ellipse().fill(.black.opacity(0.15)).frame(width: width * 0.96, height: height * 0.12)
                    .position(x: width / 2, y: height * 0.94)
                HStack {
                    RoundedRectangle(cornerRadius: 1).frame(width: width * 0.07)
                    Spacer()
                    RoundedRectangle(cornerRadius: 1).frame(width: width * 0.07)
                }
                .foregroundStyle(Color(red: 0.48, green: 0.31, blue: 0.19))
                .frame(width: width * 0.76, height: height * 0.46)
                .position(x: width / 2, y: height * 0.70)
                RoundedRectangle(cornerRadius: 3)
                    .fill(LinearGradient(colors: [Color(red: 0.75, green: 0.54, blue: 0.32), Color(red: 0.48, green: 0.31, blue: 0.19)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: width, height: max(5, height * 0.11))
                    .position(x: width / 2, y: height * 0.44)
                activityDrawing(evidence.prop)
                    .frame(width: width * 0.76, height: height * 0.43)
                    .position(x: width / 2, y: height * 0.22)
                HStack(spacing: 3) {
                    Text("\(evidence.source.sourceAge)歲")
                    Text(evidence.prop.title).fontWeight(.semibold)
                }
                .font(.system(size: min(11, max(9, size.height * 0.043))))
                .foregroundStyle(StoryPalette.sceneInk)
                .padding(.horizontal, 7).padding(.vertical, 3)
                .background(Color(red: 0.99, green: 0.95, blue: 0.82), in: RoundedRectangle(cornerRadius: 3))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(.brown.opacity(0.30), lineWidth: 0.7))
                .position(x: width / 2, y: height * 0.64)
            }
            .frame(width: width, height: height)
            .position(x: size.width * 0.76, y: size.height * 0.96 - height / 2)

            if let echo = Self.projectEcho(in: frame) {
                storyNote(title: "17歲的呼應", symbol: "arrow.turn.down.right", sealed: false)
                    .frame(width: min(100, size.width * 0.28), height: min(45, size.height * 0.26))
                    .position(x: size.width * (typeSize.isAccessibilitySize ? 0.16 : 0.84),
                              y: size.height * (typeSize.isAccessibilitySize ? 0.81 : 0.14))
                    .accessibilityLabel(echo.caption)
            } else if frame.worldChanges.contains(where: {
                $0.kind == .pendingClue && !$0.isOccurred && $0.sourceEventID == "teen-project" && $0.sourceAge == 13
            }) {
                storyNote(title: "線索・尚未發生", symbol: "clock", sealed: true)
                    .frame(width: min(100, size.width * 0.28), height: min(45, size.height * 0.26))
                    .position(x: size.width * (typeSize.isAccessibilitySize ? 0.16 : 0.84),
                              y: size.height * (typeSize.isAccessibilitySize ? 0.81 : 0.14))
            }
        }
    }

    private func storyNote(title: String, symbol: String, sealed: Bool) -> some View {
        VStack(spacing: 3) {
            Image(systemName: symbol).font(.system(size: 16, weight: .medium))
            Text(title).font(.system(size: 9, weight: .semibold))
        }
        .foregroundStyle(StoryPalette.sceneInk)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.99, green: 0.95, blue: 0.82), in: RoundedRectangle(cornerRadius: 3))
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(.brown.opacity(0.45), style: StrokeStyle(lineWidth: 0.8, dash: sealed ? [3, 2] : [])))
        .rotationEffect(.degrees(-4))
        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 2)
    }

    @ViewBuilder private func activityDrawing(_ prop: ActivityProp) -> some View {
        switch prop {
        case .poweredTools, .portableTools:
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: prop == .portableTools ? 7 : 2)
                    .fill(Color(red: 0.69, green: 0.42, blue: 0.24)).padding(.top, 10)
                if prop == .portableTools {
                    RoundedRectangle(cornerRadius: 4).stroke(.brown, lineWidth: 4).frame(width: 23, height: 13)
                }
                Image(systemName: prop == .poweredTools ? "powerplug" : "wrench.and.screwdriver")
                    .font(.system(size: 24)).foregroundStyle(.white.opacity(0.9)).padding(.top, 15)
            }.padding(.horizontal, 10)
        case .supportCalendar, .restCalendar, .pacedCard, .returnedCalendar, .careChecklist, .toolBox:
            storyNote(title: prop.title,
                      symbol: prop == .toolBox ? "wrench.and.screwdriver" : prop == .careChecklist ? "list.clipboard" : prop == .restCalendar ? "leaf" : prop == .pacedCard ? "clock" : "calendar.badge.clock",
                      sealed: false)
        case .cardboardPractice, .storedBox:
            GeometryReader { g in
                let w = g.size.width, h = g.size.height
                ZStack {
                    Path { p in p.move(to: .init(x: w * 0.1, y: h * 0.35)); for point in [
                        .init(x: w * 0.65, y: h * 0.18), .init(x: w * 0.94, y: h * 0.42),
                        CGPoint(x: w * 0.40, y: h * 0.59)] { p.addLine(to: point) }; p.closeSubpath() }
                        .fill(Color(red: 0.84, green: 0.67, blue: 0.43))
                    Path { p in p.move(to: .init(x: w * 0.10, y: h * 0.35)); for point in [
                        .init(x: w * 0.40, y: h * 0.59), .init(x: w * 0.40, y: h * 0.96), CGPoint(x: w * 0.10, y: h * 0.72)] { p.addLine(to: point) }; p.closeSubpath() }
                        .fill(Color(red: 0.64, green: 0.45, blue: 0.27))
                    Path { p in p.move(to: .init(x: w * 0.40, y: h * 0.59)); for point in [
                        .init(x: w * 0.94, y: h * 0.42), .init(x: w * 0.94, y: h * 0.80), CGPoint(x: w * 0.40, y: h * 0.96)] { p.addLine(to: point) }; p.closeSubpath() }
                        .fill(Color(red: 0.76, green: 0.55, blue: 0.33))
                    if prop == .cardboardPractice {
                        RoundedRectangle(cornerRadius: 1).fill(Color(red: 0.99, green: 0.96, blue: 0.84))
                            .frame(width: w * 0.36, height: h * 0.43).rotationEffect(.degrees(-14))
                            .position(x: w * 0.50, y: h * 0.25)
                        Path { p in p.move(to: .init(x: w * 0.41, y: h * 0.17)); p.addLine(to: .init(x: w * 0.57, y: h * 0.33)) }
                            .stroke(StoryPalette.sceneInk.opacity(0.6), lineWidth: 1)
                    } else {
                        Image(systemName: "leaf").font(.system(size: max(13, h * 0.40)))
                            .foregroundStyle(StoryPalette.sceneInk).position(x: w * 0.54, y: h * 0.43)
                    }
                }
            }
        case .onlineGuide, .paperGuide:
            GeometryReader { g in
                let w = g.size.width, h = g.size.height
                ZStack {
                    RoundedRectangle(cornerRadius: 3).fill(Color(red: 0.54, green: 0.34, blue: 0.22))
                        .frame(width: w * 0.92, height: h * 0.80).offset(y: h * 0.08)
                    HStack(spacing: 1) {
                        Rectangle().fill(Color(red: 1, green: 0.98, blue: 0.88))
                        Rectangle().fill(Color(red: 0.94, green: 0.88, blue: 0.72))
                    }.frame(width: w * 0.86, height: h * 0.76)
                    Path { p in
                        p.move(to: .init(x: w * 0.17, y: h * 0.58)); p.addLine(to: .init(x: w * 0.28, y: h * 0.27))
                        p.addLine(to: .init(x: w * 0.40, y: h * 0.58)); p.addLine(to: .init(x: w * 0.17, y: h * 0.58))
                        p.move(to: .init(x: w * 0.56, y: h * 0.31)); p.addLine(to: .init(x: w * 0.82, y: h * 0.31))
                        p.move(to: .init(x: w * 0.56, y: h * 0.48)); p.addLine(to: .init(x: w * 0.77, y: h * 0.48))
                    }.stroke(StoryPalette.sceneInk.opacity(0.65), lineWidth: 1.2)
                    if prop == .onlineGuide {
                        Image(systemName: "wifi").font(.system(size: max(12, h * 0.35), weight: .semibold))
                            .foregroundStyle(StoryPalette.sceneInk).position(x: w * 0.80, y: h * 0.72)
                    } else {
                        Rectangle().fill(Color(red: 0.68, green: 0.31, blue: 0.22))
                            .frame(width: 4, height: h * 0.80).position(x: w * 0.50, y: h * 0.55)
                    }
                }.rotationEffect(.degrees(-7))
            }
        case .requestNote:
            storyNote(title: "正在找起點", symbol: "questionmark", sealed: false)
                .rotationEffect(.degrees(9)).padding(.horizontal, 10)
        case .pausedWork:
            ZStack {
                RoundedRectangle(cornerRadius: 3).fill(Color(red: 0.79, green: 0.64, blue: 0.42))
                Rectangle().fill(Color(red: 0.93, green: 0.85, blue: 0.66)).frame(height: 5)
                Image(systemName: "leaf").font(.system(size: 24)).foregroundStyle(StoryPalette.sceneInk)
            }.padding(.horizontal, 9).padding(.vertical, 3).rotationEffect(.degrees(-5))
        }
    }

    private func croppedBackground(size: CGSize) -> CGImage? {
        guard let image = WorldSceneBitmaps.background, size.width > 0, size.height > 0 else { return nil }
        let scale = max(size.width / Double(image.width), size.height / Double(image.height))
        let width = size.width / scale, height = size.height / scale
        return image.cropping(to: CGRect(x: (Double(image.width) - width) / 2,
            y: (Double(image.height) - height) / 2, width: width, height: height).integral)
    }
    private func croppedPortrait(_ character: StoryCharacter) -> CGImage? {
        guard let image = WorldSceneBitmaps.cast else { return nil }
        let index = character.rawValue
        return image.cropping(to: CGRect(x: Double(index % 4) * Double(image.width) / 4,
            y: Double(index / 4) * Double(image.height) / 2,
            width: Double(image.width) / 4, height: Double(image.height) / 2).integral)
    }

    private func actorView(_ character: StoryCharacter, index: Int, size: CGSize) -> some View {
        let pose = LifeWorldMotion.pose(elapsedMs: motion.elapsedMs, reduceMotion: reduced, actorIndex: index)
        let protagonist = character.rawValue <= StoryCharacter.elder.rawValue
        let heroFraction = frame.actors.count > 1 ? 0.60 : 0.70
        let width = min(size.width * (protagonist ? heroFraction : 0.36), size.height * 0.76)
        let x = frame.actors.count > 1 ? size.width * (index == 0 ? 0.36 : 0.72) : size.width * 0.50
        return ZStack(alignment: .bottom) {
            Ellipse().fill(StoryPalette.sceneInk.opacity(0.19))
                .frame(width: width * 0.48, height: max(4, width * 0.065))
            let stagePose = neutralPose
            let agePortrait = protagonist && frame.stage != .childhood && frame.stage != .laterLife
                ? WorldSceneBitmaps.cell(stagePose.atlas, index: stagePose.cell, columns: stagePose.columns, rows: stagePose.rows) : nil
            if let portrait = agePortrait ?? croppedPortrait(character) {
                Image(decorative: portrait, scale: 1).resizable().scaledToFit()
                    .frame(width: width, height: width)
                    .rotationEffect(.degrees(pose.leanDegrees), anchor: .bottom)
                    .offset(y: pose.vertical - 3)
            }
        }
        .frame(width: width, height: width, alignment: .bottom)
        .position(x: x, y: size.height * 0.89 - width / 2)
    }

    @ViewBuilder private func stageFurniture(size: CGSize) -> some View {
        if frame.sceneID == "workshop" && Self.activityEvidence(in: frame) == nil {
            // A shared fictional work surface; its existence is not a household equipment claim.
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.63, green: 0.43, blue: 0.29)).frame(height: 10)
                HStack { Rectangle().frame(width: 6); Spacer(); Rectangle().frame(width: 6) }
                    .foregroundStyle(Color(red: 0.50, green: 0.34, blue: 0.23))
                    .padding(.horizontal, 14).frame(height: size.height * 0.13)
            }
            .frame(width: size.width * 0.30)
            .position(x: size.width * 0.82, y: size.height * 0.77)
        } else if frame.sceneID == "community" {
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 2).frame(height: 7)
                RoundedRectangle(cornerRadius: 2).frame(height: 6)
                HStack { Rectangle().frame(width: 5); Spacer(); Rectangle().frame(width: 5) }
                    .padding(.horizontal, 9).frame(height: size.height * 0.07)
            }
            .foregroundStyle(Color(red: 0.55, green: 0.37, blue: 0.25))
            .frame(width: size.width * 0.22)
            .position(x: size.width * 0.15, y: size.height * 0.70)
        }
    }

    private func riverRipples(size: CGSize) -> some View {
        let pose = LifeWorldMotion.pose(elapsedMs: motion.elapsedMs, reduceMotion: reduced)
        return ZStack {
            ForEach(0..<3) { index in
                Capsule().fill(.white.opacity(0.48))
                    .frame(width: CGFloat(14 + index * 6), height: 1.5)
                    .offset(x: pose.rippleHorizontal * (index.isMultiple(of: 2) ? 1 : -1))
                    .position(x: size.width * (0.83 + Double(index % 2) * 0.06),
                              y: size.height * (0.42 + Double(index) * 0.065))
            }
        }
    }

    private var visibleTokens: [WorldChangeProjection] {
        // A pending token is a note about an unresolved clue, never an achieved outcome.
        frame.worldChanges.enumerated().filter { $0.element.isOccurred || $0.element.kind == .pendingClue }
            .sorted {
                let first = tokenPriority($0.element), second = tokenPriority($1.element)
                return first == second ? $0.offset < $1.offset : first < second
            }.map(\.element)
    }

    private func tokenPriority(_ change: WorldChangeProjection) -> Int {
        let current = change.sourceEventID == frame.eventID && change.sourceAge == frame.age
        switch change.kind {
        case .memory: return current ? 0 : 3
        case .relationship: return current ? 1 : 4
        case .occurredChance: return 2
        case .delayedConsequence: return 4
        case .livedFocus: return 2
        case .pendingClue: return 5
        case .resourceChange: return 6
        }
    }

    private func tokenShelf(size: CGSize) -> some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(Array(visibleTokens.prefix(4).enumerated()), id: \.offset) { _, change in
                token(change, size: size)
            }
        }
        .padding(.horizontal, 6).padding(.vertical, 4)
        .background(Color(red: 0.99, green: 0.95, blue: 0.82), in: RoundedRectangle(cornerRadius: 3))
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(.brown.opacity(0.35), lineWidth: 0.7))
        .rotationEffect(.degrees(-2))
        .position(x: size.width * 0.19, y: size.height * 0.92)
    }

    private func token(_ change: WorldChangeProjection, size: CGSize) -> some View {
        let currentOutcome = frame.moment == .committedOutcome && motion.phase == .committedOutcome
            && change.isOccurred && change.sourceEventID == frame.eventID && change.sourceAge == frame.age
        let progress = currentOutcome ? LifeWorldMotion.arrival(phaseElapsedMs: motion.phaseElapsedMs, reduceMotion: reduced) : 1
        return Image(systemName: Self.tokenSymbol(change))
            .font(.system(size: min(16, size.height * 0.07), weight: .medium))
            .foregroundStyle(StoryPalette.sceneInk)
            .frame(width: min(22, size.width * 0.065), height: min(24, size.height * 0.09))
            .scaleEffect(0.94 + progress * 0.06)
            .offset(y: (1 - progress) * 4)
            // The fact has already committed: even an immediate pause at frame zero must leave
            // a readable token. Motion only emphasizes its arrival; it never gates the evidence.
            .opacity(LifeWorldMotion.committedTokenOpacity(arrival: progress))
    }

    static func tokenSymbol(_ change: WorldChangeProjection) -> String {
        if !change.isOccurred { return "clock.badge.questionmark" }
        switch change.kind {
        case .relationship: return "bubble.left.and.bubble.right"
        case .pendingClue: return "clock.badge.questionmark"
        case .occurredChance: return "sparkle"
        case .resourceChange: return "list.bullet.rectangle"
        case .delayedConsequence: return "arrow.turn.down.right"
        case .livedFocus: return "calendar"
        case .memory:
            // These are selected activity tokens. Neither a laptop nor notebook asserts completion,
            // access ownership, a reward or a future invitation. Unknown memories stay neutral.
            if change.sourceEventID == "teen-project" {
                switch change.sourceChoiceID {
                case "invest": return "laptopcomputer"
                case "offline": return "book.closed"
                case "ask": return "questionmark.bubble"
                case "rest": return "leaf"
                default: break
                }
            }
            return "note.text"
        }
    }

    private func portrait(for personID: String) -> StoryCharacter? {
        switch personID {
        case "mumu": .protagonist(age: frame.age)
        case "ahe", "阿禾": .ahe
        case "teacher", "樹老師": .teacher
        case "cheng", "小澄": .xiaocheng
        default: nil // Do not invent a new person when no reviewed portrait exists.
        }
    }

    private var spokenScene: String {
        if let cast = WorldCastScene.project(frame) {
            return "\(frame.age)歲，\(cast.description)\(frame.relationshipMemory?.description ?? "")跨國共用的虛構舞台，不是當地實景。"
        }
        let people = frame.actors.map { WorldMomentProjector.personName($0.personID) }.joined(separator: "、")
        let activity = WorldActivity.project(frame)
        let background = activity?.background ?? WorldActivity.neutralSetting(frame)?.background
        let place = background == "VL2Garden" ? "想像庭院" : background != nil || frame.sceneID == "workshop" ? "想像工作室" : "想像河畔"
        let presence: String
        if let activity {
            let shown = activity.companionID != nil && ![.onlinePractice, .paperPractice, .trialWork].contains(activity.kind)
            if shown && activity.kind == .remoteCollaboration { presence = "沐沐在\(place)，同伴透過螢幕參與" }
            else if shown, let person = activity.companionID { presence = "沐沐與\(WorldMomentProjector.personName(person))在\(place)" }
            else { presence = "沐沐在\(place)" }
        } else if WorldActivity.neutralSetting(frame) != nil { presence = "沐沐在\(place)等待下一個選擇" }
        else { presence = "\(people)在\(place)" }
        return "\(frame.age)歲，\(presence)。\(activity?.description ?? "")跨國共用的虛構舞台，不是當地實景。"
    }

    private var spokenChanges: String {
        let captions = frame.worldChanges.map(\.caption).joined(separator: "。")
        let activity = Self.activityEvidence(in: frame).map { "。場景物件：\($0.source.sourceAge)歲的\($0.prop.title)。" } ?? ""
        return (captions.isEmpty ? "目前沒有新的後果紀錄。" : captions) + activity
    }
}

/// Cache unchanged whole-atlas bitmaps; crop texels before layout so accessibility
/// never receives the bounds of a 4×2 atlas or overflowing scaled-to-fill image.
@MainActor private enum WorldSceneBitmaps {
    static let background = load("RiverCrossroads")
    static let cast = load("StoryCast")
    private static var atlasCache: [String: CGImage] = [:]
    private static var cellCache: [String: CGImage] = [:]
    private static func atlas(_ name: String) -> CGImage? {
        if let image = atlasCache[name] { return image }
        let image = load(name); atlasCache[name] = image; return image
    }
    /// Alpha unions measured from the source and edited index-2 cells, retained
    /// in assets/final-polish-loop/alpha-audit.json. Never trim endpoints separately.
    static func requestPose(age: Int, listening: Bool) -> CGImage? {
        guard age == 13 || age == 32 else { return nil }
        let name = age == 13 ? (listening ? "FPListening13" : "VL2Teen13")
                             : (listening ? "FPListening32" : "MCMumu")
        let key = "request-\(name)"
        if let cached = cellCache[key] { return cached }
        let rect = age == 13 ? CGRect(x: 114, y: 686, width: 434, height: 501)
                             : CGRect(x: 83, y: 656, width: 505, height: 561)
        guard let image = atlas(name), let crop = image.cropping(to: rect) else { return nil }
        cellCache[key] = crop
        return crop
    }
    static func scene(_ name: String, size: CGSize) -> CGImage? {
        guard let image = atlas(name), size.width > 0, size.height > 0 else { return nil }
        let width = CGFloat(image.width), height = CGFloat(image.height)
        let cropHeight = min(height, width * size.height / size.width)
        let cropWidth = min(width, height * size.width / size.height)
        return image.cropping(to: CGRect(x: (width - cropWidth) / 2, y: (height - cropHeight) * 0.18,
                                        width: cropWidth, height: cropHeight).integral)
    }
    static func cell(_ name: String, index: Int, columns: Int, rows: Int) -> CGImage? {
        let key = "\(name)-\(index)"
        if let image = cellCache[key] { return image }
        guard let image = atlas(name), index >= 0, index < columns * rows else { return nil }
        let cuts: [Int]? = name == "MCCatCandidate" ? [0,399,766,1201,1653,2011] : name == "MCDogCandidate" ? [0,406,797,1185,1609,1983] : nil
        let column = index % columns
        let x = cuts.map { $0[column] } ?? column * (image.width / columns)
        let width = cuts.map { $0[column + 1] - $0[column] } ?? image.width / columns
        // Reviewed transparent gutters in the original atlases are not necessarily at 50%.
        // These pixel boundaries are checked against the asset provenance manifest.
        let split = ["MCAhe": 484, "MCTeacher": 642, "MCCheng": 493, "MCMumu": 627][name]
        let row = index / columns
        let y = split.map { row == 0 ? 0 : $0 } ?? row * (image.height / rows)
        let height = split.map { row == 0 ? $0 : image.height - $0 } ?? image.height / rows
        guard let cropped = image.cropping(to: CGRect(x: x, y: y,
                                                       width: width, height: height)) else { return nil }
        // Trim only transparent atlas padding at render time; original generated PNG stays intact.
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        let bounds: CGRect? = pixels.withUnsafeMutableBytes { bytes in
            guard let context = CGContext(data: bytes.baseAddress, width: width, height: height,
                bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue) else { return nil }
            context.draw(cropped, in: CGRect(x: 0, y: 0, width: width, height: height))
            var x0 = width, y0 = height, x1 = 0, y1 = 0
            for y in 0..<height { for x in 0..<width where bytes[(y * width + x) * 4 + 3] > 12 {
                x0 = min(x0, x); x1 = max(x1, x); y0 = min(y0, y); y1 = max(y1, y)
            } }
            guard x1 >= x0, y1 >= y0 else { return nil }
            return CGRect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1)
        }
        let result = bounds.flatMap { cropped.cropping(to: $0) } ?? cropped
        cellCache[key] = result; return result
    }
    private static func load(_ name: String) -> CGImage? {
        #if canImport(UIKit)
        UIImage(named: name)?.cgImage
        #else
        NSImage(named: name)?.cgImage(forProposedRect: nil, context: nil, hints: nil)
        #endif
    }
}

#if DEBUG
/// Candidate library only. This view is never selected by LifeWorldScene or the story engine.
private struct CandidateCastPreview: View {
    private let stages = ["童年", "青少年", "青年", "中年", "晚年"]
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("貓咪／狗狗候選・尚未核准").font(.headline)
                Text("未加入正式人生，沒有故事姓名或出場事件。")
                ForEach(0..<5) { age in
                    VStack {
                        Text(stages[age])
                        HStack {
                            ForEach(["MCCatCandidate", "MCDogCandidate"], id: \.self) { name in
                                if let cell = WorldSceneBitmaps.cell(name, index: age, columns: 5, rows: 1) {
                                    Image(decorative: cell, scale: 1).resizable().scaledToFit().frame(width: 130, height: 190)
                                }
                            }
                        }
                    }
                }
            }.padding()
        }.background(StoryPalette.page)
    }
}
#Preview("未核准候選・五階段貓狗") { CandidateCastPreview() }
#endif
