# P1 核心整合與後續工作線

2026-10-23 使用者授權把四個已審查的核心 PR 整合進 `main`，作為共同開發基線。這項決策取代前輪的合併 HOLD；不代表 P1 完成或 App 可發布。

## 核心合併

| PR | 審查候選 | 保留歷史的 merge commit |
| --- | --- | --- |
| [#1](https://github.com/Gavin0099/life-crossroads/pull/1) | `ae3253b` | `58a5786` |
| [#2](https://github.com/Gavin0099/life-crossroads/pull/2) | `ad773f9` | `336c1fe` |
| [#3](https://github.com/Gavin0099/life-crossroads/pull/3) | `4f268b8` | `73d9f12` |
| [#4](https://github.com/Gavin0099/life-crossroads/pull/4) | `c05ee51` | `430fbf8` |

四個候選由本輪獨立審查者 `/root/core_merge_review` 分別覆核通過；PR #2 從 `93e0418` 到 `ad773f9` 的六筆後續提交另行檢查。PR #1 的三條、PR #2 的兩條舊 inline threads 已依具體修正及回歸測試結案，沒有把未完成的產品問題標成已修復。

每次合併前核對 frozen head、目前 main、GitHub 合併資格、同 HEAD 成功 CI，並以 `git merge-tree` 證明重新指向 main 後的合併檔案樹等於已審查候選。沒有重寫 PR 的 HEAD、squash 或刪除來源分支。此處引用既有同 HEAD CI，不冒稱 metadata retarget 另產生了新 CI。合併後的 main push CI 另以實際執行結果核對。

最終核心 `430fbf8555712d21fba4d2925399221bcbbf44b0` 的檔案樹等於 `c05ee51`，四個原始 HEAD 都是其祖先。後續只同步計畫、審查、驗證與記憶；沒有在整合中改寫遊戲規則。

## 本輪整合驗證

- `swift test -c release`：65 Domain＋6 Analysis，71 項通過，包含固定 Seed、三條既有分岔、非法狀態、Codable 及1,000局無死局。
- Python discover：15 項通過；離線資料生成檢查確認14筆觀測、8國模型、16家庭、40候選事件。
- iPhone SE（第三代）Simulator：5項 UI 通過，包含正式完整人生、比較、實際原因與放大文字。結果為 `artifacts/ios/LC02-20261023T134110Z.xcresult`。
- 專用裝置 `B5B68250-A3F9-479F-9755-B8A921536C9F` 已由腳本刪除，另查 inventory 確認不存在；未刪共用 runtime。
- Basic checks 六項通過；完整 runtime 稽核維持 advisory。

機讀證據與獨立審查在 [`artifacts/evidence/p1-core-integration/`](../artifacts/evidence/p1-core-integration/)，命令收據在 `artifacts/evidence/test-results/p1-core-*.json`。本輪沒有用既有兒少／實機證據冒充新驗收。

## 圖片 WIP 與正式整合邊界

- 原候選分支 `codex/lc-visual-design` 保留於 `2b62a19`。
- `codex/gs-visual-gameplay` 的 `9bd75d2` 已推送。
- 35個當時尚未提交的圖片／演出原型變更，原樣保存為 `codex/ui-visual-loop-4h` 的 `3438fc6` 並推送；逐檔雜湊與保存前一致。之後 Visual Agent 新增的工作不覆蓋或重設。
- WIP 仍保留原來的失敗與待驗證紀錄，不宣稱美術、演出或原型測試通過；`approved_for_app=false` 不代表已選稿。
- Visual 正式接入從最新 `origin/main` 建立獨立分支與 PR；核心程式基底至少包含 `430fbf8`。只移入選定的素材、UI與必要適配，不整條合併舊原型，不改 Domain 規則。無素材選稿時保留候選，不將其自動納入 App。

## 後續優先順序與未完成 Gate

Gameplay 先做 LC-04：保留原人生、回到重大選擇重走後半生；再做 LC-03 八國及可追溯的國家環境差異。故事後果分成長、支持、恢復、人物關係量測；保留 RNG-V2，不追高9/15。實機、人工 VoiceOver、10～15分鐘及10～12／13～15歲試玩各自留紀錄；現有完整人生可先做玩法試玩，不等待美術全部完成。

目前四國／40事件／七故事線仍是工程原型。八國、50～70事件、完整改選、SwiftData 存檔、選稿後的正式美術、兒少理解／娛樂性與發布驗收均未完成。合併沒有縮減這些目標。
