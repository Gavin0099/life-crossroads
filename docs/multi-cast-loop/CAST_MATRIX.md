# MULTI-CAST-LOOP 角色盤點

盤點基底：PR #17 `30d60007ca43431a740c093f17c75a5e75dc0fb6`。正式人物資格來自既有 `catalog.json`、`StoryBranchEngine`、實際 `ConsequenceTrace` 與 `WorldMomentProjector`；圖片不增加故事人物或成功結果。下表的「缺口」記錄改造前狀況；本輪新增素材與逐圖批准狀態見 `ART_ASSETS.md`，原生整合結果另見 `VALIDATION.md`。

| 身分 | 穩定外觀與舊素材 | 年齡範圍 | 可驗證出場來源 | 改造前缺口／本輪用途 |
|---|---|---|---|---|
| `mumu` 沐沐，水獺主角 | 栗棕、乳白吻喉、小圓耳、寬漸細尾；青綠／米白衣著與赭黃圍巾。`StoryCast` 格 0–4；`VL2Teen13`、`VL2Teen17`、`VL2Adult25`、`VL2Recovery32`、`VL2Neutral` | 正式五階段；VL2 活動姿勢集中 13、17、25、32 歲 | 每段人生的主角；已做行動須由保存後 trace 決定 | 童年與晚年多為站姿；增加交談、共作及晚年重聚姿勢。不能只用縮放冒充年齡 |
| `ahe` 阿禾，狐狸 | 橘毛、尖耳、蓬尾、珊瑚紅外套；`StoryCast` 格 5 | 故事含童年、青少年、成年、中年與晚年；原圖只有單一中性造型 | `child-friend`、自然觀察／友情延續事件；72 歲 `later-reconnect-old-friend` 必須有 `friendship=connected` | 原 `WorldActivity` 不含狐狸；缺童年互動、成年關係及晚年形貌，優先補足 |
| `teacher` 樹老師，貓頭鷹 | 暖米棕羽毛、圓眼鏡、苔綠背心；`StoryCast` 格 6；`VL2Companions` 上列聆聽／工作 | 教師身分跨學習階段；資料沒有出生年，不編造精確年齡 | `teen-project`、`teen-direction` 作品路線、修理／工具事件；25 歲 `adult-learning` 的 `cooperate`／`portfolio` 在實際關係紀錄中仍是 `teacher` | 原有姿勢少、同站旁邊；補聆聽、講解、共同製作、鼓勵。出現或邀請不代表已協助 |
| `cheng` 小澄，兔子社區夥伴 | 奶油毛、長耳、淡紫衣、編織籃；`StoryCast` 格 7；`VL2Companions` 下列 | 故事跨青少年到晚年；沒有精確出生年，不從主角年齡反推固定同齡 | 社區／照顧／生活安排事件；`adult-boundary-calendar` 的 `pacedRole` 記錄真實互動；72 歲未保留友情的 `later-reconnect-new-neighbor` | 補詢問、商量、分工、重新參與；不能把 `adult-learning` 的共作夥伴擅自換成小澄 |
| 候選 `cat`，尚無故事姓名 | 石板灰、乳白吻喉、三道深額紋、角色右耳缺口、S 尾乳白尖；珊瑚外衫、米白內搭、深藍褲、細青綠斜包。早期 `cat-five-stages.png` 及 v1 | 童年、青少年、青年、中年、晚年五階段候選 | **沒有正式 personID、StoryFact 或事件來源** | 找回設定，透明素材只進 SwiftUI Preview；未核准、不進人生場景，不新增 Domain 角色 |
| 候選 `dog`，尚無故事姓名 | 琥珀毛、額頭乳白線、角色左耳折／右耳立、淺尾尖；靛藍外衫、米白內搭、橄欖褲。早期 `dog-five-stages.png` | 五階段候選 | **沒有正式 personID、StoryFact 或事件來源** | 同貓咪，僅素材與 Preview；不能稱為已整合故事角色 |
| 候選 `hare`，不等同小澄 | 灰棕、乳白吻、角色左耳缺口、短尾；鐵鏽外衫與深背帶。早期 `hare-five-stages.png` | 五階段候選 | **沒有與 `cheng` 的權威映射** | 與奶油毛、淡紫衣的小澄外觀不同。保留為早期候選，不改名混入小澄 |

左右描述均以角色自身為準。此處是虛構角色設計，沒有按國籍分配物種、衣著、能力或道德。

## 舊素材來源

- 原正式圖集來源：`docs/visual-assets.md`（原始提示、尺寸、SHA 與用途）；`StoryCast` 為 4 欄 × 2 列透明圖集，1774 × 887。
- 前輪活動素材：`docs/visual-loop-02/asset-manifest.json` 與 `prompts.md`。主角與接觸中的桌面／工具有些在同一透明格內，不宣稱已分成獨立道具層。
- 早期候選設定：`origin/codex/lc-visual-design` 的 `2b62a192ad43e23c806d029b353d49da61576ae2`，`docs/visual/characters.md` 及 `assets/characters/concepts/{otter,hare,dog,cat}-five-stages.png`。設定圖不是透明遊戲 sprite，也不是 Owner 正式選稿。
- 本輪不得整條合併早期 Visual 分支；只取必要原始參考並保存來源版本及位元組 SHA。

## 人物資格與不能混淆的語意

`WorldActorProjection` 的選前 `inviter` 來自 `event.recurringPerson`；現有值常是顯示名稱（阿禾、樹老師、小澄）。保存後 `interacted` 則來自當次 `changedRelationships`，使用 `ahe`、`teacher`、`cheng`。畫面層應明確正規化這三位已知角色，不能把未知「工作夥伴」自動換成任一動物。

| 時點／選項 | 真實紀錄 | 畫面可表示 | 不得暗示 |
|---|---|---|---|
| 10 歲 `child-friend` 選前 | 阿禾是當前事件人物，尚未有本次結果 | 相遇／交談前 | 風車已做成、已約定保持聯絡 |
| 10 歲 `invest` | `friendship=connected`，本次 `ahe` 互動 | 共同完成風車、建立聯絡 | 任意未發生的未來重聚 |
| 10 歲 `rest` | `friendship=paused`，沒有本次人物互動 | 自己休息 | 阿禾受傷、被討厭或已承諾下次 |
| 13 歲 `ask` | `support=requested`、`learning=none`，有老師互動 | 說出需要、老師聆聽 | 已有作品、保證獲得支持或獲獎 |
| 13 歲 `offline` | `learning=paper`，老師互動 | 借紙本圖解、一起練習 | 未記錄的成功比賽 |
| 17 歲 `remoteStudio`／`mentorRelay` | `creative=remote`／`collective`，`teacher` 互動 | 連線討論／分段備料共作 | 只是換人名的相同活動 |
| 25 歲 `adult-learning/cooperate` | `creative=collective`，**teacher** 互動 | 實際共作桌、既有老師關係 | 小澄或新貓狗已加入 |
| 32 歲 `adult-boundary-calendar/ask` | `support=requested`；沒有當次 `cheng` 關係增量 | 向當次人物提出需要，尚待回應 | 對方已同意分工 |
| 32 歲 `pacedRole` | `recovery=paced`，`cheng` 互動 | 商量後試過一小段、按步調參與 | 完整接受所有活動 |
| 32 歲 `adult-local-trail/record` | `nature=observing`，`ahe` 當次互動 | 成年沐沐與阿禾分段記錄沿路植物 | 已具帶隊經驗，或只是寄信就表示已見面 |
| 72 歲 `later-reconnect/invest` | 保存 trace 的人物與分支名，加上真實 `friendship` 前史；此選項 **沒有 changedRelationships** | connected → 與阿禾做風車；paused → 與小澄做新風車 | 由缺少關係增量推斷無人，或未聯絡路線仍畫阿禾重逢 |
| 72 歲 `ask`／`rest` | 當次保存 trace 與人物；求助或休息本身 | 討論合適活動／休息 | 已共同完成風車 |

72 歲的已保存事件已具足夠人物、行動及前史證據；只讀呈現可以使用它，不需要為了畫面更動 Domain 或補寫假的關係紀錄。

## 機讀見證

`artifacts/evidence/multi-cast-loop/cast-fixtures/manifest.json` 由 `tools/multi-cast-loop/Fixtures.swift` 呼叫未修改引擎產生。每份保存檔均經完整 catalog-backed replay、Save/Restore 相等與再存位元組一致性驗證，保留 Seed、背景、完整決策與重心、故事事實、當次 trace、人物來源及 SHA。

見證是刻意選取的機制案例，不能推論一般觸發率、真實國家機率或兒少理解程度。對照的 72 歲兩局使用同國家、同家庭、同 Seed；早年選擇不同會合法改變後續事件，沒有修改狀態強迫它們相遇。

已產生 17 份見證：10 歲選前／共同風車／休息；13 歲求助／紙本／休息；17 歲遠距／共作；25 歲共作；32 歲選前／求助／有限參與，以及成年阿禾與沐沐記錄植物；72 歲阿禾／小澄各選前及共同風車。72 歲配對使用日本家庭一 Seed 5，32 歲休息路線使用 Seed 0，其餘原始見證 Seed 34；17／25 共作見證使用肯亞家庭一，不能把此組視為相同背景的策略比較。

成年友情見證 `32-ahe-trail` 是另加的第 17 份；原 16 份存檔 SHA 未變。日本家庭一 Seed 5 在 32 歲實際抽中 `adult-local-trail-recovery`，選 `record` 後與阿禾分段記錄植物；因沒有過往自然觀察記憶，這是入門活動，不能演成帶領團隊。沒有選用 `middle-friend-letter/write` 作為面對面互動證據，因為寄卡片只是提出未來碰面，尚未見面。

## 視覺年齡的假設

阿禾依主角的童年／成年／晚年切換相應造型，是配合同輩友情的視覺設計；不是新增人物出生年。樹老師與小澄沒有權威出生日期，小澄晚年場景使用成熟造型，不能據此稱她與72歲主角同齡。沐沐保留既有五階段基礎，新增互動姿態不代表每個事件都已有五階段專屬動畫。獨立Critic仍將部分青少年／青年外形及兔子年齡辨識列PARTIAL。
