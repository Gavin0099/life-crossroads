#!/usr/bin/env python3
"""Bounded Codex visual-gameplay loop for a local Life Crossroads checkout.

No external Python packages. Executes only on the user's machine with git,
Codex CLI, and Xcode installed. Does not merge or publish anything.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time

BASE_BRANCH = "codex/ui-event-first-v1"
MAX_AGENT_MINUTES = 30
MAX_REVIEW_MINUTES = 12
MIN_END_RESERVE_SECONDS = 8 * 60
MANDATORY_PNGS = (
    "01-home.png",
    "02-friend-outcome.png",
    "03-teacher-outcome.png",
    "04-narrow.png",
    "05-large-type.png",
)
REQUIRED_DOCS = ("STYLE_GUIDE.md", "PROGRESS.md", "FINAL_REVIEW.md")
CRITIC_ROUNDS = {2, 4, 6}


def sh(args: list[str], cwd: Path, timeout: int = 90) -> str:
    cp = subprocess.run(args, cwd=cwd, text=True, capture_output=True, timeout=timeout)
    if cp.returncode:
        raise RuntimeError(
            f"Command {args!r} failed (exit {cp.returncode}):\n"
            f"{cp.stdout[-1200:]}\n{cp.stderr[-1200:]}"
        )
    return cp.stdout.strip()


def root_of(path: Path) -> Path:
    return Path(sh(["git", "rev-parse", "--show-toplevel"], cwd=path)).resolve()


def make_worktree(root: Path) -> tuple[Path, str]:
    # A new worktree is essential: the main LC-01 / LC-02 / art work must be untouched.
    sh(["git", "fetch", "origin", f"refs/heads/{BASE_BRANCH}:refs/remotes/origin/{BASE_BRANCH}"], cwd=root, timeout=180)
    stamp = dt.datetime.now().strftime("%Y%m%d-%H%M%S")
    branch = f"codex/ui-visual-loop-{stamp}"
    path = root.parent / f"{root.name}-ui-visual-loop-{stamp}"
    if path.exists():
        raise RuntimeError(f"Worktree destination already exists: {path}")
    sh(["git", "worktree", "add", "-b", branch, str(path), f"origin/{BASE_BRANCH}"], cwd=root, timeout=90)
    return path, branch


def install_specs(worktree: Path, kit: Path) -> None:
    dst = worktree / "docs" / "ui-loop"
    dst.mkdir(parents=True, exist_ok=True)
    for src, name in (("LOOP_PLAN.md", "LOOP_PLAN.md"), ("AGENT_PROMPT.md", "AGENT_PROMPT.md")):
        target = dst / name
        if not target.exists():
            shutil.copyfile(kit / src, target)


def invoke_codex(worktree: Path, prompt: str, out_dir: Path, tag: str, seconds: int, sandbox: str) -> tuple[int, str]:
    out_dir.mkdir(parents=True, exist_ok=True)
    stdout_path = out_dir / f"{tag}.stdout.log"
    stderr_path = out_dir / f"{tag}.stderr.log"
    cmd = ["codex", "exec", "--sandbox", sandbox, "-"]
    print(f"  > {tag}: codex exec ({sandbox}, timeout {seconds // 60}m)", flush=True)
    with stdout_path.open("w", encoding="utf-8") as sout, stderr_path.open("w", encoding="utf-8") as serr:
        proc = subprocess.Popen(
            cmd,
            cwd=worktree,
            stdin=subprocess.PIPE,
            stdout=sout,
            stderr=serr,
            text=True,
            start_new_session=True,
        )
        try:
            assert proc.stdin is not None
            proc.stdin.write(prompt)
            proc.stdin.close()
            code = proc.wait(timeout=seconds)
            return code, str(stdout_path)
        except subprocess.TimeoutExpired:
            # Stop descendants as well as the Codex parent. Never run past the cap.
            try:
                os.killpg(proc.pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
            try:
                proc.wait(timeout=8)
            except subprocess.TimeoutExpired:
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
                proc.wait()
            serr.write("\nUI LOOP TIMEOUT: Codex terminated by bounded runner.\n")
            return 124, str(stdout_path)


def critic_prompt(round_num: int) -> str:
    return f"""You are a STRICTLY READ-ONLY independent visual/UX critic for Life Crossroads.
This is critique after builder iteration {round_num}; do NOT modify files or commit.
Read docs/ui-loop/LOOP_PLAN.md, docs/ui-loop/PROGRESS.md and actual current SwiftUI files.
Open the ACTUAL rendered PNG screenshots with your available image-viewing tool,
not just screenshot filenames, source code, or XCTest pass counts.
Compare baseline (artifacts/ui/screenshots/standard/) to new screenshots (artifacts/ui-loop/).
Prioritize: AI template aesthetics, 13-year-old audience suitability,
character scale, visual hierarchy, composition, palette/story-art coherence,
choice meaning/cost, distinct branch consequences, bottom safe area, dynamic type.
Give P0/P1/P2 findings with exact file/path and reproducible evidence.
First lines MUST be:
GATE=PASS or GATE=FAIL or GATE=NOT_VERIFIED
P0_COUNT=<integer>
P1_COUNT=<integer>
GATE=PASS only after actually opening every final output image, all content/CTA reachable,
no P0 issue, and screenshot visual scene + two outcomes visibly different.
If screenshots are missing or cannot be viewed choose GATE=NOT_VERIFIED.
Separate objective test failures from subjective design judgment.
State up to THREE highest-impact fixes; avoid generic compliments.
"""


def valid_png(path: Path) -> bool:
    try:
        with path.open("rb") as f:
            header = f.read(24)
        return path.stat().st_size > 4096 and header.startswith(b"\x89PNG\r\n\x1a\n")
    except OSError:
        return False


def ready_for_human_review(worktree: Path) -> tuple[bool, list[str]]:
    issues: list[str] = []
    for name in REQUIRED_DOCS:
        if not (worktree / "docs" / "ui-loop" / name).is_file():
            issues.append(f"missing docs/ui-loop/{name}")
    for name in MANDATORY_PNGS:
        if not valid_png(worktree / "artifacts" / "ui-loop" / "final" / name):
            issues.append(f"missing/invalid actual PNG artifacts/ui-loop/final/{name}")

    receipt = worktree / "artifacts" / "ui-loop" / "verification.json"
    if not receipt.is_file():
        issues.append("missing artifacts/ui-loop/verification.json")
    else:
        try:
            data = json.loads(receipt.read_text(encoding="utf-8"))
            if data.get("result") != "PASS":
                issues.append("verification result != PASS")
            checks = data.get("checks") or {}
            for gate in ("build", "ui_tests", "domain_tests", "visual_review", "asset_provenance"):
                gate_obj = checks.get(gate) or {}
                if not isinstance(gate_obj, dict) or gate_obj.get("result") != "PASS":
                    issues.append(f"receipt gate {gate} != PASS")
                evidence = gate_obj.get("evidence")
                if not evidence or not (worktree / evidence).is_file():
                    issues.append(f"receipt gate {gate} lacks existing evidence file")
            ui_evidence = (checks.get("ui_tests") or {}).get("evidence")
            if ui_evidence and (worktree / ui_evidence).is_file():
                # Require unedited machine-generated xcresulttool summary, not prose PASS.
                try:
                    test_summary = json.loads((worktree / ui_evidence).read_text(encoding="utf-8"))
                    devices = test_summary.get("devicesAndConfigurations") or []
                    if len(devices) < 2 or any(
                        d.get("failedTests", 1) != 0 or d.get("passedTests", 0) < 1
                        for d in devices
                    ):
                        issues.append("xcresult summary missing 2 passing simulators")
                    if test_summary.get("result") != "Passed":
                        issues.append("xcresult UI test summary != Passed")
                except (ValueError, TypeError) as exc:
                    issues.append(f"UI test evidence must be xcresulttool JSON summary: {exc}")
        except (ValueError, TypeError) as exc:
            issues.append(f"invalid verification.json: {exc}")
    # The latest independent reviewer must actually review the final images.
    critic_files = sorted((worktree / "artifacts" / "ui-loop").glob("critic-*.md"))
    if not critic_files:
        issues.append("no independent critic report")
    else:
        latest = critic_files[-1].read_text(encoding="utf-8")
        if "GATE=PASS" not in latest or "P0_COUNT=0" not in latest:
            issues.append("latest independent visual critic has not passed the screenshot gate")
    return not issues, issues


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--repo", type=Path, required=True, help="Local life-crossroads git worktree")
    ap.add_argument("--hours", type=int, choices=(3, 4), default=4, help="Hard wall-time ceiling (default 4)")
    ap.add_argument("--iterations", type=int, default=6, help="Max builder iterations (default 6)")
    ap.add_argument("--resume-worktree", type=Path, help="Resume an existing isolated loop worktree")
    ap.add_argument("--push", action="store_true", help="Push independent branch ONLY if ready, clean, and verified")
    args = ap.parse_args()
    kit = Path(__file__).resolve().parent
    for name in ("LOOP_PLAN.md", "AGENT_PROMPT.md"):
        if not (kit / name).is_file():
            ap.error(f"Missing {kit / name}")
    for exe in ("git", "codex", "xcodebuild"):
        if shutil.which(exe) is None:
            ap.error(f"{exe} not found in PATH. No long run started.")

    root = root_of(args.repo.expanduser().resolve())
    print(f"Source repo: {root}")
    if args.resume_worktree:
        worktree = root_of(args.resume_worktree.expanduser().resolve())
        branch = sh(["git", "branch", "--show-current"], cwd=worktree)
        if not branch.startswith("codex/ui-visual-loop-"):
            ap.error("Refusing resume: worktree is not a codex/ui-visual-loop-* branch")
    else:
        worktree, branch = make_worktree(root)
    install_specs(worktree, kit)
    print(f"Isolated worktree: {worktree}\nIndependent branch: {branch}")

    work_artifacts = worktree / "artifacts" / "ui-loop"
    work_artifacts.mkdir(parents=True, exist_ok=True)
    # Keep runtime Codex transcript logs OUTSIDE git; only selected visual critic
    # reports are versioned in the isolated worktree. Otherwise --push can never
    # pass the clean-working-tree check and logs can balloon the commit size.
    runner_dir = worktree.parent / f"{worktree.name}-runner-logs"
    runner_dir.mkdir(parents=True, exist_ok=True)
    state_path = runner_dir / "runner-state.json"
    state = {"branch": branch, "worktree": str(worktree), "hours": args.hours,
             "started": dt.datetime.now(dt.timezone.utc).isoformat(), "runs": []}
    # Per invocation budget is fixed; resume starts a fresh explicit budget window.
    deadline = time.monotonic() + args.hours * 3600
    agent_spec = (worktree / "docs" / "ui-loop" / "AGENT_PROMPT.md").read_text(encoding="utf-8")

    for i in range(1, args.iterations + 1):
        remaining = int(deadline - time.monotonic())
        if remaining <= MIN_END_RESERVE_SECONDS + 240:
            print("Stopping: time reserve reached.")
            break
        seconds = min(MAX_AGENT_MINUTES * 60, remaining - MIN_END_RESERVE_SECONDS)
        print(f"\n=== Builder iteration {i}/{args.iterations}; {remaining//60}m budget remaining ===", flush=True)
        prompt = agent_spec + f"\n\n# CURRENT RUNNER INSTRUCTION\nROUND {i} of {args.iterations}. " \
            f"Total hard time budget {args.hours} hours. " \
            "Read existing PROGRESS.md and critic reports. Continue only remaining work, don't restart. " \
            "Before claiming readiness, write artifacts/ui-loop/verification.json with: " \
            "{'result':'PASS|PARTIAL|FAIL','checks':{'build':{'result':'PASS|...','evidence':'path'}," \
            "'ui_tests':{...},'domain_tests':{...},'visual_review':{...},'asset_provenance':{...}}}. " \
            "For ui_tests.evidence use unmodified xcresulttool JSON summary (2 simulator records), not a text log. " \
            "Each evidence path must exist. If tests are not run mark NOT_RUN. " \
            "Commit only the isolated worktree changes when logically complete.\n"
        code, output_path = invoke_codex(worktree, prompt, runner_dir, f"builder-{i:02d}", seconds, "workspace-write")
        state["runs"].append({"round": i, "kind": "builder", "exit": code, "log": output_path})
        state_path.write_text(json.dumps(state, indent=2, ensure_ascii=False), encoding="utf-8")
        if code != 0:
            print(f"Builder iteration {i} ended exit={code}; stopping to preserve evidence.")
            break

        if i in CRITIC_ROUNDS and (deadline - time.monotonic()) > MIN_END_RESERVE_SECONDS + 600:
            crit_seconds = min(MAX_REVIEW_MINUTES * 60, int(deadline - time.monotonic()) - MIN_END_RESERVE_SECONDS)
            ccode, log_path = invoke_codex(worktree, critic_prompt(i), runner_dir, f"critic-{i:02d}", crit_seconds, "read-only")
            state["runs"].append({"round": i, "kind": "critic", "exit": ccode, "log": log_path})
            if ccode == 0:
                src = Path(log_path)
                dest = work_artifacts / f"critic-{i:02d}.md"
                dest.write_text(src.read_text(encoding="utf-8"), encoding="utf-8")
                # Capture the independent report even when it ran after the last
                # builder iteration; never leave the final report unpushed.
                try:
                    sh(["git", "add", str(dest.relative_to(worktree))], cwd=worktree)
                    sh(["git", "commit", "-m", f"test(ui): archive independent visual critique round {i}"], cwd=worktree)
                except RuntimeError as exc:
                    print("Critic report written, but git commit failed:", exc)
            else:
                print(f"Independent critic failed (exit={ccode}); visual gate must remain pending.")
            state_path.write_text(json.dumps(state, indent=2, ensure_ascii=False), encoding="utf-8")

        ready, issues = ready_for_human_review(worktree)
        if ready:
            print("Complete review package detected; ending early.")
            break
        print("Still pending: " + "; ".join(issues[:5]))

    ready, issues = ready_for_human_review(worktree)
    try:
        sh(["git", "diff", "--check"], cwd=worktree)
        sh(["git", "diff", "--cached", "--check"], cwd=worktree)
        sh(["git", "diff", "--check", f"origin/{BASE_BRANCH}...HEAD"], cwd=worktree)
    except RuntimeError as exc:
        ready = False
        issues.append(f"git diff --check failed: {exc}")
    current_status = sh(["git", "status", "--porcelain"], cwd=worktree)
    if current_status:
        print("Uncommitted files remain (not a blocker for local review; prevents --push):")
        print(current_status[:1800])
    result = {"finished": dt.datetime.now(dt.timezone.utc).isoformat(),
              "ready_for_one_human_review": ready, "issues": issues,
              "branch": branch, "worktree": str(worktree), "runs": state["runs"]}
    (runner_dir / "FINAL_RUNNER_STATUS.json").write_text(
        json.dumps(result, indent=2, ensure_ascii=False), encoding="utf-8")

    if args.push and ready and not current_status:
        try:
            print("Pushing independent branch (no merge / no release)...")
            sh(["git", "push", "-u", "origin", branch], cwd=worktree, timeout=240)
            print(f"PUSHED: {branch}")
        except RuntimeError as exc:
            print("Push failed (local work remains safe):", exc)
    elif args.push:
        print("NOT PUSHED: gates incomplete or there are uncommitted files.")

    print("\nWORKTREE:", worktree)
    print("BRANCH:", branch)
    print("REVIEW READY:", ready)
    if issues:
        print("UNRESOLVED:", "; ".join(issues[:12]))
    print("STATUS FILE:", runner_dir / "FINAL_RUNNER_STATUS.json")
    print("No files were merged or released by the runner.")
    return 0 if ready else 2


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, OSError, subprocess.TimeoutExpired) as exc:
        print("AUTONOMOUS LOOP STOPPED SAFELY:", exc, file=sys.stderr)
        raise SystemExit(2)
