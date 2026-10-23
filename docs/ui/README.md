# 《人生岔路》UI/UX 重構工作線

2026-10-23。依本輪使用者提供的整體 Plan + Slices，先交付 UI-00、01、02、04、06。
目標是把操作焦點移到「事件 → 選擇 → 後果 → 原因/比較 → 人生推進」。
「目前像紙本故事/人生報表」是使用者的產品判斷；尚未由五秒辨識或兒少研究證明。

## 直接 review

- [首頁與互動截圖](review.md)
- [三種結構線框](wireframes/README.md)
- [首頁 v1 規格](home-v1.md)
- [View DTO 與接線邊界](view-contract.md)
- [驗收紀錄與待測項](acceptance.md)
- [完整 UI-00～10 切片與目前狀態](SLICES.md)

執行 `UIPrototype/EventFirst.xcodeproj` 的 `EventFirst` scheme。
`EventFirstView.swift` 包含事件首頁、兩種結構研究、最大字級、沒有事件資料的 `#Preview`。
一般啟動只有事件主導流程；另兩版用於結構比較，不作長期產品模式。

本線從已公開視覺分支 `2b62a19` 建立 `codex/ui-event-first-v1`，保留既有角色候選與舊原型。
純 Swift 引擎、資料與主工作目錄由原工作線持有，這裡不修改。
Demo 只有兩個人生事件，並非 LC-02 四國完整人生或 P1 全部驗收。
