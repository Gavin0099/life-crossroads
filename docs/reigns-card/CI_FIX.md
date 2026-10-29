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

## 第二個遠端結果與總時限

677da55的Reigns CI #3（run40821317695）已在iOS18.5完成一般模式7/7、failed0、skipped0；原本Menu案例用真實觸碰及實際切換通過。raw summary、全部一般test.log與source保留在本片`ci3/`。這證明特定Menu測試失敗已排除。

但整體工作在20分鐘上限附近取消：一般批次於05:24匯出58張圖，大字案例進到按「繼續生活」後等待下一階段，05:25:25工作取消，沒有完整的大字summary。因此#3整體不是PASS。保留這個界線，不用7/7推導全部工作通過。

將工作總時限20→25分鐘，給冷啟／build／兩種模式／附件保留足夠時間，所有7＋1案例、逐項斷言與失敗門檻不變。另加`if: always()`的外層清理，僅讀本次capture寫入的device.txt，驗證UUID後刪除仍存在的專用裝置；已刪則記錄alreadyAbsent。#3取消後的原日誌未見delete收據，不能宣稱已驗證該次明確刪除；外層備援避免只依賴被取消shell的trap。

備援清理包含三個正反測試：只刪記錄裝置並保存收據、已刪不碰其他裝置、畸形紀錄在任何裝置操作前拒絕。後續全套57/57 Python通過；實際呼叫本機已刪裝置紀錄，確認alreadyAbsent並保留其他裝置。本次本機兩台專用Simulator均已delete，未操作別的裝置或共用runtime。
