#!/bin/bash
# Scoped rerun of the confirmation-dialog test after fixing its duplicate accessibility match.
set -euo pipefail
cd "$(dirname "$0")/../../.."
LC04_TEST_DEVICE=""
cleanup() {
  LC04_EXIT_STATUS=$?
  trap - EXIT
  if [ -n "$LC04_TEST_DEVICE" ]; then
    xcrun simctl shutdown "$LC04_TEST_DEVICE" >/dev/null 2>&1 || true
    if xcrun simctl delete "$LC04_TEST_DEVICE"; then
      echo "Deleted test Simulator: $LC04_TEST_DEVICE"
    else
      echo "Could not delete test Simulator: $LC04_TEST_DEVICE" >&2
      LC04_EXIT_STATUS=1
    fi
  fi
  exit "$LC04_EXIT_STATUS"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
LC04_TEST_DEVICE="$(xcrun simctl create "LifeCrossroads LC04 retest $(date -u +%Y%m%dT%H%M%SZ)" com.apple.CoreSimulator.SimDeviceType.iPhone-SE-3rd-generation com.apple.CoreSimulator.SimRuntime.iOS-27-0)"
echo "Created test Simulator: $LC04_TEST_DEVICE"
xcodebuild -project LifeCrossroads.xcodeproj -scheme LifeCrossroads \
  -destination "platform=iOS Simulator,id=$LC04_TEST_DEVICE" -parallel-testing-enabled NO \
  -derivedDataPath .build/ios-app -resultBundlePath "artifacts/ios/LC04-retest-$(date -u +%Y%m%dT%H%M%SZ).xcresult" \
  -only-testing:LifeCrossroadsUITests/LifeCrossroadsUITests/testCompleteLifeWithVisibleComparisonAndExecutedExplanation \
  CODE_SIGNING_ALLOWED=NO test
