#!/usr/bin/env bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$TASK_ROOT"
source .venv/bin/activate
python tools/visual/validate_manifest.py assets/visual-manifest.json
python -m unittest discover -s tools/visual -p 'test_*.py' -v
swift test
bash scripts/governance-check.sh --profile basic
# Pass a simulator UDID explicitly; do not claim which device was tested from a name alone.
if [ "$#" -gt 0 ]; then
    xcodebuild -project UIPrototype/VisualPreview.xcodeproj -scheme VisualPreview \
        -destination "platform=iOS Simulator,id=$1" \
        -derivedDataPath UIPrototype/DerivedData CODE_SIGNING_ALLOWED=NO test
fi
