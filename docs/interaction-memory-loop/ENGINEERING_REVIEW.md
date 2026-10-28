# Interaction / relationship memory — independent engineering review

2026-10-28 · Reviewer `interaction_guard_review` · base `a79f667528b5b4cbeb2e543b6d9ca33a12d680f1` · branch `codex/interaction-memory-loop`.

## Latest result

**APPROVED for the corrected bounded engineering slice; Draft/HOLD remains.** The final delta review below closes the confirmed findings and binds the reviewed source/native evidence. Earlier interim findings are retained chronologically; they are not the latest verdict. Product, formal art, real-device/VoiceOver/child testing and final remote CI remain separate.

## Historical interim decision and boundary

**Interim: CHANGES_REQUESTED for evidence completion; no new product correctness blocker established in the reviewed projection delta.** The new relationship panel links two actual saved choices and validates their source relationship. A request remains a request throughout its presentation beat. However, the initial native capture harness only inspects restored, paused outcomes, so it cannot yet demonstrate the new expressing-to-listening transition. The new fixture manifest also names an obsolete base. These are bounded evidence corrections, not a request to redesign the engine.

Owner decision: continue the authorized bounded visual/interaction Loop and prepare a reviewable Draft/HOLD candidate. DONE: factual request interaction, an actual past/present friendship contrast, negative-case protection, replay/save preservation, and native visual evidence. Claim ceiling: this slice's engineering and evidence quality; not merge/release, formal art approval, child comprehension, physical-device or VoiceOver qualification, or 90–95% product completion.

Reviewed: `WorldRelationshipMemory.swift`, `LifeWorldFrame.swift`, directly affected `LifeWorldScene.swift` rendering, new focused tests/capture harness/fixture generator, and the unchanged `GameStore` save-before-publish boundary. The reviewer did not edit product/tests/memory/PLAN, create a Simulator, commit, push, or modify GitHub. The parent owns native runs, remaining delivery and canonical memory.

## Findings / evidence gaps

### W1 — the initial capture path never observes the new request transition

- Convention: WARNING, source-bound validation gap; introduced by this slice's capture harness.
- Location: `UITests/InteractionCaptureTests.swift`, `testReplayValidatedNativeScenes`; unchanged `WorldPlayback.swift:42–53` explains the effect.
- Evidence: capture loads an already-reflecting archive and calls `resume()`. `bind(restoring:true)` pauses a reflecting outcome and sets `phaseElapsedMs = durationMs` (2000 ms). Normal request captures consequently start in the `listening` beat; they do not show `expressing → listening`. The pure enum test checks both thresholds but does not execute that native transition.
- Current-decision impact: yes for accepting the frozen visible-transition/evidence DONE; this does not establish incorrect request semantics or unsafe saving.
- Disposition: fix now. Exercise a real choosing archive, save `ask`, capture the actual early/late presentation while retaining the same committed archive, and keep controls/Reduced Motion functional. Do not fabricate applied traces or alter the outcome to achieve the capture.
- Status: open at this interim review.

### W2 — the new fixture manifest identifies the old slice's base

- Convention: WARNING, evidence metadata defect; introduced by copying the fixture generator.
- Location: `tools/interaction-memory-loop/Fixtures.swift`, manifest `baseline`; generated `interaction-fixtures/manifest.json`.
- Evidence: both currently state `30d60007ca43431a740c093f17c75a5e75dc0fb6`, whereas this slice and capture metadata use `a79f667528b5b4cbeb2e543b6d9ca33a12d680f1`.
- Current-decision impact: yes for a consistent new-slice evidence identity; fixture/source hashes themselves match, and no wrong engine execution was observed.
- Disposition: fix now in new evidence, preserving old slice evidence unchanged.
- Status: open at this interim review.

### W3 — the relationship scene crop includes explicit age labels

- Convention: WARNING, evidence interpretation boundary; introduced by the new panel.
- Location: `LifeWorldScene.swift`, `relationshipScene`; `InteractionCaptureTests.swift` scene attachment comment.
- Evidence: the native element includes `10歲 · 那時` and `72歲 · 現在`. Cropping `lifeWorldScene` no longer removes all age information.
- Current-decision impact: yes if a blind critic's age/history interpretation is counted as no-text recognition; no if the labels are explicitly masked/ignored and the report preserves that limitation.
- Disposition: fix evidence protocol now, or explicitly retain a no-text qualification gap. Do not claim a reader inferred ages merely by reading the labels.
- Status: open at this interim review.

## Product boundaries verified

- The relationship projector requires reflecting phase; latest trace `applied`; matching current age 72/event `later-reconnect`/choice `invest`; exact `story.childhood-connection` rule, friendship key, variant, and 10-year `child-friend` source; an applied historical trace matching the branch's choice; Ahe identity; and a fact with matching age/event/choice. Missing or inconsistent evidence yields nil.
- Old-friend output requires `connected`, past `invest`/`ask`, old-friend variant and actual Ahe recurring person. New-neighbor output requires `paused`, past `rest`, new-neighbor variant and actual Cheng. The past/rest panel has Mumu alone; it does not place Cheng in childhood or call their adult encounter the first ever meeting.
- The actual paired fixtures contain a completed double windmill/kept-contact choice at age 10 versus resting without a next appointment, and age-72 Ahe versus Cheng variants. The source branch explicitly points to that past trace. This is not inferred from a current resource score or a surviving flag alone.
- Current request evidence is still supplied through `WorldCastScene`: 13 `ask` has teacher interaction and `support=requested`; 32 `ask` has `support=requested`, no changed relationship, and only recipient casting. `pacedRole` is separate. The new beat only chooses expressing/listening, never assistance, cooperation or agreement.
- No independent clock, random draw or authoritative state mutation is added. The beat consumes shared elapsed time; Reduced Motion uses a static expressing pose. A resumed completed outcome may start at its final presentation stage without changing the saved meaning.
- `LifeWorldFrame.presenting` drops relationship memory outside committed outcome. Renderer additionally matches the actual cast person and current choice before drawing the paired panel.
- `GameStore.commit` still saves before assigning `journey`, and `choose`/`next` bind a projected frame only after successful commit. Failed saving cannot publish the new panel or request result through this path.
- `git diff a79f667 --name-only` for Domain, Data, Persistence and the original `LifeCrossroadsUITests.swift` was empty. The original 30-case UI surface is not replaced by these extra captures.

## Independent execution / test quality

Executed at 16:35:31–16:35:45 Asia/Taipei:

```text
xcrun xctest -XCTest LifePresentationTests.WorldRelationshipMemoryTests .build/out/Products/Debug/LifePresentationTests.xctest
5 tests / 0 failures, exit 0
```

This independently executes the author's current Debug test build; it is not a second fresh build or full-suite qualification. Tests include real validated same-seed paired archives, explicit wrong/missing/future source and actor/fact mutations, invitations/rest/requests, phase clearing, full catalog-backed replay, Codable restoration, and request timing/Reduced Motion distinctions. Negative mutated sessions intentionally bypass validation to exercise local projector guards; they are not presented as legitimate persisted lives.

The final `before == encode(save)` assertion in the new unit test is limited value-type nonmutation evidence; it is not by itself a disk-write failure test. Real disk save/load, full replay and replayed-save byte equality are executed in the fixture generator. The existing/new native save-failure test must be reported separately with its actual execution result.

Independently recomputed all **20 fixture payload hashes** and every `sourceSHA256` entry in the new manifest: **0 mismatches** at inspection. Generator uses normal `LifeSession.start`, feasible choices/focus, `continueLife`, `SaveRepository`, and full `LifeSession.restore`; it does not inject events, actors, resources, histories or outcomes.

No new native capture or complete CI result is claimed by this reviewer. The known governance session-envelope expiry remains disclosed; this review neither waived nor altered that check. Formal artwork, child trial, real iPhone and human VoiceOver gaps remain outside this source acceptance.

## Interim source binding

```text
199e8c39757a621d26662013731982ce35aa850c8a5d8f504d2a0f6f051446a4  LifeCrossroads/Presentation/WorldRelationshipMemory.swift
526a7952909dcb539347da70ef240be68c3075dc17c86e54cae90962d0e9f543  LifeCrossroads/Presentation/LifeWorldFrame.swift
4be3cb9c07165af3e77df270154b7ee7c517735b8194d604f511ce90dba9ea93  LifeCrossroads/App/LifeWorldScene.swift
d9721b520e6ea1fb702240f49ca46d71bfa2f14563cbd810a412d6b5664805ed  Tests/LifePresentationTests/WorldRelationshipMemoryTests.swift
8384715e92880f532912cdc16f81efe32d0903d4d3ef2f0b2804123671a14b5c  UITests/InteractionCaptureTests.swift
```

Governance inputs: AGENTS/base, SYSTEM_PROMPT, AGENT, REVIEW_CRITERIA, current PLAN/guardrails/active memory, prior review log, knowledge base, and prior multi-cast review. Prior nature wording P2 was confirmed already resolved; this slice does not reopen it. No recorded knowledge-base anti-pattern was silently bypassed. Architecture: read-only Presentation and SwiftUI; native interop N/A; existing `@MainActor` publish boundary unchanged. Active memory 93 lines / 9933 characters, WARNING; reviewer did not expand it. Root retains the canonical memory workflow.

## Added finding — actual screenshot exposes a past/present narration error

**P1, pre-existing and exposed by this slice; current-decision impact: yes; fix now.** This supersedes the interim statement that no product correctness blocker had been established. The visual critic identified the actual round-1 `72-neighbor-normal-screen` text: `這一頁接續了你10歲留下的選擇：和小澄擺一張社區風車桌。` The old-friend screen likewise attributes `和阿禾再做一架風車` to age 10.

The source independently confirms the mismatch at `LifeCrossroads/Presentation/LifeStoryComparison.swift:45–53`: its default case combines `branch.sourceAge` (10) and `trace.eventTitle` (the current age-72 event). `CrossroadsView.swift:710` consumes these consequences in the real outcome screen. For the new-neighbor fixture, the actual age-10 choice was rest without making another appointment; Cheng is the current adult/community connection, not the childhood action. The new visual panel therefore correctly shows past solitude while the adjacent prose contradicts it.

Although this source predates the current diff, the frozen DONE explicitly depends on truthful past/present memory. Attribution does not remove that current-decision impact. The bounded correction belongs in Presentation: separate the past-source reference from the explicitly current age/event, or omit the current event title from the past-choice sentence. Do not reconstruct an unknown past choice title from the current trace. Add a real old-friend/new-neighbor consequence regression and a generic source-branch case; no Domain/schema change is necessary. Status: open pending parent correction and delta verification.

## Delta review — corrected narration and completed request evidence

At 16:57:24–16:57:30 Asia/Taipei the reviewer independently reran the current Debug bundle:

```text
xcrun xctest -XCTest LifePresentationTests.WorldRelationshipMemoryTests .build/out/Products/Debug/LifePresentationTests.xctest
6 tests / 0 failures, exit 0
```

The new sixth test checks actual 72-year Ahe and Cheng records, the real 65-year `middle-return-slowly-continuation` record whose source is age 59, and a source-less 32-year recovery negative. Earlier draft test assumptions about a 32-year recovery or 52-year care event having a source age were rejected during review and corrected; they are not additional product failures. The queued file `narrative-regression-red.log` never ran its tests before cancellation while waiting for the SwiftPM lock. It is not red-test evidence. The actual round-1 screenshot, independently viewed by this reviewer, plus the old production sentence establishes the original bug.

**P1 narration: resolved.** The one-line correction now says `你10歲留下的故事記錄，影響了現在72歲的「…」。`, with each age taken from its respective source/current trace. It no longer attributes the current title to childhood. It does not invent a past choice title when that title is unavailable to the generic consequence function. The no-source path remains silent. The visual critic confirmed both corrected 72-year screens in round 2; the focused regression executes the formal consumer.

**W1: resolved for two actual presentation observation points.** The capture-only observer is excluded from normal builds (`VISUAL_LOOP_CAPTURE && simulator`). It observes real elapsed monotonic time and invokes the existing pause operation after a genuine choice/save; it does not inject time, state, actors, effects or random draws. Early/late assertions require actual elapsed time on the correct side of the 1100 ms presentation threshold and equal saved checksums across two real executions. The `final` SE log records age-13 points 235/1435 ms with equal archive checksum and age-32 points 247/1414 ms with another equal checksum, plus save-failure/retry passing. That whole batch still had one unrelated capture-target failure and is not reported as entirely passed. Both `final2` device suites subsequently passed their three capture tests, including the real clock and save-failure tests. This proves the two recorded poses/clock points, not a naturally animated continuous performance or a child's understanding of asking without assurance.

The initial `beats` batch's age-32 failure was a test targeting error: `isHittable` alone accepted a button beyond the visible drawer/above the pinned footer. The correction uses the existing suite's visible-viewport reveal behavior; it does not change the actual game state or choice code. The next `final` matrix failure was the inverse test-only mistake, treating the pinned `continueLife` footer as a drawer target. Both failures remain in evidence rather than being erased or combined with later passing counts.

**W2: resolved.** The current 20 fixtures and all generator source hashes were independently rechecked with zero mismatches; baseline is now `a79f667`. `round1/fixture-manifest-at-capture.json` preserves the historical wrong-baseline metadata: its independently recomputed SHA-256 `c1e61f65766741c97b8428fafb372a60e2353235c090a3ae8e2ebff807549bc8` equals the original round-1 `source.json` hash for the then-current fixture manifest. The old capture is not relabeled as having used corrected metadata.

**W3: resolved as a claim-boundary correction.** `CRITIC.md` explicitly ignores the embedded time labels for silhouette assessment and states that this is not a strict human masked-text experiment. No exact-age or no-text causal comprehension acceptance is inferred from those labels. This preserves the intended limitation rather than pretending the labels are absent.

### Additional layout defect and narrow correction

The visual critic found that enlarged time labels covered faces. The bounded 11 pt noninteractive label and separate band closed that face-overlap problem, but final2 introduced a composition seam: the right inner scene's `height - 26` content was vertically centered by its outer fixed-height frame and then offset another 26 points. The reviewer independently viewed `final2/.../72-ahe-large-scene.png`: the right feet were cut off while the past panel remained complete. The 39 pt total displacement (13 pt centering plus 26 pt offset) explains the observed roughly 78 pixel SE band; this is a source-supported diagnosis, not a substitute for new screenshots.

The final correction adds `.topLeading` alignment to that outer frame. To establish the exact delta, the reviewer removed only that alignment text in memory and hashed the reconstructed source: `2de584b88e56f9ee6243fb501f6d3091b6954215d121f6cf2d04797d6a2b40b4`, exactly matching both final2 device source records. Thus the final3 change is confined to the 72-year relationship container; previously passing 13/32 request and save-failure evidence from final2 can be carried forward with that precise binding. It is not permission to carry evidence across arbitrary future changes in the same file. Final3 native matrix and visual confirmation remain required before the latest overall verdict below.

## Final engineering verdict — APPROVED, Draft/HOLD retained

The corrected bounded engineering candidate has **no unresolved confirmed correctness/evidence blocker in this review**. The earlier P1 narration defect, W1–W3 evidence issues, and the identified relationship-container clipping seam have been resolved at their stated boundaries. This supersedes the interim `CHANGES_REQUESTED`, without deleting its findings or failed attempts. It approves the slice's engineering evidence for a Draft review; it does not authorize merging or publishing.

Final verification independently checked by this reviewer:

- New projection/narration tests: **6 / 6**, independently executed on the current rebuilt Debug bundle, as recorded above. The author's earlier full **157-test** run predates the sixth added regression; it is not represented as a full current 158-test run by the reviewer. Final HEAD CI remains the parent's separate check.
- Both final3 devices: **19 actual saved scene states and 19 reachable controls each**, one matrix test / zero failures per device. All current `sourceHashes` and all final3 image hashes were independently recomputed: zero mismatches. The parent-produced `verification.json` is `allPass=true`; the reviewer also inspected its verifier rather than relying solely on that boolean.
- Both final2 devices: three tests / zero failures, including the four actual request time points and injected save-failure/retry. The reviewer read the native logs. The final3-only container alignment delta is independently byte-bound above, so this evidence is carried forward only for unaffected request/save paths. No combined single-run “all tests passed” count is fabricated.
- The verifier now requires the exact four `(age, beat)` pairs as well as their elapsed ranges, preventing duplicate observations from satisfying the two-age/two-beat contract. It checks immutable engine/data/persistence/CI/original-UI surfaces, fixture checksums, screenshot hashes, warning summaries, and task-device cleanup.
- The reviewer independently read the native final3 SE `72-ahe-large-scene.png` and iPhone 17 `72-neighbor-large-scene.png`: both preserve the current actors' complete feet, faces and interaction props after the `.topLeading` correction. These targeted engineering checks complement the independent Visual Critic; they do not replace its broader remaining product/age/style assessment.
- **Eight task-created Simulators** have individual delete receipts, and none of their UDIDs exists in a fresh read-only `simctl list devices -j` inventory. This reviewer created/deleted zero devices and did not touch shared runtimes or other tasks' devices.
- Protected paths remain unchanged against `a79f667`: Domain, Data, Persistence, CI workflows and the original 30 UI test source. `git diff --check` passed. New art remains Draft candidate material, not formally approved art.

The current rendering changes remain read-only. The original life, branch semantics, fixed-seed event selection, replay validation and saved schema are unchanged. This supports the narrow claim that the world now visibly distinguishes a recorded request and its listening pose, and shows a trace-backed past/present relationship contrast. It does **not** prove a child's ability to infer all those meanings without text, natural continuous character animation, exact-age recognition, human VoiceOver usability, formal art consistency across all events, real-iPhone playability or voluntary replay. The known governance session-envelope expiry is not silently waived or called green.

The independent Visual Critic subsequently completed its standard-device review (11 scene crops plus one full screen), recorded zero remaining confirmed visual blockers for this slice, and retained natural-animation, all-activity-age and human-understanding limitations in `CRITIC.md`. Its conclusion agrees with the final SE review; it is not formal artwork or child acceptance. Actual final remote CI must still accompany delivery separately. No percentage of overall product completion is justified by this review.

### Final reviewed source hashes

```text
199e8c39757a621d26662013731982ce35aa850c8a5d8f504d2a0f6f051446a4  LifeCrossroads/Presentation/WorldRelationshipMemory.swift
526a7952909dcb539347da70ef240be68c3075dc17c86e54cae90962d0e9f543  LifeCrossroads/Presentation/LifeWorldFrame.swift
1be67f4a04144eae48bc7708b786ea75c640444aa008d1873b8d9bb106c3e148  LifeCrossroads/Presentation/LifeStoryComparison.swift
e003435e7c2d340d60cd5a2d21089853ada22e9484c330b44b1de25eac94c23e  LifeCrossroads/App/LifeWorldScene.swift
9537f5ba6a2be50f8869e19c1e6b62e71b553b0d588ce0681b4c81b47e519d4c  LifeCrossroads/App/GameStore.swift
c9b2bf53fc2d332bea7228e805beae1c34072bcc5910f084768455b38b09df84  LifeCrossroads/App/CrossroadsView.swift
e68da15b1bb20f08d024bee5b1f10b91dfa7a284c15c39a353869521b45dea8d  Tests/LifePresentationTests/WorldRelationshipMemoryTests.swift
b7ceebf49c1ecdb3dfc709ba7fdca0286883dfc87167307bdbbb802d7bce5183  UITests/InteractionCaptureTests.swift
```

```yaml
mode: REVIEW
task: INTERACTION-MEMORY-LOOP independent engineering delta review
task_authority: delegated user-authorized bounded loop
verdict: APPROVED
claim_ceiling: corrected engineering slice and source-bound local evidence; Draft/HOLD
resolved:
  - actual past/present narration mismatch
  - request transition evidence limited to true clock observation points
  - fixture baseline identity and historical-manifest preservation
  - no-text critic claim boundary
  - caption/container clipping seam
confirmed_open_engineering_blockers: 0
not_claimed:
  - final remote CI success or governance-expiry pass
  - full latest local 158-test suite independently rerun
  - full natural animation or human no-text comprehension
  - formal art, real iPhone, VoiceOver or child entertainment qualification
  - merge, release or 90-95 percent product completion
reviewer_files_touched:
  - docs/interaction-memory-loop/ENGINEERING_REVIEW.md
reviewer_simulators: 0
memory_and_delivery_owner: root
```
