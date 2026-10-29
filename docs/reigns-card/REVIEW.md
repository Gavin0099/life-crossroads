# RC-00～02 獨立覆審

Reviewer：`/root/reigns_poc_review`，2026-10-29。範圍限 13 歲 Reigns+ PoC；只讀程式、測試、原生截圖與執行紀錄，僅新增本報告。沒有修改實作、啟動 Simulator、提交 GitHub Review 或批准合併。

## 判定

| 面向 | 判定 | 邊界 |
| --- | --- | --- |
| Engineering | ACCEPT | 已檢查的 RC-00～02 操作與保存邊界可交付 Draft 審查；不是完整 RC-04 或遠端 CI 全綠聲明 |
| Visual | CONDITIONAL ACCEPT | 一般字級兩尺寸的四條道路可見、保存後活動可分辨；最大字級須捲動，手勢節奏及真人無障礙仍待驗證 |
| Product | 適合 Owner 試玩這個 PoC | 尚不能判定比原介面有趣，不能代替 10～15 歲測試；不授權 RC-03～06、合併或發布 |

最終未發現本輪新增、尚未修正且有證據的 P1／P2 阻擋項。覆審中找到的一項 P2 已修正並重新取證。既有治理與無障礙 finding 仍保留，不能稱專案所有 Gate 通過。

## 審查基準與來源

- 基底：PR #21 `eb6eff1be21e809e82f61806d53a1ef404910c3e`；實作工作樹 `codex/reigns-card-poc`。提交與遠端 CI 狀態由交付報告另記，這份審查不以尚未建立的 commit 代替來源。
- 規格：[PLAN](PLAN.md)、[SWIPE_CONTRACT](SWIPE_CONTRACT.md)；另讀 repo 的 PLAN、project-guardrails、AGENTS.base、SYSTEM_PROMPT、review criteria、既有 readability 驗證紀錄。
- 主要讀取：`DecisionCardModel.swift`、`DecisionSwipeCard.swift`、`CrossroadsView.swift` 差異、六項純模型測試、四項新原生測試、原有 `GameStore` 保存與 checksum 路徑。
- 最後更正的截圖／測試來源：[iPhone 17 source.json](../../artifacts/evidence/reigns-card/details-corrected/iPhone-17/source.json)、[SE3 source.json](../../artifacts/evidence/reigns-card/details-corrected/iPhone-SE-3rd-generation/source.json)。不是把最後小修套用到較早完整測試批次。

覆審時實作 SHA-256：

| 檔案 | SHA-256 |
| --- | --- |
| App/CrossroadsView.swift | `085dfd182d506d000e8c29bd326acec5eab95f97b902ff43436fdfbb803c540d` |
| App/DecisionSwipeCard.swift | `943fbe2d53fb043aa5b462184af189bd8c7e8ee8adcf555da93e4168b407fcfd` |
| Presentation/DecisionCardModel.swift | `6a3c373369d554778c23148fc1ce456cd6f8f49e9a094dfa54ae74dfd29ea2fa` |
| UITests/ReignsCardTests.swift | `74fa4802076643477f7442347e796106ecdadda92dbe7008fabca4ca2b6a39cc` |

## 已修正的發現

**P2：把數位準備說明套在求助、休息與紙本選項。** 原生 `details-final/.../rc-preparation-details.png` 顯示求助列也寫「仍要安排家裡的設備和課後時間」，原始程式對每個 choice 都呼叫 `BirthStory.creationContext`。該 helper 的無數位調整分支仍是數位學習說明，因此休息也被附上與其正式 0／0／0 成本無關的設備文案。

修正限 Presentation：僅 `choice.requiresDigitalAccess` 顯示該段，其他選項保留正式成本與不可行原因。沒有修改 Data helper、事件或成本。新原生反例確認 `swipeDigitalContext.invest` 存在，`offline/ask/rest` 不存在；已讀兩尺寸修正後日誌並逐張查看淺色詳細頁，四原始選項均保留，錯誤說明已消除。

另有三個已在覆審過程處理的小風險，未冒稱為已證實崩潰：

- 取消狀態後再發出不可行 request，先清除舊取消旗標，避免取消提示蓋過實際不可行原因；有純模型反例。
- 首屏補明確「左右拖卡」提示與共用想像場景註記，避免只由箭頭推測手勢或誤認為國家實景。
- 「看看處境與準備」的 44pt 改置於 Button label 內；新原生斷言實量入口 frame，點開、返回並核對檔案 SHA 不變。

## 工程核對

| 要求 | 核對結果 |
| --- | --- |
| 門檻與取消 | 95.9pt 不提交、96pt 才可提交；採最後實際位移，不用速度預測。拖回中心、無效位移與 cancel 後 release 的反例成立 |
| 垂直捲動 | 垂直先移動會鎖定該次手勢為捲動；純模型含斜向與鎖定反例，兩尺寸原生包含短水平取消、垂直捲動後正式左右滑動 |
| 防重複 | `commitRequested/saved` 拒絕新 request；CrossroadsView 另檢查當前 event/choosing；不由動畫自行決策 |
| 四條原始道路 | exact `offline/invest/ask/rest` 保留；左右映射固定；四按鈕都有正式完整 AX label，不符合此事件／四 ID 集合時回退原 UI |
| 不可行路線 | 正式 preview 的 applied 決定可選性；合成低預算測試只是明確的反例 fixture，不冒充某國真實人生 |
| 保存後才演出 | `GameStore.choose` 不變；只有 reflecting、新增同一 choice 的 applied trace 才 ack 成功。失敗保持原卡、原檔且無 chosenAction；可重試 |
| 新舊介面一致 | JPN／jpn-1／Seed 34 的真實 13-before 存檔，四選項分別比較實際磁碟存檔 SHA，原 UI／卡片 UI 相同；終止重啟後仍相同 |
| Feature Flag | 預設原 UI，可由 `-decision-ui-swipe` 或 13 歲決策方式選單切換；不寫入人生存檔，不擴到其他事件 |
| 核心保護 | 獨立執行與基底的 diff：Domain、Data、Persistence、GameStore、WorldPlayback 與原 UITests 檔案無變更；不是以未修改推定所有產品驗收通過 |

`GameStore.uiTestArchiveChecksum` 實際讀取保存檔案後 SHA256，並非只比較 ViewModel 字串。這讓四選項一致性與失敗不改檔的證據有實際持久化效應。

## 原生視覺核對

已查看 SE3 與 iPhone 17 的原 UI、卡片首屏、取消、保存失敗、四選項保存後畫面，以及深色／提高對比／最大字級／Reduce Motion 的新卡片與詳細頁。

| 可觀察項目 | 判定 | 證據／限制 |
| --- | --- | --- |
| 一般字級首屏找到四條道路 | PASS | SE3 corrected 首屏與 iPhone 17 首屏均可見，角色未裁掉；求助、休息不是藏在額外選單 |
| 紙本與線上活動不同 | PASS | 保存後分別為紙本桌面共作、電腦圖解活動；不是只換標題 |
| 求助不預演承諾 | PASS | 顯示提出需要／聆聽姿態，未出現作品完成；來源為保存後 trace，並有正式 scene label 斷言 |
| 休息不是失敗畫面 | PASS | 顯示休息場景、保留時間，未被描繪成錯誤選擇 |
| 失敗後保持原卡 | PASS | 原生警示後未進入已保存後果；重試才改變場景與檔案 |
| 最大字級可操作 | PARTIAL | 原生觸控及詳細頁往返通過，文字無橫向裁切；需要捲動，不能稱最大字級也可首屏直接完成全部決策 |
| 滑動手感比按鈕更好 | 尚未驗收 | 原生手勢測試證明可操作；截圖與自動測試不能證明孩子偏好或自然度 |

代表圖：[SE3 最終首屏](../../artifacts/evidence/reigns-card/details-corrected/iPhone-SE-3rd-generation/light/rc-first-screen.png)、[SE3 已修正詳細頁](../../artifacts/evidence/reigns-card/details-corrected/iPhone-SE-3rd-generation/light/rc-preparation-details.png)、[iPhone17 紙本後果](../../artifacts/evidence/reigns-card/final/iPhone-17/light/rc-card-offline-saved.png)、[線上後果](../../artifacts/evidence/reigns-card/final/iPhone-17/light/rc-card-invest-saved.png)、[求助後果](../../artifacts/evidence/reigns-card/final/iPhone-17/light/rc-card-ask-saved.png)、[休息後果](../../artifacts/evidence/reigns-card/final/iPhone-17/light/rc-card-rest-saved.png)、[SE3 最大字級選項](../../artifacts/evidence/reigns-card/details-corrected/iPhone-SE-3rd-generation/accessible/rc-all-actions.png)。

## 驗證紀錄與不能合併計數的批次

以下為 reviewer 獨立讀取的執行紀錄，不是 reviewer 重新啟動測試：

- Swift 全套 169 項通過；其後取消旗標窄修再跑六項模型測試，6/6 通過。不可說最後所有檔案在同一次 169 項跑完。
- Python 51 項通過。
- SE3 round1：3/4；原 UI 配對測試點到固定 footer，未保存。失敗紀錄保留。新測試 helper 改按實際 ScrollView/footer bounds 定位；沒有弱化或變更原測試套件。
- SE3 round2：四個新原生案例 4/4；最大字級定向 1/1。
- iPhone17 final：四個新原生案例 4/4；最大字級定向 1/1。
- 最後詳細頁語意／44pt 修正：`details-corrected` 兩尺寸各淺色 1/1、accessible 1/1。每批有自己的 source.json；它們是定向重測，不是四案例完整重跑。
- 原有 30 項 UI 測試檔未修改；這份報告不把上述新四案例算成原有 30 項全部通過。新 PR 遠端完整 CI 由主 Agent 交付報告另列。

紀錄入口：[test-summary](../../artifacts/evidence/reigns-card/test-summary.json)、[protected-surfaces](../../artifacts/evidence/reigns-card/protected-surfaces.json)、[SE3 round2](../../artifacts/evidence/reigns-card/round2/iPhone-SE-3rd-generation/light/test.log)、[iPhone17 final](../../artifacts/evidence/reigns-card/final/iPhone-17/light/test.log)、[SE3 最終定向](../../artifacts/evidence/reigns-card/details-corrected/iPhone-SE-3rd-generation/light/test.log)、[iPhone17 最終定向](../../artifacts/evidence/reigns-card/details-corrected/iPhone-17/light/test.log)。

## 保留的驗收缺口與 HOLD

1. 原生背景案例是在 idle 時 Home／activate；「手指拖到門檻時中斷 App」目前只有純模型 cancel→release 反例及 source guard，尚無實機中斷證據。
2. VoiceOver custom action 路徑有 source guard，四按鈕有 AX label 與原生可達性；沒有真人 VoiceOver 朗讀、焦點順序或 Switch Control 驗收。這輪也沒有新跑完整 Accessibility Audit，不能消除 PR21 已知九項 finding。
3. 取消採立即復位，保存後沿用既有 world playback；沒有完成彈簧回彈、額外離場 choreography 或整套 RC-04 動畫品質。兩側手勢與可見按鈕的誤觸率仍需人操作。
4. 本輪配對原生證據限 JPN／jpn-1／Seed 34／13 歲四選項；未重新驗收全八國每個國家、完整人生所有 UI 或 3～7 選項卡片。
5. `basic-checks.json` 的 `ok=false` 保留：`session_envelope` 92 天超過 90 天，drift 警告使基本流程未通過。沒有改日期、關閉 Gate 或聲稱 CI 全綠。
6. Owner 與 10～15 歲玩家尚未驗證：是否自然發現拖卡、能找到求助／休息、是否意外提交、能否說出自己選的行動和後果、是否更願意繼續玩。現在只支持進入這個 PoC 的試玩，不支持產品完成率或完整人生全面採用。

維持 Draft／HOLD；不得把這次 engineering ACCEPT 當成合併批准、RC-05 GO 或 RC-06 授權。
