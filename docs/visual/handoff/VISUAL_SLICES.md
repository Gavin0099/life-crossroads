# Life Crossroads — Visual Agent 實作切片 LV-00～LV-06

日期：2026-10-23。下列為**待執行 Slice**；尚未宣告任何美術完成或實機驗收。

## 一覽

| Slice | 任務 | 具體交付 | Gate／依賴 |
| --- | --- | --- | --- |
| **LV-00** | 可用技術與權利檢查 | `TOOL-RESEARCH.md`、工具可用性矩陣、Art Charter | 無；不執行不明第三方程式 |
| **LV-01** | 視覺方向與 UX 版型 | 兩種風格的同事件比較、9 畫面 wireframes、tokens／Art Bible v1 | LV-00；通過年齡與閱讀性覆核 |
| **LV-02** | 動物角色與年齡一致性 | 三角色設定、一角色五年齡／五表情試作、角色 Bible／一致性報告 | LV-01；同一角色可辨識 |
| **LV-03** | 共用場景與文化情境 | 五階段場景、情境物件、四國支援映射樣本 | LV-01、主 Agent 的情境定義 |
| **LV-04** | AI 圖像生產線 | prompt packets、asset manifest、去背／轉檔／驗證腳本、少量可用素材 | LV-02；所有素材有權利紀錄 |
| **LV-05** | SwiftUI 原生畫面 | Mock 資料驅動的九狀態 UI、至少四種互動 Preview、截圖與可訪問性證據 | LV-01，可與 LV-02～04 並行 |
| **LV-06** | 整合與兒少視覺驗收 | 接線 DTO 提案、素材 package、實機／兒少審核、整合 PR | LV-02～05、主 Agent 契約 |

## LV-00：工具／權利／基線

**DONE**：Agent 確認本機是否真的有 image generator、生成流程所需權限、Mac GPU/記憶體能否跑本機模型、已允許使用的雲端端點和第三方工具授權；提供可被接受的主／備方案。

- 檢視 Repo 既有 `PLAN.md`、`docs/p1-slices.md`、治理文件、分支、工作目錄。不得覆寫主 Agent 的產品文件。
- 核對 OpenAI `imagegen` Skill 或實際內建繪圖工具是否可用；**安裝 Skill 不等於擁有繪圖能力**。
- 研究 Picture Book Wizard 的角色鎖定流程；不直接採用 3～12 歲的內容與範例作 13～15 歲美術。
- 驗證 Krita、ComfyUI、StoryDiffusion、rembg 的工具／模型個別授權；不將 repo 授權等同模型授權。
- 記錄版本、依賴、網路及成本；第三方腳本需先檢視，無授權不得啟用付費 API。
- 檔案：`docs/visual/TOOL-RESEARCH.md`, `docs/visual/ART-CHARTER.md`。
- 排除：大量圖片生成、改動人生規則。

## LV-01：視覺設計方向

**DONE**：同一事件（13 歲、科學創作展）產出風格 A／B 的**實際比較圖／UI mock**，包含一張決策畫面、一張後果說明畫面；完成 9 畫面線框及 UI 設計 tokens，提出首選及保留項。

- A：敘事冒險插畫，帶水粉／手繪質感。
- B：精簡現代 2D、輪廓辨識強、較不幼兒化。
- 兩者固定文案、角色、場景和手機 viewport；不得靠不同故事內容讓其中一個顯得較好。
- 字體大小、色彩對比、點擊區、長字串、Dynamic Type、VoiceOver 層級、Reduce Motion 設定明確。
- 產出可投給年齡 10～12、13～15 的無誘導提問及記錄模板，至少進行專家先驗覆核；未找到兒少不得宣稱兒少驗證通過。
- 檔案：`docs/visual/art-direction.md`, `docs/visual/ui-screen-map.md`, `docs/visual/design-tokens.md`, `assets/concepts/style-A/`, `assets/concepts/style-B/`。
- 不通過條件：只交 prompt、沒交實際圖；中文字或按鈕被烘在插畫中；對國家給予優劣評分。

## LV-02：原創動物與角色一致性

**DONE**：三種候選動物角色均有正／側／3/4 角色卡與特徵；至少一種動物角色完成五個年齡階段＋五個情緒示範，經人工外觀一致性覆核。

- 需有原創 Character Bible：輪廓、耳尾、眼形、固定標記、比例、色票、服裝與年齡變化。
- 年齡階段是人類人生的視覺比喻，不使用動物實際壽命。
- 三角色皆可進入八國，不把動物品種映射成國籍／人格／能力。
- 建立 reference sheet 與 negative prompt；可研究 StoryDiffusion／IP-Adapter，但不得因追求一致性強制導入本機複雜 pipeline。
- 保存原始圖、修正圖、正反面／表情對照與生成來源。
- 檔案：`docs/visual/characters/`, `assets/characters/concepts/`, `assets/characters/approved/`。
- 不通過條件：多肢、大小比例／服裝無故漂移、族群或國家刻板造型、非常像既有動畫 IP。

## LV-03：五階段場景＋四國情境映射

**DONE**：童年、青少年、青年、中年、晚年各有一個通用可組合場景；示範四國如何根據主 Agent 的家庭／環境 DTO 變動具體物件、支持與限制，不產生虛構的國家平均事實。

- 拆為背景、角色、前景道具、提示區；保留 UI 文字與選項的安全可讀區。
- 建立 Scene Bible：光線、構圖、主要物件、尺度、鏡頭及可替換區域。
- `country_context_id` 只能從有資料或明示假設的情境標籤選擇；不以「國家」直接替換窮富背景圖。
- 用 1 個共同事件示範雙環境差異及一個同國不同家庭對照。
- 檔案：`docs/visual/scenes/`, `assets/scenes/`, `docs/visual/context-visual-map.json`。
- 不通過：八國只有換國旗；背景隱含沒資料支持的刻板印象。

## LV-04：素材生產管線

**DONE**：用固定 Prompt Packet + 角色／場景參考生成若干素材，選稿、局部編修、去背、匯出 Apple Assets Catalog；產出 manifest validator，可拒絕未核授權或缺 prompt 的「正式」素材。

- 建立 `asset-manifest.schema.json` 及範例 manifest。
- 每張正式素材含源文件、導出檔、prompt、reference hashes、工具／模型／版本、生成方式、授權、兒少審核及 SHA-256。
- 如果 generator 不支援確定 seed，記錄可重現**流程**而非宣稱輸出像素可重現。
- 資產優先 PNG（透明背景素材）；排除不必要的 4K 大圖，依裝置實測記憶體與檔案大小。
- 使用同一角色參照生成 5 階段與不同表情，記錄人工挑圖／拒稿比例。
- 腳本測試：尺寸、alpha、格式、缺檔、缺 prompt、未審授權、重複 asset ID、超出大小預算。
- 檔案：`tools/visual/`, `docs/visual/asset-manifest.schema.json`, `assets/approved/`, `docs/visual/asset-provenance.md`。
- 不通過：把探索草圖混成正式資產；自動下載未審模型／腳本；需要真實未成年照片。

## LV-05：SwiftUI UI Preview 與互動

**DONE**：九個遊戲狀態均有 SwiftUI wireframe 或 Preview；其中事件決策、即時／延遲回饋、「為什麼」、跨國同選擇、人生分岔至少四個互動流程可用 Mock 資料驗證；完整首頁與人生地圖也需可預覽。

- 選項呈現：當下代價、不可行原因、調整／求助替代路徑。
- 後果呈現：即時與延遲不同層級，不強行總分或紅綠輸贏。
- 比較呈現：窄螢幕上下雙卡，明列固定／變動條件、支持、路線及資料限制。
- 為什麼：四大因素欄位依 Trace DTO 實際存在情況顯示；未參與不可硬塞。
- 分岔：一條原路、一條改選，分岔前歷史固定；不要用虛構差值當正式計算結果。
- 可訪問性：Dynamic Type、VoiceOver、Reduce Motion、非只靠顏色、清楚的可按區域與 focus 順序。
- 檔案：`UIPrototype/` 或經主 Agent 接受的 app Features UI 路徑；`docs/visual/view-contract.md`；Screenshots。
- 若主 App 尚未有 Xcode project，用獨立 Preview／示範 target，不替主 Agent 新造不相容的引擎。
- 不通過：只有 Figma／圖片而沒有可用 SwiftUI 元件；UI 使用假數據冒充真實運算結果。

## LV-06：整合、兒少視覺與素材品質驗收

**DONE**：Visual Agent 把經人工選定的角色與正式素材整理成整合 PR（不直接改 Domain），提供 View DTO、Preview、license manifest 和實機截圖；必要時為主 LC-02／LC-03 的視覺畫面提供修正提案。

- 裝置：最少一種窄螢幕、常見尺寸 iPhone Simulator；**實機另留證**，不能相互冒充。
- 10～12 與 13～15 歲分開觀察：角色是否吸引、是否能找到重大選擇／代價、是否看懂跨國差異與分岔。
- 維持兒少自願及家長知情；不要求上傳孩子照片、聲音或其他可識別資料。
- 審查並列：兒少內容、可讀性、文化真實、角色一致性、產出來源／授權、資產體積、效能與崩潰風險。
- 針對完整 P1 8 國／16 情境估算後續素材量並明列未完成部分，不把四國樣板宣布成八國已完成。
- 提交 `docs/visual/acceptance.md`、截圖、已批准 assets、PR、任何失敗與殘餘風險。

## 平行依賴關係

- `LV-00 → LV-01 → LV-02 → LV-04`（美術主路）
- `LV-01 → LV-05`（UI 可先做）
- `LV-01 + 主 Agent 國家/家庭情境 DTO → LV-03`
- `LV-02 + LV-03 + LV-04 + LV-05 + 主 Agent View DTO → LV-06`

優先做出**真正可檢視的角色及手機畫面**；不要用長期資料整理掩蓋完全沒有圖、沒有 UI 的狀態。
