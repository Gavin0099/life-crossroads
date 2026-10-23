# UI-08 契約草案：本輪可編譯子集

目的：讓 View 顯示引擎提供的值，避免介面偷算人生規則。
實作來源：`UIPrototype/EventFirst/EventFirstModels.swift`；這些型別只存在於獨立原型 target。
沒有修改、採納或替換主引擎的 API。正式命名與 adapter 待整合審核。

| DTO | 必備意義 | 缺資料行為 |
|---|---|---|
| EventViewDTO | ID、角色/年齡/年份/階段、事件、插圖 ID、選項與狀態 | 沒事件顯空狀態 |
| OptionViewDTO | ID、名稱、成本、支持、不確定性、可用性/原因 | 空陣列停留；不可用不能提交 |
| OutcomeViewDTO | optionID、已發生後果、尚未發生提示、因素、證據標示 | 缺少/ID 不符，留在岔路 |
| TraceFactorViewDTO | ID、參與因素種類、解釋、證據標示 | 不補齊四類因素；空陣列顯沒有紀錄 |
| ComparisonViewDTO | 已選項、固定/變動條件、環境卡、限制 | 沒有可比資料，不能造差值 |
| LifeMapViewDTO | 五階段、目前階段、已發生節點 | 不提前建立未走過的人生紀錄 |

支援狀態是質性 display labels；尚未提供正規數值、資源 delta 或風險機率。需要時由主引擎 adapter 提供。
TraceFactor 的 `evidenceLabel` 目前只是明示的示範依據；正式整合必須加入真實 traceID、來源 ID、版本等，不能把 fixture ID 冒充 Trace。

原型 EventFirstFlow 只管理畫面、已選 ID、fixture 索引與原型歷史：

- 有效選項 → 查既有 OutcomeViewDTO；不計算成本、成功率或後果。
- 重複在非事件狀態提交、未知 ID、不可用選項均不改狀態。
- 下一事件使用下一筆 DTO 的年齡/年份；不在 UI 做年齡加法或環境換算。
- 跨國示例僅第一個事件有資料；第二個事件比較頁顯示無可比資料。
- 暫存歷史只描述原型已做的選擇，不是正式存檔。

正式 adapter 建議接縫：`loadEvent` / `selectOption(eventID, optionID)` / `loadComparison` / `advance`，以明確成功/缺資料回應替換 fixture 查表。
錯誤、非同步、取消、存檔與版本重播契約需要後續整合 slice；本輪不先猜規格。
驗收：原型 target 無 Domain/Data dependency；畫面不以國名分支計算結果；空狀態可觀測。
