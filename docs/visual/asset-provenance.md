# 圖片產製與素材檢查流程 v0.1

本輪使用內建 ImageGen；所有 prompt 保存在 `assets/prompts/`，圖保存在 `assets/concepts/` 和
`assets/characters/concepts/`。不以外部 generated_images 目錄作唯一來源。
`assets/visual-manifest.json` 記錄檔案 SHA-256、尺寸、alpha channel、參照、狀態、審核與工具。
模型名稱/版本與 seed 未由工具回傳，填 null；不由 skill 的預設 CLI 模型倒推內建模型。

流程：固定角色/故事 → prompt + 參照圖 → 生成 → AI 目視初篩 → 保留/修正 → 人工藝術與適齡/文化/權利覆核 → 正式素材。
本輪只到候選初篩及貓尾修正。設定圖沒有透明背景，也沒有完成可直接替換的分層 sprite。

正式升格前：

1. 確認帳號服務條款、參照來源及輸出使用權；不以 open-source 工具授權取代模型/輸入授權。
2. 逐角色、逐年齡核對身分標記、耳尾、關節、服裝與年齡可辨識性。
3. 人工確認無血腥、羞辱、性暗示、既有 IP 近似與國家刻板印象。
4. 用內建 ImageGen 編修/去背輸出真正 alpha PNG，保留原圖；不以白底圖冒充透明圖。
5. 尺寸/alpha/檔案預算/缺檔/缺 prompt/重複 ID/未核授權通過 validator，再匯入正式 Assets Catalog。
6. 在原生 View 檢查裁切、暗/亮色、大字、小螢幕及記憶體；實機與兒少證據另列。

原型 target 的 Assets Catalog 僅含 A/B 場景探索圖；其 `approved_for_app=false` 代表尚不能升格產品素材。
候選顯示與正式核准是不同狀態，Demo build 成功不會自動修改審核欄位。
測試只檢查結構/雜湊/尺寸與明確審核欄位，不判斷美術、合法性或適齡。

負面包固定：不含中文字/按鈕、國旗、國家能力暗示、既有角色、真實未成年照片、多肢、水印、血腥、幼兒大頭。
每次修圖指定不變項；原稿保留版本，不以覆寫消滅失敗樣本。
