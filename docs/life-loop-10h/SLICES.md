# LIFE-LOOP 10H — 可並行、可驗收的詳細開發切片（SLICES）

> 開發前讀 [PLAN.md](PLAN.md)、[CONTRACT.md](CONTRACT.md)、repo `AGENTS.md`、`PLAN.md`、`docs/project-guardrails.md`。  
> **這是待實作的 slices，不是已完成報告。** 可直接派給 Gameplay 與 Visual Agent；每個 slice 必須有真實 commit、測試與狀態證據才可標 DONE。

## 0. Agent-hours 工時帳與四輪時程

工時以 Agent-hours 計；兩 Agent 可同時工作，但各 slice 只計一次。基線固定於 PR #8 `c136bebf48ae17e24235d9da72d7f9e51b90bf0c`；不合併／不發布。

| Slice | Owner | h | R1（2h） | R2（3h） | R3（3h） | R4（2h） |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| LL-00 基線與衝突隔離 | Gameplay A | 0.50 | 0.50 | | | |
| LL-01 共通 DTO/狀態契約 | Gameplay A | 1.00 | 1.00 | | | |
| LL-02 Living 播放控制器 | Gameplay A | 1.50 | | 1.50 | | |
| LL-03 正式主流程與事件浮層 | Gameplay A | 1.50 | | 1.00 | 0.50 | |
| LL-04 後果回到生活世界 | Gameplay A | 1.00 | | | 1.00 | |
| LL-05 重入／存檔／分岔保護 | Gameplay A | 1.00 | | | 0.50 | 0.50 |
| LL-06 最終整合及回退 | Gameplay A | 0.50 | | | | 0.50 |
| VW-01 大型世界構圖 | Visual B | 0.50 | 0.50 | | | |
| VW-02 角色待機／互動／反應 | Visual B | 0.75 | | 0.50 | 0.25 | |
| VW-03 Trace 反應／無障礙 | Visual B | 0.50 | | | 0.50 | |
| VW-04 Preview 與畫面證據 | Visual B | 0.25 | | | 0.25 | |
| QA-01 獨立工程覆審 | Reviewer | 0.50 | | | | 0.50 |
| QA-02 玩法與手機畫面對照 | Reviewer | 0.50 | | | | 0.50 |
| **合計** | | **10.00** | **2.00** | **3.00** | **3.00** | **2.00** |

**沒有假設在背景自動跑10小時**；由授權的執行 Agent 現場紀錄實際時間與有界進度。任一輪未過核心 Gate，先修最關鍵問題，重新分配剩餘工時；不能擅自延長總上限或宣布完成。

## 1. R1（2h）— 舊版保留、先固定資料與大畫面

### LL-00（0.50h，Gameplay A）凍結與觀測

**輸入：** 已推送 PR #8 HEAD `c136beb`，有 PR #6→#7→#8 的堆疊 ancestry。  
**動作：**
- 確認父 PR HEAD／CI 與工作目錄；不在 `main` 或 Visual WIP 原分支直接改。
- 另開 `codex/life-loop-gameplay-10h`，從**本規劃分支最新共同文件 Commit**建起。建立 `ITERATION_LOG.md`，記最新 SHA、既有狀態圖、初始測試收據。
- 明確定位 `CrossroadsView.decision/feedback`、底部「走向下一段」、`GameStore.choose/next`、`ProjectWorkshopView`、`LifeSession` 及 `SaveRepository`。
- 凍結一段日本家庭／Seed 0 的15項 decision／trace 基準，加一段台灣家族資料缺口情境，後續不靠只看三張畫面判定規則相同。
**完成判準：** 可對照的原始快照／commit、可重跑命令、工作樹乾淨且不更動 engine；沒有把舊 UI 測試通過當成新玩法證據。  
**輸出：** `docs/life-loop-10h/ITERATION_LOG.md` R1 與 `artifacts/evidence/life-loop/baseline-*.json`（需包含引擎版本與實際選擇）。

### LL-01（1.00h，Gameplay A）凍結 LifeWorldFrame 契約

**輸入：** [CONTRACT.md](CONTRACT.md) 標示的欄位與 A/B ownership。  
**動作：**
- 在 `LifeCrossroads/Presentation/` 新增只讀 `LifeWorldFrame`／`WorldMomentProjector`，直接讀正式 Session 的 actor、stage、event、committed trace、StoryMemory、TimeJumpTrace。
- 轉換時以模型已有數值和 ID 為真，不能自行編譯新資源或國家成功倍率。
- 如果要修改欄位，先更新 CONTRACT，將最終 DTO Contract Commit 推送並通知 Visual B 使用。
- 至少撰寫出 `choosing`、`reflecting`、`ended`、未知資料／未觸發結果的投影單元測試。
**完成判準：** 新型別可編譯；本 slice 沒有任何來自動畫、玩家輸入以外的額外亂數／副作用；遇到 `rest` 不編造他人幫助。  
**拒絕條件：** 在 Presentation 中使用 `Timer`／`GameStore`，或直接由 event title 判定故事因果。

### VW-01（0.50h，Visual B）開出可分離場景

**輸入：** LL-01 凍結 DTO 契約；可先用契約 fixture 開工，不需要等待整個 Gameplay。  
**動作：**
- 開 `codex/life-loop-visual-world-10h`，不要動 `CrossroadsView.swift`。
- 建立 `LifeWorldScene.swift`（可重用）及合理的 SwiftUI Preview，常態占首屏約40–55%，使用 repo 已有 `StoryPortrait`、`StoryPalette` 和原創 SwiftUI 場景。
- 確認 iPhone SE 直向不被裁切；場景為共用虛構舞台，不描繪國家制度。
**完成判準：** 有可查看的獨立大場景 Preview，角色可辨識，正常／最大文字至少不遮蔽操作；未新增未批准素材。  
**拒絕條件：** 在新 View 裡 `@State` 修改資源、假裝選擇已執行或拉入舊 WIP 整枝。

**R1 Gate：** DTO 原因來源明確；大畫面 Preview 獨立運作；Gameplay 可直接接正式 `LifeSession`。若 DTO 不穩，先停止 Visual 擴充，修契約後再進 R2。

## 2. R2（3h）— 生活會走動，遇事真正暫停

### LL-02（1.50h，Gameplay A）UI-only WorldPlaybackController

**輸入：** LL-01 定型 DTO。  
**動作：**
- App 新增 `WorldPlaybackController`，階段 `living/eventPaused/committedOutcome/ended`。普通狀態下短片段自動演進；暫停、正常、加速、skip 可以即時切換。
- 播放 tick 只改可視進度，不計算資源、年齡或世界事件；`eventPaused` 一直等玩家選。
- 以 injectable playback clock／scheduler 或純函數轉移檢驗，不以真實 `sleep` 才能測定理。
- 實作 lifecycle cancel／generation token，`onAppear`、重入與多次 skip 不得觸發重覆轉移。
**完成判準：** 暫停後不前進，skip可立即切事件；相同 life 以normal/fast/skip重建的權威 Session 完全一致。  
**負面測試：** 事件畫面空等後不產生選擇、連點skip、背景暫停與恢復、減少動態效果。

### LL-03（共1.50h，R2 先1.00h＋R3 後0.50h，Gameplay A）正式事件主流程接線

**輸入：** Controller + Visual 場景 slot contract。  
**動作：**
- **只有 A** 可以改 `CrossroadsView.swift`：首頁進入新大場景，按生活階段顯示 `LifeWorldScene`；已有 `choosing` 事件自然從同一場景跳出 Overlay。
- 事件標題、故事短文、成本、禁用原因、求助/免費休息與選項全部取 `LifeSession.event/preview`。
- `teen-project` 嵌既有 `ProjectWorkshopView` 特例，但整體流程不能只服務13歲。
- 保留從舊 Event-first 介面回退的 Preview flag／路徑，以便審查新循環失敗時不影響舊版。
**完成判準：** 8→10、12→13 兩次相鄰正式人生節點呈現 `living→eventPaused`；Overlay 必須阻止任何 autoplay 造成的選擇；場景不是88×68縮圖。
**負面測試：** 還沒遇到下一事件時不顯示未來選項、動畫速度改變不重抽同一個 Seed、最大文字仍可點所有選擇。

### VW-02（0.75h，Visual B，R2 .50＋R3 .25）輕量角色生命感

**動作：** 待機、生活小動作、事件反應三種狀態；同一場景之內可見沐沐與一名已知人物。使用現有角色與 SwiftUI 小幅 offset／opacity，不新增大圖。角色年齡至少看得出童年、13歲、成人三種呈現。  
**完成判準：** 普通模式有小幅演出；Reduce Motion 時同樣訊息仍以靜態角色、文字與道具可見。  
**拒絕條件：** 自由地圖／碰撞系統、每人骨架動畫、未來源支持人物、FPS重型動作。

**R2 Gate：** 從生活畫面出現第一個正式事件，不選不前進；新世界已進入主流程，沒有純 Preview 假畫面。如果仍必須按下一段才能看到事件，R2 不通過。

## 3. R3（3h）— 選完後真的改變世界，而非回到卡片列表

### LL-03（剩0.50h，Gameplay A）修正場景與事件接線

**動作：** 只修 R2 實測的最大 UX 問題（Overlay位置／底部按鈕／13歲特例）；保留真實 `preview`、點擊區與可及性識別。
**完成判準：** 首屏主要是人物及環境，選項不被場景覆蓋；真正事件可操作。

### LL-04（1.00h，Gameplay A）已保存後果與自動續行

**動作：**
- 當 `GameStore.choose` 成功，使用**已發佈 reflecting session**構造 committed world changes，原場景更新道具／人物／故事記憶；
- 如保存失敗，畫面繼續顯示原選擇、錯誤可重試，不得顯示已做出的決策或新生活。
- 後果可讀但不強迫按「走向下一段」。一般模式短暫演出後，透過 guard 一次呼叫 `GameStore.next()`，接下一段生活。使用者若查看原因／比較、暫停或 VoiceOver 正在閱讀時不得計時推走。
- `next` 失敗保持 `reflecting`；解除故障可重試，不再執行 `choose`。
**完成判準：** 13歲 invest/offline/ask/rest 只顯示實際反應；另一個非13歲事件也有可驗證變化；後續至少再進入一次 `living`。  
**負面測試：** `save`失敗、`next`雙觸發、未發生luck、欠缺資源、時間跳躍已觸發/未觸發線索。

### LL-05（1.00h，R3 .50＋R4 .50，Gameplay A）重播／存檔／分岔保護

**動作：**
- 守住同背景Seed選擇的權威 Session 結果；不同 playback 速度／skip 不影響 `KeyedRandom` 或 ConsequenceTrace。
- 冷啟動 choosing/reflecting/ended 應還原可操作畫面；不二次套用 age jump。
- `viewingOriginal` 唯讀；從原人生改選至替代人生後，世界角色與已留記憶來自當前 active session，不串到原路。
- 保留臺灣 missing data、其他七國跨國比較及 80歲回顧。
**完成判準：** 具代表性的日本、臺灣完整人生與13歲fork smoke，原局不變，Codable/Journey 續玩一致，寫入失敗重試不丟失資料。  
**禁止：** 只為簡化 UI 直接重置一局或靜默覆寫不相容版本的存檔。

### VW-03（0.50h，Visual B）後果道具及可及性

**動作：** 在同一生活場景顯示至少兩種由 trace 驅動的不同結果（例如已發生的創作記憶、已互動的人物標記）；只以「待續」顯示延後線索。大字級時隱藏純裝飾但保留全部說明；VoiceOver 正確區分事件、世界變化及選項。  
**完成判準：** 一組同 Seed 不同 choice 的畫面可清楚分辨，旁有 trace ID 的證據對應；減少動態效果仍能辨識差異。
**拒絕條件：** 只用顏色區分、無來源改變數值、休息卻畫已協助的角色。

### VW-04（0.25h，Visual B）畫面截圖和交付

**動作：** 以固定 Seed、指定 event ID 與選擇記錄 capture：Living → EventPaused → CommittedOutcome → 下一段Living，以及最大字級；保存截圖來源、解析度／SHA、是否正式 Session、當次狀態。  
**完成判準：** 可驗證截圖來源不是 fixture／Mock 的正式成果；候選圖與正式通過資產分清楚。

**R3 Gate：** 「選完的世界與之前不同」是已保存 trace 支持的可見結果；後果與下一個 Living 能自然連續；如果只更換卡片文字、不改場景，R3 **不得**宣稱玩法達標。

## 4. R4（2h）— 系統回歸、獨立審查、封存候選

### LL-05（剩0.50h）與 LL-06（0.50h，Gameplay A）

- 合併 **Visual B 的獨立檔案與必要 adapter** 至 Gameplay integration branch。不要整枝 merge 舊 `codex/lc-visual-design` 或 `codex/sim-workshop-continuity`。
- `CrossroadsView.swift` 只由 A 最終接線。若存在 DTO 名稱差異，修成單一只讀 adapter，而不是複製 Resolver。
- 以 `LifeWorldPreview` 啟用新流程；保留退回 PR #8 既有 UI 的可逆入口。新／舊畫面跑相同生命紀錄；若新 UI 未過回歸，不動舊流程。
- 固定完整版本與 source SHA；每輪增量需能追到提交。
- 建 Draft Integration PR，清楚列父 PR #6/#7/#8 合併依賴與未驗證範圍；不得自動合併 main。

### QA-01（0.50h，獨立 Reviewer）工程檢查

**固定 Gate：**
1. `swift test -c release` 全套，Python `unittest` + data check + basic governance。
2. `bash scripts/ios-check.sh` 以及新生活循環、pause/skip、最大字級、存檔失敗/重試與分岔至少一條路線的定向 UI 測試。專用 Simulator 成功/失敗/取消都刪除本輪裝置並留清理 inventory。
3. 比較同背景/Seed/15 choices 下 normal vs fast vs skip 的完整 Session/trace；對照 fork 原局 invariant。
4. 查最新 PR HEAD 對應的遠端 CI；若尚未完成，就列 `CI=PENDING` 不冒稱已過。

**阻擋：** 原局遭修改、增加未記錄亂數、存檔失敗仍換畫面、跳過改變決策、原本15決策卡死、資料缺口補造0。  
**非阻擋但須列出：** 視覺未最終選稿、成人／晚年未有專屬動畫、實機／真人測試不足、舊偶發首頁轉場警告尚未隔離。

### QA-02（0.50h，獨立 Reviewer）遊戲性第一輪審查

- **同 Seed 舊／新**：8歲、13歲與中年共三個節點，評估首屏角色是否主導、事件是否自然進入、結果是否在原場景留下差異。
- **操作成本：** 15事件需多按多少次才能推進？預設新循環不得比舊版增加不必要強制操作；skip可直達事件。首次 10–15 分鐘只能做內部實測估計，不能宣稱兒少已驗收。
- **故事感：** 玩家若不看技術 trace，能否識別是哪個選擇留下哪項變化？求助與休息有可理解路線，不只有投入的正面畫面。
- **教育界線：** 國名只是環境資料，不是角色好壞；臺灣缺口透明；原人生／改選人生的比較不把所有後續差異歸因於起始選擇。
- **交付判定：** `DONE` 完全符合 G1–G5；`PARTIAL` 至少正式人生可玩的兩事件循環＋原本15次事件不破；`BLOCKED` 若主要資料／狀態安全失敗，不用截圖掩飾。

**R4 Gate：** 同一版本、相同 Seed 在舊 UI 和新 UI 的權威結果一致；新 UI 實際顯示從生活到結果的循環且可操作。若還有阻擋項，不合併／不發布，保留 Draft 和具體失敗重現。

## 5. 工作分支、所有權與交接

| 工作項 | Gameplay A | Visual B | Reviewer |
| --- | --- | --- | --- |
| `LifeCrossroads/Domain`、`Data`、`Persistence` | 原則上不改，若必要需單獨說明版本與重播影響 | **禁止** | 只讀核對 |
| `LifeCrossroads/Presentation/WorldMoment*.swift` | **唯一 Owner** | 只讀 DTO | 審查 |
| `LifeCrossroads/App/CrossroadsView.swift`、`GameStore.swift` | **唯一 Owner** | **禁止修改** | 審查 |
| `LifeCrossroads/App/LifeWorldScene.swift` 與相鄰新視覺檔 | 整合只讀 | **唯一 Owner** | 審查 |
| `Package.swift`、Xcode 接線 | **唯一 Owner** | 不改 project file | 審查 |
| `Tests/LifePresentationTests`／新 Flow tests | **唯一 Owner** | 視覺 Preview 自測，避免衝突 | 審查 |
| `UITests/LifeCrossroadsUITests.swift` | **唯一 Owner** | 提供測試 IDs／截圖 | 審查 |
| `docs/life-loop-10h/ITERATION_LOG.md` | 每輪記實際結果 | 交付差異及來源 | 記驗收結論 |

**Agent B 最早可在 LL-01 的 DTO 契約提交後以共享 SHA 分枝；不能各自假設不同資料契約。** 兩者沒有同時修改的檔案，並行開發後由 A 接起正式 App。Reviewer 可以在 R2/R3 做局部查看，但最後1h才統計總工時與最終覆審。

## 6. Slice 接受／回退矩陣

| 如果遇到 | 立即處理 | 不得做 |
| --- | --- | --- |
| 生活場景變成空白或過大擋住選項 | 降低場景高度、可捲動浮層、保留同場景 | 為了首屏而隱藏求助／休息 |
| 暫停/skip造成重覆 `next` | 停止 autoplay；先用明確「繼續生活」保留功能，再修 guard | 強迫修改 `LifeSession` 或提高亂數性 |
| 失敗儲存後出現成功反應 | 立即退回先儲存後發佈；新增失敗重現測試 | 只修文案而繼續顯示下一人生 |
| 新圖不一致或權利未知 | 使用現有已在正式 App 的圖或 SwiftUI shapes | 引入未核准 AI 候選、複製參考遊戲 |
| 有一段演出沒有實際資料可支持 | 顯示純裝飾動作或沉默的生活氛圍；保留「沒有新記錄」 | 編造朋友幫助、已完成作品或未發生事件 |
| 後期沒有專屬動畫 | 回退共用世界＋正確年齡人物與文字 | 因動畫未齊就中止完整人生 |
| 時間不足／CI 未完成 | 保留有價值 Partial、可測提交與未完成清單 | 隱藏測試失敗、假報綠燈、要求默默延長10h |

## 7. 可直接交給兩個 Agent 的啟動指令

### 給 Gameplay A

> 以 `plan/life-loop-10h-no-schedule` 最新文件提交作共同基底，讀取 `docs/life-loop-10h/PLAN.md`、`CONTRACT.md`、`SLICES.md`，以及 repo `AGENTS.md`、`PLAN.md`。主導 LL-00～LL-06，共最多7 Agent-hours。先凍結 DTO 再交接 Visual；實際將正式八國 `LifeSession` 從 Event-first UI 改成 Living→EventPaused→CommittedOutcome→Living；只控制播放，不加入排程或第二引擎；先存檔再顯示後果。你唯一修改 CrossroadsView/GameStore/Package/Xcode；確保 Seed、原局、分岔、缺值、存讀、最大文字、Reduce Motion 的回歸。每一輪 commit、測試、截圖與迭代日誌；建立 Draft PR，不合併、不發布。

### 給 Visual B

> 以 Gameplay LL-01 凍結的 DTO 共享 commit 作基底，讀取 `docs/life-loop-10h/{PLAN,SLICES,CONTRACT}.md`。僅做 VW-01～VW-04，共最多2 Agent-hours。建立獨立 `LifeWorldScene`／角色待機互動反應／場景道具 UI；使用現有動物角色或原創 SwiftUI shapes，不大量生圖，不修改 Domain、Data、Persistence、GameStore、CrossroadsView、Package 或 Xcode project。不得依素材猜因果；所有可見世界變化都經過只讀 View DTO。完成獨立 Preview、Reduced Motion／大字級路徑與可核對的 PNG/來源紀錄，交由 Gameplay 接入，不直接合併。

### 給 Reviewer／整合驗收

> 用不超過1 Agent-hour 獨立檢查新玩法的真正 UI 操作及現有模擬正確性，優先確認場景→事件→已存結果→場景、雙擊 skip／失敗儲存／原局分岔、正常字級與最大字級；重跑實際命令、保留原始失敗、核對 CI HEAD 與本次 Simulator 清理。只評工程與初步 UX，不能宣稱兒少好玩、實機或授權已驗收。若阻擋未修正，給可重現案例並維持 Draft／HOLD。

## 8. 最終報告與停止條件

實作 Agent 最終交付需用以下結構，**不可提前填 DONE**：

```text
結果：DONE | PARTIAL | BLOCKED
原因：這次實際做到的使用者可玩循環與最重要限制
下一步：三個按風險排序的剩餘工作
總 Agent-hours：A=__ / B=__ / Reviewer=__，合計=__ / 10
基底與 PR：baseSHA=__ / branch=__ / PR=__ / HEAD=__
迭代 R1：commit / tests / screenshot / 未解問題
迭代 R2：commit / tests / screenshot / 未解問題
迭代 R3：commit / tests / screenshot / 未解問題
迭代 R4：commit / tests / screenshot / 未解問題
功能：Living / Pause / Speed / Skip / Event / WorldChange / Restart / Branch
資料正確：Seed / 15 events / trace / SaveRepository / TWN missing
驗證：Swift / Python / XCUITest / CI HEAD / 專用Simulator刪除
不宣稱：正式美術、LC-03完整資料、兒少／實機／VoiceOver／發布
```

若10h預算用盡但 G1、G3 有阻擋，立即保留可恢復的 Draft + 確實測試收據，停止新圖、新動作與次要修飾。若僅缺某階段專屬場景或真人玩家證據，可交付有界 PARTIAL，列清楚沒有完成之處。
