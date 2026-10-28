# FINAL-POLISH-LOOP 驗證與交付界線

固定基底：PR20 `325b69896553fb6c479e415c0c0991e76ef78a26`。分支 `codex/final-polish-loop`，Draft base `codex/interaction-memory-loop`。不合併、不發布、不上 TestFlight；三輪結束後停在 Owner 試玩。

## 實際改變

- 13 歲求助的筆記本不再消失；32 歲維持坐姿、凳子、紙張與側包。只局部編修兩個聆聽端點，其他圖格不採用。
- 前後姿勢用同一裁切、尺度與地面座標，讀既有共用 Presentation clock。Round2 的 400 ms 淡接留下重影，Round3 縮為 120 ms 並保留真正過渡幀；**不是連續肢體動畫**。
- 移除場景中搶焦的 SF 耳朵／問號；72 歲兩路共用童年尺寸上限及暖紙年代標題，仍只顯示真實前史人物。
- 暖紙結果區與場景統一；最大字級移除裝飾標籤、保留完整選擇與 spoken label、可捲動內容及主要行動。

## 本機測試帳

| 證據 | 實際結果 | 界線 |
| --- | --- | --- |
| `swift test -c release` | Round2 **163 個不同 XCTest 案例通過** | 原158＋新5；沒有把空 Swift Testing runner 計入。 |
| `swift test -c release --filter WorldRequestTransitionTests` | 最後120 ms修正後 **5/5 PASS** | 本機最後驗證是定向5項，不混稱最終單次163全套。遠端當前HEAD另核對。 |
| `.venv/bin/python -m unittest discover -s Tests -p 'test_*.py'` | **48/48 PASS** | 原45＋新3；參照PNG、候選狀態、真實alpha及共同crop。 |
| 原有保護範圍 | **90 個既有檔案逐byte與基底相同** | 原158 Swift／45 Python／30 UI方法保留；Domain/Data/Persistence/GameStore、既有投影/clock、scripts/workflow無改動。 |
| 原生 Round1／Round2 | 每輪SE3、iPhone17各 **3/3 PASS** | 各26個真實狀態與26個可達行動，6個真正clock樣本、60張PNG；不是原30 UI套件。 |
| 原生 Round3 | SE3、iPhone17各 **3/3 PASS** | 各26狀態／26行動，8個clock樣本、62張PNG；正常／最大字級／Reduced Motion，0 runtime warnings。 |
| 保存失敗與重試 | 三輪兩機均通過 | 原檔SHA與未決定場景不變，重試保存後才演出友誼；沒有先顯示成功。 |
| 演出存檔不變 | 三輪、跨機型／字級／Reduced Motion一致 | 13／32四個最終時點的真正存檔SHA相同；不是mock的資源快照。 |
| Simulator清理 | **6台本輪裝置已delete** | `source.json` UUID不在simctl inventory；不只shutdown，不刪其他裝置／runtime。 |
| Basic checks | **FAIL** | 5 PASS、drift WARN exit1；唯一finding仍是`session_envelope`入冊91天超90天。未改框架、日期或Gate。 |

原始執行結果：`artifacts/evidence/final-polish-loop/{swift.log,swift-tests.json,swift-final-focused.log,python.log,basic-checks.json,basic-drift.log}`。每批原生的 `test.log`、`runtime-summary.json`、`logs.json` 保留精確時間／案例／原始xcresult位置。完整原始build/test/xcresult亦在本機ignored的 `artifacts/governance/final-polish-loop` 與 `artifacts/ios`，精簡log未掩蓋失敗。

## 證據來源與獨立覆審

- `fixture-sources.json`列原20份archive的Seed、家庭、事件、逐步Choice、焦點、來源SHA與重播／存讀結果；全部原檔與基底相同。13為Seed34／ask，17為同Seed34的remoteStudio與mentorRelay既有路線，32為Seed0／ask或pacedRole，72為Seed5且10歲invest或rest的實際兩路。
- `source.json`紀錄capture時HEAD為基底＋未提交overlay，逐檔SHA綁定實際App、Presentation、素材、UI test及fixture。**不偽稱native是在尚未存在的最終commit執行。**提交後再將產品檔與相同hash核對；遠端CI則使用PR實際HEAD。
- Round1全部產品/fixture hash逐一對325；Round3對最終目前bytes；每張圖片SHA亦核對。Round2四個改動rendering檔已依最後小改逆置且精準符合capture-time hash，保存在`round2/rendering-source`；未變檔仍由基底取得。這不是另外一筆Git提交。
- `python3 tools/final-polish-loop/verify-evidence.py`核對精確狀態/控制集合、無重複的13／32×觀測時點、同archive SHA、最終source、圖片與已刪裝置；結果在`evidence-verification.json`。其PASS是來源/不變性檢查，不是美術或兒少理解證明。
- 獨立Critic保留[基準問題](BASELINE_REVIEW.md)、[三輪視覺判定](FINAL_VISUAL_REVIEW.md)；獨立工程Reviewer保留[安全界線與驗證修正](ENGINEERING_REVIEW.md)。[七組Before/After](BEFORE_AFTER.md)沒有把未改變的17歲活動包裝成新成果。

## 重現方式

```sh
swift test -c release
.venv/bin/python -m unittest discover -s Tests -p 'test_*.py'
bash scripts/governance-check.sh --profile basic
bash tools/final-polish-loop/capture.sh owner-check iPhone-SE-3rd-generation normal,large,reduced '13-ask,17-remote,17-collective,32-ask,32-participating,72-ahe,72-neighbor' all
```

capture使用專用暫存Simulator；成功、失敗、INT/TERM皆shutdown後delete。不要重用已存在的label覆寫原證據。正常App不編入capture ingress。若要重跑證據verifier，`round3`是本輪凍結最終批次，不能拿新label冒充同一來源。

## 尚未驗收／停止界線

- 短過渡仍可能出現雙手輪廓，尤其暫停於過渡內；自然度維持PARTIAL。本輪不再重生圖或另開Loop。
- 正式美術選稿、角色全活動/全52事件的年齡覆蓋、實機觸控／人工VoiceOver、10–15分鐘節奏、兒少理解與自發重玩仍未驗收。Simulator不是實機。
- 本片沒有新驗證國家統計可比性、也沒有新證明出生環境的教育效果；原資料限制持續存在。
- 遠端CI以Draft PR最後狀態與原始job logs補述；已知Basic失敗不能被遊戲測試成功取代。文件保留提交前的本機狀態，不因上傳結果另開記憶或提交循環。
- 下一步為Owner依既有`docs/life-loop-10h/LL09_PLAYTEST.md`與空白`LL09_RECORDS.md`實機試玩；本輪不自動建立下一任務，不給90–95%產品完成宣稱。

## 獨立最終判定（提交前）

| 判定 | 結果 | 適用界線 |
| --- | --- | --- |
| Engineering Verdict | **ACCEPT** | 當前產品bytes、本機證據與不變性；FP-E1證據工具缺口已關閉。尚未把未來HEAD CI算通過。 |
| Visual Verdict | **CONDITIONAL ACCEPT** | V1求助道具/坐姿、V2焦點、V3兩路尺度PASS；V4大字舒適、V5短過渡殘影PARTIAL。 |
| Product Verdict | **適合 Owner 帶領試玩** | 不是兒少理解、娛樂性、正式美術或發布批准。 |

本輪已確認P1為0；保留PARTIAL而不開第四輪。兩個edited原始圖、七組原生對照、失敗中間幀、source/PNG SHA及獨立報告均可審查。另已清理247,133,312 bytes本輪專用build cache；其他工作與runtime未動。
