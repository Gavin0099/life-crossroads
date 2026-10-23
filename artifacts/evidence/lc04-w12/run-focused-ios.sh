#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../../.."
mkdir -p artifacts/ios
LC04_W12_DEVICE=""
cleanup() {
  LC04_W12_STATUS=$?
  trap - EXIT
  if [ -n "$LC04_W12_DEVICE" ]; then
    xcrun simctl shutdown "$LC04_W12_DEVICE" >/dev/null 2>&1 || true
    if xcrun simctl delete "$LC04_W12_DEVICE"; then
      echo "Deleted test Simulator: $LC04_W12_DEVICE"
    else
      echo "Could not delete test Simulator: $LC04_W12_DEVICE" >&2
      LC04_W12_STATUS=1
    fi
  fi
  exit "$LC04_W12_STATUS"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
LC04_W12_DEVICE="$(xcrun simctl create "LifeCrossroads W1 W2 $(date -u +%Y%m%dT%H%M%SZ)" com.apple.CoreSimulator.SimDeviceType.iPhone-SE-3rd-generation com.apple.CoreSimulator.SimRuntime.iOS-27-0)"
echo "Created test Simulator: $LC04_W12_DEVICE"
xcodebuild -project LifeCrossroads.xcodeproj -scheme LifeCrossroads \
  -destination "platform=iOS Simulator,id=$LC04_W12_DEVICE" -parallel-testing-enabled NO \
  -derivedDataPath .build/ios-app -resultBundlePath "artifacts/ios/LC04-W12-$(date -u +%Y%m%dT%H%M%SZ).xcresult" \
  -only-testing:LifeCrossroadsUITests/LifeCrossroadsUITests/testForkPreservesOriginalResumesAfterRelaunchAndComparesFullRemainder \
  -only-testing:LifeCrossroadsUITests/LifeCrossroadsUITests/testSaveFailuresKeepScreenAndArchiveThenRetryAndRelaunch \
  CODE_SIGNING_ALLOWED=NO test
