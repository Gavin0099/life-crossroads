# 創作桌：單事件視覺整合預覽

基底：PR #7 `49ead5a85387bb8c54e6677165161dd5e98cfa7f`，分支 `integration/p1-preview-20261024`。本片獨立 Draft PR；不合併、不發布、不整枝移入 Visual WIP。

## 驗收條件

- [x] 正式人生走至13歲 `teen-project`，有共用想像工作室、13歲沐沐與事件中的樹老師。
- [x] 四種實際選擇對應不同道具/反應：線上圖解、紙本圖解、詢問、休息；沒有獲獎或完成作品的保證。
- [x] 回饋取已保存 trace；人物取本次互動、支持取非零效果、運氣只列已發生的機會；延後線索標示尚未發生。
- [x] 數值顯示實際資源差（含上限抵銷），資料缺口不視為0；休息不呈現未參與的老師/支持/運氣。
- [x] 寫入失敗時不出現已執行反應，原檔與選擇頁保持；重試成功後才顯示。
- [x] 同 Seed/選擇重播及 Codable/本機續玩呈現一致；完整人生、分岔與原局不變回歸通過。
- [x] 小螢幕、最大文字可操作；減少動態效果的程式分支不播放轉場（靜態檢視，尚未實機人工驗證），無循環或額外等待；專用 Simulator 測後刪除。

## 操作與紀錄對應

日本家庭一、Seed0，8/10/12歲選休息後走到13歲。分別選四個選項查看對應反應；紙本路線關閉 App 後續玩，應保留同一紀錄。可以從正式回到岔路功能重走13歲，原人生不變。

| 畫面 | 唯一資料來源/界線 |
| --- | --- |
| 道具與活動反應 | 實際 `eventID`/`choiceID`；文字描述選擇的活動，不推定作品完成 |
| 老師 | `changedRelationships` 中 teacher 的本次 event/choice/age 互動；不是只看 recurringPerson |
| 長期變化 | 既有 `outcomeResources` 直接讀 `resourcesAfter - resourcesBefore` |
| 時間/精力/材料 | `finalCost`；只屬本回合，不累積 |
| 故事記憶 | 本次 `recordedStoryFacts.learning`；未知事實不補寫 |
| 他人支持 | `effectSteps` 的 otherPeople 非零變化 |
| 額外機會 | `randomTrial.occurred == true` 且對應 randomness 非零變化 |
| 延後呼應 | `scheduledHooks.count`，明示尚未發生 |
| 不完整環境 | `environmentGaps`，不推論個人設備/服務 |
| 紀錄識別 | event/age/choice/seed，僅 Simulator 的 `-ui-testing` 啟動可讀取原始識別；一般使用/VoiceOver不朗讀這串測試值，不另建存檔或產生新亂數 |

`LifePresentation` 是純投影，`ProjectWorkshopView` 是 SwiftUI 圖形；Domain、Data、Persistence 與其版本不變。原有通用「為什麼」與比較仍在，其他事件保留原畫面。

13歲頁首改用較短的活動摘要，完整原故事仍放在「多讀一點故事」；縮圖留在標題旁，避免角色/場景把第一個可選行動擠出小螢幕。

## 素材與驗收邊界

沿用 App 現有 `StoryCast` 原型，不導入任何候選 PNG。新窗景、書架、工作桌以本 repo SwiftUI shapes 編寫，活動圖示使用平台 SF Symbols；沒有新增第三方下載素材。此 PR 的場景與排版仍待使用者 review，不代表正式美術已選稿。

實機、人工 VoiceOver、10–12/13–15歲理解與吸引力、真人節奏、完整 LC-03 資料 Gate 仍未驗收。最大文字自動測試不替代人工 VoiceOver；Simulator 成功不表示可發布。

## 本機驗證與可 review 證據

- 102個不同 Swift 案例通過：原96個＋新增6個投影案例。完整首跑101個，追加分岔案例後6個投影案例定向重跑；不重複加總。
- 23個 Python 案例及 basic checks 通過。
- 首輪 iOS27.1：11項UI，10過1失敗；失敗發生於首頁收起資料卡後開始人生，尚未進入13歲新事件，原因未確認。保留原結果和UI階層，不宣稱已修好這個間歇問題。Xcode在所有測試完成後另開10分鐘診斷蒐集；只中止該本次裝置的診斷程序，結果包正常結案並保留原失敗。
- 最終版 iPhone SE3 / iOS27.0：3項定向測試全過，包含完整15決策人生/原因/比較、最大文字的真實寫入失敗/檔案不變/重試、四個選後反應/第一屏選項/實際存檔重開。原先失敗的完整人生案例本次通過，仍不能由此推論首輪根因已消失。
- 兩輪共11個不同UI案例有通過紀錄；不是最終版完整11項一次全綠。原局/完整分岔UI回歸在首輪通過；最終版相較首輪只調整呈現與定向測試斷言，核心與存檔未改。遠端最終HEAD全套CI仍須推送後核對。
- 既有寫入失敗提示關閉時的 `Publishing changes from within view updates` 警告仍出現；本次未改GameStore，錯誤提示/畫面/原檔/重試斷言通過，但沒有修復警告根因。
- 兩台專用裝置 `141BDC87-891F-400C-A1FD-866CB5225175`、`02EB4201-0419-4E43-8DDA-B337F33A3F2A` 均已 `simctl delete`，再查庫確認不存在；沒有刪共用runtime或其他任務裝置。

完整案例名稱、兩輪原生結果摘要、原失敗階層、最終程式SHA與清理確認見 [validation.json](../artifacts/evidence/event-visual/validation.json)。原生PNG來源、test identifier、裝置與SHA見 [source-map.json](../artifacts/evidence/event-visual/source-map.json)。

| 原生 Simulator 截圖 | 本次呈現 |
| --- | --- |
| [選前創作桌](../artifacts/evidence/event-visual/workshop-invitation.png) | 第一屏可見行動，完整原文仍可展開 |
| [線上圖解](../artifacts/evidence/event-visual/workshop-invest-committed.png) | 線上經驗、實際成本；延後線索在下方，未宣稱已發生 |
| [紙本練習](../artifacts/evidence/event-visual/workshop-offline-committed.png) | 紙本經驗、老師互動；存讀維持相同結果 |
| [先求助](../artifacts/evidence/event-visual/workshop-ask-committed.png) | 本次詢問，未建立作品經驗；沒有虛構額外支持 |
| [先休息](../artifacts/evidence/event-visual/workshop-rest-committed.png) | 不列老師、支持或機會；可再次尋找起點 |
| [最大文字](../artifacts/evidence/event-visual/workshop-large-text-saved.png) | 隱藏裝飾，文字可捲動，固定繼續按鈕可操作 |

這些是工程與呈現證據，仍待使用者視覺 review、人工 VoiceOver、實機與分齡兒少驗收。
