# 互動與關係記憶：驗證帳

PR19 `a79f667` 的有界後續；不改 Domain、Data、Persistence、Seed、schema、國家資料、CI或原30項UI。Draft／HOLD，不合併發布。以下表格在本機收束時填實際結果，不以檔名或排程當成功。

## 產品改變

求助先有提問姿勢，再轉為聆聽，沒有點頭同意、交工具或成功標記。實際協作仍使用獨立活動姿勢。72歲保存後，左邊回看真實10歲選擇，右邊呈現今天的人物；沒有童年約定的路線不畫童年小澄。三個中間階段的中立姿勢改善比例與年齡；活動姿勢沒有全部重畫。

P0投影只取真實保存的current trace、branch與exact historical receipt。當次支持不能從被保留的舊support flag推定。邀請、休息、存檔失敗和不匹配來源都不產生新合作或回憶；動畫不寫人生。

## 已發現並修正的缺陷

| 發現 | 證據／修正 | 狀態 |
| --- | --- | --- |
| 現在事件被寫成童年選擇 | Round1兩個72歲screen及LifeStoryComparison舊source；改成來源年齡與現在年齡分開。回歸包含兩條72路線、真65歲generic來源59及無來源負例 | 最後6項定向回歸PASS；Round2原生文字由獨立Critic關閉 |
| 新25／45中立圖頭頂裁切、童年小框尾巴貼邊 | Round1原生圖；fallback共用safe-space與小框尺寸修正 | Round2正常字級Critic關閉 |
| 最大字級的圖內時間標籤遮臉 | Round2大字圖；固定11pt單行與26pt標籤帶，完整語意保留VoiceOver／正文 | final2遮臉已關，但發現容器置中額外下移裁腳；final3以topLeading修復並重新驗證 |
| 新fixture manifest誤沿用30d6000基底欄 | 20筆真實payload未變；generator改a79f667並重建來源hash | 修正，不抹除Round1差異 |
| 原生時序測試32歲未真正按到求助 | beats批次13兩時間點成功；32按鈕中心在可視頁尾外，isHittable不足。沿用原30UI的可視viewport reveal，未修改產品行為 | 真實時序重跑PASS；最終雙尺寸帳另列 |

`narrative-regression-red.log`只記錄SwiftPM lock等待，排隊程序已終止，**不是紅測試證據**。缺陷由獨立Critic的真實Round1截圖及source確認；新增回歸不虛稱先紅後綠。

## 原生取證的邊界

取證入口只在 `VISUAL_LOOP_CAPTURE && simulator` 編譯，載入真正引擎產生、完整replay驗證且磁碟存讀一致的20個archive。正常App與CI不含該入口。

兩個求助時點：從13／32歲選前存檔進入，真的按ask並保存；演出使用系統單調時間及既有共同clock。capture觀察器在實際elapsed超過200／1400ms時呼叫同一pause操作，沒有注入時鐘值、結果、人物或RNG。斷言早期<1100ms、晚期<2000ms以及兩次保存SHA相同。這證明真實時間點的畫面與存檔不變，**不等於真人對整段動畫節奏的驗收**。

`scene.png`是XCTest原生element截圖，沒有後製修圖。72歲畫內有時間標籤；Critic明確忽略標籤來辨輪廓，不把讀到數字當無字年齡識別。不能單靠圖片證明完整故事因果或未獲承諾，仍保留短文與可追溯紀錄。

## 檢查與缺口

本機、原生、獨立覆審、清理、遠端CI各自以機讀結果和原始紀錄為準。既有Basic治理期限FAIL不關Gate、不更改框架，不因遊戲測試過就說整體CI全綠。真實iPhone完整遊玩、VoiceOver人工巡覽、10～15歲理解及自發重玩、正式美術與八國完整可比資料仍未驗收，不報90–95%完成。

## 重現

```bash
source .venv/bin/activate
swift test
python -m unittest discover -s Tests -p 'test_*.py'
python3 tools/interaction-memory-loop/make-fixtures.py
bash tools/interaction-memory-loop/capture.sh fresh-label iPhone-SE-3rd-generation normal,large,reduced '13-ask,32-ask,72-ahe,72-neighbor,45-neutral,25-neutral,13-before,10-before,72-ahe-before,13-rest,32-participating' all
bash scripts/governance-check.sh --profile basic
```

取證腳本拒絕覆蓋同名來源紀錄，EXIT/INT/TERM都shutdown並delete本次裝置；不要刪除別人的裝置或共用runtime。

本機第一輪全套157個不同Swift案例PASS；那個build早於敘事一行修正，最後另外執行6項定向回歸PASS，不能合稱單次最終158全套。44項既有Python及新增1項透明圖集／來源測試各自PASS。完整新HEAD的158／45與原30UI交由CI另核對。

原生candidate `final/SE`的時序及保存失敗兩案例通過，但矩陣helper將固定頁尾continue錯當成drawer內目標，造成第三案例FAIL。改為只對choice使用drawer reveal、固定頁尾驗證可視座標與可點；產品行為沒有因此改動。失敗紀錄保留；最終只認 `final2` 雙尺寸，名稱為final的較早批次不是最終成功證據。

## 最終來源綁定方式

最後場景矩陣以final3雙尺寸為準。final2雙尺寸各3/3包含實際13／32求助早晚及保存失敗／重試；之後唯一renderer差異是72回憶右框增加`alignment: .topLeading`。獨立Reviewer在記憶體逆置這一個參數後，SHA精準等於final2兩機紀錄；故沿用那些未改路徑的時序／失敗證據，不把它們假稱final3同一批測試。verify-evidence.py檢查此精準邊界、所有截圖SHA、受保護核心無diff、實際存檔checksum及8台專用Simulator清理。

取證時的Git HEAD是基底a79f667，原生使用當時尚未提交的overlay；source.json逐檔SHA綁定實際來源。交付前再次核對最後來源，不能將基底SHA誤當沒有套入新程式。

早期測試開發還有一次`replayed` API名稱誤用造成測試編譯失敗，改用正式`LifeSession.restore`後通過；它不表示產品引擎曾有該API，原focused-swift.log留存。

## 本機收束（2026-10-28）

| 項目 | 實際證據 | 判定 |
| --- | --- | --- |
| Swift | 初版全套157不同案例；最後6定向含敘事回歸；獨立Reviewer另跑6/6 | PASS，分清build時序 |
| Python | 最後單次45/45，含新圖原bytes／透明裁切／年齡範圍 | PASS |
| 最後原生矩陣 | final3：SE3／iPhone17各19狀態（11一般、4最大字級、4 Reduced Motion），各1/1 capture測試，38狀態 | PASS |
| 真實求助兩時點 | final2：13及32歲各早／晚，兩機共8時間點；每對保存SHA相同，實際elapsed符合區間 | PASS，兩姿勢不是連續動畫 |
| 保存失敗／重試 | final2兩機各1/1；原檔及邀請保留，retry保存後才演出 | PASS |
| Source及核心不變 | verification.json：最後source hashes與截圖SHA符合；僅72對齊補證的逆置hash吻合；Domain／Data／Persistence／原30UI／CI無diff | PASS |
| 模擬器 | 本輪8台全部有delete收據，inventory已不存在；失敗批次亦清理 | PASS |
| Basic | 5項PASS、drift WARN，唯一finding仍為session_envelope入冊91日／上限90日 | FAIL，Gate未關閉 |
| 遠端 | 獨立Draft建立後以最新HEAD核對；本表不預填成功 | 尚待執行 |

詳[機讀驗證](../../artifacts/evidence/interaction-memory-loop/verification.json)、[測試帳](../../artifacts/evidence/interaction-memory-loop/local-tests.json)、[工程覆審](ENGINEERING_REVIEW.md)、[視覺Critic](CRITIC.md)。本輪的通過範圍是已授權互動與記憶功能可交review；沒有將全部遊戲、正式美術或真人理解評為完成。

工作預算：08:19 UTC開始，有界範圍沒有再擴角色／故事；實際各Agent思考時間未由工具提供完整工時帳，不能把牆鐘時間或token數冒稱精準累計Agent-hours。等待CI不增加產品範圍。

獨立最終結論：工程APPROVED（限本片）；Visual Critic已確認未解視覺阻擋0。所有前述P1／P2已由修正來源與兩尺寸實圖關閉，歷史紀錄保留。兩pose切換、全活動年齡、真人與正式美術的PARTIAL／未驗收界線不因此取消。
