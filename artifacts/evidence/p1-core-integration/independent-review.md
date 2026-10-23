# PR #1～#4 核心整合：獨立技術覆核

日期：2026-10-23。審查者：`/root/core_merge_review`，本輪受主 Agent 委派的獨立技術覆核 Agent。

本審查者未參與這四個候選提交的實作、修正或測試撰寫。本輪只讀 Git 固定提交、GitHub GET API、現存測試與證據；唯一寫入為本報告。未建立 GitHub Review、未關閉 thread、未改碼、未合併。主 Agent 另負責本輪整合測試與合併操作。

## Review Inputs Checked

- `AGENTS.md`、`AGENTS.base.md`、`PLAN.md`、`docs/project-guardrails.md`。
- `governance/SYSTEM_PROMPT.md`、`AGENT.md`、`ARCHITECTURE.md`、`TESTING.md`、`REVIEW_CRITERIA.md`、`SOLO_OWNER_MERGE_AUTHORITY_CONTRACT.md`；`RESPONSE_ENVELOPE_CONTRACT.md` 的報告／宣稱界線。
- `memory/01_active_task.md`、`02_workflow.md`、`03_knowledge_base.md`、`04_review_log.md`。
- ADR 0001 純 Swift／資料載入邊界、ADR 0002 分析層只消費正式引擎。
- GitHub PR 1～4 的當前 metadata、全部 review submissions、inline comments，以及各指定 HEAD 的 Actions run／jobs。
- 指定提交中的模型生成器、環境 resolver、trace、LifeSession、StoryBranchEngine、StoryMemory、EventSelector、EventPolicy、GameStore、PR #2 第二輪 UI／腳本 delta、相應 regression tests、RNG-V2 比較報告及既有執行收據。

## [Decision Summary]

**Verdict：四個指定 HEAD 分別 APPROVED，限工程整合進開發基線。Risk Level：High／L2。**

未發現阻擋這次開發基線決策的未修復程式缺陷。原有資料／因果／比較問題已有實際修正，PR #2 後續差異也已補完獨立覆核。此結論保留已知產品與量測問題，並不把它們描述成修復完成。

| PR | 本輪 exact HEAD | 技術 verdict | 既有獨立 review | 本輪核對的相同 HEAD CI |
| --- | --- | --- | --- | --- |
| #1 | `ae3253bc0d9f6227550e0c06bccf2bdc0f8312e2` | APPROVED | 5625730002，直接綁同 HEAD | [39916351265](https://github.com/Gavin0099/life-crossroads/actions/runs/39916351265)，3 jobs success |
| #2 | `ad773f9b450612fe58513b5ce54d538b7cc0f215` | APPROVED | 5625730424 綁 `93e0418e7f6bf65f254a2a5b4369b41ea0a4566e`；本輪覆核其後六筆提交 | [39928709460](https://github.com/Gavin0099/life-crossroads/actions/runs/39928709460)，4 jobs success |
| #3 | `4f268b8d195c212ab32da5c7471016b9f9646b9f` | APPROVED | 5626995543，直接綁同 HEAD | [39935525025](https://github.com/Gavin0099/life-crossroads/actions/runs/39935525025)，4 jobs success |
| #4 | `c05ee5143f8f6b56ff0d71507e2c3f0580c84166` | APPROVED | 5628794428，直接綁同 HEAD | [39956496533](https://github.com/Gavin0099/life-crossroads/actions/runs/39956496533)，4 jobs success |

以上是 `independent_approved_for_exact_head` 的技術審查證據；**不是單獨的 `merge_decision=eligible` 宣告**。主 Agent 仍須保存 owner 對 exact head／immutable range 的合併授權、確認實際 required checks、整合測試、retarget 後 CI 及候選 HEAD 未變。完整 runtime governance audit 繼續為 advisory。

## Frozen Decision Boundary

- Current owner decision：依序整合 PR #1→#4 至 `main`，形成共同開發基線；保留 commit ancestry，不合併獨立 Visual 分支。
- DONE：指定候選鏈具可核對的修復、可重播引擎、可用完整人生 UI 及相應工程證據；本輪整合測試及 merge authority 由主 Agent 完成。
- Claim ceiling：可繼續開發的工程原型。不是 P1 完成、正式發布、八國可玩、50～70 事件、LC-04 完整改選、SwiftData 存檔、實機、人工 VoiceOver 或兒少娛樂／教育效果通過。
- Review boundary：四個固定候選及其必要語意影響面；PR #2 從已審 `93e0418` 到 `ad773f9` 的 delta 為額外重點。沒有重新認證整個治理框架或外部統計授權。
- Dirty worktree：開始時已有 PLAN、治理 baseline、審查文件及 memory 的本機未提交同步；本審查不將其算入任何候選 HEAD。`git diff --name-only c05ee51 -- LifeCrossroads Tests UITests scripts Package.swift .github` 無差異。

## Ancestry 與候選保全

以 `git merge-base --is-ancestor` 驗證各步皆為 true：

```text
7f34f784d2ed5ca946b6302bae3bea0dc51683e4
  → ae3253bc0d9f6227550e0c06bccf2bdc0f8312e2  (4 commits)
  → ad773f9b450612fe58513b5ce54d538b7cc0f215  (12 commits)
  → 4f268b8d195c212ab32da5c7471016b9f9646b9f  (4 commits)
  → c05ee5143f8f6b56ff0d71507e2c3f0580c84166  (3 commits)
```

GitHub 查讀時四個 PR 仍 open、unmerged；#2～#4 為 Draft。各 head/base SHA 與上述鏈一致。這支持保留 ancestry 的逐個合併；不需要把 #4 squash 成失去前面審查 ancestry 的單筆提交。若後續發生實質程式變更，本報告不自動批准新 HEAD。

## 已解決的舊 Review threads

下列「可關閉」是程式／測試核對結果；本審查者沒有執行 thread resolution。

| 原項目／來源 severity | 修復與回歸證據（行號屬指定 HEAD） | 狀態／本次決策影響 |
| --- | --- | --- |
| PR #1 國家排序健康，P2；comments 4356624392、4356928205 | `ae3253b:scripts/build-data.py:120-129` 從 `FAMILY_SCENARIOS` 讀資源；明示兩模板 66／64。`Tests/test_data_generation.py` 重排 COUNTRIES 並比較完整 household initialResources；具名模板預期值獨立固定。 | resolved；impact no；可關閉 |
| PR #1 所有 learn 被當數位需求，P1；comment 4356928198 | `ae3253b:scripts/build-data.py:159,168-172` 僅四個明確數位事件的 invest 需連網，並提供 offline。`DecisionResolver.swift:53-70` 依逐選項欄位分流；`LC01Tests.swift:35-67` 驗證離線不受國家數位門檻影響、8 歲四國均可行、獨立紙本路線。 | resolved；impact no；可關閉 |
| PR #2 固定列出四因素，P1；comment 4356928537 | `ad773f9:ConsequenceTrace.swift:87-102` 僅列 applied、非零因素並排除未觸發 randomness；`CrossroadsView.swift:337` 使用 influenceSummary。`LifeSessionTests.swift:96-122` 明確檢查 rest 僅 playerChoice、失敗 randomTrial 不算原因。 | resolved；impact no；可關閉 |
| PR #2 固定 compare invest／家庭位置配對，P2；comment 4356928544 | `ad773f9:GameStore.swift:58-61` 傳 choiceID；`LifeSession.swift:50-60` 以 templateID 和 hasSameConditions 配對。`LifeSessionTests.swift:125-135` 以重排家庭及 rest 驗證，缺資料背景拒絕。c05ee51 仍保留，另有選後比較使用選前 session。 | resolved；impact no；可關閉 |

規則依據：產品「國家與家庭分離／離線途徑／僅從實際 trace 解釋」契約；`REVIEW_CRITERIA.md` §2.2 要求修正 delta 與必要影響面覆核。以上舊問題均為 pre-existing，現在 resolved；不是以改標 severity 解除阻擋。

## PR #2：93e0418 → ad773f9 的補充覆核

覆核六筆：`4e5b833`、`6e4168c`、`8942c5a`、`cc79fa1`、`e9a4071`、`ad773f9`。

1. `CrossroadsView.swift:249-261` 明說時間／精力／材料僅當回合且不累積，四項資源與選擇歷史延續。新增 `testRoundAllowancesResetWhileResourcesAndChoicesContinue` 比較 invest/rest 的既定預算與下一回合 reset，符合實際引擎。
2. `CrossroadsView.swift:368-383,451-460` 比較 finalCost 與 applied，只有實際一致才顯示「成本與可行性相同」，引導 13 歲線上／紙本；未改數值強製造差異。
3. `StoryVisuals.swift:100-193` 新增國家觀察值、年份、來源及授權，區分全國人口比例、虛構家庭與寓言舞台；缺值明示未知。兩個 a11y 修正將父容器識別碼與獨立文字解耦。
4. `scripts/ios-check.sh:5-57` 既有 UDID 只作裝置規格參照，實際測試新建獨立裝置；EXIT／INT／TERM 走 owned UUID 的 shutdown＋delete，delete 失敗保留非零退出碼；不刪其他裝置/runtime。`Tests/test_simulator_cleanup.py` 覆蓋成功、build 失敗、delete 失敗、非法配置及無既有裝置時顯式硬體配置。這不宣稱 SIGKILL／系統中斷能執行 shell trap。
5. UI 測試檢查完整人生、8 歲相同成本、13 歲數位不同／紙本相同與不累積文案；reveal 改短距離捲動以避免高卡片被跨過，未移除最終可點選 assertion。`.github/workflows/governance-drift.yml` 擴大 Python discover 至所有 test_*.py。
6. `pr2-round2-ui-acceptance.json` exit 0 綁 `e9a4071`；該提交至 `ad773f9` 只含文件／記憶／證據，無產品或測試可執行碼差異。另有 `ad773f9` 的完整遠端 CI 成功。

沒有發現此 delta 引入新的數值／因果規則或破壞既有故事分岔。

## PR #3／#4 核心整合核對

- `EventSelector.swift:79-167` 先驗證 catalog/state，逐候選保留條件、排除理由、權重、獨立鍵、open-interval uniform 與 score；穩定 ID 排序及 tie-break，無國名倍率。
- `EventPolicy.swift:31-80` 限制有限正權重、故事值／人物／resource key，並保證每時點有尚未提前使用的無條件 fallback（minimumAge 等於該時點）及五個固定里程碑。`Models.swift:291-295` 要求免費 rest。
- `DecisionResolver.swift:35-46,94-109` 拒絕未選事件、未解鎖選項與不符年齡／預算；`LifeSession.swift:88-113` 只有成功結果才更新狀態。
- `LifeSession.swift:24-67` 將 decoded state 視為未信任，依相同 catalog 重跑全部事件／決策／time jump，拒絕不相符歷史；engine/data/content version 明確檢查。
- `StoryMemory.swift:41-69` 從實際 ledger 建構事實與關係，求助不擦除已存在的經驗；`LifeState.swift:70-84` 比較重建結果與 hook provenance，拒絕偽造。
- 原友情、學習、照顧線仍由真實 fact 及技能／健康門檻投影；新四線需要前因和技能才能解鎖帶領，無前因仍有參與／求助／免費休息。舊三線固定 fixture 的 regression 與正式動態池測試分開，不將 fixture 算成自然觸發率。
- `GameStore.swift:72-103` 保存實際選前 session 作選後比較；跨國試算仍固定同一事件、選項、家庭條件、歷史與 Seed。`@MainActor` 保護 UI 更新。
- 本輪讀到的測試包含非法輸入、邊界、被拒絕操作後 state 不變、完整 sequence、候選重排與加入、重播及新舊故事 provenance；不是僅 happy path。71 Swift／15 Python／5 UI 為既有交付與 CI 證據，本審查者沒有重跑或將其冒稱本輪獨立執行。

## 保留的 findings／驗收缺口

| severity／來源 | 位置與證據 | Attribution | Current-decision impact | Status／Disposition |
| --- | --- | --- | --- | --- |
| P1，Review 5628794428：故事延續取捨 | `artifacts/evidence/rng-v2/comparison.md:7-10`，至少兩鏈：投入 256→172／256、混合 112→64／256；動態池不保證回應每條舊線。 | exposed／RNG-V2 取捨 | no：使用者目前只整合開發基線並明留故事品質工作；沒有將兩鏈普遍達成作完成宣稱。 | carried-forward；後續有前因的故事機會／回顧與真人理解驗證 |
| P2，同 review：linked-chain 漏計支持／恢復 | `LifeCrossroads/Analysis/BatchAnalyzer.swift:136-141`，新線需 continuation＋可行 lead，不能用 rest 0/256 推論沒有後果。 | pre-existing to integration | no：量測限制明示，與遊戲可推進／重播安全無矛盾；不得據此聲稱教育成功或休息失敗。 | carried-forward；分成成長、支持、恢復、關係量測 |
| P2，同 review：隨機不同不是國家差異 | `comparison.md` 是同背景跨 Seed；目前環境只兩個宏觀指標。 | pre-existing | no：LC-03 八國與更多環境條件另列，四國原型未冒稱八國完成。 | separate work：LC-03 配對成本／支持／可行路線證據 |
| 既有非阻擋授權格式限制，Review 5625730002 | `Models.swift:204-210` 只接受 CC-BY-4.0；台灣仍 blocked。 | pre-existing | no：本次沒加入不同授權新來源，也沒有繞過資料 gate。 | separate work：LC-03 接官方新來源前逐來源契約 |
| P2，既有 UI／產品驗收 | 共用寓言舞台、五齡角色；四國／40事件／7線並非 P1 全範圍，缺實機、人工 VoiceOver、兒少、10～15分鐘實測。 | pre-existing | no：owner 明確區分開發基線、完整遊戲與發布；不能據工程批准跨越後兩者。 | carried-forward：LC-07／Visual Integration PR／真實試玩 |

以上依 `REVIEW_CRITERIA.md` §2.1 分開 severity 與 current-decision impact；沒有把「留後」自行用來豁免已證實的 correctness 問題。未發現需 fix-now 的新阻擋項。

## Governance Audit

- Architecture：`LifeDomain` 純值運算；未發現直接檔案、網路、時鐘、全域亂數或 UI 呼叫。Data 載入／CLI／App 各在自身邊界；LifeAnalysis 只依 Domain，App 不依分析層，符合兩份 ADR。
- Native Safety：N/A；沒有手動 ABI、C 指標或 native ownership 變更。Simulator resource lifetime 已在腳本 delta 覆核。
- Test Integrity：歷史 regression＋失敗案例＋狀態序列及精確 HEAD CI；主 Agent 新整合測試待另附，不能從本報告推論它已成功。
- Thread Safety：GameStore 主執行緒隔離；純 Swift value state 無共享 mutable RNG。
- Baseline Status：現存四候選 CI 成功；本次 retarget／合併之後的狀態尚未由本審查者觀察。
- Scope Hygiene：只對 frozen heads 給 verdict；未提交本機文件／Visual WIP 不在批准範圍，不應混入這四個提交。

## Knowledge Base Alignment

- `memory/03_knowledge_base.md` 無已確認的長期 anti-pattern／regression 條目（0）；已查讀 `memory/04_review_log.md` 的模型、compare sheet、原因與小螢幕 regression 歷史。
- Result：Pass，未見原國家排序／離線學習／虛構因果／固定 invest 回歸。
- 主 Agent 負責依 canonical writer 保存審查記憶；本子 Agent 不寫 memory 或執行 project-level session closeout。

## 尚需由整合操作者完成

1. 保存本輪實際 Swift／Python／Simulator 整合結果，成功／失敗都核對僅本次專用 Simulator 已刪除。
2. 在每次 retarget／merge 前核對 exact head、owner 合併授權、required checks；若程式 bytes 改變，重審該 delta，不沿用本報告批准新程式。
3. 合併以保留 ancestry 為前提，Visual 原型與未批准素材維持獨立；不因本工程 verdict 宣布 P1／發布通過。
