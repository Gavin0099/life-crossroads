# LIFE-LOOP 10H v1.1 — 無排程生活循環 × rossark-motion-skill 整合 PLAN

> 日期：2026-10-24｜狀態：**整套程式及本機整合驗證完成；最終HEAD CI推送後核對，Draft/HOLD**
> 基底：PR #8 `c136bebf48ae17e24235d9da72d7f9e51b90bf0c`（其祖先含 PR #7 `49ead5a`、PR #6 `4a6e32b`；PR #5 已合併 main）  
> 本次範圍：**Gameplay 7h + Visual 2h + 獨立整合驗收 1h = 總計 10 Agent-hours**。計時是任務預算，不是承諾精確牆上時間。Visual 的 Skill 評估與 PoC **包含在既有 2h 內**，不得另外加時。
> 動畫方法來源：[rossark-motion-skill](https://github.com/rossark0/rossark-motion-skill/tree/9b20964e32f07f8ac7e2948cd175746fa4a7712f)，固定來源 Commit `9b20964e32f07f8ac7e2948cd175746fa4a7712f`（MIT）。只使用方法與經審核的必要 SwiftUI helpers，不依賴自動生影片。  
> 產品定位：P1 遊戲循環實驗，Draft/HOLD、不合併、不發佈、不送 TestFlight。

## 0. 為何重做這個循環

現有主流程：`LifeSession.phase = choosing / reflecting / ended`；UI 以事件文字、縮圖與「走向下一段」為主。一般事件圖仍是 88×68 pt；PR #8 只為13歲 `teen-project` 提供真實 trace 驅動的工作室事件呈現。先前 102 Swift/23 Python 及 UI/CI 的通過只證明功能和局部視覺正確，不證明孩子感到自己「正在過人生」。

**新體驗承諾：** 孩子進入大型生活世界，能觀察沐沐與熟悉人物；時間以可略過的生活片段流動；一件實際事件出現時暫停；玩家做決定；已保存的實際後果讓同一世界出現不同人物／道具／故事記憶；生活再向前，不需每次點「下一段」。

### 不做什麼

- **沒有**每階段三格、每月或每日的生活排程；玩家仍主要在15次重大人生事件做選擇。
- 不新增 RNG 引擎、事件資料、國家指標、數值成長曲線、自由走路地圖、戰鬥、手動對話樹或第二套人生狀態。
- 不複製《美少女夢工廠》的人物、素材、畫面配置、文本或作品特徵，只借鏡「角色成長可見」的抽象概念。
- 不大量生圖。既有動物角色與可驗證的 SwiftUI 場景先做；未經審核的候選 PNG 不進正式 App。
- `rossark-motion-skill` 是程式動畫方法與範本，**不是**單張 PNG 自動生成可用骨架或影片的 AI；不得把 Demo 角色、素材、畫面直接併入產品。
- 不在這10h宣稱完成八國在地美術、50–70事件、完整 LC-03 資料 Gate、真實 iPhone／人工 VoiceOver／兒少試玩或正式發布。

## 1. 核心玩家體驗（必須能在正式 App 走通）

1. **進入生活：** 開始人生後進入以畫面為主的 `LivingWorld`。第一個事件前可顯示一段短生活片段，背景有原創角色待機／活動的輕量演出；不強迫等待。
2. **暫停遇事：** 系統由唯一正式 `LifeSession.event(catalog:)` 取得本回合已抽中的事件，將原場景停住，顯示可讀的事件浮層和真正可用的行動；事件視窗不可自動幫玩家選。
3. **玩家選擇：** 仍呼叫 `GameStore.choose(choiceID)`；只在 `SaveRepository.save` 成功且已發佈 `reflecting` 的 `ConsequenceTrace` 之後，場景才能顯示本次反應。
4. **世界留下變化：** 同一場景中的人物、物品、互動提示或記憶符號至少有一項與已提交 trace 對應。未發生的幫助、運氣、延後邀請不能畫成已完成。
5. **自然續行：** 後果簡短展示後，由控制器**至多一次**觸發既有 `GameStore.next()`（保存成功才前進），進入下一個生活片段；若打開原因說明或比較頁則暫停自動推進。玩家可直接略過演出，不必反覆按「下一段」。
6. **晚年與分岔：** 結束時進入原有回憶冊／完整分岔比較。從岔路重走同樣套用生活演出；原人生保持不可變。

遊戲一局仍為五階段、15個重大決策、80歲回顧。生活片段是壓縮人生的視覺敘事，**不是逐年真實模擬**；不能在畫面上插入引擎未計算的每年資源增減或國別生活機率。

## 2. 技術方向（只在 UI 與單向 Presentation 做主改造）

### 權威狀態永遠是原引擎

`LifeSession`、`LifeState`、`EventSelector`、`DecisionResolver`、`ConsequenceTrace`、`TimeJumpTrace`、`StoryMemory`、`BranchExperiment`、`LifePersistence` 保持既有唯一真實來源。

- 新增 `LifePresentation/WorldMomentProjector`（純 Swift，只讀 Session/Trace）投影人物、場景、年齡階段、道具及可驗證後果；不得寫入事件選擇或觸發亂數。
- App 新增 `WorldPlaybackController`（@MainActor／可測試）管理 UI 播放階段：`living → eventPaused → outcome → living`、結局 `ended`。這是**可重建的暫態呈現狀態**，不是新的 `SessionPhase` 或存檔模型。
- 與原生 `LifeSession` 的映射：
  - `choosing`：事件已抽中；視覺可以先播放本次到達的生活片段，然後停在事件浮層。
  - `reflecting`：結果已被正式儲存；顯示已提交後果，之後呼叫原有 `next()` 推進。
  - `ended`：維持原有結局、原人生／替代人生查看與比較。
- `Living` 播放只讀 `TimeJumpTrace`、當前狀態和已發生故事。畫面日夜、走路或呼吸循環是美術寓意；**不改變年齡、資源、事件資格或事件 draw**。
- 暫停／1×／3×／跳過只控制 UI 播放。跳過／重入／重複點擊不得呼叫兩次 `continueLife`，也不應觸發額外亂數。
- App background/foreground、旋轉、重開：先停止 UI 任務；重啟從已存 `LifeSession.phase` 重建，對正在選擇的事件直接停在事件頁，避免二次自動前進；已提交反映頁仍保留後果，按正確條件續行。
- `ProjectMoment` 與 `ProjectWorkshopView` 是單事件特例；可以嵌入通用場景容器，不能把它當作新決策引擎。
- `LifeWorldScene` 以 DTO 驅動，Visual 不能從國家名推導人物能力、醫療／網路可得性或宣稱事件已觸發。
- 動畫採**單一場景播放時間軸**（presentation-only），抽樣來源僅用可重現的裝飾性 phase，不呼叫 `KeyedRandom`。已有 `LifeSession` 的權威時鐘/事件抽選不變；跳過動畫不能跳過玩家選項。
- 若複製原作者的 SwiftUI helper，須記錄來源 Commit、原檔、修改範圍並保留 MIT 授權／著作權聲明於適當第三方公告。不能直接原樣套用其 `LoopClock` 作暫停控制：該範本 `paused` 時呈現時間 0，而恢復時計算自原 `start` 的經過時間，可能造成姿勢跳回與時間不連續。此問題應在 App 播放控制器用可暫停、可續接的**累積演出時間**解決，而非修改遊戲規則。
- 保留舊 Event-first 畫面做開發回退（feature flag／可切換預覽入口）；不能因舊畫面備援而將新循環測試誤報為通過。

詳細欄位與轉移驗收見 [CONTRACT.md](CONTRACT.md)。

## 3. 預期遊戲感與畫面

- 普通直向 iPhone 畫面，事件未出現時以**大型生活場景為視覺主體**，不再用 88×68 pt 縮圖代表整個世界。探索性目標：一般字級首屏場景約占可用高度 40–55%；不能因此把事件選項卡藏到不可操作的位置。
- 沐沐與主要熟人具待機、互動、事件反應三狀態；優先 8、13 與一個成年節點證明年齡與記憶可用相同元件顯示，其餘依既有五階段圖回退。
- 可選擇開啟「故事記憶／為什麼」而不暫停後決策所需的閱讀；延遲線索只呈現「已留下的約定／線索」，不能說已實現。
- 節奏預設快速：生活短片段 2–4 秒、後果 1–2 秒，均可立即跳過；數值是**暫定 UX 參數**，需人測而非事實時長宣稱。
- Event overlay 保留適齡文字、選項成本、不可行原因、求助／免費休息；注意孩子不應被長段報表淹沒。
- VoiceOver、Dynamic Type／最大字級、Reduce Motion 及低效能裝置時，演出可直接跳至可互動狀態，不能失去任何資訊。

## 3A. 動畫方法導入（rossark-motion-skill，Visual 2h 內完成）

### 本次只採用合適的部分

- **SwiftUI 原生動畫方法：** 參考固定版本的 `SKILL.md`、`MOTION.md` 與 `templates/swiftui/Motion.swift`；優先使用小幅 `wave`／連續 `flow`、柔和進出、單次結果動畫、同一場景時鐘。只在測試證明必要時複製少量 helpers；不需要引入整個 Repo、React Native 或影片輸出系統。
- **現有資產的可行性：** `StoryPortrait` 是從合成 `StoryCast` 圖表裁切的 PNG，眼睛／頭／手／尾巴沒有獨立可動層。這次先作輕微整體呼吸（位移約 1–2 pt）、重心與輕微傾斜（以人物不漂浮為前提），加一至兩種背景氛圍（如樹葉／水面）；**不承諾 LiveFace 眨眼、分段手臂或尾巴骨架**。
- **可見結果：** 從已保存的 `ConsequenceTrace` 出發，讓場景中一個道具、已互動人物或故事記憶發生單次可見變化。尚未發生的邀請、鼓勵或時間跳躍不能當成已發生。大場景只做一項主要動作及少量細小循環，避免永遠忙碌。
- **播放時鐘：** `WorldPlaybackController` 提供累積 `presentationElapsed`／`motionTime`；`LifeWorldScene` 消費時間值，不能自行調用 `LifeSession.next()`。暫停、改速度、遮蔽、退到背景時時間**凍結於現有姿勢**，恢復時從原姿勢連續前進，不瞬跳 0。Reduced Motion 呈現靜態資訊；單次結果直接呈現最終**已發生**狀態。
- **平穩與效能：** 使用一個場景級 `TimelineView`／時計驅動各元素，非每個物件各啟一個時鐘；沒有每幀 `random()`。場景移出、Sheet 遮蔽、App 背景或 reduced-motion 時停止不必要重繪。檢查循環首尾不跳格、事件前後不可預支後果、場景不抖動、不遮選項。
- **知識產權：** 原 Repo 的 `LICENSE` 為 MIT。任何複製或改造的原始碼須保留要求的授權與著作權聲明；本案原創角色、Demo PNG/MP4、外部參考影片的授權分別核對，不能由原 Skill 的 MIT 推定第三方圖片皆可用。具體採用／未採用清單見 [MOTION.md](MOTION.md)，導入程式時由 Agent 更新實際證據。

### 2h Visual 的 PoC 邊界

`VW-01 = 0.50h`（固定 Repo／授權查核 0.25h + 原場景靜態及動態可行性 0.25h）；`VW-02 = 0.75h`（一組待機／互動動畫、可續接時鐘）；`VW-03 = 0.50h`（trace-backed 單次事件反應、Reduced Motion）；`VW-04 = 0.25h`（固定時刻截圖／接縫檢查／證據與交接）。**超時或分層做不到即回退到原生 SwiftUI 的小幅 `offset/rotation`，不延長工時、不擴增原圖。**

## 4. 10 小時預算與雙 Agent 產出

| 帳戶 | 上限 | 範圍 |
| --- | ---: | --- |
| Agent A / Gameplay Flow | 7.00h | 只讀世界投影、播放控制、原生 App 主流程接線、回歸防護 |
| Agent B / Visual World | 2.00h | 大型場景、`rossark-motion-skill` 固定版本審核與 PoC、輕量待機／互動／後果演出、可及性；只交付獨立 View/已記錄授權的必要 helper |
| Integration + independent review | 1.00h | 手動對照行為、CI／模擬器、回歸與錯誤分類、PR 收束 |
| **總計** | **10.00h** | Agent-hours；平行工作不重複扣工 |

**四輪迭代：** R1 2h（架構與畫面邊界）；R2 3h（生活到事件）；R3 3h（已保存後果回到世界）；R4 2h（回歸、修正、交付）。每輪必有可檢視的 Commit、可運行證據／測試及最高風險記錄，不把 UI 截圖當作引擎成功。

詳見 [SLICES.md](SLICES.md) 的工時帳、依賴、Owner、DoD、回退與證據路徑。

## 5. 六項硬性驗收 Gate

**G1 真實人生：** 正式八國 `LifeSession` 仍可完成 15 次選擇與 80 歲回顧；未改 Seed、事件條件、資源規則、台灣未知資料口徑。

**G2 生活循環：** 至少兩個相鄰的正式事件可從 Living（大場景）→ EventPaused → 選擇 → 同場景後果 → Living；後續可完成一整局。無生活排程或「每回合手按下一段」。

**G3 決定論：** 同背景、Seed、15個 choiceID、版本下，暫停、1×、3×、skip、前背景切換的最終 `LifeSession`、`selectionTraces`、`ConsequenceTrace`、存檔相同；回到岔路原局不變，替代線仍可完成；動畫不能抽遊戲亂數。

**G4 真實後果：** 13歲 `teen-project`、一般事件及一個有延遲線索的回顧各有至少一個可目視辨識的 **trace-backed** 變化；未發生的運氣/支持及台灣資料缺口不編造。

**G5 可操作：** iPhone SE 尺寸首屏找得到事件選擇，最大文字和 Reduced Motion 仍可操作；VoiceOver 基本標籤／焦點順序有自動檢查與人工待驗清單。CI 綠與暫存 Simulator 刪除收據是工程 Gate，真人節奏／兒少趣味**另待驗證**。

**G6 動畫品質與授權：** 同一正式場景的待機／互動與已保存結果單次演出至少各一項可檢；暫停→恢復及 1×→3× 不瞬跳、背景／離屏不運轉、loop 接縫平順，Reduced Motion 呈現正確靜態/已發生結果。若引用原作者代碼，固定來源 Commit 並保留 MIT 條款；無可用分層 PNG 時不虛構全身動畫已完成。**G6 不要求正式角色骨架或全場景可動。**

## 6. 風險與回退

1. **播放假成長：** 若動畫比故事多，先退回「大型場景＋可跳過短片」，不要為湊動畫自行改 Domain。
2. **自動推進吞存檔：** 任何 save failure 都須留在已提交後果或原選擇；顯示可重試操作，不准轉入下一人生時點。
3. **UI state 交叉：** `viewingOriginal`、分岔人生、比較 sheet、重開 App 需測；沒有新 `SessionPhase` 或假原人生副本。
4. **PR 階層未合併：** PR #6／#7／#8 均為獨立 Draft；本片基於固定 PR #8 代碼，並不授權合併父 PR。若父 PR HEAD 更新，先做 diff 與 rebase risk check。
5. **視覺越權：** 未核准插圖一律視為候選，保留素材來源；Visual 僅改其所有檔，不改 Country、Domain、GameStore 或 `CrossroadsView.swift`。
6. **貼圖不可分層與時鐘跳動：** 不為了模仿 `LiveFace` 直接重畫臉或遮住原圖眼睛；合成 PNG 無法轉骨架時保留小幅整體動作。技能範例 `LoopClock` 的暫停跳 0 限制應由演出控制器隔離，必要時自行改寫時計並補負面測試。
6. **10h 上限：** 先保留可玩的完整人生和一段真正連貫的「活著」循環；無法完全鋪滿五階段時明列 PARTIAL，不把原 Event-first 換皮當完成。

## 7. 交付契約

- Draft PR、明確基底與 commit DAG；不得合併 main／上架。
- `docs/life-loop-10h/{PLAN,SLICES,CONTRACT,MOTION,ITERATION_LOG}.md`（本版整合前四份契約，迭代日誌由實作 Agent 建立）；機讀測試收據與對應 HEAD。
- 動畫 Skill 的來源版本、實際引入 helper 清單／變更與 MIT notice；0/loop seam/one-shot final 定點畫面、pause/resume 連續性及 Reduced Motion 證據。沒有複製代碼就明確記為「僅參考方法，無第三方程式碼引入」。
- 至少一組正式人生的 **舊 UI vs 新 UI** 同一 Seed／同一事件對照，包含事件前、後果、下一個生活畫面。
- Swift Unit／重播、Python、XCUITest／最大文字／Reduced Motion；所有測試失敗原紀錄保留。專用 Simulator 成功／失敗／取消都刪除本輪專用裝置，不刪他人或共用 runtime。
- 每輪結束寫 `DONE / PARTIAL / BLOCKED`、新發現的主要問題及下一輪取捨；必要時停止非核心視覺工作，保住 G1–G4。
- 整體 P1 尚缺的完整資料、事件量、實機、人工 VoiceOver、分齡兒少試玩與商用美術 Gate 不因本10h 自動關閉。

## 本輪完成索引

實作結果見[DELIVERY.md](DELIVERY.md)與[ITERATION_LOG.md](ITERATION_LOG.md)：111 Swift／25 Python、c445e5f兩機各18項完整回歸、新工具兩機各1項收尾通過，9台本輪專用Simulator已刪。以下規格與預算未擴張；Visual合併核時unknown、診斷收尾介入及warning／人工驗收均明列，不宣稱整體產品或發布Gate通過。
