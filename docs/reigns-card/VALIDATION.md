# RC-00～02 驗證與宣稱界線

只交付13歲單事件PoC，原版仍預設；`-decision-ui-swipe`或右上「決策方式」啟用。基底PR21 `eb6eff1`，Draft base `codex/final-polish-loop`，未改main／合併／發布／手機安裝。Owner後續審查前不做RC-03～06。

## 程式與測試

- 新增純Presentation `DecisionCardModel`和SwiftUI `DecisionSwipeCard`；CrossroadsView核對事件再交原Store選擇。只有保存後新增同choice trace才承認結果。
- **169個不同Swift測試完整通過**（原163＋新6）；其後只窄修取消後再遇不可行AX request的狀態提示，**6/6模型測試重跑通過**。不將分批加總成175個案例，也不說是最終提交單次全套。
- **51/51 Python通過**，既有測試未刪弱。34個保護檔與基底Git blob完全相同：Domain/Data/Persistence/GameStore/WorldPlayback及原30 UI來源。其他原有測試亦無diff。
- 模型覆蓋：±95.9/±96pt邊界、拖回中心、垂直先行／斜向、非有限輸入、背景取消、重複request、保存失敗可重試、保存前不可ack成功、四ID與亂序、原事件不支援就回退、正式不可行preview不被按鈕／滑動繞過。
- 原生四case：四選項原版/新卡逐項保存SHA與冷恢復；真實左右滑動/未到門檻/垂直捲動；失敗後原卡原檔、背景恢復/模式切換/重試；四替代按鈕44pt/AX labels/正常字首屏與大字可達。

## 原生批次（各有source.json，不能混成單次全過）

|批次|範圍|結果|
|---|---|---|
|round1 SE|初版4case|3 PASS / 1 FAIL，原版紙本按鈕未真正捲入安全區|
|round2 SE|4case＋深色高對比最大字級/ReduceMotion 1case|4/4、1/1 PASS|
|final iPhone17|加入拖卡提示；相同4case＋最大字級1case|4/4、1/1 PASS|
|details-final SE|準備入口44pt／全文定向|兩模式各1/1 PASS；獨立Critic仍找到準備說明錯用P2|
|details-corrected SE／17|修數位說明歸屬、增加非數位反例、最後提示／44pt／sheet|最後來源，兩尺寸各淺色1/1、accessible 1/1 PASS|

原版失敗原因：XCTest `isHittable`會將底欄之外的目標視為可點。新測試改採既有原suite的實際scroll/footer邊界，先捲至未遮擋中心再tap；沒有延長timeout掩蓋，也沒有更改原版按鈕行為。保留原始失敗log／截圖，不把第一次失敗擦掉。

新舊UI同一存檔來源JPN/jpn-1/Seed34，四選擇保存SHA逐項一致且四個結果互異。保存失敗的before SHA不變；冷恢復維持after SHA。畫面切換、手勢取消及捲動不寫入人生。Runtime checker核對SwiftUI publication警告，不能解讀為所有OS/Xcode日誌都沒有警告。

## 獨立覆審找到並修正的P2

詳情頁初版把`BirthStory.creationContext`套到四種選擇，該helper的通用fallback使求助／休息也被說成需要安排設備。修正只在`choice.requiresDigitalAccess`時顯示數位準備說明，其餘保留各自正式成本與不可行理由；不改Data helper。最後原生定向確認invest說明存在、offline/ask/rest沒有數位說明，完整四標題仍可讀、sheet往返不改存檔。原先錯用截圖與兩輪source SHA保留。

## 獨立覆審與限制

[獨立REVIEW](REVIEW.md)由另一Agent檢查源碼及真實兩尺寸圖。完整產品、正式美術、真人VoiceOver、手指仍按著卡片時背景中斷、10～15分鐘節奏、誤滑率與兒少喜好都未驗收。原生背景case是無手指拖動時進背景；拖動中斷另有純模型測試，兩者不混稱。

最大字級可捲至全部四條道路，但第一屏以標題／角色為主；不是大字首屏即可決策。只測Button替代與AX labels，不宣稱手動VoiceOver custom action流程完成。取消立即復位，沒有新增彈簧動畫或時鐘；保存後沿用既有場景演出。

基底配色audit的9項finding仍列於`docs/readability/VALIDATION.md`，本片沒有消除它們。Basic仍exit1：既有session_envelope 92天超90天；5 PASS / drift WARN，沒有改日期、框架或關Gate。遠端CI需按新PR HEAD另核對，不能拿基底CI代用。

A/B先前工作已保存於**本機**`codex/gameplay-ux-ab`、`345869d`，依Owner新方向停止，未推送、未開PR；A/B結果不計入本片Reigns驗證。該工作專用Simulator亦已刪。當前PoC只有此一新Draft交付。

## 證據完整性

`python3 tools/reigns-card/verify-evidence.py` 通過：8個接受批次、兩尺寸四選擇配對保存、90張原生PNG SHA、34個核心保護檔不變。六台本輪專用Simulator均已delete，其他既有裝置保留；見`evidence-verification.json`。歷史失敗／詳情P2批次仍保留，不納入最終接受批次。
