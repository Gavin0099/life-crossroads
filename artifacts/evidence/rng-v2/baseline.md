# 人生批次量測

固定四國、每國兩個虛構家庭、明列策略與Seed的模型批次；不是全球分布、真實事件率、現實因果或娛樂性證明。0次只表示本批次未觀察到，不能據此判定不可達。首次到100指記錄到的初始、跳躍後或決策後狀態；跳躍中沒有逐年觀測。

引擎 `lc02-4`；內容 `lc02-story-4`；資料 `lc01-data-2`；分析 `lc05-analysis-1`。
樣本：1024 局；Seeds：[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]；策略版本：lc05-policies-1。

事件距離只計不同event ID；故事距離另計同事件的變體。0距離包含在完整配對中。資源值不合成人生分數。

## 分群總覽

| 家庭 | 策略 | 事件路線數 | 事件差異中位數 | 完全相同率 | 健康最終100 | 財務安全最終100 | 人際關係最終100 | 技能最終100 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| jpn-1 | 投入優先 | 26 | 3.0 | 6/496 (1.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 32/32 (100.0%) | 0/32 (0.0%) |
| jpn-1 | 求助優先 | 25 | 3.0 | 9/496 (1.8%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-1 | 休息優先 | 21 | 3.0 | 16/496 (3.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-1 | 穩定亂數多樣選擇 | 25 | 3.0 | 8/496 (1.6%) | 0/32 (0.0%) | 0/32 (0.0%) | 8/32 (25.0%) | 0/32 (0.0%) |
| jpn-2 | 投入優先 | 27 | 3.0 | 5/496 (1.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 5/32 (15.6%) | 0/32 (0.0%) |
| jpn-2 | 求助優先 | 19 | 2.0 | 17/496 (3.4%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-2 | 休息優先 | 15 | 2.0 | 37/496 (7.5%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-2 | 穩定亂數多樣選擇 | 23 | 3.0 | 11/496 (2.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-1 | 投入優先 | 26 | 3.0 | 6/496 (1.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 32/32 (100.0%) | 0/32 (0.0%) |
| usa-1 | 求助優先 | 25 | 3.0 | 9/496 (1.8%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-1 | 休息優先 | 21 | 3.0 | 16/496 (3.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-1 | 穩定亂數多樣選擇 | 25 | 3.0 | 8/496 (1.6%) | 0/32 (0.0%) | 0/32 (0.0%) | 8/32 (25.0%) | 0/32 (0.0%) |
| usa-2 | 投入優先 | 27 | 3.0 | 5/496 (1.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 5/32 (15.6%) | 0/32 (0.0%) |
| usa-2 | 求助優先 | 19 | 2.0 | 17/496 (3.4%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-2 | 休息優先 | 15 | 2.0 | 37/496 (7.5%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-2 | 穩定亂數多樣選擇 | 23 | 3.0 | 11/496 (2.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-1 | 投入優先 | 26 | 3.0 | 6/496 (1.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 32/32 (100.0%) | 0/32 (0.0%) |
| ind-1 | 求助優先 | 25 | 3.0 | 9/496 (1.8%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-1 | 休息優先 | 21 | 3.0 | 16/496 (3.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-1 | 穩定亂數多樣選擇 | 25 | 3.0 | 8/496 (1.6%) | 0/32 (0.0%) | 0/32 (0.0%) | 8/32 (25.0%) | 0/32 (0.0%) |
| ind-2 | 投入優先 | 27 | 3.0 | 5/496 (1.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 5/32 (15.6%) | 0/32 (0.0%) |
| ind-2 | 求助優先 | 19 | 2.0 | 17/496 (3.4%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-2 | 休息優先 | 15 | 2.0 | 37/496 (7.5%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-2 | 穩定亂數多樣選擇 | 23 | 3.0 | 11/496 (2.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-1 | 投入優先 | 26 | 3.0 | 6/496 (1.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 32/32 (100.0%) | 0/32 (0.0%) |
| ken-1 | 求助優先 | 25 | 3.0 | 9/496 (1.8%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-1 | 休息優先 | 21 | 3.0 | 16/496 (3.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-1 | 穩定亂數多樣選擇 | 25 | 3.0 | 8/496 (1.6%) | 0/32 (0.0%) | 0/32 (0.0%) | 8/32 (25.0%) | 0/32 (0.0%) |
| ken-2 | 投入優先 | 27 | 3.0 | 5/496 (1.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 5/32 (15.6%) | 0/32 (0.0%) |
| ken-2 | 求助優先 | 19 | 2.0 | 17/496 (3.4%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-2 | 休息優先 | 15 | 2.0 | 37/496 (7.5%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-2 | 穩定亂數多樣選擇 | 23 | 3.0 | 11/496 (2.2%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |

## jpn-1／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |  |
| teen-repair-table | 21 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | made-a-project: 0/32 (0.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | shared-care-contacts: 0/32 (0.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 19/19 (100.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 0/10 (0.0%) |
| child-library-map | invest | 10 | 10 | 10/10 (100.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 0/13 (0.0%) |
| child-transition | invest | 13 | 13 | 13/13 (100.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | invest | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 10 | 10 | 0/10 (0.0%) |
| middle-garden-table | invest | 10 | 10 | 10/10 (100.0%) |
| middle-garden-table | rest | 10 | 10 | 0/10 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 8 | 8 | 0/8 (0.0%) |
| middle-rhythm | invest | 8 | 8 | 8/8 (100.0%) |
| middle-rhythm | rest | 8 | 8 | 0/8 (0.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 32/32 (100.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 32 | 32 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 32/32 (100.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | leadWorkshop | 32 | 32 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 11 | 11 | 0/11 (0.0%) |
| teen-launch | invest | 11 | 11 | 11/11 (100.0%) |
| teen-launch | rest | 11 | 11 | 0/11 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 10 | 10 | 0/10 (0.0%) |
| teen-repair-table | invest | 10 | 10 | 10/10 (100.0%) |
| teen-repair-table | rest | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | ask | 11 | 11 | 0/11 (0.0%) |
| teen-shared-kitchen | invest | 11 | 11 | 11/11 (100.0%) |
| teen-shared-kitchen | rest | 11 | 11 | 0/11 (0.0%) |

相鄰相同行動類型：248/448 (55.4%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |
| 財務安全 | 0/43 (0.0%) | 0/43 (0.0%) | 0/113 (0.0%) |
| 人際關係 | 135/461 (29.3%) | 114/461 (24.7%) | 390/1318 (29.6%) |
| 技能 | 0/363 (0.0%) | 0/363 (0.0%) | 0/1306 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/96 (0.0%) | 0/96 (0.0%) | 0/192 (0.0%) |
| 技能 | 0/96 (0.0%) | 0/96 (0.0%) | 0/96 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## jpn-1／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 19/19 (100.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 32/32 (100.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 10/10 (100.0%) |
| child-library-map | invest | 10 | 10 | 0/10 (0.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 13/13 (100.0%) |
| child-transition | invest | 13 | 13 | 0/13 (0.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | invest | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 14 | 14 | 14/14 (100.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 18/18 (100.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 0/18 (0.0%) |
| middle-support | ask | 32 | 32 | 32/32 (100.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 32/32 (100.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 32/32 (100.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 18 | 18 | 18/18 (100.0%) |
| teen-launch | invest | 18 | 18 | 0/18 (0.0%) |
| teen-launch | rest | 18 | 18 | 0/18 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 14 | 14 | 14/14 (100.0%) |
| teen-shared-kitchen | invest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | rest | 14 | 14 | 0/14 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 技能 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## jpn-1／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 17/32 (53.1%) | 17/32 (53.1%) |  |
| child-wind-team | 12 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | windmill-promise: 32/32 (100.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 32/32 (100.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 19/19 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 32/32 (100.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 13/13 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 15 | 15 | 0/15 (0.0%) |
| child-library-map | invest | 15 | 15 | 0/15 (0.0%) |
| child-library-map | rest | 15 | 15 | 15/15 (100.0%) |
| child-transition | ask | 17 | 17 | 0/17 (0.0%) |
| child-transition | invest | 17 | 17 | 0/17 (0.0%) |
| child-transition | rest | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 13/13 (100.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 32/32 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 19/19 (100.0%) |
| middle-garden-table | ask | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 18/18 (100.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 32/32 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 32/32 (100.0%) |
| teen-launch | ask | 18 | 18 | 0/18 (0.0%) |
| teen-launch | invest | 18 | 18 | 0/18 (0.0%) |
| teen-launch | rest | 18 | 18 | 18/18 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | invest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | rest | 14 | 14 | 14/14 (100.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## jpn-1／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 16/32 (50.0%) | 16/32 (50.0%) |  |
| child-wind-team | 12 | 20/32 (62.5%) | 4/32 (12.5%) | 4/20 (20.0%) | windmill-promise: 12/32 (37.5%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) |  |
| teen-repair-table | 21 | 16/32 (50.0%) | 6/32 (18.8%) | 6/16 (37.5%) | made-a-project: 16/32 (50.0%); repair-practice: 2/32 (6.2%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 10/32 (31.2%) | 6/32 (18.8%) | 6/10 (60.0%) | shared-care-contacts: 22/32 (68.8%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 5/19 (26.3%) |
| adult-balance | invest | 19 | 19 | 7/19 (36.8%) |
| adult-balance | rest | 19 | 19 | 7/19 (36.8%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 32 | 32 | 6/32 (18.8%) |
| adult-learning | invest | 32 | 32 | 13/32 (40.6%) |
| adult-learning | offline | 32 | 32 | 7/32 (21.9%) |
| adult-learning | rest | 32 | 32 | 6/32 (18.8%) |
| adult-neighbor-market | ask | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | invest | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | rest | 13 | 13 | 5/13 (38.5%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 12 | 12 | 3/12 (25.0%) |
| child-library-map | invest | 12 | 12 | 5/12 (41.7%) |
| child-library-map | rest | 12 | 12 | 4/12 (33.3%) |
| child-transition | ask | 16 | 16 | 5/16 (31.2%) |
| child-transition | invest | 16 | 16 | 7/16 (43.8%) |
| child-transition | rest | 16 | 16 | 4/16 (25.0%) |
| child-wind-team | ask | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | invest | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | rest | 4 | 4 | 0/4 (0.0%) |
| later-pass-on | ask | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | invest | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | rest | 13 | 13 | 7/13 (53.8%) |
| later-reconnect | ask | 32 | 32 | 7/32 (21.9%) |
| later-reconnect | invest | 32 | 32 | 15/32 (46.9%) |
| later-reconnect | rest | 32 | 32 | 10/32 (31.2%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-voice-booth | ask | 19 | 19 | 7/19 (36.8%) |
| later-voice-booth | invest | 19 | 19 | 5/19 (26.3%) |
| later-voice-booth | rest | 19 | 19 | 7/19 (36.8%) |
| middle-garden-table | ask | 11 | 11 | 3/11 (27.3%) |
| middle-garden-table | invest | 11 | 11 | 2/11 (18.2%) |
| middle-garden-table | rest | 11 | 11 | 6/11 (54.5%) |
| middle-open-desk | ask | 6 | 6 | 1/6 (16.7%) |
| middle-open-desk | invest | 6 | 6 | 2/6 (33.3%) |
| middle-open-desk | rest | 6 | 6 | 3/6 (50.0%) |
| middle-rhythm | ask | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | invest | 15 | 15 | 5/15 (33.3%) |
| middle-rhythm | rest | 15 | 15 | 10/15 (66.7%) |
| middle-support | ask | 32 | 32 | 10/32 (31.2%) |
| middle-support | invest | 32 | 32 | 11/32 (34.4%) |
| middle-support | rest | 32 | 32 | 9/32 (28.1%) |
| middle-support | shareShift | 10 | 10 | 2/32 (6.2%) |
| middle-turn | ask | 32 | 32 | 7/32 (21.9%) |
| middle-turn | invest | 32 | 32 | 4/32 (12.5%) |
| middle-turn | offline | 32 | 32 | 10/32 (31.2%) |
| middle-turn | rest | 32 | 32 | 11/32 (34.4%) |
| teen-direction | ask | 32 | 32 | 7/32 (21.9%) |
| teen-direction | invest | 32 | 32 | 6/32 (18.8%) |
| teen-direction | leadWorkshop | 14 | 14 | 4/32 (12.5%) |
| teen-direction | offline | 32 | 32 | 5/32 (15.6%) |
| teen-direction | rest | 32 | 32 | 10/32 (31.2%) |
| teen-launch | ask | 14 | 14 | 5/14 (35.7%) |
| teen-launch | invest | 14 | 14 | 5/14 (35.7%) |
| teen-launch | rest | 14 | 14 | 4/14 (28.6%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 6 | 6 | 3/6 (50.0%) |
| teen-repair-table | invest | 6 | 6 | 1/6 (16.7%) |
| teen-repair-table | rest | 6 | 6 | 2/6 (33.3%) |
| teen-shared-kitchen | ask | 12 | 12 | 6/12 (50.0%) |
| teen-shared-kitchen | invest | 12 | 12 | 4/12 (33.3%) |
| teen-shared-kitchen | rest | 12 | 12 | 2/12 (16.7%) |

相鄰相同行動類型：123/448 (27.5%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/164 (0.0%) | 0/164 (0.0%) | 0/326 (0.0%) |
| 財務安全 | 0/15 (0.0%) | 0/15 (0.0%) | 0/40 (0.0%) |
| 人際關係 | 8/473 (1.7%) | 4/473 (0.8%) | 16/944 (1.7%) |
| 技能 | 0/278 (0.0%) | 0/278 (0.0%) | 0/670 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/24 (0.0%) | 0/24 (0.0%) | 0/48 (0.0%) |
| 技能 | 0/24 (0.0%) | 0/24 (0.0%) | 0/24 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## jpn-2／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | made-a-project: 0/32 (0.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | shared-care-contacts: 0/32 (0.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 19/19 (100.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 0/10 (0.0%) |
| child-library-map | invest | 10 | 10 | 10/10 (100.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 0/13 (0.0%) |
| child-transition | invest | 13 | 13 | 13/13 (100.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | invest | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 10 | 10 | 0/10 (0.0%) |
| middle-garden-table | invest | 10 | 10 | 10/10 (100.0%) |
| middle-garden-table | rest | 10 | 10 | 0/10 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 8 | 8 | 0/8 (0.0%) |
| middle-rhythm | invest | 8 | 8 | 8/8 (100.0%) |
| middle-rhythm | rest | 8 | 8 | 0/8 (0.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 32/32 (100.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 32 | 32 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 32/32 (100.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | leadWorkshop | 32 | 32 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 18 | 18 | 0/18 (0.0%) |
| teen-launch | invest | 18 | 18 | 18/18 (100.0%) |
| teen-launch | rest | 18 | 18 | 0/18 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 14 | 14 | 0/14 (0.0%) |
| teen-repair-table | invest | 14 | 14 | 14/14 (100.0%) |
| teen-repair-table | rest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：270/448 (60.3%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |
| 財務安全 | 0/32 (0.0%) | 0/32 (0.0%) | 0/102 (0.0%) |
| 人際關係 | 1/461 (0.2%) | 0/461 (0.0%) | 1/1317 (0.1%) |
| 技能 | 0/374 (0.0%) | 0/374 (0.0%) | 0/1357 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/96 (0.0%) | 0/96 (0.0%) | 0/192 (0.0%) |
| 技能 | 0/96 (0.0%) | 0/96 (0.0%) | 0/96 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## jpn-2／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 19/19 (100.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 32/32 (100.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 10/10 (100.0%) |
| child-library-map | invest | 10 | 10 | 0/10 (0.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 13/13 (100.0%) |
| child-transition | invest | 13 | 13 | 0/13 (0.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | invest | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 14 | 14 | 14/14 (100.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 18/18 (100.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 0/18 (0.0%) |
| middle-support | ask | 32 | 32 | 32/32 (100.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 32/32 (100.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 32/32 (100.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 32 | 32 | 32/32 (100.0%) |
| teen-launch | invest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | rest | 32 | 32 | 0/32 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 技能 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## jpn-2／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 17/32 (53.1%) | 17/32 (53.1%) |  |
| child-wind-team | 12 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | windmill-promise: 32/32 (100.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 32/32 (100.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 19/19 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 32/32 (100.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 13/13 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 15 | 15 | 0/15 (0.0%) |
| child-library-map | invest | 15 | 15 | 0/15 (0.0%) |
| child-library-map | rest | 15 | 15 | 15/15 (100.0%) |
| child-transition | ask | 17 | 17 | 0/17 (0.0%) |
| child-transition | invest | 17 | 17 | 0/17 (0.0%) |
| child-transition | rest | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 13/13 (100.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 32/32 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 19/19 (100.0%) |
| middle-garden-table | ask | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 18/18 (100.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 32/32 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 32/32 (100.0%) |
| teen-launch | ask | 32 | 32 | 0/32 (0.0%) |
| teen-launch | invest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | rest | 32 | 32 | 32/32 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## jpn-2／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 16/32 (50.0%) | 16/32 (50.0%) |  |
| child-wind-team | 12 | 20/32 (62.5%) | 4/32 (12.5%) | 4/20 (20.0%) | windmill-promise: 12/32 (37.5%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 25/32 (78.1%) | 25/32 (78.1%) |  |
| teen-repair-table | 21 | 16/32 (50.0%) | 7/32 (21.9%) | 7/16 (43.8%) | made-a-project: 16/32 (50.0%); repair-practice: 2/32 (6.2%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 10/32 (31.2%) | 6/32 (18.8%) | 6/10 (60.0%) | shared-care-contacts: 22/32 (68.8%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 5/19 (26.3%) |
| adult-balance | invest | 19 | 19 | 7/19 (36.8%) |
| adult-balance | rest | 19 | 19 | 7/19 (36.8%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 32 | 32 | 6/32 (18.8%) |
| adult-learning | invest | 32 | 32 | 13/32 (40.6%) |
| adult-learning | offline | 32 | 32 | 7/32 (21.9%) |
| adult-learning | rest | 32 | 32 | 6/32 (18.8%) |
| adult-neighbor-market | ask | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | invest | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | rest | 13 | 13 | 5/13 (38.5%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 12 | 12 | 3/12 (25.0%) |
| child-library-map | invest | 12 | 12 | 5/12 (41.7%) |
| child-library-map | rest | 12 | 12 | 4/12 (33.3%) |
| child-transition | ask | 16 | 16 | 5/16 (31.2%) |
| child-transition | invest | 16 | 16 | 7/16 (43.8%) |
| child-transition | rest | 16 | 16 | 4/16 (25.0%) |
| child-wind-team | ask | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | invest | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | rest | 4 | 4 | 0/4 (0.0%) |
| later-pass-on | ask | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | invest | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | rest | 13 | 13 | 7/13 (53.8%) |
| later-reconnect | ask | 32 | 32 | 7/32 (21.9%) |
| later-reconnect | invest | 32 | 32 | 15/32 (46.9%) |
| later-reconnect | rest | 32 | 32 | 10/32 (31.2%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-voice-booth | ask | 19 | 19 | 7/19 (36.8%) |
| later-voice-booth | invest | 19 | 19 | 5/19 (26.3%) |
| later-voice-booth | rest | 19 | 19 | 7/19 (36.8%) |
| middle-garden-table | ask | 11 | 11 | 3/11 (27.3%) |
| middle-garden-table | invest | 11 | 11 | 2/11 (18.2%) |
| middle-garden-table | rest | 11 | 11 | 6/11 (54.5%) |
| middle-open-desk | ask | 6 | 6 | 1/6 (16.7%) |
| middle-open-desk | invest | 6 | 6 | 2/6 (33.3%) |
| middle-open-desk | rest | 6 | 6 | 3/6 (50.0%) |
| middle-rhythm | ask | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | invest | 15 | 15 | 5/15 (33.3%) |
| middle-rhythm | rest | 15 | 15 | 10/15 (66.7%) |
| middle-support | ask | 32 | 32 | 10/32 (31.2%) |
| middle-support | invest | 32 | 32 | 11/32 (34.4%) |
| middle-support | rest | 32 | 32 | 9/32 (28.1%) |
| middle-support | shareShift | 10 | 10 | 2/32 (6.2%) |
| middle-turn | ask | 32 | 32 | 7/32 (21.9%) |
| middle-turn | invest | 32 | 32 | 4/32 (12.5%) |
| middle-turn | offline | 32 | 32 | 10/32 (31.2%) |
| middle-turn | rest | 32 | 32 | 11/32 (34.4%) |
| teen-direction | ask | 32 | 32 | 7/32 (21.9%) |
| teen-direction | invest | 32 | 32 | 6/32 (18.8%) |
| teen-direction | leadWorkshop | 14 | 14 | 4/32 (12.5%) |
| teen-direction | offline | 32 | 32 | 5/32 (15.6%) |
| teen-direction | rest | 32 | 32 | 10/32 (31.2%) |
| teen-launch | ask | 25 | 25 | 11/25 (44.0%) |
| teen-launch | invest | 25 | 25 | 7/25 (28.0%) |
| teen-launch | rest | 25 | 25 | 7/25 (28.0%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | invest | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | rest | 7 | 7 | 1/7 (14.3%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：116/448 (25.9%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/164 (0.0%) | 0/164 (0.0%) | 0/326 (0.0%) |
| 財務安全 | 0/11 (0.0%) | 0/11 (0.0%) | 0/36 (0.0%) |
| 人際關係 | 0/473 (0.0%) | 0/473 (0.0%) | 0/945 (0.0%) |
| 技能 | 0/282 (0.0%) | 0/282 (0.0%) | 0/688 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/24 (0.0%) | 0/24 (0.0%) | 0/48 (0.0%) |
| 技能 | 0/24 (0.0%) | 0/24 (0.0%) | 0/24 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## usa-1／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |  |
| teen-repair-table | 21 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | made-a-project: 0/32 (0.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | shared-care-contacts: 0/32 (0.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 19/19 (100.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 0/10 (0.0%) |
| child-library-map | invest | 10 | 10 | 10/10 (100.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 0/13 (0.0%) |
| child-transition | invest | 13 | 13 | 13/13 (100.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | invest | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 10 | 10 | 0/10 (0.0%) |
| middle-garden-table | invest | 10 | 10 | 10/10 (100.0%) |
| middle-garden-table | rest | 10 | 10 | 0/10 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 8 | 8 | 0/8 (0.0%) |
| middle-rhythm | invest | 8 | 8 | 8/8 (100.0%) |
| middle-rhythm | rest | 8 | 8 | 0/8 (0.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 32/32 (100.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 32 | 32 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 32/32 (100.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | leadWorkshop | 32 | 32 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 11 | 11 | 0/11 (0.0%) |
| teen-launch | invest | 11 | 11 | 11/11 (100.0%) |
| teen-launch | rest | 11 | 11 | 0/11 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 10 | 10 | 0/10 (0.0%) |
| teen-repair-table | invest | 10 | 10 | 10/10 (100.0%) |
| teen-repair-table | rest | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | ask | 11 | 11 | 0/11 (0.0%) |
| teen-shared-kitchen | invest | 11 | 11 | 11/11 (100.0%) |
| teen-shared-kitchen | rest | 11 | 11 | 0/11 (0.0%) |

相鄰相同行動類型：248/448 (55.4%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |
| 財務安全 | 0/43 (0.0%) | 0/43 (0.0%) | 0/113 (0.0%) |
| 人際關係 | 135/461 (29.3%) | 114/461 (24.7%) | 390/1318 (29.6%) |
| 技能 | 0/363 (0.0%) | 0/363 (0.0%) | 0/1306 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/96 (0.0%) | 0/96 (0.0%) | 0/192 (0.0%) |
| 技能 | 0/96 (0.0%) | 0/96 (0.0%) | 0/96 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## usa-1／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 19/19 (100.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 32/32 (100.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 10/10 (100.0%) |
| child-library-map | invest | 10 | 10 | 0/10 (0.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 13/13 (100.0%) |
| child-transition | invest | 13 | 13 | 0/13 (0.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | invest | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 14 | 14 | 14/14 (100.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 18/18 (100.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 0/18 (0.0%) |
| middle-support | ask | 32 | 32 | 32/32 (100.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 32/32 (100.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 32/32 (100.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 18 | 18 | 18/18 (100.0%) |
| teen-launch | invest | 18 | 18 | 0/18 (0.0%) |
| teen-launch | rest | 18 | 18 | 0/18 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 14 | 14 | 14/14 (100.0%) |
| teen-shared-kitchen | invest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | rest | 14 | 14 | 0/14 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 技能 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## usa-1／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 17/32 (53.1%) | 17/32 (53.1%) |  |
| child-wind-team | 12 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | windmill-promise: 32/32 (100.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 32/32 (100.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 19/19 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 32/32 (100.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 13/13 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 15 | 15 | 0/15 (0.0%) |
| child-library-map | invest | 15 | 15 | 0/15 (0.0%) |
| child-library-map | rest | 15 | 15 | 15/15 (100.0%) |
| child-transition | ask | 17 | 17 | 0/17 (0.0%) |
| child-transition | invest | 17 | 17 | 0/17 (0.0%) |
| child-transition | rest | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 13/13 (100.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 32/32 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 19/19 (100.0%) |
| middle-garden-table | ask | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 18/18 (100.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 32/32 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 32/32 (100.0%) |
| teen-launch | ask | 18 | 18 | 0/18 (0.0%) |
| teen-launch | invest | 18 | 18 | 0/18 (0.0%) |
| teen-launch | rest | 18 | 18 | 18/18 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | invest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | rest | 14 | 14 | 14/14 (100.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## usa-1／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 16/32 (50.0%) | 16/32 (50.0%) |  |
| child-wind-team | 12 | 20/32 (62.5%) | 4/32 (12.5%) | 4/20 (20.0%) | windmill-promise: 12/32 (37.5%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) |  |
| teen-repair-table | 21 | 16/32 (50.0%) | 6/32 (18.8%) | 6/16 (37.5%) | made-a-project: 16/32 (50.0%); repair-practice: 2/32 (6.2%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 10/32 (31.2%) | 6/32 (18.8%) | 6/10 (60.0%) | shared-care-contacts: 22/32 (68.8%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 5/19 (26.3%) |
| adult-balance | invest | 19 | 19 | 7/19 (36.8%) |
| adult-balance | rest | 19 | 19 | 7/19 (36.8%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 32 | 32 | 6/32 (18.8%) |
| adult-learning | invest | 32 | 32 | 13/32 (40.6%) |
| adult-learning | offline | 32 | 32 | 7/32 (21.9%) |
| adult-learning | rest | 32 | 32 | 6/32 (18.8%) |
| adult-neighbor-market | ask | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | invest | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | rest | 13 | 13 | 5/13 (38.5%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 12 | 12 | 3/12 (25.0%) |
| child-library-map | invest | 12 | 12 | 5/12 (41.7%) |
| child-library-map | rest | 12 | 12 | 4/12 (33.3%) |
| child-transition | ask | 16 | 16 | 5/16 (31.2%) |
| child-transition | invest | 16 | 16 | 7/16 (43.8%) |
| child-transition | rest | 16 | 16 | 4/16 (25.0%) |
| child-wind-team | ask | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | invest | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | rest | 4 | 4 | 0/4 (0.0%) |
| later-pass-on | ask | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | invest | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | rest | 13 | 13 | 7/13 (53.8%) |
| later-reconnect | ask | 32 | 32 | 7/32 (21.9%) |
| later-reconnect | invest | 32 | 32 | 15/32 (46.9%) |
| later-reconnect | rest | 32 | 32 | 10/32 (31.2%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-voice-booth | ask | 19 | 19 | 7/19 (36.8%) |
| later-voice-booth | invest | 19 | 19 | 5/19 (26.3%) |
| later-voice-booth | rest | 19 | 19 | 7/19 (36.8%) |
| middle-garden-table | ask | 11 | 11 | 3/11 (27.3%) |
| middle-garden-table | invest | 11 | 11 | 2/11 (18.2%) |
| middle-garden-table | rest | 11 | 11 | 6/11 (54.5%) |
| middle-open-desk | ask | 6 | 6 | 1/6 (16.7%) |
| middle-open-desk | invest | 6 | 6 | 2/6 (33.3%) |
| middle-open-desk | rest | 6 | 6 | 3/6 (50.0%) |
| middle-rhythm | ask | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | invest | 15 | 15 | 5/15 (33.3%) |
| middle-rhythm | rest | 15 | 15 | 10/15 (66.7%) |
| middle-support | ask | 32 | 32 | 10/32 (31.2%) |
| middle-support | invest | 32 | 32 | 11/32 (34.4%) |
| middle-support | rest | 32 | 32 | 9/32 (28.1%) |
| middle-support | shareShift | 10 | 10 | 2/32 (6.2%) |
| middle-turn | ask | 32 | 32 | 7/32 (21.9%) |
| middle-turn | invest | 32 | 32 | 4/32 (12.5%) |
| middle-turn | offline | 32 | 32 | 10/32 (31.2%) |
| middle-turn | rest | 32 | 32 | 11/32 (34.4%) |
| teen-direction | ask | 32 | 32 | 7/32 (21.9%) |
| teen-direction | invest | 32 | 32 | 6/32 (18.8%) |
| teen-direction | leadWorkshop | 14 | 14 | 4/32 (12.5%) |
| teen-direction | offline | 32 | 32 | 5/32 (15.6%) |
| teen-direction | rest | 32 | 32 | 10/32 (31.2%) |
| teen-launch | ask | 14 | 14 | 5/14 (35.7%) |
| teen-launch | invest | 14 | 14 | 5/14 (35.7%) |
| teen-launch | rest | 14 | 14 | 4/14 (28.6%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 6 | 6 | 3/6 (50.0%) |
| teen-repair-table | invest | 6 | 6 | 1/6 (16.7%) |
| teen-repair-table | rest | 6 | 6 | 2/6 (33.3%) |
| teen-shared-kitchen | ask | 12 | 12 | 6/12 (50.0%) |
| teen-shared-kitchen | invest | 12 | 12 | 4/12 (33.3%) |
| teen-shared-kitchen | rest | 12 | 12 | 2/12 (16.7%) |

相鄰相同行動類型：123/448 (27.5%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/164 (0.0%) | 0/164 (0.0%) | 0/326 (0.0%) |
| 財務安全 | 0/15 (0.0%) | 0/15 (0.0%) | 0/40 (0.0%) |
| 人際關係 | 8/473 (1.7%) | 4/473 (0.8%) | 16/944 (1.7%) |
| 技能 | 0/278 (0.0%) | 0/278 (0.0%) | 0/670 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/24 (0.0%) | 0/24 (0.0%) | 0/48 (0.0%) |
| 技能 | 0/24 (0.0%) | 0/24 (0.0%) | 0/24 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## usa-2／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | made-a-project: 0/32 (0.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | shared-care-contacts: 0/32 (0.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 19/19 (100.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 0/10 (0.0%) |
| child-library-map | invest | 10 | 10 | 10/10 (100.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 0/13 (0.0%) |
| child-transition | invest | 13 | 13 | 13/13 (100.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | invest | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 10 | 10 | 0/10 (0.0%) |
| middle-garden-table | invest | 10 | 10 | 10/10 (100.0%) |
| middle-garden-table | rest | 10 | 10 | 0/10 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 8 | 8 | 0/8 (0.0%) |
| middle-rhythm | invest | 8 | 8 | 8/8 (100.0%) |
| middle-rhythm | rest | 8 | 8 | 0/8 (0.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 32/32 (100.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 32 | 32 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 32/32 (100.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | leadWorkshop | 32 | 32 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 18 | 18 | 0/18 (0.0%) |
| teen-launch | invest | 18 | 18 | 18/18 (100.0%) |
| teen-launch | rest | 18 | 18 | 0/18 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 14 | 14 | 0/14 (0.0%) |
| teen-repair-table | invest | 14 | 14 | 14/14 (100.0%) |
| teen-repair-table | rest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：270/448 (60.3%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |
| 財務安全 | 0/32 (0.0%) | 0/32 (0.0%) | 0/102 (0.0%) |
| 人際關係 | 1/461 (0.2%) | 0/461 (0.0%) | 1/1317 (0.1%) |
| 技能 | 0/374 (0.0%) | 0/374 (0.0%) | 0/1357 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/96 (0.0%) | 0/96 (0.0%) | 0/192 (0.0%) |
| 技能 | 0/96 (0.0%) | 0/96 (0.0%) | 0/96 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## usa-2／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 19/19 (100.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 32/32 (100.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 10/10 (100.0%) |
| child-library-map | invest | 10 | 10 | 0/10 (0.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 13/13 (100.0%) |
| child-transition | invest | 13 | 13 | 0/13 (0.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | invest | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 14 | 14 | 14/14 (100.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 18/18 (100.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 0/18 (0.0%) |
| middle-support | ask | 32 | 32 | 32/32 (100.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 32/32 (100.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 32/32 (100.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 32 | 32 | 32/32 (100.0%) |
| teen-launch | invest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | rest | 32 | 32 | 0/32 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 技能 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## usa-2／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 17/32 (53.1%) | 17/32 (53.1%) |  |
| child-wind-team | 12 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | windmill-promise: 32/32 (100.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 32/32 (100.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 19/19 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 32/32 (100.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 13/13 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 15 | 15 | 0/15 (0.0%) |
| child-library-map | invest | 15 | 15 | 0/15 (0.0%) |
| child-library-map | rest | 15 | 15 | 15/15 (100.0%) |
| child-transition | ask | 17 | 17 | 0/17 (0.0%) |
| child-transition | invest | 17 | 17 | 0/17 (0.0%) |
| child-transition | rest | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 13/13 (100.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 32/32 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 19/19 (100.0%) |
| middle-garden-table | ask | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 18/18 (100.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 32/32 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 32/32 (100.0%) |
| teen-launch | ask | 32 | 32 | 0/32 (0.0%) |
| teen-launch | invest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | rest | 32 | 32 | 32/32 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## usa-2／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 16/32 (50.0%) | 16/32 (50.0%) |  |
| child-wind-team | 12 | 20/32 (62.5%) | 4/32 (12.5%) | 4/20 (20.0%) | windmill-promise: 12/32 (37.5%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 25/32 (78.1%) | 25/32 (78.1%) |  |
| teen-repair-table | 21 | 16/32 (50.0%) | 7/32 (21.9%) | 7/16 (43.8%) | made-a-project: 16/32 (50.0%); repair-practice: 2/32 (6.2%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 10/32 (31.2%) | 6/32 (18.8%) | 6/10 (60.0%) | shared-care-contacts: 22/32 (68.8%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 5/19 (26.3%) |
| adult-balance | invest | 19 | 19 | 7/19 (36.8%) |
| adult-balance | rest | 19 | 19 | 7/19 (36.8%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 32 | 32 | 6/32 (18.8%) |
| adult-learning | invest | 32 | 32 | 13/32 (40.6%) |
| adult-learning | offline | 32 | 32 | 7/32 (21.9%) |
| adult-learning | rest | 32 | 32 | 6/32 (18.8%) |
| adult-neighbor-market | ask | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | invest | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | rest | 13 | 13 | 5/13 (38.5%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 12 | 12 | 3/12 (25.0%) |
| child-library-map | invest | 12 | 12 | 5/12 (41.7%) |
| child-library-map | rest | 12 | 12 | 4/12 (33.3%) |
| child-transition | ask | 16 | 16 | 5/16 (31.2%) |
| child-transition | invest | 16 | 16 | 7/16 (43.8%) |
| child-transition | rest | 16 | 16 | 4/16 (25.0%) |
| child-wind-team | ask | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | invest | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | rest | 4 | 4 | 0/4 (0.0%) |
| later-pass-on | ask | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | invest | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | rest | 13 | 13 | 7/13 (53.8%) |
| later-reconnect | ask | 32 | 32 | 7/32 (21.9%) |
| later-reconnect | invest | 32 | 32 | 15/32 (46.9%) |
| later-reconnect | rest | 32 | 32 | 10/32 (31.2%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-voice-booth | ask | 19 | 19 | 7/19 (36.8%) |
| later-voice-booth | invest | 19 | 19 | 5/19 (26.3%) |
| later-voice-booth | rest | 19 | 19 | 7/19 (36.8%) |
| middle-garden-table | ask | 11 | 11 | 3/11 (27.3%) |
| middle-garden-table | invest | 11 | 11 | 2/11 (18.2%) |
| middle-garden-table | rest | 11 | 11 | 6/11 (54.5%) |
| middle-open-desk | ask | 6 | 6 | 1/6 (16.7%) |
| middle-open-desk | invest | 6 | 6 | 2/6 (33.3%) |
| middle-open-desk | rest | 6 | 6 | 3/6 (50.0%) |
| middle-rhythm | ask | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | invest | 15 | 15 | 5/15 (33.3%) |
| middle-rhythm | rest | 15 | 15 | 10/15 (66.7%) |
| middle-support | ask | 32 | 32 | 10/32 (31.2%) |
| middle-support | invest | 32 | 32 | 11/32 (34.4%) |
| middle-support | rest | 32 | 32 | 9/32 (28.1%) |
| middle-support | shareShift | 10 | 10 | 2/32 (6.2%) |
| middle-turn | ask | 32 | 32 | 7/32 (21.9%) |
| middle-turn | invest | 32 | 32 | 4/32 (12.5%) |
| middle-turn | offline | 32 | 32 | 10/32 (31.2%) |
| middle-turn | rest | 32 | 32 | 11/32 (34.4%) |
| teen-direction | ask | 32 | 32 | 7/32 (21.9%) |
| teen-direction | invest | 32 | 32 | 6/32 (18.8%) |
| teen-direction | leadWorkshop | 14 | 14 | 4/32 (12.5%) |
| teen-direction | offline | 32 | 32 | 5/32 (15.6%) |
| teen-direction | rest | 32 | 32 | 10/32 (31.2%) |
| teen-launch | ask | 25 | 25 | 11/25 (44.0%) |
| teen-launch | invest | 25 | 25 | 7/25 (28.0%) |
| teen-launch | rest | 25 | 25 | 7/25 (28.0%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | invest | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | rest | 7 | 7 | 1/7 (14.3%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：116/448 (25.9%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/164 (0.0%) | 0/164 (0.0%) | 0/326 (0.0%) |
| 財務安全 | 0/11 (0.0%) | 0/11 (0.0%) | 0/36 (0.0%) |
| 人際關係 | 0/473 (0.0%) | 0/473 (0.0%) | 0/945 (0.0%) |
| 技能 | 0/282 (0.0%) | 0/282 (0.0%) | 0/688 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/24 (0.0%) | 0/24 (0.0%) | 0/48 (0.0%) |
| 技能 | 0/24 (0.0%) | 0/24 (0.0%) | 0/24 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ind-1／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |  |
| teen-repair-table | 21 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | made-a-project: 0/32 (0.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | shared-care-contacts: 0/32 (0.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 19/19 (100.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 0/10 (0.0%) |
| child-library-map | invest | 10 | 10 | 10/10 (100.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 0/13 (0.0%) |
| child-transition | invest | 13 | 13 | 13/13 (100.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | invest | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 10 | 10 | 0/10 (0.0%) |
| middle-garden-table | invest | 10 | 10 | 10/10 (100.0%) |
| middle-garden-table | rest | 10 | 10 | 0/10 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 8 | 8 | 0/8 (0.0%) |
| middle-rhythm | invest | 8 | 8 | 8/8 (100.0%) |
| middle-rhythm | rest | 8 | 8 | 0/8 (0.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 32/32 (100.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 32 | 32 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 32/32 (100.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | leadWorkshop | 32 | 32 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 11 | 11 | 0/11 (0.0%) |
| teen-launch | invest | 11 | 11 | 11/11 (100.0%) |
| teen-launch | rest | 11 | 11 | 0/11 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 10 | 10 | 0/10 (0.0%) |
| teen-repair-table | invest | 10 | 10 | 10/10 (100.0%) |
| teen-repair-table | rest | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | ask | 11 | 11 | 0/11 (0.0%) |
| teen-shared-kitchen | invest | 11 | 11 | 11/11 (100.0%) |
| teen-shared-kitchen | rest | 11 | 11 | 0/11 (0.0%) |

相鄰相同行動類型：248/448 (55.4%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |
| 財務安全 | 0/43 (0.0%) | 0/43 (0.0%) | 0/113 (0.0%) |
| 人際關係 | 135/461 (29.3%) | 114/461 (24.7%) | 390/1318 (29.6%) |
| 技能 | 0/363 (0.0%) | 0/363 (0.0%) | 0/1306 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/96 (0.0%) | 0/96 (0.0%) | 0/192 (0.0%) |
| 技能 | 0/96 (0.0%) | 0/96 (0.0%) | 0/96 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ind-1／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 19/19 (100.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 32/32 (100.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 10/10 (100.0%) |
| child-library-map | invest | 10 | 10 | 0/10 (0.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 13/13 (100.0%) |
| child-transition | invest | 13 | 13 | 0/13 (0.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | invest | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 14 | 14 | 14/14 (100.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 18/18 (100.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 0/18 (0.0%) |
| middle-support | ask | 32 | 32 | 32/32 (100.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 32/32 (100.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 32/32 (100.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 18 | 18 | 18/18 (100.0%) |
| teen-launch | invest | 18 | 18 | 0/18 (0.0%) |
| teen-launch | rest | 18 | 18 | 0/18 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 14 | 14 | 14/14 (100.0%) |
| teen-shared-kitchen | invest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | rest | 14 | 14 | 0/14 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 技能 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ind-1／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 17/32 (53.1%) | 17/32 (53.1%) |  |
| child-wind-team | 12 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | windmill-promise: 32/32 (100.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 32/32 (100.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 19/19 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 32/32 (100.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 13/13 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 15 | 15 | 0/15 (0.0%) |
| child-library-map | invest | 15 | 15 | 0/15 (0.0%) |
| child-library-map | rest | 15 | 15 | 15/15 (100.0%) |
| child-transition | ask | 17 | 17 | 0/17 (0.0%) |
| child-transition | invest | 17 | 17 | 0/17 (0.0%) |
| child-transition | rest | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 13/13 (100.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 32/32 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 19/19 (100.0%) |
| middle-garden-table | ask | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 18/18 (100.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 32/32 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 32/32 (100.0%) |
| teen-launch | ask | 18 | 18 | 0/18 (0.0%) |
| teen-launch | invest | 18 | 18 | 0/18 (0.0%) |
| teen-launch | rest | 18 | 18 | 18/18 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | invest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | rest | 14 | 14 | 14/14 (100.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ind-1／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 16/32 (50.0%) | 16/32 (50.0%) |  |
| child-wind-team | 12 | 20/32 (62.5%) | 4/32 (12.5%) | 4/20 (20.0%) | windmill-promise: 12/32 (37.5%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) |  |
| teen-repair-table | 21 | 16/32 (50.0%) | 6/32 (18.8%) | 6/16 (37.5%) | made-a-project: 16/32 (50.0%); repair-practice: 2/32 (6.2%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 10/32 (31.2%) | 6/32 (18.8%) | 6/10 (60.0%) | shared-care-contacts: 22/32 (68.8%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 5/19 (26.3%) |
| adult-balance | invest | 19 | 19 | 7/19 (36.8%) |
| adult-balance | rest | 19 | 19 | 7/19 (36.8%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 32 | 32 | 6/32 (18.8%) |
| adult-learning | invest | 32 | 32 | 13/32 (40.6%) |
| adult-learning | offline | 32 | 32 | 7/32 (21.9%) |
| adult-learning | rest | 32 | 32 | 6/32 (18.8%) |
| adult-neighbor-market | ask | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | invest | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | rest | 13 | 13 | 5/13 (38.5%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 12 | 12 | 3/12 (25.0%) |
| child-library-map | invest | 12 | 12 | 5/12 (41.7%) |
| child-library-map | rest | 12 | 12 | 4/12 (33.3%) |
| child-transition | ask | 16 | 16 | 5/16 (31.2%) |
| child-transition | invest | 16 | 16 | 7/16 (43.8%) |
| child-transition | rest | 16 | 16 | 4/16 (25.0%) |
| child-wind-team | ask | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | invest | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | rest | 4 | 4 | 0/4 (0.0%) |
| later-pass-on | ask | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | invest | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | rest | 13 | 13 | 7/13 (53.8%) |
| later-reconnect | ask | 32 | 32 | 7/32 (21.9%) |
| later-reconnect | invest | 32 | 32 | 15/32 (46.9%) |
| later-reconnect | rest | 32 | 32 | 10/32 (31.2%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-voice-booth | ask | 19 | 19 | 7/19 (36.8%) |
| later-voice-booth | invest | 19 | 19 | 5/19 (26.3%) |
| later-voice-booth | rest | 19 | 19 | 7/19 (36.8%) |
| middle-garden-table | ask | 11 | 11 | 3/11 (27.3%) |
| middle-garden-table | invest | 11 | 11 | 2/11 (18.2%) |
| middle-garden-table | rest | 11 | 11 | 6/11 (54.5%) |
| middle-open-desk | ask | 6 | 6 | 1/6 (16.7%) |
| middle-open-desk | invest | 6 | 6 | 2/6 (33.3%) |
| middle-open-desk | rest | 6 | 6 | 3/6 (50.0%) |
| middle-rhythm | ask | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | invest | 15 | 15 | 5/15 (33.3%) |
| middle-rhythm | rest | 15 | 15 | 10/15 (66.7%) |
| middle-support | ask | 32 | 32 | 10/32 (31.2%) |
| middle-support | invest | 32 | 32 | 11/32 (34.4%) |
| middle-support | rest | 32 | 32 | 9/32 (28.1%) |
| middle-support | shareShift | 10 | 10 | 2/32 (6.2%) |
| middle-turn | ask | 32 | 32 | 7/32 (21.9%) |
| middle-turn | invest | 32 | 32 | 4/32 (12.5%) |
| middle-turn | offline | 32 | 32 | 10/32 (31.2%) |
| middle-turn | rest | 32 | 32 | 11/32 (34.4%) |
| teen-direction | ask | 32 | 32 | 7/32 (21.9%) |
| teen-direction | invest | 32 | 32 | 6/32 (18.8%) |
| teen-direction | leadWorkshop | 14 | 14 | 4/32 (12.5%) |
| teen-direction | offline | 32 | 32 | 5/32 (15.6%) |
| teen-direction | rest | 32 | 32 | 10/32 (31.2%) |
| teen-launch | ask | 14 | 14 | 5/14 (35.7%) |
| teen-launch | invest | 14 | 14 | 5/14 (35.7%) |
| teen-launch | rest | 14 | 14 | 4/14 (28.6%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 6 | 6 | 3/6 (50.0%) |
| teen-repair-table | invest | 6 | 6 | 1/6 (16.7%) |
| teen-repair-table | rest | 6 | 6 | 2/6 (33.3%) |
| teen-shared-kitchen | ask | 12 | 12 | 6/12 (50.0%) |
| teen-shared-kitchen | invest | 12 | 12 | 4/12 (33.3%) |
| teen-shared-kitchen | rest | 12 | 12 | 2/12 (16.7%) |

相鄰相同行動類型：123/448 (27.5%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/164 (0.0%) | 0/164 (0.0%) | 0/326 (0.0%) |
| 財務安全 | 0/15 (0.0%) | 0/15 (0.0%) | 0/40 (0.0%) |
| 人際關係 | 8/473 (1.7%) | 4/473 (0.8%) | 16/944 (1.7%) |
| 技能 | 0/278 (0.0%) | 0/278 (0.0%) | 0/670 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/24 (0.0%) | 0/24 (0.0%) | 0/48 (0.0%) |
| 技能 | 0/24 (0.0%) | 0/24 (0.0%) | 0/24 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ind-2／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | made-a-project: 0/32 (0.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | shared-care-contacts: 0/32 (0.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 19/19 (100.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 0/10 (0.0%) |
| child-library-map | invest | 10 | 10 | 10/10 (100.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 0/13 (0.0%) |
| child-transition | invest | 13 | 13 | 13/13 (100.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | invest | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 10 | 10 | 0/10 (0.0%) |
| middle-garden-table | invest | 10 | 10 | 10/10 (100.0%) |
| middle-garden-table | rest | 10 | 10 | 0/10 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 8 | 8 | 0/8 (0.0%) |
| middle-rhythm | invest | 8 | 8 | 8/8 (100.0%) |
| middle-rhythm | rest | 8 | 8 | 0/8 (0.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 32/32 (100.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 32 | 32 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 32/32 (100.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | leadWorkshop | 32 | 32 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 18 | 18 | 0/18 (0.0%) |
| teen-launch | invest | 18 | 18 | 18/18 (100.0%) |
| teen-launch | rest | 18 | 18 | 0/18 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 14 | 14 | 0/14 (0.0%) |
| teen-repair-table | invest | 14 | 14 | 14/14 (100.0%) |
| teen-repair-table | rest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：270/448 (60.3%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |
| 財務安全 | 0/32 (0.0%) | 0/32 (0.0%) | 0/102 (0.0%) |
| 人際關係 | 1/461 (0.2%) | 0/461 (0.0%) | 1/1317 (0.1%) |
| 技能 | 0/374 (0.0%) | 0/374 (0.0%) | 0/1357 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/96 (0.0%) | 0/96 (0.0%) | 0/192 (0.0%) |
| 技能 | 0/96 (0.0%) | 0/96 (0.0%) | 0/96 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ind-2／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 19/19 (100.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 32/32 (100.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 10/10 (100.0%) |
| child-library-map | invest | 10 | 10 | 0/10 (0.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 13/13 (100.0%) |
| child-transition | invest | 13 | 13 | 0/13 (0.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | invest | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 14 | 14 | 14/14 (100.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 18/18 (100.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 0/18 (0.0%) |
| middle-support | ask | 32 | 32 | 32/32 (100.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 32/32 (100.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 32/32 (100.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 32 | 32 | 32/32 (100.0%) |
| teen-launch | invest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | rest | 32 | 32 | 0/32 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 技能 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ind-2／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 17/32 (53.1%) | 17/32 (53.1%) |  |
| child-wind-team | 12 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | windmill-promise: 32/32 (100.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 32/32 (100.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 19/19 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 32/32 (100.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 13/13 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 15 | 15 | 0/15 (0.0%) |
| child-library-map | invest | 15 | 15 | 0/15 (0.0%) |
| child-library-map | rest | 15 | 15 | 15/15 (100.0%) |
| child-transition | ask | 17 | 17 | 0/17 (0.0%) |
| child-transition | invest | 17 | 17 | 0/17 (0.0%) |
| child-transition | rest | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 13/13 (100.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 32/32 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 19/19 (100.0%) |
| middle-garden-table | ask | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 18/18 (100.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 32/32 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 32/32 (100.0%) |
| teen-launch | ask | 32 | 32 | 0/32 (0.0%) |
| teen-launch | invest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | rest | 32 | 32 | 32/32 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ind-2／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 16/32 (50.0%) | 16/32 (50.0%) |  |
| child-wind-team | 12 | 20/32 (62.5%) | 4/32 (12.5%) | 4/20 (20.0%) | windmill-promise: 12/32 (37.5%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 25/32 (78.1%) | 25/32 (78.1%) |  |
| teen-repair-table | 21 | 16/32 (50.0%) | 7/32 (21.9%) | 7/16 (43.8%) | made-a-project: 16/32 (50.0%); repair-practice: 2/32 (6.2%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 10/32 (31.2%) | 6/32 (18.8%) | 6/10 (60.0%) | shared-care-contacts: 22/32 (68.8%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 5/19 (26.3%) |
| adult-balance | invest | 19 | 19 | 7/19 (36.8%) |
| adult-balance | rest | 19 | 19 | 7/19 (36.8%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 32 | 32 | 6/32 (18.8%) |
| adult-learning | invest | 32 | 32 | 13/32 (40.6%) |
| adult-learning | offline | 32 | 32 | 7/32 (21.9%) |
| adult-learning | rest | 32 | 32 | 6/32 (18.8%) |
| adult-neighbor-market | ask | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | invest | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | rest | 13 | 13 | 5/13 (38.5%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 12 | 12 | 3/12 (25.0%) |
| child-library-map | invest | 12 | 12 | 5/12 (41.7%) |
| child-library-map | rest | 12 | 12 | 4/12 (33.3%) |
| child-transition | ask | 16 | 16 | 5/16 (31.2%) |
| child-transition | invest | 16 | 16 | 7/16 (43.8%) |
| child-transition | rest | 16 | 16 | 4/16 (25.0%) |
| child-wind-team | ask | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | invest | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | rest | 4 | 4 | 0/4 (0.0%) |
| later-pass-on | ask | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | invest | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | rest | 13 | 13 | 7/13 (53.8%) |
| later-reconnect | ask | 32 | 32 | 7/32 (21.9%) |
| later-reconnect | invest | 32 | 32 | 15/32 (46.9%) |
| later-reconnect | rest | 32 | 32 | 10/32 (31.2%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-voice-booth | ask | 19 | 19 | 7/19 (36.8%) |
| later-voice-booth | invest | 19 | 19 | 5/19 (26.3%) |
| later-voice-booth | rest | 19 | 19 | 7/19 (36.8%) |
| middle-garden-table | ask | 11 | 11 | 3/11 (27.3%) |
| middle-garden-table | invest | 11 | 11 | 2/11 (18.2%) |
| middle-garden-table | rest | 11 | 11 | 6/11 (54.5%) |
| middle-open-desk | ask | 6 | 6 | 1/6 (16.7%) |
| middle-open-desk | invest | 6 | 6 | 2/6 (33.3%) |
| middle-open-desk | rest | 6 | 6 | 3/6 (50.0%) |
| middle-rhythm | ask | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | invest | 15 | 15 | 5/15 (33.3%) |
| middle-rhythm | rest | 15 | 15 | 10/15 (66.7%) |
| middle-support | ask | 32 | 32 | 10/32 (31.2%) |
| middle-support | invest | 32 | 32 | 11/32 (34.4%) |
| middle-support | rest | 32 | 32 | 9/32 (28.1%) |
| middle-support | shareShift | 10 | 10 | 2/32 (6.2%) |
| middle-turn | ask | 32 | 32 | 7/32 (21.9%) |
| middle-turn | invest | 32 | 32 | 4/32 (12.5%) |
| middle-turn | offline | 32 | 32 | 10/32 (31.2%) |
| middle-turn | rest | 32 | 32 | 11/32 (34.4%) |
| teen-direction | ask | 32 | 32 | 7/32 (21.9%) |
| teen-direction | invest | 32 | 32 | 6/32 (18.8%) |
| teen-direction | leadWorkshop | 14 | 14 | 4/32 (12.5%) |
| teen-direction | offline | 32 | 32 | 5/32 (15.6%) |
| teen-direction | rest | 32 | 32 | 10/32 (31.2%) |
| teen-launch | ask | 25 | 25 | 11/25 (44.0%) |
| teen-launch | invest | 25 | 25 | 7/25 (28.0%) |
| teen-launch | rest | 25 | 25 | 7/25 (28.0%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | invest | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | rest | 7 | 7 | 1/7 (14.3%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：116/448 (25.9%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/164 (0.0%) | 0/164 (0.0%) | 0/326 (0.0%) |
| 財務安全 | 0/11 (0.0%) | 0/11 (0.0%) | 0/36 (0.0%) |
| 人際關係 | 0/473 (0.0%) | 0/473 (0.0%) | 0/945 (0.0%) |
| 技能 | 0/282 (0.0%) | 0/282 (0.0%) | 0/688 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/24 (0.0%) | 0/24 (0.0%) | 0/48 (0.0%) |
| 技能 | 0/24 (0.0%) | 0/24 (0.0%) | 0/24 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ken-1／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |  |
| teen-repair-table | 21 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | made-a-project: 0/32 (0.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | shared-care-contacts: 0/32 (0.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 19/19 (100.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 0/10 (0.0%) |
| child-library-map | invest | 10 | 10 | 10/10 (100.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 0/13 (0.0%) |
| child-transition | invest | 13 | 13 | 13/13 (100.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | invest | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 10 | 10 | 0/10 (0.0%) |
| middle-garden-table | invest | 10 | 10 | 10/10 (100.0%) |
| middle-garden-table | rest | 10 | 10 | 0/10 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 8 | 8 | 0/8 (0.0%) |
| middle-rhythm | invest | 8 | 8 | 8/8 (100.0%) |
| middle-rhythm | rest | 8 | 8 | 0/8 (0.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 32/32 (100.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 32 | 32 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 32/32 (100.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | leadWorkshop | 32 | 32 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 11 | 11 | 0/11 (0.0%) |
| teen-launch | invest | 11 | 11 | 11/11 (100.0%) |
| teen-launch | rest | 11 | 11 | 0/11 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 10 | 10 | 0/10 (0.0%) |
| teen-repair-table | invest | 10 | 10 | 10/10 (100.0%) |
| teen-repair-table | rest | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | ask | 11 | 11 | 0/11 (0.0%) |
| teen-shared-kitchen | invest | 11 | 11 | 11/11 (100.0%) |
| teen-shared-kitchen | rest | 11 | 11 | 0/11 (0.0%) |

相鄰相同行動類型：248/448 (55.4%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |
| 財務安全 | 0/43 (0.0%) | 0/43 (0.0%) | 0/113 (0.0%) |
| 人際關係 | 135/461 (29.3%) | 114/461 (24.7%) | 390/1318 (29.6%) |
| 技能 | 0/363 (0.0%) | 0/363 (0.0%) | 0/1306 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/96 (0.0%) | 0/96 (0.0%) | 0/192 (0.0%) |
| 技能 | 0/96 (0.0%) | 0/96 (0.0%) | 0/96 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ken-1／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 19/19 (100.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 32/32 (100.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 10/10 (100.0%) |
| child-library-map | invest | 10 | 10 | 0/10 (0.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 13/13 (100.0%) |
| child-transition | invest | 13 | 13 | 0/13 (0.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | invest | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 14 | 14 | 14/14 (100.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 18/18 (100.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 0/18 (0.0%) |
| middle-support | ask | 32 | 32 | 32/32 (100.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 32/32 (100.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 32/32 (100.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 18 | 18 | 18/18 (100.0%) |
| teen-launch | invest | 18 | 18 | 0/18 (0.0%) |
| teen-launch | rest | 18 | 18 | 0/18 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 14 | 14 | 14/14 (100.0%) |
| teen-shared-kitchen | invest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | rest | 14 | 14 | 0/14 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 技能 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ken-1／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 17/32 (53.1%) | 17/32 (53.1%) |  |
| child-wind-team | 12 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | windmill-promise: 32/32 (100.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 32/32 (100.0%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 19/19 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 32/32 (100.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 13/13 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 15 | 15 | 0/15 (0.0%) |
| child-library-map | invest | 15 | 15 | 0/15 (0.0%) |
| child-library-map | rest | 15 | 15 | 15/15 (100.0%) |
| child-transition | ask | 17 | 17 | 0/17 (0.0%) |
| child-transition | invest | 17 | 17 | 0/17 (0.0%) |
| child-transition | rest | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 13/13 (100.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 32/32 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 19/19 (100.0%) |
| middle-garden-table | ask | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 18/18 (100.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 32/32 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 32/32 (100.0%) |
| teen-launch | ask | 18 | 18 | 0/18 (0.0%) |
| teen-launch | invest | 18 | 18 | 0/18 (0.0%) |
| teen-launch | rest | 18 | 18 | 18/18 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | invest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | rest | 14 | 14 | 14/14 (100.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ken-1／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 16/32 (50.0%) | 16/32 (50.0%) |  |
| child-wind-team | 12 | 20/32 (62.5%) | 4/32 (12.5%) | 4/20 (20.0%) | windmill-promise: 12/32 (37.5%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) |  |
| teen-repair-table | 21 | 16/32 (50.0%) | 6/32 (18.8%) | 6/16 (37.5%) | made-a-project: 16/32 (50.0%); repair-practice: 2/32 (6.2%) |
| teen-shared-kitchen | 21 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | family-rotations: 0/32 (0.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 10/32 (31.2%) | 6/32 (18.8%) | 6/10 (60.0%) | shared-care-contacts: 22/32 (68.8%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 5/19 (26.3%) |
| adult-balance | invest | 19 | 19 | 7/19 (36.8%) |
| adult-balance | rest | 19 | 19 | 7/19 (36.8%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 32 | 32 | 6/32 (18.8%) |
| adult-learning | invest | 32 | 32 | 13/32 (40.6%) |
| adult-learning | offline | 32 | 32 | 7/32 (21.9%) |
| adult-learning | rest | 32 | 32 | 6/32 (18.8%) |
| adult-neighbor-market | ask | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | invest | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | rest | 13 | 13 | 5/13 (38.5%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 12 | 12 | 3/12 (25.0%) |
| child-library-map | invest | 12 | 12 | 5/12 (41.7%) |
| child-library-map | rest | 12 | 12 | 4/12 (33.3%) |
| child-transition | ask | 16 | 16 | 5/16 (31.2%) |
| child-transition | invest | 16 | 16 | 7/16 (43.8%) |
| child-transition | rest | 16 | 16 | 4/16 (25.0%) |
| child-wind-team | ask | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | invest | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | rest | 4 | 4 | 0/4 (0.0%) |
| later-pass-on | ask | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | invest | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | rest | 13 | 13 | 7/13 (53.8%) |
| later-reconnect | ask | 32 | 32 | 7/32 (21.9%) |
| later-reconnect | invest | 32 | 32 | 15/32 (46.9%) |
| later-reconnect | rest | 32 | 32 | 10/32 (31.2%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-voice-booth | ask | 19 | 19 | 7/19 (36.8%) |
| later-voice-booth | invest | 19 | 19 | 5/19 (26.3%) |
| later-voice-booth | rest | 19 | 19 | 7/19 (36.8%) |
| middle-garden-table | ask | 11 | 11 | 3/11 (27.3%) |
| middle-garden-table | invest | 11 | 11 | 2/11 (18.2%) |
| middle-garden-table | rest | 11 | 11 | 6/11 (54.5%) |
| middle-open-desk | ask | 6 | 6 | 1/6 (16.7%) |
| middle-open-desk | invest | 6 | 6 | 2/6 (33.3%) |
| middle-open-desk | rest | 6 | 6 | 3/6 (50.0%) |
| middle-rhythm | ask | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | invest | 15 | 15 | 5/15 (33.3%) |
| middle-rhythm | rest | 15 | 15 | 10/15 (66.7%) |
| middle-support | ask | 32 | 32 | 10/32 (31.2%) |
| middle-support | invest | 32 | 32 | 11/32 (34.4%) |
| middle-support | rest | 32 | 32 | 9/32 (28.1%) |
| middle-support | shareShift | 10 | 10 | 2/32 (6.2%) |
| middle-turn | ask | 32 | 32 | 7/32 (21.9%) |
| middle-turn | invest | 32 | 32 | 4/32 (12.5%) |
| middle-turn | offline | 32 | 32 | 10/32 (31.2%) |
| middle-turn | rest | 32 | 32 | 11/32 (34.4%) |
| teen-direction | ask | 32 | 32 | 7/32 (21.9%) |
| teen-direction | invest | 32 | 32 | 6/32 (18.8%) |
| teen-direction | leadWorkshop | 14 | 14 | 4/32 (12.5%) |
| teen-direction | offline | 32 | 32 | 5/32 (15.6%) |
| teen-direction | rest | 32 | 32 | 10/32 (31.2%) |
| teen-launch | ask | 14 | 14 | 5/14 (35.7%) |
| teen-launch | invest | 14 | 14 | 5/14 (35.7%) |
| teen-launch | rest | 14 | 14 | 4/14 (28.6%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 6 | 6 | 3/6 (50.0%) |
| teen-repair-table | invest | 6 | 6 | 1/6 (16.7%) |
| teen-repair-table | rest | 6 | 6 | 2/6 (33.3%) |
| teen-shared-kitchen | ask | 12 | 12 | 6/12 (50.0%) |
| teen-shared-kitchen | invest | 12 | 12 | 4/12 (33.3%) |
| teen-shared-kitchen | rest | 12 | 12 | 2/12 (16.7%) |

相鄰相同行動類型：123/448 (27.5%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/164 (0.0%) | 0/164 (0.0%) | 0/326 (0.0%) |
| 財務安全 | 0/15 (0.0%) | 0/15 (0.0%) | 0/40 (0.0%) |
| 人際關係 | 8/473 (1.7%) | 4/473 (0.8%) | 16/944 (1.7%) |
| 技能 | 0/278 (0.0%) | 0/278 (0.0%) | 0/670 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/24 (0.0%) | 0/24 (0.0%) | 0/48 (0.0%) |
| 技能 | 0/24 (0.0%) | 0/24 (0.0%) | 0/24 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ken-2／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| teen-repair-table | 21 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | made-a-project: 0/32 (0.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | shared-care-contacts: 0/32 (0.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 19/19 (100.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 0/10 (0.0%) |
| child-library-map | invest | 10 | 10 | 10/10 (100.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 0/13 (0.0%) |
| child-transition | invest | 13 | 13 | 13/13 (100.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | invest | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 10 | 10 | 0/10 (0.0%) |
| middle-garden-table | invest | 10 | 10 | 10/10 (100.0%) |
| middle-garden-table | rest | 10 | 10 | 0/10 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 8 | 8 | 0/8 (0.0%) |
| middle-rhythm | invest | 8 | 8 | 8/8 (100.0%) |
| middle-rhythm | rest | 8 | 8 | 0/8 (0.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 32/32 (100.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 13 | 13 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 32/32 (100.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | leadWorkshop | 32 | 32 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 18 | 18 | 0/18 (0.0%) |
| teen-launch | invest | 18 | 18 | 18/18 (100.0%) |
| teen-launch | rest | 18 | 18 | 0/18 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 14 | 14 | 0/14 (0.0%) |
| teen-repair-table | invest | 14 | 14 | 14/14 (100.0%) |
| teen-repair-table | rest | 14 | 14 | 0/14 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：270/448 (60.3%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |
| 財務安全 | 0/32 (0.0%) | 0/32 (0.0%) | 0/102 (0.0%) |
| 人際關係 | 1/461 (0.2%) | 0/461 (0.0%) | 1/1317 (0.1%) |
| 技能 | 0/374 (0.0%) | 0/374 (0.0%) | 0/1357 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/96 (0.0%) | 0/96 (0.0%) | 0/192 (0.0%) |
| 技能 | 0/96 (0.0%) | 0/96 (0.0%) | 0/96 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ken-2／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| child-wind-team | 12 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | windmill-promise: 0/32 (0.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 0/32 (0.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 19/19 (100.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 0/19 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 32 | 32 | 32/32 (100.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 0/32 (0.0%) |
| adult-neighbor-market | ask | 13 | 13 | 13/13 (100.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 0/13 (0.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 10 | 10 | 10/10 (100.0%) |
| child-library-map | invest | 10 | 10 | 0/10 (0.0%) |
| child-library-map | rest | 10 | 10 | 0/10 (0.0%) |
| child-transition | ask | 13 | 13 | 13/13 (100.0%) |
| child-transition | invest | 13 | 13 | 0/13 (0.0%) |
| child-transition | rest | 13 | 13 | 0/13 (0.0%) |
| child-wind-team | ask | 9 | 9 | 9/9 (100.0%) |
| child-wind-team | invest | 9 | 9 | 0/9 (0.0%) |
| child-wind-team | rest | 9 | 9 | 0/9 (0.0%) |
| later-pass-on | ask | 13 | 13 | 13/13 (100.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 0/13 (0.0%) |
| later-reconnect | ask | 32 | 32 | 32/32 (100.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 0/32 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-voice-booth | ask | 19 | 19 | 19/19 (100.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 0/19 (0.0%) |
| middle-garden-table | ask | 14 | 14 | 14/14 (100.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 18/18 (100.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 0/18 (0.0%) |
| middle-support | ask | 32 | 32 | 32/32 (100.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 0/32 (0.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 32/32 (100.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | ask | 32 | 32 | 32/32 (100.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | ask | 32 | 32 | 32/32 (100.0%) |
| teen-launch | invest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | rest | 32 | 32 | 0/32 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 技能 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ken-2／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 17/32 (53.1%) | 17/32 (53.1%) |  |
| child-wind-team | 12 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | windmill-promise: 32/32 (100.0%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-repair-table | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | made-a-project: 32/32 (100.0%); repair-practice: 32/32 (100.0%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 14/32 (43.8%) | 14/32 (43.8%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | shared-care-contacts: 32/32 (100.0%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 18/32 (56.2%) | 18/32 (56.2%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 0/19 (0.0%) |
| adult-balance | invest | 19 | 19 | 0/19 (0.0%) |
| adult-balance | rest | 19 | 19 | 19/19 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 32 | 32 | 0/32 (0.0%) |
| adult-learning | invest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | offline | 32 | 32 | 0/32 (0.0%) |
| adult-learning | rest | 32 | 32 | 32/32 (100.0%) |
| adult-neighbor-market | ask | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | invest | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | rest | 13 | 13 | 13/13 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 15 | 15 | 0/15 (0.0%) |
| child-library-map | invest | 15 | 15 | 0/15 (0.0%) |
| child-library-map | rest | 15 | 15 | 15/15 (100.0%) |
| child-transition | ask | 17 | 17 | 0/17 (0.0%) |
| child-transition | invest | 17 | 17 | 0/17 (0.0%) |
| child-transition | rest | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | invest | 13 | 13 | 0/13 (0.0%) |
| later-pass-on | rest | 13 | 13 | 13/13 (100.0%) |
| later-reconnect | ask | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | invest | 32 | 32 | 0/32 (0.0%) |
| later-reconnect | rest | 32 | 32 | 32/32 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-voice-booth | ask | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | invest | 19 | 19 | 0/19 (0.0%) |
| later-voice-booth | rest | 19 | 19 | 19/19 (100.0%) |
| middle-garden-table | ask | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | invest | 14 | 14 | 0/14 (0.0%) |
| middle-garden-table | rest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rhythm | ask | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | invest | 18 | 18 | 0/18 (0.0%) |
| middle-rhythm | rest | 18 | 18 | 18/18 (100.0%) |
| middle-support | ask | 32 | 32 | 0/32 (0.0%) |
| middle-support | invest | 32 | 32 | 0/32 (0.0%) |
| middle-support | rest | 32 | 32 | 32/32 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/32 (0.0%) |
| middle-turn | ask | 32 | 32 | 0/32 (0.0%) |
| middle-turn | invest | 32 | 32 | 0/32 (0.0%) |
| middle-turn | offline | 32 | 32 | 0/32 (0.0%) |
| middle-turn | rest | 32 | 32 | 32/32 (100.0%) |
| teen-direction | ask | 32 | 32 | 0/32 (0.0%) |
| teen-direction | invest | 32 | 32 | 0/32 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/32 (0.0%) |
| teen-direction | offline | 32 | 32 | 0/32 (0.0%) |
| teen-direction | rest | 32 | 32 | 32/32 (100.0%) |
| teen-launch | ask | 32 | 32 | 0/32 (0.0%) |
| teen-launch | invest | 32 | 32 | 0/32 (0.0%) |
| teen-launch | rest | 32 | 32 | 32/32 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/480 (0.0%) | 0/480 (0.0%) | 0/480 (0.0%) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | — (0/0) | — (0/0) | — (0/0) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## ken-2／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-friend | 10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| child-library-map | 12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%) |
| child-transition | 12 | 32/32 (100.0%) | 16/32 (50.0%) | 16/32 (50.0%) |  |
| child-wind-team | 12 | 20/32 (62.5%) | 4/32 (12.5%) | 4/20 (20.0%) | windmill-promise: 12/32 (37.5%) |
| teen-project | 13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-direction | 17 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| teen-launch | 21 | 32/32 (100.0%) | 25/32 (78.1%) | 25/32 (78.1%) |  |
| teen-repair-table | 21 | 16/32 (50.0%) | 7/32 (21.9%) | 7/16 (43.8%) | made-a-project: 16/32 (50.0%); repair-practice: 2/32 (6.2%) |
| teen-shared-kitchen | 21 | 0/32 (0.0%) | 0/32 (0.0%) | — (0/0) | family-rotations: 32/32 (100.0%); kitchen-energy: 0/32 (0.0%) |
| adult-learning | 25 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| adult-balance | 32 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) |  |
| adult-neighbor-market | 32 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) | current-financial-room: 0/32 (0.0%); market-helper: 0/32 (0.0%) |
| adult-care | 39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-turn | 45 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-support | 52 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| middle-garden-table | 59 | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) | garden-energy: 0/32 (0.0%) |
| middle-open-desk | 59 | 10/32 (31.2%) | 6/32 (18.8%) | 6/10 (60.0%) | shared-care-contacts: 22/32 (68.8%) |
| middle-rhythm | 59 | 32/32 (100.0%) | 15/32 (46.9%) | 15/32 (46.9%) |  |
| later-pass-on | 65 | 32/32 (100.0%) | 13/32 (40.6%) | 13/32 (40.6%) |  |
| later-voice-booth | 65 | 32/32 (100.0%) | 19/32 (59.4%) | 19/32 (59.4%) | recording-companion: 0/32 (0.0%); sharing-connection: 0/32 (0.0%) |
| later-reconnect | 72 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |
| later-review | 80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |  |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 19 | 19 | 5/19 (26.3%) |
| adult-balance | invest | 19 | 19 | 7/19 (36.8%) |
| adult-balance | rest | 19 | 19 | 7/19 (36.8%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 32 | 32 | 6/32 (18.8%) |
| adult-learning | invest | 32 | 32 | 13/32 (40.6%) |
| adult-learning | offline | 32 | 32 | 7/32 (21.9%) |
| adult-learning | rest | 32 | 32 | 6/32 (18.8%) |
| adult-neighbor-market | ask | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | invest | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | rest | 13 | 13 | 5/13 (38.5%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 12 | 12 | 3/12 (25.0%) |
| child-library-map | invest | 12 | 12 | 5/12 (41.7%) |
| child-library-map | rest | 12 | 12 | 4/12 (33.3%) |
| child-transition | ask | 16 | 16 | 5/16 (31.2%) |
| child-transition | invest | 16 | 16 | 7/16 (43.8%) |
| child-transition | rest | 16 | 16 | 4/16 (25.0%) |
| child-wind-team | ask | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | invest | 4 | 4 | 2/4 (50.0%) |
| child-wind-team | rest | 4 | 4 | 0/4 (0.0%) |
| later-pass-on | ask | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | invest | 13 | 13 | 3/13 (23.1%) |
| later-pass-on | rest | 13 | 13 | 7/13 (53.8%) |
| later-reconnect | ask | 32 | 32 | 7/32 (21.9%) |
| later-reconnect | invest | 32 | 32 | 15/32 (46.9%) |
| later-reconnect | rest | 32 | 32 | 10/32 (31.2%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-voice-booth | ask | 19 | 19 | 7/19 (36.8%) |
| later-voice-booth | invest | 19 | 19 | 5/19 (26.3%) |
| later-voice-booth | rest | 19 | 19 | 7/19 (36.8%) |
| middle-garden-table | ask | 11 | 11 | 3/11 (27.3%) |
| middle-garden-table | invest | 11 | 11 | 2/11 (18.2%) |
| middle-garden-table | rest | 11 | 11 | 6/11 (54.5%) |
| middle-open-desk | ask | 6 | 6 | 1/6 (16.7%) |
| middle-open-desk | invest | 6 | 6 | 2/6 (33.3%) |
| middle-open-desk | rest | 6 | 6 | 3/6 (50.0%) |
| middle-rhythm | ask | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | invest | 15 | 15 | 5/15 (33.3%) |
| middle-rhythm | rest | 15 | 15 | 10/15 (66.7%) |
| middle-support | ask | 32 | 32 | 10/32 (31.2%) |
| middle-support | invest | 32 | 32 | 11/32 (34.4%) |
| middle-support | rest | 32 | 32 | 9/32 (28.1%) |
| middle-support | shareShift | 10 | 10 | 2/32 (6.2%) |
| middle-turn | ask | 32 | 32 | 7/32 (21.9%) |
| middle-turn | invest | 32 | 32 | 4/32 (12.5%) |
| middle-turn | offline | 32 | 32 | 10/32 (31.2%) |
| middle-turn | rest | 32 | 32 | 11/32 (34.4%) |
| teen-direction | ask | 32 | 32 | 7/32 (21.9%) |
| teen-direction | invest | 32 | 32 | 6/32 (18.8%) |
| teen-direction | leadWorkshop | 14 | 14 | 4/32 (12.5%) |
| teen-direction | offline | 32 | 32 | 5/32 (15.6%) |
| teen-direction | rest | 32 | 32 | 10/32 (31.2%) |
| teen-launch | ask | 25 | 25 | 11/25 (44.0%) |
| teen-launch | invest | 25 | 25 | 7/25 (28.0%) |
| teen-launch | rest | 25 | 25 | 7/25 (28.0%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | invest | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | rest | 7 | 7 | 1/7 (14.3%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |

相鄰相同行動類型：116/448 (25.9%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/164 (0.0%) | 0/164 (0.0%) | 0/326 (0.0%) |
| 財務安全 | 0/11 (0.0%) | 0/11 (0.0%) | 0/36 (0.0%) |
| 人際關係 | 0/473 (0.0%) | 0/473 (0.0%) | 0/945 (0.0%) |
| 技能 | 0/282 (0.0%) | 0/282 (0.0%) | 0/688 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/24 (0.0%) | 0/24 (0.0%) | 0/48 (0.0%) |
| 技能 | 0/24 (0.0%) | 0/24 (0.0%) | 0/24 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.learning-route | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |
| story.care-network | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) |

## 同背景、同Seed、不同策略

| 家庭 | 策略一 | 策略二 | 配對數 | 事件距離中位數 | 故事距離中位數 |
| --- | --- | --- | --- | --- | --- |
| jpn-1 | 投入優先 | 求助優先 | 32 | 1.0 | 3.0 |
| jpn-1 | 投入優先 | 休息優先 | 32 | 1.0 | 4.0 |
| jpn-1 | 投入優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 3.0 |
| jpn-1 | 求助優先 | 休息優先 | 32 | 0.0 | 1.0 |
| jpn-1 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 2.0 |
| jpn-1 | 休息優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 2.0 |
| jpn-2 | 投入優先 | 求助優先 | 32 | 1.0 | 3.0 |
| jpn-2 | 投入優先 | 休息優先 | 32 | 1.0 | 4.0 |
| jpn-2 | 投入優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 3.0 |
| jpn-2 | 求助優先 | 休息優先 | 32 | 0.0 | 1.0 |
| jpn-2 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 2.0 |
| jpn-2 | 休息優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 2.0 |
| usa-1 | 投入優先 | 求助優先 | 32 | 1.0 | 3.0 |
| usa-1 | 投入優先 | 休息優先 | 32 | 1.0 | 4.0 |
| usa-1 | 投入優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 3.0 |
| usa-1 | 求助優先 | 休息優先 | 32 | 0.0 | 1.0 |
| usa-1 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 2.0 |
| usa-1 | 休息優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 2.0 |
| usa-2 | 投入優先 | 求助優先 | 32 | 1.0 | 3.0 |
| usa-2 | 投入優先 | 休息優先 | 32 | 1.0 | 4.0 |
| usa-2 | 投入優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 3.0 |
| usa-2 | 求助優先 | 休息優先 | 32 | 0.0 | 1.0 |
| usa-2 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 2.0 |
| usa-2 | 休息優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 2.0 |
| ind-1 | 投入優先 | 求助優先 | 32 | 1.0 | 3.0 |
| ind-1 | 投入優先 | 休息優先 | 32 | 1.0 | 4.0 |
| ind-1 | 投入優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 3.0 |
| ind-1 | 求助優先 | 休息優先 | 32 | 0.0 | 1.0 |
| ind-1 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 2.0 |
| ind-1 | 休息優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 2.0 |
| ind-2 | 投入優先 | 求助優先 | 32 | 1.0 | 3.0 |
| ind-2 | 投入優先 | 休息優先 | 32 | 1.0 | 4.0 |
| ind-2 | 投入優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 3.0 |
| ind-2 | 求助優先 | 休息優先 | 32 | 0.0 | 1.0 |
| ind-2 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 2.0 |
| ind-2 | 休息優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 2.0 |
| ken-1 | 投入優先 | 求助優先 | 32 | 1.0 | 3.0 |
| ken-1 | 投入優先 | 休息優先 | 32 | 1.0 | 4.0 |
| ken-1 | 投入優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 3.0 |
| ken-1 | 求助優先 | 休息優先 | 32 | 0.0 | 1.0 |
| ken-1 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 2.0 |
| ken-1 | 休息優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 2.0 |
| ken-2 | 投入優先 | 求助優先 | 32 | 1.0 | 3.0 |
| ken-2 | 投入優先 | 休息優先 | 32 | 1.0 | 4.0 |
| ken-2 | 投入優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 3.0 |
| ken-2 | 求助優先 | 休息優先 | 32 | 0.0 | 1.0 |
| ken-2 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 2.0 |
| ken-2 | 休息優先 | 穩定亂數多樣選擇 | 32 | 0.0 | 2.0 |

零觸發只代表本批次未觀察到；完整分布、逐步資源及多hook聚合截斷來源見同名JSON。實機、VoiceOver與兒少重玩意願仍未驗收。
