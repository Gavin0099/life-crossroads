# INTERACTION-MEMORY-LOOP 年齡素材

來源基底：PR #19 `a79f667528b5b4cbeb2e543b6d9ca33a12d680f1`。本輪只新增一張三格主角中立圖集，供 Gameplay 接入；沒有改既有角色圖、正式人物名單、候選貓狗、Domain、Data、Persistence、RNG 或存檔。素材作者未啟動 Simulator、未修改 renderer、未建立提交。

## 觀察與最小修正

已實際檢視 `StoryCast`、`MCMumu`、`VL2Neutral`、`VL2Teen13` 與 `VL2Adult25` 原圖，並核對 `StoryCharacter.protagonist(age:)` 和 `LifeWorldScene` 的映射。

| 階段 | 原素材觀察 | 本輪處理 |
| --- | --- | --- |
| 童年（≤12） | StoryCast 的短身、大頭、青綠吊帶褲可與成人區分；MCMumu 有童年交談姿勢 | 沿用，未重畫 |
| 青少年（13～22） | VL2Neutral 的 13／17 兩格幾乎同一輪廓；與成人仍容易只靠背心辨別 | 新增纖細肩身、較大頭身比例與背心的中立站姿 |
| 青年（23～40） | VL2Neutral 的 25／32 接近同圖，既有活動圖的頭臉偏幼 | 新增較成熟肩身、較長四肢及工裝外套的中立站姿；活動圖保留 |
| 中年（41～60） | StoryCast 的青年／中年除了外套細節幾乎無差；不能以同一成人圖覆蓋中年 | 新增較厚實軀幹、針織外衫及少量灰鬢；保持直立、有活力 |
| 晚年（≥61） | StoryCast／MCMumu 的灰眉、灰頭毛、眼鏡與針織服裝已較明確 | 沿用，未重畫 |

這些是現有 UI 的五個粗階段，沒有新增生命規則。13 與 17 均屬青少年、25 與 32 均屬青年；本輪不以微小外觀差別宣稱能認出精準歲數。衣著不是年齡證據的唯一來源，但生成圖在小螢幕的實際辨識仍須原生盲讀。

## 可接入素材與裁切契約

- Asset name：`IMNeutralStages`。
- 原始檔：`LifeCrossroads/App/Assets.xcassets/IMNeutralStages.imageset/IMNeutralStages.png`。
- 實際尺寸：**2172 × 724**；RGBA 8-bit；3 欄 × 1 列。
- X 邊界：`[0, 724, 1448, 2172]`；Y 邊界：`[0, 724]`。這組生成結果經量測恰可等分；不是預先假設所有圖集都等分。
- SHA-256：`f8d2148d0f5023d7bbcdd64cee21e44d6de804f9661cb0d432f5c9be9ef36b93`。

| Cell | 語意 | Source rectangle（x,y,w,h） | Alpha >12 的可見邊界（x,y,w,h） |
| --- | --- | --- | --- |
| 0 | adolescenceNeutral；13～22 | 0,0,724,724 | 117,95,447,606 |
| 1 | youngAdultNeutral；23～40 | 724,0,724,724 | 814,35,446,671 |
| 2 | middleAgeNeutral；41～60 | 1448,0,724,724 | 1504,24,478,686 |

全身、耳、尾、腳保留於各格。人物面朝右，修正後視線接近水平，雙手空置；此圖僅表示中立等待／注意，不表示老師已幫忙、已答應邀請或已完成作品。**不能拿中立圖取代已保存的實際工作、求助、休息或重聚活動姿勢。**

整合建議：普通生活或邀請中的主角依五階段映射，童年／晚年沿用 StoryCast cell 0／4，青少年／青年／中年用本圖 cell 0／1／2；13／17 不再各取近似的兩格。保留共用時鐘、Grounded 計算和 Reduced Motion 路徑；同伴出場與實際活動仍讀正式投影，不由圖片決定。

## 一次生成、一次定向修正

| 版本 | 發現與處理 | 採用 |
| --- | --- | --- |
| v1 | 三階段輪廓與衣著已拉開，但頭部及眼睛仍往上看，削弱對視 | 原始 PNG 留存，不接入 |
| v2-gaze | 僅要求頭與瞳孔轉成近水平向右，保留身份、身形、服裝、尾巴及格位 | Draft 採用；不再生圖 |

原始檔在 `assets/interaction-memory-loop/originals/`；完整提示在 `assets/interaction-memory-loop/prompts/`。本輪使用內建 `image_gen.imagegen`，一次新圖與一次定向修正，無 CLI／API fallback；工具未回傳模型版本，記為 `not_returned_by_tool`。沒有使用網路參考作品的圖像。

兩次工具原始輸出及正式 imageset 均保留原始 bytes，沒有後製去背、重取樣、剪尾、拼圖或修補。Python 只使用既有 `Tests/test_multicast_assets.py` 的只讀 PNG parser 量測 alpha、座標及 SHA，沒有寫入像素。

## 驗證與界線

技術自查 **ACCEPT**：alpha 全透明比例 67.4487%；X=724／1448 兩條格界的 `alpha >12` 像素均為 0；三個 source rectangles 不重疊並覆蓋整張圖；imageset bytes 與工具原檔及 repo 留存原檔完全相同。詳細機讀結果見 [asset-manifest.json](asset-manifest.json) 與 `assets/interaction-memory-loop/alpha-audit.json`。

身份自查 **ACCEPT（限 Draft）**：圓耳棕色水獺、奶油吻喉、琥珀領巾與青綠服裝錨保留；中年僅少量灰鬢，未被畫成虛弱老人。

年齡辨識 **PARTIAL**：中年與青年已增加可見差別，青少年／青年頭身與服裝亦不同；**尚未用本輪原生小畫幅和獨立盲讀證實五階段均清楚**。活動姿勢仍用既有圖集，因此本圖不代表所有事件畫面的年齡問題皆修復。原生整合、盲讀與逐項結論由主流程追加到本輪 Critic／驗收紀錄，不把作者自查冒稱獨立審查。

全部 `approved_for_app=false`、`draft_integration_allowed=true`。使用者授權 Draft 接入不等於正式美術選稿、真人理解或發布批准；AI 生成素材權利未宣稱已完成各地法律審查。素材可用不計算成整款遊戲的完成百分比。
