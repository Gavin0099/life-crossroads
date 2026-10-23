#!/usr/bin/env bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$TASK_ROOT"
source .venv/bin/activate
bash scripts/governance-check.sh --profile basic
swift test
xcrun swiftc -parse-as-library UIPrototype/WorldGameplay/WorldModels.swift tools/ui/check-world-flow.swift -o /tmp/lc-world-flow-check
/tmp/lc-world-flow-check
swift assets/gameplay/inspect-alpha.swift
if [ "$#" -eq 0 ]; then
    xcodebuild -project UIPrototype/WorldGameplay.xcodeproj -scheme WorldGameplay \
        -sdk iphonesimulator -derivedDataPath UIPrototype/WorldGameplay/DerivedData CODE_SIGNING_ALLOWED=NO build
elif [ "$1" = "--test" ]; then
    shift
    python tools/ui/run-simulator-tests.py --scheme WorldGameplay "$@"
else
    echo 'Usage: bash tools/ui/check-world.sh [--test --device-type iPhone-17 --result-bundle /tmp/world.xcresult]' >&2
    exit 2
fi
