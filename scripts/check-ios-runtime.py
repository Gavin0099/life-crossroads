#!/usr/bin/env python3
"""Fail the UI regression run if the known SwiftUI publication defect returns."""
import argparse
import json
from pathlib import Path
import subprocess
import sys

PUBLICATION_WARNING = "Publishing changes from within view updates is not allowed"


def publication_issues(summary):
    if not isinstance(summary, dict):
        raise ValueError("XCTest summary must be an object")
    warnings = summary.get("runtimeWarnings", [])  # Optional when no issues are reported by xcresulttool.
    if not isinstance(warnings, list) or any(not isinstance(w, dict) or not isinstance(w.get("message"), str) for w in warnings):
        raise ValueError("Malformed runtimeWarnings; cannot verify publication regression")
    return [w["message"] for w in warnings if PUBLICATION_WARNING in w["message"]]


def require_passing_tests(summary):
    if not isinstance(summary, dict):
        raise ValueError("XCTest summary must be an object")
    if summary.get("result") != "Passed" or not isinstance(summary.get("passedTests"), int) or summary["passedTests"] < 1:
        raise ValueError(
            f"Expected a completed, passing XCTest summary: result={summary.get('result')!r}, "
            f"passed={summary.get('passedTests')!r}, failed={summary.get('failedTests')!r}, "
            f"skipped={summary.get('skippedTests')!r}"
        )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("xcresult", type=Path)
    args = parser.parse_args()
    try:
        raw = subprocess.check_output(["xcrun", "xcresulttool", "get", "test-results", "summary", "--path", str(args.xcresult)], text=True)
        summary = json.loads(raw)
        # Preserve the actual completed/failed summary before enforcing the same pass gate.
        # Failed tests are evidence too; screenshots alone cannot substitute for this result.
        args.xcresult.with_suffix(".runtime-summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")
        require_passing_tests(summary)
        issues = publication_issues(summary)
        if issues:
            print(f"SwiftUI publication regression: {len(issues)} issue(s)", file=sys.stderr)
            return 1
        print("SwiftUI publication regression: no matching runtime issue reported")
        return 0
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f"Could not verify SwiftUI runtime issues: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
