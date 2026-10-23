# AI Governance 導入與完整性盤點

日期：2026-10-23（Asia/Taipei）。最新範圍：八國完整人生規格、首次本機提交與基本 CI。

## 產品開發後的狀態

框架固定版本維持不變。既有基線已推送，LC-01 的
[遠端 CI](https://github.com/Gavin0099/life-crossroads/actions/runs/39908800771) 通過，
LC-02 原型已接續實作，見 [產品進度](lc02-progress.md)。
遊戲引擎及 UI 證據與框架檢查分開；runtime 稽核持續為 advisory，沒有因此宣稱完整 runtime 強制已驗證。
以下 P0-002 與首次導入段落保留為當時的追溯紀錄，其中的授權與未驗證敘述不取代目前使用者指示。

## P0-002 導入基線（歷史）

- 首次本機 commit：`a468cbc0bef527ea44851ee0632a619ca1a797ff`。正常 Git pre-commit hook 已觸發，沒有使用 --no-verify。
- 由框架工具刷新 baseline，source_commit 記錄上述真實 commit；首次提交前的 unknown 警告已消除。
- 框架仍固定 `3bc4db55c9132f81aed4fce328f3622caf15db3c`，沒有更新框架 pointer 或修改 submodule。
- 基本檢查：6 PASS。錯誤 pin 的反向驗證成功，其他基本檢查通過，原 lock 已逐 byte 恢復。
- 完整治理稽核：14 PASS；合成 smoke 與靜態成熟度不等於真實桌面 session enforcement。
- 靜態成熟度為 full_candidate（可見表面齊備的候選），缺少的靜態表面清單為空。
- 沒有 push、PR 或遠端 CI run；遊戲、資料與實機仍未驗證。

## 基本 CI 與產品開發

使用者已明確決定完整 runtime 治理的未驗證狀態不阻擋產品開發。

| 工作 | CI 行為 | 本機入口 |
| --- | --- | --- |
| basic-checks | 失敗會使 workflow 失敗 | bash scripts/governance-check.sh --profile basic |
| governance-audit | continue-on-error，保留原始失敗 | bash scripts/governance-check.sh --profile full |

基本檢查涵蓋 framework pin、元件版本、baseline drift、YAML/JSON、shell 與 Python 語法。
尚無 Swift app；純 Swift CI 隨 LC-01 加入，app build 與完整人生驗收隨 LC-02 加入。
這個分工不放寬後續遊戲規則、資料完整性或實機品質 Gate。

## 最新導入狀態表

| 功能 | 狀態 | 這個功能是做什麼 |
| --- | --- | --- |
| 版本帳實一致性（Lock vs checkout consistency） | 已可用 | 比對 governance/framework.lock.json 的 adopted_commit 與本地 framework checkout HEAD；不做 fetch，也不宣稱真實遠端最新版。 |
| 框架本體（Framework checkout） | 已可用 | 提供 AI Governance 工具與規則來源；目前偵測到的導入型態是 submodule_consumer。 |
| 版本新鮮度（Framework version freshness） | 已可用 | 檢查本地 framework 是否追上本地已知 tracking ref；真正遠端最新證據由 updater 另外回報。 |
| 本 repo 規則（Repo governance instructions） | 已可用 | 讓 agent 進入這個 repo 時知道本 repo 的風險、測試與操作規則。 |
| 靜態治理檔案（Static framework files） | 已可用 | 提供不跑 runtime 也能讀到的治理文件、規則與導入狀態。 |
| runtime 治理能力（Runtime-capable governance） | 未驗證 | 代表 repo 是否具備可執行的 runtime governance；只有明確回報已可用時才算導入。 |
| 本機 commit/push 檢查（Git hooks） | 已可用 | 在本機 commit 或 push 前提示/檢查治理狀態；這不等於所有機器都已強制執行。 |
| 領域合約（Domain contract） | 已可用 | 用 contract.yaml 宣告這個 repo 自己的治理需求與驗證入口。 |
| 自動驗證層（Validator surface） | 已可用 | 列出 repo 專屬 validator，讓更新後能知道是否接上自動檢查。 |
| 記憶工作流（Memory workflow） | 未驗證 | 顯示 memory 寫入/檢查流程是否有被觀測；不代表記憶內容已完整同步。 |

完整 runtime、memory 及遠端 CI 的證據限制繼續揭露，不作開始 LC-01 的額外批准 Gate。
`risk_tier: medium` 為本輪 tooling 執行姿態；產品核心及兒少內容依專案規則升級驗證。

## 本輪可追溯證據

- `artifacts/evidence/test-results/basic-ci.json`：本機基本檢查的框架執行收據。
- `artifacts/evidence/test-results/ci-pin-rejection.json`：錯誤 pin 拒絕與 byte-exact 恢復的執行收據。
- `artifacts/evidence/test-results/governance-after-initial-commit.json`：14 項完整治理稽核收據。
- `artifacts/evidence/onboarding/initial-commit.log`：首次正常 commit 及 hook 輸出。
- `.governance/adoption-result.json`：本輪結果、宣稱邊界與證據索引。
- 先前 31 項框架測試收據仍保留，沒有以它取代本輪 CI 行為驗證。

舊記憶的未綁定、引用及 metadata 警告保留為歷史；新記錄以真實初始 commit 與框架收據綁定。
未執行歷史記憶正規化，也不以清空歷史警告作為產品開發前提。

## 歷史快照：GOV-001，首次提交之前

以下保留首次導入時的限制與處理記錄；當時的「未提交」及 10 PASS/1 WARN 不代表本輪最新狀態。

### 結果與版本

本機工具與專案規則已建立，consumer 類型為 submodule consumer。
正式導入驗收尚未結案：父 repo 尚無初次 commit，真實 commit/push、桌面 Codex lifecycle
及遠端 CI 未驗證。框架成熟度回報為 partial，不能宣稱 full adoption。

- 來源：https://github.com/Gavin0099/ai-governance-framework
- 固定版本：`3bc4db55c9132f81aed4fce328f3622caf15db3c`
- 路徑：`additional/ai-governance-framework`
- 上游版本說明為 1.3.0 candidate；沒有驗證 GitHub Release/tag 正式發布。
- `governance/framework.lock.json` 與 checkout SHA 一致；目前尚未 commit。
- submodule 原始碼未修改；授權及來源見 THIRD_PARTY_NOTICES.md。

### 逐項完整性

| 適用表面 | 本次結果 | 證據／驗收邊界 |
| --- | --- | --- |
| 固定來源與 submodule | 已建立 | .gitmodules、gitlink、完整 SHA、framework-pin.log |
| 版本 lock | 本機對齊，待提交 | framework.lock.json；不是已提交版本或 F-7 更新證據 |
| 保護 baseline | 已生成且 hash 驗證通過 | adopt_governance --refresh；AGENTS.base.md 未手改 |
| 專案 AGENTS | 四個專屬區段已填 | 風險、必測路徑、升級條件、禁止行為；managed contract projection 已安裝 |
| 產品方向與任務範圍 | 已記錄 | PLAN.md、project-guardrails.md；本次沒有產品程式實作 |
| domain contract | 已設定 | ios-life-simulation，架構驗證器已註冊；風險屬助理執行設定，非人工產品風險簽核 |
| 元件版本 manifest | 已補齊、compatible | version-compatibility.log；版本值來自固定框架的 installed layout |
| 規則包 | 已選擇適用範圍 | common、swift、python、refactor；其他領域保留在上游 submodule |
| 本機 Git hooks | 安裝驗證通過 | hooks.log；Git hook run pre-commit 成功，沒有產生 commit |
| pre-push 拒絕路徑 | 空更新輸入如預期拒絕 | pre-push-trigger.log；這是無效輸入演練，不是真實 push 正向驗收 |
| runtime 工具 | 三個 Codex smoke 通過 | session_start、pre_task、post_task；合成輸入不等於本次桌面 session 自動觸發 |
| memory | 四個角色骨架、canonical writer／guard | memory.log；首次提交前為 unbound，不能升級為已簽核長期事實 |
| CI | workflow 已接同一檢查入口 | .github/workflows/governance-drift.yml；尚無遠端 run |
| 後續框架更新 | F-7 入口及規則已保留 | 初次導入不是 F-7 full update；沒有因此宣稱已受治理更新完成 |
| 權利管理 | 已保存上游 license 與 notices | Apache-2.0；遊戲來源資料、事件與素材須另行檢查 |

### 不適用或尚未發生

- 多 repo fleet、Windows driver、USB、Verilog、C#/Avalonia 等不屬本專案導入範圍。
- 尚無 Swift app、引擎或統計內容；遊戲專屬 validator、Xcode CI、實機及兒少試玩尚未發生。
- 不修改全域 Codex 設定；桌面 app 沒有在本任務中提供已確認的 session-end lifecycle。
- 不把每回合 final answer 當 session end，因此沒有偽造 session-end closeout。
- 框架 SOP 的人工 domain/risk 確認、真實 commit/push 觸發及 reviewer 驗收維持未完成。

### 驗證入口與結果解讀

```bash
bash scripts/governance-setup.sh
source .venv/bin/activate
bash scripts/governance-check.sh
```

檢查入口會保留各工具的輸出與 exit code；失敗不會被轉成 PASS。
結果位於 `artifacts/governance/checks.json`、`adoption-status.json` 及各項 `.log`。

當前 strict check 仍因 drift 的來源追溯 warning 回傳非零：父 repo 無 HEAD，
baseline 的 `source_commit` 為 unknown。其他本機檢查成功不會消除這個限制。
沒有透過手改 baseline、捏造 SHA 或略過檢查解決。

記憶 guard 沒有 blocking findings，但保留 `unbound_memory`，以及第一筆新紀錄
只引用目錄而非檔案造成的 `test_evidence_provenance_not_found`，以及首次更正尚未提供
框架收據 metadata 的 `test_evidence_artifact_metadata_missing` 歷史警告。
已用框架 `test_evidence_receipt_writer` 實際重跑並產生
`artifacts/evidence/test-results/governance-onboarding.json`，再由 canonical writer 追加更正；
沒有靜默改寫歷史記錄。
這些警告不能解讀成記憶已綁定、已審閱或完整同步。

框架針對性測試為 31 passed；實際輸出見 `framework-targeted-tests.log` 及 JUnit XML。
涵蓋 runtime smoke、架構 drift 及 pre-push worktree routing；沒有跑整套框架測試，
也沒有把框架測試當成遊戲測試。

初次執行曾因測試工作目錄設在 consumer root，導致三項 fixture 路徑找不到；
改由框架目錄執行後通過。這是測試呼叫修正，沒有修改上游測試或降低斷言。

setup 再執行回報 `changed_files=0`、hook `valid=True`；專案自訂指令未被覆寫。
本機檢查摘要為 10 PASS、1 WARN、0 FAIL，但 strict command 仍回傳 1，原因是上述來源追溯警告。
完整性審查為 WARNING：可檢視與使用已安裝設定，不是正式導入或發布核准。
審查輸入包含 REVIEW_CRITERIA.md、AGENT.md、AGENTS.base.md、PLAN.md、
memory/03_knowledge_base.md、memory/04_review_log.md、安裝/執行產物及本文件所列驗收邊界。

### 初次提交後的驗收路徑

1. 負責人接受本機變更並授權初次提交；本次沒有自動 commit/push。
2. 先建立實作 checkpoint，再用 adopt --refresh 重新產生可追溯 baseline，另存治理 checkpoint。
3. 重跑相同檢查，確認 drift warning 消失；需要記憶綁定時使用 canonical writer 綁定真實 commit。
4. 真實 commit/push、PR 或 CI 發生時，各自保留觸發證據。
5. 只有取得具體平台 lifecycle 證據，才升級真實 session 自動治理的宣稱。

上述提交／上傳路徑是後續選項，不代表本輪已取得執行授權。
