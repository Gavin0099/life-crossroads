# 人生批次量測

固定四國、每國兩個虛構家庭、明列策略與Seed的模型批次；不是全球分布、真實事件率、現實因果或娛樂性證明。0次只表示本批次未觀察到，不能據此判定不可達。首次到100指記錄到的初始、跳躍後或決策後狀態；跳躍中沒有逐年觀測。

引擎 `rng-v2-1`；內容 `rng-v2-story-1`；資料 `lc01-data-2`；分析 `rng-v2-analysis-2`。
樣本：1024 局；Seeds：[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]；策略版本：lc05-policies-1。

事件距離只計不同event ID；故事距離另計同事件的變體。0距離包含在完整配對中。資源值不合成人生分數。

## 分群總覽

| 家庭 | 策略 | 事件路線數 | 事件差異中位數 | 完全相同率 | 健康最終100 | 財務安全最終100 | 人際關係最終100 | 技能最終100 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| jpn-1 | 投入優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 1/32 (3.1%) | 0/32 (0.0%) |
| jpn-1 | 求助優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-1 | 休息優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-1 | 穩定亂數多樣選擇 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-2 | 投入優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-2 | 求助優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-2 | 休息優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| jpn-2 | 穩定亂數多樣選擇 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-1 | 投入優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 1/32 (3.1%) | 0/32 (0.0%) |
| usa-1 | 求助優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-1 | 休息優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-1 | 穩定亂數多樣選擇 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-2 | 投入優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-2 | 求助優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-2 | 休息優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| usa-2 | 穩定亂數多樣選擇 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-1 | 投入優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 1/32 (3.1%) | 0/32 (0.0%) |
| ind-1 | 求助優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-1 | 休息優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-1 | 穩定亂數多樣選擇 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-2 | 投入優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-2 | 求助優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-2 | 休息優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ind-2 | 穩定亂數多樣選擇 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-1 | 投入優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 1/32 (3.1%) | 0/32 (0.0%) |
| ken-1 | 求助優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-1 | 休息優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-1 | 穩定亂數多樣選擇 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-2 | 投入優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-2 | 求助優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-2 | 休息優先 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |
| ken-2 | 穩定亂數多樣選擇 | 32 | 9.0 | 0/496 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) | 0/32 (0.0%) |

## 有實際前因的故事延續

只計有較早來源選擇、且出現延續變體的不同故事線；入門、恢復或只有標題差異不計。每局兩鏈是探索目標，休息不會被強迫安排舊約定。

| 家庭 | 策略 | 至少兩鏈／局 | 相鄰同事件類型 |
| --- | --- | --- | --- |
| jpn-1 | 投入優先 | 21/32 (65.6%) | 63/448 (14.1%) |
| jpn-1 | 求助優先 | 1/32 (3.1%) | 54/448 (12.1%) |
| jpn-1 | 休息優先 | 0/32 (0.0%) | 56/448 (12.5%) |
| jpn-1 | 穩定亂數多樣選擇 | 9/32 (28.1%) | 61/448 (13.6%) |
| jpn-2 | 投入優先 | 22/32 (68.8%) | 64/448 (14.3%) |
| jpn-2 | 求助優先 | 1/32 (3.1%) | 55/448 (12.3%) |
| jpn-2 | 休息優先 | 0/32 (0.0%) | 53/448 (11.8%) |
| jpn-2 | 穩定亂數多樣選擇 | 7/32 (21.9%) | 60/448 (13.4%) |
| usa-1 | 投入優先 | 21/32 (65.6%) | 63/448 (14.1%) |
| usa-1 | 求助優先 | 1/32 (3.1%) | 54/448 (12.1%) |
| usa-1 | 休息優先 | 0/32 (0.0%) | 56/448 (12.5%) |
| usa-1 | 穩定亂數多樣選擇 | 9/32 (28.1%) | 61/448 (13.6%) |
| usa-2 | 投入優先 | 22/32 (68.8%) | 64/448 (14.3%) |
| usa-2 | 求助優先 | 1/32 (3.1%) | 55/448 (12.3%) |
| usa-2 | 休息優先 | 0/32 (0.0%) | 53/448 (11.8%) |
| usa-2 | 穩定亂數多樣選擇 | 7/32 (21.9%) | 60/448 (13.4%) |
| ind-1 | 投入優先 | 21/32 (65.6%) | 63/448 (14.1%) |
| ind-1 | 求助優先 | 1/32 (3.1%) | 54/448 (12.1%) |
| ind-1 | 休息優先 | 0/32 (0.0%) | 56/448 (12.5%) |
| ind-1 | 穩定亂數多樣選擇 | 9/32 (28.1%) | 61/448 (13.6%) |
| ind-2 | 投入優先 | 22/32 (68.8%) | 64/448 (14.3%) |
| ind-2 | 求助優先 | 1/32 (3.1%) | 55/448 (12.3%) |
| ind-2 | 休息優先 | 0/32 (0.0%) | 53/448 (11.8%) |
| ind-2 | 穩定亂數多樣選擇 | 7/32 (21.9%) | 60/448 (13.4%) |
| ken-1 | 投入優先 | 21/32 (65.6%) | 63/448 (14.1%) |
| ken-1 | 求助優先 | 1/32 (3.1%) | 54/448 (12.1%) |
| ken-1 | 休息優先 | 0/32 (0.0%) | 56/448 (12.5%) |
| ken-1 | 穩定亂數多樣選擇 | 9/32 (28.1%) | 61/448 (13.6%) |
| ken-2 | 投入優先 | 22/32 (68.8%) | 64/448 (14.3%) |
| ken-2 | 求助優先 | 1/32 (3.1%) | 55/448 (12.3%) |
| ken-2 | 休息優先 | 0/32 (0.0%) | 53/448 (11.8%) |
| ken-2 | 穩定亂數多樣選擇 | 7/32 (21.9%) | 60/448 (13.4%) |

## jpn-1／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 15/96 (15.6%) | 15/55 (27.3%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 8/96 (8.3%) | 8/91 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 112/128 (87.5%) | 11/128 (8.6%) | 11/112 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 16} |
| teen-tool-library | 17–32 | 114/128 (89.1%) | 6/128 (4.7%) | 6/114 (5.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 14} |
| teen-launch | 21–25 | 60/64 (93.8%) | 5/64 (7.8%) | 5/60 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 4} |
| teen-repair-table | 17–32 | 94/128 (73.4%) | 17/128 (13.3%) | 17/94 (18.1%) | made-a-project: 0/128 (0.0%); repair-practice: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 15, &#x27;one-shot&#x27;: 34} |
| teen-shared-kitchen | 17–32 | 108/128 (84.4%) | 10/128 (7.8%) | 10/108 (9.3%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 20} |
| teen-shared-room | 21–32 | 84/96 (87.5%) | 8/96 (8.3%) | 8/84 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| adult-learning | 25–45 | 92/128 (71.9%) | 3/128 (2.3%) | 3/92 (3.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 6} |
| adult-local-trail | 25–59 | 122/192 (63.5%) | 12/192 (6.2%) | 12/122 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 47} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 127/192 (66.1%) | 14/192 (7.3%) | 14/127 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 40} |
| adult-shift-offer | 25–52 | 106/160 (66.2%) | 9/160 (5.6%) | 9/106 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| adult-balance | 32–52 | 95/128 (74.2%) | 4/128 (3.1%) | 4/95 (4.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 1, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 1} |
| adult-broken-bicycle | 25–59 | 130/192 (67.7%) | 14/192 (7.3%) | 14/130 (10.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| adult-neighbor-market | 25–52 | 106/160 (66.2%) | 4/160 (2.5%) | 4/106 (3.8%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 20, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 136/192 (70.8%) | 15/192 (7.8%) | 15/136 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 28} |
| middle-seed-exchange | 45–72 | 150/160 (93.8%) | 9/160 (5.6%) | 9/150 (6.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 10} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 10/192 (5.2%) | 10/140 (7.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-rest-circle | 45–72 | 143/160 (89.4%) | 11/160 (6.9%) | 11/143 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 17} |
| middle-support | 52–72 | 116/128 (90.6%) | 12/128 (9.4%) | 12/116 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 144/192 (75.0%) | 6/192 (3.1%) | 6/144 (4.2%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 17} |
| middle-open-desk | 45–72 | 126/160 (78.8%) | 14/160 (8.8%) | 14/126 (11.1%) | shared-care-contacts: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 34} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 5/64 (7.8%) | 5/62 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 87/96 (90.6%) | 9/96 (9.4%) | 9/87 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 9} |
| later-voice-booth | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 7} |
| later-path-map | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 4/32 (12.5%) | 4/32 (12.5%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 4 | 4 | 0/4 (0.0%) |
| adult-balance | invest | 4 | 4 | 4/4 (100.0%) |
| adult-balance | rest | 4 | 4 | 0/4 (0.0%) |
| adult-broken-bicycle | borrow | 14 | 14 | 0/14 (0.0%) |
| adult-broken-bicycle | repairTogether | 14 | 14 | 14/14 (100.0%) |
| adult-broken-bicycle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 3 | 3 | 0/3 (0.0%) |
| adult-learning | invest | 3 | 3 | 3/3 (100.0%) |
| adult-learning | offline | 3 | 3 | 0/3 (0.0%) |
| adult-learning | rest | 3 | 3 | 0/3 (0.0%) |
| adult-local-trail | lead | 7 | 7 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 12/12 (100.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | lead | 3 | 3 | 3/13 (23.1%) |
| adult-meal-circle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | trial | 13 | 13 | 10/13 (76.9%) |
| adult-neighbor-market | ask | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | invest | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 14 | 14 | 14/14 (100.0%) |
| adult-repair-coop | lead | 12 | 12 | 0/14 (0.0%) |
| adult-repair-coop | rest | 14 | 14 | 0/14 (0.0%) |
| adult-repair-coop | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-shift-offer | extraShift | 9 | 9 | 9/9 (100.0%) |
| adult-shift-offer | predictable | 9 | 9 | 0/9 (0.0%) |
| adult-shift-offer | rest | 9 | 9 | 0/9 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 0/5 (0.0%) |
| child-library-map | invest | 5 | 5 | 5/5 (100.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 10 | 10 | 10/10 (100.0%) |
| child-quiet-stage | perform | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | rest | 10 | 10 | 0/10 (0.0%) |
| child-rain-notebook | observe | 13 | 13 | 13/13 (100.0%) |
| child-rain-notebook | rest | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | seekGuide | 13 | 13 | 0/13 (0.0%) |
| child-transition | ask | 7 | 7 | 0/7 (0.0%) |
| child-transition | invest | 7 | 7 | 7/7 (100.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 15 | 15 | 0/15 (0.0%) |
| child-wind-team | invest | 15 | 15 | 15/15 (100.0%) |
| child-wind-team | rest | 15 | 15 | 0/15 (0.0%) |
| later-pass-on | ask | 5 | 5 | 0/5 (0.0%) |
| later-pass-on | invest | 5 | 5 | 5/5 (100.0%) |
| later-pass-on | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | lead | 6 | 6 | 6/7 (85.7%) |
| later-path-map | rest | 7 | 7 | 0/7 (0.0%) |
| later-path-map | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-path-map | shortWalk | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | ask | 4 | 4 | 0/4 (0.0%) |
| later-reconnect | invest | 4 | 4 | 4/4 (100.0%) |
| later-reconnect | rest | 4 | 4 | 0/4 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 7/7 (100.0%) |
| later-shared-recipes | lead | 6 | 6 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | lead | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | learnAgain | 9 | 9 | 9/9 (100.0%) |
| later-tool-stories | rest | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | seekGuide | 9 | 9 | 0/9 (0.0%) |
| later-voice-booth | ask | 6 | 6 | 0/6 (0.0%) |
| later-voice-booth | invest | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | rest | 6 | 6 | 0/6 (0.0%) |
| middle-friend-letter | rest | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | seekGuide | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | write | 15 | 15 | 15/15 (100.0%) |
| middle-garden-table | ask | 6 | 6 | 0/6 (0.0%) |
| middle-garden-table | invest | 6 | 6 | 6/6 (100.0%) |
| middle-garden-table | rest | 6 | 6 | 0/6 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | boundaries | 11 | 11 | 0/11 (0.0%) |
| middle-rest-circle | rest | 11 | 11 | 11/11 (100.0%) |
| middle-rest-circle | walk | 11 | 11 | 0/11 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | invest | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 3 | 3 | 3/9 (33.3%) |
| middle-seed-exchange | onePot | 9 | 9 | 6/9 (66.7%) |
| middle-seed-exchange | rest | 9 | 9 | 0/9 (0.0%) |
| middle-seed-exchange | seekGuide | 9 | 9 | 0/9 (0.0%) |
| middle-skill-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | study | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | teach | 10 | 10 | 0/10 (0.0%) |
| middle-support | ask | 12 | 12 | 0/12 (0.0%) |
| middle-support | invest | 12 | 12 | 12/12 (100.0%) |
| middle-support | rest | 12 | 12 | 0/12 (0.0%) |
| middle-support | shareShift | 12 | 12 | 0/12 (0.0%) |
| middle-turn | ask | 7 | 7 | 0/7 (0.0%) |
| middle-turn | invest | 7 | 7 | 7/7 (100.0%) |
| middle-turn | offline | 7 | 7 | 0/7 (0.0%) |
| middle-turn | rest | 7 | 7 | 0/7 (0.0%) |
| teen-direction | ask | 8 | 8 | 0/8 (0.0%) |
| teen-direction | invest | 8 | 8 | 8/8 (100.0%) |
| teen-direction | leadWorkshop | 8 | 8 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 0/8 (0.0%) |
| teen-launch | ask | 5 | 5 | 0/5 (0.0%) |
| teen-launch | invest | 5 | 5 | 5/5 (100.0%) |
| teen-launch | rest | 5 | 5 | 0/5 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 17 | 17 | 0/17 (0.0%) |
| teen-repair-table | invest | 17 | 17 | 17/17 (100.0%) |
| teen-repair-table | rest | 17 | 17 | 0/17 (0.0%) |
| teen-river-survey | join | 11 | 11 | 11/11 (100.0%) |
| teen-river-survey | lead | 6 | 6 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | seekGuide | 11 | 11 | 0/11 (0.0%) |
| teen-shared-kitchen | ask | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | invest | 10 | 10 | 10/10 (100.0%) |
| teen-shared-kitchen | rest | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | agreement | 8 | 8 | 8/8 (100.0%) |
| teen-shared-room | privateRoom | 8 | 8 | 0/8 (0.0%) |
| teen-shared-room | rest | 8 | 8 | 0/8 (0.0%) |
| teen-tool-library | practice | 6 | 6 | 6/6 (100.0%) |
| teen-tool-library | rest | 6 | 6 | 0/6 (0.0%) |
| teen-tool-library | seekGuide | 6 | 6 | 0/6 (0.0%) |

相鄰相同行動類型：218/448 (48.7%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/31 (0.0%) | 0/31 (0.0%) | 0/42 (0.0%) |
| 財務安全 | 0/48 (0.0%) | 0/48 (0.0%) | 0/94 (0.0%) |
| 人際關係 | 0/455 (0.0%) | 0/455 (0.0%) | 0/967 (0.0%) |
| 技能 | 0/343 (0.0%) | 0/343 (0.0%) | 0/1216 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/42 (0.0%) | 0/42 (0.0%) | 0/42 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 4/32 (12.5%) | 4/32 (12.5%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) |
| story.repair | 32/32 (100.0%) | 19/32 (59.4%) | 18/32 (56.2%) |
| story.kitchen | 24/32 (75.0%) | 16/32 (50.0%) | 9/32 (28.1%) |
| story.garden | 12/32 (37.5%) | 9/32 (28.1%) | 3/32 (9.4%) |
| story.nature | 24/32 (75.0%) | 21/32 (65.6%) | 14/32 (43.8%) |

## jpn-1／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 17/96 (17.7%) | 17/55 (30.9%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 6/96 (6.2%) | 6/91 (6.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 108/128 (84.4%) | 11/128 (8.6%) | 11/108 (10.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 20} |
| teen-tool-library | 17–32 | 109/128 (85.2%) | 9/128 (7.0%) | 9/109 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 19} |
| teen-launch | 21–25 | 57/64 (89.1%) | 9/64 (14.1%) | 9/57 (15.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 7} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 44/128 (34.4%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 44} |
| teen-shared-kitchen | 17–32 | 101/128 (78.9%) | 13/128 (10.2%) | 13/101 (12.9%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 27} |
| teen-shared-room | 21–32 | 80/96 (83.3%) | 10/96 (10.4%) | 10/80 (12.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 16} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 123/192 (64.1%) | 12/192 (6.2%) | 12/123 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 46} |
| adult-meal-circle | 25–59 | 136/192 (70.8%) | 13/192 (6.8%) | 13/136 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 29} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 93/128 (72.7%) | 5/128 (3.9%) | 5/93 (5.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 4} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 138/192 (71.9%) | 12/192 (6.2%) | 12/138 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 23} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 9/128 (7.0%) | 9/116 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 21/160 (13.1%) | 4/160 (2.5%) | 4/21 (19.0%) | shared-care-contacts: 130/160 (81.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 130, &#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 9} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 5 | 5 | 5/5 (100.0%) |
| adult-balance | invest | 5 | 5 | 0/5 (0.0%) |
| adult-balance | rest | 5 | 5 | 0/5 (0.0%) |
| adult-broken-bicycle | borrow | 15 | 15 | 15/15 (100.0%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 0/15 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 6 | 6 | 6/6 (100.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 0/6 (0.0%) |
| adult-local-trail | lead | 0 | 0 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 13/13 (100.0%) |
| adult-meal-circle | trial | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | ask | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | invest | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 5/5 (100.0%) |
| child-library-map | invest | 5 | 5 | 0/5 (0.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | perform | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | rest | 10 | 10 | 10/10 (100.0%) |
| child-rain-notebook | observe | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | rest | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | seekGuide | 13 | 13 | 13/13 (100.0%) |
| child-transition | ask | 7 | 7 | 7/7 (100.0%) |
| child-transition | invest | 7 | 7 | 0/7 (0.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | invest | 17 | 17 | 0/17 (0.0%) |
| child-wind-team | rest | 17 | 17 | 0/17 (0.0%) |
| later-pass-on | ask | 6 | 6 | 6/6 (100.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 0/6 (0.0%) |
| later-path-map | lead | 0 | 0 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | seekGuide | 5 | 5 | 5/5 (100.0%) |
| later-path-map | shortWalk | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | ask | 9 | 9 | 9/9 (100.0%) |
| later-reconnect | invest | 9 | 9 | 0/9 (0.0%) |
| later-reconnect | rest | 9 | 9 | 0/9 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | ask | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | invest | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 8/8 (100.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 0/8 (0.0%) |
| middle-open-desk | ask | 4 | 4 | 4/4 (100.0%) |
| middle-open-desk | invest | 4 | 4 | 0/4 (0.0%) |
| middle-open-desk | rest | 4 | 4 | 0/4 (0.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 14/14 (100.0%) |
| middle-rest-circle | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | walk | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | invest | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 9 | 9 | 9/9 (100.0%) |
| middle-support | invest | 9 | 9 | 0/9 (0.0%) |
| middle-support | rest | 9 | 9 | 0/9 (0.0%) |
| middle-support | shareShift | 2 | 2 | 0/9 (0.0%) |
| middle-turn | ask | 9 | 9 | 9/9 (100.0%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 0/9 (0.0%) |
| middle-turn | rest | 9 | 9 | 0/9 (0.0%) |
| teen-direction | ask | 6 | 6 | 6/6 (100.0%) |
| teen-direction | invest | 6 | 6 | 0/6 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/6 (0.0%) |
| teen-direction | offline | 6 | 6 | 0/6 (0.0%) |
| teen-direction | rest | 6 | 6 | 0/6 (0.0%) |
| teen-launch | ask | 9 | 9 | 9/9 (100.0%) |
| teen-launch | invest | 9 | 9 | 0/9 (0.0%) |
| teen-launch | rest | 9 | 9 | 0/9 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | seekGuide | 11 | 11 | 11/11 (100.0%) |
| teen-shared-kitchen | ask | 13 | 13 | 13/13 (100.0%) |
| teen-shared-kitchen | invest | 13 | 13 | 0/13 (0.0%) |
| teen-shared-kitchen | rest | 13 | 13 | 0/13 (0.0%) |
| teen-shared-room | agreement | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | privateRoom | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | practice | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | rest | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | seekGuide | 9 | 9 | 9/9 (100.0%) |

相鄰相同行動類型：370/448 (82.6%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/56 (0.0%) | 0/56 (0.0%) | 0/112 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/438 (0.0%) | 0/438 (0.0%) | 0/732 (0.0%) |
| 技能 | 0/409 (0.0%) | 0/409 (0.0%) | 0/409 (0.0%) |

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
| story.childhood-connection | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.learning-route | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.care-network | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.repair | 25/32 (78.1%) | 15/32 (46.9%) | 9/32 (28.1%) |
| story.kitchen | 22/32 (68.8%) | 16/32 (50.0%) | 7/32 (21.9%) |
| story.garden | 15/32 (46.9%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 24/32 (75.0%) | 22/32 (68.8%) | 13/32 (40.6%) |

## jpn-1／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 59/96 (61.5%) | 12/96 (12.5%) | 12/59 (20.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 15/96 (15.6%) | 15/57 (26.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | windmill-promise: 96/96 (100.0%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 96, &#x27;milestone-slot&#x27;: 32} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 6/96 (6.2%) | 6/91 (6.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 109/128 (85.2%) | 10/128 (7.8%) | 10/109 (9.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 19} |
| teen-tool-library | 17–32 | 106/128 (82.8%) | 10/128 (7.8%) | 10/106 (9.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-launch | 21–25 | 56/64 (87.5%) | 10/64 (15.6%) | 10/56 (17.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 8} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 128/128 (100.0%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 128} |
| teen-shared-kitchen | 17–32 | 92/128 (71.9%) | 16/128 (12.5%) | 16/92 (17.4%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 14, &#x27;one-shot&#x27;: 36} |
| teen-shared-room | 21–32 | 78/96 (81.2%) | 11/96 (11.5%) | 11/78 (14.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 130/192 (67.7%) | 10/192 (5.2%) | 10/130 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 37} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 100/160 (62.5%) | 10/160 (6.2%) | 10/100 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 15, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 7/128 (5.5%) | 7/92 (7.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 100/160 (62.5%) | 5/160 (3.1%) | 5/100 (5.0%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 15} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 140/160 (87.5%) | 13/160 (8.1%) | 13/140 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 20} |
| middle-skill-exchange | 32–65 | 137/192 (71.4%) | 12/192 (6.2%) | 12/137 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| middle-turn | 45–59 | 83/96 (86.5%) | 10/96 (10.4%) | 10/83 (12.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 13} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 15/160 (9.4%) | 15/140 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 118/128 (92.2%) | 10/128 (7.8%) | 10/118 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 10} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 0/160 (0.0%) | 0/160 (0.0%) | — (0/0) | shared-care-contacts: 160/160 (100.0%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 160} |
| middle-rhythm | 59–72 | 82/96 (85.4%) | 13/96 (13.5%) | 13/82 (15.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 14} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 6/96 (6.2%) | 6/87 (6.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 10/96 (10.4%) | 10/87 (11.5%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 93/96 (96.9%) | 3/96 (3.1%) | 3/93 (3.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 3} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 3/32 (9.4%) | 3/32 (9.4%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 7 | 7 | 0/7 (0.0%) |
| adult-balance | invest | 7 | 7 | 0/7 (0.0%) |
| adult-balance | rest | 7 | 7 | 7/7 (100.0%) |
| adult-broken-bicycle | borrow | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 15/15 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 6/6 (100.0%) |
| adult-local-trail | lead | 0 | 0 | 0/10 (0.0%) |
| adult-local-trail | record | 10 | 10 | 0/10 (0.0%) |
| adult-local-trail | rest | 10 | 10 | 10/10 (100.0%) |
| adult-local-trail | seekGuide | 10 | 10 | 0/10 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 13/13 (100.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | trial | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | ask | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | invest | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | rest | 5 | 5 | 5/5 (100.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 12/12 (100.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 12 | 12 | 0/12 (0.0%) |
| child-library-map | invest | 12 | 12 | 0/12 (0.0%) |
| child-library-map | rest | 12 | 12 | 12/12 (100.0%) |
| child-quiet-stage | backstage | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | perform | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | rest | 12 | 12 | 12/12 (100.0%) |
| child-rain-notebook | observe | 15 | 15 | 0/15 (0.0%) |
| child-rain-notebook | rest | 15 | 15 | 15/15 (100.0%) |
| child-rain-notebook | seekGuide | 15 | 15 | 0/15 (0.0%) |
| child-transition | ask | 8 | 8 | 0/8 (0.0%) |
| child-transition | invest | 8 | 8 | 0/8 (0.0%) |
| child-transition | rest | 8 | 8 | 8/8 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 6/6 (100.0%) |
| later-path-map | lead | 0 | 0 | 0/3 (0.0%) |
| later-path-map | rest | 3 | 3 | 3/3 (100.0%) |
| later-path-map | seekGuide | 3 | 3 | 0/3 (0.0%) |
| later-path-map | shortWalk | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | ask | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | invest | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | rest | 3 | 3 | 3/3 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-shared-recipes | cookOnce | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/6 (0.0%) |
| later-shared-recipes | rest | 6 | 6 | 6/6 (100.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 6/6 (100.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-voice-booth | ask | 10 | 10 | 0/10 (0.0%) |
| later-voice-booth | invest | 10 | 10 | 0/10 (0.0%) |
| later-voice-booth | rest | 10 | 10 | 10/10 (100.0%) |
| middle-friend-letter | rest | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 8/8 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rest-circle | boundaries | 15 | 15 | 0/15 (0.0%) |
| middle-rest-circle | rest | 15 | 15 | 15/15 (100.0%) |
| middle-rest-circle | walk | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | ask | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | invest | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/13 (0.0%) |
| middle-seed-exchange | onePot | 13 | 13 | 0/13 (0.0%) |
| middle-seed-exchange | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | seekGuide | 13 | 13 | 0/13 (0.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 10 | 10 | 0/10 (0.0%) |
| middle-support | invest | 10 | 10 | 0/10 (0.0%) |
| middle-support | rest | 10 | 10 | 10/10 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/10 (0.0%) |
| middle-turn | ask | 10 | 10 | 0/10 (0.0%) |
| middle-turn | invest | 10 | 10 | 0/10 (0.0%) |
| middle-turn | offline | 10 | 10 | 0/10 (0.0%) |
| middle-turn | rest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | ask | 6 | 6 | 0/6 (0.0%) |
| teen-direction | invest | 6 | 6 | 0/6 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/6 (0.0%) |
| teen-direction | offline | 6 | 6 | 0/6 (0.0%) |
| teen-direction | rest | 6 | 6 | 6/6 (100.0%) |
| teen-launch | ask | 10 | 10 | 0/10 (0.0%) |
| teen-launch | invest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | rest | 10 | 10 | 10/10 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 10 | 10 | 0/10 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/10 (0.0%) |
| teen-river-survey | rest | 10 | 10 | 10/10 (100.0%) |
| teen-river-survey | seekGuide | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | ask | 16 | 16 | 0/16 (0.0%) |
| teen-shared-kitchen | invest | 16 | 16 | 0/16 (0.0%) |
| teen-shared-kitchen | rest | 16 | 16 | 16/16 (100.0%) |
| teen-shared-room | agreement | 11 | 11 | 0/11 (0.0%) |
| teen-shared-room | privateRoom | 11 | 11 | 0/11 (0.0%) |
| teen-shared-room | rest | 11 | 11 | 11/11 (100.0%) |
| teen-tool-library | practice | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | seekGuide | 10 | 10 | 0/10 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/290 (0.0%) | 0/290 (0.0%) | 0/290 (0.0%) |
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
| story.childhood-connection | 32/32 (100.0%) | 3/32 (9.4%) | 3/32 (9.4%) |
| story.learning-route | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.care-network | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.repair | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.kitchen | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.garden | 0/32 (0.0%) | 13/32 (40.6%) | 0/32 (0.0%) |
| story.nature | 0/32 (0.0%) | 18/32 (56.2%) | 0/32 (0.0%) |

## jpn-1／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 33/96 (34.4%) | 14/96 (14.6%) | 14/33 (42.4%) | windmill-promise: 34/96 (35.4%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 34, &#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 16} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 90/96 (93.8%) | 7/96 (7.3%) | 7/90 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| teen-river-survey | 17–32 | 105/128 (82.0%) | 11/128 (8.6%) | 11/105 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 23} |
| teen-tool-library | 17–32 | 113/128 (88.3%) | 7/128 (5.5%) | 7/113 (6.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 15} |
| teen-launch | 21–25 | 58/64 (90.6%) | 7/64 (10.9%) | 7/58 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-repair-table | 17–32 | 52/128 (40.6%) | 6/128 (4.7%) | 6/52 (11.5%) | made-a-project: 64/128 (50.0%); repair-practice: 20/128 (15.6%); 規則排除：{&#x27;condition:made-a-project&#x27;: 64, &#x27;condition:repair-practice&#x27;: 20, &#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 12} |
| teen-shared-kitchen | 17–32 | 102/128 (79.7%) | 12/128 (9.4%) | 12/102 (11.8%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 26} |
| teen-shared-room | 21–32 | 82/96 (85.4%) | 9/96 (9.4%) | 9/82 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 14} |
| adult-learning | 25–45 | 91/128 (71.1%) | 5/128 (3.9%) | 5/91 (5.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| adult-local-trail | 25–59 | 127/192 (66.1%) | 11/192 (5.7%) | 11/127 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 41} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 6/128 (4.7%) | 6/92 (6.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 129/192 (67.2%) | 18/192 (9.4%) | 18/129 (14.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 11/192 (5.7%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 11/128 (8.6%) | 11/116 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 137/192 (71.4%) | 9/192 (4.7%) | 9/137 (6.6%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 25} |
| middle-open-desk | 45–72 | 44/160 (27.5%) | 4/160 (2.5%) | 4/44 (9.1%) | shared-care-contacts: 106/160 (66.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 106, &#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 10} |
| middle-rhythm | 59–72 | 84/96 (87.5%) | 11/96 (11.5%) | 11/84 (13.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 7} |
| later-tool-stories | 59–72 | 86/96 (89.6%) | 7/96 (7.3%) | 7/86 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 10} |
| later-voice-booth | 59–72 | 89/96 (92.7%) | 7/96 (7.3%) | 7/89 (7.9%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 7} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 6 | 6 | 0/6 (0.0%) |
| adult-balance | invest | 6 | 6 | 4/6 (66.7%) |
| adult-balance | rest | 6 | 6 | 2/6 (33.3%) |
| adult-broken-bicycle | borrow | 15 | 15 | 7/15 (46.7%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 3/15 (20.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 5/15 (33.3%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 5 | 5 | 0/5 (0.0%) |
| adult-learning | invest | 5 | 5 | 2/5 (40.0%) |
| adult-learning | offline | 5 | 5 | 1/5 (20.0%) |
| adult-learning | rest | 5 | 5 | 2/5 (40.0%) |
| adult-local-trail | lead | 1 | 1 | 0/11 (0.0%) |
| adult-local-trail | record | 11 | 11 | 6/11 (54.5%) |
| adult-local-trail | rest | 11 | 11 | 3/11 (27.3%) |
| adult-local-trail | seekGuide | 11 | 11 | 2/11 (18.2%) |
| adult-meal-circle | lead | 2 | 2 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 3/13 (23.1%) |
| adult-meal-circle | seekGuide | 13 | 13 | 6/13 (46.2%) |
| adult-meal-circle | trial | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | ask | 4 | 4 | 1/4 (25.0%) |
| adult-neighbor-market | invest | 4 | 4 | 2/4 (50.0%) |
| adult-neighbor-market | rest | 4 | 4 | 1/4 (25.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 2/12 (16.7%) |
| adult-repair-coop | lead | 2 | 2 | 1/12 (8.3%) |
| adult-repair-coop | rest | 12 | 12 | 4/12 (33.3%) |
| adult-repair-coop | seekGuide | 12 | 12 | 5/12 (41.7%) |
| adult-shift-offer | extraShift | 10 | 10 | 5/10 (50.0%) |
| adult-shift-offer | predictable | 10 | 10 | 3/10 (30.0%) |
| adult-shift-offer | rest | 10 | 10 | 2/10 (20.0%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 6 | 6 | 1/6 (16.7%) |
| child-library-map | invest | 6 | 6 | 2/6 (33.3%) |
| child-library-map | rest | 6 | 6 | 3/6 (50.0%) |
| child-quiet-stage | backstage | 10 | 10 | 3/10 (30.0%) |
| child-quiet-stage | perform | 10 | 10 | 5/10 (50.0%) |
| child-quiet-stage | rest | 10 | 10 | 2/10 (20.0%) |
| child-rain-notebook | observe | 13 | 13 | 2/13 (15.4%) |
| child-rain-notebook | rest | 13 | 13 | 5/13 (38.5%) |
| child-rain-notebook | seekGuide | 13 | 13 | 6/13 (46.2%) |
| child-transition | ask | 7 | 7 | 2/7 (28.6%) |
| child-transition | invest | 7 | 7 | 5/7 (71.4%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 14 | 14 | 5/14 (35.7%) |
| child-wind-team | invest | 14 | 14 | 0/14 (0.0%) |
| child-wind-team | rest | 14 | 14 | 9/14 (64.3%) |
| later-pass-on | ask | 6 | 6 | 1/6 (16.7%) |
| later-pass-on | invest | 6 | 6 | 3/6 (50.0%) |
| later-pass-on | rest | 6 | 6 | 2/6 (33.3%) |
| later-path-map | lead | 2 | 2 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 4/5 (80.0%) |
| later-path-map | seekGuide | 5 | 5 | 0/5 (0.0%) |
| later-path-map | shortWalk | 5 | 5 | 1/5 (20.0%) |
| later-reconnect | ask | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | invest | 7 | 7 | 3/7 (42.9%) |
| later-reconnect | rest | 7 | 7 | 3/7 (42.9%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-shared-recipes | cookOnce | 6 | 6 | 2/6 (33.3%) |
| later-shared-recipes | lead | 2 | 2 | 1/6 (16.7%) |
| later-shared-recipes | rest | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 3/6 (50.0%) |
| later-tool-stories | lead | 4 | 4 | 4/7 (57.1%) |
| later-tool-stories | learnAgain | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | rest | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | seekGuide | 7 | 7 | 1/7 (14.3%) |
| later-voice-booth | ask | 7 | 7 | 2/7 (28.6%) |
| later-voice-booth | invest | 7 | 7 | 3/7 (42.9%) |
| later-voice-booth | rest | 7 | 7 | 2/7 (28.6%) |
| middle-friend-letter | rest | 18 | 18 | 5/18 (27.8%) |
| middle-friend-letter | seekGuide | 18 | 18 | 7/18 (38.9%) |
| middle-friend-letter | write | 18 | 18 | 6/18 (33.3%) |
| middle-garden-table | ask | 9 | 9 | 2/9 (22.2%) |
| middle-garden-table | invest | 9 | 9 | 4/9 (44.4%) |
| middle-garden-table | rest | 9 | 9 | 3/9 (33.3%) |
| middle-open-desk | ask | 4 | 4 | 2/4 (50.0%) |
| middle-open-desk | invest | 4 | 4 | 1/4 (25.0%) |
| middle-open-desk | rest | 4 | 4 | 1/4 (25.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 2/14 (14.3%) |
| middle-rest-circle | rest | 14 | 14 | 6/14 (42.9%) |
| middle-rest-circle | walk | 14 | 14 | 6/14 (42.9%) |
| middle-rhythm | ask | 11 | 11 | 1/11 (9.1%) |
| middle-rhythm | invest | 11 | 11 | 3/11 (27.3%) |
| middle-rhythm | rest | 11 | 11 | 7/11 (63.6%) |
| middle-seed-exchange | lead | 2 | 2 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 5/10 (50.0%) |
| middle-seed-exchange | rest | 10 | 10 | 1/10 (10.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 4/10 (40.0%) |
| middle-skill-exchange | rest | 11 | 11 | 4/11 (36.4%) |
| middle-skill-exchange | study | 11 | 11 | 1/11 (9.1%) |
| middle-skill-exchange | teach | 11 | 11 | 6/11 (54.5%) |
| middle-support | ask | 11 | 11 | 3/11 (27.3%) |
| middle-support | invest | 11 | 11 | 5/11 (45.5%) |
| middle-support | rest | 11 | 11 | 2/11 (18.2%) |
| middle-support | shareShift | 5 | 5 | 1/11 (9.1%) |
| middle-turn | ask | 9 | 9 | 3/9 (33.3%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 4/9 (44.4%) |
| middle-turn | rest | 9 | 9 | 2/9 (22.2%) |
| teen-direction | ask | 7 | 7 | 1/7 (14.3%) |
| teen-direction | invest | 7 | 7 | 1/7 (14.3%) |
| teen-direction | leadWorkshop | 2 | 2 | 1/7 (14.3%) |
| teen-direction | offline | 7 | 7 | 1/7 (14.3%) |
| teen-direction | rest | 7 | 7 | 3/7 (42.9%) |
| teen-launch | ask | 7 | 7 | 2/7 (28.6%) |
| teen-launch | invest | 7 | 7 | 2/7 (28.6%) |
| teen-launch | rest | 7 | 7 | 3/7 (42.9%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 6 | 6 | 0/6 (0.0%) |
| teen-repair-table | invest | 6 | 6 | 3/6 (50.0%) |
| teen-repair-table | rest | 6 | 6 | 3/6 (50.0%) |
| teen-river-survey | join | 11 | 11 | 2/11 (18.2%) |
| teen-river-survey | lead | 1 | 1 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 2/11 (18.2%) |
| teen-river-survey | seekGuide | 11 | 11 | 7/11 (63.6%) |
| teen-shared-kitchen | ask | 12 | 12 | 3/12 (25.0%) |
| teen-shared-kitchen | invest | 12 | 12 | 6/12 (50.0%) |
| teen-shared-kitchen | rest | 12 | 12 | 3/12 (25.0%) |
| teen-shared-room | agreement | 9 | 9 | 3/9 (33.3%) |
| teen-shared-room | privateRoom | 9 | 9 | 4/9 (44.4%) |
| teen-shared-room | rest | 9 | 9 | 2/9 (22.2%) |
| teen-tool-library | practice | 7 | 7 | 1/7 (14.3%) |
| teen-tool-library | rest | 7 | 7 | 4/7 (57.1%) |
| teen-tool-library | seekGuide | 7 | 7 | 2/7 (28.6%) |

相鄰相同行動類型：113/448 (25.2%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/186 (0.0%) | 0/186 (0.0%) | 0/366 (0.0%) |
| 財務安全 | 0/25 (0.0%) | 0/25 (0.0%) | 0/56 (0.0%) |
| 人際關係 | 0/406 (0.0%) | 0/406 (0.0%) | 0/666 (0.0%) |
| 技能 | 0/242 (0.0%) | 0/242 (0.0%) | 0/551 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/9 (0.0%) | 0/9 (0.0%) | 0/9 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) |
| story.learning-route | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) |
| story.care-network | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |
| story.repair | 22/32 (68.8%) | 15/32 (46.9%) | 6/32 (18.8%) |
| story.kitchen | 20/32 (62.5%) | 16/32 (50.0%) | 8/32 (25.0%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 19/32 (59.4%) | 21/32 (65.6%) | 10/32 (31.2%) |

## jpn-2／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 11/96 (11.5%) | 11/60 (18.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 14/96 (14.6%) | 14/57 (24.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 16/96 (16.7%) | 16/55 (29.1%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 90/96 (93.8%) | 10/96 (10.4%) | 10/90 (11.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-river-survey | 17–32 | 110/128 (85.9%) | 13/128 (10.2%) | 13/110 (11.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| teen-tool-library | 17–32 | 114/128 (89.1%) | 6/128 (4.7%) | 6/114 (5.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 14} |
| teen-launch | 21–25 | 60/64 (93.8%) | 5/64 (7.8%) | 5/60 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 4} |
| teen-repair-table | 17–32 | 91/128 (71.1%) | 18/128 (14.1%) | 18/91 (19.8%) | made-a-project: 0/128 (0.0%); repair-practice: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 16, &#x27;one-shot&#x27;: 37} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 80/96 (83.3%) | 10/96 (10.4%) | 10/80 (12.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 16} |
| adult-learning | 25–45 | 91/128 (71.1%) | 4/128 (3.1%) | 4/91 (4.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| adult-local-trail | 25–59 | 122/192 (63.5%) | 12/192 (6.2%) | 12/122 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 47} |
| adult-meal-circle | 25–59 | 139/192 (72.4%) | 12/192 (6.2%) | 12/139 (8.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 26} |
| adult-repair-coop | 25–59 | 127/192 (66.1%) | 14/192 (7.3%) | 14/127 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 40} |
| adult-shift-offer | 25–52 | 106/160 (66.2%) | 9/160 (5.6%) | 9/106 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| adult-balance | 32–52 | 95/128 (74.2%) | 4/128 (3.1%) | 4/95 (4.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 1, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 1} |
| adult-broken-bicycle | 25–59 | 131/192 (68.2%) | 13/192 (6.8%) | 13/131 (9.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 35} |
| adult-neighbor-market | 25–52 | 106/160 (66.2%) | 4/160 (2.5%) | 4/106 (3.8%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 20, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 136/192 (70.8%) | 15/192 (7.8%) | 15/136 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 28} |
| middle-seed-exchange | 45–72 | 147/160 (91.9%) | 10/160 (6.2%) | 10/147 (6.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 13} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 10/192 (5.2%) | 10/140 (7.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-rest-circle | 45–72 | 143/160 (89.4%) | 11/160 (6.9%) | 11/143 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 17} |
| middle-support | 52–72 | 116/128 (90.6%) | 12/128 (9.4%) | 12/116 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 144/192 (75.0%) | 6/192 (3.1%) | 6/144 (4.2%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 17} |
| middle-open-desk | 45–72 | 126/160 (78.8%) | 13/160 (8.1%) | 13/126 (10.3%) | shared-care-contacts: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 34} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 5/64 (7.8%) | 5/62 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 7} |
| later-tool-stories | 59–72 | 86/96 (89.6%) | 9/96 (9.4%) | 9/86 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 10} |
| later-voice-booth | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-path-map | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 4 | 4 | 0/4 (0.0%) |
| adult-balance | invest | 4 | 4 | 4/4 (100.0%) |
| adult-balance | rest | 4 | 4 | 0/4 (0.0%) |
| adult-broken-bicycle | borrow | 13 | 13 | 0/13 (0.0%) |
| adult-broken-bicycle | repairTogether | 13 | 13 | 13/13 (100.0%) |
| adult-broken-bicycle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 4 | 4 | 0/4 (0.0%) |
| adult-learning | invest | 4 | 4 | 4/4 (100.0%) |
| adult-learning | offline | 4 | 4 | 0/4 (0.0%) |
| adult-learning | rest | 4 | 4 | 0/4 (0.0%) |
| adult-local-trail | lead | 8 | 8 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 12/12 (100.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/12 (0.0%) |
| adult-meal-circle | rest | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | trial | 12 | 12 | 12/12 (100.0%) |
| adult-neighbor-market | ask | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | invest | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 14 | 14 | 14/14 (100.0%) |
| adult-repair-coop | lead | 12 | 12 | 0/14 (0.0%) |
| adult-repair-coop | rest | 14 | 14 | 0/14 (0.0%) |
| adult-repair-coop | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-shift-offer | extraShift | 9 | 9 | 9/9 (100.0%) |
| adult-shift-offer | predictable | 9 | 9 | 0/9 (0.0%) |
| adult-shift-offer | rest | 9 | 9 | 0/9 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 0/5 (0.0%) |
| child-library-map | invest | 5 | 5 | 5/5 (100.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 11 | 11 | 11/11 (100.0%) |
| child-quiet-stage | perform | 11 | 11 | 0/11 (0.0%) |
| child-quiet-stage | rest | 11 | 11 | 0/11 (0.0%) |
| child-rain-notebook | observe | 14 | 14 | 14/14 (100.0%) |
| child-rain-notebook | rest | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | seekGuide | 14 | 14 | 0/14 (0.0%) |
| child-transition | ask | 7 | 7 | 0/7 (0.0%) |
| child-transition | invest | 7 | 7 | 7/7 (100.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 16 | 16 | 0/16 (0.0%) |
| child-wind-team | invest | 16 | 16 | 16/16 (100.0%) |
| child-wind-team | rest | 16 | 16 | 0/16 (0.0%) |
| later-pass-on | ask | 5 | 5 | 0/5 (0.0%) |
| later-pass-on | invest | 5 | 5 | 5/5 (100.0%) |
| later-pass-on | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | lead | 6 | 6 | 6/7 (85.7%) |
| later-path-map | rest | 7 | 7 | 0/7 (0.0%) |
| later-path-map | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-path-map | shortWalk | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | ask | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | invest | 5 | 5 | 5/5 (100.0%) |
| later-reconnect | rest | 5 | 5 | 0/5 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 6 | 6 | 6/6 (100.0%) |
| later-shared-recipes | lead | 3 | 3 | 0/6 (0.0%) |
| later-shared-recipes | rest | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | lead | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | learnAgain | 9 | 9 | 9/9 (100.0%) |
| later-tool-stories | rest | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | seekGuide | 9 | 9 | 0/9 (0.0%) |
| later-voice-booth | ask | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | invest | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | seekGuide | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | write | 15 | 15 | 15/15 (100.0%) |
| middle-garden-table | ask | 6 | 6 | 0/6 (0.0%) |
| middle-garden-table | invest | 6 | 6 | 6/6 (100.0%) |
| middle-garden-table | rest | 6 | 6 | 0/6 (0.0%) |
| middle-open-desk | ask | 13 | 13 | 0/13 (0.0%) |
| middle-open-desk | invest | 13 | 13 | 13/13 (100.0%) |
| middle-open-desk | rest | 13 | 13 | 0/13 (0.0%) |
| middle-rest-circle | boundaries | 11 | 11 | 0/11 (0.0%) |
| middle-rest-circle | rest | 11 | 11 | 11/11 (100.0%) |
| middle-rest-circle | walk | 11 | 11 | 0/11 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | invest | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 3 | 3 | 3/10 (30.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 7/10 (70.0%) |
| middle-seed-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | study | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | teach | 10 | 10 | 0/10 (0.0%) |
| middle-support | ask | 12 | 12 | 0/12 (0.0%) |
| middle-support | invest | 12 | 12 | 12/12 (100.0%) |
| middle-support | rest | 12 | 12 | 0/12 (0.0%) |
| middle-support | shareShift | 12 | 12 | 0/12 (0.0%) |
| middle-turn | ask | 7 | 7 | 0/7 (0.0%) |
| middle-turn | invest | 7 | 7 | 7/7 (100.0%) |
| middle-turn | offline | 7 | 7 | 0/7 (0.0%) |
| middle-turn | rest | 7 | 7 | 0/7 (0.0%) |
| teen-direction | ask | 10 | 10 | 0/10 (0.0%) |
| teen-direction | invest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | leadWorkshop | 10 | 10 | 0/10 (0.0%) |
| teen-direction | offline | 10 | 10 | 0/10 (0.0%) |
| teen-direction | rest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | ask | 5 | 5 | 0/5 (0.0%) |
| teen-launch | invest | 5 | 5 | 5/5 (100.0%) |
| teen-launch | rest | 5 | 5 | 0/5 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 18 | 18 | 0/18 (0.0%) |
| teen-repair-table | invest | 18 | 18 | 18/18 (100.0%) |
| teen-repair-table | rest | 18 | 18 | 0/18 (0.0%) |
| teen-river-survey | join | 13 | 13 | 13/13 (100.0%) |
| teen-river-survey | lead | 7 | 7 | 0/13 (0.0%) |
| teen-river-survey | rest | 13 | 13 | 0/13 (0.0%) |
| teen-river-survey | seekGuide | 13 | 13 | 0/13 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 10 | 10 | 10/10 (100.0%) |
| teen-shared-room | privateRoom | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | rest | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | practice | 6 | 6 | 6/6 (100.0%) |
| teen-tool-library | rest | 6 | 6 | 0/6 (0.0%) |
| teen-tool-library | seekGuide | 6 | 6 | 0/6 (0.0%) |

相鄰相同行動類型：225/448 (50.2%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/31 (0.0%) | 0/31 (0.0%) | 0/42 (0.0%) |
| 財務安全 | 0/39 (0.0%) | 0/39 (0.0%) | 0/82 (0.0%) |
| 人際關係 | 0/455 (0.0%) | 0/455 (0.0%) | 0/953 (0.0%) |
| 技能 | 0/352 (0.0%) | 0/352 (0.0%) | 0/1249 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/43 (0.0%) | 0/43 (0.0%) | 0/43 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) |
| story.learning-route | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.care-network | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) |
| story.repair | 32/32 (100.0%) | 19/32 (59.4%) | 18/32 (56.2%) |
| story.kitchen | 20/32 (62.5%) | 15/32 (46.9%) | 7/32 (21.9%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 3/32 (9.4%) |
| story.nature | 25/32 (78.1%) | 22/32 (68.8%) | 15/32 (46.9%) |

## jpn-2／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 12/96 (12.5%) | 12/60 (20.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 14/96 (14.6%) | 14/57 (24.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 19/96 (19.8%) | 19/55 (34.5%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 8/96 (8.3%) | 8/89 (9.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 106/128 (82.8%) | 12/128 (9.4%) | 12/106 (11.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-tool-library | 17–32 | 109/128 (85.2%) | 9/128 (7.0%) | 9/109 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 19} |
| teen-launch | 21–25 | 57/64 (89.1%) | 9/64 (14.1%) | 9/57 (15.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 7} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 49/128 (38.3%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 49} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 74/96 (77.1%) | 14/96 (14.6%) | 14/74 (18.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;one-shot&#x27;: 22} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 120/192 (62.5%) | 12/192 (6.2%) | 12/120 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 50} |
| adult-meal-circle | 25–59 | 133/192 (69.3%) | 14/192 (7.3%) | 14/133 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 33} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 93/128 (72.7%) | 5/128 (3.9%) | 5/93 (5.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 4} |
| adult-broken-bicycle | 25–59 | 128/192 (66.7%) | 14/192 (7.3%) | 14/128 (10.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 39} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 140/160 (87.5%) | 11/160 (6.9%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 20} |
| middle-skill-exchange | 32–65 | 138/192 (71.9%) | 12/192 (6.2%) | 12/138 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 23} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 9/128 (7.0%) | 9/116 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 21/160 (13.1%) | 4/160 (2.5%) | 4/21 (19.0%) | shared-care-contacts: 130/160 (81.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 130, &#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 9} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 5 | 5 | 5/5 (100.0%) |
| adult-balance | invest | 5 | 5 | 0/5 (0.0%) |
| adult-balance | rest | 5 | 5 | 0/5 (0.0%) |
| adult-broken-bicycle | borrow | 14 | 14 | 14/14 (100.0%) |
| adult-broken-bicycle | repairTogether | 14 | 14 | 0/14 (0.0%) |
| adult-broken-bicycle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 6 | 6 | 6/6 (100.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 0/6 (0.0%) |
| adult-local-trail | lead | 0 | 0 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/14 (0.0%) |
| adult-meal-circle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-meal-circle | seekGuide | 14 | 14 | 14/14 (100.0%) |
| adult-meal-circle | trial | 14 | 14 | 0/14 (0.0%) |
| adult-neighbor-market | ask | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | invest | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 5/5 (100.0%) |
| child-library-map | invest | 5 | 5 | 0/5 (0.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | perform | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | rest | 12 | 12 | 12/12 (100.0%) |
| child-rain-notebook | observe | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | rest | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | seekGuide | 14 | 14 | 14/14 (100.0%) |
| child-transition | ask | 7 | 7 | 7/7 (100.0%) |
| child-transition | invest | 7 | 7 | 0/7 (0.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 19 | 19 | 19/19 (100.0%) |
| child-wind-team | invest | 19 | 19 | 0/19 (0.0%) |
| child-wind-team | rest | 19 | 19 | 0/19 (0.0%) |
| later-pass-on | ask | 6 | 6 | 6/6 (100.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 0/6 (0.0%) |
| later-path-map | lead | 0 | 0 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | seekGuide | 5 | 5 | 5/5 (100.0%) |
| later-path-map | shortWalk | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | ask | 9 | 9 | 9/9 (100.0%) |
| later-reconnect | invest | 9 | 9 | 0/9 (0.0%) |
| later-reconnect | rest | 9 | 9 | 0/9 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | ask | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | invest | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 8/8 (100.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 0/8 (0.0%) |
| middle-open-desk | ask | 4 | 4 | 4/4 (100.0%) |
| middle-open-desk | invest | 4 | 4 | 0/4 (0.0%) |
| middle-open-desk | rest | 4 | 4 | 0/4 (0.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 14/14 (100.0%) |
| middle-rest-circle | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | walk | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | invest | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/11 (0.0%) |
| middle-seed-exchange | onePot | 11 | 11 | 0/11 (0.0%) |
| middle-seed-exchange | rest | 11 | 11 | 0/11 (0.0%) |
| middle-seed-exchange | seekGuide | 11 | 11 | 11/11 (100.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 9 | 9 | 9/9 (100.0%) |
| middle-support | invest | 9 | 9 | 0/9 (0.0%) |
| middle-support | rest | 9 | 9 | 0/9 (0.0%) |
| middle-support | shareShift | 2 | 2 | 0/9 (0.0%) |
| middle-turn | ask | 9 | 9 | 9/9 (100.0%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 0/9 (0.0%) |
| middle-turn | rest | 9 | 9 | 0/9 (0.0%) |
| teen-direction | ask | 8 | 8 | 8/8 (100.0%) |
| teen-direction | invest | 8 | 8 | 0/8 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 0/8 (0.0%) |
| teen-launch | ask | 9 | 9 | 9/9 (100.0%) |
| teen-launch | invest | 9 | 9 | 0/9 (0.0%) |
| teen-launch | rest | 9 | 9 | 0/9 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | seekGuide | 12 | 12 | 12/12 (100.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 14 | 14 | 0/14 (0.0%) |
| teen-shared-room | privateRoom | 14 | 14 | 0/14 (0.0%) |
| teen-shared-room | rest | 14 | 14 | 14/14 (100.0%) |
| teen-tool-library | practice | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | rest | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | seekGuide | 9 | 9 | 9/9 (100.0%) |

相鄰相同行動類型：360/448 (80.4%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/62 (0.0%) | 0/62 (0.0%) | 0/124 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/432 (0.0%) | 0/432 (0.0%) | 0/717 (0.0%) |
| 技能 | 0/404 (0.0%) | 0/404 (0.0%) | 0/404 (0.0%) |

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
| story.childhood-connection | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.repair | 25/32 (78.1%) | 15/32 (46.9%) | 9/32 (28.1%) |
| story.kitchen | 14/32 (43.8%) | 17/32 (53.1%) | 4/32 (12.5%) |
| story.garden | 16/32 (50.0%) | 11/32 (34.4%) | 2/32 (6.2%) |
| story.nature | 25/32 (78.1%) | 23/32 (71.9%) | 14/32 (43.8%) |

## jpn-2／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 59/96 (61.5%) | 17/96 (17.7%) | 17/59 (28.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 17/96 (17.7%) | 17/57 (29.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | windmill-promise: 96/96 (100.0%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 96, &#x27;milestone-slot&#x27;: 32} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 8/96 (8.3%) | 8/89 (9.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 104/128 (81.2%) | 12/128 (9.4%) | 12/104 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 24} |
| teen-tool-library | 17–32 | 106/128 (82.8%) | 10/128 (7.8%) | 10/106 (9.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-launch | 21–25 | 56/64 (87.5%) | 10/64 (15.6%) | 10/56 (17.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 8} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 128/128 (100.0%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 128} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 72/96 (75.0%) | 15/96 (15.6%) | 15/72 (20.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;one-shot&#x27;: 24} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 130/192 (67.7%) | 10/192 (5.2%) | 10/130 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 37} |
| adult-meal-circle | 25–59 | 132/192 (68.8%) | 14/192 (7.3%) | 14/132 (10.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 35} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 100/160 (62.5%) | 10/160 (6.2%) | 10/100 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 15, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 7/128 (5.5%) | 7/92 (7.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 16/192 (8.3%) | 16/124 (12.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 100/160 (62.5%) | 5/160 (3.1%) | 5/100 (5.0%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 15} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 138/160 (86.2%) | 14/160 (8.8%) | 14/138 (10.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 22} |
| middle-skill-exchange | 32–65 | 137/192 (71.4%) | 12/192 (6.2%) | 12/137 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| middle-turn | 45–59 | 83/96 (86.5%) | 10/96 (10.4%) | 10/83 (12.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 13} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 15/160 (9.4%) | 15/140 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 117/128 (91.4%) | 10/128 (7.8%) | 10/117 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 9/192 (4.7%) | 9/141 (6.4%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 0/160 (0.0%) | 0/160 (0.0%) | — (0/0) | shared-care-contacts: 160/160 (100.0%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 160} |
| middle-rhythm | 59–72 | 82/96 (85.4%) | 13/96 (13.5%) | 13/82 (15.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 14} |
| later-pass-on | 65–72 | 61/64 (95.3%) | 7/64 (10.9%) | 7/61 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 3} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 7/96 (7.3%) | 7/90 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | recording-companion: 0/96 (0.0%); sharing-connection: 96/96 (100.0%); 規則排除：{&#x27;condition:sharing-connection&#x27;: 96} |
| later-path-map | 59–72 | 91/96 (94.8%) | 4/96 (4.2%) | 4/91 (4.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 7 | 7 | 0/7 (0.0%) |
| adult-balance | invest | 7 | 7 | 0/7 (0.0%) |
| adult-balance | rest | 7 | 7 | 7/7 (100.0%) |
| adult-broken-bicycle | borrow | 16 | 16 | 0/16 (0.0%) |
| adult-broken-bicycle | repairTogether | 16 | 16 | 0/16 (0.0%) |
| adult-broken-bicycle | rest | 16 | 16 | 16/16 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 6/6 (100.0%) |
| adult-local-trail | lead | 0 | 0 | 0/10 (0.0%) |
| adult-local-trail | record | 10 | 10 | 0/10 (0.0%) |
| adult-local-trail | rest | 10 | 10 | 10/10 (100.0%) |
| adult-local-trail | seekGuide | 10 | 10 | 0/10 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/14 (0.0%) |
| adult-meal-circle | rest | 14 | 14 | 14/14 (100.0%) |
| adult-meal-circle | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-meal-circle | trial | 14 | 14 | 0/14 (0.0%) |
| adult-neighbor-market | ask | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | invest | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | rest | 5 | 5 | 5/5 (100.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 12/12 (100.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 12 | 12 | 0/12 (0.0%) |
| child-library-map | invest | 12 | 12 | 0/12 (0.0%) |
| child-library-map | rest | 12 | 12 | 12/12 (100.0%) |
| child-quiet-stage | backstage | 17 | 17 | 0/17 (0.0%) |
| child-quiet-stage | perform | 17 | 17 | 0/17 (0.0%) |
| child-quiet-stage | rest | 17 | 17 | 17/17 (100.0%) |
| child-rain-notebook | observe | 17 | 17 | 0/17 (0.0%) |
| child-rain-notebook | rest | 17 | 17 | 17/17 (100.0%) |
| child-rain-notebook | seekGuide | 17 | 17 | 0/17 (0.0%) |
| child-transition | ask | 8 | 8 | 0/8 (0.0%) |
| child-transition | invest | 8 | 8 | 0/8 (0.0%) |
| child-transition | rest | 8 | 8 | 8/8 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 7 | 7 | 0/7 (0.0%) |
| later-pass-on | invest | 7 | 7 | 0/7 (0.0%) |
| later-pass-on | rest | 7 | 7 | 7/7 (100.0%) |
| later-path-map | lead | 0 | 0 | 0/4 (0.0%) |
| later-path-map | rest | 4 | 4 | 4/4 (100.0%) |
| later-path-map | seekGuide | 4 | 4 | 0/4 (0.0%) |
| later-path-map | shortWalk | 4 | 4 | 0/4 (0.0%) |
| later-reconnect | ask | 6 | 6 | 0/6 (0.0%) |
| later-reconnect | invest | 6 | 6 | 0/6 (0.0%) |
| later-reconnect | rest | 6 | 6 | 6/6 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 7/7 (100.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | lead | 0 | 0 | 0/7 (0.0%) |
| later-tool-stories | learnAgain | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | rest | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | ask | 0 | 0 | — (0/0) |
| later-voice-booth | invest | 0 | 0 | — (0/0) |
| later-voice-booth | rest | 0 | 0 | — (0/0) |
| middle-friend-letter | rest | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 9 | 9 | 0/9 (0.0%) |
| middle-garden-table | invest | 9 | 9 | 0/9 (0.0%) |
| middle-garden-table | rest | 9 | 9 | 9/9 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rest-circle | boundaries | 15 | 15 | 0/15 (0.0%) |
| middle-rest-circle | rest | 15 | 15 | 15/15 (100.0%) |
| middle-rest-circle | walk | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | ask | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | invest | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/14 (0.0%) |
| middle-seed-exchange | onePot | 14 | 14 | 0/14 (0.0%) |
| middle-seed-exchange | rest | 14 | 14 | 14/14 (100.0%) |
| middle-seed-exchange | seekGuide | 14 | 14 | 0/14 (0.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 10 | 10 | 0/10 (0.0%) |
| middle-support | invest | 10 | 10 | 0/10 (0.0%) |
| middle-support | rest | 10 | 10 | 10/10 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/10 (0.0%) |
| middle-turn | ask | 10 | 10 | 0/10 (0.0%) |
| middle-turn | invest | 10 | 10 | 0/10 (0.0%) |
| middle-turn | offline | 10 | 10 | 0/10 (0.0%) |
| middle-turn | rest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | ask | 8 | 8 | 0/8 (0.0%) |
| teen-direction | invest | 8 | 8 | 0/8 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 8/8 (100.0%) |
| teen-launch | ask | 10 | 10 | 0/10 (0.0%) |
| teen-launch | invest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | rest | 10 | 10 | 10/10 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 12/12 (100.0%) |
| teen-river-survey | seekGuide | 12 | 12 | 0/12 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 15 | 15 | 0/15 (0.0%) |
| teen-shared-room | privateRoom | 15 | 15 | 0/15 (0.0%) |
| teen-shared-room | rest | 15 | 15 | 15/15 (100.0%) |
| teen-tool-library | practice | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | seekGuide | 10 | 10 | 0/10 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/271 (0.0%) | 0/271 (0.0%) | 0/271 (0.0%) |
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
| story.childhood-connection | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.repair | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.kitchen | 0/32 (0.0%) | 16/32 (50.0%) | 0/32 (0.0%) |
| story.garden | 0/32 (0.0%) | 14/32 (43.8%) | 0/32 (0.0%) |
| story.nature | 0/32 (0.0%) | 20/32 (62.5%) | 0/32 (0.0%) |

## jpn-2／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 13/96 (13.5%) | 13/60 (21.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 15/96 (15.6%) | 15/57 (26.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 33/96 (34.4%) | 14/96 (14.6%) | 14/33 (42.4%) | windmill-promise: 34/96 (35.4%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 34, &#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 16} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 9/96 (9.4%) | 9/89 (10.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 104/128 (81.2%) | 12/128 (9.4%) | 12/104 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;one-shot&#x27;: 24} |
| teen-tool-library | 17–32 | 113/128 (88.3%) | 7/128 (5.5%) | 7/113 (6.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 15} |
| teen-launch | 21–25 | 58/64 (90.6%) | 7/64 (10.9%) | 7/58 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-repair-table | 17–32 | 49/128 (38.3%) | 7/128 (5.5%) | 7/49 (14.3%) | made-a-project: 64/128 (50.0%); repair-practice: 20/128 (15.6%); 規則排除：{&#x27;condition:made-a-project&#x27;: 64, &#x27;condition:repair-practice&#x27;: 20, &#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 15} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 78/96 (81.2%) | 11/96 (11.5%) | 11/78 (14.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 127/192 (66.1%) | 11/192 (5.7%) | 11/127 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 41} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 6/128 (4.7%) | 6/92 (6.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 129/192 (67.2%) | 18/192 (9.4%) | 18/129 (14.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 11/192 (5.7%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 11/128 (8.6%) | 11/116 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 137/192 (71.4%) | 9/192 (4.7%) | 9/137 (6.6%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 25} |
| middle-open-desk | 45–72 | 44/160 (27.5%) | 3/160 (1.9%) | 3/44 (6.8%) | shared-care-contacts: 106/160 (66.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 106, &#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 10} |
| middle-rhythm | 59–72 | 84/96 (87.5%) | 11/96 (11.5%) | 11/84 (13.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 91/96 (94.8%) | 5/96 (5.2%) | 5/91 (5.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 5} |
| later-tool-stories | 59–72 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 11} |
| later-voice-booth | 59–72 | 82/96 (85.4%) | 8/96 (8.3%) | 8/82 (9.8%) | recording-companion: 0/96 (0.0%); sharing-connection: 6/96 (6.2%); 規則排除：{&#x27;condition:sharing-connection&#x27;: 6, &#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 6 | 6 | 0/6 (0.0%) |
| adult-balance | invest | 6 | 6 | 4/6 (66.7%) |
| adult-balance | rest | 6 | 6 | 2/6 (33.3%) |
| adult-broken-bicycle | borrow | 15 | 15 | 7/15 (46.7%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 3/15 (20.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 5/15 (33.3%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 3/6 (50.0%) |
| adult-learning | offline | 6 | 6 | 1/6 (16.7%) |
| adult-learning | rest | 6 | 6 | 2/6 (33.3%) |
| adult-local-trail | lead | 2 | 2 | 0/11 (0.0%) |
| adult-local-trail | record | 11 | 11 | 6/11 (54.5%) |
| adult-local-trail | rest | 11 | 11 | 3/11 (27.3%) |
| adult-local-trail | seekGuide | 11 | 11 | 2/11 (18.2%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 2/13 (15.4%) |
| adult-meal-circle | seekGuide | 13 | 13 | 6/13 (46.2%) |
| adult-meal-circle | trial | 13 | 13 | 5/13 (38.5%) |
| adult-neighbor-market | ask | 4 | 4 | 1/4 (25.0%) |
| adult-neighbor-market | invest | 4 | 4 | 2/4 (50.0%) |
| adult-neighbor-market | rest | 4 | 4 | 1/4 (25.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 2/12 (16.7%) |
| adult-repair-coop | lead | 2 | 2 | 1/12 (8.3%) |
| adult-repair-coop | rest | 12 | 12 | 4/12 (33.3%) |
| adult-repair-coop | seekGuide | 12 | 12 | 5/12 (41.7%) |
| adult-shift-offer | extraShift | 10 | 10 | 5/10 (50.0%) |
| adult-shift-offer | predictable | 10 | 10 | 3/10 (30.0%) |
| adult-shift-offer | rest | 10 | 10 | 2/10 (20.0%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 6 | 6 | 1/6 (16.7%) |
| child-library-map | invest | 6 | 6 | 2/6 (33.3%) |
| child-library-map | rest | 6 | 6 | 3/6 (50.0%) |
| child-quiet-stage | backstage | 13 | 13 | 4/13 (30.8%) |
| child-quiet-stage | perform | 13 | 13 | 6/13 (46.2%) |
| child-quiet-stage | rest | 13 | 13 | 3/13 (23.1%) |
| child-rain-notebook | observe | 15 | 15 | 4/15 (26.7%) |
| child-rain-notebook | rest | 15 | 15 | 5/15 (33.3%) |
| child-rain-notebook | seekGuide | 15 | 15 | 6/15 (40.0%) |
| child-transition | ask | 7 | 7 | 2/7 (28.6%) |
| child-transition | invest | 7 | 7 | 5/7 (71.4%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 14 | 14 | 5/14 (35.7%) |
| child-wind-team | invest | 14 | 14 | 0/14 (0.0%) |
| child-wind-team | rest | 14 | 14 | 9/14 (64.3%) |
| later-pass-on | ask | 6 | 6 | 1/6 (16.7%) |
| later-pass-on | invest | 6 | 6 | 3/6 (50.0%) |
| later-pass-on | rest | 6 | 6 | 2/6 (33.3%) |
| later-path-map | lead | 2 | 2 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 4/5 (80.0%) |
| later-path-map | seekGuide | 5 | 5 | 0/5 (0.0%) |
| later-path-map | shortWalk | 5 | 5 | 1/5 (20.0%) |
| later-reconnect | ask | 8 | 8 | 1/8 (12.5%) |
| later-reconnect | invest | 8 | 8 | 4/8 (50.0%) |
| later-reconnect | rest | 8 | 8 | 3/8 (37.5%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-shared-recipes | cookOnce | 5 | 5 | 2/5 (40.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/5 (0.0%) |
| later-shared-recipes | rest | 5 | 5 | 1/5 (20.0%) |
| later-shared-recipes | seekGuide | 5 | 5 | 2/5 (40.0%) |
| later-tool-stories | lead | 4 | 4 | 3/7 (42.9%) |
| later-tool-stories | learnAgain | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | rest | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | seekGuide | 7 | 7 | 2/7 (28.6%) |
| later-voice-booth | ask | 8 | 8 | 3/8 (37.5%) |
| later-voice-booth | invest | 8 | 8 | 3/8 (37.5%) |
| later-voice-booth | rest | 8 | 8 | 2/8 (25.0%) |
| middle-friend-letter | rest | 18 | 18 | 5/18 (27.8%) |
| middle-friend-letter | seekGuide | 18 | 18 | 7/18 (38.9%) |
| middle-friend-letter | write | 18 | 18 | 6/18 (33.3%) |
| middle-garden-table | ask | 9 | 9 | 2/9 (22.2%) |
| middle-garden-table | invest | 9 | 9 | 4/9 (44.4%) |
| middle-garden-table | rest | 9 | 9 | 3/9 (33.3%) |
| middle-open-desk | ask | 3 | 3 | 1/3 (33.3%) |
| middle-open-desk | invest | 3 | 3 | 1/3 (33.3%) |
| middle-open-desk | rest | 3 | 3 | 1/3 (33.3%) |
| middle-rest-circle | boundaries | 14 | 14 | 2/14 (14.3%) |
| middle-rest-circle | rest | 14 | 14 | 6/14 (42.9%) |
| middle-rest-circle | walk | 14 | 14 | 6/14 (42.9%) |
| middle-rhythm | ask | 11 | 11 | 1/11 (9.1%) |
| middle-rhythm | invest | 11 | 11 | 3/11 (27.3%) |
| middle-rhythm | rest | 11 | 11 | 7/11 (63.6%) |
| middle-seed-exchange | lead | 2 | 2 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 5/10 (50.0%) |
| middle-seed-exchange | rest | 10 | 10 | 1/10 (10.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 4/10 (40.0%) |
| middle-skill-exchange | rest | 11 | 11 | 4/11 (36.4%) |
| middle-skill-exchange | study | 11 | 11 | 1/11 (9.1%) |
| middle-skill-exchange | teach | 11 | 11 | 6/11 (54.5%) |
| middle-support | ask | 11 | 11 | 3/11 (27.3%) |
| middle-support | invest | 11 | 11 | 5/11 (45.5%) |
| middle-support | rest | 11 | 11 | 2/11 (18.2%) |
| middle-support | shareShift | 5 | 5 | 1/11 (9.1%) |
| middle-turn | ask | 9 | 9 | 3/9 (33.3%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 4/9 (44.4%) |
| middle-turn | rest | 9 | 9 | 2/9 (22.2%) |
| teen-direction | ask | 9 | 9 | 1/9 (11.1%) |
| teen-direction | invest | 9 | 9 | 1/9 (11.1%) |
| teen-direction | leadWorkshop | 4 | 4 | 1/9 (11.1%) |
| teen-direction | offline | 9 | 9 | 1/9 (11.1%) |
| teen-direction | rest | 9 | 9 | 5/9 (55.6%) |
| teen-launch | ask | 7 | 7 | 2/7 (28.6%) |
| teen-launch | invest | 7 | 7 | 2/7 (28.6%) |
| teen-launch | rest | 7 | 7 | 3/7 (42.9%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 7 | 7 | 1/7 (14.3%) |
| teen-repair-table | invest | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | rest | 7 | 7 | 3/7 (42.9%) |
| teen-river-survey | join | 12 | 12 | 2/12 (16.7%) |
| teen-river-survey | lead | 1 | 1 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 2/12 (16.7%) |
| teen-river-survey | seekGuide | 12 | 12 | 8/12 (66.7%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 11 | 11 | 3/11 (27.3%) |
| teen-shared-room | privateRoom | 11 | 11 | 6/11 (54.5%) |
| teen-shared-room | rest | 11 | 11 | 2/11 (18.2%) |
| teen-tool-library | practice | 7 | 7 | 1/7 (14.3%) |
| teen-tool-library | rest | 7 | 7 | 4/7 (57.1%) |
| teen-tool-library | seekGuide | 7 | 7 | 2/7 (28.6%) |

相鄰相同行動類型：112/448 (25.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/188 (0.0%) | 0/188 (0.0%) | 0/370 (0.0%) |
| 財務安全 | 0/20 (0.0%) | 0/20 (0.0%) | 0/51 (0.0%) |
| 人際關係 | 0/403 (0.0%) | 0/403 (0.0%) | 0/650 (0.0%) |
| 技能 | 0/245 (0.0%) | 0/245 (0.0%) | 0/566 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.learning-route | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.care-network | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |
| story.repair | 23/32 (71.9%) | 15/32 (46.9%) | 6/32 (18.8%) |
| story.kitchen | 14/32 (43.8%) | 15/32 (46.9%) | 3/32 (9.4%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 21/32 (65.6%) | 22/32 (68.8%) | 11/32 (34.4%) |

## usa-1／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 15/96 (15.6%) | 15/55 (27.3%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 8/96 (8.3%) | 8/91 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 112/128 (87.5%) | 11/128 (8.6%) | 11/112 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 16} |
| teen-tool-library | 17–32 | 114/128 (89.1%) | 6/128 (4.7%) | 6/114 (5.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 14} |
| teen-launch | 21–25 | 60/64 (93.8%) | 5/64 (7.8%) | 5/60 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 4} |
| teen-repair-table | 17–32 | 94/128 (73.4%) | 17/128 (13.3%) | 17/94 (18.1%) | made-a-project: 0/128 (0.0%); repair-practice: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 15, &#x27;one-shot&#x27;: 34} |
| teen-shared-kitchen | 17–32 | 108/128 (84.4%) | 10/128 (7.8%) | 10/108 (9.3%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 20} |
| teen-shared-room | 21–32 | 84/96 (87.5%) | 8/96 (8.3%) | 8/84 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| adult-learning | 25–45 | 92/128 (71.9%) | 3/128 (2.3%) | 3/92 (3.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 6} |
| adult-local-trail | 25–59 | 122/192 (63.5%) | 12/192 (6.2%) | 12/122 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 47} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 127/192 (66.1%) | 14/192 (7.3%) | 14/127 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 40} |
| adult-shift-offer | 25–52 | 106/160 (66.2%) | 9/160 (5.6%) | 9/106 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| adult-balance | 32–52 | 95/128 (74.2%) | 4/128 (3.1%) | 4/95 (4.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 1, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 1} |
| adult-broken-bicycle | 25–59 | 130/192 (67.7%) | 14/192 (7.3%) | 14/130 (10.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| adult-neighbor-market | 25–52 | 106/160 (66.2%) | 4/160 (2.5%) | 4/106 (3.8%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 20, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 136/192 (70.8%) | 15/192 (7.8%) | 15/136 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 28} |
| middle-seed-exchange | 45–72 | 150/160 (93.8%) | 9/160 (5.6%) | 9/150 (6.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 10} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 10/192 (5.2%) | 10/140 (7.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-rest-circle | 45–72 | 143/160 (89.4%) | 11/160 (6.9%) | 11/143 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 17} |
| middle-support | 52–72 | 116/128 (90.6%) | 12/128 (9.4%) | 12/116 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 144/192 (75.0%) | 6/192 (3.1%) | 6/144 (4.2%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 17} |
| middle-open-desk | 45–72 | 126/160 (78.8%) | 14/160 (8.8%) | 14/126 (11.1%) | shared-care-contacts: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 34} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 5/64 (7.8%) | 5/62 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 87/96 (90.6%) | 9/96 (9.4%) | 9/87 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 9} |
| later-voice-booth | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 7} |
| later-path-map | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 4/32 (12.5%) | 4/32 (12.5%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 4 | 4 | 0/4 (0.0%) |
| adult-balance | invest | 4 | 4 | 4/4 (100.0%) |
| adult-balance | rest | 4 | 4 | 0/4 (0.0%) |
| adult-broken-bicycle | borrow | 14 | 14 | 0/14 (0.0%) |
| adult-broken-bicycle | repairTogether | 14 | 14 | 14/14 (100.0%) |
| adult-broken-bicycle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 3 | 3 | 0/3 (0.0%) |
| adult-learning | invest | 3 | 3 | 3/3 (100.0%) |
| adult-learning | offline | 3 | 3 | 0/3 (0.0%) |
| adult-learning | rest | 3 | 3 | 0/3 (0.0%) |
| adult-local-trail | lead | 7 | 7 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 12/12 (100.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | lead | 3 | 3 | 3/13 (23.1%) |
| adult-meal-circle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | trial | 13 | 13 | 10/13 (76.9%) |
| adult-neighbor-market | ask | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | invest | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 14 | 14 | 14/14 (100.0%) |
| adult-repair-coop | lead | 12 | 12 | 0/14 (0.0%) |
| adult-repair-coop | rest | 14 | 14 | 0/14 (0.0%) |
| adult-repair-coop | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-shift-offer | extraShift | 9 | 9 | 9/9 (100.0%) |
| adult-shift-offer | predictable | 9 | 9 | 0/9 (0.0%) |
| adult-shift-offer | rest | 9 | 9 | 0/9 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 0/5 (0.0%) |
| child-library-map | invest | 5 | 5 | 5/5 (100.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 10 | 10 | 10/10 (100.0%) |
| child-quiet-stage | perform | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | rest | 10 | 10 | 0/10 (0.0%) |
| child-rain-notebook | observe | 13 | 13 | 13/13 (100.0%) |
| child-rain-notebook | rest | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | seekGuide | 13 | 13 | 0/13 (0.0%) |
| child-transition | ask | 7 | 7 | 0/7 (0.0%) |
| child-transition | invest | 7 | 7 | 7/7 (100.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 15 | 15 | 0/15 (0.0%) |
| child-wind-team | invest | 15 | 15 | 15/15 (100.0%) |
| child-wind-team | rest | 15 | 15 | 0/15 (0.0%) |
| later-pass-on | ask | 5 | 5 | 0/5 (0.0%) |
| later-pass-on | invest | 5 | 5 | 5/5 (100.0%) |
| later-pass-on | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | lead | 6 | 6 | 6/7 (85.7%) |
| later-path-map | rest | 7 | 7 | 0/7 (0.0%) |
| later-path-map | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-path-map | shortWalk | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | ask | 4 | 4 | 0/4 (0.0%) |
| later-reconnect | invest | 4 | 4 | 4/4 (100.0%) |
| later-reconnect | rest | 4 | 4 | 0/4 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 7/7 (100.0%) |
| later-shared-recipes | lead | 6 | 6 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | lead | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | learnAgain | 9 | 9 | 9/9 (100.0%) |
| later-tool-stories | rest | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | seekGuide | 9 | 9 | 0/9 (0.0%) |
| later-voice-booth | ask | 6 | 6 | 0/6 (0.0%) |
| later-voice-booth | invest | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | rest | 6 | 6 | 0/6 (0.0%) |
| middle-friend-letter | rest | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | seekGuide | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | write | 15 | 15 | 15/15 (100.0%) |
| middle-garden-table | ask | 6 | 6 | 0/6 (0.0%) |
| middle-garden-table | invest | 6 | 6 | 6/6 (100.0%) |
| middle-garden-table | rest | 6 | 6 | 0/6 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | boundaries | 11 | 11 | 0/11 (0.0%) |
| middle-rest-circle | rest | 11 | 11 | 11/11 (100.0%) |
| middle-rest-circle | walk | 11 | 11 | 0/11 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | invest | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 3 | 3 | 3/9 (33.3%) |
| middle-seed-exchange | onePot | 9 | 9 | 6/9 (66.7%) |
| middle-seed-exchange | rest | 9 | 9 | 0/9 (0.0%) |
| middle-seed-exchange | seekGuide | 9 | 9 | 0/9 (0.0%) |
| middle-skill-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | study | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | teach | 10 | 10 | 0/10 (0.0%) |
| middle-support | ask | 12 | 12 | 0/12 (0.0%) |
| middle-support | invest | 12 | 12 | 12/12 (100.0%) |
| middle-support | rest | 12 | 12 | 0/12 (0.0%) |
| middle-support | shareShift | 12 | 12 | 0/12 (0.0%) |
| middle-turn | ask | 7 | 7 | 0/7 (0.0%) |
| middle-turn | invest | 7 | 7 | 7/7 (100.0%) |
| middle-turn | offline | 7 | 7 | 0/7 (0.0%) |
| middle-turn | rest | 7 | 7 | 0/7 (0.0%) |
| teen-direction | ask | 8 | 8 | 0/8 (0.0%) |
| teen-direction | invest | 8 | 8 | 8/8 (100.0%) |
| teen-direction | leadWorkshop | 8 | 8 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 0/8 (0.0%) |
| teen-launch | ask | 5 | 5 | 0/5 (0.0%) |
| teen-launch | invest | 5 | 5 | 5/5 (100.0%) |
| teen-launch | rest | 5 | 5 | 0/5 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 17 | 17 | 0/17 (0.0%) |
| teen-repair-table | invest | 17 | 17 | 17/17 (100.0%) |
| teen-repair-table | rest | 17 | 17 | 0/17 (0.0%) |
| teen-river-survey | join | 11 | 11 | 11/11 (100.0%) |
| teen-river-survey | lead | 6 | 6 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | seekGuide | 11 | 11 | 0/11 (0.0%) |
| teen-shared-kitchen | ask | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | invest | 10 | 10 | 10/10 (100.0%) |
| teen-shared-kitchen | rest | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | agreement | 8 | 8 | 8/8 (100.0%) |
| teen-shared-room | privateRoom | 8 | 8 | 0/8 (0.0%) |
| teen-shared-room | rest | 8 | 8 | 0/8 (0.0%) |
| teen-tool-library | practice | 6 | 6 | 6/6 (100.0%) |
| teen-tool-library | rest | 6 | 6 | 0/6 (0.0%) |
| teen-tool-library | seekGuide | 6 | 6 | 0/6 (0.0%) |

相鄰相同行動類型：218/448 (48.7%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/31 (0.0%) | 0/31 (0.0%) | 0/42 (0.0%) |
| 財務安全 | 0/48 (0.0%) | 0/48 (0.0%) | 0/94 (0.0%) |
| 人際關係 | 0/455 (0.0%) | 0/455 (0.0%) | 0/967 (0.0%) |
| 技能 | 0/343 (0.0%) | 0/343 (0.0%) | 0/1216 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/42 (0.0%) | 0/42 (0.0%) | 0/42 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 4/32 (12.5%) | 4/32 (12.5%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) |
| story.repair | 32/32 (100.0%) | 19/32 (59.4%) | 18/32 (56.2%) |
| story.kitchen | 24/32 (75.0%) | 16/32 (50.0%) | 9/32 (28.1%) |
| story.garden | 12/32 (37.5%) | 9/32 (28.1%) | 3/32 (9.4%) |
| story.nature | 24/32 (75.0%) | 21/32 (65.6%) | 14/32 (43.8%) |

## usa-1／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 17/96 (17.7%) | 17/55 (30.9%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 6/96 (6.2%) | 6/91 (6.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 108/128 (84.4%) | 11/128 (8.6%) | 11/108 (10.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 20} |
| teen-tool-library | 17–32 | 109/128 (85.2%) | 9/128 (7.0%) | 9/109 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 19} |
| teen-launch | 21–25 | 57/64 (89.1%) | 9/64 (14.1%) | 9/57 (15.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 7} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 44/128 (34.4%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 44} |
| teen-shared-kitchen | 17–32 | 101/128 (78.9%) | 13/128 (10.2%) | 13/101 (12.9%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 27} |
| teen-shared-room | 21–32 | 80/96 (83.3%) | 10/96 (10.4%) | 10/80 (12.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 16} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 123/192 (64.1%) | 12/192 (6.2%) | 12/123 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 46} |
| adult-meal-circle | 25–59 | 136/192 (70.8%) | 13/192 (6.8%) | 13/136 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 29} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 93/128 (72.7%) | 5/128 (3.9%) | 5/93 (5.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 4} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 138/192 (71.9%) | 12/192 (6.2%) | 12/138 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 23} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 9/128 (7.0%) | 9/116 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 21/160 (13.1%) | 4/160 (2.5%) | 4/21 (19.0%) | shared-care-contacts: 130/160 (81.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 130, &#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 9} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 5 | 5 | 5/5 (100.0%) |
| adult-balance | invest | 5 | 5 | 0/5 (0.0%) |
| adult-balance | rest | 5 | 5 | 0/5 (0.0%) |
| adult-broken-bicycle | borrow | 15 | 15 | 15/15 (100.0%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 0/15 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 6 | 6 | 6/6 (100.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 0/6 (0.0%) |
| adult-local-trail | lead | 0 | 0 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 13/13 (100.0%) |
| adult-meal-circle | trial | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | ask | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | invest | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 5/5 (100.0%) |
| child-library-map | invest | 5 | 5 | 0/5 (0.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | perform | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | rest | 10 | 10 | 10/10 (100.0%) |
| child-rain-notebook | observe | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | rest | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | seekGuide | 13 | 13 | 13/13 (100.0%) |
| child-transition | ask | 7 | 7 | 7/7 (100.0%) |
| child-transition | invest | 7 | 7 | 0/7 (0.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | invest | 17 | 17 | 0/17 (0.0%) |
| child-wind-team | rest | 17 | 17 | 0/17 (0.0%) |
| later-pass-on | ask | 6 | 6 | 6/6 (100.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 0/6 (0.0%) |
| later-path-map | lead | 0 | 0 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | seekGuide | 5 | 5 | 5/5 (100.0%) |
| later-path-map | shortWalk | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | ask | 9 | 9 | 9/9 (100.0%) |
| later-reconnect | invest | 9 | 9 | 0/9 (0.0%) |
| later-reconnect | rest | 9 | 9 | 0/9 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | ask | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | invest | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 8/8 (100.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 0/8 (0.0%) |
| middle-open-desk | ask | 4 | 4 | 4/4 (100.0%) |
| middle-open-desk | invest | 4 | 4 | 0/4 (0.0%) |
| middle-open-desk | rest | 4 | 4 | 0/4 (0.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 14/14 (100.0%) |
| middle-rest-circle | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | walk | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | invest | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 9 | 9 | 9/9 (100.0%) |
| middle-support | invest | 9 | 9 | 0/9 (0.0%) |
| middle-support | rest | 9 | 9 | 0/9 (0.0%) |
| middle-support | shareShift | 2 | 2 | 0/9 (0.0%) |
| middle-turn | ask | 9 | 9 | 9/9 (100.0%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 0/9 (0.0%) |
| middle-turn | rest | 9 | 9 | 0/9 (0.0%) |
| teen-direction | ask | 6 | 6 | 6/6 (100.0%) |
| teen-direction | invest | 6 | 6 | 0/6 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/6 (0.0%) |
| teen-direction | offline | 6 | 6 | 0/6 (0.0%) |
| teen-direction | rest | 6 | 6 | 0/6 (0.0%) |
| teen-launch | ask | 9 | 9 | 9/9 (100.0%) |
| teen-launch | invest | 9 | 9 | 0/9 (0.0%) |
| teen-launch | rest | 9 | 9 | 0/9 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | seekGuide | 11 | 11 | 11/11 (100.0%) |
| teen-shared-kitchen | ask | 13 | 13 | 13/13 (100.0%) |
| teen-shared-kitchen | invest | 13 | 13 | 0/13 (0.0%) |
| teen-shared-kitchen | rest | 13 | 13 | 0/13 (0.0%) |
| teen-shared-room | agreement | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | privateRoom | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | practice | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | rest | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | seekGuide | 9 | 9 | 9/9 (100.0%) |

相鄰相同行動類型：370/448 (82.6%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/56 (0.0%) | 0/56 (0.0%) | 0/112 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/438 (0.0%) | 0/438 (0.0%) | 0/732 (0.0%) |
| 技能 | 0/409 (0.0%) | 0/409 (0.0%) | 0/409 (0.0%) |

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
| story.childhood-connection | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.learning-route | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.care-network | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.repair | 25/32 (78.1%) | 15/32 (46.9%) | 9/32 (28.1%) |
| story.kitchen | 22/32 (68.8%) | 16/32 (50.0%) | 7/32 (21.9%) |
| story.garden | 15/32 (46.9%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 24/32 (75.0%) | 22/32 (68.8%) | 13/32 (40.6%) |

## usa-1／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 59/96 (61.5%) | 12/96 (12.5%) | 12/59 (20.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 15/96 (15.6%) | 15/57 (26.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | windmill-promise: 96/96 (100.0%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 96, &#x27;milestone-slot&#x27;: 32} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 6/96 (6.2%) | 6/91 (6.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 109/128 (85.2%) | 10/128 (7.8%) | 10/109 (9.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 19} |
| teen-tool-library | 17–32 | 106/128 (82.8%) | 10/128 (7.8%) | 10/106 (9.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-launch | 21–25 | 56/64 (87.5%) | 10/64 (15.6%) | 10/56 (17.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 8} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 128/128 (100.0%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 128} |
| teen-shared-kitchen | 17–32 | 92/128 (71.9%) | 16/128 (12.5%) | 16/92 (17.4%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 14, &#x27;one-shot&#x27;: 36} |
| teen-shared-room | 21–32 | 78/96 (81.2%) | 11/96 (11.5%) | 11/78 (14.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 130/192 (67.7%) | 10/192 (5.2%) | 10/130 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 37} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 100/160 (62.5%) | 10/160 (6.2%) | 10/100 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 15, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 7/128 (5.5%) | 7/92 (7.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 100/160 (62.5%) | 5/160 (3.1%) | 5/100 (5.0%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 15} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 140/160 (87.5%) | 13/160 (8.1%) | 13/140 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 20} |
| middle-skill-exchange | 32–65 | 137/192 (71.4%) | 12/192 (6.2%) | 12/137 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| middle-turn | 45–59 | 83/96 (86.5%) | 10/96 (10.4%) | 10/83 (12.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 13} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 15/160 (9.4%) | 15/140 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 118/128 (92.2%) | 10/128 (7.8%) | 10/118 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 10} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 0/160 (0.0%) | 0/160 (0.0%) | — (0/0) | shared-care-contacts: 160/160 (100.0%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 160} |
| middle-rhythm | 59–72 | 82/96 (85.4%) | 13/96 (13.5%) | 13/82 (15.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 14} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 6/96 (6.2%) | 6/87 (6.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 10/96 (10.4%) | 10/87 (11.5%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 93/96 (96.9%) | 3/96 (3.1%) | 3/93 (3.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 3} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 3/32 (9.4%) | 3/32 (9.4%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 7 | 7 | 0/7 (0.0%) |
| adult-balance | invest | 7 | 7 | 0/7 (0.0%) |
| adult-balance | rest | 7 | 7 | 7/7 (100.0%) |
| adult-broken-bicycle | borrow | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 15/15 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 6/6 (100.0%) |
| adult-local-trail | lead | 0 | 0 | 0/10 (0.0%) |
| adult-local-trail | record | 10 | 10 | 0/10 (0.0%) |
| adult-local-trail | rest | 10 | 10 | 10/10 (100.0%) |
| adult-local-trail | seekGuide | 10 | 10 | 0/10 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 13/13 (100.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | trial | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | ask | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | invest | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | rest | 5 | 5 | 5/5 (100.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 12/12 (100.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 12 | 12 | 0/12 (0.0%) |
| child-library-map | invest | 12 | 12 | 0/12 (0.0%) |
| child-library-map | rest | 12 | 12 | 12/12 (100.0%) |
| child-quiet-stage | backstage | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | perform | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | rest | 12 | 12 | 12/12 (100.0%) |
| child-rain-notebook | observe | 15 | 15 | 0/15 (0.0%) |
| child-rain-notebook | rest | 15 | 15 | 15/15 (100.0%) |
| child-rain-notebook | seekGuide | 15 | 15 | 0/15 (0.0%) |
| child-transition | ask | 8 | 8 | 0/8 (0.0%) |
| child-transition | invest | 8 | 8 | 0/8 (0.0%) |
| child-transition | rest | 8 | 8 | 8/8 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 6/6 (100.0%) |
| later-path-map | lead | 0 | 0 | 0/3 (0.0%) |
| later-path-map | rest | 3 | 3 | 3/3 (100.0%) |
| later-path-map | seekGuide | 3 | 3 | 0/3 (0.0%) |
| later-path-map | shortWalk | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | ask | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | invest | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | rest | 3 | 3 | 3/3 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-shared-recipes | cookOnce | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/6 (0.0%) |
| later-shared-recipes | rest | 6 | 6 | 6/6 (100.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 6/6 (100.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-voice-booth | ask | 10 | 10 | 0/10 (0.0%) |
| later-voice-booth | invest | 10 | 10 | 0/10 (0.0%) |
| later-voice-booth | rest | 10 | 10 | 10/10 (100.0%) |
| middle-friend-letter | rest | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 8/8 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rest-circle | boundaries | 15 | 15 | 0/15 (0.0%) |
| middle-rest-circle | rest | 15 | 15 | 15/15 (100.0%) |
| middle-rest-circle | walk | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | ask | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | invest | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/13 (0.0%) |
| middle-seed-exchange | onePot | 13 | 13 | 0/13 (0.0%) |
| middle-seed-exchange | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | seekGuide | 13 | 13 | 0/13 (0.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 10 | 10 | 0/10 (0.0%) |
| middle-support | invest | 10 | 10 | 0/10 (0.0%) |
| middle-support | rest | 10 | 10 | 10/10 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/10 (0.0%) |
| middle-turn | ask | 10 | 10 | 0/10 (0.0%) |
| middle-turn | invest | 10 | 10 | 0/10 (0.0%) |
| middle-turn | offline | 10 | 10 | 0/10 (0.0%) |
| middle-turn | rest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | ask | 6 | 6 | 0/6 (0.0%) |
| teen-direction | invest | 6 | 6 | 0/6 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/6 (0.0%) |
| teen-direction | offline | 6 | 6 | 0/6 (0.0%) |
| teen-direction | rest | 6 | 6 | 6/6 (100.0%) |
| teen-launch | ask | 10 | 10 | 0/10 (0.0%) |
| teen-launch | invest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | rest | 10 | 10 | 10/10 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 10 | 10 | 0/10 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/10 (0.0%) |
| teen-river-survey | rest | 10 | 10 | 10/10 (100.0%) |
| teen-river-survey | seekGuide | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | ask | 16 | 16 | 0/16 (0.0%) |
| teen-shared-kitchen | invest | 16 | 16 | 0/16 (0.0%) |
| teen-shared-kitchen | rest | 16 | 16 | 16/16 (100.0%) |
| teen-shared-room | agreement | 11 | 11 | 0/11 (0.0%) |
| teen-shared-room | privateRoom | 11 | 11 | 0/11 (0.0%) |
| teen-shared-room | rest | 11 | 11 | 11/11 (100.0%) |
| teen-tool-library | practice | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | seekGuide | 10 | 10 | 0/10 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/290 (0.0%) | 0/290 (0.0%) | 0/290 (0.0%) |
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
| story.childhood-connection | 32/32 (100.0%) | 3/32 (9.4%) | 3/32 (9.4%) |
| story.learning-route | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.care-network | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.repair | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.kitchen | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.garden | 0/32 (0.0%) | 13/32 (40.6%) | 0/32 (0.0%) |
| story.nature | 0/32 (0.0%) | 18/32 (56.2%) | 0/32 (0.0%) |

## usa-1／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 33/96 (34.4%) | 14/96 (14.6%) | 14/33 (42.4%) | windmill-promise: 34/96 (35.4%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 34, &#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 16} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 90/96 (93.8%) | 7/96 (7.3%) | 7/90 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| teen-river-survey | 17–32 | 105/128 (82.0%) | 11/128 (8.6%) | 11/105 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 23} |
| teen-tool-library | 17–32 | 113/128 (88.3%) | 7/128 (5.5%) | 7/113 (6.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 15} |
| teen-launch | 21–25 | 58/64 (90.6%) | 7/64 (10.9%) | 7/58 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-repair-table | 17–32 | 52/128 (40.6%) | 6/128 (4.7%) | 6/52 (11.5%) | made-a-project: 64/128 (50.0%); repair-practice: 20/128 (15.6%); 規則排除：{&#x27;condition:made-a-project&#x27;: 64, &#x27;condition:repair-practice&#x27;: 20, &#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 12} |
| teen-shared-kitchen | 17–32 | 102/128 (79.7%) | 12/128 (9.4%) | 12/102 (11.8%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 26} |
| teen-shared-room | 21–32 | 82/96 (85.4%) | 9/96 (9.4%) | 9/82 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 14} |
| adult-learning | 25–45 | 91/128 (71.1%) | 5/128 (3.9%) | 5/91 (5.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| adult-local-trail | 25–59 | 127/192 (66.1%) | 11/192 (5.7%) | 11/127 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 41} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 6/128 (4.7%) | 6/92 (6.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 129/192 (67.2%) | 18/192 (9.4%) | 18/129 (14.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 11/192 (5.7%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 11/128 (8.6%) | 11/116 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 137/192 (71.4%) | 9/192 (4.7%) | 9/137 (6.6%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 25} |
| middle-open-desk | 45–72 | 44/160 (27.5%) | 4/160 (2.5%) | 4/44 (9.1%) | shared-care-contacts: 106/160 (66.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 106, &#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 10} |
| middle-rhythm | 59–72 | 84/96 (87.5%) | 11/96 (11.5%) | 11/84 (13.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 7} |
| later-tool-stories | 59–72 | 86/96 (89.6%) | 7/96 (7.3%) | 7/86 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 10} |
| later-voice-booth | 59–72 | 89/96 (92.7%) | 7/96 (7.3%) | 7/89 (7.9%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 7} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 6 | 6 | 0/6 (0.0%) |
| adult-balance | invest | 6 | 6 | 4/6 (66.7%) |
| adult-balance | rest | 6 | 6 | 2/6 (33.3%) |
| adult-broken-bicycle | borrow | 15 | 15 | 7/15 (46.7%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 3/15 (20.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 5/15 (33.3%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 5 | 5 | 0/5 (0.0%) |
| adult-learning | invest | 5 | 5 | 2/5 (40.0%) |
| adult-learning | offline | 5 | 5 | 1/5 (20.0%) |
| adult-learning | rest | 5 | 5 | 2/5 (40.0%) |
| adult-local-trail | lead | 1 | 1 | 0/11 (0.0%) |
| adult-local-trail | record | 11 | 11 | 6/11 (54.5%) |
| adult-local-trail | rest | 11 | 11 | 3/11 (27.3%) |
| adult-local-trail | seekGuide | 11 | 11 | 2/11 (18.2%) |
| adult-meal-circle | lead | 2 | 2 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 3/13 (23.1%) |
| adult-meal-circle | seekGuide | 13 | 13 | 6/13 (46.2%) |
| adult-meal-circle | trial | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | ask | 4 | 4 | 1/4 (25.0%) |
| adult-neighbor-market | invest | 4 | 4 | 2/4 (50.0%) |
| adult-neighbor-market | rest | 4 | 4 | 1/4 (25.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 2/12 (16.7%) |
| adult-repair-coop | lead | 2 | 2 | 1/12 (8.3%) |
| adult-repair-coop | rest | 12 | 12 | 4/12 (33.3%) |
| adult-repair-coop | seekGuide | 12 | 12 | 5/12 (41.7%) |
| adult-shift-offer | extraShift | 10 | 10 | 5/10 (50.0%) |
| adult-shift-offer | predictable | 10 | 10 | 3/10 (30.0%) |
| adult-shift-offer | rest | 10 | 10 | 2/10 (20.0%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 6 | 6 | 1/6 (16.7%) |
| child-library-map | invest | 6 | 6 | 2/6 (33.3%) |
| child-library-map | rest | 6 | 6 | 3/6 (50.0%) |
| child-quiet-stage | backstage | 10 | 10 | 3/10 (30.0%) |
| child-quiet-stage | perform | 10 | 10 | 5/10 (50.0%) |
| child-quiet-stage | rest | 10 | 10 | 2/10 (20.0%) |
| child-rain-notebook | observe | 13 | 13 | 2/13 (15.4%) |
| child-rain-notebook | rest | 13 | 13 | 5/13 (38.5%) |
| child-rain-notebook | seekGuide | 13 | 13 | 6/13 (46.2%) |
| child-transition | ask | 7 | 7 | 2/7 (28.6%) |
| child-transition | invest | 7 | 7 | 5/7 (71.4%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 14 | 14 | 5/14 (35.7%) |
| child-wind-team | invest | 14 | 14 | 0/14 (0.0%) |
| child-wind-team | rest | 14 | 14 | 9/14 (64.3%) |
| later-pass-on | ask | 6 | 6 | 1/6 (16.7%) |
| later-pass-on | invest | 6 | 6 | 3/6 (50.0%) |
| later-pass-on | rest | 6 | 6 | 2/6 (33.3%) |
| later-path-map | lead | 2 | 2 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 4/5 (80.0%) |
| later-path-map | seekGuide | 5 | 5 | 0/5 (0.0%) |
| later-path-map | shortWalk | 5 | 5 | 1/5 (20.0%) |
| later-reconnect | ask | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | invest | 7 | 7 | 3/7 (42.9%) |
| later-reconnect | rest | 7 | 7 | 3/7 (42.9%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-shared-recipes | cookOnce | 6 | 6 | 2/6 (33.3%) |
| later-shared-recipes | lead | 2 | 2 | 1/6 (16.7%) |
| later-shared-recipes | rest | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 3/6 (50.0%) |
| later-tool-stories | lead | 4 | 4 | 4/7 (57.1%) |
| later-tool-stories | learnAgain | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | rest | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | seekGuide | 7 | 7 | 1/7 (14.3%) |
| later-voice-booth | ask | 7 | 7 | 2/7 (28.6%) |
| later-voice-booth | invest | 7 | 7 | 3/7 (42.9%) |
| later-voice-booth | rest | 7 | 7 | 2/7 (28.6%) |
| middle-friend-letter | rest | 18 | 18 | 5/18 (27.8%) |
| middle-friend-letter | seekGuide | 18 | 18 | 7/18 (38.9%) |
| middle-friend-letter | write | 18 | 18 | 6/18 (33.3%) |
| middle-garden-table | ask | 9 | 9 | 2/9 (22.2%) |
| middle-garden-table | invest | 9 | 9 | 4/9 (44.4%) |
| middle-garden-table | rest | 9 | 9 | 3/9 (33.3%) |
| middle-open-desk | ask | 4 | 4 | 2/4 (50.0%) |
| middle-open-desk | invest | 4 | 4 | 1/4 (25.0%) |
| middle-open-desk | rest | 4 | 4 | 1/4 (25.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 2/14 (14.3%) |
| middle-rest-circle | rest | 14 | 14 | 6/14 (42.9%) |
| middle-rest-circle | walk | 14 | 14 | 6/14 (42.9%) |
| middle-rhythm | ask | 11 | 11 | 1/11 (9.1%) |
| middle-rhythm | invest | 11 | 11 | 3/11 (27.3%) |
| middle-rhythm | rest | 11 | 11 | 7/11 (63.6%) |
| middle-seed-exchange | lead | 2 | 2 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 5/10 (50.0%) |
| middle-seed-exchange | rest | 10 | 10 | 1/10 (10.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 4/10 (40.0%) |
| middle-skill-exchange | rest | 11 | 11 | 4/11 (36.4%) |
| middle-skill-exchange | study | 11 | 11 | 1/11 (9.1%) |
| middle-skill-exchange | teach | 11 | 11 | 6/11 (54.5%) |
| middle-support | ask | 11 | 11 | 3/11 (27.3%) |
| middle-support | invest | 11 | 11 | 5/11 (45.5%) |
| middle-support | rest | 11 | 11 | 2/11 (18.2%) |
| middle-support | shareShift | 5 | 5 | 1/11 (9.1%) |
| middle-turn | ask | 9 | 9 | 3/9 (33.3%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 4/9 (44.4%) |
| middle-turn | rest | 9 | 9 | 2/9 (22.2%) |
| teen-direction | ask | 7 | 7 | 1/7 (14.3%) |
| teen-direction | invest | 7 | 7 | 1/7 (14.3%) |
| teen-direction | leadWorkshop | 2 | 2 | 1/7 (14.3%) |
| teen-direction | offline | 7 | 7 | 1/7 (14.3%) |
| teen-direction | rest | 7 | 7 | 3/7 (42.9%) |
| teen-launch | ask | 7 | 7 | 2/7 (28.6%) |
| teen-launch | invest | 7 | 7 | 2/7 (28.6%) |
| teen-launch | rest | 7 | 7 | 3/7 (42.9%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 6 | 6 | 0/6 (0.0%) |
| teen-repair-table | invest | 6 | 6 | 3/6 (50.0%) |
| teen-repair-table | rest | 6 | 6 | 3/6 (50.0%) |
| teen-river-survey | join | 11 | 11 | 2/11 (18.2%) |
| teen-river-survey | lead | 1 | 1 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 2/11 (18.2%) |
| teen-river-survey | seekGuide | 11 | 11 | 7/11 (63.6%) |
| teen-shared-kitchen | ask | 12 | 12 | 3/12 (25.0%) |
| teen-shared-kitchen | invest | 12 | 12 | 6/12 (50.0%) |
| teen-shared-kitchen | rest | 12 | 12 | 3/12 (25.0%) |
| teen-shared-room | agreement | 9 | 9 | 3/9 (33.3%) |
| teen-shared-room | privateRoom | 9 | 9 | 4/9 (44.4%) |
| teen-shared-room | rest | 9 | 9 | 2/9 (22.2%) |
| teen-tool-library | practice | 7 | 7 | 1/7 (14.3%) |
| teen-tool-library | rest | 7 | 7 | 4/7 (57.1%) |
| teen-tool-library | seekGuide | 7 | 7 | 2/7 (28.6%) |

相鄰相同行動類型：113/448 (25.2%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/186 (0.0%) | 0/186 (0.0%) | 0/366 (0.0%) |
| 財務安全 | 0/25 (0.0%) | 0/25 (0.0%) | 0/56 (0.0%) |
| 人際關係 | 0/406 (0.0%) | 0/406 (0.0%) | 0/666 (0.0%) |
| 技能 | 0/242 (0.0%) | 0/242 (0.0%) | 0/551 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/9 (0.0%) | 0/9 (0.0%) | 0/9 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) |
| story.learning-route | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) |
| story.care-network | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |
| story.repair | 22/32 (68.8%) | 15/32 (46.9%) | 6/32 (18.8%) |
| story.kitchen | 20/32 (62.5%) | 16/32 (50.0%) | 8/32 (25.0%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 19/32 (59.4%) | 21/32 (65.6%) | 10/32 (31.2%) |

## usa-2／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 11/96 (11.5%) | 11/60 (18.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 14/96 (14.6%) | 14/57 (24.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 16/96 (16.7%) | 16/55 (29.1%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 90/96 (93.8%) | 10/96 (10.4%) | 10/90 (11.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-river-survey | 17–32 | 110/128 (85.9%) | 13/128 (10.2%) | 13/110 (11.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| teen-tool-library | 17–32 | 114/128 (89.1%) | 6/128 (4.7%) | 6/114 (5.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 14} |
| teen-launch | 21–25 | 60/64 (93.8%) | 5/64 (7.8%) | 5/60 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 4} |
| teen-repair-table | 17–32 | 91/128 (71.1%) | 18/128 (14.1%) | 18/91 (19.8%) | made-a-project: 0/128 (0.0%); repair-practice: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 16, &#x27;one-shot&#x27;: 37} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 80/96 (83.3%) | 10/96 (10.4%) | 10/80 (12.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 16} |
| adult-learning | 25–45 | 91/128 (71.1%) | 4/128 (3.1%) | 4/91 (4.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| adult-local-trail | 25–59 | 122/192 (63.5%) | 12/192 (6.2%) | 12/122 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 47} |
| adult-meal-circle | 25–59 | 139/192 (72.4%) | 12/192 (6.2%) | 12/139 (8.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 26} |
| adult-repair-coop | 25–59 | 127/192 (66.1%) | 14/192 (7.3%) | 14/127 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 40} |
| adult-shift-offer | 25–52 | 106/160 (66.2%) | 9/160 (5.6%) | 9/106 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| adult-balance | 32–52 | 95/128 (74.2%) | 4/128 (3.1%) | 4/95 (4.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 1, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 1} |
| adult-broken-bicycle | 25–59 | 131/192 (68.2%) | 13/192 (6.8%) | 13/131 (9.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 35} |
| adult-neighbor-market | 25–52 | 106/160 (66.2%) | 4/160 (2.5%) | 4/106 (3.8%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 20, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 136/192 (70.8%) | 15/192 (7.8%) | 15/136 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 28} |
| middle-seed-exchange | 45–72 | 147/160 (91.9%) | 10/160 (6.2%) | 10/147 (6.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 13} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 10/192 (5.2%) | 10/140 (7.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-rest-circle | 45–72 | 143/160 (89.4%) | 11/160 (6.9%) | 11/143 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 17} |
| middle-support | 52–72 | 116/128 (90.6%) | 12/128 (9.4%) | 12/116 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 144/192 (75.0%) | 6/192 (3.1%) | 6/144 (4.2%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 17} |
| middle-open-desk | 45–72 | 126/160 (78.8%) | 13/160 (8.1%) | 13/126 (10.3%) | shared-care-contacts: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 34} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 5/64 (7.8%) | 5/62 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 7} |
| later-tool-stories | 59–72 | 86/96 (89.6%) | 9/96 (9.4%) | 9/86 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 10} |
| later-voice-booth | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-path-map | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 4 | 4 | 0/4 (0.0%) |
| adult-balance | invest | 4 | 4 | 4/4 (100.0%) |
| adult-balance | rest | 4 | 4 | 0/4 (0.0%) |
| adult-broken-bicycle | borrow | 13 | 13 | 0/13 (0.0%) |
| adult-broken-bicycle | repairTogether | 13 | 13 | 13/13 (100.0%) |
| adult-broken-bicycle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 4 | 4 | 0/4 (0.0%) |
| adult-learning | invest | 4 | 4 | 4/4 (100.0%) |
| adult-learning | offline | 4 | 4 | 0/4 (0.0%) |
| adult-learning | rest | 4 | 4 | 0/4 (0.0%) |
| adult-local-trail | lead | 8 | 8 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 12/12 (100.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/12 (0.0%) |
| adult-meal-circle | rest | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | trial | 12 | 12 | 12/12 (100.0%) |
| adult-neighbor-market | ask | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | invest | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 14 | 14 | 14/14 (100.0%) |
| adult-repair-coop | lead | 12 | 12 | 0/14 (0.0%) |
| adult-repair-coop | rest | 14 | 14 | 0/14 (0.0%) |
| adult-repair-coop | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-shift-offer | extraShift | 9 | 9 | 9/9 (100.0%) |
| adult-shift-offer | predictable | 9 | 9 | 0/9 (0.0%) |
| adult-shift-offer | rest | 9 | 9 | 0/9 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 0/5 (0.0%) |
| child-library-map | invest | 5 | 5 | 5/5 (100.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 11 | 11 | 11/11 (100.0%) |
| child-quiet-stage | perform | 11 | 11 | 0/11 (0.0%) |
| child-quiet-stage | rest | 11 | 11 | 0/11 (0.0%) |
| child-rain-notebook | observe | 14 | 14 | 14/14 (100.0%) |
| child-rain-notebook | rest | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | seekGuide | 14 | 14 | 0/14 (0.0%) |
| child-transition | ask | 7 | 7 | 0/7 (0.0%) |
| child-transition | invest | 7 | 7 | 7/7 (100.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 16 | 16 | 0/16 (0.0%) |
| child-wind-team | invest | 16 | 16 | 16/16 (100.0%) |
| child-wind-team | rest | 16 | 16 | 0/16 (0.0%) |
| later-pass-on | ask | 5 | 5 | 0/5 (0.0%) |
| later-pass-on | invest | 5 | 5 | 5/5 (100.0%) |
| later-pass-on | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | lead | 6 | 6 | 6/7 (85.7%) |
| later-path-map | rest | 7 | 7 | 0/7 (0.0%) |
| later-path-map | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-path-map | shortWalk | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | ask | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | invest | 5 | 5 | 5/5 (100.0%) |
| later-reconnect | rest | 5 | 5 | 0/5 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 6 | 6 | 6/6 (100.0%) |
| later-shared-recipes | lead | 3 | 3 | 0/6 (0.0%) |
| later-shared-recipes | rest | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | lead | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | learnAgain | 9 | 9 | 9/9 (100.0%) |
| later-tool-stories | rest | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | seekGuide | 9 | 9 | 0/9 (0.0%) |
| later-voice-booth | ask | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | invest | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | seekGuide | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | write | 15 | 15 | 15/15 (100.0%) |
| middle-garden-table | ask | 6 | 6 | 0/6 (0.0%) |
| middle-garden-table | invest | 6 | 6 | 6/6 (100.0%) |
| middle-garden-table | rest | 6 | 6 | 0/6 (0.0%) |
| middle-open-desk | ask | 13 | 13 | 0/13 (0.0%) |
| middle-open-desk | invest | 13 | 13 | 13/13 (100.0%) |
| middle-open-desk | rest | 13 | 13 | 0/13 (0.0%) |
| middle-rest-circle | boundaries | 11 | 11 | 0/11 (0.0%) |
| middle-rest-circle | rest | 11 | 11 | 11/11 (100.0%) |
| middle-rest-circle | walk | 11 | 11 | 0/11 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | invest | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 3 | 3 | 3/10 (30.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 7/10 (70.0%) |
| middle-seed-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | study | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | teach | 10 | 10 | 0/10 (0.0%) |
| middle-support | ask | 12 | 12 | 0/12 (0.0%) |
| middle-support | invest | 12 | 12 | 12/12 (100.0%) |
| middle-support | rest | 12 | 12 | 0/12 (0.0%) |
| middle-support | shareShift | 12 | 12 | 0/12 (0.0%) |
| middle-turn | ask | 7 | 7 | 0/7 (0.0%) |
| middle-turn | invest | 7 | 7 | 7/7 (100.0%) |
| middle-turn | offline | 7 | 7 | 0/7 (0.0%) |
| middle-turn | rest | 7 | 7 | 0/7 (0.0%) |
| teen-direction | ask | 10 | 10 | 0/10 (0.0%) |
| teen-direction | invest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | leadWorkshop | 10 | 10 | 0/10 (0.0%) |
| teen-direction | offline | 10 | 10 | 0/10 (0.0%) |
| teen-direction | rest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | ask | 5 | 5 | 0/5 (0.0%) |
| teen-launch | invest | 5 | 5 | 5/5 (100.0%) |
| teen-launch | rest | 5 | 5 | 0/5 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 18 | 18 | 0/18 (0.0%) |
| teen-repair-table | invest | 18 | 18 | 18/18 (100.0%) |
| teen-repair-table | rest | 18 | 18 | 0/18 (0.0%) |
| teen-river-survey | join | 13 | 13 | 13/13 (100.0%) |
| teen-river-survey | lead | 7 | 7 | 0/13 (0.0%) |
| teen-river-survey | rest | 13 | 13 | 0/13 (0.0%) |
| teen-river-survey | seekGuide | 13 | 13 | 0/13 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 10 | 10 | 10/10 (100.0%) |
| teen-shared-room | privateRoom | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | rest | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | practice | 6 | 6 | 6/6 (100.0%) |
| teen-tool-library | rest | 6 | 6 | 0/6 (0.0%) |
| teen-tool-library | seekGuide | 6 | 6 | 0/6 (0.0%) |

相鄰相同行動類型：225/448 (50.2%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/31 (0.0%) | 0/31 (0.0%) | 0/42 (0.0%) |
| 財務安全 | 0/39 (0.0%) | 0/39 (0.0%) | 0/82 (0.0%) |
| 人際關係 | 0/455 (0.0%) | 0/455 (0.0%) | 0/953 (0.0%) |
| 技能 | 0/352 (0.0%) | 0/352 (0.0%) | 0/1249 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/43 (0.0%) | 0/43 (0.0%) | 0/43 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) |
| story.learning-route | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.care-network | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) |
| story.repair | 32/32 (100.0%) | 19/32 (59.4%) | 18/32 (56.2%) |
| story.kitchen | 20/32 (62.5%) | 15/32 (46.9%) | 7/32 (21.9%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 3/32 (9.4%) |
| story.nature | 25/32 (78.1%) | 22/32 (68.8%) | 15/32 (46.9%) |

## usa-2／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 12/96 (12.5%) | 12/60 (20.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 14/96 (14.6%) | 14/57 (24.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 19/96 (19.8%) | 19/55 (34.5%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 8/96 (8.3%) | 8/89 (9.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 106/128 (82.8%) | 12/128 (9.4%) | 12/106 (11.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-tool-library | 17–32 | 109/128 (85.2%) | 9/128 (7.0%) | 9/109 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 19} |
| teen-launch | 21–25 | 57/64 (89.1%) | 9/64 (14.1%) | 9/57 (15.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 7} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 49/128 (38.3%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 49} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 74/96 (77.1%) | 14/96 (14.6%) | 14/74 (18.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;one-shot&#x27;: 22} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 120/192 (62.5%) | 12/192 (6.2%) | 12/120 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 50} |
| adult-meal-circle | 25–59 | 133/192 (69.3%) | 14/192 (7.3%) | 14/133 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 33} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 93/128 (72.7%) | 5/128 (3.9%) | 5/93 (5.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 4} |
| adult-broken-bicycle | 25–59 | 128/192 (66.7%) | 14/192 (7.3%) | 14/128 (10.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 39} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 140/160 (87.5%) | 11/160 (6.9%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 20} |
| middle-skill-exchange | 32–65 | 138/192 (71.9%) | 12/192 (6.2%) | 12/138 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 23} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 9/128 (7.0%) | 9/116 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 21/160 (13.1%) | 4/160 (2.5%) | 4/21 (19.0%) | shared-care-contacts: 130/160 (81.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 130, &#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 9} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 5 | 5 | 5/5 (100.0%) |
| adult-balance | invest | 5 | 5 | 0/5 (0.0%) |
| adult-balance | rest | 5 | 5 | 0/5 (0.0%) |
| adult-broken-bicycle | borrow | 14 | 14 | 14/14 (100.0%) |
| adult-broken-bicycle | repairTogether | 14 | 14 | 0/14 (0.0%) |
| adult-broken-bicycle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 6 | 6 | 6/6 (100.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 0/6 (0.0%) |
| adult-local-trail | lead | 0 | 0 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/14 (0.0%) |
| adult-meal-circle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-meal-circle | seekGuide | 14 | 14 | 14/14 (100.0%) |
| adult-meal-circle | trial | 14 | 14 | 0/14 (0.0%) |
| adult-neighbor-market | ask | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | invest | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 5/5 (100.0%) |
| child-library-map | invest | 5 | 5 | 0/5 (0.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | perform | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | rest | 12 | 12 | 12/12 (100.0%) |
| child-rain-notebook | observe | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | rest | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | seekGuide | 14 | 14 | 14/14 (100.0%) |
| child-transition | ask | 7 | 7 | 7/7 (100.0%) |
| child-transition | invest | 7 | 7 | 0/7 (0.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 19 | 19 | 19/19 (100.0%) |
| child-wind-team | invest | 19 | 19 | 0/19 (0.0%) |
| child-wind-team | rest | 19 | 19 | 0/19 (0.0%) |
| later-pass-on | ask | 6 | 6 | 6/6 (100.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 0/6 (0.0%) |
| later-path-map | lead | 0 | 0 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | seekGuide | 5 | 5 | 5/5 (100.0%) |
| later-path-map | shortWalk | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | ask | 9 | 9 | 9/9 (100.0%) |
| later-reconnect | invest | 9 | 9 | 0/9 (0.0%) |
| later-reconnect | rest | 9 | 9 | 0/9 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | ask | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | invest | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 8/8 (100.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 0/8 (0.0%) |
| middle-open-desk | ask | 4 | 4 | 4/4 (100.0%) |
| middle-open-desk | invest | 4 | 4 | 0/4 (0.0%) |
| middle-open-desk | rest | 4 | 4 | 0/4 (0.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 14/14 (100.0%) |
| middle-rest-circle | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | walk | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | invest | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/11 (0.0%) |
| middle-seed-exchange | onePot | 11 | 11 | 0/11 (0.0%) |
| middle-seed-exchange | rest | 11 | 11 | 0/11 (0.0%) |
| middle-seed-exchange | seekGuide | 11 | 11 | 11/11 (100.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 9 | 9 | 9/9 (100.0%) |
| middle-support | invest | 9 | 9 | 0/9 (0.0%) |
| middle-support | rest | 9 | 9 | 0/9 (0.0%) |
| middle-support | shareShift | 2 | 2 | 0/9 (0.0%) |
| middle-turn | ask | 9 | 9 | 9/9 (100.0%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 0/9 (0.0%) |
| middle-turn | rest | 9 | 9 | 0/9 (0.0%) |
| teen-direction | ask | 8 | 8 | 8/8 (100.0%) |
| teen-direction | invest | 8 | 8 | 0/8 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 0/8 (0.0%) |
| teen-launch | ask | 9 | 9 | 9/9 (100.0%) |
| teen-launch | invest | 9 | 9 | 0/9 (0.0%) |
| teen-launch | rest | 9 | 9 | 0/9 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | seekGuide | 12 | 12 | 12/12 (100.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 14 | 14 | 0/14 (0.0%) |
| teen-shared-room | privateRoom | 14 | 14 | 0/14 (0.0%) |
| teen-shared-room | rest | 14 | 14 | 14/14 (100.0%) |
| teen-tool-library | practice | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | rest | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | seekGuide | 9 | 9 | 9/9 (100.0%) |

相鄰相同行動類型：360/448 (80.4%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/62 (0.0%) | 0/62 (0.0%) | 0/124 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/432 (0.0%) | 0/432 (0.0%) | 0/717 (0.0%) |
| 技能 | 0/404 (0.0%) | 0/404 (0.0%) | 0/404 (0.0%) |

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
| story.childhood-connection | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.repair | 25/32 (78.1%) | 15/32 (46.9%) | 9/32 (28.1%) |
| story.kitchen | 14/32 (43.8%) | 17/32 (53.1%) | 4/32 (12.5%) |
| story.garden | 16/32 (50.0%) | 11/32 (34.4%) | 2/32 (6.2%) |
| story.nature | 25/32 (78.1%) | 23/32 (71.9%) | 14/32 (43.8%) |

## usa-2／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 59/96 (61.5%) | 17/96 (17.7%) | 17/59 (28.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 17/96 (17.7%) | 17/57 (29.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | windmill-promise: 96/96 (100.0%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 96, &#x27;milestone-slot&#x27;: 32} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 8/96 (8.3%) | 8/89 (9.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 104/128 (81.2%) | 12/128 (9.4%) | 12/104 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 24} |
| teen-tool-library | 17–32 | 106/128 (82.8%) | 10/128 (7.8%) | 10/106 (9.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-launch | 21–25 | 56/64 (87.5%) | 10/64 (15.6%) | 10/56 (17.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 8} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 128/128 (100.0%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 128} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 72/96 (75.0%) | 15/96 (15.6%) | 15/72 (20.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;one-shot&#x27;: 24} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 130/192 (67.7%) | 10/192 (5.2%) | 10/130 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 37} |
| adult-meal-circle | 25–59 | 132/192 (68.8%) | 14/192 (7.3%) | 14/132 (10.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 35} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 100/160 (62.5%) | 10/160 (6.2%) | 10/100 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 15, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 7/128 (5.5%) | 7/92 (7.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 16/192 (8.3%) | 16/124 (12.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 100/160 (62.5%) | 5/160 (3.1%) | 5/100 (5.0%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 15} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 138/160 (86.2%) | 14/160 (8.8%) | 14/138 (10.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 22} |
| middle-skill-exchange | 32–65 | 137/192 (71.4%) | 12/192 (6.2%) | 12/137 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| middle-turn | 45–59 | 83/96 (86.5%) | 10/96 (10.4%) | 10/83 (12.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 13} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 15/160 (9.4%) | 15/140 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 117/128 (91.4%) | 10/128 (7.8%) | 10/117 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 9/192 (4.7%) | 9/141 (6.4%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 0/160 (0.0%) | 0/160 (0.0%) | — (0/0) | shared-care-contacts: 160/160 (100.0%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 160} |
| middle-rhythm | 59–72 | 82/96 (85.4%) | 13/96 (13.5%) | 13/82 (15.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 14} |
| later-pass-on | 65–72 | 61/64 (95.3%) | 7/64 (10.9%) | 7/61 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 3} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 7/96 (7.3%) | 7/90 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | recording-companion: 0/96 (0.0%); sharing-connection: 96/96 (100.0%); 規則排除：{&#x27;condition:sharing-connection&#x27;: 96} |
| later-path-map | 59–72 | 91/96 (94.8%) | 4/96 (4.2%) | 4/91 (4.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 7 | 7 | 0/7 (0.0%) |
| adult-balance | invest | 7 | 7 | 0/7 (0.0%) |
| adult-balance | rest | 7 | 7 | 7/7 (100.0%) |
| adult-broken-bicycle | borrow | 16 | 16 | 0/16 (0.0%) |
| adult-broken-bicycle | repairTogether | 16 | 16 | 0/16 (0.0%) |
| adult-broken-bicycle | rest | 16 | 16 | 16/16 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 6/6 (100.0%) |
| adult-local-trail | lead | 0 | 0 | 0/10 (0.0%) |
| adult-local-trail | record | 10 | 10 | 0/10 (0.0%) |
| adult-local-trail | rest | 10 | 10 | 10/10 (100.0%) |
| adult-local-trail | seekGuide | 10 | 10 | 0/10 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/14 (0.0%) |
| adult-meal-circle | rest | 14 | 14 | 14/14 (100.0%) |
| adult-meal-circle | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-meal-circle | trial | 14 | 14 | 0/14 (0.0%) |
| adult-neighbor-market | ask | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | invest | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | rest | 5 | 5 | 5/5 (100.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 12/12 (100.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 12 | 12 | 0/12 (0.0%) |
| child-library-map | invest | 12 | 12 | 0/12 (0.0%) |
| child-library-map | rest | 12 | 12 | 12/12 (100.0%) |
| child-quiet-stage | backstage | 17 | 17 | 0/17 (0.0%) |
| child-quiet-stage | perform | 17 | 17 | 0/17 (0.0%) |
| child-quiet-stage | rest | 17 | 17 | 17/17 (100.0%) |
| child-rain-notebook | observe | 17 | 17 | 0/17 (0.0%) |
| child-rain-notebook | rest | 17 | 17 | 17/17 (100.0%) |
| child-rain-notebook | seekGuide | 17 | 17 | 0/17 (0.0%) |
| child-transition | ask | 8 | 8 | 0/8 (0.0%) |
| child-transition | invest | 8 | 8 | 0/8 (0.0%) |
| child-transition | rest | 8 | 8 | 8/8 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 7 | 7 | 0/7 (0.0%) |
| later-pass-on | invest | 7 | 7 | 0/7 (0.0%) |
| later-pass-on | rest | 7 | 7 | 7/7 (100.0%) |
| later-path-map | lead | 0 | 0 | 0/4 (0.0%) |
| later-path-map | rest | 4 | 4 | 4/4 (100.0%) |
| later-path-map | seekGuide | 4 | 4 | 0/4 (0.0%) |
| later-path-map | shortWalk | 4 | 4 | 0/4 (0.0%) |
| later-reconnect | ask | 6 | 6 | 0/6 (0.0%) |
| later-reconnect | invest | 6 | 6 | 0/6 (0.0%) |
| later-reconnect | rest | 6 | 6 | 6/6 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 7/7 (100.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | lead | 0 | 0 | 0/7 (0.0%) |
| later-tool-stories | learnAgain | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | rest | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | ask | 0 | 0 | — (0/0) |
| later-voice-booth | invest | 0 | 0 | — (0/0) |
| later-voice-booth | rest | 0 | 0 | — (0/0) |
| middle-friend-letter | rest | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 9 | 9 | 0/9 (0.0%) |
| middle-garden-table | invest | 9 | 9 | 0/9 (0.0%) |
| middle-garden-table | rest | 9 | 9 | 9/9 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rest-circle | boundaries | 15 | 15 | 0/15 (0.0%) |
| middle-rest-circle | rest | 15 | 15 | 15/15 (100.0%) |
| middle-rest-circle | walk | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | ask | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | invest | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/14 (0.0%) |
| middle-seed-exchange | onePot | 14 | 14 | 0/14 (0.0%) |
| middle-seed-exchange | rest | 14 | 14 | 14/14 (100.0%) |
| middle-seed-exchange | seekGuide | 14 | 14 | 0/14 (0.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 10 | 10 | 0/10 (0.0%) |
| middle-support | invest | 10 | 10 | 0/10 (0.0%) |
| middle-support | rest | 10 | 10 | 10/10 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/10 (0.0%) |
| middle-turn | ask | 10 | 10 | 0/10 (0.0%) |
| middle-turn | invest | 10 | 10 | 0/10 (0.0%) |
| middle-turn | offline | 10 | 10 | 0/10 (0.0%) |
| middle-turn | rest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | ask | 8 | 8 | 0/8 (0.0%) |
| teen-direction | invest | 8 | 8 | 0/8 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 8/8 (100.0%) |
| teen-launch | ask | 10 | 10 | 0/10 (0.0%) |
| teen-launch | invest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | rest | 10 | 10 | 10/10 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 12/12 (100.0%) |
| teen-river-survey | seekGuide | 12 | 12 | 0/12 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 15 | 15 | 0/15 (0.0%) |
| teen-shared-room | privateRoom | 15 | 15 | 0/15 (0.0%) |
| teen-shared-room | rest | 15 | 15 | 15/15 (100.0%) |
| teen-tool-library | practice | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | seekGuide | 10 | 10 | 0/10 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/271 (0.0%) | 0/271 (0.0%) | 0/271 (0.0%) |
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
| story.childhood-connection | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.repair | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.kitchen | 0/32 (0.0%) | 16/32 (50.0%) | 0/32 (0.0%) |
| story.garden | 0/32 (0.0%) | 14/32 (43.8%) | 0/32 (0.0%) |
| story.nature | 0/32 (0.0%) | 20/32 (62.5%) | 0/32 (0.0%) |

## usa-2／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 13/96 (13.5%) | 13/60 (21.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 15/96 (15.6%) | 15/57 (26.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 33/96 (34.4%) | 14/96 (14.6%) | 14/33 (42.4%) | windmill-promise: 34/96 (35.4%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 34, &#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 16} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 9/96 (9.4%) | 9/89 (10.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 104/128 (81.2%) | 12/128 (9.4%) | 12/104 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;one-shot&#x27;: 24} |
| teen-tool-library | 17–32 | 113/128 (88.3%) | 7/128 (5.5%) | 7/113 (6.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 15} |
| teen-launch | 21–25 | 58/64 (90.6%) | 7/64 (10.9%) | 7/58 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-repair-table | 17–32 | 49/128 (38.3%) | 7/128 (5.5%) | 7/49 (14.3%) | made-a-project: 64/128 (50.0%); repair-practice: 20/128 (15.6%); 規則排除：{&#x27;condition:made-a-project&#x27;: 64, &#x27;condition:repair-practice&#x27;: 20, &#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 15} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 78/96 (81.2%) | 11/96 (11.5%) | 11/78 (14.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 127/192 (66.1%) | 11/192 (5.7%) | 11/127 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 41} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 6/128 (4.7%) | 6/92 (6.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 129/192 (67.2%) | 18/192 (9.4%) | 18/129 (14.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 11/192 (5.7%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 11/128 (8.6%) | 11/116 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 137/192 (71.4%) | 9/192 (4.7%) | 9/137 (6.6%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 25} |
| middle-open-desk | 45–72 | 44/160 (27.5%) | 3/160 (1.9%) | 3/44 (6.8%) | shared-care-contacts: 106/160 (66.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 106, &#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 10} |
| middle-rhythm | 59–72 | 84/96 (87.5%) | 11/96 (11.5%) | 11/84 (13.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 91/96 (94.8%) | 5/96 (5.2%) | 5/91 (5.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 5} |
| later-tool-stories | 59–72 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 11} |
| later-voice-booth | 59–72 | 82/96 (85.4%) | 8/96 (8.3%) | 8/82 (9.8%) | recording-companion: 0/96 (0.0%); sharing-connection: 6/96 (6.2%); 規則排除：{&#x27;condition:sharing-connection&#x27;: 6, &#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 6 | 6 | 0/6 (0.0%) |
| adult-balance | invest | 6 | 6 | 4/6 (66.7%) |
| adult-balance | rest | 6 | 6 | 2/6 (33.3%) |
| adult-broken-bicycle | borrow | 15 | 15 | 7/15 (46.7%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 3/15 (20.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 5/15 (33.3%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 3/6 (50.0%) |
| adult-learning | offline | 6 | 6 | 1/6 (16.7%) |
| adult-learning | rest | 6 | 6 | 2/6 (33.3%) |
| adult-local-trail | lead | 2 | 2 | 0/11 (0.0%) |
| adult-local-trail | record | 11 | 11 | 6/11 (54.5%) |
| adult-local-trail | rest | 11 | 11 | 3/11 (27.3%) |
| adult-local-trail | seekGuide | 11 | 11 | 2/11 (18.2%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 2/13 (15.4%) |
| adult-meal-circle | seekGuide | 13 | 13 | 6/13 (46.2%) |
| adult-meal-circle | trial | 13 | 13 | 5/13 (38.5%) |
| adult-neighbor-market | ask | 4 | 4 | 1/4 (25.0%) |
| adult-neighbor-market | invest | 4 | 4 | 2/4 (50.0%) |
| adult-neighbor-market | rest | 4 | 4 | 1/4 (25.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 2/12 (16.7%) |
| adult-repair-coop | lead | 2 | 2 | 1/12 (8.3%) |
| adult-repair-coop | rest | 12 | 12 | 4/12 (33.3%) |
| adult-repair-coop | seekGuide | 12 | 12 | 5/12 (41.7%) |
| adult-shift-offer | extraShift | 10 | 10 | 5/10 (50.0%) |
| adult-shift-offer | predictable | 10 | 10 | 3/10 (30.0%) |
| adult-shift-offer | rest | 10 | 10 | 2/10 (20.0%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 6 | 6 | 1/6 (16.7%) |
| child-library-map | invest | 6 | 6 | 2/6 (33.3%) |
| child-library-map | rest | 6 | 6 | 3/6 (50.0%) |
| child-quiet-stage | backstage | 13 | 13 | 4/13 (30.8%) |
| child-quiet-stage | perform | 13 | 13 | 6/13 (46.2%) |
| child-quiet-stage | rest | 13 | 13 | 3/13 (23.1%) |
| child-rain-notebook | observe | 15 | 15 | 4/15 (26.7%) |
| child-rain-notebook | rest | 15 | 15 | 5/15 (33.3%) |
| child-rain-notebook | seekGuide | 15 | 15 | 6/15 (40.0%) |
| child-transition | ask | 7 | 7 | 2/7 (28.6%) |
| child-transition | invest | 7 | 7 | 5/7 (71.4%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 14 | 14 | 5/14 (35.7%) |
| child-wind-team | invest | 14 | 14 | 0/14 (0.0%) |
| child-wind-team | rest | 14 | 14 | 9/14 (64.3%) |
| later-pass-on | ask | 6 | 6 | 1/6 (16.7%) |
| later-pass-on | invest | 6 | 6 | 3/6 (50.0%) |
| later-pass-on | rest | 6 | 6 | 2/6 (33.3%) |
| later-path-map | lead | 2 | 2 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 4/5 (80.0%) |
| later-path-map | seekGuide | 5 | 5 | 0/5 (0.0%) |
| later-path-map | shortWalk | 5 | 5 | 1/5 (20.0%) |
| later-reconnect | ask | 8 | 8 | 1/8 (12.5%) |
| later-reconnect | invest | 8 | 8 | 4/8 (50.0%) |
| later-reconnect | rest | 8 | 8 | 3/8 (37.5%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-shared-recipes | cookOnce | 5 | 5 | 2/5 (40.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/5 (0.0%) |
| later-shared-recipes | rest | 5 | 5 | 1/5 (20.0%) |
| later-shared-recipes | seekGuide | 5 | 5 | 2/5 (40.0%) |
| later-tool-stories | lead | 4 | 4 | 3/7 (42.9%) |
| later-tool-stories | learnAgain | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | rest | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | seekGuide | 7 | 7 | 2/7 (28.6%) |
| later-voice-booth | ask | 8 | 8 | 3/8 (37.5%) |
| later-voice-booth | invest | 8 | 8 | 3/8 (37.5%) |
| later-voice-booth | rest | 8 | 8 | 2/8 (25.0%) |
| middle-friend-letter | rest | 18 | 18 | 5/18 (27.8%) |
| middle-friend-letter | seekGuide | 18 | 18 | 7/18 (38.9%) |
| middle-friend-letter | write | 18 | 18 | 6/18 (33.3%) |
| middle-garden-table | ask | 9 | 9 | 2/9 (22.2%) |
| middle-garden-table | invest | 9 | 9 | 4/9 (44.4%) |
| middle-garden-table | rest | 9 | 9 | 3/9 (33.3%) |
| middle-open-desk | ask | 3 | 3 | 1/3 (33.3%) |
| middle-open-desk | invest | 3 | 3 | 1/3 (33.3%) |
| middle-open-desk | rest | 3 | 3 | 1/3 (33.3%) |
| middle-rest-circle | boundaries | 14 | 14 | 2/14 (14.3%) |
| middle-rest-circle | rest | 14 | 14 | 6/14 (42.9%) |
| middle-rest-circle | walk | 14 | 14 | 6/14 (42.9%) |
| middle-rhythm | ask | 11 | 11 | 1/11 (9.1%) |
| middle-rhythm | invest | 11 | 11 | 3/11 (27.3%) |
| middle-rhythm | rest | 11 | 11 | 7/11 (63.6%) |
| middle-seed-exchange | lead | 2 | 2 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 5/10 (50.0%) |
| middle-seed-exchange | rest | 10 | 10 | 1/10 (10.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 4/10 (40.0%) |
| middle-skill-exchange | rest | 11 | 11 | 4/11 (36.4%) |
| middle-skill-exchange | study | 11 | 11 | 1/11 (9.1%) |
| middle-skill-exchange | teach | 11 | 11 | 6/11 (54.5%) |
| middle-support | ask | 11 | 11 | 3/11 (27.3%) |
| middle-support | invest | 11 | 11 | 5/11 (45.5%) |
| middle-support | rest | 11 | 11 | 2/11 (18.2%) |
| middle-support | shareShift | 5 | 5 | 1/11 (9.1%) |
| middle-turn | ask | 9 | 9 | 3/9 (33.3%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 4/9 (44.4%) |
| middle-turn | rest | 9 | 9 | 2/9 (22.2%) |
| teen-direction | ask | 9 | 9 | 1/9 (11.1%) |
| teen-direction | invest | 9 | 9 | 1/9 (11.1%) |
| teen-direction | leadWorkshop | 4 | 4 | 1/9 (11.1%) |
| teen-direction | offline | 9 | 9 | 1/9 (11.1%) |
| teen-direction | rest | 9 | 9 | 5/9 (55.6%) |
| teen-launch | ask | 7 | 7 | 2/7 (28.6%) |
| teen-launch | invest | 7 | 7 | 2/7 (28.6%) |
| teen-launch | rest | 7 | 7 | 3/7 (42.9%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 7 | 7 | 1/7 (14.3%) |
| teen-repair-table | invest | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | rest | 7 | 7 | 3/7 (42.9%) |
| teen-river-survey | join | 12 | 12 | 2/12 (16.7%) |
| teen-river-survey | lead | 1 | 1 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 2/12 (16.7%) |
| teen-river-survey | seekGuide | 12 | 12 | 8/12 (66.7%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 11 | 11 | 3/11 (27.3%) |
| teen-shared-room | privateRoom | 11 | 11 | 6/11 (54.5%) |
| teen-shared-room | rest | 11 | 11 | 2/11 (18.2%) |
| teen-tool-library | practice | 7 | 7 | 1/7 (14.3%) |
| teen-tool-library | rest | 7 | 7 | 4/7 (57.1%) |
| teen-tool-library | seekGuide | 7 | 7 | 2/7 (28.6%) |

相鄰相同行動類型：112/448 (25.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/188 (0.0%) | 0/188 (0.0%) | 0/370 (0.0%) |
| 財務安全 | 0/20 (0.0%) | 0/20 (0.0%) | 0/51 (0.0%) |
| 人際關係 | 0/403 (0.0%) | 0/403 (0.0%) | 0/650 (0.0%) |
| 技能 | 0/245 (0.0%) | 0/245 (0.0%) | 0/566 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.learning-route | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.care-network | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |
| story.repair | 23/32 (71.9%) | 15/32 (46.9%) | 6/32 (18.8%) |
| story.kitchen | 14/32 (43.8%) | 15/32 (46.9%) | 3/32 (9.4%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 21/32 (65.6%) | 22/32 (68.8%) | 11/32 (34.4%) |

## ind-1／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 15/96 (15.6%) | 15/55 (27.3%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 8/96 (8.3%) | 8/91 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 112/128 (87.5%) | 11/128 (8.6%) | 11/112 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 16} |
| teen-tool-library | 17–32 | 114/128 (89.1%) | 6/128 (4.7%) | 6/114 (5.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 14} |
| teen-launch | 21–25 | 60/64 (93.8%) | 5/64 (7.8%) | 5/60 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 4} |
| teen-repair-table | 17–32 | 94/128 (73.4%) | 17/128 (13.3%) | 17/94 (18.1%) | made-a-project: 0/128 (0.0%); repair-practice: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 15, &#x27;one-shot&#x27;: 34} |
| teen-shared-kitchen | 17–32 | 108/128 (84.4%) | 10/128 (7.8%) | 10/108 (9.3%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 20} |
| teen-shared-room | 21–32 | 84/96 (87.5%) | 8/96 (8.3%) | 8/84 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| adult-learning | 25–45 | 92/128 (71.9%) | 3/128 (2.3%) | 3/92 (3.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 6} |
| adult-local-trail | 25–59 | 122/192 (63.5%) | 12/192 (6.2%) | 12/122 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 47} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 127/192 (66.1%) | 14/192 (7.3%) | 14/127 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 40} |
| adult-shift-offer | 25–52 | 106/160 (66.2%) | 9/160 (5.6%) | 9/106 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| adult-balance | 32–52 | 95/128 (74.2%) | 4/128 (3.1%) | 4/95 (4.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 1, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 1} |
| adult-broken-bicycle | 25–59 | 130/192 (67.7%) | 14/192 (7.3%) | 14/130 (10.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| adult-neighbor-market | 25–52 | 106/160 (66.2%) | 4/160 (2.5%) | 4/106 (3.8%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 20, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 136/192 (70.8%) | 15/192 (7.8%) | 15/136 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 28} |
| middle-seed-exchange | 45–72 | 150/160 (93.8%) | 9/160 (5.6%) | 9/150 (6.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 10} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 10/192 (5.2%) | 10/140 (7.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-rest-circle | 45–72 | 143/160 (89.4%) | 11/160 (6.9%) | 11/143 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 17} |
| middle-support | 52–72 | 116/128 (90.6%) | 12/128 (9.4%) | 12/116 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 144/192 (75.0%) | 6/192 (3.1%) | 6/144 (4.2%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 17} |
| middle-open-desk | 45–72 | 126/160 (78.8%) | 14/160 (8.8%) | 14/126 (11.1%) | shared-care-contacts: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 34} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 5/64 (7.8%) | 5/62 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 87/96 (90.6%) | 9/96 (9.4%) | 9/87 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 9} |
| later-voice-booth | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 7} |
| later-path-map | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 4/32 (12.5%) | 4/32 (12.5%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 4 | 4 | 0/4 (0.0%) |
| adult-balance | invest | 4 | 4 | 4/4 (100.0%) |
| adult-balance | rest | 4 | 4 | 0/4 (0.0%) |
| adult-broken-bicycle | borrow | 14 | 14 | 0/14 (0.0%) |
| adult-broken-bicycle | repairTogether | 14 | 14 | 14/14 (100.0%) |
| adult-broken-bicycle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 3 | 3 | 0/3 (0.0%) |
| adult-learning | invest | 3 | 3 | 3/3 (100.0%) |
| adult-learning | offline | 3 | 3 | 0/3 (0.0%) |
| adult-learning | rest | 3 | 3 | 0/3 (0.0%) |
| adult-local-trail | lead | 7 | 7 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 12/12 (100.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | lead | 3 | 3 | 3/13 (23.1%) |
| adult-meal-circle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | trial | 13 | 13 | 10/13 (76.9%) |
| adult-neighbor-market | ask | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | invest | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 14 | 14 | 14/14 (100.0%) |
| adult-repair-coop | lead | 12 | 12 | 0/14 (0.0%) |
| adult-repair-coop | rest | 14 | 14 | 0/14 (0.0%) |
| adult-repair-coop | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-shift-offer | extraShift | 9 | 9 | 9/9 (100.0%) |
| adult-shift-offer | predictable | 9 | 9 | 0/9 (0.0%) |
| adult-shift-offer | rest | 9 | 9 | 0/9 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 0/5 (0.0%) |
| child-library-map | invest | 5 | 5 | 5/5 (100.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 10 | 10 | 10/10 (100.0%) |
| child-quiet-stage | perform | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | rest | 10 | 10 | 0/10 (0.0%) |
| child-rain-notebook | observe | 13 | 13 | 13/13 (100.0%) |
| child-rain-notebook | rest | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | seekGuide | 13 | 13 | 0/13 (0.0%) |
| child-transition | ask | 7 | 7 | 0/7 (0.0%) |
| child-transition | invest | 7 | 7 | 7/7 (100.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 15 | 15 | 0/15 (0.0%) |
| child-wind-team | invest | 15 | 15 | 15/15 (100.0%) |
| child-wind-team | rest | 15 | 15 | 0/15 (0.0%) |
| later-pass-on | ask | 5 | 5 | 0/5 (0.0%) |
| later-pass-on | invest | 5 | 5 | 5/5 (100.0%) |
| later-pass-on | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | lead | 6 | 6 | 6/7 (85.7%) |
| later-path-map | rest | 7 | 7 | 0/7 (0.0%) |
| later-path-map | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-path-map | shortWalk | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | ask | 4 | 4 | 0/4 (0.0%) |
| later-reconnect | invest | 4 | 4 | 4/4 (100.0%) |
| later-reconnect | rest | 4 | 4 | 0/4 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 7/7 (100.0%) |
| later-shared-recipes | lead | 6 | 6 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | lead | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | learnAgain | 9 | 9 | 9/9 (100.0%) |
| later-tool-stories | rest | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | seekGuide | 9 | 9 | 0/9 (0.0%) |
| later-voice-booth | ask | 6 | 6 | 0/6 (0.0%) |
| later-voice-booth | invest | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | rest | 6 | 6 | 0/6 (0.0%) |
| middle-friend-letter | rest | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | seekGuide | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | write | 15 | 15 | 15/15 (100.0%) |
| middle-garden-table | ask | 6 | 6 | 0/6 (0.0%) |
| middle-garden-table | invest | 6 | 6 | 6/6 (100.0%) |
| middle-garden-table | rest | 6 | 6 | 0/6 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | boundaries | 11 | 11 | 0/11 (0.0%) |
| middle-rest-circle | rest | 11 | 11 | 11/11 (100.0%) |
| middle-rest-circle | walk | 11 | 11 | 0/11 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | invest | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 3 | 3 | 3/9 (33.3%) |
| middle-seed-exchange | onePot | 9 | 9 | 6/9 (66.7%) |
| middle-seed-exchange | rest | 9 | 9 | 0/9 (0.0%) |
| middle-seed-exchange | seekGuide | 9 | 9 | 0/9 (0.0%) |
| middle-skill-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | study | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | teach | 10 | 10 | 0/10 (0.0%) |
| middle-support | ask | 12 | 12 | 0/12 (0.0%) |
| middle-support | invest | 12 | 12 | 12/12 (100.0%) |
| middle-support | rest | 12 | 12 | 0/12 (0.0%) |
| middle-support | shareShift | 12 | 12 | 0/12 (0.0%) |
| middle-turn | ask | 7 | 7 | 0/7 (0.0%) |
| middle-turn | invest | 7 | 7 | 7/7 (100.0%) |
| middle-turn | offline | 7 | 7 | 0/7 (0.0%) |
| middle-turn | rest | 7 | 7 | 0/7 (0.0%) |
| teen-direction | ask | 8 | 8 | 0/8 (0.0%) |
| teen-direction | invest | 8 | 8 | 8/8 (100.0%) |
| teen-direction | leadWorkshop | 8 | 8 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 0/8 (0.0%) |
| teen-launch | ask | 5 | 5 | 0/5 (0.0%) |
| teen-launch | invest | 5 | 5 | 5/5 (100.0%) |
| teen-launch | rest | 5 | 5 | 0/5 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 17 | 17 | 0/17 (0.0%) |
| teen-repair-table | invest | 17 | 17 | 17/17 (100.0%) |
| teen-repair-table | rest | 17 | 17 | 0/17 (0.0%) |
| teen-river-survey | join | 11 | 11 | 11/11 (100.0%) |
| teen-river-survey | lead | 6 | 6 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | seekGuide | 11 | 11 | 0/11 (0.0%) |
| teen-shared-kitchen | ask | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | invest | 10 | 10 | 10/10 (100.0%) |
| teen-shared-kitchen | rest | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | agreement | 8 | 8 | 8/8 (100.0%) |
| teen-shared-room | privateRoom | 8 | 8 | 0/8 (0.0%) |
| teen-shared-room | rest | 8 | 8 | 0/8 (0.0%) |
| teen-tool-library | practice | 6 | 6 | 6/6 (100.0%) |
| teen-tool-library | rest | 6 | 6 | 0/6 (0.0%) |
| teen-tool-library | seekGuide | 6 | 6 | 0/6 (0.0%) |

相鄰相同行動類型：218/448 (48.7%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/31 (0.0%) | 0/31 (0.0%) | 0/42 (0.0%) |
| 財務安全 | 0/48 (0.0%) | 0/48 (0.0%) | 0/94 (0.0%) |
| 人際關係 | 0/455 (0.0%) | 0/455 (0.0%) | 0/967 (0.0%) |
| 技能 | 0/343 (0.0%) | 0/343 (0.0%) | 0/1216 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/42 (0.0%) | 0/42 (0.0%) | 0/42 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 4/32 (12.5%) | 4/32 (12.5%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) |
| story.repair | 32/32 (100.0%) | 19/32 (59.4%) | 18/32 (56.2%) |
| story.kitchen | 24/32 (75.0%) | 16/32 (50.0%) | 9/32 (28.1%) |
| story.garden | 12/32 (37.5%) | 9/32 (28.1%) | 3/32 (9.4%) |
| story.nature | 24/32 (75.0%) | 21/32 (65.6%) | 14/32 (43.8%) |

## ind-1／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 17/96 (17.7%) | 17/55 (30.9%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 6/96 (6.2%) | 6/91 (6.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 108/128 (84.4%) | 11/128 (8.6%) | 11/108 (10.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 20} |
| teen-tool-library | 17–32 | 109/128 (85.2%) | 9/128 (7.0%) | 9/109 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 19} |
| teen-launch | 21–25 | 57/64 (89.1%) | 9/64 (14.1%) | 9/57 (15.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 7} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 44/128 (34.4%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 44} |
| teen-shared-kitchen | 17–32 | 101/128 (78.9%) | 13/128 (10.2%) | 13/101 (12.9%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 27} |
| teen-shared-room | 21–32 | 80/96 (83.3%) | 10/96 (10.4%) | 10/80 (12.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 16} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 123/192 (64.1%) | 12/192 (6.2%) | 12/123 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 46} |
| adult-meal-circle | 25–59 | 136/192 (70.8%) | 13/192 (6.8%) | 13/136 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 29} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 93/128 (72.7%) | 5/128 (3.9%) | 5/93 (5.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 4} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 138/192 (71.9%) | 12/192 (6.2%) | 12/138 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 23} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 9/128 (7.0%) | 9/116 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 21/160 (13.1%) | 4/160 (2.5%) | 4/21 (19.0%) | shared-care-contacts: 130/160 (81.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 130, &#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 9} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 5 | 5 | 5/5 (100.0%) |
| adult-balance | invest | 5 | 5 | 0/5 (0.0%) |
| adult-balance | rest | 5 | 5 | 0/5 (0.0%) |
| adult-broken-bicycle | borrow | 15 | 15 | 15/15 (100.0%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 0/15 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 6 | 6 | 6/6 (100.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 0/6 (0.0%) |
| adult-local-trail | lead | 0 | 0 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 13/13 (100.0%) |
| adult-meal-circle | trial | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | ask | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | invest | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 5/5 (100.0%) |
| child-library-map | invest | 5 | 5 | 0/5 (0.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | perform | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | rest | 10 | 10 | 10/10 (100.0%) |
| child-rain-notebook | observe | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | rest | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | seekGuide | 13 | 13 | 13/13 (100.0%) |
| child-transition | ask | 7 | 7 | 7/7 (100.0%) |
| child-transition | invest | 7 | 7 | 0/7 (0.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | invest | 17 | 17 | 0/17 (0.0%) |
| child-wind-team | rest | 17 | 17 | 0/17 (0.0%) |
| later-pass-on | ask | 6 | 6 | 6/6 (100.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 0/6 (0.0%) |
| later-path-map | lead | 0 | 0 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | seekGuide | 5 | 5 | 5/5 (100.0%) |
| later-path-map | shortWalk | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | ask | 9 | 9 | 9/9 (100.0%) |
| later-reconnect | invest | 9 | 9 | 0/9 (0.0%) |
| later-reconnect | rest | 9 | 9 | 0/9 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | ask | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | invest | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 8/8 (100.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 0/8 (0.0%) |
| middle-open-desk | ask | 4 | 4 | 4/4 (100.0%) |
| middle-open-desk | invest | 4 | 4 | 0/4 (0.0%) |
| middle-open-desk | rest | 4 | 4 | 0/4 (0.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 14/14 (100.0%) |
| middle-rest-circle | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | walk | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | invest | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 9 | 9 | 9/9 (100.0%) |
| middle-support | invest | 9 | 9 | 0/9 (0.0%) |
| middle-support | rest | 9 | 9 | 0/9 (0.0%) |
| middle-support | shareShift | 2 | 2 | 0/9 (0.0%) |
| middle-turn | ask | 9 | 9 | 9/9 (100.0%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 0/9 (0.0%) |
| middle-turn | rest | 9 | 9 | 0/9 (0.0%) |
| teen-direction | ask | 6 | 6 | 6/6 (100.0%) |
| teen-direction | invest | 6 | 6 | 0/6 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/6 (0.0%) |
| teen-direction | offline | 6 | 6 | 0/6 (0.0%) |
| teen-direction | rest | 6 | 6 | 0/6 (0.0%) |
| teen-launch | ask | 9 | 9 | 9/9 (100.0%) |
| teen-launch | invest | 9 | 9 | 0/9 (0.0%) |
| teen-launch | rest | 9 | 9 | 0/9 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | seekGuide | 11 | 11 | 11/11 (100.0%) |
| teen-shared-kitchen | ask | 13 | 13 | 13/13 (100.0%) |
| teen-shared-kitchen | invest | 13 | 13 | 0/13 (0.0%) |
| teen-shared-kitchen | rest | 13 | 13 | 0/13 (0.0%) |
| teen-shared-room | agreement | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | privateRoom | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | practice | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | rest | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | seekGuide | 9 | 9 | 9/9 (100.0%) |

相鄰相同行動類型：370/448 (82.6%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/56 (0.0%) | 0/56 (0.0%) | 0/112 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/438 (0.0%) | 0/438 (0.0%) | 0/732 (0.0%) |
| 技能 | 0/409 (0.0%) | 0/409 (0.0%) | 0/409 (0.0%) |

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
| story.childhood-connection | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.learning-route | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.care-network | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.repair | 25/32 (78.1%) | 15/32 (46.9%) | 9/32 (28.1%) |
| story.kitchen | 22/32 (68.8%) | 16/32 (50.0%) | 7/32 (21.9%) |
| story.garden | 15/32 (46.9%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 24/32 (75.0%) | 22/32 (68.8%) | 13/32 (40.6%) |

## ind-1／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 59/96 (61.5%) | 12/96 (12.5%) | 12/59 (20.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 15/96 (15.6%) | 15/57 (26.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | windmill-promise: 96/96 (100.0%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 96, &#x27;milestone-slot&#x27;: 32} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 6/96 (6.2%) | 6/91 (6.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 109/128 (85.2%) | 10/128 (7.8%) | 10/109 (9.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 19} |
| teen-tool-library | 17–32 | 106/128 (82.8%) | 10/128 (7.8%) | 10/106 (9.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-launch | 21–25 | 56/64 (87.5%) | 10/64 (15.6%) | 10/56 (17.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 8} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 128/128 (100.0%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 128} |
| teen-shared-kitchen | 17–32 | 92/128 (71.9%) | 16/128 (12.5%) | 16/92 (17.4%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 14, &#x27;one-shot&#x27;: 36} |
| teen-shared-room | 21–32 | 78/96 (81.2%) | 11/96 (11.5%) | 11/78 (14.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 130/192 (67.7%) | 10/192 (5.2%) | 10/130 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 37} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 100/160 (62.5%) | 10/160 (6.2%) | 10/100 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 15, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 7/128 (5.5%) | 7/92 (7.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 100/160 (62.5%) | 5/160 (3.1%) | 5/100 (5.0%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 15} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 140/160 (87.5%) | 13/160 (8.1%) | 13/140 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 20} |
| middle-skill-exchange | 32–65 | 137/192 (71.4%) | 12/192 (6.2%) | 12/137 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| middle-turn | 45–59 | 83/96 (86.5%) | 10/96 (10.4%) | 10/83 (12.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 13} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 15/160 (9.4%) | 15/140 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 118/128 (92.2%) | 10/128 (7.8%) | 10/118 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 10} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 0/160 (0.0%) | 0/160 (0.0%) | — (0/0) | shared-care-contacts: 160/160 (100.0%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 160} |
| middle-rhythm | 59–72 | 82/96 (85.4%) | 13/96 (13.5%) | 13/82 (15.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 14} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 6/96 (6.2%) | 6/87 (6.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 10/96 (10.4%) | 10/87 (11.5%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 93/96 (96.9%) | 3/96 (3.1%) | 3/93 (3.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 3} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 3/32 (9.4%) | 3/32 (9.4%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 7 | 7 | 0/7 (0.0%) |
| adult-balance | invest | 7 | 7 | 0/7 (0.0%) |
| adult-balance | rest | 7 | 7 | 7/7 (100.0%) |
| adult-broken-bicycle | borrow | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 15/15 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 6/6 (100.0%) |
| adult-local-trail | lead | 0 | 0 | 0/10 (0.0%) |
| adult-local-trail | record | 10 | 10 | 0/10 (0.0%) |
| adult-local-trail | rest | 10 | 10 | 10/10 (100.0%) |
| adult-local-trail | seekGuide | 10 | 10 | 0/10 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 13/13 (100.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | trial | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | ask | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | invest | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | rest | 5 | 5 | 5/5 (100.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 12/12 (100.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 12 | 12 | 0/12 (0.0%) |
| child-library-map | invest | 12 | 12 | 0/12 (0.0%) |
| child-library-map | rest | 12 | 12 | 12/12 (100.0%) |
| child-quiet-stage | backstage | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | perform | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | rest | 12 | 12 | 12/12 (100.0%) |
| child-rain-notebook | observe | 15 | 15 | 0/15 (0.0%) |
| child-rain-notebook | rest | 15 | 15 | 15/15 (100.0%) |
| child-rain-notebook | seekGuide | 15 | 15 | 0/15 (0.0%) |
| child-transition | ask | 8 | 8 | 0/8 (0.0%) |
| child-transition | invest | 8 | 8 | 0/8 (0.0%) |
| child-transition | rest | 8 | 8 | 8/8 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 6/6 (100.0%) |
| later-path-map | lead | 0 | 0 | 0/3 (0.0%) |
| later-path-map | rest | 3 | 3 | 3/3 (100.0%) |
| later-path-map | seekGuide | 3 | 3 | 0/3 (0.0%) |
| later-path-map | shortWalk | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | ask | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | invest | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | rest | 3 | 3 | 3/3 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-shared-recipes | cookOnce | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/6 (0.0%) |
| later-shared-recipes | rest | 6 | 6 | 6/6 (100.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 6/6 (100.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-voice-booth | ask | 10 | 10 | 0/10 (0.0%) |
| later-voice-booth | invest | 10 | 10 | 0/10 (0.0%) |
| later-voice-booth | rest | 10 | 10 | 10/10 (100.0%) |
| middle-friend-letter | rest | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 8/8 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rest-circle | boundaries | 15 | 15 | 0/15 (0.0%) |
| middle-rest-circle | rest | 15 | 15 | 15/15 (100.0%) |
| middle-rest-circle | walk | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | ask | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | invest | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/13 (0.0%) |
| middle-seed-exchange | onePot | 13 | 13 | 0/13 (0.0%) |
| middle-seed-exchange | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | seekGuide | 13 | 13 | 0/13 (0.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 10 | 10 | 0/10 (0.0%) |
| middle-support | invest | 10 | 10 | 0/10 (0.0%) |
| middle-support | rest | 10 | 10 | 10/10 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/10 (0.0%) |
| middle-turn | ask | 10 | 10 | 0/10 (0.0%) |
| middle-turn | invest | 10 | 10 | 0/10 (0.0%) |
| middle-turn | offline | 10 | 10 | 0/10 (0.0%) |
| middle-turn | rest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | ask | 6 | 6 | 0/6 (0.0%) |
| teen-direction | invest | 6 | 6 | 0/6 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/6 (0.0%) |
| teen-direction | offline | 6 | 6 | 0/6 (0.0%) |
| teen-direction | rest | 6 | 6 | 6/6 (100.0%) |
| teen-launch | ask | 10 | 10 | 0/10 (0.0%) |
| teen-launch | invest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | rest | 10 | 10 | 10/10 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 10 | 10 | 0/10 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/10 (0.0%) |
| teen-river-survey | rest | 10 | 10 | 10/10 (100.0%) |
| teen-river-survey | seekGuide | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | ask | 16 | 16 | 0/16 (0.0%) |
| teen-shared-kitchen | invest | 16 | 16 | 0/16 (0.0%) |
| teen-shared-kitchen | rest | 16 | 16 | 16/16 (100.0%) |
| teen-shared-room | agreement | 11 | 11 | 0/11 (0.0%) |
| teen-shared-room | privateRoom | 11 | 11 | 0/11 (0.0%) |
| teen-shared-room | rest | 11 | 11 | 11/11 (100.0%) |
| teen-tool-library | practice | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | seekGuide | 10 | 10 | 0/10 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/290 (0.0%) | 0/290 (0.0%) | 0/290 (0.0%) |
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
| story.childhood-connection | 32/32 (100.0%) | 3/32 (9.4%) | 3/32 (9.4%) |
| story.learning-route | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.care-network | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.repair | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.kitchen | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.garden | 0/32 (0.0%) | 13/32 (40.6%) | 0/32 (0.0%) |
| story.nature | 0/32 (0.0%) | 18/32 (56.2%) | 0/32 (0.0%) |

## ind-1／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 33/96 (34.4%) | 14/96 (14.6%) | 14/33 (42.4%) | windmill-promise: 34/96 (35.4%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 34, &#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 16} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 90/96 (93.8%) | 7/96 (7.3%) | 7/90 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| teen-river-survey | 17–32 | 105/128 (82.0%) | 11/128 (8.6%) | 11/105 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 23} |
| teen-tool-library | 17–32 | 113/128 (88.3%) | 7/128 (5.5%) | 7/113 (6.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 15} |
| teen-launch | 21–25 | 58/64 (90.6%) | 7/64 (10.9%) | 7/58 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-repair-table | 17–32 | 52/128 (40.6%) | 6/128 (4.7%) | 6/52 (11.5%) | made-a-project: 64/128 (50.0%); repair-practice: 20/128 (15.6%); 規則排除：{&#x27;condition:made-a-project&#x27;: 64, &#x27;condition:repair-practice&#x27;: 20, &#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 12} |
| teen-shared-kitchen | 17–32 | 102/128 (79.7%) | 12/128 (9.4%) | 12/102 (11.8%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 26} |
| teen-shared-room | 21–32 | 82/96 (85.4%) | 9/96 (9.4%) | 9/82 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 14} |
| adult-learning | 25–45 | 91/128 (71.1%) | 5/128 (3.9%) | 5/91 (5.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| adult-local-trail | 25–59 | 127/192 (66.1%) | 11/192 (5.7%) | 11/127 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 41} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 6/128 (4.7%) | 6/92 (6.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 129/192 (67.2%) | 18/192 (9.4%) | 18/129 (14.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 11/192 (5.7%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 11/128 (8.6%) | 11/116 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 137/192 (71.4%) | 9/192 (4.7%) | 9/137 (6.6%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 25} |
| middle-open-desk | 45–72 | 44/160 (27.5%) | 4/160 (2.5%) | 4/44 (9.1%) | shared-care-contacts: 106/160 (66.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 106, &#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 10} |
| middle-rhythm | 59–72 | 84/96 (87.5%) | 11/96 (11.5%) | 11/84 (13.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 7} |
| later-tool-stories | 59–72 | 86/96 (89.6%) | 7/96 (7.3%) | 7/86 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 10} |
| later-voice-booth | 59–72 | 89/96 (92.7%) | 7/96 (7.3%) | 7/89 (7.9%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 7} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 6 | 6 | 0/6 (0.0%) |
| adult-balance | invest | 6 | 6 | 4/6 (66.7%) |
| adult-balance | rest | 6 | 6 | 2/6 (33.3%) |
| adult-broken-bicycle | borrow | 15 | 15 | 7/15 (46.7%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 3/15 (20.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 5/15 (33.3%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 5 | 5 | 0/5 (0.0%) |
| adult-learning | invest | 5 | 5 | 2/5 (40.0%) |
| adult-learning | offline | 5 | 5 | 1/5 (20.0%) |
| adult-learning | rest | 5 | 5 | 2/5 (40.0%) |
| adult-local-trail | lead | 1 | 1 | 0/11 (0.0%) |
| adult-local-trail | record | 11 | 11 | 6/11 (54.5%) |
| adult-local-trail | rest | 11 | 11 | 3/11 (27.3%) |
| adult-local-trail | seekGuide | 11 | 11 | 2/11 (18.2%) |
| adult-meal-circle | lead | 2 | 2 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 3/13 (23.1%) |
| adult-meal-circle | seekGuide | 13 | 13 | 6/13 (46.2%) |
| adult-meal-circle | trial | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | ask | 4 | 4 | 1/4 (25.0%) |
| adult-neighbor-market | invest | 4 | 4 | 2/4 (50.0%) |
| adult-neighbor-market | rest | 4 | 4 | 1/4 (25.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 2/12 (16.7%) |
| adult-repair-coop | lead | 2 | 2 | 1/12 (8.3%) |
| adult-repair-coop | rest | 12 | 12 | 4/12 (33.3%) |
| adult-repair-coop | seekGuide | 12 | 12 | 5/12 (41.7%) |
| adult-shift-offer | extraShift | 10 | 10 | 5/10 (50.0%) |
| adult-shift-offer | predictable | 10 | 10 | 3/10 (30.0%) |
| adult-shift-offer | rest | 10 | 10 | 2/10 (20.0%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 6 | 6 | 1/6 (16.7%) |
| child-library-map | invest | 6 | 6 | 2/6 (33.3%) |
| child-library-map | rest | 6 | 6 | 3/6 (50.0%) |
| child-quiet-stage | backstage | 10 | 10 | 3/10 (30.0%) |
| child-quiet-stage | perform | 10 | 10 | 5/10 (50.0%) |
| child-quiet-stage | rest | 10 | 10 | 2/10 (20.0%) |
| child-rain-notebook | observe | 13 | 13 | 2/13 (15.4%) |
| child-rain-notebook | rest | 13 | 13 | 5/13 (38.5%) |
| child-rain-notebook | seekGuide | 13 | 13 | 6/13 (46.2%) |
| child-transition | ask | 7 | 7 | 2/7 (28.6%) |
| child-transition | invest | 7 | 7 | 5/7 (71.4%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 14 | 14 | 5/14 (35.7%) |
| child-wind-team | invest | 14 | 14 | 0/14 (0.0%) |
| child-wind-team | rest | 14 | 14 | 9/14 (64.3%) |
| later-pass-on | ask | 6 | 6 | 1/6 (16.7%) |
| later-pass-on | invest | 6 | 6 | 3/6 (50.0%) |
| later-pass-on | rest | 6 | 6 | 2/6 (33.3%) |
| later-path-map | lead | 2 | 2 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 4/5 (80.0%) |
| later-path-map | seekGuide | 5 | 5 | 0/5 (0.0%) |
| later-path-map | shortWalk | 5 | 5 | 1/5 (20.0%) |
| later-reconnect | ask | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | invest | 7 | 7 | 3/7 (42.9%) |
| later-reconnect | rest | 7 | 7 | 3/7 (42.9%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-shared-recipes | cookOnce | 6 | 6 | 2/6 (33.3%) |
| later-shared-recipes | lead | 2 | 2 | 1/6 (16.7%) |
| later-shared-recipes | rest | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 3/6 (50.0%) |
| later-tool-stories | lead | 4 | 4 | 4/7 (57.1%) |
| later-tool-stories | learnAgain | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | rest | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | seekGuide | 7 | 7 | 1/7 (14.3%) |
| later-voice-booth | ask | 7 | 7 | 2/7 (28.6%) |
| later-voice-booth | invest | 7 | 7 | 3/7 (42.9%) |
| later-voice-booth | rest | 7 | 7 | 2/7 (28.6%) |
| middle-friend-letter | rest | 18 | 18 | 5/18 (27.8%) |
| middle-friend-letter | seekGuide | 18 | 18 | 7/18 (38.9%) |
| middle-friend-letter | write | 18 | 18 | 6/18 (33.3%) |
| middle-garden-table | ask | 9 | 9 | 2/9 (22.2%) |
| middle-garden-table | invest | 9 | 9 | 4/9 (44.4%) |
| middle-garden-table | rest | 9 | 9 | 3/9 (33.3%) |
| middle-open-desk | ask | 4 | 4 | 2/4 (50.0%) |
| middle-open-desk | invest | 4 | 4 | 1/4 (25.0%) |
| middle-open-desk | rest | 4 | 4 | 1/4 (25.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 2/14 (14.3%) |
| middle-rest-circle | rest | 14 | 14 | 6/14 (42.9%) |
| middle-rest-circle | walk | 14 | 14 | 6/14 (42.9%) |
| middle-rhythm | ask | 11 | 11 | 1/11 (9.1%) |
| middle-rhythm | invest | 11 | 11 | 3/11 (27.3%) |
| middle-rhythm | rest | 11 | 11 | 7/11 (63.6%) |
| middle-seed-exchange | lead | 2 | 2 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 5/10 (50.0%) |
| middle-seed-exchange | rest | 10 | 10 | 1/10 (10.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 4/10 (40.0%) |
| middle-skill-exchange | rest | 11 | 11 | 4/11 (36.4%) |
| middle-skill-exchange | study | 11 | 11 | 1/11 (9.1%) |
| middle-skill-exchange | teach | 11 | 11 | 6/11 (54.5%) |
| middle-support | ask | 11 | 11 | 3/11 (27.3%) |
| middle-support | invest | 11 | 11 | 5/11 (45.5%) |
| middle-support | rest | 11 | 11 | 2/11 (18.2%) |
| middle-support | shareShift | 5 | 5 | 1/11 (9.1%) |
| middle-turn | ask | 9 | 9 | 3/9 (33.3%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 4/9 (44.4%) |
| middle-turn | rest | 9 | 9 | 2/9 (22.2%) |
| teen-direction | ask | 7 | 7 | 1/7 (14.3%) |
| teen-direction | invest | 7 | 7 | 1/7 (14.3%) |
| teen-direction | leadWorkshop | 2 | 2 | 1/7 (14.3%) |
| teen-direction | offline | 7 | 7 | 1/7 (14.3%) |
| teen-direction | rest | 7 | 7 | 3/7 (42.9%) |
| teen-launch | ask | 7 | 7 | 2/7 (28.6%) |
| teen-launch | invest | 7 | 7 | 2/7 (28.6%) |
| teen-launch | rest | 7 | 7 | 3/7 (42.9%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 6 | 6 | 0/6 (0.0%) |
| teen-repair-table | invest | 6 | 6 | 3/6 (50.0%) |
| teen-repair-table | rest | 6 | 6 | 3/6 (50.0%) |
| teen-river-survey | join | 11 | 11 | 2/11 (18.2%) |
| teen-river-survey | lead | 1 | 1 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 2/11 (18.2%) |
| teen-river-survey | seekGuide | 11 | 11 | 7/11 (63.6%) |
| teen-shared-kitchen | ask | 12 | 12 | 3/12 (25.0%) |
| teen-shared-kitchen | invest | 12 | 12 | 6/12 (50.0%) |
| teen-shared-kitchen | rest | 12 | 12 | 3/12 (25.0%) |
| teen-shared-room | agreement | 9 | 9 | 3/9 (33.3%) |
| teen-shared-room | privateRoom | 9 | 9 | 4/9 (44.4%) |
| teen-shared-room | rest | 9 | 9 | 2/9 (22.2%) |
| teen-tool-library | practice | 7 | 7 | 1/7 (14.3%) |
| teen-tool-library | rest | 7 | 7 | 4/7 (57.1%) |
| teen-tool-library | seekGuide | 7 | 7 | 2/7 (28.6%) |

相鄰相同行動類型：113/448 (25.2%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/186 (0.0%) | 0/186 (0.0%) | 0/366 (0.0%) |
| 財務安全 | 0/25 (0.0%) | 0/25 (0.0%) | 0/56 (0.0%) |
| 人際關係 | 0/406 (0.0%) | 0/406 (0.0%) | 0/666 (0.0%) |
| 技能 | 0/242 (0.0%) | 0/242 (0.0%) | 0/551 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/9 (0.0%) | 0/9 (0.0%) | 0/9 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) |
| story.learning-route | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) |
| story.care-network | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |
| story.repair | 22/32 (68.8%) | 15/32 (46.9%) | 6/32 (18.8%) |
| story.kitchen | 20/32 (62.5%) | 16/32 (50.0%) | 8/32 (25.0%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 19/32 (59.4%) | 21/32 (65.6%) | 10/32 (31.2%) |

## ind-2／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 11/96 (11.5%) | 11/60 (18.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 14/96 (14.6%) | 14/57 (24.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 16/96 (16.7%) | 16/55 (29.1%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 90/96 (93.8%) | 10/96 (10.4%) | 10/90 (11.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-river-survey | 17–32 | 110/128 (85.9%) | 13/128 (10.2%) | 13/110 (11.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| teen-tool-library | 17–32 | 114/128 (89.1%) | 6/128 (4.7%) | 6/114 (5.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 14} |
| teen-launch | 21–25 | 60/64 (93.8%) | 5/64 (7.8%) | 5/60 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 4} |
| teen-repair-table | 17–32 | 91/128 (71.1%) | 18/128 (14.1%) | 18/91 (19.8%) | made-a-project: 0/128 (0.0%); repair-practice: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 16, &#x27;one-shot&#x27;: 37} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 80/96 (83.3%) | 10/96 (10.4%) | 10/80 (12.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 16} |
| adult-learning | 25–45 | 91/128 (71.1%) | 4/128 (3.1%) | 4/91 (4.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| adult-local-trail | 25–59 | 122/192 (63.5%) | 12/192 (6.2%) | 12/122 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 47} |
| adult-meal-circle | 25–59 | 139/192 (72.4%) | 12/192 (6.2%) | 12/139 (8.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 26} |
| adult-repair-coop | 25–59 | 127/192 (66.1%) | 14/192 (7.3%) | 14/127 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 40} |
| adult-shift-offer | 25–52 | 106/160 (66.2%) | 9/160 (5.6%) | 9/106 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| adult-balance | 32–52 | 95/128 (74.2%) | 4/128 (3.1%) | 4/95 (4.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 1, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 1} |
| adult-broken-bicycle | 25–59 | 131/192 (68.2%) | 13/192 (6.8%) | 13/131 (9.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 35} |
| adult-neighbor-market | 25–52 | 106/160 (66.2%) | 4/160 (2.5%) | 4/106 (3.8%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 20, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 136/192 (70.8%) | 15/192 (7.8%) | 15/136 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 28} |
| middle-seed-exchange | 45–72 | 147/160 (91.9%) | 10/160 (6.2%) | 10/147 (6.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 13} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 10/192 (5.2%) | 10/140 (7.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-rest-circle | 45–72 | 143/160 (89.4%) | 11/160 (6.9%) | 11/143 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 17} |
| middle-support | 52–72 | 116/128 (90.6%) | 12/128 (9.4%) | 12/116 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 144/192 (75.0%) | 6/192 (3.1%) | 6/144 (4.2%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 17} |
| middle-open-desk | 45–72 | 126/160 (78.8%) | 13/160 (8.1%) | 13/126 (10.3%) | shared-care-contacts: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 34} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 5/64 (7.8%) | 5/62 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 7} |
| later-tool-stories | 59–72 | 86/96 (89.6%) | 9/96 (9.4%) | 9/86 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 10} |
| later-voice-booth | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-path-map | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 4 | 4 | 0/4 (0.0%) |
| adult-balance | invest | 4 | 4 | 4/4 (100.0%) |
| adult-balance | rest | 4 | 4 | 0/4 (0.0%) |
| adult-broken-bicycle | borrow | 13 | 13 | 0/13 (0.0%) |
| adult-broken-bicycle | repairTogether | 13 | 13 | 13/13 (100.0%) |
| adult-broken-bicycle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 4 | 4 | 0/4 (0.0%) |
| adult-learning | invest | 4 | 4 | 4/4 (100.0%) |
| adult-learning | offline | 4 | 4 | 0/4 (0.0%) |
| adult-learning | rest | 4 | 4 | 0/4 (0.0%) |
| adult-local-trail | lead | 8 | 8 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 12/12 (100.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/12 (0.0%) |
| adult-meal-circle | rest | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | trial | 12 | 12 | 12/12 (100.0%) |
| adult-neighbor-market | ask | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | invest | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 14 | 14 | 14/14 (100.0%) |
| adult-repair-coop | lead | 12 | 12 | 0/14 (0.0%) |
| adult-repair-coop | rest | 14 | 14 | 0/14 (0.0%) |
| adult-repair-coop | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-shift-offer | extraShift | 9 | 9 | 9/9 (100.0%) |
| adult-shift-offer | predictable | 9 | 9 | 0/9 (0.0%) |
| adult-shift-offer | rest | 9 | 9 | 0/9 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 0/5 (0.0%) |
| child-library-map | invest | 5 | 5 | 5/5 (100.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 11 | 11 | 11/11 (100.0%) |
| child-quiet-stage | perform | 11 | 11 | 0/11 (0.0%) |
| child-quiet-stage | rest | 11 | 11 | 0/11 (0.0%) |
| child-rain-notebook | observe | 14 | 14 | 14/14 (100.0%) |
| child-rain-notebook | rest | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | seekGuide | 14 | 14 | 0/14 (0.0%) |
| child-transition | ask | 7 | 7 | 0/7 (0.0%) |
| child-transition | invest | 7 | 7 | 7/7 (100.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 16 | 16 | 0/16 (0.0%) |
| child-wind-team | invest | 16 | 16 | 16/16 (100.0%) |
| child-wind-team | rest | 16 | 16 | 0/16 (0.0%) |
| later-pass-on | ask | 5 | 5 | 0/5 (0.0%) |
| later-pass-on | invest | 5 | 5 | 5/5 (100.0%) |
| later-pass-on | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | lead | 6 | 6 | 6/7 (85.7%) |
| later-path-map | rest | 7 | 7 | 0/7 (0.0%) |
| later-path-map | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-path-map | shortWalk | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | ask | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | invest | 5 | 5 | 5/5 (100.0%) |
| later-reconnect | rest | 5 | 5 | 0/5 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 6 | 6 | 6/6 (100.0%) |
| later-shared-recipes | lead | 3 | 3 | 0/6 (0.0%) |
| later-shared-recipes | rest | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | lead | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | learnAgain | 9 | 9 | 9/9 (100.0%) |
| later-tool-stories | rest | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | seekGuide | 9 | 9 | 0/9 (0.0%) |
| later-voice-booth | ask | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | invest | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | seekGuide | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | write | 15 | 15 | 15/15 (100.0%) |
| middle-garden-table | ask | 6 | 6 | 0/6 (0.0%) |
| middle-garden-table | invest | 6 | 6 | 6/6 (100.0%) |
| middle-garden-table | rest | 6 | 6 | 0/6 (0.0%) |
| middle-open-desk | ask | 13 | 13 | 0/13 (0.0%) |
| middle-open-desk | invest | 13 | 13 | 13/13 (100.0%) |
| middle-open-desk | rest | 13 | 13 | 0/13 (0.0%) |
| middle-rest-circle | boundaries | 11 | 11 | 0/11 (0.0%) |
| middle-rest-circle | rest | 11 | 11 | 11/11 (100.0%) |
| middle-rest-circle | walk | 11 | 11 | 0/11 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | invest | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 3 | 3 | 3/10 (30.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 7/10 (70.0%) |
| middle-seed-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | study | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | teach | 10 | 10 | 0/10 (0.0%) |
| middle-support | ask | 12 | 12 | 0/12 (0.0%) |
| middle-support | invest | 12 | 12 | 12/12 (100.0%) |
| middle-support | rest | 12 | 12 | 0/12 (0.0%) |
| middle-support | shareShift | 12 | 12 | 0/12 (0.0%) |
| middle-turn | ask | 7 | 7 | 0/7 (0.0%) |
| middle-turn | invest | 7 | 7 | 7/7 (100.0%) |
| middle-turn | offline | 7 | 7 | 0/7 (0.0%) |
| middle-turn | rest | 7 | 7 | 0/7 (0.0%) |
| teen-direction | ask | 10 | 10 | 0/10 (0.0%) |
| teen-direction | invest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | leadWorkshop | 10 | 10 | 0/10 (0.0%) |
| teen-direction | offline | 10 | 10 | 0/10 (0.0%) |
| teen-direction | rest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | ask | 5 | 5 | 0/5 (0.0%) |
| teen-launch | invest | 5 | 5 | 5/5 (100.0%) |
| teen-launch | rest | 5 | 5 | 0/5 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 18 | 18 | 0/18 (0.0%) |
| teen-repair-table | invest | 18 | 18 | 18/18 (100.0%) |
| teen-repair-table | rest | 18 | 18 | 0/18 (0.0%) |
| teen-river-survey | join | 13 | 13 | 13/13 (100.0%) |
| teen-river-survey | lead | 7 | 7 | 0/13 (0.0%) |
| teen-river-survey | rest | 13 | 13 | 0/13 (0.0%) |
| teen-river-survey | seekGuide | 13 | 13 | 0/13 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 10 | 10 | 10/10 (100.0%) |
| teen-shared-room | privateRoom | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | rest | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | practice | 6 | 6 | 6/6 (100.0%) |
| teen-tool-library | rest | 6 | 6 | 0/6 (0.0%) |
| teen-tool-library | seekGuide | 6 | 6 | 0/6 (0.0%) |

相鄰相同行動類型：225/448 (50.2%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/31 (0.0%) | 0/31 (0.0%) | 0/42 (0.0%) |
| 財務安全 | 0/39 (0.0%) | 0/39 (0.0%) | 0/82 (0.0%) |
| 人際關係 | 0/455 (0.0%) | 0/455 (0.0%) | 0/953 (0.0%) |
| 技能 | 0/352 (0.0%) | 0/352 (0.0%) | 0/1249 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/43 (0.0%) | 0/43 (0.0%) | 0/43 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) |
| story.learning-route | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.care-network | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) |
| story.repair | 32/32 (100.0%) | 19/32 (59.4%) | 18/32 (56.2%) |
| story.kitchen | 20/32 (62.5%) | 15/32 (46.9%) | 7/32 (21.9%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 3/32 (9.4%) |
| story.nature | 25/32 (78.1%) | 22/32 (68.8%) | 15/32 (46.9%) |

## ind-2／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 12/96 (12.5%) | 12/60 (20.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 14/96 (14.6%) | 14/57 (24.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 19/96 (19.8%) | 19/55 (34.5%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 8/96 (8.3%) | 8/89 (9.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 106/128 (82.8%) | 12/128 (9.4%) | 12/106 (11.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-tool-library | 17–32 | 109/128 (85.2%) | 9/128 (7.0%) | 9/109 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 19} |
| teen-launch | 21–25 | 57/64 (89.1%) | 9/64 (14.1%) | 9/57 (15.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 7} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 49/128 (38.3%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 49} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 74/96 (77.1%) | 14/96 (14.6%) | 14/74 (18.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;one-shot&#x27;: 22} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 120/192 (62.5%) | 12/192 (6.2%) | 12/120 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 50} |
| adult-meal-circle | 25–59 | 133/192 (69.3%) | 14/192 (7.3%) | 14/133 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 33} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 93/128 (72.7%) | 5/128 (3.9%) | 5/93 (5.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 4} |
| adult-broken-bicycle | 25–59 | 128/192 (66.7%) | 14/192 (7.3%) | 14/128 (10.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 39} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 140/160 (87.5%) | 11/160 (6.9%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 20} |
| middle-skill-exchange | 32–65 | 138/192 (71.9%) | 12/192 (6.2%) | 12/138 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 23} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 9/128 (7.0%) | 9/116 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 21/160 (13.1%) | 4/160 (2.5%) | 4/21 (19.0%) | shared-care-contacts: 130/160 (81.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 130, &#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 9} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 5 | 5 | 5/5 (100.0%) |
| adult-balance | invest | 5 | 5 | 0/5 (0.0%) |
| adult-balance | rest | 5 | 5 | 0/5 (0.0%) |
| adult-broken-bicycle | borrow | 14 | 14 | 14/14 (100.0%) |
| adult-broken-bicycle | repairTogether | 14 | 14 | 0/14 (0.0%) |
| adult-broken-bicycle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 6 | 6 | 6/6 (100.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 0/6 (0.0%) |
| adult-local-trail | lead | 0 | 0 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/14 (0.0%) |
| adult-meal-circle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-meal-circle | seekGuide | 14 | 14 | 14/14 (100.0%) |
| adult-meal-circle | trial | 14 | 14 | 0/14 (0.0%) |
| adult-neighbor-market | ask | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | invest | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 5/5 (100.0%) |
| child-library-map | invest | 5 | 5 | 0/5 (0.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | perform | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | rest | 12 | 12 | 12/12 (100.0%) |
| child-rain-notebook | observe | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | rest | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | seekGuide | 14 | 14 | 14/14 (100.0%) |
| child-transition | ask | 7 | 7 | 7/7 (100.0%) |
| child-transition | invest | 7 | 7 | 0/7 (0.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 19 | 19 | 19/19 (100.0%) |
| child-wind-team | invest | 19 | 19 | 0/19 (0.0%) |
| child-wind-team | rest | 19 | 19 | 0/19 (0.0%) |
| later-pass-on | ask | 6 | 6 | 6/6 (100.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 0/6 (0.0%) |
| later-path-map | lead | 0 | 0 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | seekGuide | 5 | 5 | 5/5 (100.0%) |
| later-path-map | shortWalk | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | ask | 9 | 9 | 9/9 (100.0%) |
| later-reconnect | invest | 9 | 9 | 0/9 (0.0%) |
| later-reconnect | rest | 9 | 9 | 0/9 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | ask | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | invest | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 8/8 (100.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 0/8 (0.0%) |
| middle-open-desk | ask | 4 | 4 | 4/4 (100.0%) |
| middle-open-desk | invest | 4 | 4 | 0/4 (0.0%) |
| middle-open-desk | rest | 4 | 4 | 0/4 (0.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 14/14 (100.0%) |
| middle-rest-circle | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | walk | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | invest | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/11 (0.0%) |
| middle-seed-exchange | onePot | 11 | 11 | 0/11 (0.0%) |
| middle-seed-exchange | rest | 11 | 11 | 0/11 (0.0%) |
| middle-seed-exchange | seekGuide | 11 | 11 | 11/11 (100.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 9 | 9 | 9/9 (100.0%) |
| middle-support | invest | 9 | 9 | 0/9 (0.0%) |
| middle-support | rest | 9 | 9 | 0/9 (0.0%) |
| middle-support | shareShift | 2 | 2 | 0/9 (0.0%) |
| middle-turn | ask | 9 | 9 | 9/9 (100.0%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 0/9 (0.0%) |
| middle-turn | rest | 9 | 9 | 0/9 (0.0%) |
| teen-direction | ask | 8 | 8 | 8/8 (100.0%) |
| teen-direction | invest | 8 | 8 | 0/8 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 0/8 (0.0%) |
| teen-launch | ask | 9 | 9 | 9/9 (100.0%) |
| teen-launch | invest | 9 | 9 | 0/9 (0.0%) |
| teen-launch | rest | 9 | 9 | 0/9 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | seekGuide | 12 | 12 | 12/12 (100.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 14 | 14 | 0/14 (0.0%) |
| teen-shared-room | privateRoom | 14 | 14 | 0/14 (0.0%) |
| teen-shared-room | rest | 14 | 14 | 14/14 (100.0%) |
| teen-tool-library | practice | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | rest | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | seekGuide | 9 | 9 | 9/9 (100.0%) |

相鄰相同行動類型：360/448 (80.4%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/62 (0.0%) | 0/62 (0.0%) | 0/124 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/432 (0.0%) | 0/432 (0.0%) | 0/717 (0.0%) |
| 技能 | 0/404 (0.0%) | 0/404 (0.0%) | 0/404 (0.0%) |

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
| story.childhood-connection | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.repair | 25/32 (78.1%) | 15/32 (46.9%) | 9/32 (28.1%) |
| story.kitchen | 14/32 (43.8%) | 17/32 (53.1%) | 4/32 (12.5%) |
| story.garden | 16/32 (50.0%) | 11/32 (34.4%) | 2/32 (6.2%) |
| story.nature | 25/32 (78.1%) | 23/32 (71.9%) | 14/32 (43.8%) |

## ind-2／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 59/96 (61.5%) | 17/96 (17.7%) | 17/59 (28.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 17/96 (17.7%) | 17/57 (29.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | windmill-promise: 96/96 (100.0%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 96, &#x27;milestone-slot&#x27;: 32} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 8/96 (8.3%) | 8/89 (9.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 104/128 (81.2%) | 12/128 (9.4%) | 12/104 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 24} |
| teen-tool-library | 17–32 | 106/128 (82.8%) | 10/128 (7.8%) | 10/106 (9.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-launch | 21–25 | 56/64 (87.5%) | 10/64 (15.6%) | 10/56 (17.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 8} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 128/128 (100.0%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 128} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 72/96 (75.0%) | 15/96 (15.6%) | 15/72 (20.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;one-shot&#x27;: 24} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 130/192 (67.7%) | 10/192 (5.2%) | 10/130 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 37} |
| adult-meal-circle | 25–59 | 132/192 (68.8%) | 14/192 (7.3%) | 14/132 (10.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 35} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 100/160 (62.5%) | 10/160 (6.2%) | 10/100 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 15, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 7/128 (5.5%) | 7/92 (7.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 16/192 (8.3%) | 16/124 (12.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 100/160 (62.5%) | 5/160 (3.1%) | 5/100 (5.0%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 15} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 138/160 (86.2%) | 14/160 (8.8%) | 14/138 (10.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 22} |
| middle-skill-exchange | 32–65 | 137/192 (71.4%) | 12/192 (6.2%) | 12/137 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| middle-turn | 45–59 | 83/96 (86.5%) | 10/96 (10.4%) | 10/83 (12.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 13} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 15/160 (9.4%) | 15/140 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 117/128 (91.4%) | 10/128 (7.8%) | 10/117 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 9/192 (4.7%) | 9/141 (6.4%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 0/160 (0.0%) | 0/160 (0.0%) | — (0/0) | shared-care-contacts: 160/160 (100.0%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 160} |
| middle-rhythm | 59–72 | 82/96 (85.4%) | 13/96 (13.5%) | 13/82 (15.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 14} |
| later-pass-on | 65–72 | 61/64 (95.3%) | 7/64 (10.9%) | 7/61 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 3} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 7/96 (7.3%) | 7/90 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | recording-companion: 0/96 (0.0%); sharing-connection: 96/96 (100.0%); 規則排除：{&#x27;condition:sharing-connection&#x27;: 96} |
| later-path-map | 59–72 | 91/96 (94.8%) | 4/96 (4.2%) | 4/91 (4.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 7 | 7 | 0/7 (0.0%) |
| adult-balance | invest | 7 | 7 | 0/7 (0.0%) |
| adult-balance | rest | 7 | 7 | 7/7 (100.0%) |
| adult-broken-bicycle | borrow | 16 | 16 | 0/16 (0.0%) |
| adult-broken-bicycle | repairTogether | 16 | 16 | 0/16 (0.0%) |
| adult-broken-bicycle | rest | 16 | 16 | 16/16 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 6/6 (100.0%) |
| adult-local-trail | lead | 0 | 0 | 0/10 (0.0%) |
| adult-local-trail | record | 10 | 10 | 0/10 (0.0%) |
| adult-local-trail | rest | 10 | 10 | 10/10 (100.0%) |
| adult-local-trail | seekGuide | 10 | 10 | 0/10 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/14 (0.0%) |
| adult-meal-circle | rest | 14 | 14 | 14/14 (100.0%) |
| adult-meal-circle | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-meal-circle | trial | 14 | 14 | 0/14 (0.0%) |
| adult-neighbor-market | ask | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | invest | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | rest | 5 | 5 | 5/5 (100.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 12/12 (100.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 12 | 12 | 0/12 (0.0%) |
| child-library-map | invest | 12 | 12 | 0/12 (0.0%) |
| child-library-map | rest | 12 | 12 | 12/12 (100.0%) |
| child-quiet-stage | backstage | 17 | 17 | 0/17 (0.0%) |
| child-quiet-stage | perform | 17 | 17 | 0/17 (0.0%) |
| child-quiet-stage | rest | 17 | 17 | 17/17 (100.0%) |
| child-rain-notebook | observe | 17 | 17 | 0/17 (0.0%) |
| child-rain-notebook | rest | 17 | 17 | 17/17 (100.0%) |
| child-rain-notebook | seekGuide | 17 | 17 | 0/17 (0.0%) |
| child-transition | ask | 8 | 8 | 0/8 (0.0%) |
| child-transition | invest | 8 | 8 | 0/8 (0.0%) |
| child-transition | rest | 8 | 8 | 8/8 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 7 | 7 | 0/7 (0.0%) |
| later-pass-on | invest | 7 | 7 | 0/7 (0.0%) |
| later-pass-on | rest | 7 | 7 | 7/7 (100.0%) |
| later-path-map | lead | 0 | 0 | 0/4 (0.0%) |
| later-path-map | rest | 4 | 4 | 4/4 (100.0%) |
| later-path-map | seekGuide | 4 | 4 | 0/4 (0.0%) |
| later-path-map | shortWalk | 4 | 4 | 0/4 (0.0%) |
| later-reconnect | ask | 6 | 6 | 0/6 (0.0%) |
| later-reconnect | invest | 6 | 6 | 0/6 (0.0%) |
| later-reconnect | rest | 6 | 6 | 6/6 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 7/7 (100.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | lead | 0 | 0 | 0/7 (0.0%) |
| later-tool-stories | learnAgain | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | rest | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | ask | 0 | 0 | — (0/0) |
| later-voice-booth | invest | 0 | 0 | — (0/0) |
| later-voice-booth | rest | 0 | 0 | — (0/0) |
| middle-friend-letter | rest | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 9 | 9 | 0/9 (0.0%) |
| middle-garden-table | invest | 9 | 9 | 0/9 (0.0%) |
| middle-garden-table | rest | 9 | 9 | 9/9 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rest-circle | boundaries | 15 | 15 | 0/15 (0.0%) |
| middle-rest-circle | rest | 15 | 15 | 15/15 (100.0%) |
| middle-rest-circle | walk | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | ask | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | invest | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/14 (0.0%) |
| middle-seed-exchange | onePot | 14 | 14 | 0/14 (0.0%) |
| middle-seed-exchange | rest | 14 | 14 | 14/14 (100.0%) |
| middle-seed-exchange | seekGuide | 14 | 14 | 0/14 (0.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 10 | 10 | 0/10 (0.0%) |
| middle-support | invest | 10 | 10 | 0/10 (0.0%) |
| middle-support | rest | 10 | 10 | 10/10 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/10 (0.0%) |
| middle-turn | ask | 10 | 10 | 0/10 (0.0%) |
| middle-turn | invest | 10 | 10 | 0/10 (0.0%) |
| middle-turn | offline | 10 | 10 | 0/10 (0.0%) |
| middle-turn | rest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | ask | 8 | 8 | 0/8 (0.0%) |
| teen-direction | invest | 8 | 8 | 0/8 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 8/8 (100.0%) |
| teen-launch | ask | 10 | 10 | 0/10 (0.0%) |
| teen-launch | invest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | rest | 10 | 10 | 10/10 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 12/12 (100.0%) |
| teen-river-survey | seekGuide | 12 | 12 | 0/12 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 15 | 15 | 0/15 (0.0%) |
| teen-shared-room | privateRoom | 15 | 15 | 0/15 (0.0%) |
| teen-shared-room | rest | 15 | 15 | 15/15 (100.0%) |
| teen-tool-library | practice | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | seekGuide | 10 | 10 | 0/10 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/271 (0.0%) | 0/271 (0.0%) | 0/271 (0.0%) |
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
| story.childhood-connection | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.repair | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.kitchen | 0/32 (0.0%) | 16/32 (50.0%) | 0/32 (0.0%) |
| story.garden | 0/32 (0.0%) | 14/32 (43.8%) | 0/32 (0.0%) |
| story.nature | 0/32 (0.0%) | 20/32 (62.5%) | 0/32 (0.0%) |

## ind-2／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 13/96 (13.5%) | 13/60 (21.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 15/96 (15.6%) | 15/57 (26.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 33/96 (34.4%) | 14/96 (14.6%) | 14/33 (42.4%) | windmill-promise: 34/96 (35.4%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 34, &#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 16} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 9/96 (9.4%) | 9/89 (10.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 104/128 (81.2%) | 12/128 (9.4%) | 12/104 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;one-shot&#x27;: 24} |
| teen-tool-library | 17–32 | 113/128 (88.3%) | 7/128 (5.5%) | 7/113 (6.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 15} |
| teen-launch | 21–25 | 58/64 (90.6%) | 7/64 (10.9%) | 7/58 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-repair-table | 17–32 | 49/128 (38.3%) | 7/128 (5.5%) | 7/49 (14.3%) | made-a-project: 64/128 (50.0%); repair-practice: 20/128 (15.6%); 規則排除：{&#x27;condition:made-a-project&#x27;: 64, &#x27;condition:repair-practice&#x27;: 20, &#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 15} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 78/96 (81.2%) | 11/96 (11.5%) | 11/78 (14.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 127/192 (66.1%) | 11/192 (5.7%) | 11/127 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 41} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 6/128 (4.7%) | 6/92 (6.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 129/192 (67.2%) | 18/192 (9.4%) | 18/129 (14.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 11/192 (5.7%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 11/128 (8.6%) | 11/116 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 137/192 (71.4%) | 9/192 (4.7%) | 9/137 (6.6%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 25} |
| middle-open-desk | 45–72 | 44/160 (27.5%) | 3/160 (1.9%) | 3/44 (6.8%) | shared-care-contacts: 106/160 (66.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 106, &#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 10} |
| middle-rhythm | 59–72 | 84/96 (87.5%) | 11/96 (11.5%) | 11/84 (13.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 91/96 (94.8%) | 5/96 (5.2%) | 5/91 (5.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 5} |
| later-tool-stories | 59–72 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 11} |
| later-voice-booth | 59–72 | 82/96 (85.4%) | 8/96 (8.3%) | 8/82 (9.8%) | recording-companion: 0/96 (0.0%); sharing-connection: 6/96 (6.2%); 規則排除：{&#x27;condition:sharing-connection&#x27;: 6, &#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 6 | 6 | 0/6 (0.0%) |
| adult-balance | invest | 6 | 6 | 4/6 (66.7%) |
| adult-balance | rest | 6 | 6 | 2/6 (33.3%) |
| adult-broken-bicycle | borrow | 15 | 15 | 7/15 (46.7%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 3/15 (20.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 5/15 (33.3%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 3/6 (50.0%) |
| adult-learning | offline | 6 | 6 | 1/6 (16.7%) |
| adult-learning | rest | 6 | 6 | 2/6 (33.3%) |
| adult-local-trail | lead | 2 | 2 | 0/11 (0.0%) |
| adult-local-trail | record | 11 | 11 | 6/11 (54.5%) |
| adult-local-trail | rest | 11 | 11 | 3/11 (27.3%) |
| adult-local-trail | seekGuide | 11 | 11 | 2/11 (18.2%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 2/13 (15.4%) |
| adult-meal-circle | seekGuide | 13 | 13 | 6/13 (46.2%) |
| adult-meal-circle | trial | 13 | 13 | 5/13 (38.5%) |
| adult-neighbor-market | ask | 4 | 4 | 1/4 (25.0%) |
| adult-neighbor-market | invest | 4 | 4 | 2/4 (50.0%) |
| adult-neighbor-market | rest | 4 | 4 | 1/4 (25.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 2/12 (16.7%) |
| adult-repair-coop | lead | 2 | 2 | 1/12 (8.3%) |
| adult-repair-coop | rest | 12 | 12 | 4/12 (33.3%) |
| adult-repair-coop | seekGuide | 12 | 12 | 5/12 (41.7%) |
| adult-shift-offer | extraShift | 10 | 10 | 5/10 (50.0%) |
| adult-shift-offer | predictable | 10 | 10 | 3/10 (30.0%) |
| adult-shift-offer | rest | 10 | 10 | 2/10 (20.0%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 6 | 6 | 1/6 (16.7%) |
| child-library-map | invest | 6 | 6 | 2/6 (33.3%) |
| child-library-map | rest | 6 | 6 | 3/6 (50.0%) |
| child-quiet-stage | backstage | 13 | 13 | 4/13 (30.8%) |
| child-quiet-stage | perform | 13 | 13 | 6/13 (46.2%) |
| child-quiet-stage | rest | 13 | 13 | 3/13 (23.1%) |
| child-rain-notebook | observe | 15 | 15 | 4/15 (26.7%) |
| child-rain-notebook | rest | 15 | 15 | 5/15 (33.3%) |
| child-rain-notebook | seekGuide | 15 | 15 | 6/15 (40.0%) |
| child-transition | ask | 7 | 7 | 2/7 (28.6%) |
| child-transition | invest | 7 | 7 | 5/7 (71.4%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 14 | 14 | 5/14 (35.7%) |
| child-wind-team | invest | 14 | 14 | 0/14 (0.0%) |
| child-wind-team | rest | 14 | 14 | 9/14 (64.3%) |
| later-pass-on | ask | 6 | 6 | 1/6 (16.7%) |
| later-pass-on | invest | 6 | 6 | 3/6 (50.0%) |
| later-pass-on | rest | 6 | 6 | 2/6 (33.3%) |
| later-path-map | lead | 2 | 2 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 4/5 (80.0%) |
| later-path-map | seekGuide | 5 | 5 | 0/5 (0.0%) |
| later-path-map | shortWalk | 5 | 5 | 1/5 (20.0%) |
| later-reconnect | ask | 8 | 8 | 1/8 (12.5%) |
| later-reconnect | invest | 8 | 8 | 4/8 (50.0%) |
| later-reconnect | rest | 8 | 8 | 3/8 (37.5%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-shared-recipes | cookOnce | 5 | 5 | 2/5 (40.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/5 (0.0%) |
| later-shared-recipes | rest | 5 | 5 | 1/5 (20.0%) |
| later-shared-recipes | seekGuide | 5 | 5 | 2/5 (40.0%) |
| later-tool-stories | lead | 4 | 4 | 3/7 (42.9%) |
| later-tool-stories | learnAgain | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | rest | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | seekGuide | 7 | 7 | 2/7 (28.6%) |
| later-voice-booth | ask | 8 | 8 | 3/8 (37.5%) |
| later-voice-booth | invest | 8 | 8 | 3/8 (37.5%) |
| later-voice-booth | rest | 8 | 8 | 2/8 (25.0%) |
| middle-friend-letter | rest | 18 | 18 | 5/18 (27.8%) |
| middle-friend-letter | seekGuide | 18 | 18 | 7/18 (38.9%) |
| middle-friend-letter | write | 18 | 18 | 6/18 (33.3%) |
| middle-garden-table | ask | 9 | 9 | 2/9 (22.2%) |
| middle-garden-table | invest | 9 | 9 | 4/9 (44.4%) |
| middle-garden-table | rest | 9 | 9 | 3/9 (33.3%) |
| middle-open-desk | ask | 3 | 3 | 1/3 (33.3%) |
| middle-open-desk | invest | 3 | 3 | 1/3 (33.3%) |
| middle-open-desk | rest | 3 | 3 | 1/3 (33.3%) |
| middle-rest-circle | boundaries | 14 | 14 | 2/14 (14.3%) |
| middle-rest-circle | rest | 14 | 14 | 6/14 (42.9%) |
| middle-rest-circle | walk | 14 | 14 | 6/14 (42.9%) |
| middle-rhythm | ask | 11 | 11 | 1/11 (9.1%) |
| middle-rhythm | invest | 11 | 11 | 3/11 (27.3%) |
| middle-rhythm | rest | 11 | 11 | 7/11 (63.6%) |
| middle-seed-exchange | lead | 2 | 2 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 5/10 (50.0%) |
| middle-seed-exchange | rest | 10 | 10 | 1/10 (10.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 4/10 (40.0%) |
| middle-skill-exchange | rest | 11 | 11 | 4/11 (36.4%) |
| middle-skill-exchange | study | 11 | 11 | 1/11 (9.1%) |
| middle-skill-exchange | teach | 11 | 11 | 6/11 (54.5%) |
| middle-support | ask | 11 | 11 | 3/11 (27.3%) |
| middle-support | invest | 11 | 11 | 5/11 (45.5%) |
| middle-support | rest | 11 | 11 | 2/11 (18.2%) |
| middle-support | shareShift | 5 | 5 | 1/11 (9.1%) |
| middle-turn | ask | 9 | 9 | 3/9 (33.3%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 4/9 (44.4%) |
| middle-turn | rest | 9 | 9 | 2/9 (22.2%) |
| teen-direction | ask | 9 | 9 | 1/9 (11.1%) |
| teen-direction | invest | 9 | 9 | 1/9 (11.1%) |
| teen-direction | leadWorkshop | 4 | 4 | 1/9 (11.1%) |
| teen-direction | offline | 9 | 9 | 1/9 (11.1%) |
| teen-direction | rest | 9 | 9 | 5/9 (55.6%) |
| teen-launch | ask | 7 | 7 | 2/7 (28.6%) |
| teen-launch | invest | 7 | 7 | 2/7 (28.6%) |
| teen-launch | rest | 7 | 7 | 3/7 (42.9%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 7 | 7 | 1/7 (14.3%) |
| teen-repair-table | invest | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | rest | 7 | 7 | 3/7 (42.9%) |
| teen-river-survey | join | 12 | 12 | 2/12 (16.7%) |
| teen-river-survey | lead | 1 | 1 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 2/12 (16.7%) |
| teen-river-survey | seekGuide | 12 | 12 | 8/12 (66.7%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 11 | 11 | 3/11 (27.3%) |
| teen-shared-room | privateRoom | 11 | 11 | 6/11 (54.5%) |
| teen-shared-room | rest | 11 | 11 | 2/11 (18.2%) |
| teen-tool-library | practice | 7 | 7 | 1/7 (14.3%) |
| teen-tool-library | rest | 7 | 7 | 4/7 (57.1%) |
| teen-tool-library | seekGuide | 7 | 7 | 2/7 (28.6%) |

相鄰相同行動類型：112/448 (25.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/188 (0.0%) | 0/188 (0.0%) | 0/370 (0.0%) |
| 財務安全 | 0/20 (0.0%) | 0/20 (0.0%) | 0/51 (0.0%) |
| 人際關係 | 0/403 (0.0%) | 0/403 (0.0%) | 0/650 (0.0%) |
| 技能 | 0/245 (0.0%) | 0/245 (0.0%) | 0/566 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.learning-route | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.care-network | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |
| story.repair | 23/32 (71.9%) | 15/32 (46.9%) | 6/32 (18.8%) |
| story.kitchen | 14/32 (43.8%) | 15/32 (46.9%) | 3/32 (9.4%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 21/32 (65.6%) | 22/32 (68.8%) | 11/32 (34.4%) |

## ken-1／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 15/96 (15.6%) | 15/55 (27.3%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 8/96 (8.3%) | 8/91 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 112/128 (87.5%) | 11/128 (8.6%) | 11/112 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 16} |
| teen-tool-library | 17–32 | 114/128 (89.1%) | 6/128 (4.7%) | 6/114 (5.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 14} |
| teen-launch | 21–25 | 60/64 (93.8%) | 5/64 (7.8%) | 5/60 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 4} |
| teen-repair-table | 17–32 | 94/128 (73.4%) | 17/128 (13.3%) | 17/94 (18.1%) | made-a-project: 0/128 (0.0%); repair-practice: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 15, &#x27;one-shot&#x27;: 34} |
| teen-shared-kitchen | 17–32 | 108/128 (84.4%) | 10/128 (7.8%) | 10/108 (9.3%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 20} |
| teen-shared-room | 21–32 | 84/96 (87.5%) | 8/96 (8.3%) | 8/84 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| adult-learning | 25–45 | 92/128 (71.9%) | 3/128 (2.3%) | 3/92 (3.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 6} |
| adult-local-trail | 25–59 | 122/192 (63.5%) | 12/192 (6.2%) | 12/122 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 47} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 127/192 (66.1%) | 14/192 (7.3%) | 14/127 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 40} |
| adult-shift-offer | 25–52 | 106/160 (66.2%) | 9/160 (5.6%) | 9/106 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| adult-balance | 32–52 | 95/128 (74.2%) | 4/128 (3.1%) | 4/95 (4.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 1, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 1} |
| adult-broken-bicycle | 25–59 | 130/192 (67.7%) | 14/192 (7.3%) | 14/130 (10.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| adult-neighbor-market | 25–52 | 106/160 (66.2%) | 4/160 (2.5%) | 4/106 (3.8%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 20, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 136/192 (70.8%) | 15/192 (7.8%) | 15/136 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 28} |
| middle-seed-exchange | 45–72 | 150/160 (93.8%) | 9/160 (5.6%) | 9/150 (6.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 10} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 10/192 (5.2%) | 10/140 (7.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-rest-circle | 45–72 | 143/160 (89.4%) | 11/160 (6.9%) | 11/143 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 17} |
| middle-support | 52–72 | 116/128 (90.6%) | 12/128 (9.4%) | 12/116 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 144/192 (75.0%) | 6/192 (3.1%) | 6/144 (4.2%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 17} |
| middle-open-desk | 45–72 | 126/160 (78.8%) | 14/160 (8.8%) | 14/126 (11.1%) | shared-care-contacts: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 34} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 5/64 (7.8%) | 5/62 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 87/96 (90.6%) | 9/96 (9.4%) | 9/87 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 9} |
| later-voice-booth | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 7} |
| later-path-map | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 4/32 (12.5%) | 4/32 (12.5%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 4 | 4 | 0/4 (0.0%) |
| adult-balance | invest | 4 | 4 | 4/4 (100.0%) |
| adult-balance | rest | 4 | 4 | 0/4 (0.0%) |
| adult-broken-bicycle | borrow | 14 | 14 | 0/14 (0.0%) |
| adult-broken-bicycle | repairTogether | 14 | 14 | 14/14 (100.0%) |
| adult-broken-bicycle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 3 | 3 | 0/3 (0.0%) |
| adult-learning | invest | 3 | 3 | 3/3 (100.0%) |
| adult-learning | offline | 3 | 3 | 0/3 (0.0%) |
| adult-learning | rest | 3 | 3 | 0/3 (0.0%) |
| adult-local-trail | lead | 7 | 7 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 12/12 (100.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | lead | 3 | 3 | 3/13 (23.1%) |
| adult-meal-circle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | trial | 13 | 13 | 10/13 (76.9%) |
| adult-neighbor-market | ask | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | invest | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 14 | 14 | 14/14 (100.0%) |
| adult-repair-coop | lead | 12 | 12 | 0/14 (0.0%) |
| adult-repair-coop | rest | 14 | 14 | 0/14 (0.0%) |
| adult-repair-coop | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-shift-offer | extraShift | 9 | 9 | 9/9 (100.0%) |
| adult-shift-offer | predictable | 9 | 9 | 0/9 (0.0%) |
| adult-shift-offer | rest | 9 | 9 | 0/9 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 0/5 (0.0%) |
| child-library-map | invest | 5 | 5 | 5/5 (100.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 10 | 10 | 10/10 (100.0%) |
| child-quiet-stage | perform | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | rest | 10 | 10 | 0/10 (0.0%) |
| child-rain-notebook | observe | 13 | 13 | 13/13 (100.0%) |
| child-rain-notebook | rest | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | seekGuide | 13 | 13 | 0/13 (0.0%) |
| child-transition | ask | 7 | 7 | 0/7 (0.0%) |
| child-transition | invest | 7 | 7 | 7/7 (100.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 15 | 15 | 0/15 (0.0%) |
| child-wind-team | invest | 15 | 15 | 15/15 (100.0%) |
| child-wind-team | rest | 15 | 15 | 0/15 (0.0%) |
| later-pass-on | ask | 5 | 5 | 0/5 (0.0%) |
| later-pass-on | invest | 5 | 5 | 5/5 (100.0%) |
| later-pass-on | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | lead | 6 | 6 | 6/7 (85.7%) |
| later-path-map | rest | 7 | 7 | 0/7 (0.0%) |
| later-path-map | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-path-map | shortWalk | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | ask | 4 | 4 | 0/4 (0.0%) |
| later-reconnect | invest | 4 | 4 | 4/4 (100.0%) |
| later-reconnect | rest | 4 | 4 | 0/4 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 7/7 (100.0%) |
| later-shared-recipes | lead | 6 | 6 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | lead | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | learnAgain | 9 | 9 | 9/9 (100.0%) |
| later-tool-stories | rest | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | seekGuide | 9 | 9 | 0/9 (0.0%) |
| later-voice-booth | ask | 6 | 6 | 0/6 (0.0%) |
| later-voice-booth | invest | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | rest | 6 | 6 | 0/6 (0.0%) |
| middle-friend-letter | rest | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | seekGuide | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | write | 15 | 15 | 15/15 (100.0%) |
| middle-garden-table | ask | 6 | 6 | 0/6 (0.0%) |
| middle-garden-table | invest | 6 | 6 | 6/6 (100.0%) |
| middle-garden-table | rest | 6 | 6 | 0/6 (0.0%) |
| middle-open-desk | ask | 14 | 14 | 0/14 (0.0%) |
| middle-open-desk | invest | 14 | 14 | 14/14 (100.0%) |
| middle-open-desk | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | boundaries | 11 | 11 | 0/11 (0.0%) |
| middle-rest-circle | rest | 11 | 11 | 11/11 (100.0%) |
| middle-rest-circle | walk | 11 | 11 | 0/11 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | invest | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 3 | 3 | 3/9 (33.3%) |
| middle-seed-exchange | onePot | 9 | 9 | 6/9 (66.7%) |
| middle-seed-exchange | rest | 9 | 9 | 0/9 (0.0%) |
| middle-seed-exchange | seekGuide | 9 | 9 | 0/9 (0.0%) |
| middle-skill-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | study | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | teach | 10 | 10 | 0/10 (0.0%) |
| middle-support | ask | 12 | 12 | 0/12 (0.0%) |
| middle-support | invest | 12 | 12 | 12/12 (100.0%) |
| middle-support | rest | 12 | 12 | 0/12 (0.0%) |
| middle-support | shareShift | 12 | 12 | 0/12 (0.0%) |
| middle-turn | ask | 7 | 7 | 0/7 (0.0%) |
| middle-turn | invest | 7 | 7 | 7/7 (100.0%) |
| middle-turn | offline | 7 | 7 | 0/7 (0.0%) |
| middle-turn | rest | 7 | 7 | 0/7 (0.0%) |
| teen-direction | ask | 8 | 8 | 0/8 (0.0%) |
| teen-direction | invest | 8 | 8 | 8/8 (100.0%) |
| teen-direction | leadWorkshop | 8 | 8 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 0/8 (0.0%) |
| teen-launch | ask | 5 | 5 | 0/5 (0.0%) |
| teen-launch | invest | 5 | 5 | 5/5 (100.0%) |
| teen-launch | rest | 5 | 5 | 0/5 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 17 | 17 | 0/17 (0.0%) |
| teen-repair-table | invest | 17 | 17 | 17/17 (100.0%) |
| teen-repair-table | rest | 17 | 17 | 0/17 (0.0%) |
| teen-river-survey | join | 11 | 11 | 11/11 (100.0%) |
| teen-river-survey | lead | 6 | 6 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | seekGuide | 11 | 11 | 0/11 (0.0%) |
| teen-shared-kitchen | ask | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | invest | 10 | 10 | 10/10 (100.0%) |
| teen-shared-kitchen | rest | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | agreement | 8 | 8 | 8/8 (100.0%) |
| teen-shared-room | privateRoom | 8 | 8 | 0/8 (0.0%) |
| teen-shared-room | rest | 8 | 8 | 0/8 (0.0%) |
| teen-tool-library | practice | 6 | 6 | 6/6 (100.0%) |
| teen-tool-library | rest | 6 | 6 | 0/6 (0.0%) |
| teen-tool-library | seekGuide | 6 | 6 | 0/6 (0.0%) |

相鄰相同行動類型：218/448 (48.7%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/31 (0.0%) | 0/31 (0.0%) | 0/42 (0.0%) |
| 財務安全 | 0/48 (0.0%) | 0/48 (0.0%) | 0/94 (0.0%) |
| 人際關係 | 0/455 (0.0%) | 0/455 (0.0%) | 0/967 (0.0%) |
| 技能 | 0/343 (0.0%) | 0/343 (0.0%) | 0/1216 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/42 (0.0%) | 0/42 (0.0%) | 0/42 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 4/32 (12.5%) | 4/32 (12.5%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) |
| story.repair | 32/32 (100.0%) | 19/32 (59.4%) | 18/32 (56.2%) |
| story.kitchen | 24/32 (75.0%) | 16/32 (50.0%) | 9/32 (28.1%) |
| story.garden | 12/32 (37.5%) | 9/32 (28.1%) | 3/32 (9.4%) |
| story.nature | 24/32 (75.0%) | 21/32 (65.6%) | 14/32 (43.8%) |

## ken-1／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 17/96 (17.7%) | 17/55 (30.9%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 6/96 (6.2%) | 6/91 (6.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 108/128 (84.4%) | 11/128 (8.6%) | 11/108 (10.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 20} |
| teen-tool-library | 17–32 | 109/128 (85.2%) | 9/128 (7.0%) | 9/109 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 19} |
| teen-launch | 21–25 | 57/64 (89.1%) | 9/64 (14.1%) | 9/57 (15.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 7} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 44/128 (34.4%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 44} |
| teen-shared-kitchen | 17–32 | 101/128 (78.9%) | 13/128 (10.2%) | 13/101 (12.9%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 27} |
| teen-shared-room | 21–32 | 80/96 (83.3%) | 10/96 (10.4%) | 10/80 (12.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 16} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 123/192 (64.1%) | 12/192 (6.2%) | 12/123 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 46} |
| adult-meal-circle | 25–59 | 136/192 (70.8%) | 13/192 (6.8%) | 13/136 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 29} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 93/128 (72.7%) | 5/128 (3.9%) | 5/93 (5.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 4} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 138/192 (71.9%) | 12/192 (6.2%) | 12/138 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 23} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 9/128 (7.0%) | 9/116 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 21/160 (13.1%) | 4/160 (2.5%) | 4/21 (19.0%) | shared-care-contacts: 130/160 (81.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 130, &#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 9} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 5 | 5 | 5/5 (100.0%) |
| adult-balance | invest | 5 | 5 | 0/5 (0.0%) |
| adult-balance | rest | 5 | 5 | 0/5 (0.0%) |
| adult-broken-bicycle | borrow | 15 | 15 | 15/15 (100.0%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 0/15 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 6 | 6 | 6/6 (100.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 0/6 (0.0%) |
| adult-local-trail | lead | 0 | 0 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 13/13 (100.0%) |
| adult-meal-circle | trial | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | ask | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | invest | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 5/5 (100.0%) |
| child-library-map | invest | 5 | 5 | 0/5 (0.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | perform | 10 | 10 | 0/10 (0.0%) |
| child-quiet-stage | rest | 10 | 10 | 10/10 (100.0%) |
| child-rain-notebook | observe | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | rest | 13 | 13 | 0/13 (0.0%) |
| child-rain-notebook | seekGuide | 13 | 13 | 13/13 (100.0%) |
| child-transition | ask | 7 | 7 | 7/7 (100.0%) |
| child-transition | invest | 7 | 7 | 0/7 (0.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 17 | 17 | 17/17 (100.0%) |
| child-wind-team | invest | 17 | 17 | 0/17 (0.0%) |
| child-wind-team | rest | 17 | 17 | 0/17 (0.0%) |
| later-pass-on | ask | 6 | 6 | 6/6 (100.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 0/6 (0.0%) |
| later-path-map | lead | 0 | 0 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | seekGuide | 5 | 5 | 5/5 (100.0%) |
| later-path-map | shortWalk | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | ask | 9 | 9 | 9/9 (100.0%) |
| later-reconnect | invest | 9 | 9 | 0/9 (0.0%) |
| later-reconnect | rest | 9 | 9 | 0/9 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | ask | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | invest | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 8/8 (100.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 0/8 (0.0%) |
| middle-open-desk | ask | 4 | 4 | 4/4 (100.0%) |
| middle-open-desk | invest | 4 | 4 | 0/4 (0.0%) |
| middle-open-desk | rest | 4 | 4 | 0/4 (0.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 14/14 (100.0%) |
| middle-rest-circle | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | walk | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | invest | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 9 | 9 | 9/9 (100.0%) |
| middle-support | invest | 9 | 9 | 0/9 (0.0%) |
| middle-support | rest | 9 | 9 | 0/9 (0.0%) |
| middle-support | shareShift | 2 | 2 | 0/9 (0.0%) |
| middle-turn | ask | 9 | 9 | 9/9 (100.0%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 0/9 (0.0%) |
| middle-turn | rest | 9 | 9 | 0/9 (0.0%) |
| teen-direction | ask | 6 | 6 | 6/6 (100.0%) |
| teen-direction | invest | 6 | 6 | 0/6 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/6 (0.0%) |
| teen-direction | offline | 6 | 6 | 0/6 (0.0%) |
| teen-direction | rest | 6 | 6 | 0/6 (0.0%) |
| teen-launch | ask | 9 | 9 | 9/9 (100.0%) |
| teen-launch | invest | 9 | 9 | 0/9 (0.0%) |
| teen-launch | rest | 9 | 9 | 0/9 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 0/11 (0.0%) |
| teen-river-survey | seekGuide | 11 | 11 | 11/11 (100.0%) |
| teen-shared-kitchen | ask | 13 | 13 | 13/13 (100.0%) |
| teen-shared-kitchen | invest | 13 | 13 | 0/13 (0.0%) |
| teen-shared-kitchen | rest | 13 | 13 | 0/13 (0.0%) |
| teen-shared-room | agreement | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | privateRoom | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | practice | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | rest | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | seekGuide | 9 | 9 | 9/9 (100.0%) |

相鄰相同行動類型：370/448 (82.6%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/56 (0.0%) | 0/56 (0.0%) | 0/112 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/438 (0.0%) | 0/438 (0.0%) | 0/732 (0.0%) |
| 技能 | 0/409 (0.0%) | 0/409 (0.0%) | 0/409 (0.0%) |

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
| story.childhood-connection | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.learning-route | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.care-network | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.repair | 25/32 (78.1%) | 15/32 (46.9%) | 9/32 (28.1%) |
| story.kitchen | 22/32 (68.8%) | 16/32 (50.0%) | 7/32 (21.9%) |
| story.garden | 15/32 (46.9%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 24/32 (75.0%) | 22/32 (68.8%) | 13/32 (40.6%) |

## ken-1／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 59/96 (61.5%) | 12/96 (12.5%) | 12/59 (20.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 15/96 (15.6%) | 15/57 (26.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | windmill-promise: 96/96 (100.0%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 96, &#x27;milestone-slot&#x27;: 32} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 91/96 (94.8%) | 6/96 (6.2%) | 6/91 (6.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| teen-river-survey | 17–32 | 109/128 (85.2%) | 10/128 (7.8%) | 10/109 (9.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 19} |
| teen-tool-library | 17–32 | 106/128 (82.8%) | 10/128 (7.8%) | 10/106 (9.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-launch | 21–25 | 56/64 (87.5%) | 10/64 (15.6%) | 10/56 (17.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 8} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 128/128 (100.0%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 128} |
| teen-shared-kitchen | 17–32 | 92/128 (71.9%) | 16/128 (12.5%) | 16/92 (17.4%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 14, &#x27;one-shot&#x27;: 36} |
| teen-shared-room | 21–32 | 78/96 (81.2%) | 11/96 (11.5%) | 11/78 (14.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 130/192 (67.7%) | 10/192 (5.2%) | 10/130 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 37} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 100/160 (62.5%) | 10/160 (6.2%) | 10/100 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 15, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 7/128 (5.5%) | 7/92 (7.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 100/160 (62.5%) | 5/160 (3.1%) | 5/100 (5.0%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 15} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 140/160 (87.5%) | 13/160 (8.1%) | 13/140 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 20} |
| middle-skill-exchange | 32–65 | 137/192 (71.4%) | 12/192 (6.2%) | 12/137 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| middle-turn | 45–59 | 83/96 (86.5%) | 10/96 (10.4%) | 10/83 (12.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 13} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 15/160 (9.4%) | 15/140 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 118/128 (92.2%) | 10/128 (7.8%) | 10/118 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 10} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 0/160 (0.0%) | 0/160 (0.0%) | — (0/0) | shared-care-contacts: 160/160 (100.0%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 160} |
| middle-rhythm | 59–72 | 82/96 (85.4%) | 13/96 (13.5%) | 13/82 (15.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 14} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 6/96 (6.2%) | 6/87 (6.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 10/96 (10.4%) | 10/87 (11.5%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 93/96 (96.9%) | 3/96 (3.1%) | 3/93 (3.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 3} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 3/32 (9.4%) | 3/32 (9.4%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 7 | 7 | 0/7 (0.0%) |
| adult-balance | invest | 7 | 7 | 0/7 (0.0%) |
| adult-balance | rest | 7 | 7 | 7/7 (100.0%) |
| adult-broken-bicycle | borrow | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 0/15 (0.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 15/15 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 6/6 (100.0%) |
| adult-local-trail | lead | 0 | 0 | 0/10 (0.0%) |
| adult-local-trail | record | 10 | 10 | 0/10 (0.0%) |
| adult-local-trail | rest | 10 | 10 | 10/10 (100.0%) |
| adult-local-trail | seekGuide | 10 | 10 | 0/10 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 13/13 (100.0%) |
| adult-meal-circle | seekGuide | 13 | 13 | 0/13 (0.0%) |
| adult-meal-circle | trial | 13 | 13 | 0/13 (0.0%) |
| adult-neighbor-market | ask | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | invest | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | rest | 5 | 5 | 5/5 (100.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 12/12 (100.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 12 | 12 | 0/12 (0.0%) |
| child-library-map | invest | 12 | 12 | 0/12 (0.0%) |
| child-library-map | rest | 12 | 12 | 12/12 (100.0%) |
| child-quiet-stage | backstage | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | perform | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | rest | 12 | 12 | 12/12 (100.0%) |
| child-rain-notebook | observe | 15 | 15 | 0/15 (0.0%) |
| child-rain-notebook | rest | 15 | 15 | 15/15 (100.0%) |
| child-rain-notebook | seekGuide | 15 | 15 | 0/15 (0.0%) |
| child-transition | ask | 8 | 8 | 0/8 (0.0%) |
| child-transition | invest | 8 | 8 | 0/8 (0.0%) |
| child-transition | rest | 8 | 8 | 8/8 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 6/6 (100.0%) |
| later-path-map | lead | 0 | 0 | 0/3 (0.0%) |
| later-path-map | rest | 3 | 3 | 3/3 (100.0%) |
| later-path-map | seekGuide | 3 | 3 | 0/3 (0.0%) |
| later-path-map | shortWalk | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | ask | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | invest | 3 | 3 | 0/3 (0.0%) |
| later-reconnect | rest | 3 | 3 | 3/3 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-shared-recipes | cookOnce | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/6 (0.0%) |
| later-shared-recipes | rest | 6 | 6 | 6/6 (100.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 6/6 (100.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-voice-booth | ask | 10 | 10 | 0/10 (0.0%) |
| later-voice-booth | invest | 10 | 10 | 0/10 (0.0%) |
| later-voice-booth | rest | 10 | 10 | 10/10 (100.0%) |
| middle-friend-letter | rest | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 8/8 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rest-circle | boundaries | 15 | 15 | 0/15 (0.0%) |
| middle-rest-circle | rest | 15 | 15 | 15/15 (100.0%) |
| middle-rest-circle | walk | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | ask | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | invest | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/13 (0.0%) |
| middle-seed-exchange | onePot | 13 | 13 | 0/13 (0.0%) |
| middle-seed-exchange | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | seekGuide | 13 | 13 | 0/13 (0.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 10 | 10 | 0/10 (0.0%) |
| middle-support | invest | 10 | 10 | 0/10 (0.0%) |
| middle-support | rest | 10 | 10 | 10/10 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/10 (0.0%) |
| middle-turn | ask | 10 | 10 | 0/10 (0.0%) |
| middle-turn | invest | 10 | 10 | 0/10 (0.0%) |
| middle-turn | offline | 10 | 10 | 0/10 (0.0%) |
| middle-turn | rest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | ask | 6 | 6 | 0/6 (0.0%) |
| teen-direction | invest | 6 | 6 | 0/6 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/6 (0.0%) |
| teen-direction | offline | 6 | 6 | 0/6 (0.0%) |
| teen-direction | rest | 6 | 6 | 6/6 (100.0%) |
| teen-launch | ask | 10 | 10 | 0/10 (0.0%) |
| teen-launch | invest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | rest | 10 | 10 | 10/10 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 10 | 10 | 0/10 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/10 (0.0%) |
| teen-river-survey | rest | 10 | 10 | 10/10 (100.0%) |
| teen-river-survey | seekGuide | 10 | 10 | 0/10 (0.0%) |
| teen-shared-kitchen | ask | 16 | 16 | 0/16 (0.0%) |
| teen-shared-kitchen | invest | 16 | 16 | 0/16 (0.0%) |
| teen-shared-kitchen | rest | 16 | 16 | 16/16 (100.0%) |
| teen-shared-room | agreement | 11 | 11 | 0/11 (0.0%) |
| teen-shared-room | privateRoom | 11 | 11 | 0/11 (0.0%) |
| teen-shared-room | rest | 11 | 11 | 11/11 (100.0%) |
| teen-tool-library | practice | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | seekGuide | 10 | 10 | 0/10 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/290 (0.0%) | 0/290 (0.0%) | 0/290 (0.0%) |
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
| story.childhood-connection | 32/32 (100.0%) | 3/32 (9.4%) | 3/32 (9.4%) |
| story.learning-route | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.care-network | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.repair | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.kitchen | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.garden | 0/32 (0.0%) | 13/32 (40.6%) | 0/32 (0.0%) |
| story.nature | 0/32 (0.0%) | 18/32 (56.2%) | 0/32 (0.0%) |

## ken-1／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 10/96 (10.4%) | 10/60 (16.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 13/96 (13.5%) | 13/57 (22.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 33/96 (34.4%) | 14/96 (14.6%) | 14/33 (42.4%) | windmill-promise: 34/96 (35.4%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 34, &#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 16} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 90/96 (93.8%) | 7/96 (7.3%) | 7/90 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| teen-river-survey | 17–32 | 105/128 (82.0%) | 11/128 (8.6%) | 11/105 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 23} |
| teen-tool-library | 17–32 | 113/128 (88.3%) | 7/128 (5.5%) | 7/113 (6.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 15} |
| teen-launch | 21–25 | 58/64 (90.6%) | 7/64 (10.9%) | 7/58 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-repair-table | 17–32 | 52/128 (40.6%) | 6/128 (4.7%) | 6/52 (11.5%) | made-a-project: 64/128 (50.0%); repair-practice: 20/128 (15.6%); 規則排除：{&#x27;condition:made-a-project&#x27;: 64, &#x27;condition:repair-practice&#x27;: 20, &#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 12} |
| teen-shared-kitchen | 17–32 | 102/128 (79.7%) | 12/128 (9.4%) | 12/102 (11.8%) | family-rotations: 0/128 (0.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 26} |
| teen-shared-room | 21–32 | 82/96 (85.4%) | 9/96 (9.4%) | 9/82 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 14} |
| adult-learning | 25–45 | 91/128 (71.1%) | 5/128 (3.9%) | 5/91 (5.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| adult-local-trail | 25–59 | 127/192 (66.1%) | 11/192 (5.7%) | 11/127 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 41} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 6/128 (4.7%) | 6/92 (6.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 129/192 (67.2%) | 18/192 (9.4%) | 18/129 (14.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 11/192 (5.7%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 11/128 (8.6%) | 11/116 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 137/192 (71.4%) | 9/192 (4.7%) | 9/137 (6.6%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 25} |
| middle-open-desk | 45–72 | 44/160 (27.5%) | 4/160 (2.5%) | 4/44 (9.1%) | shared-care-contacts: 106/160 (66.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 106, &#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 10} |
| middle-rhythm | 59–72 | 84/96 (87.5%) | 11/96 (11.5%) | 11/84 (13.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 7} |
| later-tool-stories | 59–72 | 86/96 (89.6%) | 7/96 (7.3%) | 7/86 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 10} |
| later-voice-booth | 59–72 | 89/96 (92.7%) | 7/96 (7.3%) | 7/89 (7.9%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 7} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 6 | 6 | 0/6 (0.0%) |
| adult-balance | invest | 6 | 6 | 4/6 (66.7%) |
| adult-balance | rest | 6 | 6 | 2/6 (33.3%) |
| adult-broken-bicycle | borrow | 15 | 15 | 7/15 (46.7%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 3/15 (20.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 5/15 (33.3%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 5 | 5 | 0/5 (0.0%) |
| adult-learning | invest | 5 | 5 | 2/5 (40.0%) |
| adult-learning | offline | 5 | 5 | 1/5 (20.0%) |
| adult-learning | rest | 5 | 5 | 2/5 (40.0%) |
| adult-local-trail | lead | 1 | 1 | 0/11 (0.0%) |
| adult-local-trail | record | 11 | 11 | 6/11 (54.5%) |
| adult-local-trail | rest | 11 | 11 | 3/11 (27.3%) |
| adult-local-trail | seekGuide | 11 | 11 | 2/11 (18.2%) |
| adult-meal-circle | lead | 2 | 2 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 3/13 (23.1%) |
| adult-meal-circle | seekGuide | 13 | 13 | 6/13 (46.2%) |
| adult-meal-circle | trial | 13 | 13 | 4/13 (30.8%) |
| adult-neighbor-market | ask | 4 | 4 | 1/4 (25.0%) |
| adult-neighbor-market | invest | 4 | 4 | 2/4 (50.0%) |
| adult-neighbor-market | rest | 4 | 4 | 1/4 (25.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 2/12 (16.7%) |
| adult-repair-coop | lead | 2 | 2 | 1/12 (8.3%) |
| adult-repair-coop | rest | 12 | 12 | 4/12 (33.3%) |
| adult-repair-coop | seekGuide | 12 | 12 | 5/12 (41.7%) |
| adult-shift-offer | extraShift | 10 | 10 | 5/10 (50.0%) |
| adult-shift-offer | predictable | 10 | 10 | 3/10 (30.0%) |
| adult-shift-offer | rest | 10 | 10 | 2/10 (20.0%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 6 | 6 | 1/6 (16.7%) |
| child-library-map | invest | 6 | 6 | 2/6 (33.3%) |
| child-library-map | rest | 6 | 6 | 3/6 (50.0%) |
| child-quiet-stage | backstage | 10 | 10 | 3/10 (30.0%) |
| child-quiet-stage | perform | 10 | 10 | 5/10 (50.0%) |
| child-quiet-stage | rest | 10 | 10 | 2/10 (20.0%) |
| child-rain-notebook | observe | 13 | 13 | 2/13 (15.4%) |
| child-rain-notebook | rest | 13 | 13 | 5/13 (38.5%) |
| child-rain-notebook | seekGuide | 13 | 13 | 6/13 (46.2%) |
| child-transition | ask | 7 | 7 | 2/7 (28.6%) |
| child-transition | invest | 7 | 7 | 5/7 (71.4%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 14 | 14 | 5/14 (35.7%) |
| child-wind-team | invest | 14 | 14 | 0/14 (0.0%) |
| child-wind-team | rest | 14 | 14 | 9/14 (64.3%) |
| later-pass-on | ask | 6 | 6 | 1/6 (16.7%) |
| later-pass-on | invest | 6 | 6 | 3/6 (50.0%) |
| later-pass-on | rest | 6 | 6 | 2/6 (33.3%) |
| later-path-map | lead | 2 | 2 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 4/5 (80.0%) |
| later-path-map | seekGuide | 5 | 5 | 0/5 (0.0%) |
| later-path-map | shortWalk | 5 | 5 | 1/5 (20.0%) |
| later-reconnect | ask | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | invest | 7 | 7 | 3/7 (42.9%) |
| later-reconnect | rest | 7 | 7 | 3/7 (42.9%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-shared-recipes | cookOnce | 6 | 6 | 2/6 (33.3%) |
| later-shared-recipes | lead | 2 | 2 | 1/6 (16.7%) |
| later-shared-recipes | rest | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 3/6 (50.0%) |
| later-tool-stories | lead | 4 | 4 | 4/7 (57.1%) |
| later-tool-stories | learnAgain | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | rest | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | seekGuide | 7 | 7 | 1/7 (14.3%) |
| later-voice-booth | ask | 7 | 7 | 2/7 (28.6%) |
| later-voice-booth | invest | 7 | 7 | 3/7 (42.9%) |
| later-voice-booth | rest | 7 | 7 | 2/7 (28.6%) |
| middle-friend-letter | rest | 18 | 18 | 5/18 (27.8%) |
| middle-friend-letter | seekGuide | 18 | 18 | 7/18 (38.9%) |
| middle-friend-letter | write | 18 | 18 | 6/18 (33.3%) |
| middle-garden-table | ask | 9 | 9 | 2/9 (22.2%) |
| middle-garden-table | invest | 9 | 9 | 4/9 (44.4%) |
| middle-garden-table | rest | 9 | 9 | 3/9 (33.3%) |
| middle-open-desk | ask | 4 | 4 | 2/4 (50.0%) |
| middle-open-desk | invest | 4 | 4 | 1/4 (25.0%) |
| middle-open-desk | rest | 4 | 4 | 1/4 (25.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 2/14 (14.3%) |
| middle-rest-circle | rest | 14 | 14 | 6/14 (42.9%) |
| middle-rest-circle | walk | 14 | 14 | 6/14 (42.9%) |
| middle-rhythm | ask | 11 | 11 | 1/11 (9.1%) |
| middle-rhythm | invest | 11 | 11 | 3/11 (27.3%) |
| middle-rhythm | rest | 11 | 11 | 7/11 (63.6%) |
| middle-seed-exchange | lead | 2 | 2 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 5/10 (50.0%) |
| middle-seed-exchange | rest | 10 | 10 | 1/10 (10.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 4/10 (40.0%) |
| middle-skill-exchange | rest | 11 | 11 | 4/11 (36.4%) |
| middle-skill-exchange | study | 11 | 11 | 1/11 (9.1%) |
| middle-skill-exchange | teach | 11 | 11 | 6/11 (54.5%) |
| middle-support | ask | 11 | 11 | 3/11 (27.3%) |
| middle-support | invest | 11 | 11 | 5/11 (45.5%) |
| middle-support | rest | 11 | 11 | 2/11 (18.2%) |
| middle-support | shareShift | 5 | 5 | 1/11 (9.1%) |
| middle-turn | ask | 9 | 9 | 3/9 (33.3%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 4/9 (44.4%) |
| middle-turn | rest | 9 | 9 | 2/9 (22.2%) |
| teen-direction | ask | 7 | 7 | 1/7 (14.3%) |
| teen-direction | invest | 7 | 7 | 1/7 (14.3%) |
| teen-direction | leadWorkshop | 2 | 2 | 1/7 (14.3%) |
| teen-direction | offline | 7 | 7 | 1/7 (14.3%) |
| teen-direction | rest | 7 | 7 | 3/7 (42.9%) |
| teen-launch | ask | 7 | 7 | 2/7 (28.6%) |
| teen-launch | invest | 7 | 7 | 2/7 (28.6%) |
| teen-launch | rest | 7 | 7 | 3/7 (42.9%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 6 | 6 | 0/6 (0.0%) |
| teen-repair-table | invest | 6 | 6 | 3/6 (50.0%) |
| teen-repair-table | rest | 6 | 6 | 3/6 (50.0%) |
| teen-river-survey | join | 11 | 11 | 2/11 (18.2%) |
| teen-river-survey | lead | 1 | 1 | 0/11 (0.0%) |
| teen-river-survey | rest | 11 | 11 | 2/11 (18.2%) |
| teen-river-survey | seekGuide | 11 | 11 | 7/11 (63.6%) |
| teen-shared-kitchen | ask | 12 | 12 | 3/12 (25.0%) |
| teen-shared-kitchen | invest | 12 | 12 | 6/12 (50.0%) |
| teen-shared-kitchen | rest | 12 | 12 | 3/12 (25.0%) |
| teen-shared-room | agreement | 9 | 9 | 3/9 (33.3%) |
| teen-shared-room | privateRoom | 9 | 9 | 4/9 (44.4%) |
| teen-shared-room | rest | 9 | 9 | 2/9 (22.2%) |
| teen-tool-library | practice | 7 | 7 | 1/7 (14.3%) |
| teen-tool-library | rest | 7 | 7 | 4/7 (57.1%) |
| teen-tool-library | seekGuide | 7 | 7 | 2/7 (28.6%) |

相鄰相同行動類型：113/448 (25.2%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/186 (0.0%) | 0/186 (0.0%) | 0/366 (0.0%) |
| 財務安全 | 0/25 (0.0%) | 0/25 (0.0%) | 0/56 (0.0%) |
| 人際關係 | 0/406 (0.0%) | 0/406 (0.0%) | 0/666 (0.0%) |
| 技能 | 0/242 (0.0%) | 0/242 (0.0%) | 0/551 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/9 (0.0%) | 0/9 (0.0%) | 0/9 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) |
| story.learning-route | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) |
| story.care-network | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |
| story.repair | 22/32 (68.8%) | 15/32 (46.9%) | 6/32 (18.8%) |
| story.kitchen | 20/32 (62.5%) | 16/32 (50.0%) | 8/32 (25.0%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 19/32 (59.4%) | 21/32 (65.6%) | 10/32 (31.2%) |

## ken-2／投入優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 11/96 (11.5%) | 11/60 (18.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 14/96 (14.6%) | 14/57 (24.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 16/96 (16.7%) | 16/55 (29.1%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 90/96 (93.8%) | 10/96 (10.4%) | 10/90 (11.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-river-survey | 17–32 | 110/128 (85.9%) | 13/128 (10.2%) | 13/110 (11.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| teen-tool-library | 17–32 | 114/128 (89.1%) | 6/128 (4.7%) | 6/114 (5.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 14} |
| teen-launch | 21–25 | 60/64 (93.8%) | 5/64 (7.8%) | 5/60 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 4} |
| teen-repair-table | 17–32 | 91/128 (71.1%) | 18/128 (14.1%) | 18/91 (19.8%) | made-a-project: 0/128 (0.0%); repair-practice: 0/128 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 16, &#x27;one-shot&#x27;: 37} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 80/96 (83.3%) | 10/96 (10.4%) | 10/80 (12.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 16} |
| adult-learning | 25–45 | 91/128 (71.1%) | 4/128 (3.1%) | 4/91 (4.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| adult-local-trail | 25–59 | 122/192 (63.5%) | 12/192 (6.2%) | 12/122 (9.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 47} |
| adult-meal-circle | 25–59 | 139/192 (72.4%) | 12/192 (6.2%) | 12/139 (8.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 26} |
| adult-repair-coop | 25–59 | 127/192 (66.1%) | 14/192 (7.3%) | 14/127 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 40} |
| adult-shift-offer | 25–52 | 106/160 (66.2%) | 9/160 (5.6%) | 9/106 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| adult-balance | 32–52 | 95/128 (74.2%) | 4/128 (3.1%) | 4/95 (4.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 1, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 1} |
| adult-broken-bicycle | 25–59 | 131/192 (68.2%) | 13/192 (6.8%) | 13/131 (9.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 35} |
| adult-neighbor-market | 25–52 | 106/160 (66.2%) | 4/160 (2.5%) | 4/106 (3.8%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 20, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 136/192 (70.8%) | 15/192 (7.8%) | 15/136 (11.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 28} |
| middle-seed-exchange | 45–72 | 147/160 (91.9%) | 10/160 (6.2%) | 10/147 (6.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 13} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 10/192 (5.2%) | 10/140 (7.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-rest-circle | 45–72 | 143/160 (89.4%) | 11/160 (6.9%) | 11/143 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 17} |
| middle-support | 52–72 | 116/128 (90.6%) | 12/128 (9.4%) | 12/116 (10.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 144/192 (75.0%) | 6/192 (3.1%) | 6/144 (4.2%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 17} |
| middle-open-desk | 45–72 | 126/160 (78.8%) | 13/160 (8.1%) | 13/126 (10.3%) | shared-care-contacts: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;one-shot&#x27;: 34} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 5/64 (7.8%) | 5/62 (8.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 89/96 (92.7%) | 6/96 (6.2%) | 6/89 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 7} |
| later-tool-stories | 59–72 | 86/96 (89.6%) | 9/96 (9.4%) | 9/86 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 10} |
| later-voice-booth | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-path-map | 59–72 | 88/96 (91.7%) | 7/96 (7.3%) | 7/88 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 4 | 4 | 0/4 (0.0%) |
| adult-balance | invest | 4 | 4 | 4/4 (100.0%) |
| adult-balance | rest | 4 | 4 | 0/4 (0.0%) |
| adult-broken-bicycle | borrow | 13 | 13 | 0/13 (0.0%) |
| adult-broken-bicycle | repairTogether | 13 | 13 | 13/13 (100.0%) |
| adult-broken-bicycle | rest | 13 | 13 | 0/13 (0.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 32/32 (100.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 4 | 4 | 0/4 (0.0%) |
| adult-learning | invest | 4 | 4 | 4/4 (100.0%) |
| adult-learning | offline | 4 | 4 | 0/4 (0.0%) |
| adult-learning | rest | 4 | 4 | 0/4 (0.0%) |
| adult-local-trail | lead | 8 | 8 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 12/12 (100.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/12 (0.0%) |
| adult-meal-circle | rest | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-meal-circle | trial | 12 | 12 | 12/12 (100.0%) |
| adult-neighbor-market | ask | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | invest | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 14 | 14 | 14/14 (100.0%) |
| adult-repair-coop | lead | 12 | 12 | 0/14 (0.0%) |
| adult-repair-coop | rest | 14 | 14 | 0/14 (0.0%) |
| adult-repair-coop | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-shift-offer | extraShift | 9 | 9 | 9/9 (100.0%) |
| adult-shift-offer | predictable | 9 | 9 | 0/9 (0.0%) |
| adult-shift-offer | rest | 9 | 9 | 0/9 (0.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 32/32 (100.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 32/32 (100.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 0/5 (0.0%) |
| child-library-map | invest | 5 | 5 | 5/5 (100.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 11 | 11 | 11/11 (100.0%) |
| child-quiet-stage | perform | 11 | 11 | 0/11 (0.0%) |
| child-quiet-stage | rest | 11 | 11 | 0/11 (0.0%) |
| child-rain-notebook | observe | 14 | 14 | 14/14 (100.0%) |
| child-rain-notebook | rest | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | seekGuide | 14 | 14 | 0/14 (0.0%) |
| child-transition | ask | 7 | 7 | 0/7 (0.0%) |
| child-transition | invest | 7 | 7 | 7/7 (100.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 16 | 16 | 0/16 (0.0%) |
| child-wind-team | invest | 16 | 16 | 16/16 (100.0%) |
| child-wind-team | rest | 16 | 16 | 0/16 (0.0%) |
| later-pass-on | ask | 5 | 5 | 0/5 (0.0%) |
| later-pass-on | invest | 5 | 5 | 5/5 (100.0%) |
| later-pass-on | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | lead | 6 | 6 | 6/7 (85.7%) |
| later-path-map | rest | 7 | 7 | 0/7 (0.0%) |
| later-path-map | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-path-map | shortWalk | 7 | 7 | 1/7 (14.3%) |
| later-reconnect | ask | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | invest | 5 | 5 | 5/5 (100.0%) |
| later-reconnect | rest | 5 | 5 | 0/5 (0.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 32/32 (100.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 6 | 6 | 6/6 (100.0%) |
| later-shared-recipes | lead | 3 | 3 | 0/6 (0.0%) |
| later-shared-recipes | rest | 6 | 6 | 0/6 (0.0%) |
| later-shared-recipes | seekGuide | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | lead | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | learnAgain | 9 | 9 | 9/9 (100.0%) |
| later-tool-stories | rest | 9 | 9 | 0/9 (0.0%) |
| later-tool-stories | seekGuide | 9 | 9 | 0/9 (0.0%) |
| later-voice-booth | ask | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | invest | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | seekGuide | 15 | 15 | 0/15 (0.0%) |
| middle-friend-letter | write | 15 | 15 | 15/15 (100.0%) |
| middle-garden-table | ask | 6 | 6 | 0/6 (0.0%) |
| middle-garden-table | invest | 6 | 6 | 6/6 (100.0%) |
| middle-garden-table | rest | 6 | 6 | 0/6 (0.0%) |
| middle-open-desk | ask | 13 | 13 | 0/13 (0.0%) |
| middle-open-desk | invest | 13 | 13 | 13/13 (100.0%) |
| middle-open-desk | rest | 13 | 13 | 0/13 (0.0%) |
| middle-rest-circle | boundaries | 11 | 11 | 0/11 (0.0%) |
| middle-rest-circle | rest | 11 | 11 | 11/11 (100.0%) |
| middle-rest-circle | walk | 11 | 11 | 0/11 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | invest | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 3 | 3 | 3/10 (30.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 7/10 (70.0%) |
| middle-seed-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | rest | 10 | 10 | 0/10 (0.0%) |
| middle-skill-exchange | study | 10 | 10 | 10/10 (100.0%) |
| middle-skill-exchange | teach | 10 | 10 | 0/10 (0.0%) |
| middle-support | ask | 12 | 12 | 0/12 (0.0%) |
| middle-support | invest | 12 | 12 | 12/12 (100.0%) |
| middle-support | rest | 12 | 12 | 0/12 (0.0%) |
| middle-support | shareShift | 11 | 11 | 0/12 (0.0%) |
| middle-turn | ask | 7 | 7 | 0/7 (0.0%) |
| middle-turn | invest | 7 | 7 | 7/7 (100.0%) |
| middle-turn | offline | 7 | 7 | 0/7 (0.0%) |
| middle-turn | rest | 7 | 7 | 0/7 (0.0%) |
| teen-direction | ask | 10 | 10 | 0/10 (0.0%) |
| teen-direction | invest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | leadWorkshop | 10 | 10 | 0/10 (0.0%) |
| teen-direction | offline | 10 | 10 | 0/10 (0.0%) |
| teen-direction | rest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | ask | 5 | 5 | 0/5 (0.0%) |
| teen-launch | invest | 5 | 5 | 5/5 (100.0%) |
| teen-launch | rest | 5 | 5 | 0/5 (0.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 32/32 (100.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 18 | 18 | 0/18 (0.0%) |
| teen-repair-table | invest | 18 | 18 | 18/18 (100.0%) |
| teen-repair-table | rest | 18 | 18 | 0/18 (0.0%) |
| teen-river-survey | join | 13 | 13 | 13/13 (100.0%) |
| teen-river-survey | lead | 7 | 7 | 0/13 (0.0%) |
| teen-river-survey | rest | 13 | 13 | 0/13 (0.0%) |
| teen-river-survey | seekGuide | 13 | 13 | 0/13 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 10 | 10 | 10/10 (100.0%) |
| teen-shared-room | privateRoom | 10 | 10 | 0/10 (0.0%) |
| teen-shared-room | rest | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | practice | 6 | 6 | 6/6 (100.0%) |
| teen-tool-library | rest | 6 | 6 | 0/6 (0.0%) |
| teen-tool-library | seekGuide | 6 | 6 | 0/6 (0.0%) |

相鄰相同行動類型：225/448 (50.2%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/31 (0.0%) | 0/31 (0.0%) | 0/42 (0.0%) |
| 財務安全 | 0/39 (0.0%) | 0/39 (0.0%) | 0/82 (0.0%) |
| 人際關係 | 0/455 (0.0%) | 0/455 (0.0%) | 0/953 (0.0%) |
| 技能 | 0/352 (0.0%) | 0/352 (0.0%) | 0/1249 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/43 (0.0%) | 0/43 (0.0%) | 0/43 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) |
| story.learning-route | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.care-network | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) |
| story.repair | 32/32 (100.0%) | 19/32 (59.4%) | 18/32 (56.2%) |
| story.kitchen | 20/32 (62.5%) | 15/32 (46.9%) | 7/32 (21.9%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 3/32 (9.4%) |
| story.nature | 25/32 (78.1%) | 22/32 (68.8%) | 15/32 (46.9%) |

## ken-2／求助優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 5/32 (15.6%) | 5/32 (15.6%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 12/96 (12.5%) | 12/60 (20.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 14/96 (14.6%) | 14/57 (24.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 55/96 (57.3%) | 19/96 (19.8%) | 19/55 (34.5%) | windmill-promise: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 18} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 8/96 (8.3%) | 8/89 (9.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 106/128 (82.8%) | 12/128 (9.4%) | 12/106 (11.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-tool-library | 17–32 | 109/128 (85.2%) | 9/128 (7.0%) | 9/109 (8.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 19} |
| teen-launch | 21–25 | 57/64 (89.1%) | 9/64 (14.1%) | 9/57 (15.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 7} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 49/128 (38.3%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 49} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 74/96 (77.1%) | 14/96 (14.6%) | 14/74 (18.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;one-shot&#x27;: 22} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 120/192 (62.5%) | 12/192 (6.2%) | 12/120 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 50} |
| adult-meal-circle | 25–59 | 133/192 (69.3%) | 14/192 (7.3%) | 14/133 (10.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 33} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 93/128 (72.7%) | 5/128 (3.9%) | 5/93 (5.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 4} |
| adult-broken-bicycle | 25–59 | 128/192 (66.7%) | 14/192 (7.3%) | 14/128 (10.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 39} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 140/160 (87.5%) | 11/160 (6.9%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 20} |
| middle-skill-exchange | 32–65 | 138/192 (71.9%) | 12/192 (6.2%) | 12/138 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 23} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 9/128 (7.0%) | 9/116 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 8/192 (4.2%) | 8/141 (5.7%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 21/160 (13.1%) | 4/160 (2.5%) | 4/21 (19.0%) | shared-care-contacts: 130/160 (81.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 130, &#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 9} |
| middle-rhythm | 59–72 | 86/96 (89.6%) | 10/96 (10.4%) | 10/86 (11.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 10} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 6/96 (6.2%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | recording-companion: 0/96 (0.0%); sharing-connection: 0/96 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 9} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 5 | 5 | 5/5 (100.0%) |
| adult-balance | invest | 5 | 5 | 0/5 (0.0%) |
| adult-balance | rest | 5 | 5 | 0/5 (0.0%) |
| adult-broken-bicycle | borrow | 14 | 14 | 14/14 (100.0%) |
| adult-broken-bicycle | repairTogether | 14 | 14 | 0/14 (0.0%) |
| adult-broken-bicycle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-care | ask | 32 | 32 | 32/32 (100.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 0/32 (0.0%) |
| adult-learning | ask | 6 | 6 | 6/6 (100.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 0/6 (0.0%) |
| adult-local-trail | lead | 0 | 0 | 0/12 (0.0%) |
| adult-local-trail | record | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | rest | 12 | 12 | 0/12 (0.0%) |
| adult-local-trail | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/14 (0.0%) |
| adult-meal-circle | rest | 14 | 14 | 0/14 (0.0%) |
| adult-meal-circle | seekGuide | 14 | 14 | 14/14 (100.0%) |
| adult-meal-circle | trial | 14 | 14 | 0/14 (0.0%) |
| adult-neighbor-market | ask | 4 | 4 | 4/4 (100.0%) |
| adult-neighbor-market | invest | 4 | 4 | 0/4 (0.0%) |
| adult-neighbor-market | rest | 4 | 4 | 0/4 (0.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 12/12 (100.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 32/32 (100.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 0/32 (0.0%) |
| child-interest | ask | 32 | 32 | 32/32 (100.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 0/32 (0.0%) |
| child-library-map | ask | 5 | 5 | 5/5 (100.0%) |
| child-library-map | invest | 5 | 5 | 0/5 (0.0%) |
| child-library-map | rest | 5 | 5 | 0/5 (0.0%) |
| child-quiet-stage | backstage | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | perform | 12 | 12 | 0/12 (0.0%) |
| child-quiet-stage | rest | 12 | 12 | 12/12 (100.0%) |
| child-rain-notebook | observe | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | rest | 14 | 14 | 0/14 (0.0%) |
| child-rain-notebook | seekGuide | 14 | 14 | 14/14 (100.0%) |
| child-transition | ask | 7 | 7 | 7/7 (100.0%) |
| child-transition | invest | 7 | 7 | 0/7 (0.0%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 19 | 19 | 19/19 (100.0%) |
| child-wind-team | invest | 19 | 19 | 0/19 (0.0%) |
| child-wind-team | rest | 19 | 19 | 0/19 (0.0%) |
| later-pass-on | ask | 6 | 6 | 6/6 (100.0%) |
| later-pass-on | invest | 6 | 6 | 0/6 (0.0%) |
| later-pass-on | rest | 6 | 6 | 0/6 (0.0%) |
| later-path-map | lead | 0 | 0 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 0/5 (0.0%) |
| later-path-map | seekGuide | 5 | 5 | 5/5 (100.0%) |
| later-path-map | shortWalk | 5 | 5 | 0/5 (0.0%) |
| later-reconnect | ask | 9 | 9 | 9/9 (100.0%) |
| later-reconnect | invest | 9 | 9 | 0/9 (0.0%) |
| later-reconnect | rest | 9 | 9 | 0/9 (0.0%) |
| later-review | ask | 32 | 32 | 32/32 (100.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 0/32 (0.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | lead | 0 | 0 | 0/6 (0.0%) |
| later-tool-stories | learnAgain | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | rest | 6 | 6 | 0/6 (0.0%) |
| later-tool-stories | seekGuide | 6 | 6 | 6/6 (100.0%) |
| later-voice-booth | ask | 7 | 7 | 7/7 (100.0%) |
| later-voice-booth | invest | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | rest | 7 | 7 | 0/7 (0.0%) |
| middle-friend-letter | rest | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 8 | 8 | 8/8 (100.0%) |
| middle-garden-table | invest | 8 | 8 | 0/8 (0.0%) |
| middle-garden-table | rest | 8 | 8 | 0/8 (0.0%) |
| middle-open-desk | ask | 4 | 4 | 4/4 (100.0%) |
| middle-open-desk | invest | 4 | 4 | 0/4 (0.0%) |
| middle-open-desk | rest | 4 | 4 | 0/4 (0.0%) |
| middle-rest-circle | boundaries | 14 | 14 | 14/14 (100.0%) |
| middle-rest-circle | rest | 14 | 14 | 0/14 (0.0%) |
| middle-rest-circle | walk | 14 | 14 | 0/14 (0.0%) |
| middle-rhythm | ask | 10 | 10 | 10/10 (100.0%) |
| middle-rhythm | invest | 10 | 10 | 0/10 (0.0%) |
| middle-rhythm | rest | 10 | 10 | 0/10 (0.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/11 (0.0%) |
| middle-seed-exchange | onePot | 11 | 11 | 0/11 (0.0%) |
| middle-seed-exchange | rest | 11 | 11 | 0/11 (0.0%) |
| middle-seed-exchange | seekGuide | 11 | 11 | 11/11 (100.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 9 | 9 | 9/9 (100.0%) |
| middle-support | invest | 9 | 9 | 0/9 (0.0%) |
| middle-support | rest | 9 | 9 | 0/9 (0.0%) |
| middle-support | shareShift | 2 | 2 | 0/9 (0.0%) |
| middle-turn | ask | 9 | 9 | 9/9 (100.0%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 0/9 (0.0%) |
| middle-turn | rest | 9 | 9 | 0/9 (0.0%) |
| teen-direction | ask | 8 | 8 | 8/8 (100.0%) |
| teen-direction | invest | 8 | 8 | 0/8 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 0/8 (0.0%) |
| teen-launch | ask | 9 | 9 | 9/9 (100.0%) |
| teen-launch | invest | 9 | 9 | 0/9 (0.0%) |
| teen-launch | rest | 9 | 9 | 0/9 (0.0%) |
| teen-project | ask | 32 | 32 | 32/32 (100.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 0/32 (0.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | seekGuide | 12 | 12 | 12/12 (100.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 14 | 14 | 0/14 (0.0%) |
| teen-shared-room | privateRoom | 14 | 14 | 0/14 (0.0%) |
| teen-shared-room | rest | 14 | 14 | 14/14 (100.0%) |
| teen-tool-library | practice | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | rest | 9 | 9 | 0/9 (0.0%) |
| teen-tool-library | seekGuide | 9 | 9 | 9/9 (100.0%) |

相鄰相同行動類型：360/448 (80.4%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/62 (0.0%) | 0/62 (0.0%) | 0/124 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/432 (0.0%) | 0/432 (0.0%) | 0/717 (0.0%) |
| 技能 | 0/404 (0.0%) | 0/404 (0.0%) | 0/404 (0.0%) |

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
| story.childhood-connection | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.repair | 25/32 (78.1%) | 15/32 (46.9%) | 9/32 (28.1%) |
| story.kitchen | 14/32 (43.8%) | 17/32 (53.1%) | 4/32 (12.5%) |
| story.garden | 16/32 (50.0%) | 11/32 (34.4%) | 2/32 (6.2%) |
| story.nature | 25/32 (78.1%) | 23/32 (71.9%) | 14/32 (43.8%) |

## ken-2／休息優先

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 12/32 (37.5%) | 12/32 (37.5%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 59/96 (61.5%) | 17/96 (17.7%) | 17/59 (28.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 17/96 (17.7%) | 17/57 (29.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | windmill-promise: 96/96 (100.0%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 96, &#x27;milestone-slot&#x27;: 32} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 8/96 (8.3%) | 8/89 (9.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 104/128 (81.2%) | 12/128 (9.4%) | 12/104 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 24} |
| teen-tool-library | 17–32 | 106/128 (82.8%) | 10/128 (7.8%) | 10/106 (9.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 22} |
| teen-launch | 21–25 | 56/64 (87.5%) | 10/64 (15.6%) | 10/56 (17.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 8} |
| teen-repair-table | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | made-a-project: 128/128 (100.0%); repair-practice: 128/128 (100.0%); 規則排除：{&#x27;condition:made-a-project&#x27;: 128, &#x27;condition:repair-practice&#x27;: 128} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 72/96 (75.0%) | 15/96 (15.6%) | 15/72 (20.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;one-shot&#x27;: 24} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 130/192 (67.7%) | 10/192 (5.2%) | 10/130 (7.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 37} |
| adult-meal-circle | 25–59 | 132/192 (68.8%) | 14/192 (7.3%) | 14/132 (10.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 35} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 100/160 (62.5%) | 10/160 (6.2%) | 10/100 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 15, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 7/128 (5.5%) | 7/92 (7.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 16/192 (8.3%) | 16/124 (12.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 100/160 (62.5%) | 5/160 (3.1%) | 5/100 (5.0%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 15} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 133/192 (69.3%) | 17/192 (8.9%) | 17/133 (12.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| middle-seed-exchange | 45–72 | 138/160 (86.2%) | 14/160 (8.8%) | 14/138 (10.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 22} |
| middle-skill-exchange | 32–65 | 137/192 (71.4%) | 12/192 (6.2%) | 12/137 (8.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| middle-turn | 45–59 | 83/96 (86.5%) | 10/96 (10.4%) | 10/83 (12.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;one-shot&#x27;: 13} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 15/160 (9.4%) | 15/140 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 117/128 (91.4%) | 10/128 (7.8%) | 10/117 (8.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 11} |
| middle-garden-table | 32–65 | 141/192 (73.4%) | 9/192 (4.7%) | 9/141 (6.4%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 20} |
| middle-open-desk | 45–72 | 0/160 (0.0%) | 0/160 (0.0%) | — (0/0) | shared-care-contacts: 160/160 (100.0%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 160} |
| middle-rhythm | 59–72 | 82/96 (85.4%) | 13/96 (13.5%) | 13/82 (15.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 9, &#x27;one-shot&#x27;: 14} |
| later-pass-on | 65–72 | 61/64 (95.3%) | 7/64 (10.9%) | 7/61 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 3} |
| later-shared-recipes | 59–72 | 87/96 (90.6%) | 7/96 (7.3%) | 7/87 (8.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 9} |
| later-tool-stories | 59–72 | 90/96 (93.8%) | 7/96 (7.3%) | 7/90 (7.8%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-voice-booth | 59–72 | 0/96 (0.0%) | 0/96 (0.0%) | — (0/0) | recording-companion: 0/96 (0.0%); sharing-connection: 96/96 (100.0%); 規則排除：{&#x27;condition:sharing-connection&#x27;: 96} |
| later-path-map | 59–72 | 91/96 (94.8%) | 4/96 (4.2%) | 4/91 (4.4%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;one-shot&#x27;: 5} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 7 | 7 | 0/7 (0.0%) |
| adult-balance | invest | 7 | 7 | 0/7 (0.0%) |
| adult-balance | rest | 7 | 7 | 7/7 (100.0%) |
| adult-broken-bicycle | borrow | 16 | 16 | 0/16 (0.0%) |
| adult-broken-bicycle | repairTogether | 16 | 16 | 0/16 (0.0%) |
| adult-broken-bicycle | rest | 16 | 16 | 16/16 (100.0%) |
| adult-care | ask | 32 | 32 | 0/32 (0.0%) |
| adult-care | invest | 32 | 32 | 0/32 (0.0%) |
| adult-care | rest | 32 | 32 | 32/32 (100.0%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 0/6 (0.0%) |
| adult-learning | offline | 6 | 6 | 0/6 (0.0%) |
| adult-learning | rest | 6 | 6 | 6/6 (100.0%) |
| adult-local-trail | lead | 0 | 0 | 0/10 (0.0%) |
| adult-local-trail | record | 10 | 10 | 0/10 (0.0%) |
| adult-local-trail | rest | 10 | 10 | 10/10 (100.0%) |
| adult-local-trail | seekGuide | 10 | 10 | 0/10 (0.0%) |
| adult-meal-circle | lead | 0 | 0 | 0/14 (0.0%) |
| adult-meal-circle | rest | 14 | 14 | 14/14 (100.0%) |
| adult-meal-circle | seekGuide | 14 | 14 | 0/14 (0.0%) |
| adult-meal-circle | trial | 14 | 14 | 0/14 (0.0%) |
| adult-neighbor-market | ask | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | invest | 5 | 5 | 0/5 (0.0%) |
| adult-neighbor-market | rest | 5 | 5 | 5/5 (100.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 0/12 (0.0%) |
| adult-repair-coop | lead | 0 | 0 | 0/12 (0.0%) |
| adult-repair-coop | rest | 12 | 12 | 12/12 (100.0%) |
| adult-repair-coop | seekGuide | 12 | 12 | 0/12 (0.0%) |
| adult-shift-offer | extraShift | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | predictable | 10 | 10 | 0/10 (0.0%) |
| adult-shift-offer | rest | 10 | 10 | 10/10 (100.0%) |
| child-friend | ask | 32 | 32 | 0/32 (0.0%) |
| child-friend | invest | 32 | 32 | 0/32 (0.0%) |
| child-friend | rest | 32 | 32 | 32/32 (100.0%) |
| child-interest | ask | 32 | 32 | 0/32 (0.0%) |
| child-interest | invest | 32 | 32 | 0/32 (0.0%) |
| child-interest | rest | 32 | 32 | 32/32 (100.0%) |
| child-library-map | ask | 12 | 12 | 0/12 (0.0%) |
| child-library-map | invest | 12 | 12 | 0/12 (0.0%) |
| child-library-map | rest | 12 | 12 | 12/12 (100.0%) |
| child-quiet-stage | backstage | 17 | 17 | 0/17 (0.0%) |
| child-quiet-stage | perform | 17 | 17 | 0/17 (0.0%) |
| child-quiet-stage | rest | 17 | 17 | 17/17 (100.0%) |
| child-rain-notebook | observe | 17 | 17 | 0/17 (0.0%) |
| child-rain-notebook | rest | 17 | 17 | 17/17 (100.0%) |
| child-rain-notebook | seekGuide | 17 | 17 | 0/17 (0.0%) |
| child-transition | ask | 8 | 8 | 0/8 (0.0%) |
| child-transition | invest | 8 | 8 | 0/8 (0.0%) |
| child-transition | rest | 8 | 8 | 8/8 (100.0%) |
| child-wind-team | ask | 0 | 0 | — (0/0) |
| child-wind-team | invest | 0 | 0 | — (0/0) |
| child-wind-team | rest | 0 | 0 | — (0/0) |
| later-pass-on | ask | 7 | 7 | 0/7 (0.0%) |
| later-pass-on | invest | 7 | 7 | 0/7 (0.0%) |
| later-pass-on | rest | 7 | 7 | 7/7 (100.0%) |
| later-path-map | lead | 0 | 0 | 0/4 (0.0%) |
| later-path-map | rest | 4 | 4 | 4/4 (100.0%) |
| later-path-map | seekGuide | 4 | 4 | 0/4 (0.0%) |
| later-path-map | shortWalk | 4 | 4 | 0/4 (0.0%) |
| later-reconnect | ask | 6 | 6 | 0/6 (0.0%) |
| later-reconnect | invest | 6 | 6 | 0/6 (0.0%) |
| later-reconnect | rest | 6 | 6 | 6/6 (100.0%) |
| later-review | ask | 32 | 32 | 0/32 (0.0%) |
| later-review | invest | 32 | 32 | 0/32 (0.0%) |
| later-review | rest | 32 | 32 | 32/32 (100.0%) |
| later-shared-recipes | cookOnce | 7 | 7 | 0/7 (0.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/7 (0.0%) |
| later-shared-recipes | rest | 7 | 7 | 7/7 (100.0%) |
| later-shared-recipes | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | lead | 0 | 0 | 0/7 (0.0%) |
| later-tool-stories | learnAgain | 7 | 7 | 0/7 (0.0%) |
| later-tool-stories | rest | 7 | 7 | 7/7 (100.0%) |
| later-tool-stories | seekGuide | 7 | 7 | 0/7 (0.0%) |
| later-voice-booth | ask | 0 | 0 | — (0/0) |
| later-voice-booth | invest | 0 | 0 | — (0/0) |
| later-voice-booth | rest | 0 | 0 | — (0/0) |
| middle-friend-letter | rest | 17 | 17 | 17/17 (100.0%) |
| middle-friend-letter | seekGuide | 17 | 17 | 0/17 (0.0%) |
| middle-friend-letter | write | 17 | 17 | 0/17 (0.0%) |
| middle-garden-table | ask | 9 | 9 | 0/9 (0.0%) |
| middle-garden-table | invest | 9 | 9 | 0/9 (0.0%) |
| middle-garden-table | rest | 9 | 9 | 9/9 (100.0%) |
| middle-open-desk | ask | 0 | 0 | — (0/0) |
| middle-open-desk | invest | 0 | 0 | — (0/0) |
| middle-open-desk | rest | 0 | 0 | — (0/0) |
| middle-rest-circle | boundaries | 15 | 15 | 0/15 (0.0%) |
| middle-rest-circle | rest | 15 | 15 | 15/15 (100.0%) |
| middle-rest-circle | walk | 15 | 15 | 0/15 (0.0%) |
| middle-rhythm | ask | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | invest | 13 | 13 | 0/13 (0.0%) |
| middle-rhythm | rest | 13 | 13 | 13/13 (100.0%) |
| middle-seed-exchange | lead | 0 | 0 | 0/14 (0.0%) |
| middle-seed-exchange | onePot | 14 | 14 | 0/14 (0.0%) |
| middle-seed-exchange | rest | 14 | 14 | 14/14 (100.0%) |
| middle-seed-exchange | seekGuide | 14 | 14 | 0/14 (0.0%) |
| middle-skill-exchange | rest | 12 | 12 | 12/12 (100.0%) |
| middle-skill-exchange | study | 12 | 12 | 0/12 (0.0%) |
| middle-skill-exchange | teach | 12 | 12 | 0/12 (0.0%) |
| middle-support | ask | 10 | 10 | 0/10 (0.0%) |
| middle-support | invest | 10 | 10 | 0/10 (0.0%) |
| middle-support | rest | 10 | 10 | 10/10 (100.0%) |
| middle-support | shareShift | 0 | 0 | 0/10 (0.0%) |
| middle-turn | ask | 10 | 10 | 0/10 (0.0%) |
| middle-turn | invest | 10 | 10 | 0/10 (0.0%) |
| middle-turn | offline | 10 | 10 | 0/10 (0.0%) |
| middle-turn | rest | 10 | 10 | 10/10 (100.0%) |
| teen-direction | ask | 8 | 8 | 0/8 (0.0%) |
| teen-direction | invest | 8 | 8 | 0/8 (0.0%) |
| teen-direction | leadWorkshop | 0 | 0 | 0/8 (0.0%) |
| teen-direction | offline | 8 | 8 | 0/8 (0.0%) |
| teen-direction | rest | 8 | 8 | 8/8 (100.0%) |
| teen-launch | ask | 10 | 10 | 0/10 (0.0%) |
| teen-launch | invest | 10 | 10 | 0/10 (0.0%) |
| teen-launch | rest | 10 | 10 | 10/10 (100.0%) |
| teen-project | ask | 32 | 32 | 0/32 (0.0%) |
| teen-project | invest | 32 | 32 | 0/32 (0.0%) |
| teen-project | offline | 32 | 32 | 0/32 (0.0%) |
| teen-project | rest | 32 | 32 | 32/32 (100.0%) |
| teen-repair-table | ask | 0 | 0 | — (0/0) |
| teen-repair-table | invest | 0 | 0 | — (0/0) |
| teen-repair-table | rest | 0 | 0 | — (0/0) |
| teen-river-survey | join | 12 | 12 | 0/12 (0.0%) |
| teen-river-survey | lead | 0 | 0 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 12/12 (100.0%) |
| teen-river-survey | seekGuide | 12 | 12 | 0/12 (0.0%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 15 | 15 | 0/15 (0.0%) |
| teen-shared-room | privateRoom | 15 | 15 | 0/15 (0.0%) |
| teen-shared-room | rest | 15 | 15 | 15/15 (100.0%) |
| teen-tool-library | practice | 10 | 10 | 0/10 (0.0%) |
| teen-tool-library | rest | 10 | 10 | 10/10 (100.0%) |
| teen-tool-library | seekGuide | 10 | 10 | 0/10 (0.0%) |

相鄰相同行動類型：448/448 (100.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/480 (0.0%) | 0/480 (0.0%) | 0/960 (0.0%) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | 0/271 (0.0%) | 0/271 (0.0%) | 0/271 (0.0%) |
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
| story.childhood-connection | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) |
| story.learning-route | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.care-network | 32/32 (100.0%) | 10/32 (31.2%) | 10/32 (31.2%) |
| story.repair | 0/32 (0.0%) | 15/32 (46.9%) | 0/32 (0.0%) |
| story.kitchen | 0/32 (0.0%) | 16/32 (50.0%) | 0/32 (0.0%) |
| story.garden | 0/32 (0.0%) | 14/32 (43.8%) | 0/32 (0.0%) |
| story.nature | 0/32 (0.0%) | 20/32 (62.5%) | 0/32 (0.0%) |

## ken-2／穩定亂數多樣選擇

### 事件出現與資格

| 事件 | 年齡 | 符合／機會 | 入選／機會 | 入選／符合 | 未符合原因（可重疊） |
| --- | --- | --- | --- | --- | --- |
| child-interest | 8–8 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-friend | 10–10 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| child-library-map | 12–12 | 32/32 (100.0%) | 6/32 (18.8%) | 6/32 (18.8%) | nearby-guide: 0/32 (0.0%); 規則排除：{} |
| child-quiet-stage | 12–17 | 60/96 (62.5%) | 13/96 (13.5%) | 13/60 (21.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 8} |
| child-rain-notebook | 12–17 | 57/96 (59.4%) | 15/96 (15.6%) | 15/57 (26.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 14} |
| child-transition | 12–12 | 32/32 (100.0%) | 7/32 (21.9%) | 7/32 (21.9%) | ; 規則排除：{} |
| child-wind-team | 12–17 | 33/96 (34.4%) | 14/96 (14.6%) | 14/33 (42.4%) | windmill-promise: 34/96 (35.4%); 規則排除：{&#x27;condition:windmill-promise&#x27;: 34, &#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 16} |
| teen-project | 13–13 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| teen-direction | 17–25 | 89/96 (92.7%) | 9/96 (9.4%) | 9/89 (10.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 7} |
| teen-river-survey | 17–32 | 104/128 (81.2%) | 12/128 (9.4%) | 12/104 (11.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 12, &#x27;one-shot&#x27;: 24} |
| teen-tool-library | 17–32 | 113/128 (88.3%) | 7/128 (5.5%) | 7/113 (6.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 15} |
| teen-launch | 21–25 | 58/64 (90.6%) | 7/64 (10.9%) | 7/58 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 6} |
| teen-repair-table | 17–32 | 49/128 (38.3%) | 7/128 (5.5%) | 7/49 (14.3%) | made-a-project: 64/128 (50.0%); repair-practice: 20/128 (15.6%); 規則排除：{&#x27;condition:made-a-project&#x27;: 64, &#x27;condition:repair-practice&#x27;: 20, &#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 15} |
| teen-shared-kitchen | 17–32 | 0/128 (0.0%) | 0/128 (0.0%) | — (0/0) | family-rotations: 128/128 (100.0%); kitchen-energy: 0/128 (0.0%); 規則排除：{&#x27;condition:family-rotations&#x27;: 128} |
| teen-shared-room | 21–32 | 78/96 (81.2%) | 11/96 (11.5%) | 11/78 (14.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;one-shot&#x27;: 18} |
| adult-learning | 25–45 | 90/128 (70.3%) | 6/128 (4.7%) | 6/90 (6.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 4, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 10} |
| adult-local-trail | 25–59 | 127/192 (66.1%) | 11/192 (5.7%) | 11/127 (8.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 41} |
| adult-meal-circle | 25–59 | 135/192 (70.3%) | 13/192 (6.8%) | 13/135 (9.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 31} |
| adult-repair-coop | 25–59 | 129/192 (67.2%) | 12/192 (6.2%) | 12/129 (9.3%) | ; 規則排除：{&#x27;cooldown&#x27;: 10, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 38} |
| adult-shift-offer | 25–52 | 103/160 (64.4%) | 10/160 (6.2%) | 10/103 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;exclusive-group&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 24} |
| adult-balance | 32–52 | 92/128 (71.9%) | 6/128 (4.7%) | 6/92 (6.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 5} |
| adult-broken-bicycle | 25–59 | 124/192 (64.6%) | 15/192 (7.8%) | 15/124 (12.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 13, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 44} |
| adult-neighbor-market | 25–52 | 103/160 (64.4%) | 4/160 (2.5%) | 4/103 (3.9%) | current-financial-room: 0/160 (0.0%); market-helper: 0/160 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;exclusive-group&#x27;: 24, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 11} |
| adult-care | 39–39 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |
| middle-friend-letter | 32–65 | 129/192 (67.2%) | 18/192 (9.4%) | 18/129 (14.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 11, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 36} |
| middle-seed-exchange | 45–72 | 143/160 (89.4%) | 10/160 (6.2%) | 10/143 (7.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 17} |
| middle-skill-exchange | 32–65 | 140/192 (72.9%) | 11/192 (5.7%) | 11/140 (7.9%) | ; 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 21} |
| middle-turn | 45–59 | 84/96 (87.5%) | 9/96 (9.4%) | 9/84 (10.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| middle-rest-circle | 45–72 | 140/160 (87.5%) | 14/160 (8.8%) | 14/140 (10.0%) | ; 規則排除：{&#x27;cooldown&#x27;: 20} |
| middle-support | 52–72 | 116/128 (90.6%) | 11/128 (8.6%) | 11/116 (9.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 12} |
| middle-garden-table | 32–65 | 137/192 (71.4%) | 9/192 (4.7%) | 9/137 (6.6%) | garden-energy: 0/192 (0.0%); 規則排除：{&#x27;cooldown&#x27;: 8, &#x27;milestone-slot&#x27;: 32, &#x27;one-shot&#x27;: 25} |
| middle-open-desk | 45–72 | 44/160 (27.5%) | 3/160 (1.9%) | 3/44 (6.8%) | shared-care-contacts: 106/160 (66.2%); 規則排除：{&#x27;condition:shared-care-contacts&#x27;: 106, &#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 10} |
| middle-rhythm | 59–72 | 84/96 (87.5%) | 11/96 (11.5%) | 11/84 (13.1%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 12} |
| later-pass-on | 65–72 | 62/64 (96.9%) | 6/64 (9.4%) | 6/62 (9.7%) | ; 規則排除：{&#x27;cooldown&#x27;: 2, &#x27;one-shot&#x27;: 2} |
| later-shared-recipes | 59–72 | 91/96 (94.8%) | 5/96 (5.2%) | 5/91 (5.5%) | ; 規則排除：{&#x27;cooldown&#x27;: 3, &#x27;one-shot&#x27;: 5} |
| later-tool-stories | 59–72 | 85/96 (88.5%) | 7/96 (7.3%) | 7/85 (8.2%) | ; 規則排除：{&#x27;cooldown&#x27;: 7, &#x27;one-shot&#x27;: 11} |
| later-voice-booth | 59–72 | 82/96 (85.4%) | 8/96 (8.3%) | 8/82 (9.8%) | recording-companion: 0/96 (0.0%); sharing-connection: 6/96 (6.2%); 規則排除：{&#x27;condition:sharing-connection&#x27;: 6, &#x27;cooldown&#x27;: 6, &#x27;one-shot&#x27;: 8} |
| later-path-map | 59–72 | 90/96 (93.8%) | 5/96 (5.2%) | 5/90 (5.6%) | ; 規則排除：{&#x27;cooldown&#x27;: 5, &#x27;one-shot&#x27;: 6} |
| later-reconnect | 72–72 | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) | ; 規則排除：{} |
| later-review | 80–80 | 32/32 (100.0%) | 32/32 (100.0%) | 32/32 (100.0%) | ; 規則排除：{} |

### 實際選項

| 事件 | 選項 | 提供 | 可行 | 提交／遇到事件 |
| --- | --- | --- | --- | --- |
| adult-balance | ask | 6 | 6 | 0/6 (0.0%) |
| adult-balance | invest | 6 | 6 | 4/6 (66.7%) |
| adult-balance | rest | 6 | 6 | 2/6 (33.3%) |
| adult-broken-bicycle | borrow | 15 | 15 | 7/15 (46.7%) |
| adult-broken-bicycle | repairTogether | 15 | 15 | 3/15 (20.0%) |
| adult-broken-bicycle | rest | 15 | 15 | 5/15 (33.3%) |
| adult-care | ask | 32 | 32 | 12/32 (37.5%) |
| adult-care | invest | 32 | 32 | 10/32 (31.2%) |
| adult-care | rest | 32 | 32 | 10/32 (31.2%) |
| adult-learning | ask | 6 | 6 | 0/6 (0.0%) |
| adult-learning | invest | 6 | 6 | 3/6 (50.0%) |
| adult-learning | offline | 6 | 6 | 1/6 (16.7%) |
| adult-learning | rest | 6 | 6 | 2/6 (33.3%) |
| adult-local-trail | lead | 2 | 2 | 0/11 (0.0%) |
| adult-local-trail | record | 11 | 11 | 6/11 (54.5%) |
| adult-local-trail | rest | 11 | 11 | 3/11 (27.3%) |
| adult-local-trail | seekGuide | 11 | 11 | 2/11 (18.2%) |
| adult-meal-circle | lead | 0 | 0 | 0/13 (0.0%) |
| adult-meal-circle | rest | 13 | 13 | 2/13 (15.4%) |
| adult-meal-circle | seekGuide | 13 | 13 | 6/13 (46.2%) |
| adult-meal-circle | trial | 13 | 13 | 5/13 (38.5%) |
| adult-neighbor-market | ask | 4 | 4 | 1/4 (25.0%) |
| adult-neighbor-market | invest | 4 | 4 | 2/4 (50.0%) |
| adult-neighbor-market | rest | 4 | 4 | 1/4 (25.0%) |
| adult-repair-coop | apprentice | 12 | 12 | 2/12 (16.7%) |
| adult-repair-coop | lead | 2 | 2 | 1/12 (8.3%) |
| adult-repair-coop | rest | 12 | 12 | 4/12 (33.3%) |
| adult-repair-coop | seekGuide | 12 | 12 | 5/12 (41.7%) |
| adult-shift-offer | extraShift | 10 | 10 | 5/10 (50.0%) |
| adult-shift-offer | predictable | 10 | 10 | 3/10 (30.0%) |
| adult-shift-offer | rest | 10 | 10 | 2/10 (20.0%) |
| child-friend | ask | 32 | 32 | 9/32 (28.1%) |
| child-friend | invest | 32 | 32 | 11/32 (34.4%) |
| child-friend | rest | 32 | 32 | 12/32 (37.5%) |
| child-interest | ask | 32 | 32 | 8/32 (25.0%) |
| child-interest | invest | 32 | 32 | 15/32 (46.9%) |
| child-interest | rest | 32 | 32 | 9/32 (28.1%) |
| child-library-map | ask | 6 | 6 | 1/6 (16.7%) |
| child-library-map | invest | 6 | 6 | 2/6 (33.3%) |
| child-library-map | rest | 6 | 6 | 3/6 (50.0%) |
| child-quiet-stage | backstage | 13 | 13 | 4/13 (30.8%) |
| child-quiet-stage | perform | 13 | 13 | 6/13 (46.2%) |
| child-quiet-stage | rest | 13 | 13 | 3/13 (23.1%) |
| child-rain-notebook | observe | 15 | 15 | 4/15 (26.7%) |
| child-rain-notebook | rest | 15 | 15 | 5/15 (33.3%) |
| child-rain-notebook | seekGuide | 15 | 15 | 6/15 (40.0%) |
| child-transition | ask | 7 | 7 | 2/7 (28.6%) |
| child-transition | invest | 7 | 7 | 5/7 (71.4%) |
| child-transition | rest | 7 | 7 | 0/7 (0.0%) |
| child-wind-team | ask | 14 | 14 | 5/14 (35.7%) |
| child-wind-team | invest | 14 | 14 | 0/14 (0.0%) |
| child-wind-team | rest | 14 | 14 | 9/14 (64.3%) |
| later-pass-on | ask | 6 | 6 | 1/6 (16.7%) |
| later-pass-on | invest | 6 | 6 | 3/6 (50.0%) |
| later-pass-on | rest | 6 | 6 | 2/6 (33.3%) |
| later-path-map | lead | 2 | 2 | 0/5 (0.0%) |
| later-path-map | rest | 5 | 5 | 4/5 (80.0%) |
| later-path-map | seekGuide | 5 | 5 | 0/5 (0.0%) |
| later-path-map | shortWalk | 5 | 5 | 1/5 (20.0%) |
| later-reconnect | ask | 8 | 8 | 1/8 (12.5%) |
| later-reconnect | invest | 8 | 8 | 4/8 (50.0%) |
| later-reconnect | rest | 8 | 8 | 3/8 (37.5%) |
| later-review | ask | 32 | 32 | 12/32 (37.5%) |
| later-review | invest | 32 | 32 | 6/32 (18.8%) |
| later-review | rest | 32 | 32 | 14/32 (43.8%) |
| later-shared-recipes | cookOnce | 5 | 5 | 2/5 (40.0%) |
| later-shared-recipes | lead | 0 | 0 | 0/5 (0.0%) |
| later-shared-recipes | rest | 5 | 5 | 1/5 (20.0%) |
| later-shared-recipes | seekGuide | 5 | 5 | 2/5 (40.0%) |
| later-tool-stories | lead | 4 | 4 | 3/7 (42.9%) |
| later-tool-stories | learnAgain | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | rest | 7 | 7 | 1/7 (14.3%) |
| later-tool-stories | seekGuide | 7 | 7 | 2/7 (28.6%) |
| later-voice-booth | ask | 8 | 8 | 3/8 (37.5%) |
| later-voice-booth | invest | 8 | 8 | 3/8 (37.5%) |
| later-voice-booth | rest | 8 | 8 | 2/8 (25.0%) |
| middle-friend-letter | rest | 18 | 18 | 5/18 (27.8%) |
| middle-friend-letter | seekGuide | 18 | 18 | 7/18 (38.9%) |
| middle-friend-letter | write | 18 | 18 | 6/18 (33.3%) |
| middle-garden-table | ask | 9 | 9 | 2/9 (22.2%) |
| middle-garden-table | invest | 9 | 9 | 4/9 (44.4%) |
| middle-garden-table | rest | 9 | 9 | 3/9 (33.3%) |
| middle-open-desk | ask | 3 | 3 | 1/3 (33.3%) |
| middle-open-desk | invest | 3 | 3 | 1/3 (33.3%) |
| middle-open-desk | rest | 3 | 3 | 1/3 (33.3%) |
| middle-rest-circle | boundaries | 14 | 14 | 2/14 (14.3%) |
| middle-rest-circle | rest | 14 | 14 | 6/14 (42.9%) |
| middle-rest-circle | walk | 14 | 14 | 6/14 (42.9%) |
| middle-rhythm | ask | 11 | 11 | 1/11 (9.1%) |
| middle-rhythm | invest | 11 | 11 | 3/11 (27.3%) |
| middle-rhythm | rest | 11 | 11 | 7/11 (63.6%) |
| middle-seed-exchange | lead | 2 | 2 | 0/10 (0.0%) |
| middle-seed-exchange | onePot | 10 | 10 | 5/10 (50.0%) |
| middle-seed-exchange | rest | 10 | 10 | 1/10 (10.0%) |
| middle-seed-exchange | seekGuide | 10 | 10 | 4/10 (40.0%) |
| middle-skill-exchange | rest | 11 | 11 | 4/11 (36.4%) |
| middle-skill-exchange | study | 11 | 11 | 1/11 (9.1%) |
| middle-skill-exchange | teach | 11 | 11 | 6/11 (54.5%) |
| middle-support | ask | 11 | 11 | 3/11 (27.3%) |
| middle-support | invest | 11 | 11 | 5/11 (45.5%) |
| middle-support | rest | 11 | 11 | 2/11 (18.2%) |
| middle-support | shareShift | 5 | 5 | 1/11 (9.1%) |
| middle-turn | ask | 9 | 9 | 3/9 (33.3%) |
| middle-turn | invest | 9 | 9 | 0/9 (0.0%) |
| middle-turn | offline | 9 | 9 | 4/9 (44.4%) |
| middle-turn | rest | 9 | 9 | 2/9 (22.2%) |
| teen-direction | ask | 9 | 9 | 1/9 (11.1%) |
| teen-direction | invest | 9 | 9 | 1/9 (11.1%) |
| teen-direction | leadWorkshop | 4 | 4 | 1/9 (11.1%) |
| teen-direction | offline | 9 | 9 | 1/9 (11.1%) |
| teen-direction | rest | 9 | 9 | 5/9 (55.6%) |
| teen-launch | ask | 7 | 7 | 2/7 (28.6%) |
| teen-launch | invest | 7 | 7 | 2/7 (28.6%) |
| teen-launch | rest | 7 | 7 | 3/7 (42.9%) |
| teen-project | ask | 32 | 32 | 6/32 (18.8%) |
| teen-project | invest | 32 | 32 | 7/32 (21.9%) |
| teen-project | offline | 32 | 32 | 9/32 (28.1%) |
| teen-project | rest | 32 | 32 | 10/32 (31.2%) |
| teen-repair-table | ask | 7 | 7 | 1/7 (14.3%) |
| teen-repair-table | invest | 7 | 7 | 3/7 (42.9%) |
| teen-repair-table | rest | 7 | 7 | 3/7 (42.9%) |
| teen-river-survey | join | 12 | 12 | 2/12 (16.7%) |
| teen-river-survey | lead | 1 | 1 | 0/12 (0.0%) |
| teen-river-survey | rest | 12 | 12 | 2/12 (16.7%) |
| teen-river-survey | seekGuide | 12 | 12 | 8/12 (66.7%) |
| teen-shared-kitchen | ask | 0 | 0 | — (0/0) |
| teen-shared-kitchen | invest | 0 | 0 | — (0/0) |
| teen-shared-kitchen | rest | 0 | 0 | — (0/0) |
| teen-shared-room | agreement | 11 | 11 | 3/11 (27.3%) |
| teen-shared-room | privateRoom | 11 | 11 | 6/11 (54.5%) |
| teen-shared-room | rest | 11 | 11 | 2/11 (18.2%) |
| teen-tool-library | practice | 7 | 7 | 1/7 (14.3%) |
| teen-tool-library | rest | 7 | 7 | 4/7 (57.1%) |
| teen-tool-library | seekGuide | 7 | 7 | 2/7 (28.6%) |

相鄰相同行動類型：112/448 (25.0%)（不是事件類型）。

### 封頂損失

當回合，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | 0/188 (0.0%) | 0/188 (0.0%) | 0/370 (0.0%) |
| 財務安全 | 0/20 (0.0%) | 0/20 (0.0%) | 0/51 (0.0%) |
| 人際關係 | 0/403 (0.0%) | 0/403 (0.0%) | 0/650 (0.0%) |
| 技能 | 0/245 (0.0%) | 0/245 (0.0%) | 0/566 (0.0%) |

延遲呼應／時間跳躍，觀測數 480。

| 資源 | 截斷／正淨增益 | 完全抵銷／正淨增益 | 損失／原淨增益點數 |
| --- | --- | --- | --- |
| 健康 | — (0/0) | — (0/0) | — (0/0) |
| 財務安全 | — (0/0) | — (0/0) | — (0/0) |
| 人際關係 | — (0/0) | — (0/0) | — (0/0) |
| 技能 | 0/10 (0.0%) | 0/10 (0.0%) | 0/10 (0.0%) |

### 故事鏈

| 規則 | 前因出現 | 後續有trace | 來源選擇吻合 |
| --- | --- | --- | --- |
| story.childhood-connection | 32/32 (100.0%) | 8/32 (25.0%) | 8/32 (25.0%) |
| story.learning-route | 32/32 (100.0%) | 9/32 (28.1%) | 9/32 (28.1%) |
| story.care-network | 32/32 (100.0%) | 11/32 (34.4%) | 11/32 (34.4%) |
| story.repair | 23/32 (71.9%) | 15/32 (46.9%) | 6/32 (18.8%) |
| story.kitchen | 14/32 (43.8%) | 15/32 (46.9%) | 3/32 (9.4%) |
| story.garden | 13/32 (40.6%) | 10/32 (31.2%) | 2/32 (6.2%) |
| story.nature | 21/32 (65.6%) | 22/32 (68.8%) | 11/32 (34.4%) |

## 同背景、同Seed、不同策略

| 家庭 | 策略一 | 策略二 | 配對數 | 事件距離中位數 | 故事距離中位數 |
| --- | --- | --- | --- | --- | --- |
| jpn-1 | 投入優先 | 求助優先 | 32 | 2.0 | 3.0 |
| jpn-1 | 投入優先 | 休息優先 | 32 | 3.0 | 4.0 |
| jpn-1 | 投入優先 | 穩定亂數多樣選擇 | 32 | 1.5 | 3.0 |
| jpn-1 | 求助優先 | 休息優先 | 32 | 1.0 | 1.0 |
| jpn-1 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 1.0 |
| jpn-1 | 休息優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 2.0 |
| jpn-2 | 投入優先 | 求助優先 | 32 | 2.0 | 3.0 |
| jpn-2 | 投入優先 | 休息優先 | 32 | 3.0 | 4.0 |
| jpn-2 | 投入優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 3.0 |
| jpn-2 | 求助優先 | 休息優先 | 32 | 1.0 | 2.0 |
| jpn-2 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 1.0 |
| jpn-2 | 休息優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 2.0 |
| usa-1 | 投入優先 | 求助優先 | 32 | 2.0 | 3.0 |
| usa-1 | 投入優先 | 休息優先 | 32 | 3.0 | 4.0 |
| usa-1 | 投入優先 | 穩定亂數多樣選擇 | 32 | 1.5 | 3.0 |
| usa-1 | 求助優先 | 休息優先 | 32 | 1.0 | 1.0 |
| usa-1 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 1.0 |
| usa-1 | 休息優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 2.0 |
| usa-2 | 投入優先 | 求助優先 | 32 | 2.0 | 3.0 |
| usa-2 | 投入優先 | 休息優先 | 32 | 3.0 | 4.0 |
| usa-2 | 投入優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 3.0 |
| usa-2 | 求助優先 | 休息優先 | 32 | 1.0 | 2.0 |
| usa-2 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 1.0 |
| usa-2 | 休息優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 2.0 |
| ind-1 | 投入優先 | 求助優先 | 32 | 2.0 | 3.0 |
| ind-1 | 投入優先 | 休息優先 | 32 | 3.0 | 4.0 |
| ind-1 | 投入優先 | 穩定亂數多樣選擇 | 32 | 1.5 | 3.0 |
| ind-1 | 求助優先 | 休息優先 | 32 | 1.0 | 1.0 |
| ind-1 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 1.0 |
| ind-1 | 休息優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 2.0 |
| ind-2 | 投入優先 | 求助優先 | 32 | 2.0 | 3.0 |
| ind-2 | 投入優先 | 休息優先 | 32 | 3.0 | 4.0 |
| ind-2 | 投入優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 3.0 |
| ind-2 | 求助優先 | 休息優先 | 32 | 1.0 | 2.0 |
| ind-2 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 1.0 |
| ind-2 | 休息優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 2.0 |
| ken-1 | 投入優先 | 求助優先 | 32 | 2.0 | 3.0 |
| ken-1 | 投入優先 | 休息優先 | 32 | 3.0 | 4.0 |
| ken-1 | 投入優先 | 穩定亂數多樣選擇 | 32 | 1.5 | 3.0 |
| ken-1 | 求助優先 | 休息優先 | 32 | 1.0 | 1.0 |
| ken-1 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 1.0 |
| ken-1 | 休息優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 2.0 |
| ken-2 | 投入優先 | 求助優先 | 32 | 2.0 | 3.0 |
| ken-2 | 投入優先 | 休息優先 | 32 | 3.0 | 4.0 |
| ken-2 | 投入優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 3.0 |
| ken-2 | 求助優先 | 休息優先 | 32 | 1.0 | 2.0 |
| ken-2 | 求助優先 | 穩定亂數多樣選擇 | 32 | 1.0 | 1.0 |
| ken-2 | 休息優先 | 穩定亂數多樣選擇 | 32 | 2.0 | 2.0 |

零觸發只代表本批次未觀察到；完整分布、逐步資源及多hook聚合截斷來源見同名JSON。實機、VoiceOver與兒少重玩意願仍未驗收。
