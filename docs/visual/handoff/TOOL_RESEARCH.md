# Life Crossroads — 兒少遊戲圖片生成 Skill／Repo 查核 v0.1

日期：2026-10-23。此為公開資料與 README／授權頁查核，不表示已在本機安裝、跑圖、通過品質或完成商用法律審查。

## 立即推薦

**主路線**：可用的內建 ImageGen 工具 + 版本化提示詞 + Character/Scene Bible + 人工選稿與局部修正 + rembg（如必要）+ SwiftUI 元件化 UI。

**擴充備案**：Krita AI Diffusion；需要大量可重複出圖才用 ComfyUI、StoryDiffusion／IP-Adapter。`SKILL.md` 是工作指引，不是生成模型；請先確認 Agent 所在環境有可用繪圖執行工具。

## 工具比較

### 1. OpenAI / skills / imagegen — 第一順位
- https://github.com/openai/skills/blob/main/skills/.system/imagegen/SKILL.md
- 提供插畫、角色、sprite、UI mock、透明去背及編修等流程；預設內建 image_gen 路徑，CLI 為明確要求時的備援，且需 API Key。
- 優點：適合 Codex agent 指令化、可記錄 prompt、選稿及來源；避免不必要本機 GPU 安裝。
- 風險：實際繪圖能力取決於 Agent 工具；Skill 本身不保證角色跨圖一致、兒少安全與商用權利。
- 判斷：**採用流程**；生成器和權限需要 LV-00 驗證。

### 2. kart-io / picture-skills — 借鑑角色一致性規範
- https://github.com/kart-io/picture-skills
- README：18 種視覺風格、12 種場景、3–12 歲內容調整、CCLP 角色一致性提示；README 標示 MIT。
- 優點：角色鎖定、場景模板及 prompt schema 適合轉成遊戲角色 Bible。
- 風險：設計面向繪本且多為低年齡，不能直接替代 13～15 歲的吸引力／UI 規範；CCLP 不是一致性保證。
- 判斷：**只參考方法**，先審 SKILL.md／腳本與依賴再考慮安裝。

### 3. unliftedq / draw-a-picturebook — 部分適合，但不直接採用
- https://github.com/unliftedq/skills/blob/main/skills/draw-a-picturebook/SKILL.md
- 優點：角色、場景 Bible、分鏡、每張圖片 prompt 落地，可借鑑流程。
- 主要不相容：預設**把字嵌入每張繪本圖片**，而本專案應由 SwiftUI 顯示可在地化、可 VoiceOver 的文字與互動；目標也不是 PDF 繪本。
- 判斷：**僅採 Bible/分鏡方式**，不執行整套生成繪本。

### 4. HVision-NKU / StoryDiffusion — 角色一致性候選
- https://github.com/HVision-NKU/StoryDiffusion
- 官方方法用 consistent self-attention 產生較長序列的角色連續圖片，官方 LICENSE 是 Apache 2.0。
- 優點：探索相同角色在不同年齡／場景的視覺連續性。
- 風險：需考量相依模型授權、相容性、硬體、對動物臉的表現；並非保證年齡與服飾一致。
- 判斷：**只在 LV-02 圖片一致性不理想時 A/B 測試**。

### 5. Acly / krita-ai-diffusion — 修圖候選
- https://github.com/Acly/krita-ai-diffusion
- 支援 inpaint、ControlNet、參考圖、分區、圖層及 ComfyUI backend；官方 repo 是 GPL v3。
- 優點：小區域修補、修正表情、服裝及背景，能避免每次重畫整張圖。
- 風險：本機建置和模型下載成本，plugin 授權與底層模型授權分開；不要把 plugin 程式碼直接複製進 iOS app。
- 判斷：**編修優先備案**。

### 6. Comfy-Org / ComfyUI — 大量圖產製備案
- https://github.com/comfy-org/ComfyUI
- Node graph、workflow 與 API，可用於批量生成與固定流程；repo 為 GPL-3.0。
- 優點：批量輸出、可記錄工作流版本，適合正式內容量擴張。
- 風險：維護工作流、模型相依及執行環境的成本；GPU／記憶體未實測，不能預設 Mac mini 可順暢跑所有模型。
- 判斷：**有需求再引入，不是 P1 前提**。

### 7. cubiq / ComfyUI_IPAdapter_plus — 參考圖一致性備案
- https://github.com/cubiq/ComfyUI_IPAdapter_plus
- 以參考圖支援角色或風格條件。作者 2025-04-14 公告 repository 轉 maintenance-only。
- 優點：可能改善角色與風格偏移；有 workflow examples。
- 風險：維護模式、模型適配與授權需逐項查；不建議作唯一依賴。
- 判斷：**研究用途／替代方案，不放第一順位**。

### 8. danielgatis / rembg — 角色去背
- https://github.com/danielgatis/rembg
- repo MIT，可輸出透明背景；README 特別提醒**所用模型**可能需要額外商用授權（例如 BRIA RMBG-2.0）。
- 判斷：**可做輔助後處理**，但需在 asset manifest 紀錄去背模型授權。

### 9. InvokeAI / InvokeAI — 另一套本地 UI 編修工具
- https://github.com/invoke-ai/InvokeAI
- 有 layer-based canvas、節點工作流與局部編修，官方提供 Apple Silicon macOS 版本。
- 風險：導入它與 ComfyUI+Krita 是替代選型，不要兩套都花時間搭；官方專案內可能有多個授權，逐檔查核。
- 判斷：**LV-00 比較後擇一，不重複投入**。

## 模型授權陷阱

- https://github.com/black-forest-labs/flux：FLUX.1 schnell 模型標 Apache-2.0；FLUX.1 dev 系列標非商用授權，模型**使用權**和生成圖**可如何使用**並非完全同一問題。
- https://bfl.ai/legal/non-commercial-license-terms：模型的非商用／非正式生產使用限制必須認真閱讀。
- 不能因為生成器 repo 是 MIT/GPL/Apache 就推導該模型可商用，也不能因為模型可生成就推導所有參考圖的原作權利已取得。
- 未知權利來源的 AI 美術**不得自動交付 App**；需人工審核。

## 適齡圖像規則

- 10～12 歲：表情和選項反應清楚、文字與圖像區隔、資訊分層；不要用可愛遮掩困境。
- 13～15 歲：避免過度幼稚、卡通化教訓感與過於簡化的道德對錯；允許成熟但非驚嚇性的情緒層次。
- 年齡共同：無血腥、自傷技巧、性暗示、物化或歧視；支持與復原路線清楚呈現；不以紅綠顏色決定結果價值。
- 每國不能使用單一破敗或繁華城市概括該國；生活差異須與 `CountryProfile`／`HouseholdProfile` 的實際情境資料相關。
- 建議參照 UNICEF RITEC 工具（自主、能力、人際關係及兒少福祉）作為設計檢核，**不宣稱產品因此經實測具教育效果**。
  - https://www.unicef.org/childrightsandbusiness/reports/ritec-game-design-features-childrens-well-being-card-deck
- Apple Kids Category 有更嚴格的外連、購買入口及隱私規範；但 10～15 歲不必先假定屬於兒童分類，應依實際內容／年齡分級決定。
  - https://developer.apple.com/app-store/review/guidelines/

## 參考作品（只能研究表現手法）

- Beacon Pines：https://hidingspot.games/press/beaconpines/（動物角色＋繪本式分岔；**故事有較暗元素，不等同可直接面向兒少**）
- Cozy Grove：https://www.wired.com/story/cozy-grove-does-not-shame-me/（溫暖角色氣氛；不可重製其角色、美術與版面）

## 給下一個 Agent 的研究交付格式

每個候選工具請補齊：Repo URL、執行方式、本機是否試過、相依模型、授權證據、是否需要 API Key、對 Apple Silicon 的可行性、出圖成本、角色一致性、透明 PNG 與分層支援、內容安全控制、回退方案。只抄 README／stars 不算完成工具選型。
