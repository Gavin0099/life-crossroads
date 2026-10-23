#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p artifacts/ios
LIFE_TEST_DEVICE="${LIFE_SIMULATOR_ID:-}"
if [ -z "$LIFE_TEST_DEVICE" ]; then
  LIFE_TEST_DEVICE="$(python3 - <<'PY'
import json, subprocess
inventory = json.loads(subprocess.check_output(['xcrun', 'simctl', 'list', 'devices', 'available', '-j']))
phones = [d for version, devices in inventory['devices'].items() if 'iOS' in version
          for d in devices if d.get('isAvailable') and d['name'].startswith('iPhone')]
if not phones:
    raise SystemExit('No available iPhone Simulator')
print(phones[0]['udid'])
PY
)"
fi
# Separate output paths per invocation; never overwrite an earlier result bundle.
LIFE_RESULT_PATH="artifacts/ios/LC02-$(date -u +%Y%m%dT%H%M%SZ).xcresult"
xcodebuild -project LifeCrossroads.xcodeproj -scheme LifeCrossroads \
  -destination "platform=iOS Simulator,id=$LIFE_TEST_DEVICE" \
  -derivedDataPath .build/ios-app -resultBundlePath "$LIFE_RESULT_PATH" \
  CODE_SIGNING_ALLOWED=NO test
