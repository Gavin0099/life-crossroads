# FINAL-POLISH-LOOP — independent engineering review

Reviewer: `/root/final_polish_engineering`. Only this report is written by the reviewer; no product/test changes, Simulator, commit, push, merge or release.

**Latest local Engineering Verdict: ACCEPT for the reviewed presentation delta. FP-E1 is CLOSED.** Final source/evidence binding and limitations are in the final section below; initial observations remain as history. This is not an approval of an unseen remote CI run, merge, release or product completion.

## Initial review — 2026-10-28

**Preliminary engineering result: no confirmed product correctness blocker in the inspected delta. Final verdict pending frozen native evidence and current-head CI.** One verifier coverage warning below must be closed before relying on its PASS as final source/timing proof.

### Frozen decision boundary

- Owner decision: bounded final presentation polish, separate Draft PR based on PR20 `325b69896553fb6c479e415c0c0991e76ef78a26`; preserve all simulation/persistence semantics and then stop for playtesting.
- DONE: observed visual improvements, correct trace-backed actors, unchanged original/branch/replay/save behavior, native two-size evidence, independent review, honest remaining limits.
- Claim ceiling: engineering safety of the presented delta and its named evidence. This is not formal art, physical iPhone, human VoiceOver, child comprehension, entertainment, merge or release acceptance.
- Boundary: three changed App views, new pure Presentation transition helper, two edited candidate atlas cells, Xcode capture-test registration and evidence harness; adjacent cast/projection/save/clock consumers read for semantic verification.
- Inputs checked: AGENTS/base; SYSTEM_PROMPT, REVIEW_CRITERIA, relevant AGENT/ARCHITECTURE/TESTING rules; current PLAN, `docs/final-polish-loop/PLAN.md`, project guardrails; active-task memory; relevant prior review-log entries, knowledge base and `docs/interaction-memory-loop/ENGINEERING_REVIEW.md`. No human-only oversight document loaded.
- Memory pressure measured 95 lines / 10,190 characters, CRITICAL. This review uses the current fixed task and independent source evidence, not accumulated memory as new authorization. Canonical review memory is the parent's responsibility.

### Checks performed

| Boundary | Evidence and result |
| --- | --- |
| Protected surfaces | Independently compared **86 tracked files byte-for-byte** with base: Domain, Data, Persistence, all pre-existing Tests, original `UITests/LifeCrossroadsUITests.swift`, scripts, workflow and GameStore. **Zero differences**. Base test-method inventory independently counted **158 Swift / 45 Python / 30 original UI**. New files are additive. |
| Save before publish | Unchanged `GameStore.commit` writes through `SaveRepository.save` before publishing `journey`; `choose`, `next`, timed advancement bind the world only after successful commit. The new view/helper have no reference capable of writing the journey. Existing restore, fault injection and actual archive SHA reader remain unchanged. |
| Truthful casting | `WorldCastScene.project` still requires supported event, saved choice and evidenced actor role. `WorldRelationshipMemory.project` still requires the matching age-10 trace/fact and age-72 branch/participant. No added story fact, success, accepted-help state or childhood rabbit. |
| Transition | `WorldRequestTransition` reads only supplied phase elapsed time; requires both committed phases and an actual request; Reduced Motion and nonfinite inputs return the static asking pose. It has no timer, RNG, I/O or mutable state. Pause/resume and speed retain the existing clock contract. |
| Crop/pose continuity | Request endpoints use one fixed reviewed source rectangle per age and the same width/height/x/floor. Separate `request-*` bitmap cache keys cannot collide with old cell keys. Missing candidate bitmaps fall back to the original request pose. Only reviewed cell 2 is rendered. Final visual smoothness still needs the Critic's native assessment. |
| 72-year composition | Shared childhood height cap/width rule changes scale only. Old-friend versus new-connection cast still comes from immutable projected history. The previously fixed top-leading caption/container alignment is retained. |
| UI and accessibility | Changed title keeps full choice text and stable identifier/value; at accessibility sizes decorative eyebrow is omitted and its context stays in the spoken label. No choice feasibility/resource changes. Workshop change is background/border only. Human VoiceOver execution remains untested. |
| Thread/native safety | Existing App bitmap cache remains `@MainActor`; no new asynchronous publication, observer or timer. `CGImage` crop uses retained immutable objects and guarded optional results. No new ABI/manual pointer boundary; native interoperability audit N/A beyond existing image code. |
| Capture isolation/cleanup | New capture class remains behind `VISUAL_LOOP_CAPTURE`, invokes existing archive-validation ingress, observes actual shared clock then pauses it, and reads actual saved-file checksums. Capture script creates its own device and traps EXIT/INT/TERM to shutdown **and delete** that device. No original device/runtime cleanup added. |

### Test quality and execution boundaries

- New five Swift tests assert reviewed timing endpoints (held through 700 ms, half handover at 900 ms, settled at 1,100 ms), bounded/monotonic output, Reduced Motion/nonfinite negatives, invitations/rest/participation/wrong-phase rejection and pause/total-clock independence. Expected values do not reimplement the easing formula.
- The new save-nonmutation unit test is **read-only value/projection smoke evidence**, not proof of real disk failure handling. Actual disk/complete-fork assertions remain in `SaveRepositoryTests`, `WorldPersistenceTests` and `BranchExperimentTests`; App save-failure/retry/cold-restoration tests remain among the original 30 UI cases.
- Independently executed `.venv/bin/python -m unittest discover -s Tests -p 'test_final_polish_assets.py' -v`: **3/3 PASS, 4.137 s**. It checks original/reference bytes, byte-identical integrated candidate PNGs, approval boundary, real alpha coverage within the common crop and clear cell split lines. No generated pixels modified.
- Read parent's current local Python output: **48 tests PASS, 36.570 s**. Current Swift log shows all five new transition cases passed; full-suite completion is not yet claimed at this checkpoint. Reviewer did not launch a competing Swift build.
- Round1 evidence manifest reports both devices 3 tests / 0 failures, 26 states and 6 true-clock request samples each, 60 native attachments each, no runtime warnings, both task devices deleted. These are **baseline** results, not post-change acceptance. Parent's independently retained baseline source check reports zero product/fixture mismatches with base.
- Remote CI for the final new HEAD does not yet exist at this checkpoint. Prior Basic `session_envelope` 91-day versus 90-day failure remains a carried-forward known limitation, never a green-CI claim; framework/date/Gate/workflow bytes are unchanged.

### Finding FP-E1 — WARNING: final evidence verifier needs exact timing/source identity checks

- Convention: REVIEW_CRITERIA `WARNING`, evidence coverage; not an established product defect.
- Initial location: `tools/final-polish-loop/verify-evidence.py:33–46`.
- Evidence: initial implementation checks only six request rows, so duplicates could satisfy the count without covering both ages and all three beats. Source hashes are compared to base only for Round1; Round3 is not compared with the final current product bytes. The earlier interaction-memory review explicitly retained exact-pair verification, so this is a regression in a new evidence utility's coverage.
- Attribution: introduced; status: **open pending final verifier correction**; disposition: fix now, bounded evidence-only correction.
- Current-decision impact: **yes for accepting the verifier as final provenance/timing proof**, no confirmed simulation or save defect. Actual current logs have not been shown to contain duplicate rows or stale rendering.
- Acceptance: require exact unique `(13,32) × (expressing,handoff,listening)` samples; independently bind final source hashes to the actual final rendering/test bytes (or a precisely documented frozen commit), retaining historical Round1 hashes. Re-run on the completed captures and preserve results. Keep final source changes from silently invalidating earlier screenshots.
- Rule reference: TESTING §3.2/§3.3 (independent/sensitive assertions), REVIEW_CRITERIA §2.2/§3.3 (exact delta and evidence), Owner FP-05/Final delivery source requirements.

### Prior findings / remaining qualification

- Prior narration-as-childhood and caption clipping defects were read and confirmed not reintroduced in the source delta; no Domain correction is needed for this slice.
- Final native smoothness, posture identity, true-clock mid-frame and dual-size maximum-text/Reduced Motion assessment remain pending. No source-only visual PASS is issued.
- Human gameplay, coarse-age recognition, natural continuous performance, physical iPhone and VoiceOver usability remain qualification gaps. No completion percentage is derived from test counts.
- Knowledge base contains two cautionary guidance items and no promoted technical anti-pattern; both checked. The relevant prior-review patterns (trace truth, source binding, exact clock observations, caption grounding) were explicitly cross-checked.

### Initial source binding

This is an uncommitted candidate binding, not an approval of a future HEAD:

| File | SHA-256 |
| --- | --- |
| App/LifeWorldScene.swift | `730af7ef1a5101b22f11e527cdbeda165a8d1460fbf16104e876eec9ff25a0cb` |
| App/CrossroadsView.swift | `c5d906795d82210948d3ad05766dcc4789b39a63df3c96fe08d0510c147d557e` |
| App/ProjectWorkshopView.swift | `cba308400fb8dc858d16a780cd4316cea92844a255d9db13ac7465e834d204f2` |
| Presentation/WorldRequestTransition.swift | `96c13f993157601cbd5efed202804452751dceb95179d3ce900533f78fd9c0d2` |
| Tests/LifePresentationTests/WorldRequestTransitionTests.swift | `87a7b2ec52266b184b893587edcd52e564b46b583bbba1e90a8b9da0495ab546` |
| Tests/test_final_polish_assets.py | `d5ec31eb1e07736865d20a63e542a86ee4193c0eb6dc67b4449568772af6e4f0` |

Active-turn accounting: started **11:25:48 UTC**; completion timestamp will be reported to parent when returning. Final follow-up is limited to the remainder of the 20-minute reviewer budget.

### Initial-turn follow-up

At **11:31 UTC**, parent supplied the narrow verifier correction. Reviewer read the actual changed code: both request ages/three beats now require an exact six-element unique set; the matrix/control logs require the exact selected state set/count; Round3 App/Presentation/UI test/project/fixture hashes now compare to current bytes. Tool hashes remain recorded but are deliberately outside final renderer identity. **FP-E1 source correction is satisfactory; execution against completed final captures is still pending.**

Parent's now-complete Swift log independently counted **163 distinct passed XCTest methods, zero failed methods**; the empty Swift Testing runner messages are not counted as additional tests. No second full run was launched by this reviewer. First active turn **11:25:48–11:31:20 UTC** (conservative close estimate **5 min 32 s**); remaining reviewer budget **14 min 28 s**. Return idle until final evidence is supplied.

## Final local engineering review — 2026-10-28

**Engineering Verdict: ACCEPT, bounded to the current source hashes and local evidence below.** No outstanding confirmed P1/P2 product-correctness blocker was found in this presentation-only delta. Keep Draft/HOLD; remote CI, visual qualification and product acceptance are separate decisions.

### Final delta and protected boundaries

- Re-read the final App/helper/test diff. The last timing correction is a **120 ms handover from 700 to 820 ms**, with the independently specified half-opacity endpoint at 760 ms. The previously recorded 400 ms/900 ms half-point is historical Round 2 behavior, not the final contract. Pure phase/request/Reduced Motion/nonfinite guards remain. No added clock, random draw, state mutation, success or agreement is introduced.
- The shared `StoryPalette.illustratedPaper` extracts the existing warm RGB values; caption/card/background consumers change rendering only. Crossroads retains the full chosen action and accessibility context. Fixed crops, shared grounding, seated 32-year props, original asking fallback and true-history 72-year casting remain intact.
- Independently recomputed **all 90 entries** in `protected-surfaces.json` against both their manifest hashes and exact base bytes: **zero mismatches**. This includes the original 86 protected files and four pre-existing presentation projection/clock files. Original **158 Swift / 45 Python / 30 UI** test methods remain unchanged; no negative case, Gate or workflow was weakened. `git diff --check` is clean.
- Full-suite records include actual-disk every-phase round trips, immutable original/fork prefixes, complete alternate lives, fixed-choice replay, eight-country restore/replay, malformed/unknown archives and failure/retry behavior. Examples are `SaveRepositoryTests.testRealDiskRoundTripEveryPhaseKeepsOriginalAndReplaysRemainingLife`, `BranchExperimentTests.testSameSeedChoicesAndCodableAtEveryPhaseReproduceCompleteAlternative`, and `WorldPersistenceTests.testForkOriginalBytesSurvivePresentationAndMidBranchDiskRestore`. The additive read-only transition unit test is still only smoke evidence and is not substituted for these stronger checks.

### Local validation and exact limits

| Evidence | Independently checked result | Claim boundary |
| --- | --- | --- |
| `swift.log` | 163 distinct XCTest cases passed, zero failed | Full suite at Round 2. Do not call this a single full run after the final timing change. |
| `swift-final-focused.log` | 5 transition tests passed, zero failed | Final 700–820 ms change: endpoints, negatives, clock independence and projection/archive invariance. Empty filtered suites are not extra tests. |
| `python.log` / independent first-turn asset run | 48/48 passed; reviewer separately ran the 3 additive asset checks | Hashes, candidate status, crop alpha safety and original Python range retained. |
| Final native SE3 and iPhone 17 | **3/3 tests per device**, zero failures/skips/warnings; 26 matrix/control states, 8 actual-clock request samples and 62 PNGs each | A focused capture/integration set. The original 30 UI cases are preserved, but no new local full-30 run is claimed. |
| Final native identity | **64 rendering/test/project/fixture hashes per device** independently match current bytes; all **124 final PNGs** independently match their manifests | Frozen local candidate, not a future commit or remote build. Evidence-tool hashes are retained separately from renderer identity. |
| Save-before-publish native exercise | Both final logs contain `oldFileAndInvitationUnchanged=true retrySaved=true`; request/archive hashes remain identical at all four times and across rounds/devices | Real failed-write/retry observation complements unchanged store/disk/branch tests; no claim that a screenshot alone proves persistence. |
| Cleanup | Both final device UUIDs independently absent from `simctl list`; retained verifier confirms all six task devices deleted | No device creation/deletion by this reviewer. |
| Basic governance | Five PASS, drift WARN/exit 1; actual log retains `session_envelope` age 91d > 90d | Known non-green Gate remains; date/framework/workflow/Gate were not changed. |
| Remote CI | **NOT REVIEWED for the new final HEAD in this local review** | Parent must bind pushed HEAD and current CI separately in the PR. No future result is counted as passed. |

### FP-E1 disposition — CLOSED

The corrected verifier now enforces exact unique age/beat pairs, exact matrix/control sets and final-current rendering/test/fixture identities. Historical Round 1/2 retain their six samples; Round 3 explicitly requires **eight**, adding a real in-transition observation for each age. The UI test and verifier both reject a transition sample at or after 820 ms, so a settled endpoint cannot masquerade as the blend.

The completed `evidence-verification.json` reports **PASS with zero failures** over six captures: 364 PNGs, 156 matrix/control states and 40 actual-clock request samples. The reviewer independently checked the final source/PNG hashes, actual log times, archive identities and deletion state rather than relying solely on the PASS label. The recorded in-transition times are:

| Device | 13-year transition | 32-year transition |
| --- | --- | --- |
| iPhone SE3 | 772 ms | 738 ms |
| iPhone 17 | 720 ms | 737 ms |

All are strictly inside the final 700–820 ms window. Archive hashes remain `8d85eb25d6f21ac085fa4fafec47c110567a6513133614c2ab49c8336a65f1b4` (13) and `942b8c7bf91ec42b4e135db52654af9c2dc2da07b6978921bf2c5499fe00f03a` (32). FP-E1 no longer blocks accepting the retained local provenance/timing evidence.

### Final source binding

| File | SHA-256 |
| --- | --- |
| App/LifeWorldScene.swift | `0e10b6feed556a8ecba419d344d11321915bf6b56b86234dfc2e966289237ff9` |
| App/CrossroadsView.swift | `a3c4e193bc7365a6090de030e45cc343f2218a7ab1b641a9f863b635cdb84f73` |
| App/ProjectWorkshopView.swift | `25508c479a591bf02c41d6b16d710bf72b16b14f32de44023e2b9eb1c5e7816b` |
| App/StoryVisuals.swift | `3d67257e4b7f23cc479159accc71e3f12b5965891570e921e5ce7b27a81e8b67` |
| Presentation/WorldRequestTransition.swift | `5fe25b370f9fe77ed9a2a5c20aa90a9a8561cc85e60e8008073a9313fc1b97fb` |
| Tests/LifePresentationTests/WorldRequestTransitionTests.swift | `a5f31d09a5eb99921dfab145eb0c071eae7be0328f2615454f0291314f795c56` |
| UITests/FinalPolishCaptureTests.swift | `ce4de282d43e6bb485bde990bcb83e80187f2d21beadd874533a30318e2bf98f` |
| tools/final-polish-loop/verify-evidence.py | `ab61a5bb0cc1f89ea0cb8e32adb03c870ce912be88f0131209399da7f91a552a` |

### Remaining acceptance gaps and stop

Independent Visual Critic retains FP-V4 large-text reading comfort and FP-V5 translucent intermediate hands as **P2/PARTIAL**, with no claim of continuous anatomical animation or effortless accessibility. They do not establish a new save/decision regression and are not silently converted to engineering PASS. Its conditional visual verdict and owner-led playtest readiness remain separate from this engineering verdict.

Physical iPhone operation, manual VoiceOver, target-age recognition, enjoyment, spontaneous replay and environment/choice comprehension remain untested. Do not infer 90–95% product completion, formal art approval, an all-green CI, or release readiness from this report. Stop this bounded Loop for owner playtesting; no additional Loop is authorized by the review.

Final active follow-up charged conservatively **11:55:30–12:00:00 UTC (4 min 30 s)**, including context restoration and source/evidence review. Combined with the first turn: **10 min 02 s of the 20-minute reviewer cap**. Only this report was written; all other verification was read-only.
