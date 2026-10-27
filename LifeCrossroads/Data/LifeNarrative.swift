import LifeDomain

/// Read-only original prose. History references always come from the actual story ledger.
public enum LifeNarrative {
    public static let version = "life-narrative-1"

    public static func text(event: DecisionSkeleton, state: LifeState) -> String {
        if event.storyVariantID?.contains("-opportunity-") == true { return event.storyQuestion }
        if event.id == "teen-project" {
            return "樹老師把線上圖解與紙本放在創作桌上。你看著還沒動起來的模型，想試試自己的點子；課後的時間卻只有這麼多。\n線上需要安排設備與連線，紙本也要準備材料。你可以選一條路開始、先說出需要，或把這段時間留給自己。桌上的邀請，不必今天就變成完成的作品。"
        }
        if event.id == "teen-direction" {
            let fact = state.story.fact("learning")
            let age = fact.map { String($0.age) } ?? ""
            switch fact?.value {
            case "paper":
                return "樹老師翻到你\(age)歲留下的紙本練習記錄。熟悉的摺痕讓你想起那次選擇；現在，面前多了一場工作坊的邀請。你想帶著經驗再試一次，也想留些時間給自己。\n你可以繼續參與、改用線上方式或先商量安排。是否能帶領別人，仍要看目前的經驗與負擔；以前選了紙本，並沒有替今天決定答案。"
            case "online":
                return "樹老師重開你\(age)歲留下的線上創作記錄。那次練習沒有替往後的日子畫好路線，卻讓今天的邀請有了來處。你看著還能修改的地方，想知道自己現在會怎麼做。\n你可以接著交流，也可以把想法拿到紙上。帶領工作坊仍有經驗與成本條件；換方法不是白費以前的努力。"
            default:
                let past: String
                if let fact, fact.choiceID == "ask" {
                    past = "你在\(age)歲時先說出需要；那次尚未留下作品經驗，也沒有保證後來一定獲得協助。"
                } else if let fact, fact.choiceID == "rest" {
                    past = "你在\(age)歲把時間留給自己。那次沒有建立作品經驗，今天仍能找到新的起點。"
                } else {
                    past = "這段人生目前沒有可接續的作品記錄。"
                }
                return "小澄和你停在學習活動的布告欄前。\(past)面前有可以借的入門圖解，你不必先證明自己早就會了。\n從一個小步驟開始、說明現在的負擔，或先保留時間，都可以。這次沒有舊作品的邀請，不代表往後都沒有機會。"
            }
        }
        return EventNarratives.texts[event.storyVariantID ?? event.id] ?? event.storyQuestion
    }
}
