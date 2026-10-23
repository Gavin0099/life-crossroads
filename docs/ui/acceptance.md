# MVP 驗收與證據界線

最新 UI-11／12 增量見 [本輪圖庫](review-11-12.md) 與 [驗證紀錄](../../artifacts/ui-11-12/verification.json)。以下 v1 歷史證據保留。

UI-11／12 驗證：10 個 UI 測試方法均在 iPhone 17／SE 3 通過。首輪兩台各 9 PASS、1 FAIL（測試誤認選單 accessibility label），只修正測試定位後，該方法在兩台補測通過；保留兩份 summary，未聲稱首輪全綠。
另有 8 個實際 Flow 情境／31 項斷言、3 個可被偵測的定點 mutation、25 個既有 Swift 測試、基本檢查與 2 個真實 Simulator 建立／刪除整合測試。50 張原生截圖來自上述執行，逐張來源有紀錄。
比較頁一般／最大文字的測試檢查整段文字 frame 與 footer 的相對位置；兩路回饋、錯配資料、歷史節點及重玩都有可觀測驗證。
人物反應目前是既有情境圖搭配分支心聲與淡入，不是新生成的分支表情或角色動畫。美術與玩家理解仍需後續驗收。
依使用者追加要求，舊有三台本工作線 Simulator 已刪除；後續測試入口每輪建立暫用裝置，成功／失敗後皆刪除並保留外部證據。

依據：使用者提供 UI/UX 計畫、UI-00/01/02/04/06 與本輪 home/DTO 規格；風險 L1。

## 工程與畫面檢查

| 類別 | 預期可觀測行為 |
|---|---|
| 主流程 | 13 歲選項 → 正確 fixture 後果 → 原因 → 比較 → 15 歲下一事件 → 原型回顧 |
| 可選與不可選 | 兩個可選選項提供不同後果/精力標示；不可選有原因且 disabled |
| 缺資料 | 缺事件、選項、後果、原因、比較資料均不編造；缺後果不能推進 |
| 次頁 | 人物/地圖/紀錄能返回原事件，不提交選擇；地圖保留五階段 |
| 可讀性 | 窄螢幕與最大 Dynamic Type 可捲到第二選項並點選；Footer 不覆蓋可點內容 |
| 結構比較 | 三版同事件內容；只有事件首頁是可點主線，研究版不假裝完整功能 |
| 邊界 | 不改 Domain/Data/Package；原型無引擎依賴，不自行推算結果 |

XCTest 的行為 assertion 與原生 screenshot 共同作證；不能只以 Button 存在代替整條 flow。
測試有不合法/不可用狀態、空集合與最大文字邊界；本輪沒有 I/O、存檔、機率或版本遷移行為。

## 已發現與修正

- 首輪多裝置 test 執行未完成，保留 `initial-tests.log` 並中止；不作 PASS 證據。
- 改單裝置驗證後，確定後果頁的父容器 accessibilityIdentifier 覆蓋了子按鈕 ID，測試找不到「查看原因」。移除父層 ID，保留按鈕各自識別。`before-footer-fix.json` 與 focused log 保留；相同完整主流程測試用於修正後回歸。
- 小幅修改主圖為完整情境縮圖，避免狹長裁切截斷角色臉，也進一步將焦點留給選項。
- 前輪 PLAN 新章節的 baseline inventory 未更新，basic 檢查提出 drift；使用既有 refresh 工具同步章節清單。沒有更新治理框架版本或變更 gate 行為。

實際執行命令、結果與裝置，見 `artifacts/ui/verification.json` 和各原始 log。
Xcode 的 `IDESchemeActionSDKRecord invalidDigitCount` 診斷保留，結果以正式 test summary 為準。

## 尚未驗證

- 五秒辨識、選項成本/風險理解、比較頁不排行的兒少理解。
- 10～12 / 13～15 歲對教材感、遊戲感與三版吸引力的主觀判斷。
- 真實 iPhone、實際 VoiceOver 語音與觸控探索；可存取標籤不等同完成 VoiceOver 測試。
- 正式美術、素材商用核准、國家文化真實性、完整人生節奏與正式引擎整合。

以上按 [direction-gate](direction-gate.md) 執行人測與後續整合，不能用 Simulator 或 CI 代替。
