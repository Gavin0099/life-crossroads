# RNG-01～04：可重播的人生事件導演

來源：使用者 2026-10-23 的明確實作要求。這是獨立原創 Swift 實作；參考作品只提供一般排程問題，不移植程式、劇情、資料或素材。

## 現有差異與範圍

基底 ad773f9：`LifeSession` 依陣列位置固定走15個事件，catalog限制年齡嚴格遞增，state限制每eventID只能決策一次。已有固定KeyedRandom、真實成本與ConsequenceTrace、三條歷史分岔及延遲hook，沒有事件候選排程或獨立人物facts。

新增 `EventCatalog`、`EventEligibility`、`WeightedEventSelector`、`EventDirector`、`DirectedLifeSession`；原本固定 `LifeSession` 保留。Directed catalog 包含原模型、具有年齡窗的事件定義，以及15個重要人生slot。每slot選一個事件，維持五階段、15次決策、晚年回顧。少量新增內容不代表50～70個事件完成。

## 執行契約

- Definition ID是內容身分；occurrence ID是這次發生身分，包含語意slot、eventID與次數。相同definition重複仍只計一則內容。
- 資格條件皆為AND：年齡窗、實際國家指標、家庭安排、四項資源、人物關係fact及歷史選擇。不存在的指標或fact不能被猜成通過。國名沒有成功權重。
- policy的maxOccurrences=1是一次性；nil是可重複；cooldownYears邊界為age-lastAge >= cooldownYears。互斥group阻止同組其他definition，再次同definition仍按repeat與cooldown處理。
- 每個事件的年齡窗保留至少一個適齡、離線、無材料成本、無條件限制的求助選項，其時間／精力在所有可用家庭的回合額度內。免費休息另行保留。既有StoryBranch可能隱藏的選項ID不計入保證求助／休息，避免定義看似有選項、實際投影卻移除唯一退路。
- 延遲hook保存來源選前資源，搭配來源前決策歷史重建當時的角色／故事projection；不用今天的資源重寫過去。完整session重播核對快照真實。原有4年後、最晚100歲的規則保留；100歲無法再安排未來hook，因此catalog拒絕該slot可選且會排新hook的定義。
- 人物fact僅由已套用choice的顯式relationshipEffect產生／撤銷，保存origin occurrence與choice；不解析故事文字。條件可控制後續事件及可用choice，免費休息不受限制。
- 權重為正整數，累積溢位或超過Double精確整數上限時拒絕；候選按語意ID排序，以slot＋age＋selector版本的固定KeyedRandom抽一次。無共享亂數序列，其他channel抽樣不改此抽樣。後果保留既有eventID＋實際年齡＋channel key；每slot年齡嚴格遞增，所以repeat也不需加入全域次數改動配對亂數。
- 選事件trace記錄每個候選的實際條件檢查、排除理由、權重、候選總權重、key/draw及入選ID。空池明確失敗；15個slot都有不受條件限制的專用fallback，該fallback也參加正常抽選，使用條件集合是否為空不偷偷更換結果。
- 選定offer之後preview不能重新抽事件。跨國比較保持offer與choice，重驗當地eligibility；不符合時回傳不可比較，不能改選另一事件。事件合格但原選項成本或條件不符時仍能比較，其後果trace明確applied=false，不會消耗資源。
- 後果繼續由DecisionResolver運算，包含實際選項條件與人物fact變動；入選機會與後果機會分層記錄。
- Directed state仍使用同一LifeState；新增director metadata與occurrence-aware history/hook。legacy state版本lc02-3不改；directed state使用lc02-3+director-1，director及event catalog版本另外固定。舊引擎即使忽略新增欄位也會拒絕directed版本，不能錯當舊模式。沒有相符directed catalog不能解析directed state。
- Directed session的restore驗證以固定seed和記錄的選擇重播，核對完整state／offers／traces／jumps；錯版本、偽造facts／occurrence／選擇或資源拒絕。純Codable decode只是解析，不代表驗證。

## 驗證與整合

RNG-01：每種條件正反例與邊界；非法輸入明確失敗。RNG-02：排序不變、同seed、once/repeat/cooldown/mutex、空池、權重溢位。RNG-03：實際選擇建立人物fact，後續事件／選項改變，延遲hook恰一次。RNG-04：固定seed批次紀錄eligible與selected分母、覆蓋、重複率、所有可用背景可到回顧；含低資源、不同策略及序列化續玩。

LC-03的同選擇比較沿用既有指標與家庭模板；TWN資料仍blocked。LC-04可使用director版本、slot及occurrence重播，未宣稱完整改選UI或SwiftData完成。LC-05後續以相同API擴充內容，新增內容前仍需適齡及來源檢查。這輪不新增發布或合併授權，也不宣稱真人遊戲感驗收。
