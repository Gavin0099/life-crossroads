# 《人生岔路》Codex 3–4 小時自動視覺改造套件

這是一份**供使用者在自己的 Mac 上啟動的本地執行器**；ChatGPT 不會在對話背景執行。

## 用法（本地已安裝 Codex CLI、登入、Xcode／Simulator）

請將本資料夾放在 Mac 可讀路徑，例如 `~/Downloads/life_crossroads_ui_loop_4h`。
然後在 Terminal 執行：

```bash
python3 ~/Downloads/life_crossroads_ui_loop_4h/run_ui_loop.py \
  --repo /你自己的/life-crossroads \
  --hours 4 --iterations 6 --push
```

若要 3 小時上限，把 `--hours 4` 換成 `--hours 3`。`--push` 是選用的，只有完成本地檔案、證據收據、測試狀態，且 Git worktree 乾淨時才推送到**新分支**。不加 `--push` 就只在新 worktree 保留結果。

腳本會先從 `origin/codex/ui-event-first-v1` 建立獨立 worktree，並以 sandbox `workspace-write` 跑最多 6 輪 Codex Builder，於第 2、4、6 輪後視剩餘時間執行唯讀 Critic。每輪都有單獨時間上限；總時間硬上限約 3 或 4 小時。

**它不會**合併 PR、發布 App、關閉治理，不會自動付費使用圖片 API，也不會碰主工作目錄的未提交變更。

## 重要界線

- 這是第一輪「一個紙橋事件 + 兩條選擇後果」的 UI／美術垂直切片，不是整款遊戲美術完成。
- 程式碼與截圖 Gate 通過不等於兒少真人研究、正式美術專家或素材商用授權通過。
- 若 Codex 額度不足、ImageGen 不可用、Xcode 不可用、權限受阻，就留下 partial evidence 並停止，不會繞過系統限制。
- 若執行環境不同、未有自動視覺檢視工具或 Simulator，應先處理環境，而非將無圖片的測試結果冒稱視覺完成。
- 當地 Mac 需保持開機與網路／登入可用；本腳本不安裝任何工具。
- 啟動前先查閱 `LOOP_PLAN.md` 與 `AGENT_PROMPT.md`，以及實際 repository 的 `AGENTS.md`／治理契約。程式只在允許範圍內修改。

## 備用方案：Claude Code Ralph Loop

若要用 Claude Code 的官方 Ralph Loop，而非 Codex CLI 啟動器，可在**單獨 worktree** 安裝官方 ralph-loop 插件後，使用：

```text
/ralph-loop "Read docs/ui-loop/AGENT_PROMPT.md and docs/ui-loop/LOOP_PLAN.md. Build the bounded paper-bridge visual gameplay vertical slice; keep evidence, run tests, critic screenshots, iterate. Only output <promise>VISUAL_SLICE_READY</promise> after the exact acceptance artifacts and gates pass; otherwise report partial/blockers." --max-iterations 8 --completion-promise VISUAL_SLICE_READY
```

此命令本身只有 **最大迭代次數**，不保證 4 小時硬上限；要硬上限需要另外用外部 process supervisor。只建議已安裝並信任該插件的環境使用。
