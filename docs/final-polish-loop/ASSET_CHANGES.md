# FINAL-POLISH-LOOP — targeted asset changes

Base: `325b69896553fb6c479e415c0c0991e76ef78a26` (PR #20). Asset agent: `/root/final_polish_pose_edits`.

Only two observed prop/posture discontinuities were edited. These are Draft candidates, not formally approved art. No App, renderer, Domain, Data, Persistence, tests, or event content was changed by this asset task.

## Observed baseline and local corrections

| Scene | Observed in original native early → late | Local edit | Candidate self-review |
|---|---|---|---|
| 13, asking the teacher | `VL2Teen13` cell 2 held a notebook; switching to neutral made it disappear | Same standing teenager, notebook, scarf, vest, trousers and feet. Raised palm lowers to notebook; mouth closes and gaze stays toward companion | ACCEPT for candidate geometry/props; native transition pending |
| 32, discussing arrangements | `MCMumu` cell 2 sat on a stool with papers/side bag; switching to neutral removed all three and stood up | Same seated adult, stool, folded paper and shoulder bag. Pointing hand rests beside the paper; relaxed closed mouth | ACCEPT for candidate geometry/props; native transition pending |

Baseline images inspected directly:

- `artifacts/evidence/interaction-memory-loop/final2/iPhone-SE-3rd-generation/13-expressing-normal-scene.png`
- `artifacts/evidence/interaction-memory-loop/final2/iPhone-SE-3rd-generation/13-listening-normal-scene.png`
- `artifacts/evidence/interaction-memory-loop/final2/iPhone-SE-3rd-generation/32-expressing-normal-scene.png`
- `artifacts/evidence/interaction-memory-loop/final2/iPhone-SE-3rd-generation/32-listening-normal-scene.png`

## Outputs and exact adoption boundary

Both output files are unmodified original tool PNGs, 1254 × 1254, 8-bit RGBA, 2 × 2 atlas. **Adopt only index 2**, the bottom-left cell, with source rectangle `x:0, y:627, width:627, height:627`. The other three cells are retained solely as part of the raw generated atlas and must not replace existing activities. No external art was used.

| Candidate | Original edit target | SHA-256 |
|---|---|---|
| `assets/final-polish-loop/originals/teen13-listening-v1.png` | `LifeCrossroads/App/Assets.xcassets/VL2Teen13.imageset/VL2Teen13.png` | `a2e685d31d7b14413a766a5e1bd7c335b9e78ffff2a0c2df0a449f82753044ab` |
| `assets/final-polish-loop/originals/adult32-listening-v1.png` | `LifeCrossroads/App/Assets.xcassets/MCMumu.imageset/MCMumu.png` | `f5359a055aa919bedea972cbc352861d1f3b6cdb9e9a213d5a6cb922907585eb` |

Prompts are under `assets/final-polish-loop/prompts/`. Complete provenance, alpha inspection and approval state are in `asset-manifest.json` and `assets/final-polish-loop/alpha-audit.json`. Tool: built-in `image_gen.imagegen`; model version was not returned. Two local edits, zero retries; no whole-scene regeneration or new character.

## Integration geometry

Coordinates below have top-left origin in the full 1254 × 1254 atlas. The PR20 baseline renderer trimmed each cell's alpha independently. Closing a gesture reduces width; applying independent fit/centering can therefore shift the character even though feet/head remain nearly unchanged in the atlas. Use a common fixed rectangle/transform for each early/late pair.

| Pair | Original visible bbox (alpha > 12) | Edited visible bbox | Common render rectangle |
|---|---|---|---|
| 13 | `(114,689,434,496)` | `(114,686,384,501)` | `(114,686,434,501)` |
| 32 | `(83,660,504,555)` | `(83,656,505,561)` | `(83,656,505,561)` |

The 13-year lowered arm intentionally reduces silhouette width by 50 px; this is not a resized body. Fixed transforms are needed before judging crossfade smoothness. The source and endpoint have minor 2–6 px outline/groundline changes; no claim of pixel-identical unedited areas is made. If cropped relative to the selected cell, subtract 627 from these `y` values.

## Read-only validation and limits

- `python3 assets/final-polish-loop/inspect-assets.py`: source/output dimensions, PNG type, SHA, alpha range, split-line transparency and bbox measurements.
- Both output alpha ranges are 0–255, with approximately 64.8% / 67.8% fully transparent pixels. No visible pixels at either 627 px atlas split (threshold 12).
- Self-check: complete ears, tail, feet and props; notebook hands/paper contact retained; no new helper, promise, award or finished-work state.
- Minor texture/outline drift remains possible with edited raster assets. Candidate assessment does not prove formal character lock or native animation quality.
- No Simulator launched by asset agent; no device cleanup required for this subtask. Parent owns native integration, capture and independent Critic verification.
- No formal Owner art approval, legal-release clearance, VoiceOver/human testing or overall product-completion claim.

## Root integration after the asset handoff

The parent integrated byte-identical copies as `FPListening13` and `FPListening32` in Assets.xcassets. Only the reviewed bottom-left request cell is sampled, through the common rectangles above. The source PNGs, other activity cells, existing cast and cat/dog candidate status are unchanged.

Round2 proved prop/posture continuity but exposed a 400 ms dissolve with double-hand silhouettes. Round3 shortens the same shared-clock handover to 120 ms (700–820 ms); it does not add another pose, timer, life decision or successful-help state. Actual transition images remain in the evidence. Pausing within the handover may still show both hand silhouettes, so continuous natural acting remains PARTIAL.

Both native sizes retain notebook/stool/paper/bag, and the scene/control/receipt checks pass. Final independent judgments are in `FINAL_VISUAL_REVIEW.md`; this integration does not change `approved_for_app=false` or grant formal art/release approval.
