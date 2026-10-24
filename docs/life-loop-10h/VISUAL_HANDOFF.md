# Visual B 前置交接（PARTIAL，非另一份計畫）

唯一規格為本目錄既有 PLAN／SLICES／CONTRACT／MOTION，基底 PR9 `c823c820ceea027215df2d2f46c2c0ac4373c871`。本文件只記實際產物與依賴，不改10h工時帳或六項Gate。

## 已做

- VW-01來源預查：核對 rossark 固定 `9b20964` 的五個檔案與 MIT；採小幅動作方法，不安裝Skill、不複製 helper、不採 Demo素材。逐檔 blob SHA 見 `artifacts/evidence/life-loop-visual/rossark-audit.json`。
- 使用原有 StoryCast／RiverCrossroads 與少量 SwiftUI 圖形建立 `LifeWorldScenePreviewModel` 與隔離 Preview。8／13／39歲可檢視；沒有匯入舊分支的三組候選PNG。
- 只讀傳入時間：沒有 Date、Timer、TimelineView 或遊戲回呼；同相位暫停不歸零，loop閉合、Reduced Motion首幀／結果末幀、未提交不播結果、非法時間邊界等七個純取樣檢查通過。
- 8張 macOS SwiftUI ImageRenderer 影格在 `artifacts/evidence/life-loop-visual/frames/`，有明確示意標記。不是iOS原生截圖，不是假裝正式trace來源。

## 未完成與接線依賴

最新查核到 Gameplay 正式分支 `codex/life-loop-gameplay-10h` 的 `4980643cfa5157f62e6853c6a3707209cbe1ab27`：只完成 LL-00 基線與舊原型隔離，尚未發布 LL-01 DTO。共享規劃基底只有 `ProjectMoment.swift`。舊 `codex/life-loop-01` 的 `65fff9e` 使用 `LifeWorldViewState`／`LifePlayback` 舊接口，不能當作 PR9 的 LL-01 已凍結。

Gameplay A需推送 LL-01 可編譯的 `LifeWorldFrame`／投影及累積時間契約，並給出共享SHA。之後B將顯示fixture換成單向adapter，不把fixture當Domain。結果單次動畫需A提供同token的相位經過時間／起點；B不另外造時計。

VW-01整片仍是PARTIAL，VW-02～04尚未完成；新正式App、同Seed不同選擇／已保存trace、雙機／最大文字／VoiceOver、loop動畫真實觀看、暫停調速／背景時鐘與六項Gates皆未驗收。純取樣測試只保護renderer，不證明A的控制器或存檔正確。

Visual預算仍為2 Agent-hours，Skill預查包含在內；此次不啟動新的四小時循環、不加圖像工時、不修改A的迭代總帳。可核對的工作樹開始／本輪記錄時間另存 `preflight-provenance.json`；這個區間不是全團隊精確工時，先前舊規格工作另列，不重複算成新Slices完成。

## 重現

```bash
mkdir -p .build/life-loop-visual
xcrun swiftc -swift-version 6 -parse-as-library -target arm64-apple-macos14.0 \
  LifeCrossroads/App/LifeWorldScenePreview.swift tools/life-loop-visual/Render.swift \
  -o .build/life-loop-visual/render
.build/life-loop-visual/render "$PWD"
```

只產生原生SwiftUI預覽影格，不建立Simulator。正式Xcode project／Package／UITests接線仍由A擁有。

舊規格候選另保留在 `codex/world-art-01`（實作 `54183d4`／記憶 `c638ee5`），其最後雙機各5/5與12台Simulator清理收據屬舊原型；修正版美術未獨立覆核，原始覆核PARTIAL。舊版使用本機Timeline，**不符合PR9新時鐘契約，不整枝合併或自動匯入候選圖**。
