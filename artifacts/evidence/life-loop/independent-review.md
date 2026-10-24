# LIFE-LOOP-01 / WORLD-ART-01 有界獨立程式審查

> 最新判斷：已證實創作DisclosureGroup AX接線缺陷已做source修正，最終原生證據仍待驗；維持CHANGES_REQUESTED。重新開始的原始失敗已由AX快照確認為helper過早取樣，不能歸因於confirmation請求遺失。下文依查核順序保留歷史假說與更正。

[Decision Summary]
**程式覆核結論：APPROVED（限下述程式邊界）；已證實程式阻擋項 0。**
這表示目前可把播放控制與世界場景交付為 Draft 候選，不表示完整原生 UI 驗證、上游 CI 或產品驗收已通過。主流程仍在執行原生測試；若其結果揭露本輪契約失敗，須重新覆核該差異，不能引用此結論忽略失敗。

## Review Inputs Checked

- PLAN.md、docs/project-guardrails.md、memory/01_active_task.md、AGENTS.base.md。
- governance/SYSTEM_PROMPT.md、AGENT.md、ARCHITECTURE.md、TESTING.md、REVIEW_CRITERIA.md。
- memory/03_knowledge_base.md 與 memory/04_review_log.md，包含先前原局不變、存檔失敗測試與 R1 SwiftUI runtime warning 的處置。
- 未提交 diff（基底 c136bebf48ae17e24235d9da72d7f9e51b90bf0c），新 Playback/World DTO/Scene/Tests、docs/life-world-contract.md、ADR0006。
- 必要語意半徑：LifeSession、BranchExperiment/LifeJourney、StoryMemory/StoryBranchEngine、SaveRepository 既有行為及 UI 測試接縫。

## Frozen Decision Boundary

- Owner decision：Gameplay 與 Visual World 兩角色整合，建立獨立 Draft PR 供 review；不合併、不發布。此 reviewer 不開發、不向 GitHub 發文。
- DONE（本子任務）：檢查播放/保存/原局/trace 來源及測試品質，將阻擋項與驗收缺口交回主流程。全套原生測試、遠端 CI、Simulator 清理由主流程負責。
- Claim ceiling：有界 source review + 6 項純 Swift 重跑；不是實機、人工 VoiceOver、兒少或發布資格認證。
- Risk：L2。播放本身純呈現，但接在保存、原局與分岔關鍵接縫。

## 已核對的行為

| 核對點 | 程式證據與判斷 |
| --- | --- |
| 播放不改人生與 Seed | LifePlayback.swift:8-45 僅持有呈現 phase/age/progress/pause/speed，不持有 session、亂數、IO 或真實時鐘；pulse/skip 只能到 event 並停住。GameStore.swift:98-117 控制呈現，只有 choose/next 才能呼叫正式 LifeJourney。 |
| 背景/恢復不補算 | CrossroadsView.swift:130-145 在非 active 時 pause，Task 取消與 pulse 前 guard 共同阻止恢復追趕；250ms 不是 elapsed-time 累積。GameStore.swift:69 與 LifePlayback.swift:26-32 重開直接停在已保存事件/結果。ADR0006 明示動畫位置不保存，不能聲稱恢復原動畫位置。 |
| 保存先於世界發布 | GameStore.swift:85-95 同步 save 成功後才替換 journey；start/restart:136-152、choose:156-161、next:164-173、branch:177-184 均在 commit 成功後才 travel/restore。失敗只設定錯誤，不發布新世界或新結果。同步 @MainActor 呼叫中未引入新的 await 競態。 |
| 原局/分岔 | GameStore.swift:20-23 選擇保留原局或 active alternative；world:101-105 只在局部副本 restore 原局呈現。choose/next 拒絕 viewingOriginal；BranchExperiment 的不可變 original、獨立 alternative 及既有 replay validation 沒有變更。 |
| 跨國比較 | compare:192-202 仍由正式選前 session/同選項構成，播放沒有插入亂數或改國家條件。新測試在正式13歲節點使用真實 compare；未更動 Domain/Data/Statistics/保存 schema 版本。 |
| 世界人物與物件 | LifeWorldViewState.swift:61-71 事件人物來自實際 projected event，選後人物來自此次 trace.changedRelationships 的 event/choice/age 匹配；74-82 的旗標及日記帶實際來源。friendship paused、learning none、care seeking/paused 不宣稱已完成作品或已獲支持。Scene 僅消費 DTO，不做隨機、決策或保存。 |
| 閱讀與動態 | CrossroadsView.swift:147-153 在事件及最大字級縮小舞台，177-207 最大字級直排操作；LifeWorldScene.swift:25-28,73-75,179-195 尊重 Reduce Motion 與停止插值；場景 AX 文字保留真實來源，正式啟動不暴露測試用 raw IDs。這是程式查核，原生可用性仍須看實跑。 |

## 技術觀察與缺口

### W1 — 純值隔離測試不能替代 GameStore 整合驗證

- Severity/source：WARNING，REVIEW_CRITERIA。
- Location：Tests/LifePresentationTests/LifePlaybackTests.swift:113-121、148-170。
- Evidence：`flow` 沒有 session reference，所以單獨呼叫 flow 後 `life == before` 很容易成立；SaveRepository round-trip 也未呼叫 App 中實際的 Task/commit。這些測試能保護呈現狀態機和投影，不能單獨證明 App 接線沒誤推進。
- 新 UI 測試 UITests/LifeCrossroadsUITests.swift:10-78 的方向正確：使用實際 pause/3倍/skip、兩事件自然到達、真實檔案 SHA、背景/重開、世界 AX 來源、保存失敗不前進與 retry。此審查發出時主流程仍在跑原生測試，尚未把它們計為 PASS。
- Attribution：introduced（覆蓋界線）；current-decision impact：no（Draft 工程候選 source review）；status：open；disposition：carried-forward 至主流程附上原生結果。最終若聲稱完整接線 DONE，需以該結果補足，失敗必須修正或明示未完成。
- Rule：TESTING §3.3、§3.4、§6.3；REVIEW_CRITERIA §3.3。

### W2 — 一般字級、小螢幕、完整分岔與 Reduce Motion 的原生證據尚待主流程統一完成

- Severity/source：WARNING，REVIEW_CRITERIA。
- Location：CrossroadsView.swift:25-69、147-207；LifeWorldScene.swift:179-205、216-260；UITests/LifeCrossroadsUITests.swift。
- Evidence：固定在 ScrollView 外的場景會改變可閱讀高度，原有11項 UI 的 skip/創作詳細紀錄接線已調整，新2項測試覆蓋生活與最大字級；source review 無法證明所有 hit target/長比較頁/原局畫面仍可操作。既有 UI 的前中末原局/比較內容斷言並未被移除。Reduce Motion 是程式路徑查核，尚無本 reviewer 新建的人工操作證據。
- Attribution：introduced/exposed（新布局驗證需求）；current-decision impact：no（本次 Draft 程式審查）；status：open；disposition：carried-forward 至主流程完整原生回歸與截圖查核。實機、人工 VoiceOver 與分齡兒少試玩維持後續 Gate，不以本輪 CI 替代。
- Rule：TESTING §4.2、§8；PLAN 驗收與 simulator/實機界線。

### R1 — 既有錯誤提示發布警告仍保留

- Severity/source：WARNING，前次 W1/W2 review。
- Location：CrossroadsView.swift:127-129 的既有 alert Binding/action；memory/04_review_log.md 的 1226fb2 review。
- Attribution：pre-existing/exposed；status：carried-forward；disposition：carried-forward；current-decision impact：no（本次未改該發布路徑、未見原局或保存損壞證據）。本輪未宣稱已隔離根因或修復。若新原生結果顯示狀態錯誤，應據實重新判定。
- Rule：TESTING §4.3；REVIEW_CRITERIA §2.1。

## 驗證

- Reviewer：`source .venv/bin/activate && swift test -c release --skip-build --filter LifePlaybackTests`，exit 0，6 項通過、0失敗。直接重跑主流程已建置 binary；不是另一次獨立 build。
- Raw：artifacts/governance/life-loop/independent-focused-swift.txt。
- 查核主流程全 Swift 日誌 swift-tests.txt 與父回報：108 distinct cases（12 presentation、85 domain、5 persistence、6 analysis）通過；這是作者證據，不冒充 reviewer 重跑全套。
- `git diff --check` 通過。reviewer 建立 Simulator 數 0；沒有刪除任何裝置、runtime 或其他工作線檔案。
- 沒有修改產品、測試、PLAN 或 memory，沒有 commit/push/merge/發布。此檔僅位於已授權 ignored review artifacts；canonical memory 由主流程彙整。

## Governance Audit

- Architecture：Presentation 純值，App 持有 UI Task 和 save 接線，Scene 只讀；Domain 未加入 time/UI/IO。
- Native Safety：N/A（沒有 ABI/硬體邊界）。
- Thread Safety：@MainActor synchronous commit；Task sleep 有 cancellation 及前景 guard。
- Baseline Status：不是重新資格認證上游 PR #8。基底 c136beb 的遠端 CI 在本輪早期仍進行中，不能用此 review 宣稱它已綠燈。
- Test Integrity：測試 expected 來自固定場景、phase/age/fact invariant 與原始檔 bytes，不重寫 RNG/核心引擎演算法。W1 明列純值測試的整合界線；沒有執行 mutation testing，不宣稱完整覆蓋。
- Knowledge Base：核對2項既有 gotcha 與具體前次 W1/W2、R1 記錄；未見新增國名倍率、虛構因果、原局改寫或 save-before-publish 逆序。

## 審查時產品 bytes（未提交工作目錄）

- `LifeCrossroads/App/GameStore.swift` SHA256 `0ed08ae4b223dfb3eeb48149988a182d5c81c23fd4e9d2116fc947ee975d5bca`
- `LifeCrossroads/App/CrossroadsView.swift` SHA256 `ad4a5247e455b3b0c094da2d712d960570048f4a68b76f5738bd636198ddfbea`
- `LifeCrossroads/App/LifeWorldScene.swift` SHA256 `311a1aef9dbf14cea5a739faea04819ac6ddbd645e1461d0760cf5bcfd304ad9`
- `LifeCrossroads/Presentation/LifePlayback.swift` SHA256 `f8c8f206394bb36a82c480937dfaed9bcc2344cc7f83652178da1cb2b0a27ef3`
- `LifeCrossroads/Presentation/LifeWorldViewState.swift` SHA256 `68957507afc2533d1890abf5d82761cd4f87eb0c0911ff689ff5d9e5a0d5c1cc`
- `Tests/LifePresentationTests/LifePlaybackTests.swift` SHA256 `4ae251bef9a7994cdf4453ccf5bf36824daea50630c44aab43466271fec5e741`
- `UITests/LifeCrossroadsUITests.swift` SHA256 `53eeb73dc5d40147eee8e9c674a544785033c15bbff19c6e220850e27da2beae`
- `Package.swift` SHA256 `0d63b08982e8f4763df1ab52893ddbc0527915c0dd020ab22e38ebfde8248baa`
- `LifeCrossroads.xcodeproj/project.pbxproj` SHA256 `3c1b5c91abab3fc750c253a9563bd49fdd9e93b86ba7efe3df8300578bb294ed`

## 定向重覆核：Simulator 測試標記的數字格式修正

2026-10-24，父工作線回報首輪兩項新 UI 均停在測試標記格式斷言。Reviewer 直接核對 `targeted-ios.txt:792`：實際 AX `event|true|1.000000|10|1|river-home` 與預期 `event|true|1.0|10|1|river-home` 不同；另一項在 UITests:28 的同類字串前綴斷言失敗。這是測試標記表示錯誤，不能把首輪結果記成 PASS，也不能據此宣稱後半段尚未執行的斷言已驗證。

本次修正將 CrossroadsView 的 Simulator AX marker 改成 `accessibilityValue(Text(verbatim: playbackTestValue))`，由明確 String 插值構成相同欄位；避免 SwiftUI LocalizedStringKey 重新格式化 Double。此 marker 仍只在 Simulator 且 uiTestArchiveChecksum 存在（-ui-testing）才顯示；新的 computed String 沒有狀態修改、保存或亂數存取。其餘所見變更為新增外層 VStack 的縮排整理。Gameplay、DTO、Scene、Tests、Package 及 Xcode wiring 與前次審查 SHA 相同，沒有擴張原程式覆核邊界。

- 判斷：修正合理，未新增程式阻擋項，維持有界 source APPROVED。
- 最新 CrossroadsView SHA256：`ad4a5247e455b3b0c094da2d712d960570048f4a68b76f5738bd636198ddfbea`。
- 直接核對 `artifacts/governance/life-loop/final-test-source.json` 的9項 bytes 全部匹配；上節的 CrossroadsView binding 已同步為本次修正版。
- `git diff --check` 通過。本次不重跑純 Swift、不建立 Simulator、不修改測試預期值來掩蓋失敗。
- 最終13項原生回歸仍由主流程執行；本覆核不預記其結果。W1/W2 的原生證據條件與實機/VoiceOver/兒少界線維持。

## 新原生證據後的有界重判：重新開始未進入新人生

**目前工程 DONE 判斷改為 CHANGES_REQUESTED，直到此重現失敗修正/排除；先前 source APPROVED 不是對此後新原生證據的批准。**

- Severity/source：BLOCKING（REVIEW_CRITERIA，本輪完整流程驗收）。
- Evidence：`full-ios.txt:1199-1225` 的完整人生案例已走完結局，點擊 `replayNewSeed`、`confirmRestart` 後沒有 `skipToEvent`，5秒內也沒有 `eventTitle`，UITests:283 失敗。確定的事實是此次回歸沒有滿足重新開始驗收；僅日誌尚不能證明唯一根因。
- Suspected location：`CrossroadsView.swift:113-121`。isPresented Binding setter 在 false 時清掉 restartAction，但 destructive Button 執行時才 switch 同一可變 optional，nil分支靜默 break。若系統先清顯示 binding，再執行已選按鈕，選擇便遺失。這是有實際危險的狀態/回呼依賴；不應依賴未固定的 dismissal/action 先後。
- Attribution：pre-existing/exposed。`git show c136beb:LifeCrossroads/App/CrossroadsView.swift` 有完全相同接線，不宣稱由 LIFE-LOOP 新引入；但本輪聲稱保留重新開始/固定Seed流程，故 current-decision impact：yes；status：open；disposition：fix now，或用可重現證據排除本假說並修真正根因。
- 建議：使用 iOS15 已有的 `confirmationDialog(... isPresented:..., presenting:restartAction) { action in ... } message: { _ in ... }`。按鈕只 switch 已捕獲的非 optional `action`，不再即時讀 restartAction；dismiss 清理仍保留。不要用 Button closure 第一行 `guard let restartAction` 作為修正，因為執行到那時已可能清空。也不要改用較新 item overload 提高最低版本。
- Primary API evidence：本機 iPhoneSimulator SDK `SwiftUI.swiftinterface:22552,22619` 宣告 presenting-data actions overload，availability iOS15；較新 item overload 的內建實作同樣把 wrappedValue 交給 presenting，支持把顯示內容資料與 dismiss binding 分離的設計。此為本機官方 SDK 查核，未做平台回呼順序的 instrumented 證明。
- 下一個可驗證邊界：主流程取失敗畫面/AX確定停在結局且無保存alert；採捕獲修法後以相同完整人生/換Seed/同Seed案例重跑，驗證新Seed改變與同Seed保持，保留原始失敗。Reviewer 不修改檔、不跑Simulator。

## 定向 source 覆核：重新開始請求改為捕獲值

主流程改為 `presenting: restartAction`，actions 參數 `action` 為非 optional，Button:116-120 只 switch 此捕獲值，沒有 nil/break；message 同步採資料參數版本。Binding false 清理與選後清理仍保留。這個修改移除前述可變 optional 於 callback 時被清空的依賴；沒有新增 engine、Seed 或存檔計算。

- 新 CrossroadsView SHA256：`5d0f12b44fce1e0d18ef92774483e440b2dd013b475672837625282e9f212407`。
- Source 修正判斷：合理；原生失敗 **尚未結案**，仍須完整重新開始案例與新增取消/同Seed/換Seed/首頁newLife案例在最終bytes通過。
- 測試source問題另即時通知：新 UITests:104 在 reflecting 畫面讀 `lifeSeed`；此元素只存在 decision()，所以預期會在真正restart之前失敗。建議先在最初 decision 保存 seed，再於每次成功restart decision更新，保留所有原有語意斷言，不擴大產品測試標記。此為測試harness錯誤，不是另一個產品缺陷。
- 沒有改產品或測試、沒有新Simulator、沒有重跑測試；`git diff --check` 通過。正在執行的全套仍綁定舊 final-test-source.json，不把舊binary通過案例預記為捕獲修法已驗證。

### 新增 restart test 的 seed 接縫已修正

已直接重讀最終測試：初始 `priorSeed` 在 start 成功的 decision 畫面擷取；每次 restart 的 `restartedSeed` 同樣在 decision 讀取並更新 priorSeed，然後才選 rest。取消仍核對實際檔案 SHA 與播放/世界狀態不變；same/new/same 仍斷言清掉舊決策、正確保持/更換Seed，首頁新局仍回 launchSeed。未新增產品標記或延長等待，沒有降低原斷言。測試source接縫問題現已 resolved；真正restart產品失敗仍待原生重跑。

- UITests SHA256：`10cc24f3b54ff3b7253bc50ccf084f5d00161632650e8ea5c4b3d23026b10084`。
- 已讀首輪 full-ios.txt 的作者原生證據：最大字級/保存失敗/重試/skip新案例 PASS 60.448秒（line4334）；兩事件自然到達/暫停/速度/背景/重開/實際世界記憶 PASS 53.935秒（line4543）。本輪 W1 的主要 App 接線已有實際支持，不能再只說全是純值隔離測試。
- 這兩項原生 PASS 綁定捕獲修法之前的 final-test-source.json；不把它們當成新confirmation修法已受測。原完整人生restart失敗及目前 CHANGES_REQUESTED 邊界仍保留，待最後同案例與新test重跑。既有 alert warning 又在full-ios:4308出現，R1維持 open/carried-forward，不能宣稱零警告。

## 定向 source 覆核：創作詳細紀錄 AX identifier 的作用範圍

已直接核對 `full-ios.txt:6457-6473` 的失敗 AX snapshot：展開後，原本應為 projectSceneCaption/projectMemory/projectReceipt 等 StaticText 都變成 identifier `projectDetails`，因此 ProjectFour 與 ProjectLarge 無法取得既有子項。這是本輪把 `accessibilityIdentifier` 掛在整個 DisclosureGroup 所引入的接線缺陷（introduced），不是虛構引擎、存檔或資料損壞。

修正後 CrossroadsView.swift:496-501 讓 DisclosureGroup 內容維持 `ProjectWorkshopView(moment:)`，只對 label Text 掛 projectDetails。子視圖本身仍各自保有原 identifier，openProjectDetails helper 仍以 any descendant 找同一個標籤來操作。原有四反應、來源、紙本保存失敗重試/存讀與各真實記憶斷言未刪除或放寬。這是最小合理修正；原生是否正確保留AX與label可點仍須同case重跑。

- Severity/source：BLOCKING，REVIEW_CRITERIA（本輪必要整合回歸失敗）。
- Current-decision impact：yes，直至最終兩個project案例在修正版通過；status：source corrected / native verification pending；disposition：fix now。
- 當前總判斷仍 CHANGES_REQUESTED，不能只憑 source 修正關閉原生失敗。Confirmation捕獲與此AX修正共用最終定向五案例驗證邊界。
- CrossroadsView SHA256：`0e1d82aba4f124e8a392d580d18e126a021ae5fca5694f7dbf22eb1b7530aed0`；UITests SHA保持 `10cc24f3b54ff3b7253bc50ccf084f5d00161632650e8ea5c4b3d23026b10084`。

同次delta其餘查核：生活頁caption現在直接說明「重開停在已存事件或結果」，與 ADR0006 恢復語意一致，沒有補算或改引擎。`.github/workflows/governance-drift.yml` 只把 ios-app job timeout 30→45分鐘；本輪14項原生流程較長且先前全套已超過22分鐘，增加外層時間預算不改測試選取、斷言、個別等待或通過條件，因此沒有藉延長等待掩蓋產品失敗。全套舊binary仍維持原證據綁定。

`git diff --check`通過。此 reviewer 沒有修改產品/測試/CI或建立Simulator；最終原生五案例證據仍待主流程。

## 原始 failure hierarchy 更正：重新開始確實已進入新生活

直接核對 `restart-failure-context/DBEB2187-C501-4F85-987A-440137EAFD96.txt`：line17 是5歲生活中的河畔，line21為0～8歲，line27 `living|false|0.625`，line38確實有 `skipToEvent`。沒有停留結局或存檔失敗alert。這推翻「此次confirm回呼沒有開始人生」的假說。

**更正後觀測根因：原測試helper只在tap返回後單幀查 `skip.exists`，錯過轉場後出現的控制；接著事件等待只有5秒，比正常8秒生活片段短，於合法旅行中失敗。** 先前full-ios中即時一次exists query不能代表後續skip永遠不存在。原生流程已真的開始；不能以這次failure證明optional-clearing接縫真的觸發、不能聲稱presenting修法修好了這個已觀測失敗，也不能由此推論它是舊PR8其他轉場問題的共同根因。

- Confirmation presenting修正仍可作為獨立source防禦：消除讀取可被dismiss清空optional的依賴；它在該次failure中不是已證實根因，不再作為已重現產品缺陷計數。
- 原restart項判定更正為 **test-harness defect**，attribution introduced/exposed（新生活旅行與舊helper假設不合）；測試同步source已修，實跑待驗。
- UITests.swift:635-640 把單次 `exists` 改成 `waitForExistence(timeout:3)`，等待真實玩家控制後tap。沒有直接改session/clock、沒有把事件5秒改長、沒有改資料或Seed斷言。若請求真的nil/no-op，3秒仍找不到skip，後續event斷言仍失敗，所以沒有將該缺陷隱藏。
- 新UITests SHA256：`a0a4cac03a82746c36556677c187d7eeb3cf192ca1fd04a5ed5cdd2c033652f5`；CrossroadsView保持 `0e1d82aba4f124e8a392d580d18e126a021ae5fca5694f7dbf22eb1b7530aed0`。
- 第一個定向5case run由主流程在已知harness問題後停止，不視為PASS或完整FAIL資格結果；原始log/result保留，Simulator由主流程trap清理。最終必須綁定上述新helper bytes重跑五case。
- 目前仍待最終原生證據，尤其本輪已證實的project AX接線缺陷尚不能結案，因此維持CHANGES_REQUESTED；本更正移除錯誤根因歸屬，不預記新run成功。

本 reviewer僅更正此報告、未改產品或測試、未建立Simulator；`git diff --check`通過。
