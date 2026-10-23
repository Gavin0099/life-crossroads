# LC-02 原創故事視覺

本輪把出生、事件、選後回饋及人生回顧接成繪本旅途。主角「沐沐」隨五個人生階段換成年齡對應的水獺造型；當頁同行角色只由引擎的 `recurringPerson` 選取，回顧則讀當時 trace 的實際人物、事件及選項。沒有為國家分派物種、服裝、角色好壞或視覺上的高低等級。

插圖是一座各國共用的虛構河畔舞台，不聲稱是日本、美國、印度或肯亞的生活實景。首頁及說明頁均明示這個界線。家庭條件、代價、故事分岔及結果仍由離線引擎決定；插圖不作為統計或文化考證證據。

## 來源與保存

2026-10-23 使用內建 `image_gen`（built-in tool mode）生成兩個全新資產。沒有使用參考作品、外部圖片、下載素材或 CLI/API fallback；沒有傳入參考圖。工具沒有回傳可核實的模型版本，因此不另外宣稱特定 image model。

| 資產 | Workspace 路徑 | 原始尺寸 | Alpha | 用途 |
| --- | --- | --- | --- | --- |
| 河畔岔路舞台 | `LifeCrossroads/App/Assets.xcassets/RiverCrossroads.imageset/river-crossroads.png` | 1536 × 1024 | 無 | 出生、事件、選後與回顧的共用場景 |
| 五齡主角及三位同行角色 | `LifeCrossroads/App/Assets.xcassets/StoryCast.imageset/story-cast.png` | 1774 × 887 | 有 | 四欄兩列透明角色圖集，SwiftUI 顯示時裁切單格 |

SHA-256：

- `river-crossroads.png`：`141d42dd9a537d642fb9451338b286ee981893629fee75bdf056066796e37947`
- `story-cast.png`：`663bb1b1ce8a0af2ed99be72827a6e4bc69978eb00708df62f7b27cd85e068d8`

圖集依序為：童年、青少年、青年、中年的沐沐；第二列為晚年沐沐、狐狸阿禾、貓頭鷹樹老師、兔子小澄。完整 PNG 直接複製進 workspace，未以影像工具重畫、合成、裁切或重新取樣。`StoryPortrait` 在顯示時從圖集取單格，`StoryScene` 將與當頁引擎人物相符的角色放進舞台。

工具原始輸出位於 `$CODEX_HOME/generated_images/01a167a2-1bac-7180-8840-392f4977dbea/`，兩個檔名分別為 `exec-9b18d9e2-550a-4e13-b8ea-0530c6c80add.png`、`exec-89a86f13-a841-406a-864c-c09862731a0d.png`。App 只參照 workspace 的 asset catalog，不依賴工具輸出路徑或網路。

這些是 AI 生成的原創資產。沒有挪用第三方素材不等於已完成各地區 AI 著作權、商標或完整內容相似性法律審查；不得將本筆來源紀錄當作 App Store 發布批准。後續如替換圖片，保留新來源及檔案版本紀錄。

## 生成提示全文

### RiverCrossroads

```text
Use case: illustration-story
Asset type: a reusable landscape background for an original iPhone portrait story game for children ages 10–15, titled Life Crossroads (do not draw any text)
Primary request: A warm hand-painted storybook riverside village crossroads, with an open gently curving path in the foreground splitting toward a small community workshop and a footbridge, a large leafy tree by the river, cozy distant buildings, wildflowers, and lots of open foreground space for separate character sprites.
Style/medium: original sophisticated children's book gouache and colored pencil, softly tactile paper grain, clear bold silhouettes, warm honey light, muted forest green and turquoise river, peach and cream accents. Charming, expressive environment without excessive tiny detail; appeal to older children, avoid babyish preschool look.
Composition/framing: landscape 3:2 illustration; quiet center and lower foreground kept clear. Edge to edge artwork suitable for wide scene header crop on an iPhone. No characters, no people, no animals in the scene, no text or lettering.
Constraints: This is a fictional allegorical stage shared by all countries; no flags, no national landmarks, no ethnic cues, no logos, no watermark, no UI mockup. No imitation of any existing game or artist.
```

### StoryCast

```text
Use case: illustration-story
Asset type: one transparent character sprite atlas for an original iPhone life choices story game for ages 10–15
Primary request: Create eight completely separated full-body anthropomorphic animal character sprites on a genuinely transparent background. Arrange in an EXACT uniform 4 columns by 2 rows grid, each sprite centered in its own equal cell, all characters fully within their cell with generous empty margin, feet at same relative baseline, no overlapping, no ground or shadows beyond each cell. The total canvas is wide 2:1. Each character is standing in a gentle three-quarter pose facing the viewer. No cell borders, no labels, no text.
TOP ROW left to right: (1) a young curious brown river otter child wearing a cream shirt, teal dungarees, small amber scarf and carrying a tiny explorer satchel; (2) the same otter as a teenager, slightly taller, wearing teal vest and cream shirt, amber scarf, holding a notebook; (3) the same otter as a young adult, cream shirt and teal utility jacket, amber scarf, casual shoulder bag; (4) the same otter in middle age, mature rounded face, teal cardigan and cream shirt, amber scarf.
BOTTOM ROW left to right: (5) the same otter in old age with gray muzzle, round spectacles, teal cardigan and amber scarf, comfortable erect stance, no implication of frailty; (6) an expressive warm orange fox friend wearing a coral-red jacket and cream shirt, a leaf tucked into pocket; (7) a friendly owl teacher with warm beige feathers, round spectacles, moss-green vest, holding a paper diagram; (8) a friendly cream rabbit community companion wearing a muted lavender tunic and carrying a small woven basket.
Style/medium: original sophisticated children's book gouache and colored pencil, softly tactile painted textures, simple clear lively faces and bold silhouettes; consistent scale and style across all eight sprites; warm muted palette, expressive but not babyish.
Constraints: true transparent alpha background, no checkerboard, no solid backdrop, no flags or nationality coding, no brands, no logos, no watermark, no imitation of any existing game or artist. Exactly eight sprites in the specified 4 by 2 order. Each sprite should occupy roughly the central 65 percent of its cell width and 85 percent height.
```

## UI 與無障礙邊界

- 必要的事件、人物、可選行動、預算、實際結果及分岔原因均為獨立原生文字，並非圖片中的文字。
- `birthScene`、`decisionScene`、`reflectionScene`、`endingScene` 各自提供反映當頁圖像內容的讀屏標籤；圖集的單一角色圖是裝飾內容，不重複朗讀。當引擎人物沒有對應插圖，場景不假稱圖中有該人物，頁面仍列出人物文字。
- 不把整個畫面合併成一個無障礙元素；既有選項、比較、繼續及關閉控制的 identifier 保留。
- 字體使用 Dynamic Type；無障礙文字尺寸下，國家及家庭選擇改為選單。預算及近況使用可換行布局，長故事可捲動，首頁保留短文模式。
- 沒有強制動態、閃爍或自動播放動畫，減少動態設定不需要額外視覺替代流程。重要資訊不只靠顏色區分。
- 四項資源不合成評分；回顧先呈現當前狀態與個別故事，曲線放進可展開的歷程中。

## 本代理驗證及未驗證

已用 `view_image` 目視檢查兩個原圖的內容及圖集排列，以 `sips -g pixelWidth -g pixelHeight -g hasAlpha` 核對尺寸與透明度；`plutil -lint LifeCrossroads.xcodeproj/project.pbxproj` 及 `xcrun swiftc -frontend -parse LifeCrossroads/App/CrossroadsView.swift LifeCrossroads/App/StoryVisuals.swift` 通過。

以上僅為資產與語法檢查。完整 Xcode build、Simulator 流程、小螢幕裁切、最大文字、VoiceOver 實際操作、真實 iPhone 與兒少遊玩吸引力，由主代理整合驗證或後續實測提供證據；此文件不預先宣稱這些項目通過。
