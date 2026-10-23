#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p artifacts/ios
LIFE_DEVICE_CONFIG="$(python3 - <<'PY'
import json, os, subprocess
inventory = json.loads(subprocess.check_output(['xcrun', 'simctl', 'list', 'devices', 'available', '-j']))
requested = os.environ.get('LIFE_SIMULATOR_ID')
phones = [(version, d) for version, devices in inventory['devices'].items() if 'iOS' in version
          for d in devices if d.get('isAvailable') and 'iPhone' in d.get('deviceTypeIdentifier', '')
          and (d['udid'] == requested if requested else True)]
if not phones:
    raise SystemExit('No matching available iPhone Simulator configuration')
runtime, device = phones[0]
print(device['deviceTypeIdentifier'])
print(runtime)
PY
)"
# The supplied ID selects hardware/runtime only; never use or delete someone else's device.
LIFE_DEVICE_TYPE="$(printf '%s\n' "$LIFE_DEVICE_CONFIG" | sed -n '1p')"
LIFE_DEVICE_RUNTIME="$(printf '%s\n' "$LIFE_DEVICE_CONFIG" | sed -n '2p')"
LIFE_TEST_DEVICE=""
cleanup() {
  LIFE_EXIT_STATUS=$?
  trap - EXIT
  if [ -n "$LIFE_TEST_DEVICE" ]; then
    xcrun simctl shutdown "$LIFE_TEST_DEVICE" >/dev/null 2>&1 || true
    if xcrun simctl delete "$LIFE_TEST_DEVICE"; then
      echo "Deleted test Simulator: $LIFE_TEST_DEVICE"
    else
      echo "Could not delete test Simulator: $LIFE_TEST_DEVICE" >&2
      [ "$LIFE_EXIT_STATUS" -ne 0 ] || LIFE_EXIT_STATUS=1
    fi
  fi
  exit "$LIFE_EXIT_STATUS"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
LIFE_TEST_DEVICE="$(xcrun simctl create "LifeCrossroads Test $(date -u +%Y%m%dT%H%M%SZ)" "$LIFE_DEVICE_TYPE" "$LIFE_DEVICE_RUNTIME")"
echo "Created test Simulator: $LIFE_TEST_DEVICE"
# Separate output paths per invocation; never overwrite an earlier result bundle.
LIFE_RESULT_PATH="artifacts/ios/LC02-$(date -u +%Y%m%dT%H%M%SZ).xcresult"
xcodebuild -project LifeCrossroads.xcodeproj -scheme LifeCrossroads \
  -destination "platform=iOS Simulator,id=$LIFE_TEST_DEVICE" \
  -parallel-testing-enabled NO \
  -derivedDataPath .build/ios-app -resultBundlePath "$LIFE_RESULT_PATH" \
  CODE_SIGNING_ALLOWED=NO test
