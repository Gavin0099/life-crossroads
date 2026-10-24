# WORLD-ART-01 獨立視覺覆核

Reviewer：`/root/simulation_visual_critic`，2026-10-24。此為暫時、唯讀 reviewer 的有界工作；只寫入本報告，未修改程式、圖像、PLAN 或 memory，未啟動 Simulator，未執行專案 session closeout。

**判定：PARTIAL；目前 Visual 候選品質 Gate 未通過。P0：0，P1：1，P2：3。** 雙機各5/5是原生預覽工程證據，不能取代下列實圖判斷。場景、角色尺寸與三姿勢的基本方向可保留，但便條與共同互動焦點尚有一項 P1。

## 具體問題

| 等級 | 實際圖片 | 發現及修正要求 |
| - | - | - |
| **P1** | 雙機 `03-interacting.png`、`05-teen.png`、`09-seeking.png`，以及 `07-largest.png` | **便條與手部接點不成立，兩人尚未共同看向同一物件。** 童年圖的小便條浮在狐狸外套胸前、主角手掌右下方，沒有手指或表面支承；青少年圖便條疊在貓頭鷹圖本／胸前邊界，與主角伸手位置亦不重合。主角看向手邊，而狐狸／貓頭鷹主要朝主角臉或前方，沒有清楚聚焦便條。最大字級縮放後更容易看出便條是獨立浮層。請先把物件註冊到實際角色局部手掌座標，處理前後遮擋；再讓夥伴視線或姿態朝同一個可信的接觸點。修正後需新雙機原圖，不能以程式註解「Shared focus」或測試 PASS 關閉此項。 |
| P2 | 雙機 `03`、`05`、`06`、`09` | 記憶圖示下的水平木條／層架像懸空的 UI 貼紙，沒有與背景門柱、桌面或掛點形成物理關係。作為來源入口其實可辨識，但目前削弱了場景物件感。可明確採 UI 記憶列或補合理掛點／承托，避免兩者混雜。 |
| P2 | 雙機 `01-idle` 對照 `02-walking`／`10-paused`；`03`、`05` | 晚間版本主要是背景減亮加色調，天空、日光地板斑塊與人物自身受光仍明顯偏白天；能看出明暗變化，但晚間感偏弱。此為質感改善，不要求新增背景量產；後續可調整人物與接地陰影、窗外及門燈的一致光線。 |
| P2 | `narrow/03-interacting.png`；標準機型亦接近右邊界 | 狐狸尾巴超出右邊界被裁切，人物組合較擠。主角本身仍可完整辨識，非 P1；整合時宜留夥伴尾巴／腳的安全邊界，而非只驗主角可及性框。 |

P1 為一個整體互動註冊／焦點問題，沒有將同一問題重複計數為多項。這些判斷來自下列20張圖片；沒有以程式推測代替看圖。

## 可確認的視覺成果

- **角色大小**：雙機普通字級與最大字級均能辨識完整主角，臉、衣服、雙手、腳及尾巴有存在感，已遠大於88×68圖示。當前為專用預覽的大面積場景；這不能證明正式整合時仍保有同樣空間。
- **待機／移動／互動**：童年待機雙手垂下、移動抬腿擺臂、互動張開手掌，三個靜態姿勢可直接區分。`02`與`08`保留相同可辨識步行姿勢。單張PNG不能證明步態自然；已知是單姿勢配位置位移，非完整逐幀走路。
- **接地與透明邊緣**：普通圖腳與門廊平面接點大致自然，移動抬腳姿態不等於整體漂浮。未見明顯白底矩形、棋盤格、硬裁掉的主角耳朵或大範圍去背白邊。這是兩機合成後肉眼檢查，非所有像素／背景的透明品質保證。
- **兩年齡與老年沿用**：童年以連身褲、青少年以背心／短褲區分，黃色領巾、棕色包與水獺身份延續。老年灰毛、眼鏡與針織外套可辨識，且仍在同一門廊。此次照片未呈現童年／青少年六格各自全部獨立預覽，也沒有成年與中年的原生個別圖；不宣稱五年齡完整姿勢已驗證。成年以後沿用靜態素材是已揭露邊界。
- **來源與事實物件**：普通字級的 `04-source` 清楚顯示「留下聯絡約定」及10歲選擇紀錄來源，返回控制可見，沒有把eventID/choiceID露給玩家。`09-seeking` 的記憶列以一般紀錄圖示／褐色區分，未出現獎盃或成功標章；不能只靠圖示推論實際獲得協助。人物旁既有圖本為角色素材的一部分，整合文案仍須避免誤讀為已獲得新成果。
- **最大文字**：雙機 `07-largest` 保留可辨識的人物組合與完整預覽入口；標題和選單換行，沒有把字級封頂。可是20張選定圖中**沒有最大字級下來源 sheet 本身**的截圖，只有普通來源 sheet 及最大字級返回場景。其實際字級／最後一行排版不能由本報告當作已看過；測試可另證明互動，不等於視覺收據。
- **暫停／Reduce Motion**：`08`、`10`的場景與人物保持可見；是否真的停止位置與局部 Timeline 必須看工程斷言／時間序列，不能由一張PNG證明。此 reviewer 未進行動畫影片或系統設定操作審查。

## 實際版本、來源與完整性核對

先讀取了 `WORLD-ART-01.md`、`asset-manifest.json`、`alpha-inspection.json`、`protected-source-check.json`。圖集記錄1536×1024 RGBA、alpha極值0…254及背景透明；本次獨立核對其輸出SHA並看合成邊緣，未宣稱重做完整alpha像素統計。

- 基底：PR8 `c136bebf48ae17e24235d9da72d7f9e51b90bf0c`；契約 `life-world-view-1`。
- 雙機 source-binding 的**10/10 source檔**逐檔重新hash均與當前檔吻合；兩輪來源／素材SHA相同。
- 雙機 **2/2契約SHA**與目前 `tools/world-art-preview/contract-snapshot/LifeCrossroads/Presentation/` 的原樣公開契約快照吻合：`LifePlayback.swift` = `f8c8f206394bb36a82c480937dfaed9bcc2344cc7f83652178da1cb2b0a27ef3`；`LifeWorldViewState.swift` = `68957507afc2533d1890abf5d82761cd4f87eb0c0911ff689ff5d9e5a0d5c1cc`。這證明預覽編譯來源對應，不證明正式Gameplay整合已完成。
- asset-manifest **3/3素材**及protected-source-check **27/27受保護檔**重新hash均吻合。
- gallery **20/20 PNG**重新hash皆符合各自source-map；亦與source-map目前 `raw_attachment_local_path` 的原生匯出附件hash吻合。原始匯出檔名為歷史識別，完整附件現在位於忽略的 `.build/world-art-preview/final-raw-attachments/<run>/`，沒有把搬移視為重生圖片。
- `standard-20261024T045200Z` 與 `narrow-20261024T045202Z` 的test-summary各5 passed、0 failed、0 skipped；cleanup收據皆 `deleted=true`、exit0。Reviewer未自行開啟／清理任何Simulator。

| 受測來源收據 | source-binding SHA-256 | 核對 |
| - | - | - |
| `standard-20261024T045200Z` | `4983079b01d95de9611a3eaeeadcaa866d1cfdb49d80a2921ff3ef81b5aebd4c` | 10/10 sources + 2/2 contracts MATCH |
| `narrow-20261024T045202Z` | `4983079b01d95de9611a3eaeeadcaa866d1cfdb49d80a2921ff3ef81b5aebd4c` | 10/10 sources + 2/2 contracts MATCH |

## 20張實際檢視圖片收據

每張均以 `view_image` 開啟原圖；不是只看contact sheet。下表路徑相對 `artifacts/world-art/gallery/`。

| 實看PNG | SHA-256 | source-map與原生附件 |
| - | - | - |
| `standard/01-idle.png` | `999d5e54d7f67006a617ccc17a819c945c3f2cc147eb488baf1020a2e66ebdf1` | MATCH |
| `standard/02-walking.png` | `7496a6b37a0132185581192d7deb384401afe134beb391d083df647dd9544a2e` | MATCH |
| `standard/03-interacting.png` | `d5be1a6e777cbc854c0d0d8c534545f3b87edf1cf08a42d3779d58600557d88d` | MATCH |
| `standard/04-source.png` | `b8671023d9517e9b738eca70d515f7ec7d2049e093392509faace319315858f5` | MATCH |
| `standard/05-teen.png` | `8e0a86d6ad57010c3263313016441a538f1630dd25c594ddab9105806d9e0fba` | MATCH |
| `standard/06-elder.png` | `f7dcdda149b42d2ead9fc65208cfc319597aeb32fa882db739bf58a598454509` | MATCH |
| `standard/07-largest.png` | `9745dafe37b5ddd39721b28a6dbd88ee6cf5ba9cee50f45a577335c2e02a72be` | MATCH |
| `standard/08-reduced-motion-walking.png` | `97a23c090979436bc2e09068fdeb4beb10aeb3bebde812e24caec82b439312ad` | MATCH |
| `standard/09-seeking.png` | `78c1a19ce0ddb476432ffaa73427e4453a9b7a2380139f3620d353c6b7e59c02` | MATCH |
| `standard/10-paused.png` | `0c6dcbca8c9cf20f1aedb3418947a26a00887a776f4594ec46d346d5b7b885b4` | MATCH |
| `narrow/01-idle.png` | `52f4dd0745df96375617cb23b6211a1930ad5c62c5d8ce4c7ac4c6e385b862ad` | MATCH |
| `narrow/02-walking.png` | `e712917d83c8e8415293f6ceeb1c21de6c93957d190494cd3d5c579f815d7b87` | MATCH |
| `narrow/03-interacting.png` | `65bfe57110d09b544b402daab96d6dad7951fab27f3d16743ad12ef19b5cd95d` | MATCH |
| `narrow/04-source.png` | `f495848c53f711e238daf4d9aa1f6a4ed69b649fce9fb07f744919e6c1fab2ef` | MATCH |
| `narrow/05-teen.png` | `bab5fd2f100a064f5053aaf1d7aecf756bffd25a1cc9513f163d0f9de4cc0e4d` | MATCH |
| `narrow/06-elder.png` | `e0aca521a58a3a3b22fdb5cdd6fa72e09699d6c45638a4dd548310ffde0462b5` | MATCH |
| `narrow/07-largest.png` | `289e8de735d7959a07197323a9b905592e79f984943e2cb5e05300f7aef0f79f` | MATCH |
| `narrow/08-reduced-motion-walking.png` | `6aaf0ee25137c3d4b018c30ad76c9754c69dcb56200ade1f40230327c273cf97` | MATCH |
| `narrow/09-seeking.png` | `d51a02842c5a716aa091831cac24dcf5bab864479d9b1ed0ee28a34fdd44da07` | MATCH |
| `narrow/10-paused.png` | `c9587597255b0d6d41c7801e11b401ea099d3a5fa0c1d2e2f52c739b2f06275e` | MATCH |

## 判定邊界與下一次覆核條件

保留本版成果與PARTIAL判定；核心P1修復後，以新圖像版本／來源收據再次覆核便條接點、遮擋及共同視線，再決定Visual候選範圍是否PASS。既有失敗圖與本報告不應被新圖片無聲替換。

此為**獨立視覺預覽覆核**，尚非正式人生主流程整合、正式存讀／Seed回歸、真人遊戲性、兒少適齡試玩、人工VoiceOver、實機、商用權利批准或人類選稿批准。背景是共用寓言門廊，不是某國真實家庭設備。來源物件可追溯不等於現實因果，候選素材也未因工具可用或測試通過就取得正式批准。沒有合併或發布判定。
