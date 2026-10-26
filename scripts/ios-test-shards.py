#!/usr/bin/env python3
"""Partition the declared XCTest methods in the project's single UI test source.

Every declared case runs once across the matrix. Empty/invalid shards fail closed.
Actual execution and passing counts still come from XCTest, not this inventory.
"""
import argparse
import json
from pathlib import Path
import re


def declared_tests(source):
    names = re.findall(r"^    func (test\w+)\(", source, re.MULTILINE)
    # Refuse unfamiliar formatting instead of silently omitting a newly added case.
    candidates = re.findall(r"\bfunc\s+(test\w+)\s*\(", source)
    if sorted(candidates) != sorted(names):
        raise ValueError("Unrecognized UI test declaration; refuse a partial inventory")
    if not names or len(names) != len(set(names)):
        raise ValueError("Expected unique, nonempty UI XCTest methods")
    return sorted(names)


def partition(names, shard, count):
    if count < 1 or not 0 <= shard < count or len(names) != len(set(names)):
        raise ValueError("Invalid UI shard configuration")
    selected = sorted(names)[shard::count]
    if not selected:
        raise ValueError("UI shard must execute at least one test")
    return selected


def verify_execution(summary, selected):
    if (not selected or not isinstance(summary, dict) or summary.get("result") != "Passed"
            or type(summary.get("passedTests")) is not int or summary["passedTests"] != len(selected)
            or summary.get("failedTests") != 0 or summary.get("skippedTests") != 0):
        raise ValueError("XCTest must pass every selected case; no missing or skipped cases")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("shard", type=int)
    parser.add_argument("count", type=int)
    parser.add_argument("--summary", type=Path)
    args = parser.parse_args()
    source = Path(__file__).resolve().parents[1] / "UITests/LifeCrossroadsUITests.swift"
    selected = partition(declared_tests(source.read_text()), args.shard, args.count)
    if args.summary:
        verify_execution(json.loads(args.summary.read_text()), selected)
        print(f"Verified {len(selected)} selected UI cases passed")
    else:
        for name in selected:
            print("LifeCrossroadsUITests/LifeCrossroadsUITests/" + name)
