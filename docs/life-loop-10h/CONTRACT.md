# LIFE-LOOP 10H — Gameplay／Visual 共同契約（CONTRACT）

> 這是 LL-01 一開始必須凍結的 DTO 與狀態轉移契約。初版規格，不表示型別已存在。可在 LL-01 依真實 Swift API 微調，但需先在同一提交更新本文件，兩 Agent 再使用同版契約。

## A. 嚴格分離三種狀態

| 層級 | 權威來源 | 允許行為 | 明確禁止 |
| --- | --- | --- | --- |
| 人生／運算 | `LifeDomain.LifeSession`、`EventSelector`、`DecisionResolver` | `start`、`choose`、`continueLife`、`beforeDecision`、`compare` | Visual 自行抽事件、修改資源、補國家機率 |
| 儲存／發佈 | `LifePersistence.SaveRepository`、`GameStore.commit` | 先儲存完整 LifeJourney，成功後 `@Published` 更新 | 演出 speculative preview 當作已發生的後果 |
| 顯示／播放 | `LifePresentation.LifeWorldFrame` + App `WorldPlaybackController` | 投影已知 trace、場景、演出速度與可及性 | UI timer 寫入人生歲數、`LifeState`、亂數或新故事事實 |

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
    // UI tick only; never mutate LifeState, Seed or draw random.
    // advanceOnce() checks current authoritative LifeSession phase
    // and event/decision index before calling GameStore.next().
}
```

**請把實際傳遞設計成依賴注入或可測試動作 closure，不要讓 Presentation target import SwiftUI 或 GameStore。** UI controller 只可呼叫 GameStore 的合法命令；任何 save fail 不得改變 UI 中的 authoritative session。

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
    let reduceMotion: Bool
    // Render-only: no random, no timer-driven state mutations.
}
```

- 至少可辨識：童年、13歲工作室、成年人三種場景／人物年齡呈現；沒對應正式圖時使用明確共用虛構場景。
- 同一場景切換 `living / eventPaused / committedOutcome`；事件浮層、真正可行選擇由正式 App Owner 接。
- 事件後至少兩種不同的 trace-backed 世界變化（如故事記憶留下道具、人物互動記號），不能改寫選擇歷史。
- 大型畫面不犧牲選項可達；長篇說明仍可展開，最大文字只隱藏裝飾。
- 動畫穩定且易跳過，低動態/VoiceOver 不因畫面隱藏而遺漏文意。

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
| Finish | 八國現有完整人生＋至少一條分岔 | 15項決策到80歲回顧，無卡死 |

## F. 邊界與交接

- 程式基底凍結 PR #8 `c136beb`；PR #6、#7、#8 尚未合併 main，不以本片合併取代其資料/素材審查。
- Agent A 唯一擁有 `CrossroadsView.swift` 與任何必要 `GameStore.swift` 變更；Agent B **不得編輯**這兩者，也不能修改 `Domain/`、`Data/`、`Persistence/`、`EventSelector`。
- 兩 Agent 的所有畫面與變更需標明作者與 Commit，整合由 A 在單獨 Integration PR/branch 進行；避免把 WIP 原型全枝合併。
- 若出現跨版本存檔、資料來源/授權或安全問題，列 BLOCKED，保留原檔並可回退到 PR #8 舊 UI；不能用臨時造假資料通過測試。
- 不需要重寫 `docs/p1-slices.md`；本契約是一次獨立、可驗收的體驗實驗，不宣稱 LC-03/05/06/07 已完成。
