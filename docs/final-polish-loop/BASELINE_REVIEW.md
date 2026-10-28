# FINAL-POLISH-LOOP — independent baseline visual review

Reviewer: `/root/final_polish_critic`. Review-only; no App, art, tests, Domain, Simulator, commit or push changes.

## Round 1A — provisional review of retained native evidence

Started 2026-10-28 11:06:22 UTC (first clock timestamp available to this reviewer). This pre-review precedes the new Round 1 capture. It does **not** approve an unseen revision or substitute historical captures for newly requested matched Before/After evidence.

**Decision: CHANGES_REQUESTED for the bounded visual polish; Visual PARTIAL.** No observed P1 correctness defect in the inspected images. The concrete P2 improvements below fit the requested slice. This is not an engineering, merge or release verdict.

### Frozen boundary and inputs

- Owner decision: improve the existing representative scenes for an independent Draft review and then stop for playtesting.
- Base: PR #20 `325b69896553fb6c479e415c0c0991e76ef78a26`.
- DONE: observable improvement of request continuity, visual hierarchy and route composition without invented saved outcomes; dual-size native verification and independent final review.
- Claim ceiling: visual interpretation of native scenes and necessary renderer/projection code. No human-child perception, gameplay enjoyment, physical iPhone, VoiceOver execution or continuous animation qualification.
- Read: AGENTS entry, PLAN product direction/current scope, project guardrails, active-task record, REVIEW_CRITERIA, life-crossroads-art-loop skill, relevant review-log/knowledge-base entries, `WorldRelationshipMemory`, `WorldCastScene`, relevant `LifeWorldScene` renderer.
- Prior records checked: the multi-cast and interaction-memory review entries retain product/age/natural-motion limits. The prior clipped 72-year feet/caption issue was fixed in final3; it is not reopened using obsolete final2 images.
- Dirty capture harness/PLAN files belong to the parent task; this reviewer did not change or review them as finished implementation.

### Evidence identity

Root for the paths below: `artifacts/evidence/`.

1. `interaction-memory-loop/final3/iPhone-17/`: 13 ask, 32 ask/participating, 72 Ahe/neighbor scene images; SE3 13/32 maximum-text fullscreens and 72 Ahe normal fullscreen.
2. `interaction-memory-loop/final2/iPhone-17/`: actual 13/32 expressing/listening scene pairs. These are retained historical samples, **not freshly captured at PR20**.
3. `multi-cast-loop/round3/iPhone-17/17-remote-normal-scene.png` and `17-collective-normal-scene.png`: retained historical activity evidence; fresh PR20 17-year captures are still required.

The final3 source manifest hashes exactly match PR20 bytes for the three examined files:

| File | SHA-256 |
| --- | --- |
| App/LifeWorldScene.swift | `e003435e7c2d340d60cd5a2d21089853ada22e9484c330b44b1de25eac94c23e` |
| Presentation/WorldRelationshipMemory.swift | `199e8c39757a621d26662013731982ce35aa850c8a5d8f504d2a0f6f051446a4` |
| Presentation/WorldCastScene.swift | `63c0231f3cd6c54c6649b2960e70748e761c7183a8b17ecd941108348f261232` |

The final2 and multi-cast full renderer hashes differ from PR20. Their screenshots help locate pre-existing issues; they do not supply whole-renderer identity. Current request selection code independently retains the discrete 1,100 ms pose substitution. Parent will bind new captures to the frozen base.

### Blind scene reading before source interpretation

- 13: a young otter holding a notebook addresses an owl; the second frame shows an empty-handed standing otter. No completed creation is shown. A white question/ear medallion is the most graphic high-contrast element between them.
- 32: a seated otter points to a sheet while a rabbit gestures; the second frame has the otter standing, with sheet, stool and side bag gone. The rabbit stays in the same pose. This is a larger spatial discontinuity than a facial expression change.
- 17: computer/headphones and an owl on the display are clearly distinguishable from glue/cardboard on a shared physical table. The otter's teal clothing/yellow scarf and owl's green vest/glasses maintain identity anchors.
- 72: old otter/fox and old otter/rabbit are visibly different present-day pairs. The childhood panel contains a fox only in the friendship route. Feet and ears remain within final3 frames. The solitary childhood otter is substantially larger than the paired childhood otter.
- 32 participation: tools touch the held cardboard, and a table separates this activity from simply discussing a sheet. The rabbit's right-side pose conveys joining the work; it must remain limited to an actual saved participation choice.

### Findings and narrow acceptance checks

| ID / severity | Observable evidence and location | Status | Current-decision impact / disposition | Bounded fix and acceptance |
| --- | --- | --- | --- | --- |
| FP-V1 / P2 | `final2/.../13-{expressing,listening}-normal-scene.png` and `32-{expressing,listening}-normal-scene.png`; PR20 `LifeWorldScene.swift:108` replaces the request pose with `neutralPose`; `WorldRelationshipMemory.swift:50` switches at 1,100 ms; renderer disables implicit animation. Notebook disappears at 13; stool/sheet/bag and seated posture disappear at 32. | FAIL, pre-existing, open | Yes for claiming natural request continuity; fix now. Does not prohibit creating a Draft. | Keep a consistent seated/standing body and relevant objects across the request/listening beat. Supply actual pre/during/post native samples from the shared clock. A fade alone must not be called a natural stand-up or explain disappearing furniture. No new success/acceptance gesture. |
| FP-V2 / P2 | `final3/.../13-ask-normal-scene.png`, `32-ask-normal-scene.png`; `LifeWorldScene.swift:87–96`. Large white circular SF question/ear occupies the visual center, while hands and gaze are secondary. | PARTIAL, pre-existing, open | Yes for this slice's explicit visual-hierarchy refinement; fix now. | Reduce or remove the medallion; use restrained consistent dialogue treatment and existing poses. Native SE3 scene must still make a request/listening readable without implying an answer. This is a focal competition observation, not a demand to change the whole art style. |
| FP-V3 / P2 | `final3/iPhone-17/72-{ahe,neighbor}-normal-scene.png`; `LifeWorldScene.swift:154–159` applies different width caps (0.54 vs 0.78) to childhood Mumu. Same 10-year stage looks much larger in the solo panel. | PARTIAL, pre-existing, open | Yes for claiming the requested consistent two-route composition; fix now. | Use a shared apparent child-height/floor rule while retaining the true cast. Preserve enough width for both figures; do not add a childhood rabbit or fox to fill the solo space. Verify both sizes with 72-year main-pair scale unchanged. |
| FP-V4 / P2 | SE3 `13-ask-large-screen.png` and `32-ask-large-screen.png`: oversized “這次選擇之後” label and event title consume most remaining viewport; the bottom row is icon-only. | PARTIAL, pre-existing, open | No demonstrated inaccessible action; carried-forward unless narrow typography hierarchy improves within scope. | Keep dynamic text readable and scrollable; lower decorative/status priority, not user content size. New fullscreens plus actual primary-action visibility/reachability evidence are needed; static screenshots alone do not prove scrolling or VoiceOver operation. |

### Checks already supported / limitations

| Check | Result | Reason |
| --- | --- | --- |
| Fox, owl, rabbit silhouette distinction | PASS in examined scenes | Ears, tail, wings and proportions clearly distinguish the species. |
| 17 remote versus shared activity | PASS for retained images; fresh PR20 capture pending | Screen/headphones versus shared cardboard table are materially distinct. No large redraw warranted by present evidence. |
| 72 truthful relationship casting | PASS for inspected projection and final3 images | `WorldRelationshipMemory.project` requires saved 10-year trace/fact and current 72-year branch/participant; solo childhood route does not depict childhood Cheng. Engineering negative-path execution belongs to engineering reviewer. |
| 72 frame completeness/grounding | PASS for examined final3 normal scenes | Heads, ears, feet and tails remain visible; no recurrence of historical clipped-feet issue observed. |
| Request does not visually claim completed success | PASS for sampled stills | No finished work, accepted-help badge or celebration. Continued semantic guard needed after polish. |
| Five coarse life stages | PARTIAL | Childhood/teen/adult/elder examples inspected; full 25/45 source-matched set not yet independently reviewed. Exact-age guessing is outside DONE. |
| Natural continuous movement | FAIL / unqualified | Two discrete samples and current pose substitution do not establish a natural movement sequence. Need true clock transition evidence; no skeletal-animation claim. |
| Reduced Motion / VoiceOver | PARTIAL / not newly qualified | Current code keeps a static request pose; this pre-review has not inspected new reduced/native accessibility execution. |
| Enjoyment and child understanding | NOT TESTED | Independent visual critique is not a target-age playtest. |

### Governance audit

Architecture: visual/projection read-only inspection only. Native safety and async mutation implementation review: N/A to this critic; assigned separately. Test integrity: historical evidence explicitly distinguished from fresh baseline. Baseline identity: three relevant final3 source hashes verified against PR20. No tests or Simulators executed. Knowledge-base alignment: no new fabricated-cause pattern observed; no interpretation of an invitation as saved success accepted. Final acceptance remains pending new Round 1 and correction rounds.

Round 1B will append the newly captured matched baseline rather than replace this initial record.

## Round 1B — newly captured baseline confirmed

Reviewed beginning 2026-10-28 11:31:43 UTC as part of the Round 2 review turn.

New source: `artifacts/evidence/final-polish-loop/round1/{iPhone-SE-3rd-generation,iPhone-17}`. Each device has 60 native PNGs. Reviewer independently recalculated every listed PNG hash: 60/60 per device match `screenshots.json`. All 34 App/Presentation source hashes per device match the frozen PR20 `325b698` Git bytes. This narrow independent identity check does not claim every test-harness file equals the base; the parent separately records fixture/harness verification.

Fresh images inspected include SE 13 listening, 17 remote/shared, 32 participation and iPhone 17 13/32 asking plus both 72 histories. They reproduce V1–V3: the 13 notebook and 32 seated arrangement are absent in the listening outcome, the white ear symbol is prominent, and the solitary childhood figure is substantially larger. The source-matched 17 remote/shared and 32 participation scenes confirm material activity differences; no new defect requires regenerating those assets.

Round 1 verdict remains **PARTIAL / CHANGES_REQUESTED for V1–V3**, with no observed P1. The baseline is now newly captured and traceable; Round 1A's older evidence is retained as history rather than silently relabeled.
