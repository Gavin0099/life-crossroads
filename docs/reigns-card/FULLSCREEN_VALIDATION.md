# RC-FULLSCREEN-01 驗證邊界

本輪直接修正 PR24 的 Owner PRODUCT REJECT。原始基底 `225c2828f4ea56c8ae5eb89a414ac506808b6374`，保留原模型；只改13歲選前與已保存結果的呈現。其他51個事件不擴充。

## 改動

- 一般字級預設全螢幕單卡，沒有整頁 ScrollView 或大導航列。HUD、兩行內提示、主場景、求助／休息／全部行動形成固定版型。
- 主卡由獨立背景與保留原比例的角色／活動圖層構成。紙本場景有專用的桌側構圖，沒有將原180pt橫圖整張拉長。未新增或修改任何美術位元圖。
- 成功保存才讀 `ProjectMoment`、`WorldCastScene`、`WorldActivity`；求助僅表達需要，未將老師出現說成答應協助。所有結果留在同一舞台，由玩家明確繼續。
- 大字及 VoiceOver 走可捲動完整按鈕；文字自然高度，場景獨立220pt。Reduce Motion不改故事／保存結果。實際VoiceOver人工走讀另列缺口。
- 原 `DecisionCardModel`、Domain、Data、Persistence、GameStore、Presentation、圖集、schema及Seed未變。原30個UI案例僅明確指定原介面作rollback回歸，沒有刪斷言或放寬；本輪新案例使用無opt-in的正式新預設。

## 工程證據

純Swift169個不同案例、Python51項通過，見 `test-summary.json` 及原始log。這批執行於本輪首次UI重構之後；後續變動僅App佈局／呈現暫停與原生測試，不冒稱為最後一次全部重跑。原模型的門檻／方向、取消、重複提交、不可行選項防繞過仍由既有6項測試保護。

最終原生批次與來源以 `artifacts/evidence/reigns-fullscreen/evidence-verification.json` 為準；包含兩種硬體一般模式7項及accessible1項。這是7個不同新UI案例在兩尺寸重複驗證，不能稱為16個不同案例，也不能加上前面失敗批次稱為單次全過。

| 最終硬體 | 一般模式 | 最大字級／深色／高對比／Reduce Motion | 主卡／整窗高度 |
|---|---|---|---|
| iPhone SE3 | 7/7 | 1/1 | 523/667 = 78.4% |
| iPhone17 | 7/7 | 1/1 | 654/874 = 74.8% |

機讀核對保留63張代表性native PNG、獨立held-preview收據、來源SHA與四條配對存檔；六台本輪裝置已delete。重複的成功前置截圖以 `historical-retention.json` / `final-retention.json` 留完整匯出SHA與取捨，不將刪除的重複PNG當作遠端交付；失敗圖、盲讀A–E、完整測試log／source／runtime summary均保留。

7項分別驗證：
1. 四種選擇分別與原UI保存位元組相同，且冷恢復一致。
2. 真正左右拖曳、短拖取消及垂直動作不提交。
3. 寫入失敗原檔不變、未演出結果、模式切換／背景恢復與重試。
4. 預設版型、卡片比例、四個完整按鈕可達、數位提示只給真正數位選項、返回與明確續行。
5. 持續按住的左右預覽，釋放未達門檻不改檔；原生畫面另由simctl同步取證。
6. 移除capture／fixture注入後，正常選擇保存結果超過原2秒區間仍不自動離場。
7. 結束真實原人生，冷啟正常模式，再從13歲建立分岔；結果同樣保留到明確繼續。

第6／7項針對獨立Reviewer指出「截圖模式自帶暫停」的證據盲點；不是用測試暫停冒充正式行為。兩條路徑保存前後checksum有觀察斷言。

原生紀錄沒有匹配到SwiftUI view-update publication runtime warning；此結論只涵蓋實際執行的批次。全頁bounding boxes與scene-only盲辨分開判定。卡片比例另外用整個視窗高度作保守分母，不能用裁切場景圖證明全螢幕。

## 失敗、限制與狀態

- 歷史失敗／修正保留在 [Before／After](FULLSCREEN_BEFORE_AFTER.md)，包含工具重複產品、sheet查詢、紙本遮臉及最大字級截斷。
- 本機Basic仍exit1：5項PASS、drift WARN，既有 `session_envelope` 92天超90天。raw `basic/checks.json`、`basic/drift.log`保留；未更改日期、框架或關Gate。
- PR21原有9項native accessibility finding不由本片宣稱清除。
- 當前提交的遠端CI以 [PR24 checks](https://github.com/Gavin0099/life-crossroads/pull/24/checks) 及PR說明最後查核為準；本機 `ci-status.json` 保留查核快照，不為加入CI回報而改變受測HEAD。之前225c282的成功run不算新版證據。
- 所有本任務建立的Simulator都須delete；最後inventory及每批device.txt由verify-fullscreen.py核對。其餘原有裝置、共用runtime不動。
- 尚未驗收：Owner版型偏好、真人VoiceOver、實機、兒少發現操作／誤滑／重玩、拖曳保持期間進入背景的原生手勢測試。閒置狀態背景恢復與純模型中斷已有證據，兩者不混稱。

Draft／HOLD。只交13歲PoC看圖與試玩，不合併、發布、安裝手機、不啟動RC03～06。
