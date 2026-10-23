# Life Crossroads / 人生岔路 — Visual Agent 計畫 v0.1

- 日期：2026-10-23
- 狀態：交付另一個 AI Agent 的執行規格；**非已完成設計或美術**
- 專案：`Gavin0099/life-crossroads`
- 建議 Branch：`codex/lc-visual-design`
- 建議 Worktree：獨立於 LC-01～LC-07 的既有工作目錄
- 文件建議併入路徑：`docs/visual/VISUAL_PLAN.md`

## 1. 與遊戲本體的關係

Visual Agent 與主產品 Agent 平行工作，不修改 LC-01／LC-02 的資料、國家、家庭、機率、決策、存檔或 ConsequenceTrace 計算。

主專案 P1 目標不變：8 國、16 家庭情境、50～70 個原創事件、五階段完整人生、每局 10～15 分鐘／12～18 個重大選擇；跨國同選擇、同背景改選與後果解釋必須清楚可見。LC-02 第一次可玩驗收為四國完整人生，不能以靜態美術 Demo 取代。

Visual Agent 負責：兒少視覺定位、原創擬人化動物角色、五階段年齡造型、共用情境美術、UI 規格、SwiftUI UI Mock／Preview、圖像產製管線及美術驗收證據。

**不負責**：人生結果規則、真實國家指標、家庭聯合分布、教育效果主張、即時 AI 劇情或圖像、後端、App Store 提交。跨界需求只提契約變更建議，不直接改動 Domain。

## 2. 受眾與美術核心假設

- 主要測試：10～12 歲、13～15 歲兩群；低年級將來另做適配。
- 美術形式：原創的**擬人化動物**、2D 故事冒險，溫暖但不幼兒化；這是待驗證候選，不是已經被研究證明的最佳形式。
- 角色外觀**不與國籍綁定**；同一角色可以在不同國家人生重生。動物品種不影響智力、成功率、壽命等人生演算。
- 避免「國家＝特定動物」「貧困＝髒亂」「某國＝落後」等刻板化構圖；各國具多元家庭與可行的支持路徑。
- 兒少適切：避免血腥、自傷細節、性暗示、恐怖驚嚇、羞辱性失敗圖像；生活困境以尊嚴、選擇與支持呈現。
- 標示及解釋：可用的國家差異必須與實際資料／明示假設對應，不能靠繪畫暗示不存在的統計因果。

## 3. 最重要的 UX 命題

畫面應幫孩子依序理解：

`我在哪個環境 → 我有什麼資源與限制 → 我能做哪些選擇 → 當下怎麼了 → 幾年後怎麼了 → 為什麼 → 若重新選會怎樣`

拒絕把介面做成：教育報表、成人理財 Dashboard、長篇逐字閱讀測驗、讓玩家看不出自己選擇影響的純插畫網站。

### 3.1 需要設計的九種狀態

1. 首頁／開始一生：遊戲感、明確開始、續玩位置。
2. 動物化身選擇：3 種原創角色；**不得與國家綁定**。
3. 出生／成長背景：國家、家庭及來源／假設標示，避免國家評分。
4. 五階段人生地圖：童年、青少年、青年、中年、晚年，簡明可回顧。
5. 事件決策：情緒／角色／限時資源／2～3 個有吸引力的選項／可行性及成本。
6. 立即回饋：發生了什麼，不把好壞縮成紅綠或總分。
7. 「為什麼」：選擇、環境、支持、運氣中**僅顯示實際參與**的因素，能連回 ConsequenceTrace。
8. 跨國同選擇比較：小螢幕建議上下兩張卡，比較成本、支持與路徑，不排行國家。
9. 分岔與晚年回顧：過去一致、改選後差異可視化；保留原局紀錄。

### 3.2 SwiftUI 架構邊界

- 使用真正的 SwiftUI View、文字、按鈕、圖表、VoiceOver 語意；AI 不生成圖片中的按鈕或中文字。
- 初期建 `VisualDemoModels` / `PreviewFixtures` 做樣例，不在 UI Mock 中硬編碼人生機率。
- Model-to-View 合約以 Protocol + DTO 草案交主 Agent 審核，與 Domain 的實際介面對齊由整合 PR 完成。
- 可使用 Assets Catalog 的 PNG；小圖示優先 SF Symbols / SwiftUI Shapes／自有向量，不為每顆 icon 產一張點陣圖。
- 支援 Dynamic Type、VoiceOver、Reduce Motion、單手直向操作；資訊不能僅靠色彩或動畫傳達。

## 4. 藝術方向與角色系統

### 4.1 先比較兩套方向，不大量出圖

- **A：敘事冒險插畫**：數位水粉／手繪質感、明快表情、清晰剪影、場景層次。
- **B：現代 2D 遊戲美術**：圖形輪廓更清楚、色塊與材質節制、能兼顧 13～15 歲。
- 相同角色、事件、手機尺寸各做同內容對照；另以極小人類角色對照確認動物是否妨礙對真實人生的理解。不要把外部遊戲的角色照搬。
- 比較標準：初見吸引力、情緒閱讀、選項理解、13～15 歲是否覺得幼稚、可量產的一致性。

### 4.2 角色 Bible

角色候選為 3 種原創動物化身（例：水獺、兔子、狗；類別可依比較證據微調）。

每角色需定義：正側面與 3/4 頭身比例、耳尾輪廓、眼形、固定辨識記號、色票、五階段成長變化、衣著規則、五種表情、不能漂移的特徵、負面生成條件。

每一個動物化身都可以出現在全部八國。不可將動物物種設定成國家能力差異的原因。

### 4.3 場景 Bible

採**通用人生階段場景＋有來源與人工覆核的情境物件層**，而非 8 國 × 70 事件各畫一張完整插畫。

先建立童年、青少年、青年、中年、晚年五類共用場景；再配置家庭、社區、學校、工作與照顧責任等情境元件。各國的生活環境描寫由情境資料、文化查核決定，不使用刻板印象當變體。

## 5. 最小可交付美術包（支援 LC-02）

- 兩套風格板與同事件畫面 A/B；一套選定 Art Direction Bible。
- 3 種原創動物角色概念；至少 **1 種主角**完成 5 階段一致性示範及 5 種表情，其餘角色先完成角色表，不強迫一次量產全部年齡 × 表情組合。
- 五個人生階段共用背景的至少各一個可用場景樣板；其中四國背景以可替換物件呈現，不宣稱沒有證據的在地情況。
- 九種 UI 狀態的 wireframe／screen spec；至少事件、後果、跨國比較、分岔回顧的 SwiftUI Preview 可互動（Mock 資料）。
- 可重現的素材 Manifest（含生成提示、模型、版本、來源、商用條款、人工審核）、透明去背及轉檔腳本。
- 最小裝置截圖：窄螢幕與常見 iPhone 尺寸，兩年齡組的閱讀與理解回饋。

不把第一批圖當成全部 8 國、16 家庭、50～70 事件已完成。素材設計必須**可擴充**到 P1 全量，但大量產出應在角色／風格鎖定後。

## 6. 圖片生產流程

`故事／國家情境 brief → 鎖定角色與場景 Bible → 寫入 prompt packet → 產出候選 → 人工視覺與兒少內容檢查 → 一致性／文化檢查 → 局部修正 → 去背與素材切層 → asset manifest → Xcode Assets Catalog → 實機／Simulator 視覺 QA`

### 6.1 每張正式素材的機讀 Manifest 建議欄位

`asset_id`, `role`, `character_id`, `life_stage`, `emotion`, `scene_id`, `country_context_id`, `width`, `height`, `has_alpha`, `source_type`, `generator`, `model_name`, `model_version`, `model_license`, `prompt_path`, `reference_asset_ids`, `workflow_version`, `input_hashes`, `output_sha256`, `review_child_safety`, `review_visual_consistency`, `review_cultural_context`, `review_licensing`, `approved_for_app`.

- 若服務不提供 seed，填 `null` 並記錄工具版本及人工選稿，不聲稱像素可重現。
- 來源、許可或審核不明的資產 **不得標記 approved_for_app=true**。
- 不可把未授權角色、受版權保護的遊戲 UI、原作《80億分之1》的圖像當可重用資產。
- 不上傳真實未成年人的照片作為參考；使用自創角色和經授權參照。
- 所有正式素材必須提供圖像本體與 prompt／來源紀錄，而不只是報告「已生成」。

## 7. 與主 Agent 的協作契約

| 邊界 | 主 Agent（LC-xx） | Visual Agent（LV-xx） |
| --- | --- | --- |
| 國家／家庭資料 | 唯一資料與規則真實來源 | 呈現與語意清晰度 |
| Simulation/Decision/Trace | 可編譯、可測試的演算 | 定義 UI 需要的 DTO 欄位並提 PR |
| Core Swift 檔案 | 主要修改者 | **禁止直接修改** |
| SwiftUI 畫面與 Preview | 審核接線介面 | 主要製作與驗收 |
| 素材／prompt／manifest | 使用及版本對齊 | 主要產出與來源稽核 |
| 故事內容 | 原創事件語意與結果 | 分鏡、美術與資訊分層 |

- 每片以獨立 branch / worktree / PR，不直接碰 `main`；既有兩筆本機提交仍由主 Agent 處理。
- 若主 Repo 還未 push，Visual Agent 應在已有真實基線的環境建 worktree；不可自行重建另一套不相容專案。
- 不私自導入第三方大套件、外部 API、付費服務或模型下載；有必要先記錄用途、授權、硬體成本及可回退方案。
- 等主 Agent 接受 View DTO 契約後才接真實 Domain 資料。

## 8. 品質 Gates

**LV-00/LV-01 方向 Gate**：角色是同一身分、兩組年齡適切、畫面有遊戲感、未把國籍人格化或等級化，實際截圖而非只交文字描述。

**角色一致性 Gate**：同一角色跨 5 年齡狀態仍能憑輪廓、耳尾、面部辨識；不得有多肢、服裝無解漂移、過度幼兒化等明顯問題。

**UX Gate**：孩子能找出當下決策成本、後續影響與原因；即使不看動畫與不辨紅綠色仍能理解。

**素材 Gate**：全部已採用圖片有來源、模型使用方式與許可審查；符合透明度、解析度與 Xcode Asset Catalog 要求；不把探索圖混進正式資產。

**整合 Gate**：SwiftUI Preview 在假資料上可互動；真實演算尚未接入時，不宣稱 LC-02 遊戲可玩或已完成實機驗收。

## 9. 外部參考（查閱於 2026-10-23）

- OpenAI imagegen Skill：https://github.com/openai/skills/blob/main/skills/.system/imagegen/SKILL.md
- Picture Book Wizard：https://github.com/kart-io/picture-skills
- StoryDiffusion：https://github.com/HVision-NKU/StoryDiffusion
- Krita AI Diffusion：https://github.com/Acly/krita-ai-diffusion
- ComfyUI：https://github.com/comfy-org/ComfyUI
- rembg：https://github.com/danielgatis/rembg
- UNICEF RITEC：https://www.unicef.org/childrightsandbusiness/reports/ritec-game-design-features-childrens-well-being-card-deck
- Apple App Review：https://developer.apple.com/app-store/review/guidelines/
