# 三項P2定點修正驗收

日期：2026-10-24。基準`a53c992498ab370be4f33bd8a12b00f6cf967c7b`；分支`codex/sim-workshop-continuity`。本輪只有App呈現與UI回歸變更，不新增角色點陣圖，不修改Domain、Data、國家差異或人生規則。[圖庫](REVIEW.md)／[範圍與失敗紀錄](RECOVERY.md)。

**最終判定：PASS — 三項舊P2於13→15歲工坊候選範圍關閉；同來源雙機各17/17、獨立圖像覆核均通過。交付獨立分支供使用者Review，不代表整體產品驗收。**

|原P2|修正內容|驗收依據|
|---|---|---|
|四張同級表單卡，前因不清|13歲真實來源記錄置於機會面板，專屬延續行動與一般行動分層|兩路分別以source event/choice/age對上真正trace；全部選項與成本保留|
|試作橋看似木製模型|原生薄紙帶沿既有桁架，使用暖折邊與細陰影，保留鏤空及手部接觸；材料可近看紙面／摺線|沒有修改角色PNG；原生圖像獨立審查，避免用紙面圖解代替場景紙質驗收|
|觀察與時間只有文字補充|同工坊展開紙面與人物節點；可回看13歲真實快照並返回15歲|免費觀察及回顧／返回均以整份LifeSession相等驗證；記錄期只讀，不可執行今天的新行動|

## 驗證

|Gate|結果|證據|
|---|---|---|
|Swift|PASS 80/80（74 Domain＋6 Analysis）|[完整輸出](../../../artifacts/simulation-p2/swift-final.log)|
|Python|PASS 15/15|[實際Tests目錄輸出](../../../artifacts/simulation-p2/python-tests.log)|
|基本治理檢查|PASS 6/6|[log](../../../artifacts/simulation-p2/governance-basic-final.log)、[收據](../../../artifacts/simulation-p2/governance-basic-checks.json)；不代表runtime治理已驗證|
|SE 3原生完整回歸|PASS 17/17|[summary](../../../artifacts/simulation-p2/narrow-final-summary.json)、[命令與刪除收據](../../../artifacts/simulation-p2/narrow-final-run.json)|
|iPhone 17原生完整回歸|PASS 17/17|[summary](../../../artifacts/simulation-p2/standard-final-summary.json)、[命令與刪除收據](../../../artifacts/simulation-p2/standard-final-run.json)|
|最終SE獨立圖像覆核|PASS：3舊P2關閉，未見新P0/P1|[獨立SE報告](CRITIC_FINAL_SE.md)，實看19張工坊原生圖|
|最終iPhone17獨立圖像覆核|PASS：3舊P2關閉，未見新P0/P1|[獨立iPhone17報告](CRITIC_FINAL_STANDARD.md)，另外實看19張工坊原生圖|

原有14項全部保留，加上3項有實際行為斷言的新測試。最大字級與Reduce Motion保留角色場景、完整選項／成本及最後免費行動；沒有縮圖、封頂字級、刪除測試、放寬斷言或任意長等待。人物面板另檢查不與下方世界內容重疊。

[61檔來源快照](../../../artifacts/simulation-p2/native-source-final.json)包含App、Domain、Data、角色素材、Xcode project與測試。雙機完成後已再次逐檔核對；基準SHA不是被測程式SHA。[新提交綁定](../../../artifacts/simulation-p2/source-binding.json)與原版證據分開保留。

[32檔受保護來源](../../../artifacts/simulation-p2/protected-source.json)保持相同；[最終驗證](../../../artifacts/simulation-p2/verification.json)另外比較完整`assets/simulation`與App asset catalog的路徑清單及位元組，22個素材檔全部保持一致。兩路完整JSON已同時核對前輪基準與兩機型，不能只以文字截圖認定人生規則不變。

原始`.xcresult`及診斷影片保留本機`artifacts/ios/`，不將大型診斷影片加入Git。截圖／JSON及逐附件雜湊進版本控制；早期失敗log、具體AX hierarchy與代表性原生錄影幀同樣保留。每次專用裝置均由runner的finally刪除，包含編譯失敗與測試失敗；最終核對本輪8個專用UUID全部已不存在，不刪其他任務裝置與共用runtime。

## 判定界線

這是13→15歲兩次決策切片的呈現修正。中間年度仍未模擬，連續年度世界、完整P1八國及SIM-04真人遊戲感沒有因此通過。紙面觀察不是完成作品，求助不是保證取得工具；人物熟悉度不是道德或人生總分。沒有新編國家差異或推算引擎未記錄的因果。

Simulator與Reduce Motion回歸不代表實機、人工VoiceOver、最低iOS17或10～15歲真人理解／重玩驗證。既有素材仍是未正式核准候選，`approved_for_app=false`及商用／正式選稿界線保持不變。僅推送獨立分支供review，不合併main、不發布App。

本分支只推送、不新增PR；目前Project CI的push觸發僅main，故不將本機回歸聲稱為遠端CI通過。待日後PR／正式整合時另依同HEAD確認CI。

實作與證據提交為`6c1c3c320e04cac74354048ca5ef1282afa6a9ab`；來源綁定及canonical記憶採後續收尾提交。[記憶流程檢查](../../../artifacts/simulation-p2/memory-closeout-check.json)已執行guard，本輪阻擋0、允許記憶完成宣告；既有記錄仍有background warnings，不宣稱整個歷史記憶或runtime治理已清理／通過。
