# LX-05｜同一夢想，不同機會（交付紀錄）

基底PR #13 `3408463`，獨立分支`codex/lx05-opportunity`，維持Draft/HOLD，不合併或發布。

同樣13歲線上創作，17歲依既有模型準備負擔與家庭支持，提供遠距協作或分段備料共作；25歲的遠距試作／在地製作桌只讀取實際參與紀錄。可用行動、數位依賴、成本與效果都有差異，沒有國籍成功倍率。兩個節點在已有故事承諾時預約接續，降低部分抽選自由度，換取長期呼應；不沿用RNG-V2的舊多樣性數字。

平行比較預設固定家庭模板與條件，進階開關才可換家庭。既有單事件快比標示為快速入口，仍固定前史／資源，不自動代玩另一局。首屏最多三個有實際前因、機會或人物差異的轉折，完整時間軸展開閱讀；晚年關係不會因時間較晚而自動落選。出生頁不再標0歲搭配童年造型，進入按鈕固定可見。

## 版本與限制

- engine=`lx05-opportunity-1`，content=`lx05-opportunity-story-1`，data=`lc03-data-1`。
- **舊引擎存檔不可直接續玩**：拒絕載入並保留原檔，可用原版本續玩；新人生需明確取代。沒有自動遷移或跨版本結果相同的宣稱。
- 國家資料仍只有現有LC-03來源；機會映射是`creative-opportunities-1`遊戲假設。台灣數位口徑不足時保留unknown，不推定特別管道。不同國家仍可有相同路線。
- [64局機制見證](../artifacts/evidence/opportunity/comparison.md)及[機讀紀錄](../artifacts/evidence/opportunity/samples.json)：預先指定Seed34、八國兩家庭四策略、完整15決策。同意圖不等於17／25歲都選同一實際行動。
- 正式美術、國家環境辨識、實機、人工VoiceOver、10～15分鐘節奏與兒少理解／重玩仍待驗收。[本片試玩步驟與空白表](opportunity-playtest.md)可交給真人主持。

## 驗證

完整機讀摘要見[validation.json](../artifacts/evidence/opportunity/validation.json)、[測試嘗試紀錄](../artifacts/evidence/opportunity/test-attempts.json)。原始本機日誌保留於`artifacts/governance/opportunity/`；目前未將遠端CI預記為成功。

|範圍|本輪結果與邊界|
|---|---|
|純Swift|最終`swift test -c release`：128/128，含15呈現、16存檔、91引擎、6量測測試；新增6個機會整合案例|
|Python／基本檢查|35/35及basic PASS；資料生成與CLI契約均覆蓋|
|64局機制見證|八國×兩家庭×四策略、固定Seed34；960次決策、64/64重播；重跑位元組一致；16局紙本策略全部能走至25歲合作桌|
|SE原生首輪|3/3：出生失敗重試／冷恢復、最大字級、日／肯13→17→25機會與快比；App來源74ecdcf|
|標準尺寸原生|1/1：完整原人生＋同模板另一人生、存檔故障恢復、兩側實際資料與展開完整比較；App來源74ecdcf|
|SE敘事補測|1/1：加入13歲前因文案後，重新走日／肯機會鏈、17歲冷恢復與快比；App來源74f8af1|
|清理／警告|本輪建立的三台Simulator全部delete，最終裝置清單查無三台；三次各0筆指定SwiftUI發布警告|

上述為四個不同UI案例、五次執行，不是單批完整29項全過。最後的紙本延續及receipt只列實際因素修正，已在最終128項純Swift回歸；未重跑全部原生案例。工具仍輸出Xcode的operatingSystemBuild解析診斷，不將其宣稱為零警告。當前HEAD的完整CI在推送後另核對。

定向測試還包含：門檻兩側／缺值／沒有指導支持、重新命名與排序不改結果、直接呼叫未解鎖行動被拒絕、實際磁碟各階段存讀、完整平行人生原局不變、偽造機會trace及舊引擎存檔拒絕且不覆檔、真正72歲關係轉折可入首屏。沒有以結果數值相似作為故事相同的判定。

已保留故障證據：首輪新增無支持fixture只改單國家庭，違反同模板一致性，已改成全模板相同條件；舊凍結整局、靜態敘事集合、CLI harness與數位選項白名單預期不適用新模型，改成明示版本拒絕／原檔保留、未改開場fixture與三種時鐘結果一致，未重新生成舊fixture假裝相容。初次完整debug回歸失敗、排隊debug重跑取消與後續release通過分開保存。

## 可覆核畫面

- [SE出身揭曉](../artifacts/evidence/opportunity/se/lx04-birth-reveal.png)、[最大字級](../artifacts/evidence/opportunity/se/lx04-maximum-reader.png)。
- [日本17歲實際邀請](../artifacts/evidence/opportunity/se/lx05-JPN-age-17.png)、[肯亞17歲實際邀請](../artifacts/evidence/opportunity/se/lx05-KEN-age-17.png)。
- [日本25歲試作](../artifacts/evidence/opportunity/se/lx05-JPN-age-25.png)、[肯亞25歲合作桌](../artifacts/evidence/opportunity/se/lx05-KEN-age-25.png)。
- [完整兩人生的摘要比較](../artifacts/evidence/opportunity/standard/lx04-parallel-stories.png)。

圖片來源commit及SHA逐張列於validation.json；共用寓言場景仍非國家實景，這輪沒有新增或核准正式美術。
