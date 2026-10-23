# VA-03A｜阿澄（水獺）表情、姿勢與情境演出規格 v1.1

> 本文件是 **3–4 小時 Visual Gameplay Loop 的必讀、必驗收規格**，不是要額外做完一套動畫系統。
> 適用：`Gavin0099/life-crossroads`，`codex/ui-event-first-v1` 起點，13 歲紙橋事件 `bridge`。

## 1. 體驗目標與範圍

讓 10–15 歲玩家能**不靠讀取結果文字**，辨識「這是同一個阿澄」、「他目前的感受／姿勢有變」、「找朋友與找老師造成不同的現場互動」。視覺不能代替 Domain 解釋真正的因果，不能暗示找老師一定正確或合作一定成功。

- 本輪只做 **1 名主角（13 歲水獺阿澄）、1 位既有朋友（野兔）、1 個紙橋事件與 2 種後果**。
- 最小動作語彙：**4 種表情 + 3 種姿勢**，不是 4×3=12 張大型插畫。先建立可重用的表情／姿勢素材或分層合成，實際可玩的狀態至少 3 組。
- 教師不是新的主角：可用現有背景人物、手、影子、剪影，或清楚可辨識的材料清單／工具卡來表達協助；不要為了這個 MVP 追加整套教師角色。
- 不做 Live2D、完整骨架動畫、全套 20 年齡造型、額外事件、付費 API、大量姿勢排列。

## 2. 一致性鎖定（不可漂移）

阿澄：栗棕毛、乳白橢圓口鼻與喉部、小圓耳、**寬而漸細的水獺尾**、角色**右眉上短乳白記號**、青綠外衫／米白上衣／深藍褲／赭黃斜背包；13 歲、身形約五頭身、非嬰兒 Q 版。左右一律指**角色自己的左右**。情緒改變不得改毛色、臉型、眼睛大小、耳尾形狀、穿著配色、攝影角度或場景光源。

朋友野兔：灰棕毛、長耳、角色左耳小缺口、鐵鏽色外衫、深色褲。兩角色不可交換服裝錨、物種特徵或被改成既有動畫 IP。

### 4 種表情（表情 ID 穩定）

| ID | 玩家看到的可辨識線索 | 不應做的事 |
|---|---|---|
| `neutral` | 平視、自然嘴型、放鬆眉眼 | 不必永遠微笑 |
| `thinking` | 眉毛微收、視線朝橋或工具、嘴角克制 | 不用黑色問號貼紙代替表情 |
| `hopeful` | 眼神較亮、輕微笑意、臉頰放鬆 | 不誇張成 Q 版燦笑或成功保證 |
| `tired` | 眼瞼稍低、肩頸放鬆、輕微疲態 | 不等於受傷、生病、失敗或道德負評 |

### 3 種姿勢（姿勢 ID 穩定）

| ID | 可視差異 | 使用情境 |
|---|---|---|
| `idle` | 身體重心安定，雙手自然停留，視線落在紙橋 | 事件初始／觀察 |
| `collaborating` | 身體朝工作桌前傾，手實際參與紙橋模型，眼神與野兔互動 | 找朋友一起試做 |
| `asking` | 身體轉向求助對象，一手示意或接過工具清單，姿態有互動方向 | 找老師尋求支援 |

**視覺核准條件**：不是用文字標籤「思考／開心」假裝人物變化；至少眼睛／眉嘴、手臂與重心或與道具接觸位置之一發生真實可見變化。四種表情與三種姿勢需出現在實際渲染的 contact sheet／表情姿勢預覽圖中；正式流程至少使用下表三組狀態。

## 3. 紙橋事件表演表（Acting Map）

| 狀態 ID | Domain / fixture 來源 | 阿澄表情 × 姿勢 | 同畫面動作／道具 | 不可宣稱 |
|---|---|---|---|---|
| `bridge-initial` | `EventViewDTO.id=bridge`，尚未選擇 | `thinking` × `idle` | 紙橋材料散放，野兔看向工作桌；選項仍清楚可點 | 不偷顯示任何未發生的後果 |
| `bridge-team` | `OptionViewDTO.id=bridge-team` | `hopeful` × `collaborating` | 阿澄和野兔一起扶著試做的橋，保留「發現需要重做」的模糊性 | 不宣稱作品已完成、比賽獲獎 |
| `bridge-help` | `OptionViewDTO.id=bridge-help` | `neutral` 或 `hopeful` × `asking` | 阿澄向老師或材料清單伸手、看向準備路線；保留「尚未報名」的狀態 | 不把求助描寫為已完成紙橋 |

不可選的 `bridge-buy`、缺 Outcome、缺 Trace：不得切換到假的「成功」表情或把不存在的狀態寫進歷史。

`neutral` 與 `tired` 至少在**表情測試面板**中清晰可見；若時間不足，`tired` 不強制插入不相干的劇情。對 15 歲事件若沒有新製作的演出資產，必須保留清楚、可用的 fallback，不可拿 13 歲的結果立繪當新事件已發生事實。

## 4. SwiftUI 呈現與互動約束

- 建議新增純 Presentation 模型 `ActorEmotion`、`ActorPose`、`ActorStageVisualState`（名稱可隨既有命名調整）；從**當前 eventID + selected optionID + UI screen** 映射，不改 `LifeCrossroads/Domain`、`Data` 或規則引擎。
- 需要保證同一個角色從事件、選擇結果到下一畫面身分一致；不要讓同一狀態在不同渲染批次長出新服裝、新尾巴、新臉。
- 技術實作優先順序：**重用原圖／局部拆層 → 既有 SwiftUI 圖層或少量補圖 → 必要時最少量的新生成圖**。表情層可替換，姿勢層可改，但不要把七種狀態全塞進單一烘字圖片。
- 背景持續存在；角色、道具、反應隨選擇改變。任何插畫不可烘入選項文案、數值或國籍。
- 如要動畫，只用 150–350ms 的淡入、輕微位移或換姿勢過場；尊重 `@Environment(\.accessibilityReduceMotion)`，開啟時即時切換到**相同最終狀態**，不延遲按鈕、結果或 Trace。不可用動畫掩蓋只有文字變化。
- 角色狀態給 VoiceOver 一段有意義的描述，例如「阿澄正與野兔協作測試紙橋」，不是只讀表情代碼；裝飾層應避免重複朗讀。
- 角色設定與 UI 配色必須同光源、同輪廓語彙；容許少量筆觸／材質不規則以降低樣板感，但不可用過度紋理犧牲文字對比與觸控目標。

## 5. 照片與資料證據（必交付）

除 `LOOP_PLAN.md` 原有五張實機尺寸 Simulator 截圖外，新增：

1. `artifacts/ui-loop/final/06-acting-contact-sheet.png`：**從實際 UI／候選素材渲染**的預覽，至少可辨識 4 表情和 3 姿勢；可用 SwiftUI Debug/Preview 拼成一張。不是單純文字表格，也不可放無關的生成圖假裝已接入。
2. `docs/ui-loop/ACTING_IMPLEMENTATION.md`：記錄表情／姿勢的 Swift 型別或映射位置、資產路徑、套用哪個事件與選項、fallback、Reduce Motion 的行為、測試名稱、尚未做的部分。
3. `artifacts/ui-loop/acting-state-proof.json`：結構須符合本文件第 6 節。截圖均來自 Simulator；不得以渲染 mockup 替代實際 App 螢幕。
4. XCTest 至少新增 `testActingBranchesAreVisuallyDistinct` 和 `testReducedMotionPreservesOutcome` 或語意相同測試。前者須確認**實際選擇後對應不同角色狀態**，而非只比較文字；後者須開啟減少動態效果仍能到達正確結果。兩種 Simulator 各跑完整 UI 測試（既有 8 項 + 至少 2 項）。
5. 若使用任何新生成圖，留下來源、prompt、版本與 hash，標 `candidate`／`approved_for_app=false`，不進行商用權利核准宣告。

## 6. `acting-state-proof.json` 介面契約

```json
{
  "schema_version": "1.1",
  "event_id": "bridge",
  "character_id": "otter-acheng",
  "expression_catalog": ["neutral", "thinking", "hopeful", "tired"],
  "pose_catalog": ["idle", "collaborating", "asking"],
  "contact_sheet": "artifacts/ui-loop/final/06-acting-contact-sheet.png",
  "states": {
    "bridge-initial": {
      "expression_id": "thinking", "pose_id": "idle",
      "prop_id": "paper-bridge-materials",
      "screenshot": "artifacts/ui-loop/final/01-home.png"
    },
    "bridge-team": {
      "expression_id": "hopeful", "pose_id": "collaborating",
      "prop_id": "paper-bridge-prototype",
      "screenshot": "artifacts/ui-loop/final/02-friend-outcome.png"
    },
    "bridge-help": {
      "expression_id": "neutral", "pose_id": "asking",
      "prop_id": "borrow-tools-list",
      "screenshot": "artifacts/ui-loop/final/03-teacher-outcome.png"
    }
  },
  "reduced_motion_test": "testReducedMotionPreservesOutcome"
}
```

這是**目標 schema 範例**，不是現有成果。Runner 僅能檢查檔案結構、列舉 ID、路徑與圖片位元差異；**只有 Critic 親眼檢視圖片才能確認表情、姿勢與場景是否真的可辨識**。圖片 SHA 不同本身**不等於**視覺後果不同。

## 7. Critic 必問的反方問題

1. 忽略所有選項文字，三張主流程圖是否仍看得出角色處於不同動作／情緒？
2. 尾巴、耳缺口、右眉小白記號、斜背包是否保持同一人？圖形有沒有多手、多尾、漂移比例？
3. 「找老師」是不是偷畫成已成功交出作品？「找朋友」是不是把需要重做改畫成完全勝利？
4. 表情是不是像表情貼紙、用文字標籤冒充演出，或直接套用固定笑臉？
5. 4 表情／3 姿勢是否能從 contact sheet 看清楚，而且跟真正 SwiftUI 畫面是同一套素材／狀態？
6. iPhone SE 3、Dynamic Type、Reduce Motion 與 VoiceOver 能否正常做出選擇並辨識狀態？

若答不出或看不到 PNG，必須標為 `NOT_VERIFIED` 或 `PARTIAL`，不能因 build PASS 就聲稱表情／動作系統完成。
