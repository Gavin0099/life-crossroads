# Acting v1.1 — implementation / Round 4

Status: implemented in source; **build, UI observations, screenshots and critic gate NOT_VERIFIED**. The builder did not launch a Simulator or run the tests. No acting proof JSON is authored here; only the supervisor may produce the canonical proof from real XCTest attachments.

## Presentation mapping

`WorldGameplayView.swift` defines `ActorEmotion`, `ActorPose` and `ActorStageVisualState`. `WorldGameplayView.actingState` requires the real event ID `workshop-2027`, accepted selected key and the actual current snapshot. `bridge` is only the art/proof alias; the fixture and options remain `workshop-2027` / `team` / `help`.

| Snapshot / accepted option | Presentation state | Expression / pose | Prop |
| --- | --- | --- | --- |
| `workshop-start` / none | `bridge-initial` | `thinking` / `idle` | `paper-bridge-materials` |
| `team-reaction` / `team` | `bridge-team` | `hopeful` / `collaborating` | `paper-bridge-prototype` |
| `help-reaction` / `help` | `bridge-help` | `neutral` / `asking` | `borrow-tools-list` |

The same state selects the foreground, dialogue portrait and meaningful actor accessibility description. With the test-only `-acting-proof` launch flag, `world-actor.accessibilityValue` is JSON containing the event alias, source event, character, option, expression, pose, prop and actual Asset Catalog IDs. Ordinary gameplay uses the Chinese expression title as its value and the meaningful Chinese action description as its label, without technical JSON. The initial option is JSON null. Missing/rejected route data does not set `selectedKey`, so the initial acting remains. A blocked missing-next scene retains the last valid reaction. Next-day, time-passage and adult snapshots retain the existing renderer; the reaction composite is not reused as a later event or adult outcome.

## Assets and renderer

Three exact copies were added under `UIPrototype/WorldGameplay/Assets.xcassets/`; their PNG hashes match the original manifest entries. Original `assets/gameplay/va-*`, prompts and manifest were not modified.

| Asset Catalog name | Original candidate | Use |
| --- | --- | --- |
| `va-otter-emotions-v1` | `assets/gameplay/va-otter-emotions-v1.png` | `ActorPortrait`: in-memory CGImage crops from original 1254×1254 atlas; exact four 627×627 cells, neutral (0,0), thinking (627,0), hopeful (0,627), tired (627,627) |
| `world-cast` (existing) | `assets/gameplay/characters-atlas-v2.png` | Idle cast using existing per-character source rectangles |
| `va-friend-worktable-v2` | `assets/gameplay/va-friend-worktable-v2.png` | Entire collaborating foreground, including hands, paper prototype and table |
| `va-teacher-worktable-v2` | `assets/gameplay/va-teacher-worktable-v2.png` | Entire asking foreground, including teacher, friend, list and table |

`ActorStageVisual` uses the existing workshop background and `ActorPoseVisual`. Idle uses the matching transparent va-materials-table-v1 painted table with loose paper without drawing a successful route. Reaction composites are fitted whole with margins; no old cast, duplicate name tags or floating bridge/list is overlaid. Family support remains in the authored story and relationship page; the supplied reaction composites do not depict the caregiver. Portraits appear in the initial header and reaction dialogue, with the same crop component used in the catalog. Two posture-only fixture phrases were aligned with the art: the initial friend is simply nearby, and the teacher comes to the table rather than sitting. Meaning, route uncertainty, resources, reasons and later memories remain intact.

## Native catalog, motion and observations

`WorldGameplayApp` launches `ActingContactSheet` with `-acting-contact-sheet`. It uses the exact `ActorEmotion.allCases`, `ActorPose.allCases`, `ActorPortrait` and `ActorStageVisual` components used by the game. Four portraits and three complete stage samples are laid out on one screen at default text size. The `acting-catalog` heading exposes the catalog JSON consumed by the branch test. Native layout on both models is still awaiting supervisor validation.

Selection uses a 0.25-second transition. The existing environment Reduce Motion flag or test argument `-reduce-motion` passes nil animation and applies the same accepted WorldFlow snapshot synchronously. Result buttons and state have no scheduled delay. The existing playback/year system is unchanged.

The original six UI methods and screenshot names remain. Four added mandatory methods:

- `testActingBranchesAreVisuallyDistinct`: reads catalog JSON from the rendered preview, then reads the actual `world-actor` value initially and after real `team` and `help` taps on fresh launches. It attaches those decoded values, not assertion expectations, as UTF-8 JSON `acting-state-observations.json`, `.keepAlways`.
- `testReducedMotionPreservesOutcome`: for both routes compares observed normal and reduced-motion actor dictionaries, reaction text, pending uncertainty and enabled continuation.
- `testActingContactSheetShowsCatalog`: checks all seven rendered sample frames and attaches the real screen as `acting-contact-sheet`.
- `testMissingRouteKeepsInitialActing`: checks the missing-route error, unchanged observed initial state, absent result/reaction, empty history and restart state.

The largest-text test also keeps its no-extra-swipe assertion after the entry, adds a two-second hittable wait and `accessibility-decisions` capture, and scrolls the actual presented detail viewport. The prior direct choice anchor is preserved.

## Remaining limits

These are composed candidate images and portrait crops, not skeletal animation or twelve independently posed expressions. `tired` is catalog-only. Later scene work surfaces remain outside this focused change. All source assets retain `approved_for_app=false`. Expression readability, identity anchors, hands, full-scene framing, contact-sheet fit, VoiceOver experience and both-device attachment export need actual supervisor/critic evidence. No build/test/art PASS, real-device, child-playtest or commercial approval is claimed.

## Round 6 correction from actual failures

Round 5 iPhone17 passed nine of ten methods; SE3 passed eight of ten. Largest-text scrollTo did not move at all (before/after screenshot bytes equal); SE catalog had two oversized portrait accessibility frames and a last pose beyond the viewport. Those failures remain preserved.

Largest text now opens a large native decision sheet using the existing choices. Cancelling leaves the world awaiting a choice. A selected option is stored only until sheet dismissal, then passed to the same WorldFlow selection so reaction focus occurs in the visible world. The original no-extra-swipe entry assertion remains and cancellation has a regression assertion. No second copy of choices stays behind the sheet.

Portraits crop the exact source cell in memory rather than moving an oversized Image. Source PNGs are unchanged. Catalog vertical space reserves more room for its heading, portraits and footer; complete-frame assertions remain. The initial materials table is a versioned ImageGen prop matching the route worktable, with only loose paper and no successful bridge. Proof initial asset IDs include that table. All assets remain unapproved prototype candidates. Focused and full tests are pending; these edits alone do not establish PASS.

The focused SE3 catalog regression passed after the crop/layout fix. The entry still failed even after changing scrollTo into a sheet, revealing that the decorative scene intercepted taps outside its clipped bounds. Disabling hit testing only on the noninteractive scene made the unchanged maximum-text entry/result/comparison/next-day regression pass (47.859s). Scene accessibility descriptions remain available. Full two-model validation is next; focused results do not replace it.
