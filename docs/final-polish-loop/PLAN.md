# FINAL-POLISH-LOOP

來源：Owner 2026-10-28完整任務。固定PR20 `325b69896553fb6c479e415c0c0991e76ef78a26`，新分支codex/final-polish-loop；Draft基底codex/interaction-memory-loop。不合併、不發布、不上TestFlight，不自動啟動下一Loop。

## 範圍與驗收
FP01角色一致性／五粗階段；FP02真實13與32求助銜接、72歷史；FP03場景與操作的視覺層級；FP04七個代表場景；FP05三輪原生與獨立Critic。
角色／資料語意來自已保存trace與既有projection。只改App、Presentation純呈現計算、必要素材與驗證。Domain、Data、Persistence、Seed/RNG/schema、事件／國家、Save-before-Publish、原158Swift/45Python/30UI範圍、貓狗候選故事狀態與CI不變。

## 先固定的證據
- Round1：相同真實archive於SE3／iPhone17的基準；先審查再決定局部生圖。
- Round2：只修可觀察P1/P2，重新拍同狀態；13／32保存後200/900/1400ms均讀實際共同clock，存檔SHA必須相同。
- Round3：修正後最終同源正常／最大字級／Reduced Motion；保存失敗／重試，原有全套與新呈現邊界測試。
- 既有158/45/30不刪減；共用clock取值的邊界、invalid/nonfinite、Reduce Motion及非request反例；只觀察不新增clock或人生決策。
- 原生元素圖未後製，完整畫面核對主要行動、VoiceOver語意保留，人工VoiceOver與兒少試玩另列。

## 三輪／預算／停止
最多3輪實質修正，最多4 Agent-hours。採保守計時：root牆鐘（含工具／CI等待）加各子Agent有工作turn的起訖區間；閒置等圖的時間另列，不偽稱CPU工時。
本輪root保守起算11:00 UTC；目標root≤150分鐘，Critic≤25、工程Reviewer≤20、必要局部圖修≤25，總額220分鐘，保留20分鐘緩衝。各turn記帳，達預算就停止擴修並據實交付。
兩次對同問題無改善停止重生圖；需Domain、重大重繪或新故事則BLOCKED，保留可用版本。工程／視覺／試玩三判定分開；CI既有session_envelope期限FAIL不關Gate。

## 記憶與交付
active-task目前95行10190字元CRITICAL。本輪是Owner已固定的呈現維護，以當前授權、PR20與實際檔案為依據，不從累積歷史擴張產品；不啟用舊fail-closed cleanup。記憶整理另安排，僅收束時canonical記錄本片證據。
交付BASELINE_REVIEW、FINAL_VISUAL_REVIEW、BEFORE_AFTER、ASSET_CHANGES、VALIDATION、≥5組原生對照、SHA/Seed/Choice與三類Verdict。最後停在Owner實機及兒少試玩。

## 三輪收束
Round1雙尺寸基準；Round2修道具/構圖並發現淡接雙手；Round3縮短120ms、暖紙層級與真過渡取證。無第四輪。工程Reviewer ACCEPT，Visual CONDITIONAL ACCEPT，Product適合Owner帶領試玩，持續Draft/HOLD。最後source核對及六裝置delete皆PASS；原30UI與當前HEAD遠端CI待推送後核對，既有治理FAIL不消除。

子Agent保守active計時：局部圖修8m23s；Critic三turn總14m；工程Reviewer兩turn總10m02s，合計32m25s。root自11:00 UTC至提交前檢查點計時，後續CI等待仍列root牆鐘；最終總計在PR交付補述，不偽稱此時已完成遠端等待。
