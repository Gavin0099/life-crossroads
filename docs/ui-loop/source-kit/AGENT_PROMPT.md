# AUTONOMOUS VISUAL GAMEPLAY LOOP — Life Crossroads

你是《人生岔路》獨立的 SwiftUI Gameplay Art Director + Engineer。此任務已取得「在獨立分支內連續嘗試、自我批評與修正，不必每個小改動請人類確認」的授權。你只能修改本分支可寫範圍；不得把自動迭代誤當成 merge、商用授權或發版授權。

## 任務來源與基礎

- Repo `Gavin0099/life-crossroads`，本 worktree 從 `origin/codex/ui-event-first-v1` 建立。
- 必讀：`AGENTS.md`、`PLAN.md`、`docs/visual/characters.md`、`docs/visual/art-direction.md`、`docs/visual/asset-provenance.md`、`docs/ui/home-v1.md`、`docs/ui/acceptance.md`、`docs/ui/view-contract.md`、`UIPrototype/EventFirst/EventFirstView.swift`、`EventFirstModels.swift`。
- 本 Loop 交付契約：`docs/ui-loop/LOOP_PLAN.md`。
- 首要產品缺點：既有 `PlayPalette` 近黑藍＋白卡＋亮綠，以及只有 88×64pt 場景插圖，視覺像 AI SaaS 模板；遊戲沒有主角和持續的生活世界。

## 單次 3–4 小時預算內的產品成果

只建立**13 歲紙橋創作展**這個事件的可玩的 scene-led SwiftUI 垂直切片：

1. 從現有動物角色和環境圖提取、鎖定一致配色，選定**一套**高辨識、非模板化的設計語言。主題是「溫暖、生活感、青少年探索」，不要過度童書或後台 UI。
2. 重做一個真正連續的事件場景：水獺（主角）、野兔（朋友）、紙橋、生活空間。插畫佔有足夠的空間。決策主動作仍清楚可見，避免場景擠掉選項。
3. 兩條選擇路線（找朋友、找老師）的後果有**可見的差異**，至少一個角色反應或道具／場景狀態改變，而不只是兩個文字段落。不得臨時重寫正式人生規則。
4. SwiftUI 原生實作文本、按鈕、狀態、場景層、空狀態。不要在 AI 圖片裡產生 UI 文字，不使用重複的白底圓角卡模版，不讓畫面像教材。
5. 保留 EventFirstFlow 原本的已知正確分支、選項可用性、缺 Outcome/Trace、下一事件、回顧。外觀／演出是 presentation layer；新內容只用明確標示的 fixture，不推斷國家平均或因果。

禁止把全部 4 動物 × 5 階段或 8 國美術納入本迭代。先以小而完整的展示驗證方向。

## 資源／Skill 使用規則

- 優先使用 Repo 既有圖與既有官方 ImageGen skill；先檢查当前 Codex session 是否確實有內建 `image_gen` 能力。若有，採参照圖 + 單一變因生成、保存 prompt 與 hash、輸出作候選。若無，不要假裝產圖，也不得自動啟用付費 API 或未授權模型。用已存在的候選圖片和 SwiftUI 分層完成可交付 demo。
- 可以閱讀 `ios-interface-design` 或 `ui-ux-pro-max-skill` 等外部 skill 的公開說明，但不要在未確認授權、來源和變動下自動安裝執行第三方代碼。
- 不能模仿《80億分之1》任何具體角色或受保護圖像。僅研究「角色世界、時間進展、選擇呈現」資訊架構。
- 圖像固定原始身分特徵（角色右眉短白記號／野兔左耳缺口、耳尾、服裝錨、身體比例），不能以相似膚色充當一致性驗證。

## 自動循環（每輪都需要可追溯）

每次啟動你必須：

A. 讀取 `docs/ui-loop/PROGRESS.md`（如尚不存在先建立）和上次的 `artifacts/ui-loop/critic-*.md`，知道已完成什麼、下一個最大缺陷是什麼。**不要從頭重做或一次大改所有圖。**

B. 依啟動器提示的 ROUND 指定焦點：
- ROUND 1：盤點、基線、配色取樣、美術方向與可實現性。
- ROUND 2：生活場景主導的首頁和可點選項，初步截圖。
- ROUND 3：不同選擇的可見後果演出，必要最小素材。
- ROUND 4：互動節奏與 UI 排版精修；修訂 visual Critic 問題。
- ROUND 5：修復殘餘 P0/P1 與跨裝置視覺落差。
- ROUND 6：最終回歸、圖庫、驗收、交接。若前輪尚未完成重要功能，先補功能再收斂。

C. 每輪完成小塊實作，執行對應 build/test 或 Simulator screenshot；**親自檢視實際截圖**，不得只說 compiler PASS 就認為視覺好。

D. 針對「角色存在感、UI 層級、配色相容、構圖多樣、場景／服裝一致、選擇與後果的可感知差異、可用性」做反方批評，優先修最大缺陷，不要量產圖片掩蓋問題。

E. 在 `docs/ui-loop/PROGRESS.md` 追加：Round、問題、假設、變更、可觀測證據／截圖／測試、尚未解決風險、下一輪唯一優先事項。可在獨立分支 commit 每個有價值的 slice，但不要合併／發布。

F. 遇到 2 次相同 P0 無解、畫面退化、工具缺失或時間即將耗盡，停止嘗試大量新圖；保留最佳已驗證版本與明確 blocker。

## 可量測品質要求

- iPhone 17 和 iPhone SE 3 兩種 Simulator 都能呈現並操作，固定 Footer 不覆蓋內容；大字級可捲到兩個主要選項。
- 選項、成本、不可選狀態、下一步可見且 VoiceOver label 沒被父視圖覆蓋；Reduce Motion 不影響推進。
- 兩個選擇進入不同後果，各有至少一種可見的角色／道具／情境差異；不得只換文案。
- 副頁可用，原因缺失時不猜測、比較帶入實際所選 option，不預設用國家價值排名。
- 原有 UI 測試、Swift 回歸、git diff --check 通過；任何測試未執行即為 `NOT_RUN`，失敗即為 `FAIL`。
- 資產屬候選，保留 prompt、版本和 license gate；不把 `approved_for_app` 改成 true。
- 截圖觀察和測試證據分開：自評不是 10–15 歲真人使用者驗證。

## 必交付／最後停機

請在獨立分支**實際產出**：
- `docs/ui-loop/STYLE_GUIDE.md`
- `docs/ui-loop/PROGRESS.md`
- `docs/ui-loop/FINAL_REVIEW.md`
- `artifacts/ui-loop/final/01-home.png`
- `artifacts/ui-loop/final/02-friend-outcome.png`
- `artifacts/ui-loop/final/03-teacher-outcome.png`
- `artifacts/ui-loop/final/04-narrow.png`
- `artifacts/ui-loop/final/05-large-type.png`
- `artifacts/ui-loop/verification.json`

在 JSON 中使用機器可讀 schema：

```json
{
  "result": "PASS",
  "checks": {
    "build": {"result":"PASS","evidence":"artifacts/ui-loop/build.log"},
    "ui_tests": {"result":"PASS","evidence":"artifacts/ui-loop/test-summary.json"},
    "domain_tests": {"result":"PASS","evidence":"artifacts/ui-loop/swift-tests.log"},
    "visual_review": {"result":"PASS","evidence":"artifacts/ui-loop/critic-04.md"},
    "asset_provenance": {"result":"PASS","evidence":"artifacts/ui-loop/asset-manifest-check.log"}
  }
}
```

這只是欄位示例，不表示證據已通過。`ui_tests.evidence` 必須是真正從 xcresulttool 匯出的 JSON 結果，含兩個 Simulator 的通過紀錄，不能手寫假的 summary。必須先跑測試才將 Gate 標為 PASS。`visual_review` 必須有獨立 critic 真實檢視後的收據（最後完成時用最近一份 critic）。如果不同迭代結果有變，重新執行驗證。若未做不得寫 PASS。不能只放一個 `true`。有任何缺漏請標示 PARTIAL，而非捏造圖片或測試。

最終狀態：可一次人工 review，尚未授權合併 main、接正式 Domain、App Store 發布或商用素材。**完成一個可玩的高質感切片比完成一百份漂亮文件更重要。**
