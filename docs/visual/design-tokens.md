# SwiftUI 視覺元件規格

值直接對照 `UIPrototype/VisualPreview/VisualDemoModels.swift`。iOS 17+，直向 iPhone。

| Token | A | B |
|---|---|---|
| background | #F5F0E6 | #101D30 |
| surface | #FFFCF5 | #1D3049 |
| ink | #243A39 | #F5F0E6 |
| secondary | #526460 | #BECAD5 |
| accent | #245D56 | #BDE4DA |
| onAccent | #FFFFFF | #152D35 |

字體：標題 `.largeTitle` rounded bold、選項 `.headline`、內文 `.body`、說明 `.subheadline`、元資料 `.caption`。
不使用固定縮字或正文 `lineLimit`。字級依 Dynamic Type；英文章節眉只作裝飾層。
間距：頁邊 20、卡片 18、卡內 12、選項 10；圓角卡 20、按鈕 16～18。
最低點擊高 44；主要按鈕 48+、選項 64+。捲動長文，不把資訊縮成一行。

元件：ChapterHeading、StageStrip、StoryArtwork、ChoiceCard、OutcomeCard、FactorCard、ContextCard、FooterActions。
同一組排版用 `VisualDirection` 換 tokens 與 art，不複製兩份互動邏輯。
`ViewThatFits` 在大字把人生階段、資源列、頁尾按鈕轉直排。

VoiceOver：標題帶 header trait、裝飾圖用單一情境描述、按鈕同時讀取名稱與成本。
閱讀順序：章節/年齡 → 場景 → 限制 → 選項 → 當下後果 → 延遲提示 → 原因 → 環境比較。
圖示/文字共同表意；不以紅綠表示好壞。原型無動畫，Reduce Motion 無需等待/特效。

實際 VoiceOver 語音巡覽、觸控探索及真實 iPhone 效果仍待測；XCTest 可存取標籤不等於已通過 VoiceOver。
