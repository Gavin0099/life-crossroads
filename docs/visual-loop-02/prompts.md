# VISUAL-LOOP-02 — 生成提示與迭代紀錄

2026-10-28。工具：本 session 內建 `image_gen.imagegen`；未使用 CLI、其他服務或程式重畫。原始生成 PNG 保留在工具回傳路徑；Assets 中為 byte-for-byte 複本，沒有像素修圖、裁圖、去背或重新編碼。SwiftUI 顯示時才按等格裁切。

身份只參考 repo 原創 `StoryCast`；新背景與圖層均為本輪生成。這是可整合至 Draft 的 AI 生成候選，未宣稱人工正式選稿、法律審查或兒少可讀性驗收完成。圖層不是任何國家實景，也不表述國家設備擁有率。

採用鏈：

- `VL2Studio`：`VL2Studio`
- `VL2Workshop`：`VL2Workshop`
- `VL2Garden`：`VL2Garden`
- `VL2Teen13`：`VL2Teen13` → `VL2Teen13_padding` → `VL2Teen13_screen` → `VL2Teen13_gaze_r2`
- `VL2Teen17`：`VL2Teen17` → `VL2Teen17_screen_padding`
- `VL2Adult25`：`VL2Adult25` → `VL2Adult25_padding` → `VL2Adult25_gutter` → `VL2Adult25_gaze_r2`
- `VL2Recovery32`：`VL2Recovery32` → `VL2Recovery32_padding`
- `VL2Companions`：`VL2Companions` → `VL2Companions_work_r2`
- `VL2Neutral`：`VL2Neutral`

修正理由：13 歲首稿中線留白不足，第二稿增大留白；13／17 歲電腦首稿把草圖放在筆電外殼，改成角色與玩家都看得到實際螢幕的側後視角；25 歲前兩稿長桌／尾巴跨等格中線，第三稿縮短長桌並向內收尾巴。未採用稿留在原始路徑，不進 App。

## VL2Studio

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-0a38a32b-93a2-4c74-b0f1-b5a5b3a2ff89.png`

```text
Use case: illustration-story. Asset: VL2Studio, an original background layer for an iPhone interactive storybook game. A quiet welcoming learning studio, hand-painted with matte gouache and colored pencil on warm textured paper. Broad simplified shapes, flat 2D shading, dry dark-brown outlines, warm cream walls, muted forest/blue-green accents, terracotta pots, honey wood. A large soft window at upper left, low shelves with plain unlettered sketchbooks and paper rolls at rear, distant supplies. The LOWER HALF and broad CENTER are EMPTY honey-colored floor for separate character-and-desk sprites; no foreground table, no chairs occupying center. Eye-level stage perspective, horizon about midway. Wide 3:2 composition, readable on a small phone, sparse large details. No characters, people, animals, faces, text, labels, signs, UI, logos, flags or national architecture. Not photoreal, not 3D, not glossy, no imitation of any artist or game. Entire edge-to-edge rectangular background; no vignette border. This fictional workshop is shared across countries and makes no claim about anyone's real possessions.
```

## VL2Workshop

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-e45960b7-57f7-4963-b2a2-c94409f96329.png`

```text
Use case: illustration-story. Asset: VL2Workshop reusable adult maker-studio BACKGROUND layer. Use the attached studio only as palette/2D matte gouache-and-colored-pencil style reference; create a DISTINCT more mature working environment. Broad paper-textured shapes, no photoreal fur or glossy 3D. Adult community maker space: high timber beam ceiling, wide open double doors to daylight at upper right, a pegboard of SIMPLE unbranded hand tools far on the back wall, neatly rolled plain plans, material cubbies, muted dark teal cabinets. Eye-level stage perspective, wide 3:2 rectangle. Lower HALF and broad center EMPTY honey-ochre floor, to insert separate otter/desk/long-table activity sprites later; NO foreground workbench, table or chair. Strong clean silhouette architecture different from the learning studio, slightly cooler sage daylight. Warm cream/teal/terracotta palette. No people, animals, characters, faces, signs, writing, labels, UI, flags, national landmarks, coins, trophies or logos. Not any real country's typical home. Edge to edge, no decorative border.
```

## VL2Garden

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-5878a9e2-6b86-458a-9b2a-54cdf442439b.png`

```text
Use case: illustration-story. Asset: VL2Garden, reusable quiet courtyard BACKGROUND only for an original 2D interactive storybook. Preserve the matte gouache/colored-pencil paper texture, simple broad flat shapes and warm cream/teal/terracotta palette from the reference, but make an entirely distinct OUTDOOR intimate courtyard. A shade tree spreads a soft canopy across upper left; low garden wall and plain planters at back, a simple pergola along right, a few broad-leaved plants and herbs, calm afternoon dappled light. LOWER HALF is a wide EMPTY pale earthen paving terrace for separate sprites sitting or doing a small shared task; no foreground furniture. Eye-level stage perspective, wide 3:2 rectangle. Plenty of quiet negative space, no river, no village panorama. No characters, faces, people, animals, signs, lettering, icons, UI, national landmarks, flags, awards or logos. Avoid glossy 3D, photorealism, excessive tiny detail, borders. A fictional shared setting, never a claimed country-specific scene.
```

## VL2Teen13

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-ac63b81e-c789-440b-8271-c7be5d1ed8a1.png`

```text
Use case: game sprite atlas. Asset VL2Teen13. Produce ONE TRANSPARENT square PNG with exactly FOUR independent activity sprites, equal 2 columns x 2 rows grid, read left-right/top-bottom, each fully centered within its own square cell and separated by generous TRANSPARENT gutters. No grid lines, cell labels, text, background, floor panel or frames. Each cell has 12% clear transparent padding, no object crosses a cell boundary. Whole bodies, feet, tails and furniture fully visible. Reference1 fixes Mumu the brown otter's identity (the teenage otter in upper row second cell): round small ears, broad short cream muzzle, brown nose, expressive dark eyes, thick tail. Reference2 sets matte gouache/colored-pencil warm paper style; render character in softer flat 2D forms, less detailed fur and NO shiny 3D. Same 13-year-old childlike teen Mumu in ALL cells, teal vest, cream shirt with rolled sleeves, ochre scarf, brown shorts; no other character anywhere.

CELL0 top-left: Mumu seated on low wooden stool, torso leaning forward and looking to the RIGHT at a compact plain open laptop on a small wood desk; BOTH paws naturally contact keyboard/tablet, screen contains only a simple unlettered unfinished geometric draft. Focused raised brows, not celebratory. Clear side-three-quarter face.
CELL1 top-right: Mumu at a similar low desk facing LEFT, leaning over paper with head and gaze lowered; one paw holding a pencil making an unfinished drawing, other paw flattening paper; a folded cardboard piece and plain ruler beside it. Thoughtful slightly pursed mouth. Paper-making silhouette distinct from computer.
CELL2 bottom-left: Mumu standing angled RIGHT, one paw holding a plain sketchbook close to chest, other paw half-raised with open palm to ASK a question; tentative open mouth and uncertain eyebrows, eye-line to off-image person at right. NO teacher, helper, response, gift, success check or light bulb. This shows ONLY making a request.
CELL3 bottom-right: Mumu sitting relaxed on a simple wood bench, shoulders lowered, paws resting in lap, eyes half-closed calmly breathing, soft tired expression; blank closed sketchbook placed on bench by side. Tail curls down naturally. No work props in hands. Rest is legitimate and peaceful, not failure.

Consistent anatomy across all four, believable paw contact and distinct posture/expression/gaze. Crisp readable broad silhouettes for small-screen gameplay. No symbols, lettering, trophies, money, awards or visible UI. Transparent negative space, not black/white/checkerboard background.
```

## VL2Teen13_padding

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-5fb3df8e-0344-47fc-a2bc-d043f91f7919.png`

```text
Edit this atlas for SPRITE PADDING ONLY. Preserve the same four original otter drawings, contact poses, four activities, expressions, colors and order. Output one square transparent atlas divided into EXACT equal 2x2 cells. Shrink each entire sprite GROUP including furniture to fit within the central 76% width AND 76% height of its own cell. Center each group in its square. Each cell must have at least 12% clear TRANSPARENT padding on ALL four sides. Important: no fur, tails, feet, furniture or antialiased pixel may cross a midline or touch outer edge. The middle horizontal and vertical 12% bands must be fully transparent. Do not add visible gridlines, labels, checkerboard, floor shadows, background, text or decorative elements. No new characters. Transparent background.
```

## VL2Teen17

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-ed4370b0-04db-4d11-85f8-d87fed72f390.png`

```text
Use case: game sprite atlas. Asset VL2Teen17. ONE transparent wide PNG, exactly TWO independent sprites in equal 2-column x 1-row square cells. Each complete group centered within the central 78% of its own cell, minimum 10% transparent padding on ALL sides, a wide fully transparent vertical gutter. No grid, floor, background, labels, symbols, borders or text. Whole feet/tails/furniture visible. First reference fixes Mumu teenage otter identity/color scheme and craft art; second fixes original age progression. Render SAME 17-year-old Mumu in both cells: visibly taller/slimmer and longer limbs than the 13-year-old in reference1, narrower cheek, teal open vest over cream rolled-sleeve shirt, ochre scarf, brown full trousers, recognizable rounded otter ears/cream muzzle/brown nose/thick tail. Matte colored-pencil/gouache, simple broad 2D shapes, no glossy 3D.

LEFT CELL0 REMOTE COLLABORATION: Mumu in side three-quarter seated at a compact desk, wearing a simple over-ear headset, looking RIGHT at a modest open laptop whose screen faces partly toward camera. On screen a large plain UNFINISHED geometric sketch only, NO face/person or success indicator. One paw points to the shared draft, other rests on touchpad; brows attentive, mouth slightly open as if discussing. A single sheet next to laptop has same rough outline. Body leans into communication, not generic idle typing. This is participation in remote collaboration, not proof of success.
RIGHT CELL1 FACE-TO-FACE COLLECTIVE WORK: Mumu standing slightly bent over a WIDE low collaborative materials table, head lowered to look at two separated pieces of cardboard. One paw carefully holds a fold while other holds a brush with glue. The right third of the table has an empty prepared work space for a separately composited partner; Mumu occupies its LEFT side. Open friendly concentrating mouth, turned gaze partly toward that empty space, plausible hands actually touching unfinished materials. NO other characters, no laptop, no trophies, no money. This is making segmented shared materials, not a finished prize.

Do not depict a different otter in the two cells. Maintain clear differences from 13-year-old. Keep the composition equal-size cells with no intrusion across centerline. Transparency everywhere outside the sprite groups.
```

## VL2Adult25

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-417b7f16-5309-417a-bb6c-fd584f93a91a.png`

```text
Use case: original game sprite atlas. Asset VL2Adult25. One WIDE transparent PNG, exactly TWO sprites in equal square cells in a 2-column x 1-row grid. Center each entire group in the central 78% of its cell, generous clear transparent margins on every side and wide transparent central gutter. No background or floor, no labels or frame. Fully visible feet/tails/furniture. First reference gives existing Mumu age progression; use its upper-row third young ADULT, not the child. Second reference establishes consistent activity atlas rendering. SAME mature 25-year-old Mumu in both cells: taller long torso/limbs, smaller eyes relative to face, slightly narrower cheeks than teen, short broad cream muzzle, rounded otter ears, dark brown nose/thick tail. Teal practical work JACKET with sleeves rolled, cream shirt, small ochre scarf, full brown trousers. Matte gouache and pencil illustration with broad shapes, no glossy 3D, simple paper texture. No other character.

LEFT CELL0 PAID TRIAL WORK: adult Mumu stands in profile three-quarter toward RIGHT at a compact TALL individual workbench. He is bent at the waist studying and measuring an UNFINISHED small wooden hinged box prototype, one paw touching a plain set square against the box, other holding pencil to mark wood. Eyes narrowed in careful concentration, mouth neutral, brows slightly cautious. A plain work apron over his jacket, safe handtools lying unused, large plain clipboard with unlettered outline sketch behind the small object. Visually a single adult trial workstation, not school homework. No currency, contract text, award, approval stamp or finished product. Whether work earns income is not visualized.
RIGHT CELL1 LOCAL COMMUNITY MAKING: same adult Mumu with teal jacket, no apron, seated at LEFT end of a visibly LONG low communal trestle table extending to the right, leaning forward to pass an unfinished large cardboard shape toward empty right work position while looking toward where a separate companion could stand. One paw contacts the held shape, other smooths an unlettered broad shared layout. Open sociable expression, body turned halfway toward off-frame collaborator. Multiple clearly separate large pieces laid in an assembly sequence, two EMPTY stools at far right for later compositing. No tools in raised hands. This is shared making work, not payment or success. Must differ from left adult solo measuring pose in table height, posture and materials. No extra characters in either cell.
No text, UI, numbers, logos, coins, trophies, badges, flags or celebratory icons anywhere. Transparent everywhere outside groups; NO object or antialias edge crosses centerline.
```

## VL2Recovery32

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-5c7d4f06-b3d4-445e-8fab-bdcd72aa33f6.png`

```text
Use case: transparent sprite atlas. Asset VL2Recovery32. Generate one square transparent PNG of exactly TWO separate full sprites, arranged equal TWO COLUMNS and ONE ROW (each equal rectangular cell). All parts fully within the central 78% width and 78% height of their own half; large transparent gutter at center; no edge clipping. Both show SAME adult 32-year-old brown otter Mumu from reference, practical teal JACKET, cream shirt, ochre scarf, full brown trousers, adult longer body and limbs, smaller eyes, slightly mature cheeks, rounded otter ears, broad cream muzzle, thick tail. Preserve identity and matte pencil/gouache paper appearance, reduce fur detail. No other character. No text, symbols, UI, labels or background.

LEFT HALF, REST TIME PROTECTED: Mumu seated fully on left end of a simple garden bench, feet supported, shoulders relaxed and leaning back, head turned slightly toward sunlight with softly closed eyes. One paw rests on knee, other touches the bench. A LARGE EMPTY SPACE clearly remains on the right side of the bench. His plain closed project folder lies beneath bench, not in hands. This is calm self-directed rest, never laziness or failure. Face quietly relieved. No task tools or invitations.
RIGHT HALF, ACTUAL SHORT PARTICIPATION: same adult Mumu seated forward on a low stool at a SMALL low folding side-table, looking down with focused but easy smile. He uses ONE paw to hold a single modest unfinished cardboard shape while other dabs glue onto ONE joint with a small brush. Only ONE small piece of work, not a pile; a simple cup with brush and a plain cloth nearby. His posture is light, a bounded small contribution, not full-day exhausting work. Feet and tail visible. This differs clearly from the long-table adult work scenes. No trophy, completion, money, praise, other people or success signals.

Reference is visual identity only, not permission to replicate its exact poses or furniture. Transparent negative space, no ground plane, shadow rectangle, checkerboard or border.
```

## VL2Companions

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-b08bdb77-ea52-4641-abbe-9057b4707347.png`

```text
Use case: original layered storybook game sprite atlas. Asset VL2Companions. ONE SQUARE TRANSPARENT PNG, equal TWO COLUMNS x TWO ROWS, exactly FOUR separate entire full-body companion sprites, one centered at (25%,25%), (75%,25%), (25%,75%), (75%,75%). Fit each complete character inside CENTRAL 65% of its own cell so every side has a wide TRANSPARENT gutter. No object, ear, antialiasing, wing or foot may touch cell midlines. No furniture, background, floor panel, text, writing, gridline, label, numbers or icons.

Reference1 identity: ONLY existing tan/beige owl teacher with round wire glasses and olive vest (bottom-row third) and cream rabbit Xiao-Cheng with lavender tunic (bottom-row fourth). Reference2 establishes gouache/pencil style. Use matte flat paper-colored illustration, warm cream/teal/earth palette, rounded simple shapes and limited detail, NO glossy fur or 3D. No otter or fox in this atlas.

TOP LEFT CELL0 owlListening: kind mature owl teacher, round thin glasses, white/cream shirt and olive vest. Body angled LEFT, head tilted DOWN LEFT at a shorter student's eye-line, calm thoughtful eyes and closed beak, one wing held softly at belly, other relaxed. Listening only; no book offered, no giving, no cheering or approval.
TOP RIGHT CELL1 owlWorking: same owl identity/clothes, leaning forward toward LEFT, looking DOWN LEFT with focused slightly narrowed eyes, two wings extending forward at waist height as if attending to shared paper situated OUTSIDE sprite. One wing gently points down with tip, other rests forward. No paper, furniture or reward included. Active collaboration gesture without victory.
BOTTOM LEFT CELL2 rabbitListening: cream rabbit in lavender tunic/cream cuff, long upright ears tilted gently toward LEFT, body angled LEFT, thoughtful kind attentive eyes looking LEFT, paws lightly joined in front at waist. Closed mouth, no gift or basket, no cheering.
BOTTOM RIGHT CELL3 rabbitWorking: SAME rabbit, sleeves gently rolled, torso leaning forward and facing LEFT, eyes looking DOWN LEFT at shared work, one paw holding a single plain rectangular unfinished cardboard piece at waist, other paw supporting it, concentrated small open mouth, asymmetrical ears indicating attention. No extra tools, furniture, worktable or finished product.
Everything outside four bodies transparent. Clear pose changes, stable faces and age, suitable for separate runtime compositing only when actual recorded companion is present.
```

## VL2Teen13_screen

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-7f36a32c-916d-4b42-a4ff-e54c4457cc47.png`

```text
Edit only the TOP LEFT computer sprite of this existing 2x2 transparent sprite atlas. Keep all other three sprites (paper making, asking, resting) visually unchanged, including their positions and sizes. Keep equal square 2x2 cells and generous TRANSPARENT gutters. New top-left pose: same 13-year-old otter Mumu seated at the LEFT side of a compact wooden computer desk, viewed from rear-three-quarter so we see his back, one side of his cream cheek, and his gaze angled RIGHT toward the computer. Plain small DESKTOP monitor positioned on desk at the RIGHT, screen facing left-front toward both Mumu and camera, so its VISIBLE SCREEN legitimately shows a simple unfinished geometric drawing with a dark thin bezel; clearly not artwork on the monitor back. Separate small keyboard in front, both paws resting on it. Screen plane and keyboard perspective must physically agree; monitor on its stand, cable not needed. Focused eyes looking at screen, fully visible tail, stool and feet. No text, faces, UI icons or other characters on screen. No laptop lid.
IMPORTANT: the entire top-left group fits within the central 78% of its square cell. Do not enlarge or move it across midlines. Other three cells unchanged. Preserve original matte pencil/gouache character identity, teal vest, cream sleeves, ochre scarf, no glossy 3D. Output true transparent background, no checkerboard or floor.
```

## VL2Teen17_screen_padding

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-2dfca2a2-e7ab-4d7d-9e32-e6f71d9b8a5b.png`

```text
Correct this 2-column transparent game atlas, preserving its two activities and same teenage otter identity. EXACT two equal square cells. Shrink BOTH complete groups so each fits inside the central 68% WIDTH and 76% HEIGHT of its own half, centered at x=25% and x=75%; add wide fully transparent middle gutter and outer margins. NO pixel, tail or furniture crosses vertical centerline. All feet/furniture visible, no background.
LEFT cell: replace the physically incorrect laptop with a plain compact DESKTOP monitor and keyboard. Same older 17-year-old Mumu wears headset and teal vest/cream rolled sleeves/ochre scarf, seated at LEFT of small desk in BACK THREE-QUARTER PROFILE. We see his back, a side cream cheek and eye looking RIGHT at actual display. Monitor is on RIGHT side of desk and its visible SCREEN faces toward Mumu AND viewer, with thin dark bezel and one unfinished geometric line draft. One paw points at the displayed shared draft, other rests on keyboard; slightly open mouth in discussion, no face on screen, no trophy or success signal. Mature teen body more slender and limbs longer than a child. No illustration on back of a screen, no laptop.
RIGHT cell: preserve the forward leaning material assembly pose and wide plain table, paw gluing a fold of cardboard, other paw holding it, open workspace at right, NO extra character. Slightly narrow cheek and smaller eyes relative to face, keep him same 17-year-old as left. Clear brush-to-cardboard contact.
Matte gouache/pencil with warm paper grain. Maintain all clothes/identity, transparent margins, no text, numbers, icons or panels.
```

## VL2Adult25_padding

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-0be19180-f73c-4136-b292-23eb728c092a.png`

```text
Layout repair for sprite atlas. Output aspect ratio EXACTLY 2:1 (wide, e.g. 1536x768), transparent. Place the existing LEFT solo-work group at x25%, y50%, and existing RIGHT shared-work group at x75%, y50%. These are TWO EQUAL SQUARE CELLS. Shrink each complete group including ALL tail, furniture and feet to fit inside the central 70% width and 80% height of its own square. IMPORTANT the transparent vertical stripe from x46% through x54% MUST remain fully empty: currently the right otter tail crosses into the left cell; fix by shrinking/moving the WHOLE right group to the right, preserving tail. Same left and right art, same adult otter identity and teal jackets; do not crop body or furniture. Keep work differences: adult carefully measuring wooden prototype at tall solo workbench versus adult at low communal long table passing an unfinished piece toward empty partner position. Keep faces and hand contacts. Need adult maturity: longer torso/limbs, somewhat smaller eyes than a child, cream muzzle and ochre scarf remain. No reinterpreting objects, no text, labels, money, trophy, background, shadows, floor, extra animal, grid or frame. Entire canvas outside two centered groups transparent.
```

## VL2Adult25_gutter

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-c57f3b62-c56f-4c1a-83f6-0e25103ef1e6.png`

```text
Rebuild this transparent atlas with clean equal cell boundaries. TWO sprites in a 2:1 canvas, equal left and right square cells. The vertical central TWENTY PERCENT of entire canvas must be completely empty transparent space, absolutely no tail/furniture/foot crosses there. Keep both drawings visually much SMALLER than previous reference (whole group width at most 32% of total canvas). Center left sprite at x=23%, right sprite at x=77%. Keep original left paid trial measuring pose and adult identity. RECOMPOSE right community group to become narrower: same adult Mumu seated passing one unfinished interlocking cardboard piece across a communal table; table extends only a little to right with ONE empty stool, not two; keep broad shared layout and separate unfinished pieces. Otter's tail curls inward beneath his stool instead of pointing toward center gutter. Table width only 1.7 times body height, not a panorama. Distinct low community table versus left tall solo workbench; same teal adult jacket/cream shirt/ochre scarf. Do not invent extra characters, money, rewards or finished success. Entire groups including all edges fit in their own equal cells with abundant clear padding, all feet visible. No background, floor, drawn gridline, text or label. True transparent PNG, matte gouache/pencil original otter art.
```


## VL2Recovery32_padding

32 歲休息長椅原稿貼近等格右邊界；第二稿收窄長椅並保留一個空位，確保顯示時不裁到椅腳。

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-b9731a5d-ce27-4d7d-bf87-bf29a0a071a7.png`

```text
Minor layout repair only. Keep these two original 32-year-old otter activity drawings and same order/identity. Output transparent 2:1 sprite atlas with exactly two equal square cells. LEFT resting bench currently touches its cell's right edge. Shrink/recompose LEFT entire bench-and-otter group by 18%, move slightly toward the left quarter center, make bench a little narrower yet retaining one clear empty place at its right. All armrests, feet and tail must have at least 8% of a cell width of transparent margin from the central divider and outer edges. Keep Mumu sitting relaxed with closed eyes, empty right bench place and closed folder underneath, no new activity. RIGHT small-task group remains essentially unchanged: adult gluing one unfinished piece at small folding table, same gaze, exact hand contacts and proportions. Large fully transparent vertical central gutter, no pixel of either sprite may touch midline. No background, ground plane, text, frame, numbers, grids, new character, money or reward. True alpha transparency, same matte pencil and gouache appearance.
```

## VL2Neutral

整合後補充：選擇前延續新版身份與服裝，僅等待／觀察，沒有先演出尚未選擇的行動。原第一段26分43秒工時保留；本段另記。

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-83b76b44-713e-4ab8-a084-da086613918c.png`

```text
Use case: layered original storybook game character atlas. Asset VL2Neutral. Create ONE SQUARE true transparent PNG, exactly FOUR whole-body neutral Mumu otter sprites arranged equal 2 columns x 2 rows. One independently centered sprite per equal square cell, read left-right/top-bottom. All ears/feet/tails fully visible and inside central 72% WIDTH and 80% HEIGHT of own cell, large entirely transparent gutters, no parts crossing grid midlines. No grid, borders, labels, background, floor, props or text.

Four references establish SAME Mumu otter identity across ages13,17,25,32 in that order. Use the corrected matte gouache/pencil original art style and colors, preserve face and silhouette: brown river otter, rounded small ears, short broad cream muzzle, brown nose, thick curved tail, expressive dark eyes, cream shirt, muted teal clothes, ochre scarf. Avoid overly glossy 3D fur. These four poses are for BEFORE A DECISION and show ONLY waiting/observing, never an action already chosen.

TOP LEFT cell0 age13: small early adolescent proportion, slightly larger round head than older self, shorter torso and limbs, teal vest over cream shirt with rolled sleeves, ochre scarf, cropped brown trousers. Standing still, both paws naturally at sides, shoulders level, curious but neutral closed mouth, eyes looking gently to the RIGHT at mid-height. No reaching, talking, requesting or making.
TOP RIGHT cell1 age17: SAME face slightly slimmer and noticeably taller/slender late teen body with longer legs, teal open vest, cream rolled sleeves, ochre scarf, longer brown trousers. Neutral standing weight evenly planted, one paw relaxed near side seam and the other loose, attentive neutral face looking three-quarter RIGHT. No tool or task.
BOTTOM LEFT cell2 age25: SAME mature young-adult face, smaller eyes relative to head, longer torso, wider practical teal JACKET over cream shirt, ochre scarf, full brown trousers. Adult body taller than teen, standing quietly with arms lowered, thoughtful closed mouth and level gaze to RIGHT. No apron, equipment, job award or work props.
BOTTOM RIGHT cell3 age32: SAME adult identity and teal jacket/cream shirt/scarf palette, proportion consistent with25 with slightly more settled broad shoulders, full brown trousers. Standing naturally and observing, hands relaxed low, calm open eyes and a neutral almost-smile, three-quarter RIGHT gaze. Do not draw sitting, sleeping or reclining; this is NOT a rest decision.

Keep identical garment details and face identity with activity atlases so transitions do not replace character with a different animal. Natural quiet idle stance only. No laptop, paper, book, furniture, trophies, coins, symbols, text, extra animals or scenery. All negative space true alpha transparency.
```

## VL2Teen13_gaze_r2

獨立 Critic R1 定向修正；僅一次嘗試。PASS。前版原圖與 SHA 保留於 manifest previous_versions 及 generations；未宣稱其他格像素完全不變。

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-b958363d-1c05-4310-a166-471eb73cfda3.png`

```text
Very local sprite-atlas correction. Keep the exact 2x2 transparent atlas, its size, four cell positions, all clothing, bodies, hands, props and furniture. Preserve top-left computer, top-right paper, bottom-right resting sprites exactly. Change ONLY the eyes and head tilt of the bottom-left asking otter (cell2): he currently looks upward right into empty air. His conversation partner is immediately to the RIGHT and LOWER, at about his own chest height. Lower his chin slightly, rotate the face a little toward camera-right and downward, and direct both pupils RIGHT and DOWN toward that nearby lower partner. Eyes open attentively, questioning slightly open mouth stays. Do NOT close eyes, do not add partner, do not change raised open paw gesture or sketchbook, outfit, body posture or facial identity. Do not add successful help, gift, symbols or any new objects. Same brown otter with broad cream muzzle and ochre scarf. Keep every other part of all four sprites as unchanged as possible. True alpha background, same equal-grid positions and existing transparent gutters. No shape crosses midlines. Matte pencil/gouache consistency.
```

## VL2Adult25_gaze_r2

獨立 Critic R1 定向修正；僅一次嘗試。PASS。前版原圖與 SHA 保留於 manifest previous_versions 及 generations；未宣稱其他格像素完全不變。

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-003b9d3a-8235-4987-b0c5-df8dab21c5e4.png`

```text
Very local sprite-atlas correction. Preserve this 2-column transparent atlas, size, equal cells, transparent gutter, clothing, entire bodies, hands, workbenches, materials and layout. LEFT solo-work sprite remains unchanged. In RIGHT community-work sprite ONLY change otter's gaze/head angle: he currently looks above and to the right into empty air. His partner is sitting immediately to his RIGHT across the table, with eyes LOWER than his own face, roughly near the height of his chest. Lower his chin and turn his face slightly down-right; both pupils should look toward that nearby lower partner, not the ceiling or sky. Maintain small friendly open mouth, identity, adult teal jacket/cream shirt/ochre scarf, seated body and hand extending an unfinished cardboard piece. Do NOT draw the partner or new item. Preserve the exact hand contacts, table/stool, folded tail and all other props. No help-success symbol, completed prize, money or text. Keep full transparency and clear equal-cell boundaries, no objects across centerline. Avoid changing rendering style, maturity or anatomy.
```

## VL2Companions_work_r2

獨立 Critic R1 定向修正；僅一次嘗試。PASS。前版原圖與 SHA 保留於 manifest previous_versions 及 generations；未宣稱其他格像素完全不變。

原始檔：`/Users/macminim4/.codex/generated_images/01a18045-a64f-7311-9b4b-11ea5bc7bd98/exec-122f5bc5-ecc7-410b-ba08-9c82605f294b.png`

```text
Very local sprite edit to this four-companion 2x2 transparent atlas. Preserve positions, size, equal cells, character identity, style, clothes, faces, other three sprites and all transparent gutters. Change ONLY TOP RIGHT cell1 owlWorking: same mature beige owl with round thin glasses, cream shirt and olive vest. Keep his torso leaning forward toward LEFT and gaze DOWN LEFT. Both wings must now visibly GRIP/SUPPORT one simple broad flat UNFINISHED tan cardboard piece at waist height, with one bent unfinished crease, no drawing or writing, no glued finished box. Left wingtip rests on top edge and other wingtip supports underside, natural contact; paper tilts slightly toward LEFT to be set onto a shared table at runtime. This shows active preparing/shared work that has already occurred, not a result or prize. Keep entire sheet inside cell1 with generous transparent margins, no intrusion into centerlines. Do NOT add a table, other character, tools, completed craft, reward, badge or text. TOP LEFT listening owl retains empty relaxed wings and has no material. BOTH bottom rabbit sprites stay as they were. No background or floor. True alpha transparent PNG, matte gouache/colored-pencil style matching original atlas.
```
