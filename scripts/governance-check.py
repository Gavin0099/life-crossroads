#!/usr/bin/env python3
"""Run existing framework checks and preserve actual output, including failures."""
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
from pathlib import Path
import subprocess
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--profile", choices=("basic", "full"), default="full",
                        help="basic: required repository checks; full: additional governance audit")
    args = parser.parse_args()
    root = Path(__file__).resolve().parent.parent
    framework = root / "additional/ai-governance-framework"
    output = root / "artifacts/governance"
    if args.profile == "basic":
        output = output / "basic"
    output.mkdir(parents=True, exist_ok=True)
    environment = os.environ.copy()
    environment["PYTHONPATH"] = str(framework) + os.pathsep + environment.get("PYTHONPATH", "")
    environment["AI_GOVERNANCE_PYTHON"] = sys.executable
    environment["AI_GOVERNANCE_NO_LEDGER_WRITE"] = "1"
    results = []

    def run(name: str, arguments: list[str]) -> None:
        completed = subprocess.run(arguments, cwd=root, env=environment,
                                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                   text=True, encoding="utf-8", errors="replace", check=False)
        (output / f"{name}.log").write_text(completed.stdout, encoding="utf-8")
        warning = name == "drift" and completed.returncode == 1 and "severity           = warning" in completed.stdout
        status = "WARN" if warning else ("PASS" if completed.returncode == 0 else "FAIL")
        results.append({"name": name, "status": status, "exit_code": completed.returncode, "command": arguments,
                        "output": str((output / f"{name}.log").relative_to(root))})
        print(f"{name}: {status}", flush=True)

    pin_code = """import json, pathlib, subprocess
lock = json.loads(pathlib.Path('governance/framework.lock.json').read_text())
head = subprocess.check_output(['git','-C','additional/ai-governance-framework','rev-parse','HEAD'],text=True).strip()
url = subprocess.check_output(['git','config','-f','.gitmodules','submodule.additional/ai-governance-framework.url'],text=True).strip()
if head != lock['adopted_commit']:
    raise SystemExit('framework lock/checkout mismatch')
if url != lock['framework_repo']:
    raise SystemExit('framework source mismatch')
print(head)
"""
    run("framework-pin", [sys.executable, "-c", pin_code])
    run("version-compatibility", [sys.executable, "-m", "governance_tools.governance_version_check",
                                  "--required-versions", str(framework / "governance/runtime/required_versions.yaml"),
                                  "--version-manifest", str(root / ".governance/version_manifest.yaml"),
                                  "--write-artifact", str(output / "version_compatibility.json"), "--json"])
    run("drift", [sys.executable, "-m", "governance_tools.governance_drift_checker",
                  "--repo", str(root), "--framework-root", str(framework), "--format", "human"])
    syntax_code = """import json
from pathlib import Path
import yaml
for path in [Path('contract.yaml'), Path('.governance/version_manifest.yaml'), *Path('.github/workflows').glob('*.yml')]:
    yaml.safe_load(path.read_text())
for path in [Path('governance/framework.lock.json'), *Path('.github/hooks').glob('*.json')]:
    json.loads(path.read_text())
print('Project YAML and JSON parsed successfully')
"""
    run("config-syntax", [sys.executable, "-c", syntax_code])
    run("shell-syntax", ["bash", "-n", "scripts/governance-setup.sh", "scripts/governance-check.sh"])
    source_code = """import ast
from pathlib import Path
for path in [*Path('scripts').glob('*.py'), *Path('.github/hooks').glob('*.py')]:
    ast.parse(path.read_text(), filename=str(path))
print('Project Python sources parsed successfully')
"""
    run("python-syntax", [sys.executable, "-c", source_code])
    if args.profile == "full":
        run("hooks", [sys.executable, "-m", "governance_tools.hook_install_validator",
                      "--repo", str(root), "--framework-root", str(framework), "--format", "json"])
        run("memory", [sys.executable, "-m", "governance_tools.memory_workflow", "--repo", str(root),
                       "--check", "--run-guard", "--fail-on-blocker", "--format", "json"])
        run("quickstart", [sys.executable, "-m", "governance_tools.quickstart_smoke",
                           "--project-root", str(root), "--plan", str(root / "PLAN.md"),
                           "--contract", str(root / "contract.yaml"), "--format", "json"])
        run("external-smoke", [sys.executable, "-m", "governance_tools.external_repo_smoke",
                               "--repo", str(root), "--contract", str(root / "contract.yaml"),
                               "--output", str(output / "external_repo_smoke.json"), "--format", "json"])
        for event in ("session_start", "pre_task", "post_task"):
            run(f"codex-{event}", [sys.executable, str(framework / "runtime_hooks/smoke_test.py"),
                                  "--harness", "codex", "--event-type", event,
                                  "--project-root", str(root), "--plan-path", str(root / "PLAN.md"),
                                  "--contract", str(root / "contract.yaml"), "--format", "json"])
        summary_code = (
            "import json; from pathlib import Path; "
            "from governance_tools.governance_maturity_summary import build_governance_maturity_summary,format_human,summary_to_dict; "
            "s=build_governance_maturity_summary(Path('.'),framework_root=Path('additional/ai-governance-framework')); "
            "Path('artifacts/governance/adoption-status.json').write_text(json.dumps(summary_to_dict(s),ensure_ascii=False,indent=2)+'\\n'); "
            "print(format_human(s))"
        )
        run("adoption-status", [sys.executable, "-c", summary_code])
    ok = all(item["exit_code"] == 0 for item in results)
    receipt = {"generated_at": dt.datetime.now(dt.timezone.utc).isoformat(), "profile": args.profile,
               "ok": ok, "checks": results,
               "not_claimed": ["real Codex lifecycle enforcement", "remote CI success", "real commit/push trigger",
                               "game correctness", "child suitability", "iPhone acceptance"]}
    (output / "checks.json").write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Evidence: {output / 'checks.json'}")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
