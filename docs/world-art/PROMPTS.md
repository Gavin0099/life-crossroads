# WORLD-ART-01 圖片生成紀錄

工具：內建 `image_gen.imagegen`；未使用付費 API 或第三方模型下載。候選未取得人類正式美術批准。

輸入：本 Repo 既有原創 `RiverCrossroads` 與 `StoryCast`，分別作風格及身分參考；未抓取參考作品素材。

背景候選：`LifeWorldHome.imageset/river-home-v1.png`。

```text
Use case: stylized-concept
Asset type: portrait 2D life simulation game background layer, 1024 x 1536, no UI.
Input image: reference only, existing original RiverCrossroads background. Preserve its painterly warm ochre, moss green and teal visual language, river village atmosphere; create a new camera composition, not a screenshot of UI.
Primary request: a close, lived-in open riverside community home porch, reusable for an animal character living from childhood through old age. Frame for a vertical iPhone stage. Lower 55 percent is a broad uncluttered warm timber floor where separately composited large characters can stand. At left midground an unoccupied low wooden work surface with clear top, at right midground a small wall shelf for memories. Open door toward a narrow riverside footpath and river in upper center, mature leafy tree overhead, soft hills far away. House is a fictional shared allegorical setting, no national flags or distinctive landmark. Comfortable human scale, close camera slightly above eye height, floor grounding and perspective consistent with full-body sprites.
Style: polished original hand-painted 2D adventure game art for ages 10–15, textured brushwork, clean readable silhouettes, restrained detail, no glossy 3D.
Lighting: neutral soft daytime, warm highlights, cool soft shadows; evening light added by code later.
Constraints: absolutely no people or animals, no already completed projects, trophies or earned objects, no loose foreground objects blocking sprite feet, no text, no letters, no logos, no watermark, no border, no card layouts. Scene background only, opaque.
```

姿勢第一版：已生成但未選用；修正以便清除周邊背景。

```text
Use case: identity-preserve
Asset type: reusable original 2D game character pose atlas, genuinely transparent RGBA background, exactly 3 columns and 2 rows, 1536 x 1024 landscape.
Input image: reference identity and costume only, existing StoryCast atlas. Use ONLY its brown otter protagonist. Do not include fox owl or rabbit.
Primary request: six separate full-body pose sprites of the SAME existing otter. Top row is child age 8 matching top-left reference (teal overalls, cream rolled-sleeve shirt, mustard neckerchief, small brown satchel, bare otter feet). Bottom row is adolescent age 15 matching second reference (teal vest, cream shirt, brown cuffed trousers, same mustard neckerchief and brown satchel, bare otter feet).
Columns left to right: (1) idle standing, relaxed arms and calm expression; (2) walking toward right in clear stride, one foot planted, other leg naturally bent and lifted, arms counter-swing, alert eyes looking right; (3) interacting, torso slightly leaning right, both hands extended toward a common focus at waist height as if sharing a small piece of paper, eyes looking directly at the hands, gentle attentive expression. The hands should be empty so gameplay supplies props, no floating props. Compact tail behind body.
Style: EXACTLY match original illustrated storybook-game brush texture, face proportions, cream muzzle, round ears, whiskers, warm eyes and costume. No new character design. Not chibi, not 3D.
Layout constraints: all 6 sprites centered inside equal 512 x 512 cells, no crossing cell edges, no text, no gridlines, no shadows or floor, no accessories changing between poses. Each sprite feet baseline at 90% of its cell, full height approximately 82% of cell. All cell backgrounds truly transparent alpha, not checkerboard paint, no gradients or opaque backdrop. Clean silhouettes without halos. No extra characters.
```

姿勢修正版：`LifeWorldPoses.imageset/otter-poses-v3.png`。RGB 預覽可能顯示棕色底，實際 PNG 含透明 alpha；以 alpha-inspection.json 和原生合成圖核對。

```text
Use case: background-extraction.
Edit target: the six-pose otter sprite atlas just generated. Remove ALL brown gradient glow, vignette, studio backdrop, lighting haze, shadow and semitransparent color surrounding EVERY otter. Every pixel outside each otter silhouette must have alpha=0; all fur, clothes, faces inside silhouettes must be opaque alpha=255. No colored rectangular cells or halos. Preserve exactly the same six characters, cell coordinates, dimensions, outfits, positions, hand gestures, poses and brush texture. Output real transparent RGBA. Do not change character designs, do not add floor shadows, don't paint a checkerboard.
```

最後只修正互動欄兩人的視線，低頭看向手部；v2 保留於生成工具目錄，專案使用 v3：

```text
Use case: precise-object-edit.
Edit target: six-cell transparent otter atlas.
Change ONLY the two otters in the RIGHTMOST COLUMN (interacting poses). Tilt their heads downward 20 degrees and aim BOTH pupils at their own outstretched hands, lower right. Brows and face show focused attention to the paper they would share. They must NOT look upward. Keep the left and middle columns pixel-identical if possible; preserve every body, costume, hand and foot location, layout, 3 columns x 2 rows and size. Keep genuinely transparent alpha outside silhouettes, no backdrop. No text.
```

原檔保留在工具產出目錄；專案使用的兩份素材已複製進 imageset，沒有覆蓋既有素材。沒有外部角色／商標素材匯入；不宣稱已完成所有商用法務核准。
