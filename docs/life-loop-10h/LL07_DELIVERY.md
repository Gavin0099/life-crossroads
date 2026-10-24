# LL-07／LL-08：固定世界、真實道具與發布警告修正

狀態：正式App來源 `3aa85b56f5a02ba8a1fe99aa515c918c6f0013fb`；27c5084僅修UI測試footer定位，App tree完全相同。兩機最新定向各6/6、runtimeWarnings=[]，本地工程已完成；推送及遠端CI由最終PR HEAD另行核對，不預記成功。5ab原批次標準機20/20、SE18/20，失敗手勢及截圖保留，不當雙機全過。基於 PR #10 `b896e05` 的有界改進，原PR保持Draft/HOLD；不合併、不發布。

## 玩家看到的改變

事件和後果保留同一大型世界，只有下方決策抽屜捲動；同字級切換生活／事件／後果不再縮圖。一般畫面約210～300pt、大字約160～210pt，依可用高度調整。播放控制只一列52pt，底部系統安全區另保留；大字次要速度設定放選單，主要操作維持44pt觸控範圍。

8歲已保存後果有紙箱練習／求助紀錄／收好紙箱；13歲有線上圖解／紙本練習／找起點／保留時間；17歲只有真正觸發才顯示呼應。待發生線索明示未發生，休息不增加未記錄的幫手。8歲目前沒有持久StoryFact，道具只在該次後果顯示，未聲稱跨年記憶。

暖紙色抽屜與紙帶道具重組既有素材。角色仍是整張PNG的輕量演出，沒有新增眼睛、手部、視線或骨架；不是正式美術完成。河畔仍是跨國共用寓言舞台，並非當地實景。

## 警告根因與實際修正

原PR10三筆警告集中在保存失敗提示案例。暫時探針證實：按「知道了」已清除錯誤，UIKitDialogBridge後續dismiss／reset又經Binding寫入nil；其中reset位於ViewGraph.updateOutputs，重複觸發@Published。

`bbe8657` 只增加 `dismissError()` 的nil guard並共用於提示按鈕與Binding，佈局未變；三個原案例3/3、runtimeWarnings=[]。探針移除後才整合佈局。原始1/1但有1筆warning的基準、堆疊與修正後摘要保留於 [warning-proof.json](../../artifacts/evidence/ll07/warning-proof.json)。

新增 `scripts/check-ios-runtime.py`：讀真正xcresult，一旦回報此發布警告即令UI檢查失敗；完整runtime摘要照常保存。它實際拒絕舊有警告bundle並接受修正後bundle；正／負／空摘要及清理fixture有測試。沒有以關閉一般診斷或忽略warning當修正，可選OS診斷模式仍維持原設定。

## 來源與未改範圍

- A主流程分支 `codex/ll07-world-continuity`；B只窄接Scene，不合併其整條舊原型分支。
- B實作129ca19、離線證據companion2beceb9；Scene SHA256 `ced164aefaa15ec5fd93c49024dd4124209cc1e8cf261442a9c95dce4af313cb`。
- Domain／Data／Persistence、世界DTO／投影、WorldPlayback、Motion、PNG及遊戲版本皆與b896無diff。來源仍是保存成功後的同一Session／Trace；選擇與抽選不由View執行。
- 固定世界取消捲動場景的geometry preference狀態回寫；使用iOS17的[accessibility content shape](https://developer.apple.com/documentation/swiftui/contentshapekinds/accessibility)限定語意範圍，未採UIKit/private橋接。
- 控制列背景不延伸到home-indicator安全區，AX shape限定真正控制範圍；系統安全間隔未刪除，64pt門檻未放寬。

## 驗證與歷史（不互相冒充）

| 證據 | 狀態／範圍 |
| --- | --- |
| 純Swift | 111個不同案例通過，含固定Seed、凍結trace、真實存讀及完整原局／替代人生。 |
| Python | 30項通過，包含真實shell接線、runtime警告負向fixture及失敗清理。 |
| Basic／build-for-testing | 通過；正式App／新UITests可編譯。 |
| isolated nil guard | 三個受影響UI案例3/3、0 runtime warning；不冒充新佈局全套。 |
| 5ab3c97 SE3完整20 | 18過2失敗：新增道具choice.ask與冷恢復whyResult，固定捲動來回；runtimeWarnings=[]，裝置已delete。 |
| 5ab3c97 iPhone17完整20 | 20/20，runtimeWarnings=[]，裝置已delete。 |
| 3aa85b5 iPhone17定向6 | 6/6，runtimeWarnings=[]；包含全文normal/AX、四選項、大字、固定世界、冷恢復與保存故障，專用裝置已delete。 |
| 27c5084 SE3定向6 | 6/6，runtimeWarnings=[]；App與3aa tree相同，測試邊界更嚴，專用裝置已delete，與舊全套分開。 |
| B離線對照 | 14組固定來源畫面、11份不同存檔bytes；28PNG／14份存檔與27來源hash可重算。46／74是守衛斷言數，不是新增XCTest或14段不同人生。 |
| 離線獨立專項覆核 | 無P0／P1，兩項P2：向量道具與插畫筆觸差異、原PNG視線／手部未參與新道具；不代替原生或真人驗收。 |

歷史保留：SE首輪1/2、後續2/3的AX邊界差1.5pt失敗；誤用UIKit命名modifier的編譯失敗（0個產品案例）；改用public content shape後固定世界案例1/1，場景前後240pt。668標準機7/9敗在AX包含34pt安全區，runtimeWarnings=[]；該來源SE批次由A主動中止，exit75，不當20項完成。修正後iPhone17單項1/1，場景前後298.667pt、頁尾52pt。這些來源均不冒充最終20項。

必要原始log／xcresult留在本機 `artifacts/governance/ll07/` 與 `artifacts/ios/`。最終原生summary／逐圖manifest與46張選取PNG在native/，各圖標明實際batch／來源／test／SHA；14台本輪專用Simulator均delete且最終inventory查無。自己的標準QA checkout已保留raw後封存；沒有刪其他任務裝置、工作樹或runtime。

## 真人與產品驗收

[LL-09試玩步驟與空白紀錄](LL09_PLAYTEST.md)已備妥，沒有真人結果。尚缺實機、人工VoiceOver焦點、真人節奏、孩子理解與自發重玩；CI不能代替。正式角色表演與美術語言仍是部分達成，不擴充生圖或人生引擎來掩蓋這些缺口。

本輪不是新的十小時大計畫。先修已確認的工程問題，再用可玩的整合結果供審查；兩機、來源與測試批次據實記錄。完整P1、LC03資料可比性及發布Gate維持原狀。

## 全文入口的覆核更正

B初報『摘要截斷且無全文入口』，A亦漏看下方而採納；獨立Reviewer核對後確認5ab本已保留『完整故事與問題』DisclosureGroup，故撤回原零入口P1判斷。原內容未遺失，實際為選項下方入口不易找到的P2。A保留已完成的標題旁『閱讀全文』便利入口，完整逐段storyText與storyQuestion在原生頁面可捲讀，modal暫停世界；新增審閱過的8／13歲末段與問題literal回歸，在normal/AX讀到底、關閉後比對存檔／事件／場景。不以錯誤判斷宣稱修復了不存在的資料遺失。

3aa也只修測試helper的SE捲動：根據實際target／viewport朝中央短距離、slow且停0.2秒再放手；保留isHittable／中點範圍及32次上限。5ab兩張失敗圖顯示停在目標上下之外，原log反覆正反拖；Scene與可行性沒有被修改來讓測試通過。

## 測試helper的第二次定位更正

3aa SE定向6為1過5敗，原摘要保留history/3aa-se-failed.json。第一次按frame短拖後，仍以worldPause按鈕估頁尾上緣；按鈕內縮讓測試容許中點落進控制列背景，tap沒有作用。27c改讀整列worldPlaybackControls再留8pt，正常SE可視區334～607pt、控制列615～667pt。來源、限制及實際frame在raw log，不把這些測試失敗刪除，也沒有改App可行性讓它過關。

同一App tree f61e36003c7ddc44dfe2ff905809a5a77ac12827串起3aa標準機與27c SE；每張PNG仍標實際執行commit，不把不同批次改標同一次全套。

## 審查入口與操作

- [機讀批次與來源總表](../../artifacts/evidence/ll07/validation.json)／[未改動邊界與App tree橋接](../../artifacts/evidence/ll07/source-boundary.json)／[14台清理收據](../../artifacts/evidence/ll07/simulator-cleanup.json)。
- [SE最終事件](../../artifacts/evidence/ll07/native/se/ll07-event-pinned-world.png)／[最大字級](../../artifacts/evidence/ll07/native/se/ll07-maximum-text-layout.png)／[13歲紙本後果](../../artifacts/evidence/ll07/native/se/ll08-thirteen-offline.png)。
- [標準機最終事件](../../artifacts/evidence/ll07/native/standard-followup/ll07-event-pinned-world.png)／[全文末段與問題](../../artifacts/evidence/ll07/native/standard-followup/ll07-full-event-13-maximum.png)。原5ab完整20圖在native/standard/，未改標為新版全套。
- Xcode開啟LifeCrossroads scheme，首頁啟用生活世界預覽；固定日本／家庭一／Seed0可看8→13→17保存後果。選擇前只看情境，保存後才有活動物件；閱讀全文不提交選擇。UI自動化存檔checksum僅Simulator測試顯示，非正式遊戲資訊。

本輪保持獨立Draft／HOLD，以PR #10分支為base；不改或合併父PR，不發布。遠端檢查以新PR當前HEAD的Actions與PR描述為準，本地文件不先寫遠端成功。
