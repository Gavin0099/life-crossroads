# Life Crossroads｜4 小時 Visual Gameplay + Acting Agent Loop v1.1

適用專案：`Gavin0099/life-crossroads`
基準分支：`codex/ui-event-first-v1`（已查核的歷史 HEAD：`1771c57`）
工作分支：執行器從上述遠端分支建立**全新獨立 worktree／分支**；不變更原工作目錄。

## 目標與範圍

唯一核心目標：把目前「深藍背景＋同形卡片＋88×64 插圖」的決策頁，改成具有**角色、空間、選擇和後果演出**的 SwiftUI 可玩垂直切片。沿用現有 13 歲「紙橋」事件、現有事件與 Outcome fixture、原始四動物角色設定及可追溯素材。保留 `EventFirstFlow`／UI 操作語意。

四小時只能合理期待：**一個事件、一個主角（水獺）、一位朋友（野兔）、兩條選擇路線、兩種結果演出，以及整套對照截圖**。

**VA-03A 表演系統已納入本輪必要交付**：阿澄 4 種可辨識表情、3 種可辨識姿勢（重用組合，不是製作 12 張完整插畫），可玩的初始／朋友／老師三狀態、兩種不同選項的場景反應，支援 Reduce Motion。詳細身分錨、狀態 ID、證據格式和測試契約見 [`CHARACTER_ACTING_SPEC.md`](CHARACTER_ACTING_SPEC.md)。不得宣稱完成四個角色 × 五階段、八國與 50–70 事件的正式美術。

## 參考工具／技能

- OpenAI Codex non-interactive：<https://learn.chatgpt.com/docs/non-interactive-mode>。使用 `codex exec --sandbox workspace-write`；不使用 `--yolo` 或不受限的全權模式。
- OpenAI ImageGen：<https://github.com/openai/skills/blob/main/skills/.system/imagegen/SKILL.md>。先確認 agent 確實可用內建工具；**不**在失敗時默默切成收費 API。
- iOS 原生視覺 Skill：<https://github.com/tn/ios-interface-design>。供 SwiftUI 排版／配色／輔助使用；不是遊戲美術的現成解答。
- UI UX Pro Max：<https://github.com/nextlevelbuilder/ui-ux-pro-max-skill>。可參考 SwiftUI 指引、配色與 UX，但不可當自動品質證明。
- Snapshot Testing：<https://github.com/pointfreeco/swift-snapshot-testing>。有明確必要時才評估新增測試相依，既有 XCTest + screenshots 可以先用。
- Claude Code Ralph Loop：<https://github.com/anthropics/claude-plugins-official/blob/main/plugins/ralph-loop/README.md>。替代執行器；需要使用 `--max-iterations` 與停止訊號，不能無限跑。

先讀 Repo 既有 `AGENTS.md`、`PLAN.md`、`docs/visual`、`docs/ui`，以實際 repo 規則優先；**每一輪也必讀本套件 `CHARACTER_ACTING_SPEC.md`**。先重用 repo 既有角色設定，最多 3 組生成／局部編修的候選試驗，不能為湊滿表情數量浪費整個時間箱。

## Slice / 時間箱（硬上限 4 小時；3 小時模式則按優先級縮短）

| 時間預算 | Slice | 交付 |
|---|---|---|
| 0–25m | VA-01 美術審計與 style lock | Baseline、角色與 UI 配色衝突、不可變角色身分錨、4–6 個 tokens |
| 25–85m | VA-02 Scene-led SwiftUI | 工作室場景、阿澄與野兔位置、清楚的紙橋／決策入口及 safe area |
| 85–145m | **VA-03A 表情與姿勢系統** | **4 表情 + 3 姿勢**同角色預覽圖、3 組實際演出映射，控制新素材數量 |
| 145–195m | VA-03B 兩條路線／輕動效 | 朋友合作、老師支援兩種不同可見反應；Reduce Motion 同結果，不改 Domain |
| 195–225m | VA-04 自動批評／修正 | 兩 Simulator、放大字與 Reduce Motion 測試；Critic 反方檢查表情與姿勢可辨識 |
| 225–240m | VA-05 收斂與交接 | 最終截圖、acting proof、驗證收據、Before/After、獨立分支交接 |

前期設計／後期測試可以交錯；只要每輪都有可觀測成果。迭代次數由執行器限制，建議 6 輪 Builder + 最多 3 輪獨立 Critic。**3 小時模式優先縮短動畫／打磨，不得刪掉兩條路線的可見差異、表情姿勢基本證據或必要測試。** 時間耗盡或受限條件觸發就停止，不得偽稱 PASS。

## 美術方向（方向性 brief，不是強制視覺結果）

- 風格：溫暖、有生活痕跡、帶些冒險感的 2D 角色場景；不是 3D 商品卡、SaaS 後台、厚重繪本分頁。
- 配色：從既有 `assets/characters`、`assets/concepts/style-A`、`style-B` 中提取調和的色彩，再建立 `Surface/Ink/Accent/Scene/Status` tokens。避免接近黑藍＋螢光綠＋純白卡片的未整合對比。不得用顏色為國家／人生貼上好壞標籤。
- 主角：水獺外觀固定栗棕色、奶油色吻喉、小圓耳、寬漸細尾、右眉短白記號；野兔長耳、左耳缺口、鐵鏽色外衫；角色／國籍無關。
- 視覺：一個連續的工作室／紙橋環境＋前景角色＋選項 panel；畫面具不對稱節奏，而非每項等大的白色圓角卡。插畫不要烘文字；UI 由 SwiftUI 繪出。
- **角色表演**：阿澄需有 `neutral`／`thinking`／`hopeful`／`tired` 四表情與 `idle`／`collaborating`／`asking` 三姿勢，兩選項須映射不同角色／道具狀態；不得只換字幕或貼表情符號。詳細表演節奏在 `CHARACTER_ACTING_SPEC.md`。
- 演出：必要時加入 150–350ms 的輕量位移或淡入；支援 Reduce Motion 並保留完全相同的最終結果。不要拿粒子特效掩蓋空洞互動。

## 封閉式品質 Gate

**功能 Gate**：現有 fixture 選項可選／不可選、不同後果、原因不足不虛構、比較頁帶入所選項、事件推進、回顧、返回都正常。Domain/Data/Package 不變。

**視覺 Gate**：
- 5 秒內可辨識角色、正在發生的事件、下一個主要操作（**仍須真人驗證**；AI 評分不等於人測）。
- iPhone 17 與窄螢幕 iPhone SE 3 上，選項可捲到且可點；固定 CTA 不遮住任何內容。
- **表情姿勢 Gate**：實際畫面至少展示事件初始、找朋友、找老師三組可見狀態；同一個阿澄的面部、手、重心或道具接觸要看得出差異；四表情、三姿勢由 `06-acting-contact-sheet.png` 呈現。
- 至少有兩種視覺上可區別的選擇後果，不是只換文字、圖示或背景色。
- 角色比例、耳尾、衣著錨、配色、光源有連續性，沒有多手、多尾、臉部飄移、AI 文字幻覺。
- 不使用 8 張幾乎相同的生成角色圖；只保留通過的必要素材。
- 圖片有 provenance、prompt、審核旗標 `approved_for_app=false`；沒有人工商用授權審核不得自動轉為正式素材。
- 如沒有能力直接讀取畫面，明確標記「視覺觀察未驗證」，不可僅憑測試通過聲稱視覺 PASS。

**工程 Gate**：
- Swift build + 既有 UI flow test；**至少新增兩項 UI tests**：選項分支對應的角色／姿勢／道具狀態（不可只比文字），及 Reduce Motion 下相同後果；兩個 Simulator 應各有至少 10 項測試通過。
- XCTest／Simulator 兩裝置、最大字與 VoiceOver 基本結構檢查（如真實語音巡覽不可執行須明示）。
- Git diff `--check`、無未授權的檔案變更、保存失敗紀錄與修正後結果。
- `artifacts/ui-loop/acting-state-proof.json` 必須用機器可讀格式列出表情、姿勢、三狀態與真實截圖；無法從截圖辨識則不能標成視覺 PASS。
- 每一輪存下 Problem / Hypothesis / Edit / Evidence / Next step，避免漫無目的重畫。

## 權限與停止條件

- 可修改獨立原型、`docs/ui-loop`、`assets` 下版本化候選與 `artifacts/ui-loop`；**不修改** `LifeCrossroads/Domain`、`LifeCrossroads/Data`、`Package.swift`、正式 App 或其他 worktree。
- 不自動 merge main、不上架、不直接改 PR #1/#2、不下載未核准模型／新增付費 API、不處理私密客戶資料、不關閉治理。遇到權限提示按當前環境規則停止或收斂，不能繞過。
- 2 個連續 Critic 循環沒有可驗證改善：停止重複生成，留下最佳版本與阻塞項。
- 生成工具不可用：先重組已有場景素材與 SwiftUI compositing，標示未完成新 artwork，不自動使用 API 付費 fallback。
- 時間到、Codex 額度／認證受限、環境工具缺失、測試卡住時：停止，交付可核實的部分完成成果；絕不自稱通過。

## 最終檔案契約

- `docs/ui-loop/STYLE_GUIDE.md` — 一套採用的 tokens、色彩來源、避免 AI 感規則。
- `docs/ui-loop/PROGRESS.md` — 每輪改動及 reviewer 的 P0/P1／修正紀錄。
- `docs/ui-loop/ACTING_IMPLEMENTATION.md` — 角色表演實作對照、fallback、減少動態效果與測試清單。
- `docs/ui-loop/FINAL_REVIEW.md` — 差異截圖索引、風險、未解項與唯一人類 Review Gate。
- `artifacts/ui-loop/final/01-home.png`
- `artifacts/ui-loop/final/02-friend-outcome.png`
- `artifacts/ui-loop/final/03-teacher-outcome.png`
- `artifacts/ui-loop/final/04-narrow.png`
- `artifacts/ui-loop/final/05-large-type.png`
- `artifacts/ui-loop/final/06-acting-contact-sheet.png` — 同一角色 4 表情＋3 姿勢的實際渲染表（非文字清單）。
- `artifacts/ui-loop/acting-state-proof.json` — eventID/optionID/表情／姿勢／道具／截圖對照。
- `artifacts/ui-loop/verification.json` — build / UI tests / Domain tests / visual-review / acting_state / license 的證據與狀態，記錄測試日誌位置。

圖片缺少時不得以空白檔案佔位。PNG 截圖由 Simulator 真實擷取。支援一次看完「前／後」的圖庫。

## 執行注意

本套件的 Python 啟動器**只會在使用者自己的 Mac 執行**；ChatGPT 對話本身不會持續操作 Mac 四小時。啟動後 Codex 受其帳號用量、環境權限、授權工具與 Xcode 可用性影響。4 小時是最多執行時間，不是保證品質或保證耗滿四小時。
