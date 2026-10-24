# LIFE-LOOP 10H v1.1：生活循環整合交付

整套 LL-00～LL-06 程式與本機整合驗證已完成，沿用 [Draft PR #10](https://github.com/Gavin0099/life-crossroads/pull/10)。App／UITests 凍結 `c445e5f0f9bee48832d0e77463d54777a6a3009f`；測試工具最後修正 `e1ca7c702a305f5c49489295ae9d7afdf36fb1cb` 不改 App。文件提交後另核對最終 HEAD CI，不拿舊 HEAD 的成功代替。不合併、不發布。

## 實際可玩的差異

開始八國人生後先看大型河畔生活場景，約3秒遇到正式事件並暫停。玩家選擇且保存成功後，同一世界才顯示真實的人物互動、資源、道具或故事記憶，約2秒後自然回到生活。可暫停、1×／3×、立即跳過演出；事件永不自選。原因、比較、背景與原局檢視會暫停，冷啟動不偷偷補算人生。首頁可切回原 Event-first。

保留既有五齡沐沐整張 PNG，做小幅待機、水面環境與單次結果演出。生活場景高300pt、事件88pt、大字90pt、後果170pt，並非每個階段都占半屏。13歲創作、紙本、求助、休息與13→17歲呼應讀取實際 trace；未發生線索明示尚未實現，休息不額外畫出幫手。共同河畔是寓言場景，不能當各國實景。

## 保護與整合範圍

- 基於 PR #9 `c823c82`，承接 PR #8；舊原型 `65fff9e` 未整枝合併。
- 只讀 `LifeWorldFrame`／projector、注入單調時間的 `WorldPlayback`、GameStore 保存後更新快取投影；動畫不改事件、Seed、版本或存檔 schema。
- identity／generation／in-flight ticket 防止過期與重複續行；寫入失敗停留原畫面及原檔，可重試。完整原局與替代後半生仍由原分岔系統保存。
- 既有 Visual `803539c`／handoff `5551d4d` 只窄接 Scene 裁圖、靜態 bitmap cache 及人物尺寸；沒有合併其整條原型分支。Scene／Motion bytes 與最終作者版吻合。
- rossark 固定 `9b20964`、MIT 僅供動畫方法參考；沒有複製外部程式、Demo 素材、安裝整包 skill、產生新角色或骨架。

## 驗證

| 項目 | 最後結果與邊界 |
| --- | --- |
| 純 Swift | 111個不同案例通過：102基線＋3投影＋4播放＋2真實磁碟／分岔。獨立重跑9項是其中子集。 |
| 決定論 | 日本／台灣家庭一 Seed0 的 LL-00完整15項 trace 保持凍結；normal／fast／skip、逐邊界磁碟存讀、原局 bytes 與完整替代人生一致。八國15次選擇到80歲可完成。 |
| Python | 25項通過，含 wrapper 參數、boot失敗、成功／失敗刪除，以及可選診斷正／負向設定。 |
| 正式 App 全套 | c445e5f：iPhone SE3／iPhone17、iOS27.0各18/18通過，有效 xcresult、截圖與原命令 exit0；各有3筆 Publishing changes runtime warning。 |
| 新工具收尾 | e1ca7c7：兩機各1/1保存失敗與重試案例，無人工介入即正常結束及自動刪除；各仍有1筆同 warning。不是額外兩個不同 UI 案例。 |
| 圖像來源 | 兩機各12張原生 PNG、24筆 SHA256重算吻合，22個不同hash；兩機比較末列各有重複截圖，不當新場景。 |
| 動畫 | 直接編譯 App helper 驗證累積鐘、暫停／速度／loop與one-shot；舊版18張離線圖僅作當時來源證據，不當 c445 原生圖。嚴格像素相等1/255失敗與同輸入控制保留，不宣稱pixel-exact。 |
| 資料／引擎 | 對正式基底 Domain／Data／Persistence 無diff；31觀測／8國／16家庭／40事件離線檢查通過。 |
| 清理 | 本輪9台root專用Simulator均delete，對照inventory全部不存在；沒有刪其他任務裝置或runtime。標準機 raw xcresult 已複製回主工作目錄，自己的QA worktree已封存並由附件清單確認。 |

兩輪完整測試結束後，Xcode曾卡在額外 `simctl diagnose`。已取樣並核對 parent／argv／owned UUID，只終止兩個可選診斷 child，沒有終止 xcodebuild、runner 或共享服務；原程序隨即正常完成。**額外 OS 診斷不完整**，一般 XCTest/log/截圖/結果保留。`scripts/ios-check.sh` 現預設 `-collect-test-diagnostics never`，可選 `on-failure`；仍保留失敗 exit code／xcresult／清理。這不是 publishing warning 修復。操作明細見 [診斷收據](../../artifacts/evidence/life-loop/diagnostic-stall-action.json)。

舊 runner 啟動失敗、v2 2/4、704完整15/16、7aa定向5/5及4d延遲1/1依原來源保留；最新雙機18/18不抹去歷史。完整原始檔在本機 `artifacts/governance/life-loop-10h/` 及 `artifacts/ios/`；版本化摘要／畫面在 [integrated-native](../../artifacts/evidence/life-loop/integrated-native)，[機讀驗證](../../artifacts/evidence/life-loop/integration-validation.json)逐項列出來源與hash。

## 六項 Gate 與覆核

| Gate | 本輪可支持的判斷 |
| --- | --- |
| G1 真實人生 | 八國完整人生本地工程通過，未關閉既有資料缺口。 |
| G2 生活循環 | 自然相鄰兩事件與完整新世界人生／分岔原生通過，不是兒少趣味評分。 |
| G3 決定論 | 凍結 trace、速度／skip、原檔／原局／替代線與存讀工程通過。 |
| G4 真實後果 | 一般事件、13歲、13→17線索轉真實呼應具正式原生圖及獨立目視證據。 |
| G5 可操作 | 兩機全套、SE首屏、最大文字、Reduced本地通過；最終HEAD CI另外核對。人工VoiceOver及實機未驗收。 |
| G6 動畫與授權 | source/helper/單一鐘/靜態與Reduced通過；不宣稱實機FPS、所有連續演出已人測或正式骨架美術完成。 |

[獨立 Reviewer](../../artifacts/evidence/life-loop/independent-review.md)最後窄覆核核對兩機18項與新工具、6張目視及24個圖hash，未見剩餘已確認工程阻擋，累計約0.966 Agent-hour；未給合併批准。[既有 Visual 作者自查](INTEGRATED_VISUAL_REVIEW.md)逐看24張／22不同畫面來源，屬作者自查，不能當獨立 Critic。

## 工時與尚未驗收

這次做的是10 Agent-hours上限的整套實作，並非只做LL-00，也不是要求等待滿10小時。帳戶仍A7／B2／Reviewer1，不另加圖片工時。觀測窗含工具等待、不是精確逐片秒錶。r2 Visual已知0.857h只占B的一部分；既有Visual另有早期未量測audit及作者QA，合併B與總帳精確值標unknown，不能宣稱每個cap均已核實或花滿10h。正式雙機由A承擔，沒有再分配B2h。詳見 [工時帳](../../artifacts/evidence/life-loop/budget-ledger.json)及 [迭代日誌](ITERATION_LOG.md)。

仍缺真實iPhone、人工VoiceOver、分齡兒少與10～15分鐘節奏。最大字體固定控制列佔近半屏，事件小角色／固定PNG姿勢與家具風格仍待產品評估；本輪可操作不代表閱讀舒適或正式美術通過。Publishing changes warning發出點未定位，不宣稱零警告、已修復或已有資料毀損。LC-03資料可比性、50～70事件及整體P1／發布Gate均未因本次完成而通過。
