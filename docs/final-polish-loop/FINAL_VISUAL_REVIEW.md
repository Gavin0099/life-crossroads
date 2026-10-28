# FINAL-POLISH-LOOP — independent correction review

Reviewer: `/root/final_polish_critic`. Only this review document and `BASELINE_REVIEW.md` are reviewer-owned. No App/asset/test edits, Simulator creation, commit, push, merge or release by this reviewer.

## Round 2 — SE correction evidence, standard size pending

Review began **2026-10-28 11:31:43 UTC**. This is an intermediate record, not a final whole-task approval. Frozen scope, governance inputs and prior observations remain in `BASELINE_REVIEW.md`; no unrelated capability qualification was reopened.

**Visual verdict: CONDITIONAL ACCEPT / PARTIAL.** Clear improvement in request continuity, visual focus and the two childhood compositions. One newly visible transition artifact needs a final bounded adjustment or explicit residual limitation. No observed P1. Engineering verdict belongs to the engineering reviewer; Product verdict awaits the final representative-size check and remains only about readiness for owner playtesting.

### Evidence actually inspected

- Fresh Round 1 baseline: both devices, source and PNG identity verified as recorded in baseline Round 1B.
- `artifacts/evidence/final-polish-loop/round2/iPhone-SE-3rd-generation/`: seven core scenes (13 request, 17 remote/shared, 32 request/participation, 72 Ahe/new-neighbor); 13/32 actual expressing/handoff/listening triplets; 10/13/25/45/72 coarse-age set; 13/32 large fullscreens, 17 remote large scene/shared large fullscreen, 72 neighbor large fullscreen; 13/32 and 72 Ahe Reduced Motion scene captures.
- All 60 Round 2 SE native PNG SHA-256 values independently match the screenshot manifest.
- Source manifest correctly calls out uncommitted renderer overlay and retains the base commit; it is not misrepresented as unchanged PR20 output.
- Round 2 iPhone 17 was still running when review began. **No Round 2 dual-size PASS is claimed in this section.**

### Observable Before/After results

| Criterion | Round 1 | Round 2 SE | Evidence / disposition |
| --- | --- | --- | --- |
| 13 held notebook and posture continuity | FAIL | PASS for object continuity; transition PARTIAL | `13-{expressing,handoff,listening}-normal-scene.png`: notebook, scarf, clothing and floor remain stable. Lowered speaking hand replaces the entire-body neutral swap. V1's disappearing notebook is resolved. |
| 32 seated objects and posture continuity | FAIL | PASS for object continuity; transition PARTIAL | `32-{expressing,handoff,listening}-normal-scene.png`: stool, side bag, held sheet and seated position persist. V1's unexplained standing/furniture disappearance is resolved. |
| Request remains unconfirmed help | PASS | PASS in sampled images | Teacher/rabbit attends to the request; no completed object, celebration or acceptance badge appears. Listening endpoint is calm, not victorious. This is visual evidence, not a substitute for projection/negative-path tests. |
| Center symbol competes with faces/hands | PARTIAL | PASS | V2 white circle/ear/question is removed in request scenes. The actual gesture/partner is now the center of attention, and request meaning remains readable. |
| 72 two-route childhood scale | PARTIAL | PASS for shared scale/floor rule | `72-{ahe,neighbor}-normal-scene.png`: both childhood figures now have comparable apparent height and grounding; solo route stays solo. The different pre-existing pose proportions remain visible but no longer read as a different age scale. V3 resolved on SE. |
| 72 true memory/cast and completeness | PASS | PASS | Ahe appears only in friendship history; Cheng only in the current new-connection panel. Ear tips, tails and feet remain in frame. Current Mumu scale is shared between both routes. |
| 17 remote versus shared activity | PASS | PASS | Computer/headphones/screen owl versus cardboard/glue/physical owl retain clear different actions. No unnecessary redraw. |
| 32 request versus participation | PASS | PASS | Discussion of a sheet differs from held cardboard, brush/glue and worktable. Participation is not depicted in the request endpoint. |
| Coarse 10/13/25/45/72 growth | PARTIAL (incomplete inspected set) | PASS for visible coarse-stage cues; perception untested | 10 overalls/short proportions; teen vest; young-adult jacket; middle-age greying temples/cardigan; later-life grey hair/glasses. These are identifiable visual stages, not proof a child can infer exact age. |
| Maximum Dynamic Type hierarchy | PARTIAL | PARTIAL, improved | The oversized decorative “這次選擇之後” block is gone, making story title available earlier. Large title/subtitle still require scrolling, and icon-only footer remains. No observed clipping of the world or proven inaccessible action; V4 carried forward for real-device readability. |
| Reduced Motion semantic still | PARTIAL | PASS for inspected static meaning | 13/32 keep the expressive request pose and true objects; 72 retains both true histories. No success is manufactured by disabling animation. Manual VoiceOver remains untested. |

### New correction-delta finding FP-V5

- **Severity:** P2 (user task scale).
- **Attribution:** introduced/exposed by Round 2's full-pose crossfade.
- **Location:** `LifeCrossroads/App/LifeWorldScene.swift`, requesting-pose `ZStack` with `.opacity(1 - blend)` and `.opacity(blend)`; `WorldRequestTransition` supplied-clock opacity.
- **Native evidence:** `round2/iPhone-SE-3rd-generation/13-handoff-normal-scene.png` shows a translucent raised hand over the lowered hand near the chest; `32-handoff-normal-scene.png` shows two hand/sleeve silhouettes, with slight facial/sheet-edge blending. The endpoints themselves are materially better and consistent.
- **Status:** open; **Disposition:** one final bounded correction, then keep residual natural-motion limitations instead of repeated regeneration.
- **Current-decision impact:** yes for declaring the requested natural pose handoff fully PASS; no evidence of a data/decision defect or reason to block a Draft preview.
- **Rule reference:** FP-02/FP-05 require natural pose continuity and honest PARTIALs; art-loop skill requires native middle-state inspection, not just attractive endpoint PNGs.
- **Narrow recommendation:** substantially shorten the full-pose overlap (approximately 100–150 ms is a design trial, not an empirically validated perception threshold). Keep the existing shared clock and stable object composition. An additional broad repaint or new animation system is not warranted. If ghosting remains, report bounded two-pose dissolves as PARTIAL; do not call them continuous limb animation. Do not merely choose screenshots outside the blend window and claim it was removed.
- **Recheck:** same saved source and actual expressing/mid-transition/listening captures; renderer clock evidence must bind the sampled middle time. Validate no notebook/stool disappearance returns. Reduced Motion stays static.

### Claim and stop boundary

The revised scenes are easier to interpret and the original observable discontinuities are mostly corrected. The target is owner/child playtest readiness, not a fully animated production cast. No target-age recognition, natural-motion comfort, enjoyment, replay willingness, physical iPhone or full manual VoiceOver evidence is supplied by this review. Final Round 3 must append its results, including unresolved V4/V5 if applicable; it must not erase the failed baseline or Round 2 middle frames.

Round 2 author consultation: prefer a short 120 ms dissolve with honestly retained naturalness PARTIAL over generating a third discrete pose. A third pose alone does not create continuous anatomy, and the current stable props/identity should not be put at risk without evidence. The grey present-day caption band may be returned to the established warm paper palette as a small consistency correction. These are recommendations, not acceptance of an unseen Round 3.

Active-time ledger: initial review charged conservatively 5 minutes; Round 2 started 11:31:43 UTC and substantive document review ended 11:35:00 UTC (3m17s), with brief author consultation afterward; charge this turn 4 minutes. Cumulative charged active review 9/25 minutes; idle waiting excluded.

## Round 3 — final bounded visual acceptance

Review started **2026-10-28 11:53:16 UTC**. The parent froze App source before this review. No further visual generation or implementation iteration is requested.

**Visual Verdict: CONDITIONAL ACCEPT.**

**Product Verdict: 適合試玩 — suitable for an owner-led preview/playtest, subject to the separately reported engineering result.** This explicitly does not mean children already understand the relationships, the game is enjoyable, all official art is approved, or the App is ready to release. Draft/HOLD remains.

**Governance review decision: APPROVED with the two disclosed non-blocking limitations V4/V5 for the bounded Draft/playtest handoff.** No observed P1 visual defect and no observed new story-truth defect in the inspected states. It is not approval to merge. Engineering Verdict is outside this critic's ownership and must be reported independently.

### Final inputs and identity binding

- Native evidence: `artifacts/evidence/final-polish-loop/round3/iPhone-SE-3rd-generation/` and `.../iPhone-17/`, each 62 PNGs. Both runtime summaries report 3 passed tests, 0 failures and no runtime warnings. These are parent-produced test results read by the reviewer, not tests rerun by the reviewer.
- Reviewer independently recalculated all 124 PNG SHA-256 values; all match the two `screenshots.json` manifests. All recorded App/Presentation source hashes match the final local files at review time. The base remains PR20 `325b698`; the source manifests bind the actual final overlay instead of calling it unchanged baseline code.
- Inspected native samples include both device sizes; seven core scene meanings; 13/32 true-clock expressing/transition/listening states; representative maximum Dynamic Type and Reduced Motion; five coarse stages at 10/13/25/45/72. Fullscreen and native scene crops were examined separately. Not every one of 124 PNGs was visually read; all hashes were checked.
- Relevant final source SHA-256:

| File | SHA-256 |
| --- | --- |
| App/LifeWorldScene.swift | `0e10b6feed556a8ecba419d344d11321915bf6b56b86234dfc2e966289237ff9` |
| App/CrossroadsView.swift | `a3c4e193bc7365a6090de030e45cc343f2218a7ab1b641a9f863b635cdb84f73` |
| App/ProjectWorkshopView.swift | `25508c479a591bf02c41d6b16d710bf72b16b14f32de44023e2b9eb1c5e7816b` |
| App/StoryVisuals.swift | `3d67257e4b7f23cc479159accc71e3f12b5965891570e921e5ce7b27a81e8b67` |
| Presentation/WorldRequestTransition.swift | `5fe25b370f9fe77ed9a2a5c20aa90a9a8561cc85e60e8008073a9313fc1b97fb` |

### Final criterion matrix

| Criterion | Final result | Evidence-bound judgment |
| --- | --- | --- |
| FP-V1: request objects/posture persist | **PASS** | Both 13-year endpoints retain the same notebook, body scale, clothes and floor. Both 32-year endpoints keep the stool, seated pose, sheet and side bag. No unexplained stand-up returns in the inspected Round 3 images. |
| FP-V2: request focal hierarchy | **PASS** | White SF ear/question circles are absent. Mumu's speaking/settling gesture and actual counterpart carry the scene; no completion symbol was introduced. |
| FP-V3: 72-year comparison scale | **PASS** | Both routes use the same child-height/floor rule; solo childhood remains solo. Current Mumu has consistent scale, with fox versus rabbit correctly distinguished. Native standard/SE-large images show complete ears, tails and feet. |
| 13-year meaning | **PASS** | The notebook is unfinished/request context. Teacher attending is not depicted as a finished work or guaranteed opportunity. The normal fullscreen explicitly keeps the recorded-outcome limits. |
| 17-year remote versus co-making | **PASS** | Remote headset/computer/screen portrait and face-to-face cardboard/glue table remain visibly different. Character anchors remain stable; no cosmetic-only “new activity” is counted. |
| 32-year requesting versus participating | **PASS** | Held planning sheet/seated discussion and real brush/cardboard/table activity are distinguishable, including the SE large scene. A request still does not become cooperation. |
| 72-year reunion versus new connection | **PASS** | Saved childhood fox friendship appears only in its proper history; no childhood rabbit or invented reunion in the alternate route. Current objects and people remain distinct. |
| Character identity / coarse growth | **PASS, bounded** | Four species remain distinguishable. Mumu's overalls, teen vest, young-adult jacket, greying middle-age cardigan, and later-life grey/glasses supply coarse-age cues in the five inspected stages. This is reviewer recognition, not child-recognition data or exact age inference. |
| Frame completeness / core-scene prop contact | **PASS, sampled** | No newly clipped head, ear, foot or tail in the core samples. Notebook/sheet/cardboard are held and working figures contact their tools. Existing generic 25/45 world-signage compositions were used for age checking, not qualified as fully natural cast interactions. |
| Warm paper UI consistency | **PASS** | Final 72-year caption band and outcome card use warm paper again. These blend with the native page and no longer introduce the Round 2 cool grey rectangle. |
| FP-V4: maximum-text reading comfort | **PARTIAL** | Removing the decorative badge reveals useful content sooner, but large headings and subtitles still require substantial scrolling. Standard-size large fullscreens show content continuing beneath/around the fixed bottom area. Controls remain visible in sampled stills; this critic did not independently operate scrolling or VoiceOver. Retain for owner/accessibility playtest; do not claim effortless reading. |
| FP-V5: natural motion / ghosting | **PARTIAL** | Duration is now bounded to 120 ms, but the genuine intermediate captures still reveal translucent double hands. This is improved two-pose continuity, not continuous anatomical animation or proven perceptual smoothness. |
| Reduced Motion meaning | **PASS, sampled static state** | Static request images preserve the expressive pose and objects; remote/co-making and memory scenes retain correct activity/relationship meaning. No extra success implied by motion being disabled. |
| Save failure visual boundary | **PASS, sampled screenshot only** | SE `10-savefailure-normal-scene.png` remains the invitation/before-choice cast. Full failure/retry/archive correctness belongs to engineering evidence. |
| Target-age comprehension / entertainment | **NOT TESTED** | No child was observed. No % complete, replay motivation or 10–15 minute comfort conclusion is derived from these pictures. |

### Actual transition evidence — residual defect not hidden

`WorldRequestTransition` changes opacity only over 700–820 ms of the supplied presentation clock. It does not create a Domain clock or a new simulation outcome. The parent added an actual in-window sample rather than reusing only the 900 ms post-transition screenshot.

| Device | 13 expressing / transition / handoff / listening (ms) | 32 expressing / transition / handoff / listening (ms) |
| --- | --- | --- |
| SE3 | 232 / **772** / 941 / 1447 | 206 / **738** / 951 / 1412 |
| iPhone 17 | 252 / **720** / 934 / 1430 | 204 / **737** / 903 / 1448 |

All four samples for each age/device retain their logged archive identity: 13-year `8d85eb25d6f21ac085fa4fafec47c110567a6513133614c2ab49c8336a65f1b4`; 32-year `942b8c7bf91ec42b4e135db52654af9c2dc2da07b6978921bf2c5499fe00f03a`. The reviewer read these actual-clock log lines; no nominal sample time is passed off as the observation.

V5 severity remains **P2**, status **open**, disposition **carried-forward**. The 772 ms SE 13-year image clearly retains the raised-hand ghost; the 738/737 ms 32-year images show overlapping sleeve/hand shapes. Shortening exposure is supported by the code/time evidence, but improvement in a moving viewer's perception was not independently established by the stills. Current-decision impact: **no for owner-led Draft playtesting**, because the saved meaning, stable objects and endpoints are intact and the limitation is explicit; **yes for any claim of fully natural animation**. The owner task's stopping rule permits preserving bounded unresolved quality limitations instead of a fourth loop.

V4 severity remains **P2**, status **open**, disposition **carried-forward**. Current-decision impact: **no for the bounded visual Draft handoff**; human readability and accessible operation must be observed during the upcoming owner/manual checks. No fresh screenshot establishes an unavailable main action, and this reviewer does not infer full accessibility from its presence.

### Stop decision

Stop this Loop. The baseline defects were documented before correction, two real correction rounds produced visible improvement, the real mid-transition weakness is preserved, and no further repaint is justified by the current evidence. Next evidence must come from owner iPhone use and 10–15-year-old participants: relationship recognition, distinctions between asking and receiving, environment/choice understanding, interest and willingness to replay. The visual verdict is conditional because V4/V5 remain; product observations and official-art approval are separate outstanding boundaries. Do not automatically open another Loop.

Final review timing: **11:53:16–11:57:22 UTC**, 4m06s of substantive review plus report handoff; charge 5 minutes conservatively. Total charged active review **14/25 minutes** across all three turns. No idle waiting is included and no extra review loop is requested.

## Accessibility-label correction — bounded final addendum

2026-10-28 14:12:30 UTC: inspected the one-line correction removing only the explicit `chosenAction` accessibility-label prefix. The underlying visible `Text(trace.choiceTitle)`, styling, identifier and choice value remain; no pixels, layout, assets or clock behavior are intentionally changed. This repairs consistency with the original history label rather than changing the story.

New iPhone 17 source: `artifacts/evidence/final-polish-loop/round3-ax/iPhone-17/`. Its runtime summary reports 3/3 passing, 0 warnings. Reviewer recalculated all 52 PNG hashes: all match. Examined the new 13-year normal fullscreen and 32-year transition scene; visible composition is retained and the disclosed V5 translucent hand remains. V4/V5 judgments and Visual **CONDITIONAL ACCEPT** are unchanged; no new art iteration is requested.

`CrossroadsView.swift` is now bound to SHA-256 `2c6691e3944495527f6250b7f25e8fbab54d2bb03cc5b2e670ed2dd5bc240fd5` (superseding the Round 3 source row for this file). SE recapture was still running during this check; no completed new SE review is claimed yet. The parent separately owns the original full-life/parallel UI regression evidence and latest CI result.

**SE follow-up completed 2026-10-28 14:16 UTC:** inspected `round3-ax/iPhone-SE-3rd-generation/13-ask-normal-screen.png` and `72-neighbor-reduced-scene.png`. Request notebook, true present-day rabbit, solo childhood history, warm band, framing and visible controls retain the reviewed meaning. Independently recalculated all 52 PNG hashes with no mismatch; recorded App/Presentation hashes match current source, including the corrected `CrossroadsView` SHA above. Runtime summary reports 3 passed, 0 failed and 0 warnings. This closes the pending SE source binding; it does not erase V4/V5, constitute manual VoiceOver testing, or imply new HEAD CI has passed.

Final source correction is parent commit `6ec388d`; visual source remains bound by the recorded hashes. **Visual CONDITIONAL ACCEPT / Product 適合 Owner 帶領試玩** remains unchanged. Latest remote CI is outside this critic's completed evidence and must be reported pending unless separately verified. No new loop or artwork requested. Addendum active review: first pass 46 seconds, this SE pass under one minute; conservatively charge 2 minutes total. Cumulative charged critic time **16/25 minutes**, idle excluded.
