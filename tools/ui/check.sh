#!/usr/bin/env bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$TASK_ROOT"
source .venv/bin/activate
bash scripts/governance-check.sh --profile basic
swift test
python tools/ui/write-wireframes.py
if [ "$#" -eq 0 ]; then
    xcodebuild -project UIPrototype/EventFirst.xcodeproj -scheme EventFirst \
        -sdk iphonesimulator -derivedDataPath UIPrototype/EventFirst/DerivedData \
        CODE_SIGNING_ALLOWED=NO build
else
    xcodebuild -project UIPrototype/EventFirst.xcodeproj -scheme EventFirst \
        -destination "platform=iOS Simulator,id=$1" -parallel-testing-enabled NO \
        -collect-test-diagnostics never -derivedDataPath UIPrototype/EventFirst/DerivedData \
        CODE_SIGNING_ALLOWED=NO test
fi
