# 文字與背景對比修正

來源：Owner 2026-10-29 iPhone 試玩回饋「根本看不到字」。基準為已安裝的 PR21 `45d3ff9`。

這是一輪有界的可讀性修正：找出固定淺底與動態白字的接縫；保留既有插畫、版面、選擇文意與人生引擎。使用具深／淺／提高對比變體的 Xcode 語意色票；插畫紙張另外固定一組文字與底色，禁止只切換其中一邊。一般文字最低4.5:1，小字及提高對比目標7:1。

驗收：原生深色 Before；淺／深色主頁、13歲選項／結果、72歲回憶、說明 Sheet；SE／標準尺寸、大字與提高對比檢查；實際色票的對比回歸；原有資料／存檔／動態呈現邏輯不變。專用Simulator成功或失敗皆刪除。保持Draft/HOLD。

採用外部 skill 的有界部分：Paul Hudson `swiftui-pro` v2.0.0，MIT；已讀 SKILL.md、references/design.md、references/accessibility.md。只採用語意色、共用設計常數、適應系統外觀與無障礙的指引，不更新部署版本、不引入框架、不執行不相關現代化。

參考：
- https://developer.apple.com/design/human-interface-guidelines/dark-mode
- https://developer.apple.com/design/human-interface-guidelines/color
- https://github.com/twostraws/SwiftUI-Agent-Skill/blob/main/swiftui-pro/SKILL.md
- https://github.com/twostraws/SwiftUI-Agent-Skill/blob/main/swiftui-pro/references/design.md
- https://github.com/twostraws/SwiftUI-Agent-Skill/blob/main/swiftui-pro/references/accessibility.md

Skill在本輪直接讀取使用，沒有改寫全域Codex設定或宣稱已安裝。
