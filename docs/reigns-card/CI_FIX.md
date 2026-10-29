# PR24 CI修正與實機驗收準備

Owner對5c20fa7的版型判定為CONDITIONAL ACCEPT，未批准完整人生擴充。本片只處理新發現的CI失敗與Wi-Fi安裝準備，正式App、Domain、資料、存檔及52事件不變。

## 失敗的實際意義

Reigns card PoC #2 / run40816153774並非摘要缺失。從保留artifact12872962362取得原始xcresult，SHA核對為`2a6822b8c3e19d31e76848eb76fdd1925600cef6101c0f2c62f38aaa2c21411d`，所有來源檔digest與5c20fa7一致。

iOS18.5 / iPhone16Pro執行7項，6過1失敗，無跳過。失敗發生在`testFailedSaveBackgroundModeSwitchAndRetryPreserveOriginal`第一次按遊戲選單：AX知道按鈕frame=(346,66,44,44)，卻回報點擊位置{-1,-1}並失敗。四種配對保存與冷恢復、實際滑動、正常結果與分岔停留等其餘六項通過。這是已知發生點；未證明是真人觸控或VoiceOver也故障，亦不以重跑推定偶發。

`check-ios-runtime.py`當時在保存summary之前拒絕非Passed結果，造成外層訊息籠統，讓失敗摘要沒有跟隨匯出的50張圖一起保存。

## 修正

- Menu測試採按鈕真實frame中心的原生觸碰，仍要求目標選單展開、實際切換UI、存檔checksum不變、保存失敗原檔不變、重試及結果正確。沒有直接呼叫store或繞過實際選單。
- 新全螢幕HUD仍驗證44pt。舊介面使用系統導航列，其測得frame42pt；本片不把新HUD規格錯套舊介面，也不宣稱舊介面通過44pt驗收。
- runtime檢查先保存實際JSON，再套原有Passed＋已執行測試的門檻；失敗時列出result／passed／failed／skipped。失敗不會因有截圖而放行。

## 本機驗證及限制

- 54項Python全套通過。新增回歸以實際CI的6過1失敗為依據，驗證exit1及失敗summary確實落盤；另驗證Passed、未完成、零執行與畸形摘要。原來的拒絕門檻及SwiftUI警告檢查保留。
- 第一次54項跑完有1個既有錯誤訊息相容性測試失敗；保留原訊息前綴後54/54。未刪除或放寬該測試。
- 新helper首輪0/1：對舊導航列42pt誤套新HUD44pt。分清契約後，iPhone16Pro / iOS27.1定向1/1，兩次本輪建立的Simulator均已delete。
- 本機沒有iOS18.5 runtime；同環境的修正判斷必須等待新HEAD遠端CI，不把iOS27.1當作iOS18.5重現證據。原169 Swift／雙尺寸全螢幕批次仍屬5c20fa7歷史證據，本片不冒稱重新執行。
- 正式App程式無差異，已重新建置開發簽署iPhone版本並通過codesign驗證；這不是已安裝或真人驗收。更新時不清除App資料、不注入測試fixture。

原始失敗摘要與日誌：`artifacts/evidence/reigns-ci-fix/failed-summary.json`、`failed-native-test.log`；來源核對：`failed-source-verification.json`。原始ZIP／xcresult本機保留，不將322MB重複附件加入Git。新CI狀態以PR24當前HEAD的checks與PR說明為準。

Basic既有session_envelope 92/90期限finding仍保留。iOS18.5的Menu無障礙命中問題與人工VoiceOver需實機走讀，座標觸碰測試不等於已通過VoiceOver。17歲仍為舊介面，未授權RC03～06；Draft/HOLD，不合併發布。
