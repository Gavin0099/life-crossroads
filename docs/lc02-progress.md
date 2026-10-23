# LC-02：四國完整人生實作進度

LC-01 [PR #1](https://github.com/Gavin0099/life-crossroads/pull/1) 的
[遠端 CI](https://github.com/Gavin0099/life-crossroads/actions/runs/39908800771) 通過後，
依使用者「直接展開」的授權接續實作。此片獨立分支，建立在 LC-01 上，未自動合併 PR。

## 這輪實作

- 原生 SwiftUI 首頁，四國與兩家庭選擇、虛構情境說明及短文模式。
- `LifeSession` 純值控制器管理選擇、回饋、時間跳躍與晚年回顧，避免重複點擊套用。
- 15 個原創故事場景涵蓋五個階段，每段三個選項，重用 LC-01 實際成本與後果計算。
- 「為什麼」讀取實際 trace；「換一個環境」固定過去資源、家庭模板、Seed 及相同選擇，只更換情境資料。
- 13、25、45 歲投入後的三條人物回聲；晚年時間軸、四項資源圖與同背景重玩。
- 版面使用可捲動文字、系統字級、VoiceOver 名稱與數字標示，並保留免費休息及回首頁。
- 原生 Xcode project、shared scheme、Simulator UI 測試與 CI，沒有後端或大型美術。

內容版本由 `lc02-skeleton-1` 升為 `lc02-story-1`；資料版本與原始統計保持不變。
家庭及宏觀門檻仍是明示的設計假設。沒有將這兩項統計推成工資、學制、壽命或疾病模型。

## 驗收邊界

LC-02 **仍在開發驗收中**。工程流程可以從出生背景走完 15 決策至晚年回顧，
但尚未完成真實 iPhone、10～15 分鐘節奏、兒少理解與娛樂性的玩家驗證。
偵測到的實體 iPhone 目前離線；沒有將 Simulator build 或自動點擊速度當作實機與遊玩時間證據。

存檔、完整分岔實驗、八國故事、50～70 事件及 LC-07 試玩保持原 slice 邊界。
本版首頁明示關閉 app 後不保存進度。這項限制在 LC-06 接入 SwiftData 後解除。
沒有宣稱可用於正式發布、TestFlight 或 App Store。

工程證據使用 `artifacts/evidence/test-results/lc02-*`；UI 原始結果在本機 `artifacts/ios/` 與 CI artifact。
`swift test` 驗證純 Swift 與八個背景的流程；UI 測試另驗證實際開啟比較、原因說明與 15 次決策到回顧。

畫面審查曾發現比較 sheet 初次開啟沒有四國資料；原先只檢查視窗標題的 UI 測試漏掉此問題。
新增四國列斷言後，在修正前確實失敗。改為使用帶資料的 sheet item，避免兩個 State 分別更新時捕捉舊資料。
修正前的失敗輸出保留；Xcode 27 在測試失敗後反覆 resolve graph，已結束該次本機進程，收據 exit 143，不能把它當作完整正常結束的測試。
