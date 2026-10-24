# LL-08 Visual B：依真實來源留下場景痕跡

本輪是 PR #10 `b896e058bf49f61ec8eafec2a4134a35edff6ddc` 審查後的窄範圍修正。不是重新開十小時 Loop。PR #10 維持 Draft／HOLD，不合併、不發布；LL-09 真人驗收仍未執行。

## 給 Gameplay A 的整合界線

只取 `LifeCrossroads/App/LifeWorldScene.swift` 的變更；`tools/world-trace-visual/` 與本文件、離線證據可一併保存，但不接入 App target。不整枝合併舊 Visual 分支。A 持續擁有主流程、抽屜、狀態發布修正與正式雙機測試。

- 基準 Scene SHA256：`31b43ccf0a5485c41674594c02718dca3eae84d6bcd22ebaeff9a437e7ca6e75`。
- 候選 Scene SHA256：`ced164aefaa15ec5fd93c49024dd4124209cc1e8cf261442a9c95dce4af313cb`。
- 沒有改動 Domain、Data、Persistence、DTO、Motion、人物 PNG、背景 PNG 或遊戲數值。
- 實際 Scene 編譯與來源守衛已通過；最終 iPhone 原生整合、抽屜／頁尾與 warnings 驗收交由 A。離線圖不冒充 Simulator 截圖。

## 來源 → 場景

| 時點 | 真實來源 | 呈現與限制 |
| --- | --- | --- |
| 8歲決策前 | 尚無已執行活動 | 不出現成果道具。 |
| 8歲 `child-interest` 已提交後果 | `resourceChange`，`isOccurred=true`，相同 event／age | invest：紙箱練習；ask：求助紀錄與問號；rest：收好紙箱。沒有畫成已取得安全工具、成功作品或新幫手。 |
| 13歲 `teen-project` 已保存記憶 | `memory`，`isOccurred=true`，sourceAge=13 | invest：線上圖解；offline：紙本練習；ask：仍在找起點；rest：保留時間。桌面掛牌保留13歲來源，之後年齡不把舊事冒充當下成果。 |
| 後續尚未發生 | `pendingClue`，`isOccurred=false` | 時鐘與虛線紙箋，明寫「線索・尚未發生」。不畫成功或邀請已成真。 |
| 17歲已觸發呼應 | `delayedConsequence`，`isOccurred=true`，來源是13歲 `teen-project` | 顯示「17歲的呼應」；只有 pending 或休息路線不會出現。 |

現有8歲事件**沒有持久 StoryFact**。這輪只能呈現該次實際後果，不能聲稱8歲物件已跨年保存。若後續要求持續到13／17歲，需由 Gameplay 另行提供正式來源；B 不在 View 補造故事。線上圖解是活動象徵，不宣稱擁有電腦、設備或國家網路條件。人物只沿用 frame.actors，存在的下一事件邀請者也不代表過去選擇獲得了支持。

## 視覺修改

保留大型角色與原有共同時鐘。新道具有桌面、桌腳與落地陰影；既有 workshop 空桌在有來源道具時不重複繪製。底部後果符號改成同一張暖色紙帶，減少獨立白色小卡。線索／呼應紙箋避開角色臉部，在150pt大字場景放於左下並保留裁切餘裕。完整原因仍在正式資料與場景無障礙說明中。

這些是既有素材加原生幾何的重組。人物視線、手部與整張 PNG 動作沒有新增；河畔共用舞台也不是八國實景。插畫和幾何物件仍有細緻度差異，不能據此宣告正式美術完成。

## 離線驗證與可檢視成果

- [Before／After](../../artifacts/evidence/world-trace-visual/before-after.png)
- [比較結果](../../artifacts/evidence/world-trace-visual/comparison.json)
- [基準來源與圖像雜湊](../../artifacts/evidence/world-trace-visual/baseline/manifest.json)
- [候選來源與圖像雜湊](../../artifacts/evidence/world-trace-visual/candidate/manifest.json)
- [實際使用的存檔與雜湊索引](../../artifacts/evidence/world-trace-visual/saved-lives/index.json)（逐位元複製正式 SaveRepository 輸出，兩版共用，非手造狀態）
- [獨立離線視覺覆核](../../artifacts/evidence/world-trace-visual/independent-review.json)

工具使用正式 Domain、SaveRepository 原子存讀、WorldMomentProjector 與實際 Scene，固定 JPN／jpn-1／Seed0。14組畫面逐一對照同來源存檔，其中是11份不同存檔bytes（大字等畫面重用同份狀態），不是14段不同人生。兩版的存檔SHA、changes、actors完全相同，繪圖前後檔案不變；基準46與候選74項來源／狀態守衛通過。這是守衛斷言數，不是新增74項 XCTest。

Visual B 逐張檢視全部14張候選圖。初輪發現紙箋遮臉、道具懸浮與150pt底緣裁切，修正後重畫。包含8歲3路、13歲4路、決策前、17歲兩條路，以及最大 Dynamic Type／Reduce Motion。沒有啟動 Simulator，沒有新增待清理裝置。這是作者自檢，**不是獨立 Critic、iOS 原生、VoiceOver 實機或兒少試玩 PASS**。

其後既有獨立 Reviewer `/root/simulation_visual_critic` 另行實看全部14候選與4基準圖，核對28張PNG、28份本地原子存檔、27個受測來源及Scene hash，沒有P0／P1。保留2項P2：幾何道具和插畫質感差異、角色目光／手部未參與新道具。它的結論只限離線候選無阻擋發現；不替代A的正式iOS雙機整合與原生圖驗收，也不宣稱全產品美術或acting完成。

重現：

```sh
python3 tools/world-trace-visual/render.py --baseline
python3 tools/world-trace-visual/render.py
```

輸出位於 `artifacts/evidence/world-trace-visual/`。使用已安裝 Xcode／Swift 與既有素材，不使用付費 API、不裝新模型。build／原子存檔中間檔位於 git 忽略的 `.build/world-trace-visual/`。manifest 包含編譯前後來源hash與每張 PNG hash，不以 git HEAD 冒充尚未提交的受測來源。

## A 的原生回歸重點

在相同整合版本核對：8歲未選／休息不多出幫手；13歲線上／紙本／求助／休息可區別；17歲已觸發呼應與休息無呼應；最大字級150pt、普通字級大型世界均不遮臉、不裁紙箋；Reduce Motion 仍保留正確道具。保留正式 screenshot、來源hash、存檔與warning證據；每輪專用 Simulator 完成、失敗或中止均 delete，不刪別人的裝置或 runtime。
