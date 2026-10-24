# LIFE-LOOP 10H v1.1：生活循環整合交付

狀態：程式、本機測試與獨立工程覆核完成；遠端最新完整CI仍待。沿用 [Draft PR #10](https://github.com/Gavin0099/life-crossroads/pull/10)，不合併、不發布。

## 本次可操作成果

正式八國人生現在以大型河畔世界開始，生活片段約3秒後停在真實事件；玩家決定並保存成功，才顯示本次人物、資源、記憶或道具變化，約2秒後自然續行。可以暫停、1×／3×、立即跳過；事件等待永不自選。首頁可切回既有 Event-first，人生與存檔共用。

世界保留既有五齡沐沐 PNG，採輕微整體待機、水面環境與已保存後果的單次演出；不是新角色骨架或各國實景。13歲紙本創作、求助、休息及延後故事事實由實際 trace 投影，不畫出未發生的幫手或機會。

## 工程邊界

- 基底為 PR #9 `c823c82`，承接 PR #8 `c136beb`；舊原型 `65fff9e` 只保留 checkpoint，未整枝合併。
- `LifeWorldFrame`／`WorldMomentProjector` 只讀人生；`WorldPlayback` 注入單調時間；GameStore 使用唯一累積演出鐘，保存成功後才更新世界投影。
- 世界進度、動畫、速度不寫入人生 schema，不改事件抽選、資料版本或 Seed。相同輸入的完整 trace 與存檔仍可重現。
- generation／identity／in-flight ticket 阻擋過期與重複續行，寫入失敗停在原結果，可重試。背景、遮蓋、離屏、原局檢視凍結演出；冷啟動不補算人生或自動消耗下一事件。
- 已保存原局仍由原本分岔系統管理。完整後半生和磁碟恢復測試不以畫面 marker 相等替代。
- 動畫僅參考 rossark 固定來源 `9b20964` 的方法，MIT 及來源 hash 已查核；沒有安裝整包 skill、複製原碼或引入第三方 demo 圖片。

## 驗證

| 證據 | 結果與範圍 |
| --- | --- |
| 純 Swift | 111個不同案例通過：102基線＋3世界投影＋4時計＋2真實存讀／分岔。獨立Reviewer重跑9項屬其中子集，不加總。 |
| 固定基準 | LL-00日本／台灣家庭一Seed0完整15項trace保持凍結；normal／fast／skip及逐邊界真實磁碟讀寫與原局bytes一致。八國均能完成15選擇／80歲。 |
| Python | 24項通過，包含模擬器wrapper參數、boot失敗、成功／失敗清理。 |
| 正式motion helper | 直接swiftc編譯App實際helper，時間接縫、暫停／恢復／速度連續及one-shot測試通過；沒有另外抄出一個測試版算法。 |
| 離線畫面 | 18張真實session→正式projector→scene；幾何loop首尾一致。嚴格像素相等曾失敗1/255，同輸入重繪控制亦同幅；保留原失敗與容忍比較，不宣稱pixel-exact。 |
| 完整原生回歸 | binary `7040802`：SE／iOS27.0，16項中15過1失敗；舊UI11項、新世界完整人生／原局分岔／恢復／存檔重試等通過。最大字體projectMemory的helper拖曳從固定footer開始，無法捲到文字。 |
| 最新原生定向 | binary `7aa69d2` 五項全部通過（237.324秒）；包含修正手勢的最大字體、新增Reduced Motion、兩事件自然續行／前次原因、冷恢復及寫入失敗。未把前版完整套件冒充本版全套。 |
| 引擎／資料範圍 | 對基底Domain/Data/Persistence無diff；離線31觀測／8國／16家庭／40事件資料檢查通過。 |

完整原始失敗和通過記錄保留於本機 `artifacts/governance/life-loop-10h/`；可提交的版本化摘要、選定原生圖與來源manifest在 `artifacts/evidence/life-loop/`。測試方法可見正式SLICES／CONTRACT；每次使用專用Simulator，終了以delete清除，不只shutdown。

## 畫面對照與驗收缺口

舊新8歲首屏相同日本家庭一Seed0；13歲大字舊新對照同為rest三次後紙本創作。manifest逐張記錄實際binary，不把704圖充作最新圖。生活大場景、事件緊縮場景、已保存後果、下一事件、完整岔路比較分開檢查。

仍需真實iPhone、人工VoiceOver焦點、分齡兒少試玩和真人10–15分鐘節奏。最大字體固定控制列佔較大空間，能操作與閱讀舒適度分開判斷。SwiftUI「Publishing changes from within view updates」warning在本輪仍有，前一版亦記錄同字串；本輪發出點／根因尚未定位或修復，不宣稱零warning或已有資料毀損。台灣資料可比性、完整事件量、正式美術與發布Gate沒有因本次完成而通過。

## 工時

這是10 Agent-hours上限下的整套實作，並非只做LL-00。Gameplay上限7h、Visual2h、Reviewer1h。記錄可核實的工作觀測窗，包含等待的窗是保守上界，不虛構精確逐片工時或花滿10h。最終觀測帳、R1～R4及G1～G6狀態於ITERATION_LOG收束。

## Gate 判斷（工程與玩家證據分開）

| Gate | 本輪判斷 |
| --- | --- |
| G1 真實人生 | 本地工程通過：八國15決策／80歲，核心與資料無diff。 |
| G2 生活循環 | 本地原生通過：相鄰兩事件及完整新世界人生可操作，自然續行不自選。 |
| G3 決定論 | 本地工程通過：凍結trace、速度／skip、真實存讀與原局／完整替代線。 |
| G4 真實後果 | 一般與13歲反應已原生目視；另有4d3308e正式13→17歲線索／已觸發呼應原生案例1/1通過，兩張真圖保留，沒有修改App或引擎。 |
| G5 可操作 | SE首屏／最大字體／App減少動態本地通過；最新完整遠端CI與人工VoiceOver仍待。 |
| G6 動畫與授權 | 實際helper、單一累積鐘、固定時刻與來源MIT查核通過；不宣稱實機FPS或嚴格像素相等。 |

獨立覆核由另名Reviewer完成，沒有代替使用者合併批准。維持Draft／HOLD，完整P1與發布Gate均未通過。

獨立Reviewer主段05:55:25–06:51:06 UTC，另G4補證46.3秒，合計約0.941 Agent-hour（含等待、上限1h）；無剩餘已確認工程阻擋。完整[覆核紀錄](../../artifacts/evidence/life-loop/independent-review.md)已保存，未給合併批准。

Visual作者與只讀QA保守觀測共0.857 Agent-hour／2h，沒有擴充角色素材。正式原生首屏、休息／Reduced與8→10→12變化已目視，細節見 `artifacts/evidence/life-loop/visual-qa.json`。

最後G4 test-only `4d3308e`：13歲pending→17歲已發生呼應1/1通過44.367秒，兩圖由Reviewer獨立實看；第五台專用Simulator已刪。本次工時保守觀測與個別cap見 `artifacts/evidence/life-loop/budget-ledger.json`，文件提交時root仍在PR/CI交付工作窗內。
