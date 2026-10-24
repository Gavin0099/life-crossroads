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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("xcresult", type=Path)
    args = parser.parse_args()
    try:
        raw = subprocess.check_output(["xcrun", "xcresulttool", "get", "test-results", "summary", "--path", str(args.xcresult)], text=True)
        summary = json.loads(raw)
        if not isinstance(summary, dict) or summary.get("result") != "Passed" or not isinstance(summary.get("passedTests"), int) or summary["passedTests"] < 1:
            raise ValueError("Expected a completed, passing XCTest summary with executed tests")
        # Keep all runtime warnings, not only the one this regression check rejects.
        args.xcresult.with_suffix(".runtime-summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2) + "\n")
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
