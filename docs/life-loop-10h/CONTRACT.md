# LIFE-LOOP 10H v1.1 — Gameplay／Visual／Motion 單一共同契約（CONTRACT）

> 這是 LL-01 一開始必須凍結的 DTO、狀態轉移與動畫時鐘契約。**LL-01實作契約：型別見 LifeCrossroads/Presentation/LifeWorldFrame.swift。** 可在 LL-01 依真實 Swift API 微調，但需先在同一提交更新本文件，兩 Agent 再使用同版契約。動畫方法來源為 [rossark-motion-skill@9b20964](https://github.com/rossark0/rossark-motion-skill/tree/9b20964e32f07f8ac7e2948cd175746fa4a7712f)（MIT）；本案實際採用與授權清單見 [MOTION.md](MOTION.md)。

## A. 嚴格分離三種狀態

| 層級 | 權威來源 | 允許行為 | 明確禁止 |
| --- | --- | --- | --- |
| 人生／運算 | `LifeDomain.LifeSession`、`EventSelector`、`DecisionResolver` | `start`、`choose`、`continueLife`、`beforeDecision`、`compare` | Visual 自行抽事件、修改資源、補國家機率 |
| 儲存／發佈 | `LifePersistence.SaveRepository`、`GameStore.commit` | 先儲存完整 LifeJourney，成功後 `@Published` 更新 | 演出 speculative preview 當作已發生的後果 |
| 顯示／播放 | `LifePresentation.LifeWorldFrame` + App `WorldPlaybackController` | 投影已知 trace、場景、演出速度與可及性，向場景輸出連續演出時間 | UI timer 寫入人生歲數、`LifeState`、亂數或新故事事實 |
| 圖形與動作 | `LifeWorldScene`／可審計的 SwiftUI motion helpers | 消費 DTO／可暫停時間值，只畫角色／背景／已提交後果 | 自己呼叫 `GameStore.next`、亂數抽遊戲事件、修改存檔、硬做無分層 PNG 的骨架動畫 |

**關鍵：`Living` 是演出階段，不是新的儲存引擎回合。** 不加入 365 天／12 個月的虛擬模擬時鐘。

## B. 建議的純 Swift 投影介面（Agent A Owner）

類型名稱可依既有命名稍微調整，但欄位語意不得變成測試 fixture 硬編。

```swift
// LifePresentation, depends only on LifeDomain.
public enum LifeWorldMomentKind: String, Sendable {
    case living, eventPaused, committedOutcome, ending
}

public struct WorldActorProjection: Equatable, Sendable {
    public let personID: String             // 已知人物 ID，原創角色映射
    public let role: String                 // protagonist / inviter / interacted
    public let evidenceEventID: String?     // 不是「被幫助」的推定
}

public struct WorldChangeProjection: Equatable, Sendable {
    public enum Kind: String, Sendable {
        case resourceChange, relationship, memory, occurredChance, pendingClue
    }
    public let kind: Kind
    public let caption: String
    public let sourceEventID: String
    public let sourceChoiceID: String
    public let sourceAge: Int
    public let isOccurred: Bool  // false 的線索只能標「已留下、未實現」
}

public struct LifeWorldFrame: Equatable, Sendable {
    public let stage: LifeStage
    public let age: Int                     // 真正權威的目前人生歲數
    public let visualFromAge: Int?          // 僅蒙太奇顯示，不是逐年運算
    public let sceneID: String             // fiction: river / workshop / community 等
    public let actors: [WorldActorProjection]
    public let worldChanges: [WorldChangeProjection]
    public let moment: LifeWorldMomentKind
    public let eventID: String?            // 只來自當前 event/trace
}

// 真實方法需以現在 LifeSession API 為準；沒有副作用。
public enum WorldMomentProjector {
    public static func project(
        session: LifeSession,
        catalog: ModelCatalog
    ) throws -> LifeWorldFrame
}
```

### 取證規則

- `eventPaused`：從真正入選的 `session.event(catalog:)`／`EventSelectionTrace` 得到事件、人名、可選行動；可以描繪事件邀請者在場，**但不能推定其已幫忙**。
- `committedOutcome`：只能使用 `session.phase == .reflecting`、`traces.last?.applied == true` 的提交後資料；`ProjectMoment` 如符合13歲條件可沿用。
- 立即影響：`ConsequenceTrace.resourcesAfter - resourcesBefore`、`effectSteps` 與 `changedRelationships`；上限抵銷、淨零不得畫成增益。
- 已發生的運氣：`randomTrial.occurred == true` 且實際效果非零；未發生不顯示成功。
- 早先呼應已觸發：`TimeJumpTrace.triggeredHooks`，使用實際 `dueAge` 和來源決策。
- 尚未發生：`scheduledHooks`、`pendingHooks`；僅當成「留下線索」，不描繪已兌現的後果。
- 故事記憶：`StoryMemory.fact`／`recordedStoryFacts` 可顯示來源年齡／選擇；不可由單純人名或畫面插圖偽造。
- 臺灣數位／醫療不同口徑的缺口：沿用 `environmentGaps`；不能以畫面設備存在推定家庭實際擁有。
- 角色物種與美術人物不對應國籍；同一虛構場景可以跨國共用，必須向使用者說明不是實景。

## C. 建議 App UI 播放控制器（Agent A Owner）

```swift
@MainActor
enum WorldPlaybackPhase {
    case living
    case eventPaused
    case committedOutcome
    case ended
}

@MainActor
final class WorldPlaybackController: ObservableObject {
    @Published private(set) var phase: WorldPlaybackPhase
    @Published private(set) var speed: PlaybackSpeed // paused / normal / fast
    // Authoritative animation-only accumulated time, monotonic across pause/speed change.
    @Published private(set) var presentationElapsedMs: Double
    // UI tick only; never mutate LifeState, Seed or draw random.
    // advanceOnce() checks current authoritative LifeSession phase
    // and event/decision index before calling GameStore.next().
}
```

**請把實際傳遞設計成依賴注入或可測試動作 closure，不要讓 Presentation target import SwiftUI 或 GameStore。** UI controller 只可呼叫 GameStore 的合法命令；任何 save fail 不得改變 UI 中的 authoritative session。

**動畫鐘必須獨立於人生鐘。** 當視圖被遮擋、切到背景、使用者暫停或 Reduce Motion 時，應停止不必要的每幀刷新。播放速度變更時，先以舊速度結算截至切換點的累積演出時間，再以新速度增量；不得用 `Date()` 的絕對經過時間重算整個演出並瞬間跳姿勢。即時生命遊戲時間仍由 `LifeSession` / `SimulationEngine` 控制，且只能在合法選擇和保存邊界改變。

### 動畫播放相位契約（Gameplay A 的時間，Visual B 的畫面）

**輸入範本（命名可調，語意不得變）**

```swift
// App 層，與生命 Domain 的 Seed / RNG 完全分離。
struct PresentationMotionFrame: Equatable, Sendable {
    let elapsedMs: Double     // 演出累積有效毫秒數
    let frozen: Bool          // pause / hidden / background / event decision
    let reduceMotion: Bool    // 靜態就能讀完整內容
    let phase: WorldPlaybackPhase
    let phaseToken: String    // 同一次結果只播一次，重入不得重播決策
}
```

- **連續性：** 正常播時 `elapsedMs += wallDeltaMs × presentationSpeed`。暫停時保持固定 elapsed，恢復從固定值繼續；速度改變須先依先前速度結算 elapsed，再重設壁鐘參考點；背景恢復不得補算隱藏期間的時間。
- **首尾：** 例如 4 秒 loop 在 `0/1000/2000/4000ms` 觀察一致的邊界姿勢。單次 outcome 只在正式結果已保存後啟動，完成後固定末幀；不得因反覆 appear 又從零套用遊戲行動。
- **場景效率：** 每個場景**一個**可停更時間源，子物件用純函數 `wave/flow/track` 計算視覺變換。裝飾性 phase 允許固定 index 的 `seeded(i)`，但不得每 frame `random()` 或呼叫 Domain 的 `KeyedRandom`。
- **Skill 語意陷阱：** 上游 `templates/swiftui/Motion.swift` 的 `LoopClock` 在 `paused || reduceMotion` 時直接輸出 `t=0`，恢復後則用 `Date().timeIntervalSince(start)`；若直接拿它作使用者可暫停/調速的場景時鐘，會在暫停和恢復時跳姿勢。本專案必須**包裝或重寫相位累積器**，且針對 pause/resume/1×→3×/背景切換測試。不能以套用 `LoopClock` 宣稱這些 Gate 已過。
- **圖層限制：** `StoryPortrait` 使用單張 `StoryCast` atlas 角色裁切，無單獨眼睛/手臂/頭/尾巴的 rig。本輪只能做整體細微變換與分離可用的場景道具。禁止在未拆圖情況下用 `LiveFace` 模擬已具有獨立眼睛圖層；完整表情骨架是後續工作。
- **減少動態效果：** 呼吸／環境迴圈靜止於資訊完整的 frame0；已發生 outcome 的 one-shot 呈現完成時的末幀。事件還未做選擇時，不能顯示 outcome 末幀；活動與結果原因仍用文字保留。
- **授權：** 若複製 `rossark-motion-skill` 的代碼，保留 MIT LICENSE 的版權與許可、Commit、原始檔、修改清單及第三方 notice；若僅參考原理自行寫，紀錄「無直接代碼引入」。官方 Demo 人物／影片及其他來源 PNG 不因 Skill MIT 而自動核准。

### 狀態對照

| 當下保存狀態 | 畫面階段 | 可做什麼 |
| --- | --- | --- |
| 新人生 `choosing`，第一個事件前 | `living` 的短開場（可略過）後 `eventPaused` | 既有事件與選項等候玩家 |
| 已選完 `reflecting` | `committedOutcome` | 顯示已保存後果；若開詳細說明，停止自動續行 |
| `reflecting` 後動畫結束或跳過 | 經合法 `GameStore.next()` 儲存後 `living` | 蒙太奇播放到新年齡，然後 `eventPaused` |
| `ended` | `ended` | 既有回顧、完整分岔與比較 |
| 暫停／背景／VoiceOver 輔助讀取 | 保持當下畫面 | 不自動提交 `choose` 或多呼叫 `next()` |
| 冷啟動重讀 `choosing` | 直接 `eventPaused`，或可明確略過的開場 | 不把同一時間跳躍重新執行 |
| 冷啟動重讀 `reflecting` | `committedOutcome` | 重新展示已存後果，不能自行重做決策 |
| 查看保留的原人生 `viewingOriginal=true` | 只讀原人生 | 不顯示繼續選擇，不呼叫 `next()` |

**事件卡在 `eventPaused` 時，播放速度與播放 tick 都不能自動越過選擇。** 「繼續生活」可以為無動畫或輔助模式的可操作快捷鍵；普通流程不再強制按「走向下一段」。

### Exactly-once guard

由 Agent A 定義進度 identity，最低限度是 `(countryCode, householdID, seed, traces.count, phase)` 的當前 Session 驗證，加上 in-flight guard／cancel generation token。僅當保存狀態仍為預期 `reflecting` 且事件序號相同時，才允許一次 `continueLife`；畫面 `onAppear`、重覆 skip、sheet dismiss 和速度切換不得重複執行。

如未能成功保存下一段：維持原 `reflecting` 及原 JSON bytes、顯示錯誤與重試入口；不得顯示下一次事件的已發生狀態。

## D. Agent B 的輸入／輸出（不能改引擎）

Visual 只新增 App 下的可重用 `LifeWorldScene` 及視覺輔助檔案，**由 Agent A 的 adapter 注入只讀 `LifeWorldFrame`**。如果 Agent B 從共同 contract branch 開工時實際 DTO 尚未編譯完成，先以獨立 `LifeWorldScenePreviewModel` fixture 做 SwiftUI Preview，並在整合時只保留單向 adapter；不得複製 Domain 邏輯來讓 Preview 變綠。

```swift
struct LifeWorldScene: View {
    let frame: LifeWorldFrame        // 或由 gameplay 實作的薄 adapter 包裝
    let motion: PresentationMotionFrame
    // Render-only: no random, no timer-driven LifeSession mutation.
}
```

- 至少可辨識：童年、13歲工作室、成年人三種場景／人物年齡呈現；沒對應正式圖時使用明確共用虛構場景。
- 同一場景切換 `living / eventPaused / committedOutcome`；事件浮層、真正可行選擇由正式 App Owner 接。
- 事件後至少兩種不同的 trace-backed 世界變化（如故事記憶留下道具、人物互動記號），不能改寫選擇歷史。
- 大型畫面不犧牲選項可達；長篇說明仍可展開，最大文字只隱藏裝飾。
- 動畫穩定且易跳過，低動態/VoiceOver 不因畫面隱藏而遺漏文意。
- Visual 動畫必須只消費 A 已累積的 motion elapsed；不要自行用 `Date()` 與 `LoopClock` 更新情節、不要每層獨立 `TimelineView`；事件選擇期間背景運動凍結或只保留不影響決策的輕微動作。
- 場景基本動作優先使用原有動物角色微幅移動（1–2pt）、柔和轉頭感/傾斜及 1–2 種環境元素。外部範例的高幅度跳躍、四肢骨架、重製臉部，只有分層正式素材到位才另立 Slice。

## E. 逐案驗收的矩陣

| Case | 操作 | 驗證 |
| --- | --- | --- |
| Playback equivalence | 相同國家/家庭/Seed及15選擇，normal、fast、skip | `LifeSession`、trace、存檔結果一致 |
| Pause at event | 生活播完、事件浮層出現後不選 | 無自動選擇、沒有新的 `DecisionRecord` |
| Double-trigger | 畫面重入、快速點兩次 skip、前背景切換 | 同一 `reflecting` 最多一次 `continueLife`，不漏也不重 |
| Save failure | 在 `choose` 與 `continueLife` 注入失敗後重試 | JSON與畫面保持原狀，沒有虛假場景反應 |
| Rerun／fork | 完整人生後在13歲改選，同 Seed重播兩人生 | 原局不變、分岔差異可讀、演出不混線 |
| Age/stage | 8、13、25/39、65/80 的正式事件 | 人物五階段、不產生假年齡或已發生後果 |
| Cause boundaries | 13歲 invest/offline/ask/rest，台灣資料缺口、未觸發 luck | 人物／成本／支持／未來線索各讀真實 trace |
| Accessibility | iPhone SE、超大字級、Reduce Motion、VoiceOver基本標籤 | 首屏可操作；不把互動或原因只放在動畫/顏色 |
| Motion continuity | 在 3× 時暫停、恢復、改1×、隱藏 sheet 再開 | 姿勢連續、elapsed 不重設、不補算背景時間；無額外 `next()` |
| Clock isolation | 生活動作 frame 序列與同 Seed 的完整人生重播 | 動畫 phase/draw 不影響 `LifeSession` 或存檔；禁每 frame game random |
| Loop/reduced motion | 檢查循環時間0%/25%/50%/100%，Reduced Motion 及 one-shot 末幀 | 接縫不跳、靜態不漏事實、只有保存後才顯示已發生後果 |
| Motion provenance | 有/無複製上游 SwiftUI helpers 兩種情境 | 有複製則附 MIT notice＋SHA；沒複製則明列未安裝／只借鏡方法 |
| Finish | 八國現有完整人生＋至少一條分岔 | 15項決策到80歲回顧，無卡死 |

## F. 邊界與交接

- 程式基底凍結 PR #8 `c136beb`；PR #6、#7、#8 尚未合併 main，不以本片合併取代其資料/素材審查。
- Agent A 唯一擁有 `CrossroadsView.swift` 與任何必要 `GameStore.swift` 變更；Agent B **不得編輯**這兩者，也不能修改 `Domain/`、`Data/`、`Persistence/`、`EventSelector`。
- 兩 Agent 的所有畫面與變更需標明作者與 Commit，整合由 A 在單獨 Integration PR/branch 進行；避免把 WIP 原型全枝合併。
- 若出現跨版本存檔、資料來源/授權或安全問題，列 BLOCKED，保留原檔並可回退到 PR #8 舊 UI；不能用臨時造假資料通過測試。
- 不需要重寫 `docs/p1-slices.md`；本契約是一次獨立、可驗收的體驗實驗，不宣稱 LC-03/05/06/07 已完成。
- 動畫方法的審查和接入限於 Visual 既有 2h 工作預算，不能額外新增專門 Skill Agent；初次 PoC 若被圖層限制阻擋，保留正式人生／靜態世界可玩，後續骨架需求另列 backlog。

## LL-01 凍結補充

實作保留上述欄位，增加 `LifeWorldFrame.environmentGaps` 與 `WorldChangeProjection.Kind.delayedConsequence`，以區分未知成本與已觸發呼應。`PresentationMotionFrame`位於純Swift Presentation，`phase`使用`LifeWorldMomentKind`、增加`phaseElapsedMs`供one-shot末幀。Visual唯一介面為`LifeWorldScene(frame: LifeWorldFrame, motion: PresentationMotionFrame)`。`WorldMomentProjector.personName`只映射既有虛構人物；frame.age永遠是權威年齡，living用`frame.presenting(.living)`。App只在正式保存後投影reflecting；DTO本身不聲稱preview已保存。

## 正式播放接線（LL-02～05）

實際實作以 `GameStore.playback: WorldPlayback` 包裝上述建議的 `WorldPlaybackController` 責任，沒有新增第二個 ObservableObject 或 SessionPhase。純Swift `WorldPlayback` 接受單調 `now`，App唯一時間來源為 `ProcessInfo.systemUptime`；可見timed phase由一個可取消task更新，場景/子物件不另建clock。Living 3000ms、committedOutcome 2000ms；1×/3×只縮放有效演出時間。

- `WorldSessionIdentity`取國家、家庭、Seed、trace數、SessionPhase；`WorldAdvanceTicket`另帶持續增加的generation。失敗、同Seed重開和bind均使舊ticket失效；`awaitingCommit`阻止重複tick/skip。
- `GameStore`驗證ticket仍對應當前reflecting且非原局後，才呼叫原有continueLife並save；成功才bind新session，失敗保持原JSON/結果且paused，可手動重試。
- 新/冷恢復的paused結果直接提供one-shot末幀；正常中途pause保留既有phase elapsed。全域elapsed不因普通phase切換歸零。
- `suspended`為sheet/背景/首頁/原局等遮蓋；`offscreen`來自ScrollView具名座標與viewport交集。兩者皆停止tick；單純捲出場景仍可在底欄手動繼續，不形成閱讀後死鎖。背景時間不補算。
- 首頁「生活世界預覽」可切回同一journey的legacy Event-first；命令列`-legacy-event-first`供回歸。同一組App儲存/決策仍唯一。
- 系統Reduce Motion或首頁「減少動態效果」任一啟用即用同一靜態分支；後者是AppStorage偏好，不寫入人生JSON。Simulator `-ui-testing -reset-save`同時重設此測試偏好，普通重開保留設定。測試App內設定不代表已人工操作iOS設定或VoiceOver焦點。
- 自動續行後，下一事件保留「回看剛才的選擇與原因」，讀真正last trace，打開時同樣暫停；不由目前事件倒推舊原因。

可見時使用GameStore的單一累積鐘，Reduce Motion減少刷新頻率；停留event/ending、隱藏或暫停時沒有持續tick。`.transaction`禁止場景自行啟動隱式重複動畫。正式Actor/後果圖只由本次投影供給；legacy小插圖在新世界模式隱藏。

世界投影在成功保存/恢復的bind邊界更新一次；逐幀只切換只讀frame的moment。`GameStore`不在動畫刷新時讀currentEvent/preview重新抽算候選；age/人物/後果由新session重新投影，不沿用前事件快取。
