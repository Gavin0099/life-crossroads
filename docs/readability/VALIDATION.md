# iPhone 文字可讀性修正

Owner 2026-10-29 在實機回報看不到字。本片接續 PR21 `45d3ff9`；只修顯示配色，不重開角色／動畫 Loop。

## 原因與改動

深色模式會將 SwiftUI 預設文字變成白色，但 `illustratedPaper` 原為固定的 RGB(0.98, 0.95, 0.88)。SE 原生重現白字／奶油紙，約1.10:1，低於一般文字4.5:1。之前的原生視覺取證沒有涵蓋這個深色模式接縫。

共用色票改為十個具淺／深／提高對比變體的 Xcode Color Set；背景與主／次要文字成對切換。主要按鈕使用獨立深綠底＋白字（按下亦維持對比），避免把深色模式的淺綠連結色當作白字按鈕底。插畫中的紙張／年代標籤固定深墨色＋不透明淺紙，不隨 UI 外觀單獨反白。PNG、美術姿勢與所有人生規則保持原樣。

## 採用的 skill 與準則

使用 Paul Hudson 的 [swiftui-pro](https://github.com/twostraws/SwiftUI-Agent-Skill/blob/main/swiftui-pro/SKILL.md) v2.0.0（MIT），已讀其 design/accessibility 參考，採用共用語意色與適應系統外觀的規則。這輪直接讀取使用，未安裝到全域 skills。

[Apple Dark Mode](https://developer.apple.com/design/human-interface-guidelines/dark-mode) 要求在不同外觀確認文字清楚；一般文字最低4.5:1，自訂小字目標7:1。[Apple Color](https://developer.apple.com/design/human-interface-guidelines/color) 建議自訂色提供深／淺及提高對比變體。比例以 WCAG 2 sRGB 相對亮度公式量測實際 Color Set，沒有以肉眼好看代替對比量測。

## 驗證邊界

- 色票對比、原生畫面及系統可及性對比檢查分開；不宣稱已做完整 VoiceOver 或整款 App 的 WCAG 認證。
- 系統 audit 會把捲出畫面、被固定插畫／底欄蓋住的 AX 文字矩形當成仍然可見，造成假陽性。原始失敗、元素截圖及範圍紀錄保留。最終只排除屬於故事捲動區、矩形不完全位於實際可視範圍內的 static text；可見文字、按鈕等其他 finding 全部保留為 FINDINGS_RETAINED，不能報成 audit PASS。UI capture 測試的 PASS 只代表能操作／取證及存檔不變；對比由色票量測、原生圖與 audit 各自列證。要檢查的選項先完整捲入可視範圍。裁切文字是「未由該次系統 audit 驗證」，不能計入可見文字 PASS。
- `13-before`、`13-ask`、`72-ahe` 都載入既有真實引擎存檔；檢查前後 archive checksum 必須完全相同。出生頁透過正式隨機出生入口產生，只操作專用測試存檔。
- 所有新截圖取證於基底45d3ff9加工作目錄 overlay，每批 `source.json` 保存實際 Swift／色票／測試 SHA；不冒稱截圖來自當時尚未建立的提交。
- 39份 Domain／Data／Persistence／Presentation 檔案對45d3ff9逐byte一致，見 protected-surfaces.json；原本30個UI測試未修改。此次沒有為配色重跑完整人生套件。
- Basic check 保留原有 session_envelope 入冊92日超90日的失敗；不修改日期、框架或Gate，也不宣稱CI全綠。

## 測試診斷歷史

1. 第一個 SE runtime 選擇不相容，在 create 前失敗，沒有取得裝置；改為依 supportedDeviceTypes 選相容 runtime。
2. 新截圖 runner 最初未處理 legacy xctestrun 字典格式，build成功而尚未跑UI；已補格式相容分支。
3. 第一輪選項揭露使用整頁 swipe，無法將固定場景下的選項移到可操作範圍；改用既有視窗內拖曳方法，並要求完整按鈕框位於可視範圍。
4. Native contrast audit 先後暴露被插畫／頁尾遮住的文字矩形假陽性；未更動產品色票來討好 audit，保留失敗原圖與逐項座標，將自動檢查的宣稱限制為完全可見文字。

這些是截圖／audit harness 的修正，不當作多輪產品美術改善。最終的介面差異以 Before/After 原生圖與來源SHA為準。

5. 系統 audit 也回報深色說明頁原生「完成」玻璃按鈕 Contrast failed。元素原圖可讀，但尚未確認系統演算法的判定原因；這項 finding 不被排除，完整保留。為避免在第一個原生工具 finding 就中止後面畫面取證，audit 改為逐畫面保存結果。不能把 capture PASS 說成 audit 全綠。

## 最終本機結果（2026-10-29）

| 項目 | 結果與範圍 |
| --- | --- |
| Python | 51/51 PASS；原48＋3個色票回歸，`python.log` |
| 色票 | 四種外觀、36組前景／底色全部達各自門檻；正文最低10.73:1、次字7.17:1；`contrast.json` |
| 原生capture | SE3與iPhone17，各淺／深／高對比最大字級；6/6 PASS、42張真實App圖，非完整30 UI套件 |
| 保存狀態 | 每批13-before／13-ask／72-ahe前後SHA不變，六批間同一fixture亦一致 |
| 原生runtime | 六批沒有SwiftUI view-update publication warning |
| 原生對比audit | 共保留9項finding，未宣稱全過；逐畫面audit.txt與完整test.log可核對 |
| 保護範圍 | 39份Domain／Data／Persistence／Presentation逐byte不變；原30 UI案例未刪改 |
| Simulator | 含失敗的測試runner診斷在內，11台本次專用裝置均delete，inventory核對不存在；其他裝置/runtime未動 |
| 實機版本 | 開發簽署build及codesign驗證PASS；iPhone Wi-Fi未連線，**尚未安裝這次配色修正** |
| Basic | FAIL：既有session_envelope92日超90日；其餘5項PASS，保留原Gate |

上述可重查結果在 `artifacts/evidence/readability/native-validation.json`、`simulator-cleanup.json`。兩台的source.json綁定實際App／色票／capture測試SHA，全部對應本輪最終檔案。截圖工具的debug失敗不混入6批成功結果。

9項audit finding為：六批說明頁「完成」各一項；SE淺色「閱讀全文」一項；標準尺寸高對比最大字級出生頁兩段底欄附近／畫面外文字兩項。後者沒有套用故事drawer的裁切排除，因此亦原樣保留；log內`visibleFindings`欄名不表示每項都已證明完全可見。目視「完成」與「閱讀全文」可讀，仍不擅自把系統finding關閉。出生頁大字仍需捲動，完整人工VoiceOver及閱讀舒適度待Owner驗收。

## PR 與試玩邊界

修正更新既有Draft PR21，不開新美術Loop、不合併或發布。[前輪CI55](https://github.com/Gavin0099/life-crossroads/actions/runs/40704815462)現已完成：Swift、六組Simulator及iOS聚合成功，Basic因既有期限失敗、advisory略過；這是45d3ff9的結果，不能冒稱本輪新提交CI。新HEAD CI以PR的實際執行狀態為準。

本輪結論是已修復可重現的深色白字／奶油底缺陷，具原生改善證據；不是整款App正式美術、所有無障礙、兒少娛樂性或90–95%產品完成驗收。下一步是把修正版裝回Owner iPhone確認實際閱讀體驗。
