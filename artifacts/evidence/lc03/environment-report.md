# LC-03 八國環境：執行比較

八國16虛構家庭×4明列策略×Seed0/3（3為0～15搜尋中的照顧呼應見證）；實際抽中事件的同選擇快照比較固定前史/資源/Seed/家庭模板。台灣未知成本不作定量結論；完整各國人生另保留實際後續選擇，不能歸因於國籍或一項改選。不是娛樂性、教育效果、實機或全球抽樣證據。

128局（8國×2家庭×4既有明列策略×Seed0/3）完成至80歲；同版本同選擇重播與Codable恢復由CLI逐局比對。策略定義、完整選擇及故事見同名JSON；完整trace見壓縮原始檔/CI artifact。

## 相同事件與行動的快照比較

固定實際事件、選前狀態、前史、Seed及家庭模板。此表不會把台灣未知成本記作0；CHE/GDP只作背景，沒有推導個人服務或成功率。

### 8歲 / child-interest / invest / Seed 0

|國家|時間/精力/材料|可行性|實際可行替代|
|---|---|---|---|
|TWN|1/2/1|可安排|ask、rest|
|JPN|1/2/1|可安排|ask、rest|
|USA|1/2/1|可安排|ask、rest|
|DEU|1/2/1|可安排|ask、rest|
|IND|1/2/1|可安排|ask、rest|
|BRA|1/2/1|可安排|ask、rest|
|VNM|1/2/1|可安排|ask、rest|
|KEN|1/2/1|可安排|ask、rest|

支持由實際家庭安排計算，來源及假設列於JSON的support/sourceRules；不是按國籍給支持倍率。

### 13歲 / teen-project / invest / Seed 0

|國家|時間/精力/材料|可行性|實際可行替代|
|---|---|---|---|
|TWN|未估完整成本（非0）|不作跨國判斷|offline、ask、rest|
|JPN|3/2/1|可安排|offline、ask、rest|
|USA|2/2/1|可安排|offline、ask、rest|
|DEU|2/2/1|可安排|offline、ask、rest|
|IND|3/2/1|可安排|offline、ask、rest|
|BRA|3/2/1|可安排|offline、ask、rest|
|VNM|3/2/1|可安排|offline、ask、rest|
|KEN|4/2/2|可安排|offline、ask、rest|

支持由實際家庭安排計算，來源及假設列於JSON的support/sourceRules；不是按國籍給支持倍率。

### 39歲 / adult-care / invest / Seed 0

|國家|時間/精力/材料|可行性|實際可行替代|
|---|---|---|---|
|TWN|未估完整成本（非0）|不作跨國判斷|ask、rest|
|JPN|2/2/1|可安排|ask、rest|
|USA|2/2/1|可安排|ask、rest|
|DEU|2/2/1|可安排|ask、rest|
|IND|2/2/3|本回合預算不足|ask、rest|
|BRA|2/2/2|可安排|ask、rest|
|VNM|2/2/2|可安排|ask、rest|
|KEN|2/2/2|可安排|ask、rest|

支持由實際家庭安排計算，來源及假設列於JSON的support/sourceRules；不是按國籍給支持倍率。

### 72歲 / middle-support / invest / Seed 3

|國家|時間/精力/材料|可行性|實際可行替代|
|---|---|---|---|
|TWN|未估完整成本（非0）|不作跨國判斷|shareShift（家庭試算）、ask、rest|
|JPN|2/2/1|可安排|shareShift、ask、rest|
|USA|2/2/1|可安排|shareShift、ask、rest|
|DEU|2/2/1|可安排|shareShift、ask、rest|
|IND|2/2/3|本回合預算不足|ask、rest|
|BRA|2/2/2|可安排|shareShift、ask、rest|
|VNM|2/2/2|可安排|shareShift、ask、rest|
|KEN|2/2/2|可安排|shareShift、ask、rest|

支持由實際家庭安排計算，來源及假設列於JSON的support/sourceRules；不是按國籍給支持倍率。

## 實際後續路線

|國家/家庭|策略|前因選擇|後續照顧情境|
|---|---|---|---|
|BRA/bra-1 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|BRA/bra-1 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|BRA/bra-2 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|BRA/bra-2 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|DEU/deu-1 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|DEU/deu-1 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|DEU/deu-2 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|DEU/deu-2 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|IND/ind-1 Seed0|investFirst|39歲 ask|本局未抽中；不編造呼應|
|IND/ind-1 Seed3|investFirst|39歲 ask|本局未抽中；不編造呼應|
|IND/ind-2 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|IND/ind-2 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|JPN/jpn-1 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|JPN/jpn-1 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|JPN/jpn-2 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|JPN/jpn-2 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|KEN/ken-1 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|KEN/ken-1 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|KEN/ken-2 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|KEN/ken-2 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|TWN/twn-1 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|TWN/twn-1 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|TWN/twn-2 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|TWN/twn-2 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|USA/usa-1 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|USA/usa-1 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|USA/usa-2 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|USA/usa-2 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|VNM/vnm-1 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|VNM/vnm-1 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|
|VNM/vnm-2 Seed0|investFirst|39歲 invest|本局未抽中；不編造呼應|
|VNM/vnm-2 Seed3|investFirst|39歲 invest|72歲 middle-support-reciprocal|

不是每局必定遇到後續事件；先前選擇可能改變候選資格/權重與選項。各路後續另有選擇及運氣，不作單一原因歸因。

## 未完成驗收

- 台灣全人口數位與不含商保理賠的WHO口徑自付資料仍缺；八國可玩不等於所有成本可定量比較。
- 共用寓言故事不宣稱完整重現各國制度；在地內容、實機、人工VoiceOver、兒少理解與10～15分鐘節奏待驗收。
- 舊版存檔因引擎/資料/內容版本變更會明確拒絕，原檔保留；未交付自動遷移。
