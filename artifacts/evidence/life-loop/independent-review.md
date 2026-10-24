# LIFE-LOOP 10H v1.1 — 獨立 QA01／QA02

> 結論：有界獨立工程覆核通過，QA02本地手機畫面對照完成。維持Draft/HOLD；細節與Gate邊界見文末。

## 範圍與身份

- Reviewer：`/root/life_loop_review`，只做有界獨立覆核；沒有修改產品、建立模擬器、向 GitHub 發文、合併或發布。
- 正式審查起點：2026-10-24 05:55:25 UTC；上限 1 Agent-hour，包含等待與最後畫面覆核。
- 正式共同規劃：`c823c820`，上游 PR8 `c136beb`。舊 prototype `65fff9e` 的 4/5 結果完全不算本版 G1–G6。
- 已讀 PLAN／SLICES／CONTRACT／MOTION／ITERATION_LOG，以及 repo 規範與治理 review/test 規範。
- 最後來源覆核：`f3bbf10`（projector 快取）；`6e6eea3`（前次原因入口）、`e52886d`（排除無證據泛用人物縮圖）均已讀。文件與記憶後續變更由主流程負責。

## 目前結論

來源與本地原生證據未發現剩餘已確認的工程阻擋。完整原生回歸曾在最大字體測試失敗；實際圖確認手勢起點落在固定 footer，7aa69d2 修正 helper 後最新5項全部通過，沒有移除原資料或可見性斷言。兒少娛樂性、實機、手動 VoiceOver、完整資料可比性與發布另行驗收。

最終原生結果按版本分開：完整16項來源 `7040802` 是15 PASS／1 FAIL；最新 `7aa69d2` 來源的5項定向重跑全過，包含該失敗與 Reduced Motion、回看上次原因、投影快取／存讀接線。不能改報成最後 HEAD 的完整16項已重新全過。

## 已修正發現

| 發現 | 判斷／位置 | 修正與證據 |
| --- | --- | --- |
| F1 失敗 ticket 可在重試期間復活；同 Seed reset 可能重用世代 | 真實 guard 契約缺陷；WorldPlayback `commitFailed`／`bind(reset:)` | `7eff8a0` 失敗增世代，reset 不重建歸零；新增失敗後重試仍拒舊 ticket 與 same-Seed reset 斷言。同步 MainActor 當時未觀測到重複寫檔，沒有據此指稱實際資料損壞。 |
| F2 暫停或冷恢復 outcome 從零進度開始，當前變化 token 可一直不顯示 | WorldPlayback.swift:52、LifeWorldScene.swift:136 | 新綁定的 paused/restored outcome 使用完成末幀；中途 pause 保持當前相位。Visual 最小 opacity0.45，優先當前記憶；focused regression 覆蓋。 |
| F3 捲出畫面未停時計 | CrossroadsView.swift:65、WorldPlayback `setOffscreen` | 以實際 ScrollView viewport 相交更新 offscreen，停自動時計；明確 Continue/skip 仍可用，避免捲到 footer 後無法繼續。focused 覆蓋凍時與手動續行。 |
| G5 舊170pt事件場景讓 SE 首屏沒有可選行動 | 原生 v2 真圖確認；CrossroadsView.swift:165 | `7040802` 壓縮事件時的場景／標頭／故事，保留 living 大場景和完整故事 disclosure。新增首屏真實 hit/midpoint 斷言，最後原生與真圖已通過；最大字體helper修正後亦通過。 |
| 原生 debug token 向一般使用者暴露 | CrossroadsView.swift:170 | 限 Simulator 且 `-ui-testing`，正式顯示保留自然語言。 |

上述修正都沒有改 Domain／Data／Persistence 與統計指標。獨立 diff 對 `c823c82` 的核心路徑為空。

## 重要正向檢查

1. GameStore.swift:36–50：先在本地 journey 執行合法 next，保存成功才發布並重綁世界；失敗停在原 reflecting，暫停且可明確重試。未以動畫預覽冒充已提交後果。
2. GameStore.swift:16–19：世界投影快取僅於成功提交／restore 後更新。動畫 accessor 只轉換演出 moment；living body 不讀 currentEvent／preview，Scene／Motion 沒有 RNG、Domain 命令或 I/O。
3. WorldPlayback.swift:43–95：前一速度結算、暫停／背景／offscreen 凍時、單調演出鐘、identity+generation+in-flight guard；事件等待不會自行選擇，冷讀檔不補算人生。
4. CrossroadsView.swift:137–159：sheet、原局檢視、首頁、背景、錯誤、restart dialog 皆停自動播放；取消 Task 不發布過期續行。VO 開啟會暫停，仍保留明確 Continue。
5. LifeWorldFrame.swift:53–87：真實 applied trace 的淨資源、符合事件／選項／年齡的互動、實際隨機紀錄、既有 story facts；pending 明標尚未實現，triggered hook 不混為 pending。場景不從國籍或插畫推定支援。
6. `whyPrevious` 在自動 next 後開啟實際最後 trace，開啟時停播放；不把上一個行動與當前另一個事件錯配比較。
7. Visual 使用現有 whole-PNG atlas 與原創圖形，由單一外部演出時間驅動小幅待機與道具變化；沒有硬切骨架、自由地圖、外部 demo 人物或第二套人生引擎。
8. 固定 Rossark 方法來源 `9b20964`、MIT notice、blob hash 與未直接複製程式／demo 的清單可追溯；這是來源審核，不是法律認證。

## 驗證與測試品質

### Reviewer 自行執行

- `swift test -c release --filter 'WorldPlaybackTests|LifeWorldFrameTests|WorldPersistenceTests'`：修正後 **9 個 distinct tests PASS**（4時計、3投影、2真實暫存檔），0失敗。raw：`/tmp/life-loop-10h-review-final-swift.log`，主流程另存 `artifacts/governance/life-loop-10h/reviewer-*`。
- 真實 `LifeWorldMotion.swift` + committed `verify-motion.swift` 以 swiftc 編譯執行 PASS：`/tmp/life-loop-10h-motion-check.json`。
- `git diff --check` PASS。沒有重複跑長全套或另開 Simulator。

### 證據強弱界線

- 純值型別播放測試只能證明時計與隔離邊界，未突變的區域變數本身不是 App 寫檔證據。真實 SaveRepository 讀寫、既有 LL00 凍結 trace 比較、存檔 bytes、原生 fault+retry 是另外的強證據。
- normal／fast／skip 的八國重播相等與日本／台灣 preimplementation fixtures 有獨立基準。fixtures 必須保持凍結，不能為配合本輪結果重錄 expected values。
- 新10歲 AX 斷言可抓投影快取未更新；沒有 runtime projector 次數計數，不能說已動態量測每幀呼叫數。
- 冷讀檔、完整分岔的純 Swift bytes 與原生前／中／末紀錄／12段比較互補；不只靠 mock 或 marker 相等。
- Reduced Motion 的 App 切換走同一條實際條件分支；不等於測過 iOS 系統設定或手動 VoiceOver 焦點。
- Scene 使用 source-bound 離線18圖與純 helper：loop0/4000ms 幾何一致；嚴格像素等值曾因1/255量化失敗，對照同輸入重渲染也有相同幅度差異。保留原始失敗與容忍結果，不宣稱 pixel-exact。

### 保留的中途失敗

- 首輪 runner bootstrap 在產品測試前退出；不是產品4項通過或失敗。
- v2：2 PASS／2 FAIL。最大字體 action 中心落在 playback footer 後方，未觸發選擇；native popover 沒有獨立 Cancel AX button。兩者已由實際 hierarchy 定位，沒有改寫為 Domain／存檔錯誤。
- 新 helper 採實際 footer 邊界；取消使用 native 按鈕或 outside dismiss，仍驗 confirm 消失、原 outcome 與磁碟 checksum 不變。不能把 outside-dismiss PASS 說成 explicit Cancel AX PASS。

## 尚未驗收／注意

- 手動 VoiceOver 焦點、真實 iPhone、目標兒少重玩與理解、10–15分鐘真人節奏仍缺證；不以 CI／Simulator 替代。
- 完整全套 summary 記錄3個同字串 SwiftUI「Publishing changes from within view updates」warning，案例本身 PASS；同字串已在正式 PR8 前的 artifacts/evidence/event-visual/final-ui-summary.json 與 initial-ui-summary.json 記錄（validation.json:175–177 標示未修）；本輪仍現，尚無定位堆疊，不能宣稱此輪發出點與歷史根因相同、零 warning 或已證實資料損壞。保留為待診斷。
- 未測每個 view lifecycle 排程交錯；來源 guard 與定向 regression 有效，但不是所有排程的形式驗證。
- 圖片仍屬現有原型、共用虛構舞台，非各國實景；八國資料缺口與統計可比限制維持。
- 不發 GitHub Review，不批准合併；維持 Draft／HOLD，是否進 main 由使用者後續決定。

## 最終原生證據與畫面

完整16項 binary7040802 已完成 **15 PASS／1 FAIL**（1699.935秒）；裝置 1CF72ECB-FD3F-40BD-968A-2A462181272B 已有 delete 收據。已確認：新世界完整分岔373.952秒 PASS、自然兩事件24.786秒 PASS、冷恢復／原因／取消保檔40.680秒 PASS。最大字體141.894秒 FAIL，projectMemory存在卻無法透過 helper reveal 為不遮擋目標（full log12404）。Reviewer 自行只讀匯出並實際看 /tmp/lc-review-world-max/2BF0EC8C-210A-4E50-AD32-4CF6B15E4A41.png：AX outcome footer 約從650px=325pt開始，helper下拖曳點為667×0.65=433.6pt，明確在固定 footer。這支持 helper 手勢起點不在可捲內容的根因；不是已證實的 Domain 或保存失敗。尚須把兩個 drag 端點都限制在真實可捲 viewport 並保留原可見性／資料斷言，再重跑 MaximumText。大型 footer 仍是值得改善的 AX 閱讀 UX，不能因此宣稱手動 VoiceOver 已通過。

最後新世界 save-before-publish／失敗重試26.173秒 PASS。

Reviewer 已自行匯出/實際看 full704 正常字體 SE 圖：

- /tmp/lc-review-world-save/E2CD8A3C-1CC1-4014-BDA8-2B6739E190F5.png：8歲首屏兩個選項完整可見，成本清楚，footer 沒有覆蓋選項；正常字體 G5 改善有真圖與原生斷言。
- /tmp/lc-review-world-save/035C543F-8395-4EE4-8EC0-EC34EDE4F6E6.png：真實已保存 rest outcome 的世界只有主角與記錄 token，沒有未參與幫手；舊 feedback 縮圖仍在此704圖中，e528 source 已排除，不能稱這張舊圖是最後 HEAD。

最新 7aa69d2 定向五項 raw：artifacts/governance/life-loop-10h/world-ui-focused-final.txt，**5/5 PASS**（237.324秒）：

| 項目 | 秒 | 結果 |
| --- | ---: | --- |
| 最大字體紙本事件、真實後果、原因入口 |126.610|PASS|
| 自然相鄰兩事件、不自選、10歲快取、後一次living、前次原因 |28.383|PASS|
| App Reduced Motion 的靜態事實及10歲更新 |20.333|PASS|
| 冷讀結果、原因sheet、取消重開保留bytes |37.449|PASS|
| choose／next寫入失敗不發布，重試後推進 |24.550|PASS|

測試通過已由 reviewer 直接讀 raw；最新畫面和本次裝置 delete 收據在下方補登。未取得者仍待驗收，不以預期填完成。

## 最後 QA02 與本地驗收收束

最新五項 source7aa69d2：5/5 PASS、237.324秒。原生 raw、focused-summary.json／focused-manifest.json 均已直接讀取；runtime warning1個，沒有宣稱零 warning。
八張 *-7aa69d2.png 已逐張實際看完：首屏兩動作與成本、0→8大living、10歲阿禾真事件、10→12回生活並保留暫緩聯絡記憶、rest／Reduced只有主角與記錄token及淨健康+2/人際+1、最大字體紙本選項與紙本故事記憶可捲達。最新rest已無泛用feedback縮圖，無未參與幫手。大字footer仍佔較大畫面，保留為後續閱讀UX，不能稱手動VO已測。
最後raw明示 delete169B437B-65BB-4449-869B-2A42E8A87F3D；simulator-cleanup-final.json 以simctl list確認本輪4台專用裝置全不存在，沒有刪其他裝置/runtime。Reviewer未建立Simulator。

## Gate 與結案邊界

| Gate | 有界判斷 | 限制 |
| --- | --- | --- |
| G1 真實人生 | 本地工程通過 | 八國純Swift15次/80歲、核心diff空；不等於統計完整。 |
| G2 生活循環 | 本地整合通過 | 兩個自然事件、回大living與完整人生/分岔有原生結果；不是兒少可玩性驗收。 |
| G3 決定論 | 工程證據通過 | normal/fast/skip、fixtures、原局bytes、存讀/分岔；不是全部UI排程的形式驗證。 |
| G4 真實後果 | 核心投影/一般與13歲目視成立 | 延遲線索語意有trace/unit/source；未另逐項獨立原生目視的延遲回顧不補算為全Gate完成。 |
| G5 可操作 | 本地SE/最大字體/App Reduced通過 | CI需核最後PR HEAD；人工VO、實機、真人節奏另列；取消只聲稱實測的實際途徑。 |
| G6 動畫與授權 | source/helper/定點畫面與時計成立 | 不把離線圖當實機連續流暢度，無rig/完整動作美術宣稱。 |

沒有剩餘已確認工程阻擋，可以留在獨立Draft供review。維持Draft/HOLD，不批准合併或發布；這不是整體G1–G6/P1/發布資格全數完成。遠端CI與完整產品驗收由主流程另附證據。舊完整16項15/1失敗保留，最新5項定向通過另列，不改報最後HEAD整套重跑全綠。

Review start=2026-10-24T05:55:25+00:00; end=2026-10-24T06:51:06.481111+00:00; elapsed=3341.5s; Agent-hours=0.928 (including waits; limit1h). QA01/QA02 counted once.

## G4 最後有界補證覆核（4d3308e）

本節更新前述 G4「延遲回顧未獨立原生目視」缺口：**G4 本地工程／原生畫面驗收通過**。

只讀覆核 test-only 29行 diff：App／Domain 未改。真正從日本家庭一、Seed0，rest三次到13歲，再選invest、成功保存。測試先讀真實scene.value斷言「留下線索，尚未實現」；實際continue至17歲後，讀worldChange.delayedConsequence並斷言「17歲的呼應」、不含「尚未實現」，最後跳至正式17歲事件並驗scene年齡。沒有測試硬塞世界事實或修改模型。

已讀 delayed-summary.json／delayed-manifest.json／world-ui-delayed-final.txt：1/1 PASS44.367秒、0 runtime warning（僅指這一次）、對應來源4d3308e275705972121134582321deaef77609be。此新案例不能與前5項重跑冒加為完整最新HEAD全套。

已逐張實際看 world-thirteen-pending-clue-4d3308e.png 與 world-seventeen-occurred-echo-4d3308e.png：13歲已存線上創作、老師互動和待發生clock線索；17歲同世界明文顯示「樹老師記得你當年的選擇，這次邀你一起分享經驗」，保留10/13歲真實記憶。發生/未實現語意沒有混用，並未把邀請寫成必然成功。這補齊一般事件、13歲與延遲線索回顧的G4目視證據。

raw末尾已明示delete4D5BE544-62B0-45D3-9CE2-9695BF438CD8。沒有啟動新測試或Simulator、沒有產品編輯或GitHub操作。其餘人工VO／實機／兒少／最新CI／G6完整手機連續演出資格邊界維持。

G4 supplement start=2026-10-24T06:56:10+00:00; end=2026-10-24T06:56:56.270341+00:00; actual=46.3s; prior QA window3341.5s + this supplement=3387.8s (0.941 Agent-hour). The interval after the prior final report and before this new bounded request was stopped, not active QA or test waiting. Even reserving60s for prior final-report notification overhead stays below3600s.
