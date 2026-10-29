# RC-FULLSCREEN-01 independent review

Reviewer: `/root/reigns_poc_review` · 2026-10-29

**Engineering Verdict: ACCEPT for RC-FULLSCREEN-01. Visual Verdict: ACCEPT for this bounded 13-year screen. Product Verdict: suitable for Owner PoC review; Draft / HOLD remains.** No confirmed unresolved P1/P2 was found in the final reviewed source and native evidence. These conclusions do not grant Owner visual approval, merge permission, RC-05 GO, RC-03–06 implementation, or a product completion percentage.

This is a new review against the [Owner's PR #24 fullscreen request](https://github.com/Gavin0099/life-crossroads/pull/24#issuecomment-6486812739). The earlier `REVIEW.md` covered a different layout contract and cannot stand in for this review. The revised requirement explicitly removes four large persistent actions from the normal screen while preserving all four choices through secondary controls and the accessible alternative.

## Review boundary and provenance

- Baseline: `225c2828f4ea56c8ae5eb89a414ac506808b6374`.
- Implementation/evidence commit: `d726fb18ad6a537da76e42b498d666a343c59b02`.
- Reviewed code: `LifeCrossroads/App/CrossroadsView.swift`, `DecisionSwipeCard.swift`, `LifeWorldScene.swift`, native tests, and the unchanged model/save/branch entry contracts they call.
- Reviewed native evidence: complete SE3 and iPhone 17 final screens, choosing, four saved outcomes, held left/right previews, save failure, and dark/high-contrast/maximum-text/Reduced Motion fallback. Earlier failed native iterations were also reviewed.
- Source snapshots: `artifacts/evidence/reigns-fullscreen/final/{iPhone-SE-3rd-generation,iPhone-17}/source.json`. The two manifests are identical. The reviewer recomputed every listed file SHA against the working tree: no mismatch.
- Same starting life: `13-before.json`, Japan / `jpn-1`, Seed 34. Fixture SHA: `c1074e81fb937ec13928efbf9b8012bab9fbcbe0938b1f2cc99f53df90411ebd`.
- The reviewer inspected code, logs and native pixels independently; did not edit production/tests, operate Simulator, or post a GitHub review. This document is the reviewer's only change in this round.

Key final source hashes:

| File | SHA-256 |
| --- | --- |
| `CrossroadsView.swift` | `a59d44056c2202bba5138fd65683b3abbff3c4edbcd91a423a2f2f62ddeae8c6` |
| `DecisionSwipeCard.swift` | `9fef55483056f77d52430c55c44f8dd4fab9cf1e7c75906ee657dedb8392ed0b` |
| `LifeWorldScene.swift` | `c9a0117280adca5c4278499b77f091743be7be051696b98772153029196b7334` |
| `UITests/ReignsCardTests.swift` | `1da5ecd7c6458a9ecd1011f8c6cdc28fc48eab6aa04951681b5275b13ef516a5` |

## Findings, corrections and closure

| Finding observed during review | Evidence and correction | Final status |
| --- | --- | --- |
| **P1: paper-route desk hid the teacher's entire face.** The image could not communicate the intended interaction. | Blind image C and `round1/iPhone-SE-3rd-generation/light/rc-scene-card-offline-saved.png` show the failure. Portrait composition now changes the two actor sizes/positions and shares a floor. Final paper screens on both sizes show the owl's face, gaze and hand, with the otter drawing at the table. | **CLOSED / PASS** after native reinspection; not merely a source assertion. |
| **P2: normal branch entry could bypass the explicit-continue hold.** Pausing only in `submitSwipeChoice` did not cover `GameStore.startBranch`, which can enter the 13-year reflecting state directly. | The existing view task now holds any immersive published outcome before ticking, including branch entry. Two added native cases remove capture/reset launch flags and fixture environment, cold-resume real saves, then test normal choice and actual branch creation respectively. Each requires the card to remain for 3.5 seconds, longer than the existing 2-second outcome duration, with unchanged save SHA; explicit continue then exits. Both pass on both final sizes. | **CLOSED / PASS**. Capture-mode screenshots alone would not have proved this. |
| **P2: maximum text truncated the prompt/status and compressed the actors into a narrow strip.** Buttons being reachable did not make the whole screen readable. | `round1/iPhone-SE-3rd-generation/accessible/rc-first-screen.png` records the failure, despite that batch's accessibility test passing. The final fallback uses natural text height, a separate 220pt scene, no redundant swipe hint row, fixed-size HUD icons, and a vertical outcome footer. Final SE3 and 17 show the complete question and outcome text with intact actors. | **CLOSED / PASS** for the inspected fallback; scrolling is intentionally required. |

The preliminary `layout2` test failure is also retained: a duplicated background/sheet choice identifier led the test to target the hidden background button. Scoping the query to `swipeActionsSheet` corrected the test. This was not resolved by weakening save/outcome assertions. The round 1/2 visual failures above remain part of the record and are not retroactively labeled passing.

## Actual fullscreen assessment

| Owner requirement | Result | Independent observation |
| --- | --- | --- |
| One fixed fullscreen stage at normal text size | **PASS** | Both complete native pages have a small HUD, one dominant card and one compact auxiliary row. There is no surrounding normal-size vertical scroll or old navigation title. |
| Card at least 65% of available height | **PASS** | SE card is 523pt of a 667pt entire window: **78.4%**. iPhone 17 is 654pt of 874pt: **74.8%**. Even this conservative entire-window denominator exceeds 65%. Test-reported 84.6% / 87.3% use HUD-top to footer-bottom instead; these are different denominators, not conflicting measurements. |
| Short prompt, minimal HUD, no four large persistent actions | **PASS** | Normal prompt is one line; saved captions are at most two. The visible actions are compact ask/rest/all-actions, with full original choices inside the sheet. |
| Intact portrait composition | **PASS** | The background is composed separately from fitted character/tool atlas cells. Final static heads, feet and tails are intact and proportions are not stretched. Both actors are visible in the corrected paper route. |
| True left/right preview | **PASS** | Actual held native images show card translation/rotation and the intended action label, while actors remain in the neutral pre-choice scene. An 80pt hold says release to cancel; the model's 96pt commit threshold is unchanged. Card edges move beyond the physical screen during the drag; this is transient card motion, not static bitmap stretching. |
| All four original choices and feasibility | **PASS** | `offline`, `invest`, `ask`, `rest` remain distinct. Main actions have swipe and full-button alternatives; ask/rest are visible. Details retain formal costs and unavailable reasons. Digital context remains limited to the digital choice. |
| Saved result stays in the same large card | **PASS** | The four real saved outcomes show paper practice, computer use, expressing a need, and rest. No long result page replaces the card. Explicit continue remains available; ordinary play and branch entry are both covered. |
| Maximum text / Reduce Motion fallback | **PASS, bounded** | Dark/high-contrast/max-text/Reduced Motion native cases pass and the inspected text is complete. Fallback uses a ScrollView and full buttons; it is not claimed to meet the normal-size no-scroll layout. Manual VoiceOver is still unverified. |

Full-page evidence is necessary for these layout findings. A scene-only crop cannot establish card height, action accessibility, or the absence of persistent controls.

Representative final evidence under `artifacts/evidence/reigns-fullscreen/final/`:

- Both devices: `light/rc-first-screen.png`, `rc-card-{offline,invest,ask,rest}-saved.png`, `rc-preview-hold-{left,right}.png`, `rc-save-failed.png`.
- Both devices: `accessible/rc-first-screen.png` and `rc-rest-saved.png`.
- Both devices: `light/rc-normal-outcome-held.png` and `rc-normal-branch-outcome-held.png`.
- Original/new comparison: same-life `rc-original-*-saved.png` versus `rc-card-*-saved.png`; exact paired save hashes are in `evidence-verification.json`.

## Blind activity read

The reviewer first saw native scene-only files `blind/A.png` through `E.png`, before reading `blind-mapping.json`. The initial interpretations were sent to the implementer before the mapping was disclosed.

| Blind image | Interpretation recorded before mapping | Revealed source | Result |
| --- | --- | --- | --- |
| A | Otter using a computer with geometric instructions; studying/working, not proof of a finished project. | `invest` | **PASS** |
| B | Otter resting with eyes closed on a bench, notebook set aside. | `rest` | **PASS** |
| C | Otter drawing/practicing on paper; owl's face hidden by the desk. | `offline` | **FAIL in round 1; fixed in final** |
| D | Two characters standing/talking/waiting; cannot infer that help was promised or received. | Pre-choice | **PASS** for a neutral state |
| E | Otter presenting/holding a notebook toward the owl; expressing a need, with no visible completion or confirmed help. | `ask` | **PASS** for request-only semantics |

Final paper reinspection was not blind because the mapping was already known; it establishes that the specific face-occlusion defect is fixed, not an additional blinded trial. The blind read supports distinct activities in these scenes. It does not establish that children recognize them, that the gestures are enjoyable, or that a long-term story is understood without text.

Nonblocking observation: the request-pose otter reads somewhat smaller/younger than the neutral pose. Identity, clothes and activity remain recognizable. This round does not certify consistency across all five life stages or every existing asset, and this observation alone is not a demonstrated P1/P2 defect.

## Engineering and evidence checks

The reviewer confirmed zero diff from the baseline in `LifeCrossroads/Domain`, `Data`, `Persistence`, `Presentation/DecisionCardModel.swift`, `Presentation/WorldPlayback.swift` and `App/GameStore.swift`. No new clock or random source was introduced. New presentation is limited by the real event/phase; viewing the preserved original life does not become an editable choice card. The saved `ConsequenceTrace` and existing projections determine the aftermath.

`DecisionCardModel` still guards release/request, duplicate submission and unavailable choices. Outcomes cannot be selected again by dragging. Failed saves leave the pre-choice world and old archive intact, expose the failure and permit retry. All four actual UI choices produce identical old/new saved SHA values, followed by cold restore. These are observable saved effects, not only mocked return values.

Final native batches are separate executions on identical source, not one combined run:

| Device / mode | Result | Scope |
| --- | --- | --- |
| iPhone SE3 / light | **7/7** | Real swipes/cancel, held previews, four old/new saved outcomes and cold restore, failure/retry/background/mode switch, layout/all-actions, normal outcome hold, normal branch-entry hold |
| iPhone SE3 / accessible | **1/1** | Max text, dark/high contrast, Reduce Motion, full-button fallback |
| iPhone 17 / light | **7/7** | Same seven cases |
| iPhone 17 / accessible | **1/1** | Same accessible case |

The reviewer read the final logs and independently counted **169 unique Swift test passes** and the Python **51-test PASS** log. The original 30-case UI suite retains all its assertions; its launch helper now explicitly selects `-decision-ui-original`, so it remains rollback coverage. This must not be described as 30 tests of the new default fullscreen UI or as a fresh 30-case execution in this final native batch.

Known evidence boundaries:

- Native interruption covers background/foreground behavior, but a live finger-down drag interrupted by the OS is not captured as a native case; the cancellation model and view lifecycle guard are the supporting evidence for that narrower edge case.
- The production outcome-hold tests remove capture-mode pausing. Remaining `-ui-testing` checksum instrumentation does not itself stop the presentation clock.
- Basic checks retain the drift warning. The delivery envelope preserves the known `session_envelope` expiry (92 days versus 90), prior accessibility findings and the prohibition on claiming all CI green. This reviewer did not verify a newly pushed remote HEAD; exact remote CI status belongs in the delivery report.
- Device cleanup is recorded by the implementer's verification artifact. The reviewer did not create/delete Simulators and did not independently operate device management.

## Remaining product acceptance

This change now meets the bounded visual request in a way the previous four-button layout did not: the choice and its aftermath occupy the same large card, the normal screen is fixed, actions are compact, and different saved activities are visually distinguishable. That is a concrete improvement in presentation; it is not proof that the whole game is more fun.

Owner must still accept the actual iPhone appearance and feel. Manual VoiceOver/Switch Control, real-device touch/cancellation behavior, accidental-submission rate, understanding of help/rest, child preference versus the old buttons, and willingness to continue/replay remain untested by real target players. Existing wider art/accessibility limitations are not cleared by these 13-year screenshots.

**Stop at the requested PoC review boundary. Keep PR #24 Draft / HOLD, without merging, releasing or automatically expanding to other events.**
