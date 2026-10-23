# Bounded visual loop

Run from the existing isolated worktree with its `.venv` active. This supervisor uses the installed, logged-in Codex CLI; it installs nothing, invokes no paid API, and never commits, pushes, merges or publishes.

```sh
source .venv/bin/activate
python tools/ui-loop/run_ui_loop.py \
  --worktree /Users/macminim4/.codex/worktrees/ui-visual-loop/life-crossroads \
  --base-commit 9bd75d23e6fed6057700fa23a71de31bf3e201d8 \
  --control-dir /Users/macminim4/.codex/visual-loop-control/01a16763 \
  --deadline 2026-10-23T14:30:56Z --iterations 6 --no-push
```

Do not start until the owner finishes the input checkpoint (adopted brief, style guide, candidate images and manifest). The persistent control `state.json` fixes the actual start at 10:30:56Z. This run uses the explicit control directory above so a temporary-directory purge cannot erase its ledger; the owner restores only the original start/deadline and actual attempts after the earlier session restart. Resume with the identical command; it cannot reset that deadline or the number of attempted builders. An exclusive lock prevents concurrent supervisors. Without `--worktree`, an exact `--base-commit` is required to create an isolated `codex/ui-visual-loop-*` worktree; no branch fetch or floating reference is used.

## Execution contract

- At most six builders, each capped at 30 minutes. Each critic is capped at 12 minutes. Every normal child command is also bounded by the absolute deadline, with time reserved for cleanup. Builders preserve a ten-minute convergence reserve.
- Builder uses `workspace-write` from an external sandbox directory, with explicit writable roots only for `UIPrototype/WorldGameplay`, `WorldGameplayTests`, `WorldGameplay.xcodeproj`, `assets/gameplay`, `assets/prompts`, and `docs/ui-loop`. The entire repo is not its writable cwd. Network is disabled. Post-run file hashes, branch, base ancestry and HEAD checks fail closed on a scope or commit violation.
- The supervisor runs `swift test`, the real WorldFlow fixture harness, alpha inspection, candidate provenance checks, then all WorldGameplay UI tests separately on iPhone 17 and iPhone SE 3. It exports the original `xcresulttool` summary and test tree for each bundle. A passing summary must match the scheme, exact device model, zero failures and at least six executed tests; the raw tree must show all six mandatory WorldGameplay methods passing on the same device. Summaries and trees are never hand-merged.
- The five required final PNGs come from named XCTest attachments. The narrow maximum-text reaction is also attached to critics when present. Critic invocation directly attaches these PNGs with CLI `--image`; input receipts preserve argv, image hashes, successful exit and the genuine CLI thread-start transcript. CLI 0.163 does not expose `view_image` events in its JSONL, so this is **image-input evidence**, not a claim about unseen tool logs.
- The first three critic lines must exactly contain `GATE=...`, `P0_COUNT=...`, `P1_COUNT=...`; PASS requires both counts zero. Each P0 also needs a stable `P0_ID=...` line. At least two distinct CLI critic threads are required. The latest passing critic must match current source and final image hashes. Repeated P0 or no verified change across consecutive reviews ends iteration.
- Source/test failure can be repaired by a later bounded builder. Missing, malformed or stale evidence yields PARTIAL/exit 2; screenshots or textual PASS alone cannot pass the package gate. Candidate provenance PASS means hashes and references are traceable for the prototype; `approved_for_app=false` is required and is **not** a commercial approval claim.

## Process and Simulator cleanup

Every command has its own process group and a separate parent/deadline watchdog. Normal exit, timeout, SIGINT and SIGTERM terminate descendants. The watchdog also terminates the owned child group if the supervisor crashes or is killed.

`tools/ui/run-simulator-tests.py` journals a unique creation intent before requesting a device and writes the returned UUID immediately. If interrupted between creation and UUID publication, cleanup resolves only that exact 128-bit owned name, records the UUID, and deletes by UUID. It never deletes by broad name, `all`, runtime, or another task's device. An unresolved creation remains pending and fails cleanup rather than being silently forgotten. Shutdown failure/timeout still attempts deletion. After deletion, a fresh device inventory must confirm that UUID is absent. Failed or ineffective deletion retains `owned` status for a later sweep.

```sh
python tools/ui/run-simulator-tests.py --cleanup-only \
  --owned-ledger /Users/macminim4/.codex/visual-loop-control/01a16763/owned-simulators.json
```

The final package includes the owned-device cleanup ledger. A gate cannot pass unless both tested UUIDs are recorded as deleted and no creation intent remains unresolved. Host shutdown or unavailable CoreSimulator can still prevent cleanup; those cases retain a pending ledger and require the command above.

## Evidence and final gate

Runtime state, logs, bundles and iteration PNGs remain outside Git in the selected control directory. A final snapshot is copied to `artifacts/ui-loop/`: final PNGs, two untouched summaries and test trees, supervisor check logs, critic reports/transcripts/input receipts, cleanup ledger and `verification.json`. Existing source/baseline evidence is not rewritten.

After the run and after any necessary documentation or canonical-memory checkpoint, independently verify the current package:

```sh
python tools/ui-loop/run_ui_loop.py \
  --worktree /Users/macminim4/.codex/worktrees/ui-visual-loop/life-crossroads \
  --base-commit 9bd75d23e6fed6057700fa23a71de31bf3e201d8 \
  --control-dir /Users/macminim4/.codex/visual-loop-control/01a16763 \
  --deadline 2026-10-23T14:30:56Z --verify-only
```

This read-only verification may run after the loop deadline; it does not restart or extend the loop. The owner handles review, canonical memory, commit and push separately. A local package PASS is not real-device, child-playtest, commercial-art or release approval.

## Runner regression tests

```sh
python -m pytest tools/ui-loop/test_run_ui_loop.py -q
```

These use independent fixtures for strict headers, malformed receipts, path escapes, two device summaries, current-source/image binding, actual attachment arguments, subprocess timeout/descendants, and owned-device cleanup. Mocked Simulator fixtures test deletion scope and persistence; they are not actual Simulator runs. Existing opt-in actual device lifecycle tests remain in `tools/ui/test_simulator_lifecycle.py`.
