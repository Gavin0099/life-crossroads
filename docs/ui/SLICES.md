# UI-00～10 採納切片

本輪優先為 UI-00、UI-01、UI-02、UI-04、UI-06。目的、範圍、決策、排除項與驗收分見各連結。
獨立 review 單位不代表必須為每份文件建立分支；本輪 MVP 合併為單一可執行原型分支。

| Slice | 工作 | 本輪狀態 / 依賴 |
|---|---|---|
| UI-00 | [目標](GOALS.md)、[範圍](SCOPE.md)、[入口](README.md) | 文件已落地 |
| UI-01 | [資訊架構](information-architecture.md)、[畫面地圖](screen-map.md) | 文件已落地 |
| UI-02 | [三方向線框](wireframes/README.md) | 三版靜態結構 + 原生研究入口；可點主線為 A |
| UI-03 | 競品/參考結構分析 | 尚未執行一手查核；不從既有印象宣稱完成 |
| UI-04 | [首頁 v1](home-v1.md) | 採事件卡主導，已實作；人工 UX 待驗 |
| UI-05 | 人物/家庭、人生地圖、比較、紀錄次頁規格 | 本輪有最小示範與責任定義；詳細內容/完整資料待整合 |
| UI-06 | EventFirst SwiftUI 可點主流程 | 兩事件 fixture、後果、原因、比較、下一事件與原型回顧 |
| UI-07 | StageHeader 等七元件 | 本輪所需元件已拆分；尚未作全 App 元件庫 |
| UI-08 | [View DTO](view-contract.md) | 原型型別可編譯；正式 Domain adapter 待審核 |
| UI-09 | [可用性檢查](acceptance.md) | 執行小螢幕/大字 Simulator 驗證；實機與 VoiceOver 待驗 |
| UI-10 | [方向 Gate](direction-gate.md) | 預設主方向 A；五秒辨識與 10～15 歲理解/偏好未驗證 |

順序：定義/三版研究 → 首頁/可點流程 → 次頁/正式 adapter → 人類可用性與風格 Gate。
不因原型只有兩事件而縮減主產品的四國完整人生交付或 P1 八國完整人生目標。
每次新增國家、正式素材或引擎接線另按有界 slice 驗收；本計畫不自動授權發布。

## 獨立審查後的順序

使用者已接受五個優先 slices 的工程 MVP，保留 Event-First 為正式候選，先做 UI-11／12，再進 UI-13。

| Slice | 本輪責任與 Gate |
|---|---|
| UI-11 | 頁首狀態、事件/選項配對、可讀頁尾、明確下一步、靜態線框、人生地圖節點；工程回歸見 [本輪證據](review-11-12.md) |
| UI-12 | 一事件兩路角色回應、質性變化、伏筆與下一事件回提；可操作原型供 review，玩家理解 Gate 尚未通過 |
| UI-13 | 待續：單一 LC-02 真實事件 → DTO／後果／Trace，一致性由 Domain 驗證 |
| UI-14 | 待續：兩年齡組、實機、VoiceOver 與預設理解標準；不能以 Simulator 代替 |

契約與腳本：[UI-11／12](ui-11-12.md)。新增量以 `1771c57` 為 review base；不將未合併的整條視覺／UI 分支直接併入 main。
