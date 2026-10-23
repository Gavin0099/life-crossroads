# Life Crossroads Visual Agent

2026-10-23；工作分支 `codex/lc-visual-design`，從 LC-01 `6a5137b` 分離。
本線不修改主工作目錄中的 LC-02 未提交變更，也不以原型代替四國完整人生驗收。

本輪：LV-00 工具查核、LV-01 兩風格 UI 與候選圖；依使用者追加，製作四角色五階段圖。
ZIP 原稿保存在 `handoff/`，是規劃參考，並非授權或已完成證據。
原稿的三角色需求由本輪明確追加更新為四角色。沒有從交接文件推導 push、PR 或發布授權。

- [工具查核](TOOL-RESEARCH.md)、[美術準則](ART-CHARTER.md)
- [Art Direction Bible](art-direction.md)、[角色一致性](characters.md)
- [九畫面規格](ui-screen-map.md)、[Tokens](design-tokens.md)、[View DTO 提案](view-contract.md)
- [素材流程](asset-provenance.md)、[驗收與待驗項](acceptance.md)

開啟 `UIPrototype/VisualPreview.xcodeproj`，選 `VisualPreview` scheme；在
`VisualEventView.swift` 選 A/B、後果、比較、缺少原因與最大文字的 `#Preview`。
同一原生 View 可執行於 Simulator；互動只切換 fixture 狀態，不呼叫人生引擎。

所有生成圖均為候選，`approved_for_app=false`。本輪未鎖定正式美術方向。
AI 目視檢查不等於藝術專家、兒少、文化或商用權利審核。
