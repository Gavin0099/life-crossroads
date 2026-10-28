# VISUAL-LOOP-02 原生取證

基底是 PR15 `81371e0aa257233fadd0355faf36ba8e0edcdc64`。新分支只變動 App 與純讀取 Presentation；人生資料、選擇規則及存檔 schema 不變。

1. `python3 tools/visual-loop-02/make-fixtures.py` 以正式引擎、真實可行選擇產生 14 份存檔，逐份經 SaveRepository 存讀與 JourneySave.validate 重播核對。範例不是修改 state 或強迫事件。
2. `bash tools/visual-loop-02/capture.sh <round-label> iPhone-SE-3rd-generation normal,large,reduced`；標準機改成 `iPhone-17`。必須依序執行（共用 capture derived data）。已存在的 label 請換新名稱，避免覆蓋舊證據。
3. 工具建立專用裝置、選支援該硬體的 runtime，使用 `VISUAL_LOOP_CAPTURE` 編譯旗標。只有這種 Simulator build 編入檔案載入／暫停 ingress 與單一 capture XCTest；正常 App、實機與 CI 的30個UI案例不編入此入口。
4. 測試讀真實存檔後只恢復／暫停／拍照／驗證控制可到達，不改選擇。每次拍攝前後比較原檔 SHA；大字與 reduceMotion 讀取實際 UI presentation 狀態確認設定生效。normal14＋large8＋reduced8＝每台30狀態，**不是新增30個正式UI案例**。
5. `scene.png` 是 XCTest 原生元素截圖，沒有以影像工具塗改；`screen.png` 是原生完整畫面。基準舊場景的65歲內含文案，故沒有當成純盲測。
6. `source.json` 記錄當時 HEAD、overlay說明與所有實際來源SHA；`screenshots.json` 記錄圖檔SHA、原附件及xcresult；`runtime-summary.json` 保留測試數與警告。未提交來源以SHA綁定，不把HEAD名義值當成畫面唯一來源。
7. 完整build/XCTest log保留在忽略的 `artifacts/governance/visual-loop-02/`，公開log是判定與capture紀錄投影，`logs.json`保留兩者SHA。三次基準工具失敗及一次第三輪shell啟動失敗單列 `capture-failures.json`，不計成功。
8. `python3 tools/visual-loop-02/verify-evidence.py round3` 核對兩台全矩陣、來源、圖檔、同一原存檔校驗與可行控制；並核對本次全部裝置建立／delete紀錄及simctl inventory。trap在成功、失敗與中止均刪本次裝置，不刪其他裝置或runtime。

畫面中的紙板、草稿、工具是明確活動的原創插畫詮釋，不是家庭實際財物、國家實景、收入或完成作品的統計證據。只顯示被保存的行動；尚未選擇使用獨立中立姿勢。32歲的休息空間來自已完成的生活重心記錄，與本次實選短時參與分開。

AI Critic第一輪先看匿名A–M再給映射；L/M排除純盲測。後輪已知道意圖，是修正覆核而非新盲測。正式美術選稿、VoiceOver實機操作、10～15歲娛樂／理解／重玩仍待真人，不能由這套工具宣稱完成。
