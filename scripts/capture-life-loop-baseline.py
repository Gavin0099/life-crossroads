#!/usr/bin/env python3
"""LL-00 recorder: execute the existing Swift CLI; preserve, never calculate, outcomes."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BASE = "c823c820ceea027215df2d2f46c2c0ac4373c871"
CODE_BASE = "c136bebf48ae17e24235d9da72d7f9e51b90bf0c"
FROZEN = ["LifeCrossroads", "Package.swift", "LifeCrossroads.xcodeproj", "UITests"]


def command(*args):
    return subprocess.check_output(args, cwd=ROOT, text=True).strip()


def encode(value):
    # Full machine traces stay intact without adding 50,000 generated lines to the PR.
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")) + "\n"


def capture():
    subprocess.run(["git", "merge-base", "--is-ancestor", CODE_BASE, BASE], cwd=ROOT, check=True)
    # The reference recorder must not silently capture a modified gameplay implementation.
    subprocess.run(["git", "diff", "--exit-code", BASE, "--", *FROZEN], cwd=ROOT,
                   stdout=subprocess.DEVNULL, check=True)
    if command("git", "ls-files", "--others", "--exclude-standard", "--", *FROZEN):
        raise ValueError("Untracked gameplay source: capture in the frozen LL-00 checkout")
    receipt = ROOT / "artifacts/governance/life-loop-10h"
    receipt.mkdir(parents=True, exist_ok=True)
    with (receipt / "baseline-cli.log").open("w") as log:
        result = subprocess.run(["swift", "run", "-c", "release", "life-demo", "--environment-samples"],
                                cwd=ROOT, text=True, stdout=subprocess.PIPE, stderr=log, check=True)
    (receipt / "baseline-environment.full.json").write_text(result.stdout)
    report = json.loads(result.stdout)
    catalog = json.loads((ROOT / "LifeCrossroads/Data/Resources/catalog.json").read_text())
    if report["dataVersion"] != catalog["dataVersion"]:
        raise ValueError("CLI/catalog version mismatch")
    policies = [p for p in report["policies"] if p["policy"] == "investFirst"]
    if len(policies) != 1:
        raise ValueError("Expected one explicit investFirst policy")
    output = {}
    for code in ["JPN", "TWN"]:
        household = code.lower() + "-1"
        runs = [r for r in report["runs"] if (r["countryCode"], r["householdID"], r["seed"], r["policy"])
                == (code, household, 0, "investFirst")]
        if len(runs) != 1 or not runs[0]["replayAndRestoreMatch"]:
            raise ValueError("Missing, duplicate or unreproducible reference run: " + code)
        run = runs[0]
        traces = run["traces"]
        ages = [t["age"] for t in traces]
        if len(traces) != 15 or ages[0] != 8 or ages[-1] != 80 or any(a >= b for a, b in zip(ages, ages[1:])):
            raise ValueError("Reference life must contain 15 ordered decisions, ages 8...80")
        if any(not t["applied"] or t["countryCode"] != code or t["householdID"] != household
               or t["seed"] != 0 for t in traces):
            raise ValueError("Unexecuted or mixed-background trace")
        versions = {key: traces[0][key] for key in ["engineVersion", "dataVersion", "contentVersion"]}
        if any(any(t[k] != v for k, v in versions.items()) for t in traces):
            raise ValueError("Mixed trace versions")
        witnesses = [row for sample in report["samples"] if sample["eventID"] == "teen-project"
                     for row in sample["comparisons"] if row["trace"]["countryCode"] == code]
        if len(witnesses) != 1 or (code == "TWN" and not witnesses[0]["trace"]["environmentGaps"]):
            raise ValueError("Missing actual digital-choice comparison / Taiwan gap witness")
        output["baseline-" + code.lower() + "-seed0.json"] = {
            "schemaVersion": 1, "sourceCommit": BASE, "codeBaseCommit": CODE_BASE,
            "versions": versions, "policyDefinition": policies[0], "run": run,
            "decisionSequence": [{"eventID": t["eventID"], "choiceID": t["choiceID"], "age": t["age"]} for t in traces],
            "digitalComparisonWitness": witnesses[0],
            "claimBoundary": "Formal engine reference only; not LIFE-LOOP or animation acceptance. Taiwan unknowns remain unknown.",
        }
    return output


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Rerun Swift and compare existing snapshots; do not overwrite")
    args = parser.parse_args()
    destination = ROOT / "artifacts/evidence/life-loop"
    destination.mkdir(parents=True, exist_ok=True)
    for name, value in capture().items():
        content = encode(value)
        path = destination / name
        if args.check:
            if not path.exists() or path.read_text() != content:
                raise SystemExit("Baseline mismatch: " + name)
        else:
            path.write_text(content)
        print(("Verified " if args.check else "Captured ") + name + " SHA256=" + hashlib.sha256(content.encode()).hexdigest())
