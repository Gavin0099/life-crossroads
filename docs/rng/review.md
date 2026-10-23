# RNG-01～04 交付審查

本輪在 `codex/rng-event-director`，以引擎分支 `ad773f9b450612fe58513b5ce54d538b7cc0f215` 為基底，完成可執行的純 Swift 人生事件導演。原本每局固定按陣列順序走15個事件；現在可在相同人生節點，依角色狀態與固定 Seed 從候選池選事件，並保留完整入選及後果紀錄。

交付是 **19個事件定義、每局15個重要決策的有界工程切片**。P1仍維持八國、16家庭、50～70原創事件、每局12～18個重要決策及10～15分鐘；本輪沒有把四國批次或程式測試當成整個P1驗收。

## 先看實際差異

| 原有引擎 | 本輪新增行為 |
| --- | --- |
| `LifeSession` 用決策索引推進固定15節點 | `DirectedLifeSession` 在15個語意slot中使用 `EventDirector`；legacy模式保留 |
| 三條具名歷史分岔，沒有一般事件資格層 | `EventEligibility` 支援年齡、環境指標、家庭、資源、人物fact與歷史選擇 |
| 事件ID一生只可決策一次 | 定義ID與occurrence ID分開，支援一次性、重複次數、冷卻與互斥 |
| 已有 `KeyedRandom` 與 `ConsequenceTrace` | 保留既有後果key，另建slot抽選key；新增候選資格、權重、拒絕原因與抽樣trace |
| 人物與延遲效果依歷史接續 | 明確choice effect建立人物fact，真正開啟晚年選項；重複hook各有來源且恰觸發一次 |

權重使用正整數與穩定語意ID排序；候選陣列反序不改結果。國名沒有成功倍率；環境條件讀取帶來源的指標值。本輪原創互助事件沒有硬套網路人口比例，指標條件能力以明示邊界fixture驗證。加入新合格候選會改變分布，沒有承諾內容更新後仍保留舊入選結果。

每個事件必須保留適齡、離線、免材料且回合額度可負擔的求助選項，以及免費休息；會被既有故事條件隱藏的選項不能充當唯一保證路線。未知人物fact不等於明確的false。錯版本、偽造歷史、人物fact或offer會拒絕；`Codable`解析後以 `DirectedLifeSession.restore`／`validate`重播核對，不把解碼成功當存檔有效。

完整設計見 [design.md](design.md)，獨立測試契約見 [batch-contract.md](batch-contract.md)。指定第三方版本的實讀研究及採用界線見 [reference-study.md](reference-study.md)；未移植其程式、劇情、資料庫或素材。

## 可核對的結果

以下讀自 [batch.json](../../artifacts/rng/batch.json) 與 [validation-manifest.json](../../artifacts/rng/validation-manifest.json)，不是預期目標。

| 驗證 | 實際結果 |
| --- | --- |
| XCTest | 70項通過，0失敗：47既有＋23新測試 |
| 主批次 | JPN、USA、IND、KEN × 2家庭 × Seed 0～127；1,024／1,024完成 |
| 完整人生 | 每局15決策、五階段、80歲回顧；80歲是敘事收束，沒有死亡模型 |
| 同決策重播／候選反序／中途續玩 | 各1,024／1,024完整session相同；3,072段對照另計，不加入主樣本數 |
| 事件覆蓋 | 19／19曾符合條件並實際入選；零資格、零入選清單皆空 |
| 選事件／後果trace | 各15,360筆 |
| 已執行長期變化 | 1,448次合法重複occurrence、1,640次延遲回應、680筆人物關係fact |
| 違規 | 未合資格入選、一次性／次數限制、冷卻、互斥、trace配對、求助、完整人生及死路均0 |
| 路線變化 | 每家庭128個Seed中75種事件序列；不是75份獨立劇本 |
| 定向變異 | 移除排序、冷卻邊界錯誤、忽略人物關係，3／3被測試assertion抓到 |

原創候選的入選率分母是符合條件的slot，不能解讀為人口發生率：

| 原創事件 | 合格slot | 入選occurrence | 具體機制 |
| --- | ---: | ---: | --- |
| 社區借物站 | 1,664 | 960 | 早期求助／參與留下有來源的借物聯繫 |
| 社區修繕練習 | 4,040 | 2,460 | 最多3次、間隔至少10年，實際技能與延遲回應 |
| 互助空檔 | 20 | 12 | 照顧安排＋既有求助歷史；與修繕練習互斥 |
| 晚年借物經驗分享 | 1,608 | 952 | 借物聯繫＋技能28開啟主持，未達門檻仍能求助／休息 |

窄條件另有合法可重播路徑：KEN／家庭1／Seed 5在45歲到達互助事件；USA／家庭1／Seed 0在80歲以童年留下的聯繫開啟主持。同Seed改選休息時主持選項不開放。兩者的輸入選擇與實際trace保存在 `batch.json` 的 `targeted`。

原始 [Swift測試log](../../artifacts/rng/logs/swift-tests.log)、[批次log](../../artifacts/rng/logs/batch.log)、[變異摘要](../../artifacts/rng/mutations/summary.json)皆保留。QA前的證據放在 [pre-qa](../../artifacts/rng/pre-qa/)，最終驗證以manifest綁定的來源與輸出SHA-256為準。這些工程測試不證明真人娛樂性、教育效果或現實發生機率。

## 執行與 iOS 編譯

在repo根目錄執行：

```sh
swift test
swift run -c release life-demo --director-audit > /tmp/rng-batch.json
```

第二個命令預設1,024段主樣本。`--seeds-per-context 2`只有16段smoke，不代替完整批次。

正式App target仍透過本機Swift Package引用 `LifeDomain`、`LifeData`；Package使用目錄來源探索，因此新Domain檔案自動納入，無須修改 `project.pbxproj`。已用下列命令編譯正式App及新Domain，arm64／x86_64均成功：

```sh
xcodebuild -project LifeCrossroads.xcodeproj -scheme LifeCrossroads \
  -configuration Debug -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/lc-rng-ios-build CODE_SIGNING_ALLOWED=NO build
```

此檢查沒有建立、啟動或留下Simulator裝置；暫存DerivedData亦已刪除，保留 [編譯log](../../artifacts/rng/logs/ios-package-build.log)及[來源雜湊收據](../../artifacts/rng/ios-package-build.json)。有一項AppIntents metadata因無framework依賴而略過的工具警告。**編譯通過不代表正式App已切換事件導演**：`GameStore.session`目前仍為legacy `LifeSession`，本輪沒有更改既有App行為。

## 後續整合建議與未完成項

- **LC-03**：跨國比較固定已選offer及choice，重新檢查該背景資格；不符合即標示不可比，不偷偷另抽事件。事件合格但選項成本不可行，保留 `applied=false` 的實際限制trace。八國資料與台灣缺口仍按原計畫處理。
- **LC-04**：把director／catalog／engine版本、slot、occurrence、關係facts與待觸發hook納入快照。保留原局，回到岔路改選後重播；目前的Codable核對不是完整改選UI或SwiftData交易驗收。
- **LC-05**：沿本次資料契約擴充至50～70個真正不同的原創定義；分開量測合格次數與入選次數。重複同一定義、國家文案變體或只換ID都不能增加內容量。
- **生活世界UI**：由同一個directed session輸出目前offer、人物fact、實際後果與time jump的View DTO；畫面表演已執行的變化，不自行抽事件或計算數值。原因／比較保留深入功能。正式App接線需要獨立垂直整合與UI回歸。

尚未實作真實出生分布抽選、正式App的事件導演切換、逐年連續生命演化、SwiftData存檔、完整改選UI，亦未驗收實機、兒少理解、10～15分鐘節奏或重玩意願。本輪沒有合併PR或發布App。
