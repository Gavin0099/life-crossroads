# VISUAL-LOOP-02 — 驗收與限制

獨立 Draft／HOLD；以PR15 `81371e0`為基底。這輪改的是正式 App 的活動圖層與場景呈現，沒有更動 Domain、Data、Persistence、Seed、存檔schema或原30個UI案例。正式美術與玩家驗收不是自動化測試可替代。

## 已執行循環

- W0：兩台原生基準，14份正式引擎可重播存檔。舊畫面多為同一河畔、站姿及文字牌；紀錄分離在 `baseline/`。三項基準工具失敗與一次第三輪shell啟動失敗保留在 `capture-failures.json`，不計入PASS。
- R1：新背景、活動圖層與人物接線，兩台normal。獨立Critic先看匿名A–M再給映射；四組核心活動可辨，但遠距肖像浮於房間、部分視線及共作參與不清楚。L/M帶舊UI內容，排除純盲測。
- R2：補中立等待姿勢、同伴實際握持材料、視線與接地，兩台三模式。Critic確認四組活動區分，另抓到SE大字視訊框越界，保留No-Go及原圖，沒有用normal通過代替全模式。
- R3：視訊框改綁定實際sprite的螢幕區域，縮小以保留草稿；大字頁首顯示年齡／國家，完整身份階段仍有accessibility label。最終兩台三模式重新拍攝及覆核，結果見下列最終證據。

## 驗收表

PASS只表示本欄明訂的可觀測條件成立，沒有把AI辨圖擴張成兒少驗收。

| 項目 | 判定 | 證據／界線 |
| --- | --- | --- |
| 精確PR15基底、獨立分支 | PASS | `codex/visual-loop-02`由81371e0開始；沒有合入舊Visual WIP |
| 真實存檔對照、來源映射 | PASS | 14份JourneySave經正式validate與save/load；Seed34創作鏈、Seed0恢復鏈，見fixtures/manifest.json |
| 3套背景、可替換角色活動與獨立同伴 | PASS | 3背景＋6透明圖集；來源、生成提示、SHA、格位與權利狀態在asset-manifest.json |
| 13線上／紙本／求助／休息活動可辨 | PASS（AI目視） | R1/R2盲讀分別看出鍵盤、紙筆、攤掌交談、放鬆休息；求助未畫成得到協助 |
| 17遠距／備料共作不同 | PASS（AI活動辨識） | 耳機螢幕交流對照紙板接縫作業與同伴持料；R3兩尺寸三模式均已目視關閉小窗越界 |
| 25試作／在地桌不同 | PASS（AI目視） | 站姿單人工位盒框作業對照坐姿共作桌舉板；沒有把圖片當付款／錄取證據 |
| 32過去休息安排／實際參與不同 | PASS | 前者讀完成的focusHistory，後者讀已保存pacedRole；休息長椅對照小桌短時參與 |
| 未選之前不提前工作 | PASS | 獨立neutral姿勢與相同場景；純Swift測試拒絕從舊記憶、pending clue推定當前選擇 |
| 無國名設備映射、缺值不畫斷電斷網 | PASS | Presentation只讀實際action／focus；國家與家戶規則未變 |
| 固定Seed／原人生／存讀 | PASS（工程） | 完整145Swift含原回歸；逐次native拍攝前後checksum及跨版本同存檔校驗另見verification.json |
| 兩機型normal／large／reduced矩陣 | PASS（工程） | 最終60狀態、60可行控制、跨基準checksum及source hash全部一致；見verification.json，並非60個正式UI案例 |
| 原30UI與當前HEAD遠端CI | PENDING PUSH | 未減少案例、分片或Gate；以獨立PR當前HEAD檢查為準 |
| basic治理檢查 | FAIL（既有框架時限） | pinned framework的session_envelope過渡鍵於10/28超過90天；5項PASS、drift WARN導致required basic失敗。沒有升級框架或關閉檢查 |
| 13與17精確年齡只看圖可靠區分 | FAIL／仍不足 | Critic只能粗分幼態、青少年、成人及長者；不能宣稱所有年齡辨識已達標 |
| 至少3種姿勢與4種表情，不以微晃冒充手臉動畫 | PASS（素材及AI目視） | 坐姿鍵盤、低頭紙筆、攤掌詢問、閉眼休息與站姿工作；專注、疑問、放鬆、交談。是姿態切換＋共用光影，仍沒有逐格／骨架手臉動畫 |
| 正式美術與真人10～15歲娛樂、理解、重玩 | FAIL／待驗 | 使用者尚未安排完成試玩；AI Critic不是真人或正式選稿 |
| 實機VoiceOver與本版iPhone驗收 | FAIL／待驗 | 本輪為Simulator原生；沒有以Simulator結果冒充實機 |
| 當次Simulator全部刪除 | PASS | 成功／失敗共11台owned Simulator均有delete收據且inventory已不存在；未刪其他裝置/runtime |

## 來源與重現

- [八組Before/After](BEFORE_AFTER.md)，另附標準尺寸及大字完整畫面。
- [美術規格](VISUAL_BIBLE.md)、[資產來源與版本](asset-manifest.json)、[生成及修正全文](prompts.md)。沒有第三方下載圖片、外部字型或照搬參考遊戲。
- [第一輪盲讀](CRITIC_BLIND_R1.md)、[映射核對](CRITIC_MAPPED_R1.md)、[第二輪覆核](CRITIC_R2.md)、[最終雙尺寸覆核](CRITIC_R3.md)。後輪已有先驗，不稱新的盲測。
- [重現步驟與證據邊界](REPRODUCE.md)、[本機測試](../../artifacts/evidence/visual-loop-02/validation.json)。舊規則存檔保留但拒讀的既有限制仍在，沒有新增遷移。

## 決策

獨立AI Critic最終四對Go，指定原生範圍無剩餘阻擋P1/P2；required basic時限失敗仍保留，遠端CI另核對。

核心對照先看「做了什麼不同活動」，不從圖推論所得、技能高低、被錄取或現實國家的因果。正式美術、兒少體驗與發布繼續HOLD；不宣稱90～95%完成，不合併、不發布。
