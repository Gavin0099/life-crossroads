# PR15 CI 同步修正獨立覆核

Reviewer：`/root/pr14_independent_review`；2026-10-27。基底HEAD `1b8f5b3f574a8d7bf408d7874c868e8c5d7693e9`；本次有界覆審已綁定修正commit `3c01772169aeb294d4254325ea38e8ef44ca9f79`。

**Verdict：測試同步修正可接受；已確認的同步問題可關閉，沒有新增產品P1/P2發現。** 這不是整份新HEAD CI通過，也不解除產品Draft/HOLD。

## 原失敗與根因邊界

Root核對原run48為29/30個UI案例通過，整體CI仍失敗。Reviewer直接讀取shard3完整log、summary及失敗AX階層，確認本shard為4 PASS、1 FAIL；唯一失敗是`testLifeOverviewFocusPersistsWithoutRerollingTheVisibleEvent`舊第197行收據不存在，未自行重新稽核其他五個shard的25例。

原log在55.65秒送出continueLife，58.81秒送出focusReceiptDetails，恰跨過3秒living切換。AX已為12歲、`eventPaused|false`、兩段決策（8歲rest，10歲「請阿禾和大人一起調整碰面方式」），而測試原本只打算完成8歲決策並讀8→10安排。`WorldPlayback.swift:29,42–53`顯示pause是呈現狀態；cold resume choosing保持eventPaused但不還原pause。`WorldPlayback.swift:78–85`的living到期只切換eventPaused、回nil；`GameStore.swift:28–50`只對合法reflecting ticket呼叫continueLife，不呼叫choose。額外ask最符合XCTest在解析目標後跨版面送出座標，不是已證實的focus存讀失敗或引擎自選。

此判斷不證明真人點擊動態版面絕無誤觸；現有失敗不足以指定新的產品缺陷或改變播放／持久化契約。

## 修正差異

唯一程式差異為`UITests/LifeCrossroadsUITests.swift:173–209`，13行新增、3行刪除；提交另包含PLAN、交付文件及證據收據，沒有產品碼變更。改用startWorldPaused，cold resume後明確pause並驗狀態，rest後等待continue，略過montage後先驗child-friend／10歲／單次決策，再讀receipt。閱讀前後checksum與年齡不變；既有focus、存續玩、當下事件不重抽及receipt文案斷言保留，沒有用放寬timeout或刪斷言掩蓋失敗。

已審測試檔SHA256：`bf15d4d92527b8566404c8fbbe3879e402785e409da0df13310b1b3c6d0dad76`。

## 驗證與未主張

- Reviewer直接以`xcrun xcresulttool get test-results summary`及`tests`讀`artifacts/ios/LC02-20261027T095737Z.xcresult`：指定同一案例PASS 1/1、0 failed、0 skipped、runtimeWarnings=[]；57.313秒。與同前綴runtime-summary.json一致。
- `/tmp/lc-pr15-focus-sync-standard.log`明確顯示同案例PASS及`TEST SUCCEEDED`；最後有`Deleted test Simulator: 6C89FB4F-0B54-4E7B-812D-6D62E0134D7C`。log SHA256=`ddf43adc63043094b80865396e1c125b397efeaa38841150c5df1e5851258bb2`。Root另回報wrapper exit0；reviewer未重跑測試。
- 此定向環境為iPhone 17、iOS Simulator 27.0；原失敗CI為iPhone 16 Pro、iOS Simulator 18.5。定向通過支持此修正，不能代替新HEAD在原CI環境的全套結果。SE同案例在第一次報告時仍執行，最後已獨立核對PASS 1/1；詳見下方最終綁定。正式新HEAD CI仍待跑。
- 原失敗證據保留：`ci-ui3-artifact/build-and-test.log` SHA256=`5eea0cd37b339e58b454f141ab767489d582b66e00258f2aede605900e7b0cbc`；`ci-ui3-screens/0BB630DE-7E37-4725-B83F-85D6AE37D432.txt` SHA256=`1caa323ada9ced39b71893af2a435ebf6a4eba3b56a08f555471489a57b5e470`。未把run48改寫成成功或把前版engine140當新增完整CI證據。
- Reviewer只讀程式與原生收據，寫此ignored報告；沒有改tracked檔、建立／操作Simulator、額外啟動測試、commit/push/GitHub review或merge。既有核心完整覆審仍按`final-review.md`的來源與產品非主張邊界適用。


## 最終收據與提交綁定

- `git show 3c01772169aeb294d4254325ea38e8ef44ca9f79:UITests/LifeCrossroadsUITests.swift`重算SHA256，與已審工作樹及公開correction.json均為`bf15d4d92527b8566404c8fbbe3879e402785e409da0df13310b1b3c6d0dad76`。原106檔manifest中105檔相同，唯一差異就是這個已審測試檔；LifeCrossroads/及scripts/相對28aa189沒有任何差異。公開validation明確把原106檔綁定留在28aa189、UI修正另綁SHA，沒有把舊測試SHA冒稱當前檔案。
- 同一提交內20項公開checksums全部重算一致；standard.json、se.json與本機runtime-summary JSON結構完全相等。機器核對紀錄為`ci-sync-binding.json`。
- SE最後收據：直接讀`artifacts/ios/LC02-20261027T100036Z.xcresult`的summary及tests，確認同一指定案例PASS 1/1、0 failed、0 skipped、runtimeWarnings=[]，63.516秒；iPhone SE第3代、iOS Simulator27.0。與standard為兩次定向執行，不合併冒稱全30項。
- 兩次log均明確記錄`TEST SUCCEEDED`及`Deleted test Simulator`，ID各與xcresult／公開correction相同：standard `6C89FB4F-0B54-4E7B-812D-6D62E0134D7C`；SE `98C6889E-199B-4DBF-8179-D0A4746E95E1`。SE log `/tmp/lc-pr15-focus-sync-se.log` SHA256=`16d080a3517c7d4b73d7498568c0b6a2b9f54f3a84152abbac0c3077a34c908c`；standard log SHA見上。Reviewer據清理成功日誌確認，沒有另啟動或操作裝置。
- **最終結論：3c01772測試同步修正APPROVED，已證實的同步問題關閉，本次範圍無未解P1/P2。** 原run40478935963仍是29/30失敗；依root本輪狀態新HEAD尚未push，完整遠端CI未通過、仍待執行。核心沿用原已審來源的140 Swift／1024人生證據，本輪沒有重跑或把它重新計數。
- **剩餘Gate：** 最新提交的完整遠端CI，以及既有真人、實機／VoiceOver、台灣資料和美術驗收。維持Draft/HOLD，不合併；局部修正完成不等於整體產品90–95%或發布驗收。Reviewer僅更新ignored覆審與綁定紀錄，未修改產品／測試／共享記憶，未額外執行測試。
