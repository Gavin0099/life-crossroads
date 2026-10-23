# PR #5 W1／W2 有界差異覆核

**Verdict：APPROVED；已證實新增阻擋項 0。**
審查綁定產品提交 `1226fb2fc2a1fc778b67fed8dd2b6556243a3138`，前次已審查基準為 `2f030d2f646dc0c7bcb08c39b57c55bb09bf09c4`。本次只覆核 W1／W2 的補強，不重新審查未變更的引擎。此技術結論不是遠端 CI 成功或合併已完成的聲明；後續 companion 若不變更產品 bytes，可再作限定綁定確認。

## Review Inputs Checked

- 前次獨立審查 `artifacts/governance/lc04-independent-review/review.md/.json`。
- `PLAN.md`、`docs/project-guardrails.md`、`memory/01_active_task.md`；既有 REVIEW_CRITERIA／TESTING／AGENT／ARCHITECTURE／SYSTEM_PROMPT／RESPONSE_ENVELOPE 已於同一 reviewer context 載入，本輪另讀 `SOLO_OWNER_MERGE_AUTHORITY_CONTRACT.md`。
- `2f030d2..1226fb2` 的四個 Swift 檔、`docs/lc04-w12-followup.md`；必要接縫為既有 GameStore commit 和 alert。
- 父作者執行的真實定向 UI 日誌、XCResult summary、16項 focused Swift 與15項 Python 日誌；本 reviewer 沒有重跑 Simulator。
- 四個 Swift 檔提交 bytes 均與首次差異覆核的 SHA-256 相同；docs 僅追加實際結果、殘餘範圍和 runtime warning，已重新讀取。詳 `product-head-bindings.json`。

## Frozen Decision Boundary

- Owner request：只補 W1／W2，最新 CI 通過後由父工作線合併 PR #5；本子 reviewer 不 commit／push／merge、不寫 memory。
- DONE：確認新 UI 內容斷言確實防止兩路錯接，保存失敗注入確實經 GameStore catch，實際檔案 SHA 與 retry／relaunch 受測，正式裝置排除本次故障注入及校驗畫面。
- Claim ceiling：有界工程驗收；不宣稱所有 iOS 檔案故障、啟動壞檔 UI、分岔 picker 錯誤提示、實機、VoiceOver、兒少或 P1 通過。
- Review boundary：四個 Swift 檔與跟隨文件；未變的 Domain、Persistence、事件/圖片內容不重啟整輪資格認證。

## W1：已關閉本輪要求的 UI 內容核對缺口

位置：`UITests/LifeCrossroadsUITests.swift:213-235,243-269,323-359`；`CrossroadsView.swift:386-392,475-483`；`BranchViews.swift:85-109`。

測試在尚未分岔時從實際選擇回饋保存事件文字/ID、行動文字/ID及選前/選後四項資源，沒有再次呼叫 production engine 產生 expected。13歲分岔後明確確認原/替代的 choice ID 與 resources 不同。分岔後及替代局完成重啟後，都核對保留原局的8／32／80歲；完整比較頁另外核對13／32／80歲兩側的內容。新增 accessibility identifiers 和 values 綁定既有顯示用 trace，沒有新增模擬邏輯。

斷言敏感度的程式推理：若把比較的 original 接成 alternative，13歲 invest/offline 與資源不同會讓內容斷言失敗；若把原局視圖接成未完成 alternative，原局32／80歲資料不存在亦會失敗。此為可檢查的敏感度推理，加上實際 UI 通過證據；本輪沒有執行 mutation testing，故不宣稱已跑 mutant。

Status：resolved（限定此 UI 內容核對項）；原 W1 severity WARNING 保留歷史，不升格為曾有產品資料毀損。

## W2：已關閉選擇／繼續的保存失敗接線缺口

位置：`GameStore.swift:29-37,46-50,82-92`；`CrossroadsView.swift:42-47`；`UITests/LifeCrossroadsUITests.swift:279-312,362-372`。

- fault set 僅在 Simulator 編譯，且必須同時有 `-ui-testing` 與 `-ui-fail-save-at` 才填入。正常啟動 set 為空。
- 注入是在正式 `commit` 的 do 區塊內拋出 `fileWriteNoPermission`，先於 `saves.save` 和 `journey = next`；會進入同一個 catch，設定真實 errorMessage，沒有測試專用假的 alert。
- 第2次（choose）及第4次（continue）保存失敗後，UI 分別留在原事件及回饋；沒有發布尚未保存的 next。一次消耗 fault 後，重按相同操作成功。
- SHA-256 的來源是 `Data(contentsOf: saves.fileURL)`，非 in-memory journey 的編碼或固定值。讀不到時回傳 missing，測試的64字元斷言會失敗。兩次失敗各比對檔案 SHA 保持；兩次成功 retry 各比對 SHA 改變，重啟後再比對已讀回的進度與最後 SHA。
- 新故障欄位、參數解析、throw、checksum getter／CryptoKit import及畫面都在 `#if targetEnvironment(simulator)`；正式 device target 的編譯條件排除這些新增入口。這是程式級編譯條件查核，不是本輪實機建置／操作證據。先前就有的 ui-testing filename/reset 行為不在「本次新 hook 已排除」的宣稱內。

敏感度推理：移除 fault/catch 將使 alert 斷言失敗；提早發布 next 將使 phase/畫面斷言失敗；提早覆寫檔案將使 checksum 不變斷言失敗；不消耗 fault 將使 retry 斷言失敗。沒有實際修改原始碼執行 mutation。

Status：resolved（限定 common commit 的 choose／continue 失敗與恢復）。W2原本提及的啟動損壞/版本不相容 UI、fork-picker寫入失敗提示仍屬明示未覆蓋部分，沒有聲稱 W2 的所有可能 UX 都實測過。前輪真實唯讀目錄 replacement failure probe與本輪注入分別支持 filesystem及App catch層，沒有互相替代。

## 非阻擋觀察 R1：錯誤提示關閉時出現 runtime warning

- Severity：WARNING（REVIEW_CRITERIA）。
- 觀察位置：`artifacts/governance/lc04-w12-ios.log:2423`，W2第一次「知道了」點擊後；`artifacts/evidence/lc04-w12/ios-summary.json`記錄同一項警告。
- 原文：`Publishing changes from within view updates is not allowed, this will cause undefined behavior.`
- 相關程式位置：`CrossroadsView.swift:109-110` 的 alert Binding setter及按鈕 action，與 `2f030d2` 的103-104行逐字相同。新增checksum getter只讀檔，沒有發布 ObservableObject 狀態。
- Attribution：exposed（新測試暴露）；這不等於已證實 alert 的哪一行是根因。日誌沒有可用來源位置/stack，本輪不能證明根因、已存在的警告頻率或所有後果。
- Trigger：第一次保存失敗提示被關閉；當輪 warning 後的 phase、原資料 checksum、成功 retry及relaunch斷言全部通過。
- Impact：已觀察到 SwiftUI 不允許的發布時機警告；尚未觀察到本輪契約的畫面或資料失敗。不可宣稱零警告或問題已修復。
- Current-decision impact：no。此次差異未增加 view-update 中的 Published 寫入，且實際受測 failure/retry 狀態保持；沒有足以認定本輪新增 correctness defect或推翻兩項驗收的證據。
- Status：open；Disposition：carried-forward。
- 建議：於後續 UI 錯誤提示維護時，用可定位的 runtime issue stack／定向重現隔離發布來源；若觀察到狀態錯亂、提示循環或資料變動，再據實升級。這項建議不啟動本輪額外工作。
- Rule reference：TESTING §4.3；REVIEW_CRITERIA §2.1、§2.2、§3.4。

## 驗證與提交綁定

- 父工作線執行 `bash artifacts/evidence/lc04-w12/run-focused-ios.sh`：兩項通過。W1 436.604秒；W2 41.811秒；XCResult為 passedTests=2、failedTests=0、runtimeWarnings=1。
- W2實際三個成功狀態的檔案SHA：
  - start：`b4f200464b98a682fcf739326f8795c3991447f5a9df6b82c73ffbaa84a6b6dd`
  - retry choice：`1a3ddd0ec7ad3e1ccfdb75541f327084cd39fd3fb1ad6b166ba910b28845b37c`
  - retry continue／relaunch：`66e4d1d15590c351c3f6e89cfc0171382958149dfd51606283546227c7261a2e`
- 實際日誌含 `Deleted test Simulator: FDF71D90-D924-4B1A-B23D-02ECE0938A76`；本 reviewer 建立裝置數為0。
- 本輪父工作線16項focused Swift、15項Python均通過；reviewer直接讀取原始日誌與提交後摘要，不把它們當成兩項新UI斷言的替代證據。
- `git diff --check`通過。四個Swift的SHA與產品提交完全相同；docs已讀最終補充。產品提交後僅有預期的canonical memory工作目錄變更，沒有混入本次review修改。
- 此報告不聲稱 `1226fb2` 或尚未建立的companion遠端CI已完成；最終候選仍須同HEAD綠燈及完整merge predicates，父工作線負責確認。
- 已證實新增 blockers：0。未更改產品／memory；沒有commit、push、merge或外部review訊息。

## 保留的後續驗收

啟動壞檔 UI、fork-picker保存失敗提示、分岔頁最大字級、人工VoiceOver、實機、兒少理解及節奏均未升級為已完成。本輪未重審既定後續slice，也未要求為這些已明列的界線擴張補強範圍。

