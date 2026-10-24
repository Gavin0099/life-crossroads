# LL-07／LL-08：固定世界與真實後果呈現

本地工程已完成，以 PR #10 `b896e05` 為基底，維持獨立 Draft／HOLD、不合併、不發布。正式 App 來源 `d518c3b`；`ce9f6a7` 只修閱讀測試的可視區計算，兩者 App tree 完全相同。遠端結果由推送後新 PR 當前 HEAD 的 checks 與描述提供，本文件不預記成功。

## 玩家看到的改變

- 生活、事件、後果保留同一大型世界，只有下方決策抽屜捲動。一般場景約210～300pt，大字約160～210pt，phase切換不縮成88pt。播放控制為52pt單列，保留系統安全區；大字的次要速度設定收進選單，主要觸控範圍44pt。
- 8歲當次已保存後果顯示紙箱練習／求助紀錄／收好紙箱；13歲按真實記憶顯示線上／紙本／求助／保留時間，17歲只有真正觸發才有呼應。未實現線索明示尚未發生，休息不新增幫手。
- 原本選項下方已有「完整故事與問題」，內容未被刪除。本輪在標題旁增加「閱讀全文」便利入口，完整敘述與問題可捲讀，開關不提交選擇或改存檔。最終截圖前另檢查問題最後一行進入實際可視區。
- 場景說明放在圖片外的一行文字，不遮角色頭部，也不縮角色。仍是跨國共用寓言河畔，不是當地實景；大字的Scene spoken label保留這項區別。

## SwiftUI警告：根因、窄修正及回歸

原PR10三筆警告都在保存故障提示案例。暫時探針記錄到：按「知道了」已把錯誤清為nil，UIKitDialogBridge後續dismiss／reset又經Binding重複寫nil；其中reset在ViewGraph.updateOutputs內，重複觸發@Published。

`bbe8657`只增加共用`dismissError()`的nil guard，未改佈局；原三案例3/3且runtimeWarnings=[]。探針移除後才整合其他改動。[warning-proof.json](../../artifacts/evidence/ll07/warning-proof.json)保留原警告、堆疊與修正後摘要。

`scripts/check-ios-runtime.py`讀真正xcresult，一旦再回報此發布警告即令UI檢查失敗，完整runtime摘要照常保存。已實際拒絕舊警告bundle、接受修正後bundle，並有正／負／空摘要及清理fixture。沒有關閉一般runtime issue蒐集來讓測試過關；可選OS診斷模式維持原設定。此修正針對觀察到的重複nil路徑，不宣稱消除所有未來SwiftUI風險。

## 驗證：來源與批次分開

| 範圍 | 實際結果 |
| --- | --- |
| 純Swift／Python／basic | 111個不同Swift案例、30項Python及basic通過。核心來源未變，含固定Seed、trace、真實磁碟存讀與原局／完整替代後半生回歸。 |
| 最終App：iPhone17 D518 | 四項4/4、runtimeWarnings=[]；8／13四選項、正常／最大文字全文、固定Scene／首屏行動、保存故障與重試。 |
| 最終App：SE D518 | 原四項batch為3/4：場景／選擇／首屏／保存三案例過，閱讀測試錯扣固定24pt安全區而失敗。原summary不改標4/4。 |
| 同App：SE ce9閱讀補測 | 1/1、runtimeWarnings=[]；改讀實際viewport再留8pt，8／13歲一般與最大字級問題末行均可見，關閉後事件／存檔／Scene不變。不縮字、不改文案或App。 |
| 先前3aa／27c定向 | 兩機各6/6、0項此發布警告，包含大字、冷恢復／提示取消與保存故障；其後目視仍抓到SE badge遮頭，故不能拿這批代替最終視覺驗收。 |
| 5ab舊完整20 | 標準機20/20、SE18/20，SE求助及whyResult手勢失敗；不當作新版雙機全21。 |
| 最終原生證據 | 76張選取PNG含歷史批次；每圖標實際commit／test／SHA。最新畫面為標準15＋SE場景11＋SE閱讀4，共30圖，沒有覆寫舊圖。 |
| 清理 | 本輪root17台專用Simulator均delete，最終inventory查無；自己的標準QA checkout保留raw後封存，不動B工作樹、其他裝置或runtime。 |

[機讀批次總表](../../artifacts/evidence/ll07/validation.json)／[未改動邊界與App tree橋接](../../artifacts/evidence/ll07/source-boundary.json)／[清理收據](../../artifacts/evidence/ll07/simulator-cleanup.json)。原始log與xcresult保留本機artifacts/governance/ll07/及artifacts/ios/；各摘要與必要失敗圖已提交供遠端覆核。沒有宣稱兩機最新來源各完整21項本地全套。

## 目視覆核與修正歷史

- B實作129ca19、離線證據2beceb9、計數澄清b4d8780；只窄接Scene，不合併舊原型整枝。Scene SHA256為`ced164aefaa15ec5fd93c49024dd4124209cc1e8cf261442a9c95dce4af313cb`。
- B離線對照為14組來源畫面、11份不同存檔bytes；28PNG、14份存檔及27來源hash已重算。46／74是守衛斷言，並非XCTest數量或14段不同人生；macOS ImageRenderer不代替原生驗收。
- 初報「沒有全文入口」是B與A漏看既有DisclosureGroup的誤判，已撤回；實際為P2導覽問題。新便利入口不宣稱修復不存在的內容遺失。
- 同一獨立Reviewer覆核舊30原生圖判PARTIAL：SE13歲線上／紙本／求助的badge碰頭頂／上耳輪廓，為真正P1。A以57178c5把說明移至圖片外一行，沒有縮角色或改Scene。原圖／manifest與[修正前報告](../../artifacts/evidence/ll07/native/followup-review-before-caption.json)保留。最終增量目視另列，不把舊標準機0P1冒充雙機整體通過。
- 舊13歲AX全文圖只證明問題node可達／label完整，末行未拍全；d518增加底邊可見斷言。SE647pt的末行本在667pt實際視窗內，測試卻誤扣24pt要求635pt，故ce9只修這個測試假設並定向補測。
- 工程歷史亦保留：AX邊界差1.5pt、誤用UIKit命名modifier的編譯失敗（0產品案例）、668標準7/9因頁尾AX86pt失敗及SE主動中止。使用public iOS17 accessibility content shape及正確safe-area背景後，Scene固定、頁尾52pt；1pt／64pt門檻未放寬。手勢按實際target與整列controls定位，保留isHittable／中點限制及32次上限。

## 可直接查看的最終畫面

[SE紙本後果／完整頭部](../../artifacts/evidence/ll07/native/se-caption-final/ll08-thirteen-offline.png)／[SE事件首屏](../../artifacts/evidence/ll07/native/se-caption-final/ll07-event-pinned-world.png)／[SE大字問題末行](../../artifacts/evidence/ll07/native/se-reading-final/ll07-full-event-13-maximum.png)／[標準機事件](../../artifacts/evidence/ll07/native/standard-caption-final/ll07-event-pinned-world.png)。

Xcode開啟LifeCrossroads scheme，首頁啟用生活世界預覽；日本／家庭一／Seed0可看8→13→17的保存後果。選擇前只有情境，保存後才呈現活動物件。自動化存檔checksum只在Simulator測試顯示，不是正式遊戲資訊。

## 邊界與產品缺口

Domain／Data／Persistence、世界DTO／投影、WorldPlayback、Motion、PNG及遊戲版本與b896未變。8歲沒有持久StoryFact，本輪只顯示當次已提交resourceChange，未聲稱跨年記憶。

暖紙UI與幾何道具仍未完全融入插畫筆觸；角色仍是整張PNG，未新增視線、手部或骨架acting。最大字級的標題／全文入口與首屏選項導覽仍須真人閱讀驗收。這是可審查工程改進，不是正式美術、P1或發布完成。

[LL-09操作與空白記錄](LL09_PLAYTEST.md)已準備，沒有真人結果。仍缺真實iPhone、人工VoiceOver、真人10～15分鐘節奏、兒少理解與自發重玩；CI及AI目視不能代替。這輪不是新的十小時大型計畫，不宣稱精確花滿十小時。

## 最終獨立增量覆核

[最終原生專項報告](../../artifacts/evidence/ll07/native/final-incremental-independent-review.json)：同一Reviewer實看11張最新差異圖，連同先前30圖歷史覆核，確認SE三路遮頭P1與最大字級問題末行證據缺口已關閉；這11張未見新P0／P1。Root已重算11張hash，來源吻合。保留三項P2：AX首屏導覽密度、扁平道具與插畫質感差異、角色尚未注意／接觸新道具。這不是重新看遍所有最新圖、雙機最新21/21或正式美術／發布批准。
