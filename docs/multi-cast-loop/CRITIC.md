# MULTI-CAST-LOOP 三輪視覺與工程覆審

Critic只看原生場景裁切；盲圖是原始PNG的位元組複製，不修改截圖像素。圖號／來源／SHA映射在 `artifacts/evidence/multi-cast-loop/blind-round*-map.json`。沒有以AI判讀代替兒少理解、Owner選稿或真人VoiceOver。

| 輪次 | 原生輸入 | 獨立發現 | 修正／界線 |
|---|---|---|---|
| 1 | SE與iPhone17，各17個真實保存狀態；盲評A–K | 視線常越過對方；13求助讀成思考；螢幕頭像被誤讀為狐狸；成年阿禾的舊場景仍有文字與牌卡遮身 | 保留3 ACCEPT／7 PARTIAL／1 REJECT原判；新圖調整視線，13改用已存在的攤掌姿勢，遠端老師頭像放大，成年觀察改用真實活動投影 |
| 2 | 兩尺寸各31狀態：17一般＋7最大字級＋7減少動態；13張盲圖 | 對視、提問、貓頭鷹與成年場景均改善，無新遮臉／浮空；青少年／青年及兔子成熟外形仍有歧義 | 6 ACCEPT／7 PARTIAL／0 REJECT；不把「無REJECT」當全美術通過。K曾被速報誤讀為老年，Critic單圖複核後撤回並保留更正依據 |
| 3 | 最終凍結來源的兩尺寸／字級／Reduced Motion確認 | 新的獨立Reviewer：8 ACCEPT／6 PARTIAL／0 REJECT；物種、手作、休息可辨，詢問與一般交談、年齡及歷史含義仍有限 | 總體PARTIAL；保留真人／正式美術HOLD，不把靜態作品展示說成已證明重聚或因果 |

- [第一輪原始盲評](critics/round1.md)
- [第二輪原始盲評及更正](critics/round2.md)
- [第三輪獨立覆核](critics/round3.md)
- [工程審查及P2回歸](ENGINEERING_REVIEW.md)

工程Reviewer以真實Seed5找到觀察continuation路線，證明固定稱「入門」超出實際紀錄。新增案例先失敗，再刪除不必要的資歷推論；保留同一路線的原生畫面與原本故事。

## 沒有隱藏的失敗

- 基準標準機：拍攝shell執行中被修改，build成功後shell EOF，未執行測試；專用裝置已刪。`baseline-recovery`重用同一已編譯基準App補拍。這不是產品測試失敗，也不冒稱首次成功。
- 基準SE匯出：初版檔名regex漏兩個含多個連字號的場景；修正後從同一xcresult完整匯出32張，無修改圖片或重做決策。
- 圖集：阿禾格距、貓尾跨格與沐沐視線失敗原圖及生成修正保留，見ART_ASSETS。
- Python第一次44項：新增測試預期的候選種類名稱與已寫manifest契約不一致；對齊正式candidateAtlas名稱後重跑，未修改候選批准狀態。
- 自然觀察P2：真實continuation回歸先失敗，窄修後重新驗證；沒有修改引擎避免反例。
- 既有框架 `session_envelope` 入冊91日超過90日限制：保留basic失敗，不停用Gate，不宣稱CI全綠。

## 工作預算

本輪以3～4 Agent-hours為上限，停止條件是完成真實整合與有界覆審，而非耗滿時間。素材Agent觀測28分21秒；盤點、工程Reviewer與Critic皆為短範圍子任務，沒有另開長期功能工作線。主流程開始約06:00 UTC，包含編譯、截圖與遠端等待；其觀測區間不應冒稱精確純工作時間。最終完成時間由提交／CI憑據補充，沒有以Token或圖數換算完成率。
