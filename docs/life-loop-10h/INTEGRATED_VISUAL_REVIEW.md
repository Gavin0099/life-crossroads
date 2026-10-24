# 正式生活循環：Visual B 整合覆核

沿用 PR9 LIFE-LOOP 10H v1.1，整合交付由 Gameplay A 的 Draft PR10 承載。本報告不開新切片、不增加圖片或另一套模擬器。本次 Visual 作者覆核不是獨立 Critic，也不是兒少或實機驗收。

## 凍結來源

正式 App 產品提交：`c445e5f0f9bee48832d0e77463d54777a6a3009f`。Gameplay 已窄整合 B 的裁切、whole-atlas cache 與主角尺寸；`LifeWorldScene.swift` 和 `LifeWorldMotion.swift` 的受測檔案逐位元吻合 B 最終交付。沒有整枝合併歷史 Visual 替代元件，沒有增加角色圖。來源雜湊見 `artifacts/evidence/life-loop-visual/integration/formal-integration-review.json`。

## 覆核結果：工程整合可供 Review，最終美術／遊戲感仍 PARTIAL

Gameplay 正式 App iPhone 17 與 SE3 各 **18/18、零失敗**；兩份有效 xcresult 的摘要均為 Passed。不是先前 renderer 隔離 App 的5/5。兩個原 Xcode 命令均正常退出；只中止已確認屬於本輪的 simctl diagnose 子程序以解除診斷收尾停滯，沒有殺 xcodebuild 或竄改結果包。額外 OS 診斷沒有完整收集，原始 log、程序取樣與操作由 A 留存。

已實際開啟兩機各12張正式原生 PNG，共24個檔案／22個不同圖像雜湊；每機兩張比較頁已在80歲末列，bytes相同，不算兩種額外場景。所有 PNG／來源／測試／裝置／SHA 在 A 的 `artifacts/evidence/life-loop/integrated-native/{standard,se}/manifest.json`，作者覆核清單保存在上述 JSON。20張世界畫面與原 xcresult 匯出檔逐位元一致，另4張比較頁亦逐張開啟。沒有產生新美術素材。

| 畫面 | 兩機目視觀察與範圍 |
| --- | --- |
| `world-childhood-living` | 300pt生活場景中主角明顯放大、完整可見；腳底與陰影合理，沒有整張atlas越界。進度、暫停、加速、跳至事件可見。 |
| `world-se-first-action`／`world-second-real-event` | 事件、代價及行動清楚；17可見三項，SE初屏可見兩項，其餘需捲動。88pt場景中人物仍小，未解決所有時點的角色存在感。 |
| `world-next-living` | 決定後回到大型生活畫面，保留10歲故事記憶。畫面中的樹老師來自已推進的下一事件 inviter，不把其出現解釋為上一個rest選項得到老師支持。 |
| `world-saved-rest-outcome` | 8歲休息線是單人及實際資源變化；沒有額外老師或未發生的協助／作品完成演出。 |
| `world-thirteen-pending-clue` | clock問號符號可見；17機型文字明示還沒發生、不是獲獎或邀請保證。SE同一說明在首屏以下，不能單憑該圖宣稱整段文字首屏可見；完整操作由18項UI套件核對。 |
| `world-seventeen-occurred-echo` | 已觸發呼應與13歲記憶同時呈現；兩機都能讀到17歲邀請，SE已捲至文字所以畫面上緣在導覽列後方，不誤判為原圖裁切壞掉。 |
| 最大字級event／outcome | 文本換行、選項及紙本創作記錄可捲至；SE固定頁尾佔近半屏，閱讀舒適度仍不足。截圖是在捲動中段，不宣稱角色／所有內容能同屏。 |
| `world-reduced-motion-committed` | 保留完整主角及已保存後果符號／內容；沒有因減少動態而失去事實。靜態圖不能證明實機FPS或所有動畫接縫。 |
| 完整後半生比較／80歲末列 | 原局與改選線、前後資源、實際原因入口及回顧不代表死亡說明可讀；其餘完整路線正確性依正式回歸及Domain證據。 |

本次作者目視未發現新增的圖片裁切／場景事實阻擋，但**不給最終美術PASS**：事件期仍是小角色配大量選項卡，最大字級固定操作列偏大；整張PNG仍有固定視線／手勢與簡化家具的風格落差。這些限制與「能否操作」分開，交由使用者判斷本輪方向，未另開修圖迴圈。

## Simulator 與來源收束

B 本次覆核新增裝置為0；先前B的13台再次確認皆不在inventory。A本次正式雙機 `066B070D-30B4-4BF4-928A-B16329E0AD8A`／`156D4064-66BE-4E93-8B14-9C74CCAA85C1` 已delete且由B只讀再確認不存在；沒有動到別人裝置或runtime。A若補測診斷收尾工具，該次新裝置另附收據，不混入這36項完整回歸。

兩份摘要仍各有3筆 SwiftUI「Publishing changes from within view updates」warning；不宣稱零warning、根因已修或存在資料毀損。後續文件與工具提交不自動改變受測App凍結來源。

## 需保留的判斷邊界

- 主流程生活期場景高300pt；一般事件暫停期88pt；輔助使用字級90pt。主角比例放大不能抵消後兩者的高度限制。需分開評估角色存在感及選項可操作性，不能把大場景截圖當全部階段都大。
- 現有角色是整張 PNG，沒有新增手、眼、尾巴分層；角色持有的既有道具不等於引擎記錄了活動成功。真正的後果須由已保存 trace／token／原因呈現。
- Reduce Motion 和背景暫停保留事實，不能因沒有播放動作而刪去已保存後果；尚未實現線索不能畫成已獲得邀請。
- 人工 VoiceOver、實機效能與分齡兒少試玩仍須另列，原生 UI 測試不代替這些證據。
- 共享10 Agent-hours不新增額度；Visual r2 與 B 的未精確量測時段由 A 的總帳標示不確定性，不宣稱精確用滿10小時或所有個別cap已核實。
