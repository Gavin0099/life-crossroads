# born-somewhere 指定版本研究

研究日期：2026-10-23。用途：形成《人生岔路》RNG-01～04 的獨立設計與測試要求。
本次透過 GitHub connector 實讀指定版本的程式與證據文件，並查閱原作官方條款；未執行第三方遊戲的批次測試，未將其程式、劇情、資料庫或素材匯入本 repo。

## 版本與來源

| 項目 | 核對值 |
| --- | --- |
| Repository | `rollroyces/born-somewhere`，第三方專案，不是原作官方程式庫 |
| 指定提交 | [`5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34`](https://github.com/rollroyces/born-somewhere/commit/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34) |
| 提交時間 | 2026-10-23 03:55:33 UTC |
| `app.js` blob | `e881282f0661099b3dafd82dbc19c6311f314aac`；6,448 行 |
| `README.md` blob | `5fbd043471992007d49ba2aeb61f66b3acebe989` |
| `LICENSE` blob | `4c31a0d0b013028013ece782f2945309de89c52c` |
| `evidence/v5.62-event-dedup.md` blob | `7c8fc1433b20999b77070527d7f4e02be327bc87` |
| `evidence/v5.85-decision-reachability.md` blob | `2b060afdae5d9d3e0e7cfd7ab9aae93623b62d47` |

以下程式連結固定於完整 SHA；不以會變動的 `main` 作為此次判斷依據。這份研究沒有宣稱該 SHA 仍是上游最新版本。

## 五種機制與採用邊界

| 機制 | 指定版本的實際做法 | 可採用概念與應避免之處 |
| --- | --- | --- |
| 加權出生 | `chooseCountry()` 依出生數或人口建立權重；出生數缺值會退到人口，再退到 1；使用全域亂數。[L936–952](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/app.js#L936-L952) | 抽樣模式與資料品質分開。出生數／人口混用不能宣稱為真實出生分布。《人生岔路》先限於已支援情境，完整出生分布資料另行驗證。 |
| 年齡與權重事件池 | `generateYearlyEvent()` 按年齡及年度焦點建立候選，再做權重抽選。[L2292–2378](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/app.js#L2292-L2378) | 年齡窗、資格條件、權重分開定義；每個事件有穩定語意 ID。權重是遊戲設計假設，不能冒充現實事件發生率。 |
| 條件式事件與排序偏差 | `tryTriggerDecision()` 排除已決策事件，對各事件執行 `chance()`，再從通過者均勻選一個；不再命中第一個就返回。[L812–846](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/app.js#L812-L846) | 先形成完整候選集合可避免 first-hit 壓制。但此實作仍按陣列消耗全域亂數，不能證明固定 Seed 的重排不變。逐項機率通過後均勻選取也不等同單一加權抽選；本作採自己的明確分布與 KeyedRandom 契約。 |
| 冷卻與去重 | 決策間隔至少 4 年，其他中斷間隔至少 2 年；年度背景事件分一次性與可重複，耗盡時回傳無事件。一次性背景事件以英文顯示文字作為記憶鍵。[L800–824](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/app.js#L800-L824)、[L2361–2378](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/app.js#L2361-L2378) | 明訂 once／repeat／cooldown／mutex，不直接沿用其間隔常數。以 ID 記錄歷史，顯示文案改動不應重置去重。空池須明確處理，不能偷偷重抽已耗盡事件。 |
| 終生狀態與里程碑 | `milestoneEvents()` 在年齡節點更新教育、就業與家庭，後續條件依賴這些狀態；`tick()` 另做年度狀態演化。[L1589–1775](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/app.js#L1589-L1775)、[L1875–1914](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/app.js#L1875-L1914) | 測試前段狀態是否真的能到達後段資格；效果必須是明確型別，經本作 resolver 留下 trace。其教育、健康、家庭及財務機率與敏感內容不作為本作規格或資料。 |

## 去重紀錄的工程經驗

[v5.62 證據文件](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/evidence/v5.62-event-dedup.md) 將重複問題分成無歷史的事件抽樣、未排除既有狀態、耗盡候選又退回原池三類。文件也記錄某些事件最初被錯分為可重複，實測後才改為一次性。

可採用的要求是「重複必須有內容上的理由」，並驗證存檔往返後仍保留發生次數與時間。該文件因 JavaScript `Set` 的 JSON 序列化限制改用陣列；此限制不直接適用 Swift，Codable `Set` 或陣列皆可，仍須測試續玩行為。

## 600 段人生／23 種事件的證據界線

[v5.85 文件](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/evidence/v5.85-decision-reachability.md) 自述：16 國共 600 段人生，每年呼叫真實 `tick()` 與決策派發、自動回答事件，24 種中觀察到 23 種。文件指向測試 build `b24a1a4`；`5bd0bf4` 是新增該證據文件的提交。

這是上游作者的量測報告，本次沒有重跑。文件沒有提供固定 Seed 清單、16 國名稱、逐局輸出或可直接執行的完整 harness。未出現事件被解釋為條件狹窄，這不是該事件可達的獨立證明；本作須以定向 fixture 加上一般批次覆蓋驗證。它另指出條件門檻落在實際狀態分布之外、親屬狀態與年齡窗不重疊，說明只檢查語法或單獨 predicate 不足以證明人生流程可達性。

## 文字推導效果：存在定義，不等於執行證據

[`applyEventEffects()` L2382–2398](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/app.js#L2382-L2398) 確實依顯示文字關鍵字改變狀態。但在此次讀取的完整 `app.js` 中只有該函式定義，找不到呼叫；同版本 `index.html` 亦沒有呼叫。年度主流程對回傳事件的處理是加入 log，[L1905–1912](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/app.js#L1905-L1912)。因此不能宣稱該函式的文字效果已在實際年度路徑執行。

本作仍應避免以顯示文字決定規則，且需測試真正公開入口：入選事件、玩家選擇、狀態改變、後續資格與 ConsequenceTrace 必須連得起來，不能只測到未被接線的函式。

## 授權聲明並不一致

第三方 [LICENSE](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/LICENSE) 標為 MIT；其 [README](https://github.com/rollroyces/born-somewhere/blob/5bd0bf4b74ddfdd6f426b6cf5d674604bfe72a34/README.md) 自稱移植原作，並把原作稱為 CC BY 4.0。原作[官方條款](https://1in8b.life/en/terms/)（此次查閱有效日期 2026-10-23）卻保留程式、文字及圖片的權利，並將可自由另作的通用概念與這些作品內容分開。

這些聲明不能互相替代，也不足以確認第三方專案所含全部內容的權利來源。本作只取通用排程問題與驗證經驗，自行撰寫 Swift、事件及素材；不複製或翻譯第三方程式、劇情、資料庫與圖片。這是本次採用邊界，不是對其授權效力或商用權利的法律結論。

## 對本作 RNG 驗證的要求

- RNG-01：條件均有通過／拒絕與邊界 fixture；狹窄條件用定向人生證明可達。
- RNG-02：測固定 Seed 重播、候選排列置換、其他亂數用途不干擾、冷卻邊界、互斥、一次性及存檔續玩。加入「不合資格」候選應不變；加入新合資格候選會改變分布，不承諾原結果保持。
- RNG-03：由公開流程驗證人物 fact／後續選項／延遲效果真的改變；每項已執行效果對應實際 trace，不以文字補上因果。
- RNG-04：保存固定 Seed、國家家庭與策略、catalog／director 版本；分別計數 eligible、selected、resolved，列出一次性重複、死路、完成率及決策數。「資格從未到達」與「有資格但未抽中」分開報告。

現有 P1 的八國、16 家庭、50～70 原創事件及每局 12～18 個重要決策目標維持。這份研究不代表內容量、真人試玩、實機或發布驗收完成。
