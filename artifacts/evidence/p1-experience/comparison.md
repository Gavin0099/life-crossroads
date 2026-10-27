# 八國人生體驗：最終量測

版本：`p1-experience-1`／`p1-experience-story-1`，重心規則 `life-focus-2`。8國×2虛構家庭×4策略×Seed 0…15＝**1,024局**。每局15選擇，全部完成、重新存讀重播一致；**52／52事件**都有實際出現見證。

| 策略 | 局數 | 同家庭同策略各組Seed兩兩差異中位數範圍 | 至少兩種具前因的可行延續規則 | 健康滿100：focus1→focus2 | 人際滿100：focus1→focus2 |
| --- | --- | --- | --- | --- | --- |
| 投入／準備 | 256 | 8～8 / 15 | 222 / 256 | 0 → 0 | 0 → 0 |
| 支持／關係 | 256 | 7～8 / 15 | 96 / 256 | 0 → 0 | 128 → 0 |
| 休息／恢復 | 256 | 9～9.5 / 15 | 64 / 256 | 256 → 0 | 0 → 0 |
| 混合 | 256 | 9～9 / 15 | 160 / 256 | 0 → 0 | 0 → 0 |

每組16 Seed＝120對，64組共7,680對；不混不同家庭或策略算差異。連結計數是**曾開放且當時可行**，不是玩家已接受／完成；`connections.livesAccepting`另列實選。全休息策略會拒絕延續，不能宣稱它完成兩條故事。差異為事件ID，不等於情感或娛樂差異。

focus1→focus2使用相同1024格與策略（內容、環境規則相同）；唯一平衡改變是生活重心不再每段自動額外加點，保留完成區間與故事機會。這批次最終四資源都沒有100，不代表所有Seed或玩法永不飽和。原focus1摘要與SHA保存在本目錄，完整中間輸出保留本機治理證據。

## 實際不同的後續

- **工具／Seed2／家庭一**：日本45歲使用工作檯，65歲接續工作檯合作；肯亞45歲準備可攜工具，65歲走手動工具支援。電力取得資料只映射本遊戲準備規則，不推論每個人的供電可靠度；離線工具不讀網路率。
- **照顧／Seed11／家庭一**：日本45歲預留看診準備，72歲核對預留安排；肯亞45歲先與小澄列出共同準備，72歲核對共同安排。自付占比映射虛構材料負擔，沒有推論治療成效或個人實際帳單。
- 兩組配對都檢查家庭全部實際條件相等（排除ID、國碼與顯示名稱），同Seed、同策略及人生時序；不同路線容許不同實選。完整實際trace在`summary.json.pairedEnvironmentWitnesses`，不能把全人生差異全歸因單一指標。
- 創作13→17→25鏈沿用PR14已核對實作及新版本回歸。國名更換、家庭零支持高技能、資料缺失的反例仍測試。

## 沒有藏起來的結果

0…15樣本中，`adult-support-revisit`出現176次（ask112／rest64），`later-rest-circle-invite`出現16次（visit16），**沒有接受returnHelp或adaptedPlace**。這代表抽中節點與形成所需前史是兩回事，不能只用事件覆蓋52／52宣稱每條延續普遍發生。獨立完整人生另外找到Seed16及28的可行實選，正式Seed17／63回歸確認後續求助／休息不會抹掉已獲得的支持與已試步調。未為提高數字強制插入事件；真人是否容易感受到這些延續待驗。

## 重現與資料

```sh
swift build -c release
.build/release/life-demo --experience-audit --seed-count 16 > /tmp/life-experience-audit.json
python3 scripts/summarize-experience.py /tmp/life-experience-audit.json /tmp/life-experience-summary.json --catalog LifeCrossroads/Data/Resources/catalog.json
```

`audit.json.gz`解壓後為所有1024局機讀原始資料；`summary.json`包含64組統計、來源SHA及兩組完整trace。策略明確列在兩檔`policyDescription`，並非每局都固定invest。`screenshots.json`綁定SE正式測試截圖；不拿先前版本畫面冒充本版。

僅為有限工程樣本。8國資料完整性、真人10～15分鐘／自發重玩／啟發性、正式美術與完整實機VoiceOver尚未通過；沒有90～95%產品完成度結論。
