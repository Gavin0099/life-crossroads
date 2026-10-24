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

## 兩機圖已就緒（作者自查入口）

- 正式c445e5f App兩機各18/18，summary與逐圖manifest已在主工作目錄 `artifacts/evidence/life-loop/integrated-native/standard/`、`se/`，各12張原生PNG，來源/測試/裝置ID/SHA逐張保留。
- 請既有B只讀以上12×2圖核對生活300pt／事件88pt／大字90pt、13歲pending→17歲occurred、rest與Reduced，不啟動Simulator或修改renderer。屬作者自查，不是獨立Critic；請在共享2h內作有界目視，精確核時缺口保留unknown。
- 兩機各18案例PASS後，Xcode卡在自己的simctl diagnose（取樣及親子argv已驗證）。A僅TERM這兩個診斷子程序，沒有殺xcodebuild／runner／共享服務；原命令均正常exit0、有效xcresult已完成，兩台均delete。原log、診斷取樣與操作紀錄保留；不宣稱額外OS診斷完整。
- A正把verbose OS diagnostics改為可選（預設never，實際失敗調查可選on-failure），仍保留XCTest/log/screenshots/xcresult及失敗exit code；將補小型原生收尾驗證，不變更App source、不重跑36案例。
- B完成後可將正式觀察記在既有工作樹的 `docs/life-loop-10h/INTEGRATED_VISUAL_REVIEW.md`；A只移入最終報告／來源，不整枝合併。

## 最後交付（不再擴充）

- c445e5f兩機完整18/18已結束，圖／hash與有效xcresult均保存。e1ca7c7工具never模式兩機各1/1無介入收尾，App未變；本輪root9台Simulator均delete。
- 獨立Reviewer最終窄覆核完成，總0.966h，未見新增阻擋；B作者自查兩檔已從其59eab53取入，與獨立報告分列。B不用另開Simulator、改renderer、追加工時或第二PR。
- 原始診斷收尾需人工TERM可選child的事實、Publishing changes警告及B核時unknown均保留於DELIVERY和機讀證據。最終文件commit／CI在同PR10更新，Draft/HOLD，不合併main、不發布。
