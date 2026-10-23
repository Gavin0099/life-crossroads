import Foundation
import LifeDomain

/// Original, bounded scheduling fixtures. All numbers are game design assumptions, not measured rates.
/// The existing catalog remains unchanged; callers explicitly opt into this experimental event pool.
public enum DirectedDemo {
    public static let contentVersion = "rng-demo-1"
    public static let newEventIDs = ["rng-child-tool-library", "rng-community-practice", "rng-mutual-support", "rng-legacy-workshop"]

    public static func catalog(base: ModelCatalog) throws -> EventCatalog {
        try base.validate()
        var model = base
        // Metadata is explicitly decoded because legacy value types expose Codable, not public initializers.
        let definition = """
        {"id":"rng-scheduling-demo","version":"1","statement":"15個人生決策槽；既有事件權重2，原創候選權重3。借物站8～12歲，練習25～59歲最多3次且間隔10年，互助39～59歲，傳承65～80歲。互助與練習為互斥敘事路線。借物聯繫與技能28開啟主持選項；人口比例只作明示環境條件。","limitation":"原創遊戲排程與故事門檻，不是真實機率、國家排名、教育或醫學預測。15槽及80歲為敘事節奏，不是死亡模型。"}
        """
        let assumption = try JSONDecoder().decode(DesignAssumption.self, from: Data(definition.utf8))
        model.assumptions.append(assumption)
        let originals = try originalEvents(catalog: model)
        var events = model.decisions.map {
            DirectedEvent(decision: $0, minimumAge: $0.age, maximumAge: $0.age, weight: 2,
                          assumptionID: assumption.id)
        }
        events.append(.init(decision: originals[0], minimumAge: 8, maximumAge: 12, weight: 3,
                            conditions: [.household(field: .mentorSupport, minimum: 1, maximum: 2)],
                            relationshipEffects: [
                                .init(choiceID: "join", personID: "tool-library", factID: "connection"),
                                .init(choiceID: "ask", personID: "tool-library", factID: "connection")
                            ], assumptionID: assumption.id))
        events.append(.init(decision: originals[1], minimumAge: 25, maximumAge: 59, weight: 3,
                            conditions: [.resource(field: .health, minimum: 20, maximum: 100)],
                            policy: .init(maxOccurrences: 3, cooldownYears: 10, exclusiveGroup: "community-role"),
                            assumptionID: assumption.id))
        events.append(.init(decision: originals[2], minimumAge: 39, maximumAge: 59, weight: 3,
                            conditions: [.household(field: .careLoad, minimum: 1, maximum: 2),
                                         .historyChoice(eventID: "adult-care", choiceID: "ask")],
                            policy: .init(exclusiveGroup: "community-role"),
                            assumptionID: assumption.id))
        events.append(.init(decision: originals[3], minimumAge: 65, maximumAge: 80, weight: 3,
                            choiceConditions: [.init(choiceID: "host", conditions: [
                                .relationship(personID: "tool-library", factID: "connection", present: true),
                                .resource(field: .skills, minimum: 28, maximum: 100)
                            ])], assumptionID: assumption.id))
        return .init(version: contentVersion, model: model, events: events,
                     slots: model.decisions.map { .init(id: "life-\($0.age)", age: $0.age, fallbackEventID: $0.id) },
                     personIDs: ["tool-library"])
    }

    public static func originalEvents(catalog: ModelCatalog) throws -> [DecisionSkeleton] {
        guard let child = catalog.decisions.first(where: { $0.id == "child-interest" }),
              let adult = catalog.decisions.first(where: { $0.id == "adult-balance" }),
              let later = catalog.decisions.first(where: { $0.id == "later-pass-on" }) else {
            throw ModelError.missing("directed demo reference shapes")
        }
        guard [child, adult, later].allSatisfy({ event in
            event.choices.contains { $0.id == "ask" } && event.choices.contains { $0.id == "rest" }
        }) else { throw ModelError.missing("directed demo recovery choice shapes") }
        func choice(_ source: DecisionSkeleton, id: String, title: String, kind: ChoiceKind,
                    control: DecisionControl = .personal, effect: ResourceValues,
                    time: Int = 1, energy: Int = 1, materials: Int = 0, hook: String? = nil) -> ChoiceDefinition {
            var result = source.choices.first { $0.id == "ask" }!
            result.id = id; result.title = title; result.kind = kind; result.control = control
            result.minimumAge = control == .adultResponsibility ? 23 : 0
            result.timeCost = time; result.energyCost = energy; result.materialCost = materials
            result.effect = effect; result.requiresDigitalAccess = false; result.delayedHook = hook
            result.assumptionIDs = ["choice-effects", "support-network"]
            return result
        }
        func rest(_ source: DecisionSkeleton) -> ChoiceDefinition {
            var result = source.choices.first { $0.id == "rest" }!
            result.title = "今天先休息，之後仍能尋找新的支持"
            return result
        }
        var library = child
        library.id = newEventIDs[0]; library.age = 10
        library.title = "社區借物站的第一次邀請"; library.recurringPerson = "管理借物站的夏姨"
        library.storyQuestion = "想試新工具時，可以先和誰一起確認安全？"
        library.choices = [
            choice(child, id: "join", title: "和可信任的大人一起認識借物站", kind: .learn,
                   control: .sharedWithAdult, effect: .init(relationships: 2, skills: 2), time: 2, hook: "library-followup"),
            choice(child, id: "ask", title: "請大人陪你詢問免費借用與安全安排", kind: .askSupport,
                   effect: .init(relationships: 2, skills: 1)), rest(child)
        ]
        var practice = adult
        practice.id = newEventIDs[1]; practice.age = 32
        practice.title = "社區修繕桌又開放了"; practice.recurringPerson = "練習夥伴小岸"
        practice.storyQuestion = "這次想學一小步，還是先把需要說出來？"
        practice.choices = [
            choice(adult, id: "practice", title: "和小岸一起練習修好一件小物", kind: .learn,
                   effect: .init(skills: 3), time: 2, energy: 2, hook: "practice-followup"),
            choice(adult, id: "ask", title: "詢問免材料費的練習方式", kind: .askSupport,
                   effect: .init(relationships: 2, skills: 1)), rest(adult)
        ]
        var support = adult
        support.id = newEventIDs[2]; support.age = 45
        support.title = "夥伴提議交換一小段空檔"; support.recurringPerson = "鄰居小葵"
        support.storyQuestion = "互助安排可以保留自己的界線嗎？"
        support.choices = [
            choice(adult, id: "agree", title: "自願約好可負擔的一小段互助時間", kind: .care,
                   control: .adultResponsibility, effect: .init(health: -1, relationships: 3), time: 2),
            choice(adult, id: "ask", title: "先請小葵陪你查找支持，不急著承諾", kind: .askSupport,
                   effect: .init(relationships: 2)), rest(adult)
        ]
        var legacy = later
        legacy.id = newEventIDs[3]; legacy.age = 72
        legacy.title = "借物站想留下大家的修繕經驗"; legacy.recurringPerson = "新管理員小棠"
        legacy.storyQuestion = "曾經接受的幫助，能用自己的方式傳下去嗎？"
        legacy.choices = [
            choice(later, id: "host", title: "和小棠一起帶領熟悉的借物小活動", kind: .share,
                   effect: .init(relationships: 3, skills: 1), time: 2, energy: 2),
            choice(later, id: "ask", title: "請小棠幫忙記下一件值得分享的小事", kind: .askSupport,
                   effect: .init(relationships: 2, skills: 1)), rest(later)
        ]
        return [library, practice, support, legacy]
    }
}
