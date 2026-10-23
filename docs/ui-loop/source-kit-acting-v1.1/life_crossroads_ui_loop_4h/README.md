# 《人生岔路》Codex 3–4 小時自動視覺＋角色演出 Loop v1.1

這是一份**供使用者在自己的 Mac 上啟動的本地執行器**；ChatGPT 不會在對話背景執行。此 v1.1 已將**阿澄 4 表情、3 姿勢、兩路線不同反應與 Reduce Motion**放入必要驗收，不需要在每張新圖之後人工簽核。

新增 [`CHARACTER_ACTING_SPEC.md`](CHARACTER_ACTING_SPEC.md)：角色身分錨、表情／動作清單、三個可玩狀態、SwiftUI 呈現規則、contact sheet、XCTest 和 JSON 證據。

## 用法（本地已安裝 Codex CLI、登入、Xcode／Simulator）

請將本資料夾放在 Mac 可讀路徑，例如 `~/Downloads/life_crossroads_ui_loop_4h`。
然後在 Terminal 執行：

```bash
python3 ~/Downloads/life_crossroads_ui_loop_4h/run_ui_loop.py \
  --repo /你自己的/life-crossroads \
  --hours 4 --iterations 6 --push
```

若要 3 小時上限，把 `--hours 4` 換成 `--hours 3`。時間縮短時先省略裝飾動畫，不可把表情姿勢變化、路線區別與可用性測試當成已完成。`--push` 是選用的，只有完成本地檔案、證據收據、測試狀態（**包含表情／姿勢與減少動態效果 Gate**），且 Git worktree 乾淨時才推送到**新分支**。不加 `--push` 就只在新 worktree 保留結果。

腳本會先從 `origin/codex/ui-event-first-v1` 建立獨立 worktree，並以 sandbox `workspace-write` 跑最多 6 輪 Codex Builder，於第 2、4、6 輪後視剩餘時間執行唯讀 Critic，**Critic 會檢查實際演出截圖及表情姿勢的辨識度**。每輪都有單獨時間上限；總時間硬上限約 3 或 4 小時。

**它不會**合併 PR、發布 App、關閉治理，不會自動付費使用圖片 API，也不會碰主工作目錄的未提交變更。

## 重要界線

- 這是第一輪「一個紙橋事件 + 兩條選擇後果」的 UI／美術垂直切片；包括 4 表情、3 姿勢，但**不是 12 組動畫，也不是整款遊戲美術完成**。
- 預期最後多出 `06-acting-contact-sheet.png`、`ACTING_IMPLEMENTATION.md`、`acting-state-proof.json`，並由兩個新增 UI tests 覆蓋表演狀態與 Reduce Motion。
- 程式碼與截圖 Gate 通過不等於兒少真人研究、正式美術專家或素材商用授權通過。
- 若 Codex 額度不足、ImageGen 不可用、Xcode 不可用、權限受阻，就留下 partial evidence 並停止，不會繞過系統限制。
- 若執行環境不同、未有自動視覺檢視工具或 Simulator，應先處理環境，而非將無圖片的測試結果冒稱視覺完成。
- 當地 Mac 需保持開機與網路／登入可用；本腳本不安裝任何工具。
- 啟動前先查閱 `LOOP_PLAN.md`、`CHARACTER_ACTING_SPEC.md` 與 `AGENT_PROMPT.md`，以及實際 repository 的 `AGENTS.md`／治理契約。程式只在允許範圍內修改。

## v1.1 比 v1.0 多了哪些硬性 Gate？

- 四表情、三姿勢出現在真實渲染的 `06-acting-contact-sheet.png`；不能只在 Markdown 列出名字。
- 初始／找朋友／找老師三組實際畫面，各有有意義的角色表演與道具狀態。
- 兩種 Simulator 各至少 10 項 UI test 通過，包含表演狀態與 Reduce Motion。
- 唯讀 Critic 要真正打開六張 PNG，記錄四張主要圖的 SHA256；修圖後舊的 Critic PASS 自動失效。
- 如果尚未做到則回報 `PARTIAL`，可保留獨立 worktree，但不會自動以 PASS 推送。

執行器本身可在本機先做**不啟動 Codex**的單元測試：

```bash
python3 -m unittest discover -s ~/Downloads/life_crossroads_ui_loop_4h/tests -p 'test_*.py' -v
```

已啟動 **舊版 Loop** 的情況，建議先讓舊任務安全結束，之後以 v1.1 開新 worktree；執行器不會悄悄覆蓋先前 worktree 的合約。

## 備用方案：Claude Code Ralph Loop

若要用 Claude Code 的官方 Ralph Loop，而非 Codex CLI 啟動器，可在**單獨 worktree** 安裝官方 ralph-loop 插件後，使用：

```text
/ralph-loop "Read docs/ui-loop/AGENT_PROMPT.md, docs/ui-loop/LOOP_PLAN.md and docs/ui-loop/CHARACTER_ACTING_SPEC.md. Build a bounded paper-bridge scene with 4 readable expressions, 3 reusable poses, distinct friend/teacher reactions and Reduce Motion; keep evidence, run tests, critic screenshots, iterate. Only output <promise>VISUAL_SLICE_READY</promise> after the exact acceptance artifacts and gates pass; otherwise report partial/blockers." --max-iterations 8 --completion-promise VISUAL_SLICE_READY
```

此命令本身只有 **最大迭代次數**，不保證 4 小時硬上限；要硬上限需要另外用外部 process supervisor。只建議已安裝並信任該插件的環境使用。
