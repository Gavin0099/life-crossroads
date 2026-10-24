# 舊 Visual World 候選封存：PARTIAL

使用者於2026-10-24提供 PR9 `c823c82` 的 LIFE-LOOP 10H v1.1 作為唯一正式規格。本分支保留先前場景／角色姿勢候選與實測，不是新計畫的完成交付，不整枝移入新流程。

- 原型大場景、童年／青少年三姿勢、既有成年到老年造型、真實紀錄物件與只讀來源詳情已實作。
- 第一版最終雙機各5/5，但獨立實圖覆核仍為 PARTIAL（P1便條漂浮／共同視線，另有P2）。原報告與圖庫保留在 `INDEPENDENT_REVIEW.md`、`gallery/`。
- 便條已改為角色局部座標，僅為既有阿禾／樹老師補修正姿勢；修正版雙機各5/5，20張新原生圖在 `artifacts/world-art/gallery-v2/`。**修正版尚未做獨立視覺覆核，不能標美術 PASS。**
- 12台本片專用 Simulator（含編譯／測試失敗與受控中斷）均已刪除並查庫確認；其他任務裝置與共用 runtime 未刪。
- 27個核心／資料／存檔／主流程及正式project檔案保持基底 bytes 不變。沒有合併或發布。

新的 LIFE-LOOP 規格要求 Gameplay 注入 `LifeWorldFrame` 與連續的 `PresentationMotionFrame`，暫停不能歸零。本原型以舊 `LifeWorldViewState` 及本機 Timeline 示範，**不符合新的時鐘／正式主流程 Gate**。後續依 PR9 的 VW-01～04 工作，既有候選 PNG 仍需選稿；不得因本片測試過就匯入正式 App。

尚未完成：PR9 LL-01正式契約接線、共同時間軸、one-shot與loop接縫驗證、正式兩事件自然循環、完整人生／分岔整合回歸、實機與兒少驗收。獨立預覽的測試不取代這些工作。
