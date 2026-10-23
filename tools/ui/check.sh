#!/usr/bin/env bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$TASK_ROOT"
source .venv/bin/activate
bash scripts/governance-check.sh --profile basic
swift test
swiftc -parse-as-library -swift-version 6 -target "$(uname -m)-apple-macosx13.0" \
    UIPrototype/EventFirst/EventFirstModels.swift tools/ui/EventFirstFlowChecks.swift \
    -o /tmp/lc-event-first-flow-checks
/tmp/lc-event-first-flow-checks
python tools/ui/write-wireframes.py
if [ "$#" -eq 0 ]; then
    xcodebuild -project UIPrototype/EventFirst.xcodeproj -scheme EventFirst \
        -sdk iphonesimulator -derivedDataPath UIPrototype/EventFirst/DerivedData \
        CODE_SIGNING_ALLOWED=NO build
else
    if [ "$1" != "--test" ]; then
        echo 'Usage: bash tools/ui/check.sh [--test --device-type iPhone-17 --result-bundle /tmp/event-first.xcresult]' >&2
        exit 2
    fi
    shift
    python tools/ui/run-simulator-tests.py "$@"
fi
