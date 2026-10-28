# VISUAL-LOOP-02：CI 高度浮點誤差獨立覆審

結果：**PASS／APPROVED，僅限這次 UI 測試的 0.000001 pt 容差修正；沒有阻擋此窄修的已證實問題。**
原因：原始 CI 的唯一失敗是 119.99999999999997 pt 與 120 pt 的嚴格比較，差距只有約 2.84×10⁻¹⁴ pt；119.99 pt 的實質不足仍會失敗，產品布局與其餘斷言未改。
下一步：由主流程驗證修正後候選的完整 CI；本覆審不代表完整布局、實機、真人或合併驗收。

## 範圍與版本

- 日期：2026-10-28；獨立 reviewer：`/root/visual_ci_precision_review`；L1／review。
- 父流程指定 Draft PR #17、精確基底 PR #15 `81371e0`。本地實際 HEAD：`8e404a7afa33af1a4bccfd7df1afe659338a8404`。
- 審查對象：上述 HEAD 加上當時未提交的 `UITests/LifeCrossroadsUITests.swift` 五行差異：拆開原本同一行的兩個斷言、加入兩行註解、將高度比較左側加 `0.000_001`。
- 測試檔 SHA-256：`34601237b99c4805d2a4236d36b68261b2cc6a7ccae3ce88f500530be77d8cd8`。後續若測試 bytes 改變，應重新核對本結論適用範圍。
- 固定決策：確認這個浮點修正是否可繼續驗證。不是審查整個 PR 的視覺重製，也不批准合併、發布或取消 Gate。
- Reviewer 只新增本文件；未改測試、App、引擎、CI、記憶，未 commit／push，未建立或啟動 Simulator。主流程負責 canonical review 記憶。

## 原始證據與解讀

| 已直接檢查的證據 | 觀察與限制 |
| --- | --- |
| `artifacts/governance/visual-loop-02/ci/ui2/build-and-test.log:1190–1304` | `testBirthStoryWorldAndContextRemainReadableAtMaximumType` 在進入童年、暫停、跳過生活段並找到 `eventTitle`／`lifeWorldScene` 後，於原測試第 102 行失敗。實際值為 `119.99999999999997`，要求值為 `120.0`。 |
| 同 log 第 5700–5705 行 | 此分片執行 5 項、1 失敗；不是 5 項全部通過。log SHA-256：`c3ee9f3d5fe668af76a720eddbad84a5034323c3c62856706daa01599dce38bb`。 |
| `artifacts/governance/visual-loop-02/ci/ui2/LC02-20261028T034811Z.xcresult` 的 `test-results summary` 與該案例 `activities` | 獨立於文字 log 核對為 4 passed、1 failed、0 skipped；唯一 failureText 與 log 相同。裝置是 iPhone 16 Pro／iOS 18.5 Simulator。summary 的 runtimeWarnings 為空，只能說該欄位沒有記錄。 |
| xcresult 原始附件的 `19DD0E82-7D4D-4C59-9ECB-B4AFC8F2FC87.mp4` | 匯出到暫存目錄，以 AVFoundation 擷取並目視錄影末端畫面。場景可見、角色未被高度壓扁；畫面仍顯示「生活暫停了」。因此這份影片不能作為精確斷言瞬間或後續閱讀頁的目視證明。原始影片保留於 xcresult，未修改原始 artifact。 |
| `LifeCrossroads/App/CrossroadsView.swift:1103`、`:236–255` 及 `LifeCrossroads/App/LifeWorldScene.swift:18–56` | 最大 accessibility 字級明確傳入 120 pt；`worldStage` 以 `.frame(height: height)` 指定場景高度，並限制 accessibility content shape；場景內容以幾何尺寸布局、裁切。沒有產品高度改動配合測試。 |
| 當前測試 diff、`selected-tests.txt`、`.github/workflows/governance-drift.yml:13–47` | 30 個 test function 名稱及順序與 HEAD 完全相同。六個 UI 分片、非 fail-fast、每組摘要核對，以及聚合 Gate 要求全部 success 的條件均保留；App／CI／scripts 的本輪工作樹 diff 為空。 |

失敗值與 120 的差為 `2.842170943040401e-14`，等於 120 附近 Double 的 2 ULP。這支持浮點表示／座標轉換誤差的解讀，不支持畫面真的少了可見高度。**未定位 XCTest／Accessibility 內部是哪一個運算產生這 2 ULP**；程式註解所提「coordinate subtraction」是合理機制解釋，並非已追蹤到框架內部實作的事實。

## 容差與反例

已檢查的實際變更：

```swift
XCTAssertTrue(scene.exists)
// AX coordinate subtraction can report 120 pt as 119.99999999999997.
// Allow only subpixel floating-point noise; the 120 pt layout floor stays intact.
XCTAssertGreaterThanOrEqual(scene.frame.height + 0.000_001, 120)
```

產品的 120 pt 高度要求及比較右側仍保留。精確地說，測試允許約 `119.999999` 到 120 pt 之間的量測誤差；不能說數學接受集合完全不變。容差僅百萬分之一 pt，119.99 pt 的缺口是其 10,000 倍，因此不會掩蓋此級別的布局不足。

以 Python IEEE-754 double 獨立執行邊界 probe，結果如下；這是數值敏感度檢查，不是 XCTest 或 Simulator 重跑：

| 輸入高度（pt） | 原比較 `height >= 120` | 新比較 `height + 1e-6 >= 120` | 判讀 |
| --- | --- | --- | --- |
| 119.99999999999997 | false | true | 接受原始的 2 ULP 誤差 |
| 120 | true | true | 精確邊界保留 |
| 121 | true | true | 合格高度保留 |
| 119.99 | false | false | 實質不足仍失敗 |
| 119.999998 | false | false | 超過容差的不足仍失敗 |
| 0 | false | false | 空高度仍失敗 |
| NaN | false | false | 非數值仍失敗 |

未刪除 scene 存在、完整閱讀問題可點擊、休息選項可點擊、繼續人生出現等斷言，也未加 skip、expected failure、重試或放寬 CI 結果。

## Findings 與未驗證項目

- **已證實阻擋：0；數值修正 PASS。** 原始失敗與新接受條件有直接對應，未發現這個容差掩蓋真正高度不足的證據。此結論不等於已排除所有場景裁切、文字重疊或布局問題；高度本來就不是完整可讀性的充分條件。
- **WARNING／carried-forward：修正後 UI 執行尚未由 reviewer 驗證。** 原 log 在高度失敗後立刻 Tear Down，沒有執行本案例後面的 reader／rest／continue 斷言。這不阻擋窄修本身，但阻擋宣稱修正後整項測試或完整 CI 已通過。依 `governance/TESTING.md` 的結果範圍及 `REVIEW_CRITERIA.md` 的證據邊界，由主流程保存新候選 CI 結果。
- **Baseline status：Unverified by this reviewer。** 沒有重新 build 基底或候選；只讀取既存實際 CI bundle。未將基底稱作已重新驗證的穩定版本。
- 未跑 Simulator、完整 30 UI、Swift／Python 專案測試、治理檢查或實機；未驗證真人閱讀、VoiceOver、所有尺寸、正式美術、遠端新 HEAD CI、PR 狀態或合併條件。
- 未建立新 runtime、hook、validator 或治理 Gate。測試結果不擴張成產品完成率或現實體驗結論。

## 驗證與輸入

實際使用 `xcrun xcresulttool get test-results summary --path <上述 bundle> --format json`、`get test-results activities --test-id 'LifeCrossroadsUITests/testBirthStoryWorldAndContextRemainReadableAtMaximumType()'` 與 `export attachments`；讀取原始 log、指定測試及其必要布局接縫，執行上述數值 probe、測試名稱集合核對、`git diff HEAD -- LifeCrossroads .github/workflows scripts` 及 SHA-256 綁定。

已讀入 repo 的 `AGENTS.base.md`、`PLAN.md`、`docs/project-guardrails.md`、`memory/01_active_task.md`，以及 `SYSTEM_PROMPT.md`、`AGENT.md`、`TESTING.md`、`REVIEW_CRITERIA.md`、`RESPONSE_ENVELOPE_CONTRACT.md`；在 `memory/03_knowledge_base.md` 與 `memory/04_review_log.md` 定向查閱高度／AX／浮點／可讀性／CI 相關既往記錄，沒有據此重開無關核心審查。Active memory 為 89 行／9491 字元，WARNING；本 reviewer 未擴張記憶。

本文件是有界獨立工程覆審。主流程可接續既定 CI 驗證，維持 Draft／HOLD；不能據本文件宣布整個 PR、產品或發布通過。
