# MULTI-CAST-LOOP independent engineering review

2026-10-28 · Reviewer `multicast_code_review` · Base `30d60007ca43431a740c093f17c75a5e75dc0fb6` · working branch `codex/multi-cast-loop`

## Decision

**CHANGES_REQUESTED — one bounded P2 wording defect.** The new casting projection preserves the distinction between an invitation, a request, an actual relationship interaction, and a saved reunion participant. The reviewed code does not change the engine, data, persistence, seed rules, or save schema. One new accessibility description nevertheless infers a beginner activity from a fixture that covers only the recovery branch; the production matcher also accepts the continuation branch.

This is an interim, source-bound review of the current uncommitted candidate. It does not approve a later source revision, remote CI, merge, release, formal artwork, child comprehension, physical devices, or VoiceOver usability. The parent owns the narrow correction and subsequent evidence. This reviewer did not start a Simulator or edit product/test/memory/PLAN files.

## P2 — do not infer beginner status for every nature-recording scene

- Location: `LifeCrossroads/Presentation/WorldCastScene.swift:27`, reached by lines 37–39 and 57.
- Attribution: introduced.
- Current-decision impact: yes for the claim that every new description is grounded in the actual route; no core state corruption was observed.
- Disposition: fix now; parent acknowledged the finding and plans to remove the unnecessary beginner assertion in round 3. Not yet verified fixed by this report.
- Actual behavior: `.natureNotes` always says `這是入門觀察`, although its matcher accepts `adult-local-trail/record` at age 32 without distinguishing `adult-local-trail-recovery` from `adult-local-trail-continuation`.
- Independent reachable witness: JPN, `jpn-1`, Seed 5. Real choices: age 8 `child-interest/invest`; 10 `child-friend/invest`; 12 `child-rain-notebook/observe`; 13 `teen-project/invest`; 17 `teen-direction/invest`; 21 `teen-tool-library/rest`; 25 `adult-learning/invest`; 32 `adult-local-trail/record`. The age-32 resolved event is `adult-local-trail-continuation`, retaining actual earlier nature observation. The existing `32-ahe-trail` fixture instead exercises `adult-local-trail-recovery`.
- Narrow correction: describe the actual action — recording plants together — without deciding whether it is the player's first or an experienced observation. No Domain or schema change is needed. Keep the statement that this selected action is not leading a group or receiving certification.
- Regression: cover both real recovery and continuation routes and confirm both stay factual, keep `ahe` as the actual interaction, and do not call the continuation route a beginner route.

The witness was executed against the existing compiled, unmodified `LifeDomain` library with `xcrun swift -I .build/multi-cast-loop/fixtures -L .build/multi-cast-loop/fixtures -lLifeDomain -Xlinker -rpath -Xlinker "$PWD/.build/multi-cast-loop/fixtures" -e '<probe>'`. The probe started real JPN/jpn-1 sessions for seeds 0..<128, preferred `observe` for `child-rain-notebook`, `join` for `teen-river-survey`, otherwise feasible `invest` then `rest`, continued normally to age 32, and selected `record` only for the real continuation event. It printed the full route above and `found=true`. It did not inject an event, trace, resources, or story state, and wrote no fixture.

## Boundaries verified in source

| Surface | Review observation |
|---|---|
| Inviter vs interaction | Choosing projects only normalized known names/IDs as `inviter`. Committed scenes require `interacted` from a relationship interaction matching event, choice, and age; inviter evidence cannot satisfy that requirement. |
| 32-year request | `adult-boundary-calendar/ask` adds only `recipient` for the saved event's actual Cheng identity. `.requesting` explicitly leaves assistance unconfirmed. It is not `.pacedParticipation`. |
| 72-year identity | Saved recurring person and exact saved story variant must agree before a `participant` appears. Ahe requires `later-reconnect-old-friend`; Cheng requires `later-reconnect-new-neighbor`. A retained friendship flag by itself does not create a participant. `ask` maps to planning, `rest` to no cast scene. |
| 25-year teacher | `adult-learning/cooperate` uses the real `teacher` interaction, despite the generic `工作夥伴` recurring-person label. It does not substitute Cheng. |
| Missing/unknown evidence | Unsupported event/age pairs, no committed choice, no matching actor role, and unknown/candidate IDs do not create a cast scene. The selected real 10/13/72 rest cases have no invented companion. |
| Save failure | Existing `GameStore.choose` binds a new world only after `commit` succeeds. The new UI failure test asserts unchanged scene label and archive checksum, no chosen action, then a successful retry with changed saved checksum. Reviewer inspected this test; did not execute it. |
| Candidate animals | Cat/dog are only consumed by the `#if DEBUG` candidate Preview. They have no story person mapping; hare is not aliased to Cheng. Preview assets being bundled does not establish formal artwork approval. |
| Runtime cuts | Manually compared all six current atlas dimensions and manifest source rectangles with `WorldSceneBitmaps.cell`. Ahe row split 484, teacher 642, Cheng 493, Mumu 627, cat x edges 0/399/766/1201/1653/2011, and dog x edges 0/406/797/1185/1609/1983 agree. |
| Original boundaries | `git diff 30d6000` reports no changes in Domain, Data, Persistence, or `UITests/LifeCrossroadsUITests.swift`. The latter still contains all original 30 `func test` declarations. |

No other actionable casting correctness blocker was established within this bounded review. The negative-case assessment is not exhaustive proof for all future events or hypothetical manually fabricated frames.

## Evidence provenance and test quality

- The fixture generator uses normal `LifeSession.start`, real feasible choices, focus choices, and `continueLife`; it does not force events or edit authoritative state. It calls catalog-backed full replay, disk save/load, and replayed-save byte equality. All 17 fixture payload hashes and all current `sourceSHA256` bindings matched independently at review time.
- `LifeSession.restore` calls `validate`, which replays from the original start and compares the entire session. Therefore the new restore test checks a meaningful independent invariant, not merely JSON decoding or renderer self-comparison. It additionally checks that observing the cast leaves the saved file bytes unchanged.
- The six new Swift tests cover actual fixture identities, request/participation distinctions, same-seed old-friend/new-neighbor histories, rest, missing actor evidence, unknown events, incompatible presentation phases, missing committed choices, candidate IDs, disk save/load, and full replay. They lacked the continuation-route case identified above.
- The capture test is compiled only under `VISUAL_LOOP_CAPTURE`. The existing App fixture ingress additionally requires a Simulator build plus both `-ui-testing` and `-visual-loop-capture`; it validates the archive with the real catalog before saving into the isolated UI-test archive. The normal App build has no compiled capture ingress. The Xcode project adds the capture source and fixtures to the UI-test target rather than the App resources phase.
- Capture screenshots use actual `XCUIApplication` and `lifeWorldScene` element screenshots. Source metadata binds App, Presentation, test, artwork, and fixture inputs. Current round-2 SE source hashes all matched at inspection. Older baseline/round-1 hashes correctly differ from the current candidate and must not be presented as final-source capture proof.
- The baseline SE provenance note explicitly records the manifest metadata addition and re-export of omitted hyphenated attachment names. The original baseline standard-device attempt retains `failure.json`; its replacement is separately named `baseline-recovery`. This reviewer did not reinterpret that failed attempt as successful.
- The native capture test verifies scene existence, a real archive checksum, unchanged archive during capture, feasible controls, and large/reduced-motion flags. Visual species/age/gaze/activity acceptance remains with the independent image critic and Owner, not these source assertions.

## Reviewer execution

| Check | Result / limit |
|---|---|
| `swift test -c release --skip-build --filter WorldCastTests` | 6 tests, 0 failures. Executed the existing release test build; this is not an independent fresh rebuild. |
| `PYTHONDONTWRITEBYTECODE=1 .venv/bin/python -m unittest discover -s Tests -p 'test_multicast_assets.py' -v` | 3 tests, 0 failures. Includes real decoded alpha gutters, PNG/manifest dimensions/hashes/rectangles, and candidate restrictions. |
| Independent real-engine nature-route probe | Confirmed the P2 route above. A passing happy-path suite does not close it. |
| Fixture/source hash recomputation | 17 payloads plus every generator manifest source binding matched. |
| `git diff --check` | Passed at review time. |
| Simulator / physical-device actions | None by reviewer. |
| Full baseline / final CI | Not rerun or claimed. Root must report the final candidate separately. |

The known framework session-envelope 90-day failure remains a disclosed pre-existing basic-governance failure. This review did not disable, rerun, fix, waive, or convert it into a pass. Passing focused tests do not establish an all-green CI result.

## Reviewed source identity

SHA-256 before the parent correction:

```text
c74beefc7f747e8c1ac4f0a50b4b3ba913037faa9aa6a17303f6ddfb0283a429  LifeCrossroads/Presentation/WorldCastScene.swift
66079867710f5ab92462b53d1a118d1cd553ba3c9e507d610d457de2fd68c1bd  LifeCrossroads/Presentation/LifeWorldFrame.swift
07ad75149d9d4ef9f1c73c614223843601f0b06ed712b44582156f05af3a446d  LifeCrossroads/App/LifeWorldScene.swift
45ab980d6293f2d246eeb2cc1ebf42766e2cc493f9144ccab2faed639d9755f7  Tests/LifePresentationTests/WorldCastTests.swift
6ed8bf42c4f3ee7e55026074a130d6a8372d5ebaf97dac23f84c83d81f37f28c  UITests/MultiCastCaptureTests.swift
```

Governance inputs: AGENTS/base, PLAN, project guardrails, active task, SYSTEM_PROMPT, AGENT, REVIEW_CRITERIA, TESTING, response-envelope Engineering Explanation, and prior review/knowledge records. Relevant prior PR14 no-support and PR17 visual findings were checked for overlap; this review does not reopen their unrelated closed fixes. Active memory measured 91 lines / 9,743 characters, WARNING; no memory mutation. Parent retains canonical review-memory responsibility.

```yaml
mode: REVIEW
task: MULTI-CAST-LOOP bounded independent engineering review
task_authority: parent delegation of user-requested multi-agent work
done:
  - reviewed casting semantics and evidence/test boundaries
  - executed six existing-build Swift tests and three Python asset tests
  - reproduced one real-engine continuation-route wording defect
claim_ceiling: interim changes requested; one P2, no additional confirmed blocker in reviewed boundary
not_claimed:
  - final corrected-source approval or fresh full build
  - final remote CI or basic governance pass
  - native capture execution by this reviewer
  - formal artwork, child comprehension, physical-device or VoiceOver acceptance
  - commit, push, merge, release, or project session closeout
files_touched: docs/multi-cast-loop/ENGINEERING_REVIEW.md
next_action: parent removes unsupported beginner assertion, adds the reachable-route regression, and requests bounded re-review
```

## Delta re-review — P2 closed, 2026-10-28 14:47 Asia/Taipei

**Latest verdict: APPROVED for the bounded casting engineering change; the original P2 is resolved, and no additional blocker was established.** This supersedes the interim `CHANGES_REQUESTED` decision above while preserving its finding, witness, and historical source binding.

The corrected `.natureNotes` description now states only `沐沐與阿禾在戶外分段記錄沿路植物。` It neither calls a returning observer a beginner nor infers expertise, leadership, or certification. The matcher and evidence guards are unchanged. Replacing this one sentence with the original text reconstructs the exact previously reviewed `WorldCastScene.swift` SHA-256, so the production correction is demonstrably confined to that sentence. `LifeWorldFrame.swift`, `LifeWorldScene.swift`, and `MultiCastCaptureTests.swift` still match the earlier reviewed hashes.

The new `testNatureContinuationDoesNotInventFirstTimeExperience` (lines 106–122) executes the independently found JPN/jpn-1 Seed 5 route through normal engine choices and continuation. It verifies the actual selected event and `adult-local-trail-continuation`, contrasts the existing fixture's `adult-local-trail-recovery`, projects the committed real trace, checks `.natureNotes`, and rejects `入門`/`首次` in the resulting description. The existing matrix test still projects the recovery fixture to the same `.natureNotes` kind and checks the real Ahe identity. The common description therefore covers both histories without a new authority or schema field.

Failure and correction evidence:

- Author's `artifacts/governance/multi-cast-loop/validation/nature-regression-before.log` was read: the new test failed exactly at the unsupported `入門` assertion, 1 test / 1 failure. The reviewer did not recreate this historical source state.
- Author's freshly rebuilt `artifacts/governance/multi-cast-loop/validation/swift-final.log` records `Build complete!` and all 7 `WorldCastTests` passing on the corrected source. The full suite was still in progress when inspected; its eventual total and final result remain the parent's reporting responsibility.
- Reviewer independently ran `xcrun xctest -XCTest LifePresentationTests.WorldCastTests/testNatureContinuationDoesNotInventFirstTimeExperience .build/release/LifePresentationTests.xctest` against that newly built test bundle: exit 0, 1 test / 0 failures at 14:47:01. This is a focused execution, not a second full-suite run or an independently rebuilt toolchain qualification.
- `git diff --check` passed. No Simulator was created or used; no product, test, PLAN, memory, commit, or remote change was made by this reviewer.

Final changed-source bindings for this delta:

```text
63c0231f3cd6c54c6649b2960e70748e761c7183a8b17ecd941108348f261232  LifeCrossroads/Presentation/WorldCastScene.swift
cdb90a4e42f008844306478cbfd02fe74fdb074fb5ecdc4f223c0dd5b8b418c0  Tests/LifePresentationTests/WorldCastTests.swift
```

The P2 disposition is now **resolved / fixed**, with current-decision impact **no** at this bounded engineering-review boundary. This does not change the limits on final native captures, final HEAD CI, the pre-existing basic-governance 90-day failure, formal artwork, physical-device/VoiceOver/child evidence, or merge/release authority. No project-level session closeout was attempted; this is review completion only.

```yaml
mode: REVIEW
task: MULTI-CAST-LOOP P2 delta re-review
done:
  - verified the production delta is one factual description sentence
  - verified the real continuation regression and recovery comparison
  - read original failing regression evidence
  - independently executed corrected focused regression successfully
claim_ceiling: bounded engineering review approved; original P2 closed; no additional confirmed blocker
not_claimed:
  - final full-suite, native capture, remote CI, or basic-governance pass
  - formal artwork, child comprehension, device or VoiceOver qualification
  - merge, release, or session-end authority
files_touched: docs/multi-cast-loop/ENGINEERING_REVIEW.md
next_action: parent completes its already-authorized final validation and delivery report
```
