# LIFE-LOOP 動畫工作準則（MOTION.md）

> 狀態：**VW-01～03 已有獨立 Visual 程式與純函數證據，等待 Gameplay 接入與正式 UI 驗收**。沒有安裝外部依賴或複製上游程式碼。本文件是 Visual Agent 的專案動作規範；基於現有 `LifeCrossroads` 原創角色與資料邊界撰寫。  
> 適用工作：`docs/life-loop-10h/PLAN.md`、`SLICES.md` 的 VW-01～04，共最多 **2 Agent-hours**（不另加時）。  
> 唯一外部方法參考：`rossark0/rossark-motion-skill` @ [固定 Commit `9b20964e32f07f8ac7e2948cd175746fa4a7712f`](https://github.com/rossark0/rossark-motion-skill/tree/9b20964e32f07f8ac7e2948cd175746fa4a7712f)；Repo [MIT LICENSE](https://github.com/rossark0/rossark-motion-skill/blob/9b20964e32f07f8ac7e2948cd175746fa4a7712f/LICENSE)。外部發表日約 2026-10-22，仍屬新 Repo，須以本案實測而非星數作驗收。

## A. 先審核、再借鏡

閱讀順序：
1. 外部 `SKILL.md`（動作與效能原則）。
2. `MOTION.md`（平台共同概念）。
3. `templates/swiftui/Motion.swift`（loop/one-shot、`wave/flow/track/seeded`）。
4. `templates/swiftui/LiveFace.swift`（**僅確認圖層前提**；本次不直接使用）。
5. `LICENSE`（著作權聲明保留要求）。
6. 本案 `LifeCrossroads/App/StoryVisuals.swift` 與 `ProjectWorkshopView.swift`，`LifePresentation` 的 `ProjectMoment`、`LifeDomain` 的 `ConsequenceTrace`；項目可見的效果必須以已保存 trace 為依據。

外部 `SKILL.md` 的通用方法不是本專案的治理或產品要求。**本案規則優先：** 無生活排程、無新人生引擎、無未核准素材、無影響 RNG、保留台灣資料缺口、正式 App 可續玩、同 Seed 重播一致。不要在沒有審查的情況下執行上游 scripts、下載模型、添加 React Native／第三方執行依賴或採用它的 demo 圖像。

## B. 與原有素材的實際相容程度

| 本案素材／元素 | 是否能在2h內做 | 不該宣稱 |
| --- | --- | --- |
| `StoryPortrait`：由 `StoryCast` PNG 圖表裁切的完整沐沐 | **可**：整體上下呼吸、微幅重心、緩慢傾斜、跟著事件道具輕微挪動 | **不可**：已獨立眨眼、雙手揮舞、尾巴延遲/分段骨架 |
| `RiverCrossroads`／工作桌等場景與 repo-native shapes | **可**：樹葉擺動、水波、桌上道具出現、輕微前後景移動 | **不可**：對應真實國家文化或環境資源的寫實場景 |
| 13歲 `teen-project` 與 `ProjectMoment` | **可**：線上／紙本／求助／休息依已提交 choice/trace 單次顯示道具反應 | **不可**：因為動畫就代表作品已完成、已獲邀請或有未發生的老師協助 |
| 其他 39 歲、晚年等正式人生事件 | **可**：重用同一角色+世界容器與通用 trace 記憶符號 | **不可**：聲稱 40 個事件均已有專屬可動場景 |

如果圖片只有單層，優先使用整體細微變換，不進行不可信的眼白遮罩。要升級 `LiveFace`，須先有合法的眼白、瞳孔、眼皮、頭部等分層素材及對應 pivot，可在後續獨立 Slice 做，不佔這 10h。

## C. 本次推薦動作配方（僅設計起點，需視覺調整）

**只做一個有意義的主要動作＋最多兩種輕微待機循環**：

- **待機：** 整張沐沐 PNG 垂直變化 1–2 pt，週期約 3–5 秒；保持腳/地面陰影穩定，必要時把移動幅度再減半。
- **同場景人物：** 對彼此反應使用不同相位（不要全場一起點頭），有限度微傾斜約 1–2°；不插入憑空出現的幫助或人物關係。
- **場景生命感：** 葉子、淡水波或燈光任選一至兩種，不必每物件都動；重複元素的不同相位只用固定 index 的可重現裝飾數值（例如上游 `seeded(i)` 概念），**不要每幀抽 `random()`**。
- **事件邀請：** 角色由生活微動切到事件注意姿態，平順 ease，不瞬移；重大選擇時世界時間暫停，畫面不變成強迫倒數。
- **已保存後果：** 道具變化、已互動人物或故事記憶標記採 0.25–0.6 秒單次演出；只能從已發佈 `reflecting` trace 驅動。未曾成功保存，絕不可出現提交後道具與數值。
- **減少動態效果：** 待機循環停在有資訊的首幀；已發生結果直接顯示末幀。動畫不是資訊唯一載體，需保留文字與圖示。

## D. 播放控制（必須由 Gameplay 供時）

**動畫不是遊戲時間。** Gameplay 管 `WorldPlaybackController.presentationElapsedMs`，Visual 讀其時間與可用的視覺 DTO。

- `normal / fast`：只放大視覺播放速度，不修改 `LifeSession` 年齡、Seed、事件條件或資源。
- `pause / eventPaused / sheet / background / hidden`：應凍結於現有姿勢且停止不必要重繪，恢復後沿原相位平順續行。
- `skip`：直接讓可互動事件顯示，若是已完成結果才可以呈現對應 one-shot 末幀，絕不能略過需要玩家決定的事件。
- **源碼注意事項：** 上游 `LoopClock(paused:)` 在 paused 時把 `t`設為0，恢復時使用從最初 `start` 累積的原始壁鐘時間。**不可直接用該行為作本案 pause/resume。** 由 Gameplay 提供可續接的累積 elapsed + scene token，或在同等回歸證據下包裝修正。Visual 不另開一個獨立持續運轉的時鐘。
- **效率：** 每個可見場景單一 `TimelineView` 或已整合時鐘，子物件由純計算生成變換；不要每隻角色、每片葉子、每個 emoji 分別獨立建立每幀時計。未顯示畫面不持續運算。

## E. VW-01～04 驗收矩陣（全部算在 Visual 2h）

| Slice | 產物 | 至少需要的證據 |
| --- | --- | --- |
| VW-01 0.50h | 固定 Skill/SHA/MIT 清單、角色貼圖限制及 SwiftUI 大場景 Preview | 來源連結、是否引入 code 的聲明、尺寸畫面 |
| VW-02 0.75h | 主角微動 + 至少一種環境循環/互動狀態 | loop 0/25/50/100% 定點、pause→resume/1×→3× 不跳格；無每幀 game random |
| VW-03 0.50h | 至少兩種不同 trace-backed 的單次已發生反應，Reduced Motion 靜態 | 相同 Seed 不同 choice；已保存 trace、未發生 support/luck 不出現 |
| VW-04 0.25h | 真正 UI 截圖／若不增工可選短動畫影片、清單及交接 | 截圖 SHA、eventID/choiceID/age、實際 Session、來源 Commit |

**核心失敗時：** 如果 2h 不足以做可靠的動畫計時器，直接回退到 SwiftUI 內建小幅 `offset/rotationEffect` 與少數 stage changes，並保留中止原因。不能犧牲 Playable LIFE-LOOP 的事件／存檔安全來追求漂亮動作。

## F. 來源採用紀錄模板（由執行 Agent 填寫）

| 欄位 | 目前規劃狀態 |
| --- | --- |
| External repo / commit | rossark0/rossark-motion-skill / `9b20964e32f07f8ac7e2948cd175746fa4a7712f` |
| License | MIT；本規劃未複製上游原始碼 |
| 預計研究檔 | `SKILL.md`, `MOTION.md`, `templates/swiftui/Motion.swift`, `LiveFace.swift`, `LICENSE` |
| 真正複製/修改檔 | **NONE — 無直接代碼引入**；自行撰寫 `App/LifeWorldMotion.swift`、`App/LifeWorldScene.swift`，未套用 `LoopClock`／`OneShotClock`／`LiveFace` |
| Notices／版權保留 | 未複製上游程式碼，沒有新增 App 授權依賴；研究紀錄保留原 LICENSE 全文、Copyright (c) 2026 rossark0、固定 commit 與五份檔案 Git blob SHA |
| Demo PNG／MP4 使用 | **NONE** |
| 是否開始實作、Simulator 測試 | **YES／實作在獨立 Visual branch；本 Agent 未建立 Simulator**。純 motion 定點/接縫驗證已執行，正式 App UI 由 Gameplay 整合後執行 |
| 人工／實機／兒少測試 | **未驗收** |

執行 Agent 若真的複製任何上游程式碼，必須更新這張表與可追溯 notices；若只參考算法概念，自行實作的程式碼不自動等同抄用，但仍要保留研究來源。

## G. 本輪實際接入（Visual B，10H v1.1）

共享契約為 Gameplay 的 `6f5e3c1`，正式 API 為 `LifeWorldScene(frame: LifeWorldFrame, motion: PresentationMotionFrame)`。主流程仍由 A 擁有；Visual 不修改 Domain、Data、Persistence、主流程、Package 或 Xcode。

- `LifeWorldMotion` 是原創、無時鐘的純函數。4秒循環；沐沐整張 PNG 上下幅度1.25pt、整體微傾0.65度；配角使用固定 index 的四分之一相位差。河水裝飾水平幅度2pt。沒有手腳／眼睛／頭／尾巴骨架，沒有重畫水獺。
- `elapsedMs` 完全由 Gameplay 提供，`frozen` 不被轉成0。暫停／背景／遮蔽停鐘由 A 管理；Visual 沒有 Timer、Date、TimelineView、onAppear 啟動或每幀 RNG。相同 elapsed 會得到相同姿勢，View 本身沒有累積時間狀態。
- 單次已發生 token 使用 `phaseElapsedMs` 的480ms ease-out並持有末幀，只有 frame 與 motion 都是 committedOutcome、來源為目前事件／年齡、`isOccurred == true` 才使用。已提交 token 首幀 opacity 最低0.45，立即暫停也不會把事實藏成透明；這項針對 frozen-first-frame 的修正有正式 helper 回歸斷言。求助沒有推定成功，pendingClue 只能是問號時鐘，資源圖示是混合變化收據，沒有一律上升的正向訊號。
- Reduced Motion：角色與環境顯示完整的首幀，已提交結果顯示末幀；沒有做選擇時不會呈現未來結果。AX最大文字隱藏純裝飾，人物、自然中文 accessibility 及所有 worldChanges.caption 仍保留；詳細文字由 A 的正式事件／後果畫面提供。
- `river`／`workshop`／`community` 都重用既有虛構河畔素材，工作桌及長椅為 SwiftUI shapes；13歲道具只表示已選擇的活動／記憶，不宣稱家庭擁有設備或作品已完成。角色五齡直接使用 `StoryPortrait.protagonist(age:)`。

來源證據：`artifacts/evidence/life-loop/visual-motion/rossark-source-audit.json`。純函數驗證器直接編譯正式 `LifeWorldMotion.swift`，結果在 `loop-and-arrival-results.json`；0/1000/2000/4000ms、首尾接縫、Reduced Motion、無效時間及一次性480ms末幀均有定點核對。這不取代 A 的暫停／調速／背景時鐘整合測試，也不宣稱正式 UI、實機或兒少已驗收。

離線視覺證據：`render-world.py` 以正式 SwiftUI Scene、真實 `LifeSession`／投影與既有PNG輸出18張固定影格；macOS離線資產adapter只替換讀圖方式，不是Simulator／檔案保存證據。`offline-render-manifest.json` 保留8／13／39歲、同日本家庭Seed0的四種13歲選擇、Reduced Motion對照、立即凍結的結果首幀、90pt緊湊高度、來源與每張SHA。一般與Reduced各選擇的事實欄位完全一致；rest沒有憑空產生互動或運氣。

初次嚴格像素相等檢查失敗，原始結果保留在 `rendered-seam-strict-attempt.json`：首尾6748／1740000色通道相差1／255；**同樣t=0重畫的control也有7135通道相差最多1／255**。`rendered-seam-results.json` 分開報告 exactPixelEquality=false 與1個8-bit量化級、少於1%通道的有界視覺檢查；不宣稱ImageRenderer逐像素決定論。正式motion函數的首尾姿態相同，Gameplay的人生／時鐘決定論仍須獨立驗證。
