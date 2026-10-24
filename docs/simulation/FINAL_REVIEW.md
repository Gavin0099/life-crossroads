# GS-05／SIM-01～03 工坊切片驗收

歷史驗收記錄：本頁的三項P2與14項測試屬於上一來源版本；[本輪P2修正驗收](p2/FINAL_REVIEW.md)另附原生證據。

日期：2026-10-24。基底：main `5701a36f55ca09f1c0481c2830014db4f2611fa4`。候選分支：`codex/sim-workshop-continuity`。本文件只驗收13→15歲兩事件切片；P1八國、完整人生產品驗收及SIM-04真人動機仍未通過。

最終來源快照：[61檔SHA-256](../../artifacts/simulation/native-source-final.json)，涵蓋Domain、Data、App、素材、Xcode project及測試。雙機型均與此快照一致；基底SHA不能代替被測來源。[交付commit綁定](../../artifacts/simulation/source-binding.json)記錄逐檔核對。

**交付判定：GS-05／SIM-01～03可review的工程與視覺候選已完成；整體產品及SIM-04仍未驗收。**

## 分開判定

|Gate|狀態|證據與界線|
|---|---|---|
|GS-05共同視線／手部|PASS，候選範圍|原生圖像獨立審查；素材仍未正式核准|
|SIM-01持續狀態|工程PASS|共用LifeSession保存關係、準備事實、資源及歷史，重開後保留；損壞拒絕而不編造人生|
|SIM-02世界呈現|候選|同一工坊留有試作／清單，免費觀察；兩路不同角色／道具焦點；不是自由走動或連續年度模擬|
|SIM-03可玩延續|工程PASS|13歲team→15歲lead、help→borrow；不同可用ID、實際可執行、來源trace指向13歲選擇；不符合條件不能偽造執行|
|最終Swift|PASS：80/80|74 Domain（含9新增）＋6 Analysis；[完整log](../../artifacts/simulation/final-source-swift.log)|
|Python／清理腳本|PASS：15/15|[log](../../artifacts/simulation/python-tests.log)，含專用Simulator成功／失敗清理回歸|
|SE 3完整原生回歸|PASS：14/14|[summary](../../artifacts/simulation/narrow-final-summary.json)、[命令與裝置刪除](../../artifacts/simulation/narrow-final-run.json)|
|iPhone 17完整原生回歸|PASS：14/14|[summary](../../artifacts/simulation/standard-final-summary.json)、[命令與裝置刪除](../../artifacts/simulation/standard-final-run.json)|
|最終原生視覺覆核|候選範圍PASS：P0/P1=0|[最終SE](CRITIC_FINAL_SE.md)、[最終iPhone17](CRITIC_FINAL_STANDARD.md)，每款實看12張工坊PNG，核對37附件、5素材及61來源；各保留3項P2|
|SIM-04真人遊戲感|NOT RUN|[預先標準](GAMEPLAY_SLICE.md)；無真人結果，不宣稱有趣、重玩意願或兒少理解率|

原生14項為既有5項完整人生回歸＋9項工坊行為測試。工坊包括正式首頁進出、觀察不耗資源、兩路後續行動、圖像關閉狀態不變、重開保存、最大字級／Reduce Motion、最後免費行動可完整捲出、損壞存檔拒絕，以及既有演出圖錄。沒有刪除原完整人生測試。

兩機型的實際team／help整份JSON觀察完全相同，[路線證據](../../artifacts/simulation/route-evidence.json)保留不同未來ID、實際執行及來源。[清理收據](../../artifacts/simulation/simulator-cleanup.json)確認本輪7個專用裝置UUID均已不存在，含失敗及中止；沒有刪除其他裝置或共用runtime。[圖庫](REVIEW.md)與[總覽](../../artifacts/simulation/contact-sheet.png)均來自原生截圖。

## Trace與內容界線

每個新行動引用明列的`workshop-continuity`設計假設；15歲機會trace保留真實來源事件、選項、年齡、技能與熟悉度檢查。沒有使用國名決定路線，原統計資料沒有修改。192條四國×兩家庭×八Seeds×三起始選擇驗證保留求助／免費恢復。

原完整人生預設8～80歲15決策不變；新`DecisionTimeline`綁定獨立內容版本。舊序列化缺少排程欄位時仍可用原排程重播，跨內容版本／偽造歷史或排程被拒絕。工坊存檔是獨立試玩記錄，不等同於LC-04尚未合併的完整人生分岔存檔。

## 失敗與修正留存

- 早期測試錯把第二家庭假設為沒有支持。核對既有資料後修正測試預期，未修改國家／家庭規則來配合測試。原失敗與修正log均保留。
- 第一輪SE完整測試在固定底部入口失敗：測試helper將20pt的捲動內容邊界誤套到12pt內距的固定控制列。保留可點性與行為斷言，僅分開固定控制列的定位。原生診斷圖與log保留。
- 該輪12個方法已記錄7通過／5失敗，但Xcode卡在`collectSimulatorDiagnostics`，中止後結果包未封存；它不是可用的xcresult summary。保留文字log、原生截圖及process sample，不偽稱完整失敗結果包已可讀。後續關閉大型系統診斷，XCTest截圖／JSON仍完整保留。
- 第一個獨立審查找到兩項P1：AX5首屏角色被擠出、主CTA白／青對比約1.96:1。場景優先排列、短而明確的入口及深綠底修正後，v2原生覆核P0=0/P1=0，白字對比約8.87:1。未封頂字級、刪資訊或再縮角色。[首輪](CRITIC_SE_FOCUSED.md)、[v2](CRITIC_SE_ACCESSIBILITY.md)各自保留。
- 曾在視覺修正前中止iPhone 17回歸，該次是INTERRUPTED；裝置已刪除，不能當成最終通過。

## 剩餘限制

兩次決策不能代表整款人生模擬已有足夠深度。P2候選問題包含選項面板仍有表單感、試作橋的紙質辨識，以及觀察／兩年跳轉仍以文字補充；不再量產角色圖來掩蓋這些問題。初始綠衣成人未在圖像中具名，不將其冒充求助路線的橘色老師。

尚無真人試玩、實機、人工VoiceOver、最低iOS 17及兒少對動作／原因的理解驗證。Reduce Motion為程式路徑與可操作性回歸；靜態圖錄不能證明動畫時序或主觀演出品質。素材授權／正式選稿未完成，`approved_for_app=false`維持不變。不合併main、不發布App。
