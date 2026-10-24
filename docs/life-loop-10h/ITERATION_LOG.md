# LIFE-LOOP 10H v1.1 迭代日誌

## R1 / LL-00：基線與衝突隔離

範圍：使用者最新「００」先按 LL-00 執行。只做基線觀測與快照，**R1 尚未完成**；LL-01、VW-01及G1～G6不因本片自動通過。唯一規格仍是本目錄原有四文件，沒有第二套產品計畫。

- 共用規劃：PR #9 `c823c820ceea027215df2d2f46c2c0ac4373c871`，分支 `plan/life-loop-10h-no-schedule`。
- 正式工作分支：`codex/life-loop-gameplay-10h`，從該規劃提交建立；本日誌、產生器與快照同提交，實際提交號見 Git 歷史/交付 PR。
- 程式基底：PR #8 `c136bebf48ae17e24235d9da72d7f9e51b90bf0c`；祖先依次 #6 `4a6e32b` → #7 `49ead5a` → #8 → #9。全部保持 Draft/Open/未合併。
- #6/#7/#8 對應HEAD的CI已成功；#9首次核對仍進行中，狀態見 `baseline-remote.json` 的查詢時間，不預記綠燈。
- 開始時工作樹乾淨；本片不改 `LifeCrossroads/**`、Package、Xcode或UITests。保存檔與統計欄位、版本均不改。

### 正式狀態與入口（規劃基底）

`Home → start/保存 → choosing → choose/保存 → reflecting → 手按下一段/continueLife/保存 → choosing… → ended`。只有保存成功才發布新人生；正式狀態沒有新增生活排程。

| 接縫 | 位置 | 本片處理 |
| --- | --- | --- |
| 真實決策/結果畫面 | `CrossroadsView.swift:228 / :401` | 只定位，不改畫面 |
| 手動走向下一段 | `CrossroadsView.swift:82` | 保留基線；LL-04才處理自然續行 |
| 保存先於發布 | `GameStore.swift:82` | 只讀核對 |
| 選擇/推進命令 | `GameStore.swift:128 / :133` | 不新增自動呼叫 |
| 13歲演出 | `ProjectWorkshopView.swift:6` | 保留既有trace投影 |
| 權威事件/選擇/推進 | `LifeSession.swift:84 / :102 / :110` | 不改引擎 |
| 真實存讀 | `SaveRepository.swift:23 / :32` | 不改schema或檔案 |

### 凍結快照與重跑

`artifacts/evidence/life-loop/baseline-{jpn,twn}-seed0.json` 是既有 `life-demo --environment-samples` 真實運行的家庭一、Seed 0、明列 `investFirst` 策略。保留完整15筆 trace、選項順序及 engine/data/content版本，不只截圖或事件標題。策略遇不可行項目沿既有CLI規則選擇，實際choiceID已逐筆記錄。

版本：engine `lc03-environment-1`、data `lc03-data-1`、content `lc03-environment-story-1`。台灣額外保留實際13歲數位選擇比較及 `environmentGaps`；未知部分不是0，家庭/行動的部分成本不可當作與日本完整成本的國家優劣比較。

在本LL-00原始程式未修改的checkout執行：

```sh
python3 scripts/capture-life-loop-baseline.py
python3 scripts/capture-life-loop-baseline.py --check
swift test -c release
python3 scripts/build-data.py --check
python3 -m unittest discover -s Tests -p 'test_*.py'
bash scripts/governance-check.sh --profile basic
```

`--check` 重跑正式Swift CLI後比對快照的完整位元組，不覆寫快照；原始App/引擎有變動或多出未追蹤程式時會拒絕重新定義基準。後續slice要重現原基準，使用本LL-00提交的獨立checkout；不要把新版輸出覆蓋此處參考。

### 前規劃原型隔離

[`codex/life-loop-01 @65fff9e`](https://github.com/Gavin0099/life-crossroads/tree/65fff9e) 已保留可恢復WIP，沒有開成新版正式實作PR。它的手動續行、progress式播放、新畫水獺與三階段契約，不符合新版的累積動畫相位、自然續行、既有PNG與正式 `LifeWorldFrame` 邊界。可逐項參考保存先發布、trace來源與測試經驗，**不得整枝合併**。

該舊原型的Swift108/Python23、完整UI10/13與最終定向4/5是歷史觀測；三個完整套件失敗在定向已通過，但新「取消」按鈕定位回歸仍失敗，後續斷言未執行。不是新版工程DONE。原始失敗、修正、歸因更正與未解警告見該checkpoint的 `artifacts/evidence/life-loop/`，不混入本片原始基線通過數。

四台前規劃專用Simulator（含中止/失敗）均已刪除，未刪他人裝置或共用runtime；本LL-00不另建Simulator。基線CI通過不替代新版UI、實機或兒少證據。

### 工時與下一步

LL-00本機結果：**DONE；R1=PARTIAL**。Swift102、Python23、data check、basic checks通過；兩份完整快照重新運行後位元組一致；正式App/核心程式diff為空。驗證、檔案SHA及範圍限制見 `artifacts/evidence/life-loop/baseline-validation.json`，不是新玩法/動畫驗收。

LL-00預算0.50 Agent-hour，包含本片基線盤點/隔離/快照；實際觀測窗及上限帳見 `baseline-validation.json`。新規劃Visual及Reviewer尚未開工。前規劃原型是既有輸入，其工作/失敗不冒作本R1交付。

1. LL-01：先凍結只讀 `LifeWorldFrame` / `WorldMomentProjector`，分開真實年齡與視覺蒙太奇，補未發生/未知來源負面測試。
2. 由同一契約提交交接Visual獨立分支；既有PNG微動、外部固定SHA/MIT查核算在Visual2h內。
3. LL-02／04：累積演出時間、暫停/速度連續、Exactly-once與後果自然續行，再驗新版G1～G6；目前均未完成。

## 使用者更正後：接續整套10 Agent-hours（2026-10-24）

先前將「００」解讀為僅LL-00、完成後停下，與完整10h授權不符，已更正。從05:45:15 UTC接續Gameplay現場執行；使用者等待間隔不計主動工作。總帳維持Gameplay7h／Visual2h／Reviewer1h上限，未要求等待滿10h或建立排程。

### R1 / LL-01

- 共用契約提交 `6f5e3c1` 已推至PR #10同分支。新增純Swift LifeWorldFrame / WorldMomentProjector / PresentationMotionFrame，沒有修改Domain、存檔schema或版本。
- 3項實際投影測試通過：choosing沒有未做選擇後果、rest不編造人物或運氣、真實故事記憶/延後線索/已觸發呼應、台灣缺口及ended/restore。
- DTO保留真實年齡，另列visualFromAge；動畫輸入分global elapsed與phase elapsed，Visual不可自建時鐘。
- Visual於05:48:23 UTC起研究固定上游SHA/MIT，收到契約後在獨立worktree及`codex/life-loop-visual-world-10h-r2`實作。未更動其他已存在的Visual工作樹；不整枝合併舊WIP。

### R2～R4 執行中

- 新增純Swift WorldPlayback：注入單調時間、3秒Living／2秒保存後結果、1×／3×、暫停／背景、每phase世代與exactly-once ticket；冷啟動reflecting保持暫停待玩家操作。
- GameStore仍先save再publish。動畫回呼只在identity與generation仍匹配reflecting時呼叫合法continueLife；失敗保持原結果、暫停自動重試。
- 正式Crossroads接scene／事件／結果與可回退開關；說明/比較/岔路/警告/背景及VoiceOver阻止自動續行。未完成UI驗證前不標DONE。
- 原有UI回歸明確用legacy開關；新世界UI另有自然兩事件、存檔失敗、冷恢復、最大文字、完整人生/分岔案例，不混計為同一路徑。
- 新增日本/台灣凍結trace與normal/fast/skip真實磁碟存讀一致性；八國15決策與完整分岔原局bytes保持，結果待本輪測試完成後記錄。
