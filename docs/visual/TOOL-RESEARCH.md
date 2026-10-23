# LV-00 工具查核：2026-10-23

實際能力：本輪直接呼叫內建 `image_gen.imagegen` 並保存生成圖，不需要 API Key 或 CLI fallback。
已讀本機 ImageGen skill，沒有安裝或執行下面第三方 repo 的腳本。上游 HEAD 與授權 API 結果見
`artifacts/visual/tool-source-check.json`；這些版本是研究時點，非部署版本。
本機為 Apple M4 / 16 GiB。沒有跑本地擴散模型 benchmark，不能推算速度或顯存餘裕。

| 工具及一手來源 | 安裝 / 實際使用 | 程式與模型權利 | 角色、透明度與決策 |
|---|---|---|---|
| [OpenAI ImageGen skill](https://github.com/openai/skills/blob/main/skills/.system/imagegen/SKILL.md) | 本機 skill + 內建生成器已實際出圖；未用 CLI | Skill 指引不授予模型權重或素材權利；工具未揭露底層模型/seed；帳號適用條款待核 | 以參照圖維持身分；支援透明請求但本輪用不透明設定圖；主方案 |
| [Picture Book Wizard](https://github.com/kart-io/picture-skills) | 複製 skill 的設計；依賴外部圖像工具；未安裝 | README 自述 MIT，但 GitHub license API 未識別、未找到獨立 license 證據；不直接複製程式/素材 | 參考角色鎖定方法；其 3～12 歲定位不能證明 13～15 歲適合；不採文字烘圖 |
| [StoryDiffusion](https://github.com/HVision-NKU/StoryDiffusion) | Python ≥3.8、PyTorch ≥2；需模型；未安裝 | 程式 Apache-2.0；模型/相依權利另查 | 序列一致性候選，動物年齡效果與 Mac 性能未測；本輪不依賴 |
| [Krita AI Diffusion](https://github.com/Acly/krita-ai-diffusion) | Krita plugin + 相容 ComfyUI backend 或服務；須依 plugin 安裝頁核對版本；未安裝 | plugin GPL-3.0；backend/模型/服務分別審核 | 局部修正、圖層、參照控制的備案；不將 GPL 程式碼併入 App |
| [ComfyUI](https://github.com/comfy-org/ComfyUI) | 官方有 Apple Silicon/PyTorch 安裝路線；需模型與依賴；未安裝 | 程式 GPL-3.0，節點和模型另審 | 批次與 workflow 版本化較合適；維護成本尚無理由在首輪導入 |
| [rembg](https://github.com/danielgatis/rembg) | Python ≥3.11,<3.14；CPU/ONNX 可用路線；未安裝 | MIT 僅程式；目前 README 的預設 BRIA RMBG-2.0 商用需另付協議 | 透明 PNG 可行，但不執行未核模型；優先內建透明生成/編修 |
| [InvokeAI](https://github.com/invoke-ai/InvokeAI) | WebUI / Canvas + Python/PyTorch/模型；Mac 安裝性能未實測；下載網站讀取 403 | 主 LICENSE Apache-2.0；repo 另有模型及其他 license 檔 | 圖層編修與節點的替代方案；不與 Krita/ComfyUI 同時投入 |

各工具的免費程式碼不代表服務、算力或模型免費。內建工具沒有回傳單圖成本與實際模型版本，均記錄 unknown；沒有聲稱成本為零。
沒有任何上述工具能憑 README 證明角色一致、適齡、沒有相似 IP 或輸出可商用。

## 權利界線

[OpenAI 公開條款](https://openai.com/policies/terms-of-use/)說明雙方之間輸出的權利歸屬，也要求輸入權利與輸出適當性由使用者負責，且輸出未必獨有。
本輪沒有核對此帳號究竟受消費者、商務或另訂條款拘束，亦未取得人工 IP 相似性審查；因此只有候選展示，不填 approved。
這是發布前未完成的核定，不是宣稱本輪原創候選有已知侵權問題。

[BFL 官方模型表](https://github.com/black-forest-labs/flux)將 FLUX.1 schnell 列 Apache-2.0，dev 系列列非商用模型授權。
不能從 ComfyUI 授權推導 FLUX dev 模型可商用；模型使用與輸出許可也不能混為一談。本輪未使用 FLUX 或 BRIA。

## 能力與回退

- 內建生成失敗：保留既有候選、可執行 SwiftUI 與 prompt；明列工具阻塞。API CLI 僅在使用者明確要求時啟用。
- 角色漂移：以母圖 + 單一變因編修；保留原稿與拒稿原因。貓的犬型尾即為本輪實際修正案例。
- 透明/切層：本輪不需要；正式 sprite 階段先用內建透明編修，再核對 alpha 邊緣。未驗證本地去背模型。
- 大量生產：先量測每張挑圖率、修圖時間、記憶體與實際費用，再決定 ComfyUI；不承諾本機可跑所有模型。

結論：LV-00 已有可用的主方案與保守發布邊界；本地工具安裝/性能試驗及商用正式核准均尚未完成。
