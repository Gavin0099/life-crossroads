# RNG-01～04 獨立修補審查

2026-10-23；審查者 `/root/gameplay_qa`，與實作者分工。審查分支 `codex/rng-event-director`，基底 `ad773f9b450612fe58513b5ce54d538b7cc0f215`；以下核對的是提交前工作目錄的修補差異，不是宣稱基底已包含修補。

**判斷：APPROVED，限本次已重現缺陷及其修補差異可供工程 review。** 原四項缺陷及複查發現的救援選項投影問題均已修正；本次範圍內未確認新的未解阻塞。這不是整個子系統無缺陷、合併、兒少驗收或發布批准。

## 審查邊界與輸入

依 [設計契約](design.md)、[批次不變量](batch-contract.md) 與 repo 的 `AGENT`、`ARCHITECTURE`、`TESTING`、`REVIEW_CRITERIA`、既有 review log／knowledge base，檢查 `EventCatalog.validate`、故事投影、延遲回應來源、`DirectedLifeSession.restore` 及對應測試。目的為確認原失敗輸入被正確拒絕或可正常執行，並保持純 Swift Domain 與 UI／I/O 分離。

沒有重新審查無關子系統或擴張完整內容資格認證；未修改 Domain 或測試。本審查只新增此文件。

## 已修正的發現

各項沿用首輪 **P2**，狀態均為 **resolved**，處置為本輪修正；對目前有限工程 review 不再構成阻擋。

| 問題與歸因 | 修補核對 | 定向證據 |
|---|---|---|
| 新增 catalog 驗證只保證休息，缺少無材料求助（introduced） | `EventDirector.swift:66` 要求適齡、離線、材料 0、無條件限制，且時間／精力在可用家庭與年齡階段的額度內。 | `testCatalogRejectsMissingOrUnaffordableOrAgeUnsafeSupport`；外部 probe 再跑「缺 ask」與「ask 材料費 1」均被拒絕。低資源／零材料正常人生另有既有測試。 |
| 分岔人物的延遲回應與原定義不一致（exposed in directed path） | `DecisionResolver.swift:164` 保存選前資源；`LifeState.swift:117` 以來源前決策歷史、來源年齡與資源重新投影，核對完整 hook，沒有放寬人物或文字驗證。 | `testDelayedCallbackKeepsProjectedPersonAndSurvivesRestore`；USA／usa-1／Seed 42 的阿禾重逢回應原重現路徑可完成。額外竄改已觸發 hook 的 `originResourcesBefore.health` 後，`restore` 拒絕重播不一致。 |
| 100 歲新回應到期日等於當下（exposed by directed age window） | `EventDirector.swift:78` 拒絕在實際 100 歲槽年齡窗內含新延遲回應的定義；不偷偷刪回應或立即給效果。 | `testTerminalAgeCannotSchedulePastFutureButNinetyNineCanReachOneHundred` 同時驗證 100 歲拒絕、99 歲到 100 歲仍可觸發；外部原重現輸入現在被拒絕。 |
| 家庭條件共用錯誤上限（introduced） | `EventDirector.swift:18` 區分材料額度 0～4，交通、照顧、陪伴 0～2。 | `testCatalogRejectsInvalidDefinitionsAndUnsafeRecoveryRestrictions` 含陪伴 3～4 拒絕及材料 3～4 接受；外部陪伴錯誤門檻 probe 現在被拒絕。 |
| 定義中的救援選項仍被故事投影移除（exposed by recovery fix） | `StoryBranchEngine.swift:29` 列出既有條件式選項身分，catalog 不把它們計為保證求助／休息；原本故事投影行為保持。 | `testStoryGatedChoicesCannotBeTheOnlyGuaranteedRecoveryRoute` 覆蓋兩組事件／選項 × 求助／休息。原 probe 將唯一求助放在 `teen-direction/leadWorkshop`，現在於 catalog 驗證拒絕。 |

另核對 Root 提出的結尾存檔越界修補：`DirectedLifeSession.swift:110` 在使用槽索引前要求 choosing 的已完成數嚴格小於槽數，回歸測試涵蓋竄改已結束存檔。歷史年齡也先驗 0～100，再做冷卻相減。

## 證據與限制

- 本 reviewer 實際重新執行上述最小外部 probes；以當前 Debug library 連結，沒有重寫 production 狀態機。來源為首輪已重現輸入與契約，未把實作當成預期值。
- 檢視實作者提供的最後一次 `swift test` 日誌：70 tests、0 failures，含新投影回歸。本 reviewer 未重跑完整 1,024 人生批次；批次與來源版本的最終對應以 [validation-manifest.json](../../artifacts/rng/validation-manifest.json) 及其引用證據為準。69 tests／先前批次不能直接冒充最後修補版本的執行證據。
- `originResourcesBefore` 是待驗證的存檔資料；單獨 `LifeState.validate` 的欄位與來源形狀核對不等於完整歷史真實性。儲存邊界仍須使用 `DirectedLifeSession.restore`／完整重播，不只 `JSONDecoder.decode`。
- 沒有測試無限多種 catalog 組合，沒有證明所有未來故事條件都可達；新增會移除選項的故事分岔時須維持救援分類及回歸測試一致。
- 未啟動 Simulator，沒有實機、兒少試玩、正式持久化、授權或發布驗收；legacy 模式與新 directed 模式的能力不可互相代稱。

本次修補審查的關鍵來源 SHA-256（後續來源異動應重新判斷受影響範圍）：

```text
EventDirector.swift          c431ba4f095109d7fd7395106dd21e28acc4ababffdd324e07498fdc488ae5e8
LifeState.swift              94a9db2c50a91b7522b70ad068036f506662493d43a861ecb5d9d63d05fb9f11
DecisionResolver.swift       724a63677c717bddddc43503e8a101fa24eaaedbacbbfe48df2f98a4e0f8a918
StoryBranchEngine.swift      0d7646720d29c91e108166ef0d41538300dbe6ef4a07447c0d4070fa0a2f23af
EventDirectorTests.swift     36ea3431db4775dae25424a3daadf91bdff9eba40fcd137a52494cd7b0bf609b
```
