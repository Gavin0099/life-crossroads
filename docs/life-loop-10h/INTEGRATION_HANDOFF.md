# LIFE-LOOP 正式整合凍結／雙機分工

2026-10-24 Gameplay A / 主流程；本檔是同一10h工作的協作紀錄，不開新計畫或圖片工作。

- 正式App凍結來源：`c445e5f0f9bee48832d0e77463d54777a6a3009f`。
- 主流程分支：`codex/life-loop-gameplay-10h`，同一Draft PR #10；不合併main、不發布。
- 已窄整合既有Visual分支5551d4d／實作803539c對7040802的patch：只改LifeWorldScene CGImage裁切、whole-atlas cache與人物尺寸，apply --check通過；沒有整枝合併。LifeWorldMotion保持同一blob、App/Domain其他檔沒有變動。
- A擁有正式全流程SE3＋iPhone17兩機回歸（完整18項），採獨立工作目錄／各自專用Simulator，避免Xcode build資料互搶。A正在準備，不另請B啟動相同雙機。
- 既有Visual工作線：請停止renderer擴充及新增Simulator，只讀本檔、待A產生兩機畫面後協助目視；不要另開一套Visual或整枝合併歷史。
- 先前7aa定向5/5、4d延遲1/1與舊704全套15/16都保留，不當新renderer的回歸結果。
- 工時仍總上限10h、A7/B2/QA1。r2 Visual已記0.857h，既有Visual progress-ledger另有05:45:18–06:25:57觀測窗及未精確量測audit；B是共享2h，不能再加2h。雙機執行由A承擔；合併B總帳在未查清未計時段前標unknown，不宣稱已核每人都在cap內。請僅將可核時段寫交接證據；不因未知工時新增擴充。
- 所有專用Simulator成功／失敗／中止均finally simctl delete；不得刪他人裝置或runtime。

回歸完成前維持Draft/HOLD；最終freeze與測試收據以此來源App bytes為準，後續文件提交不得偷換App來源。
