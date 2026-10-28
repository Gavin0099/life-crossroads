#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../.."
label="${1:?baseline or round label}"; hardware="${2:?iPhone-17 or iPhone-SE-3rd-generation}"; variants="${3:-normal}"; filter="${4:-}"; testname="${5:-testReplayValidatedNativeScenes}"
if [ "$testname" = all ]; then testname=""; fi
out="artifacts/evidence/interaction-memory-loop/$label/$hardware"
if [ -f "$out/source.json" ]; then
  echo "Capture evidence already exists at $out; choose a new label." >&2
  exit 2
fi
mkdir -p "$out"
device=""
cleanup() {
  status=$?; trap - EXIT
  if [ -n "$device" ]; then
    xcrun simctl shutdown "$device" >/dev/null 2>&1 || true
    if xcrun simctl delete "$device"; then echo "Deleted visual Simulator: $device"; else status=1; fi
  fi
  exit "$status"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
runtime=$(xcrun simctl list runtimes -j | python3 -c 'import sys,json; print([r["identifier"] for r in json.load(sys.stdin)["runtimes"] if r["isAvailable"] and any(d["identifier"] == "com.apple.CoreSimulator.SimDeviceType."+sys.argv[1] for d in r.get("supportedDeviceTypes",[]))][-1])' "$hardware")
device=$(xcrun simctl create "IM-$label-$hardware" "com.apple.CoreSimulator.SimDeviceType.$hardware" "$runtime")
echo "Created visual Simulator: $device runtime=$runtime"
xcrun simctl boot "$device"
xcrun simctl bootstatus "$device" -b
python3 tools/interaction-memory-loop/capture-metadata.py "$out" "$device" "$runtime" "$variants" "$filter"
xcodebuild -project LifeCrossroads.xcodeproj -scheme LifeCrossroads -destination "platform=iOS Simulator,id=$device" \
  -derivedDataPath .build/interaction-memory-loop/native CODE_SIGNING_ALLOWED=NO \
  SWIFT_ACTIVE_COMPILATION_CONDITIONS='DEBUG VISUAL_LOOP_CAPTURE' build-for-testing > "$out/build.log" 2>&1
python3 - "$variants" "$filter" <<'PY'
import sys,plistlib
from pathlib import Path
files=list(Path('.build/interaction-memory-loop/native/Build/Products').glob('*.xctestrun')); assert len(files)==1,files
p=files[0];d=plistlib.loads(p.read_bytes())
targets=[t for c in d.get('TestConfigurations',[]) for t in c['TestTargets']] if 'TestConfigurations' in d else [v for k,v in d.items() if k!='__xctestrun_metadata__']
for t in targets:
 for key in ['EnvironmentVariables','TestingEnvironmentVariables']:
  env=t.setdefault(key,{});env['LIFE_CAPTURE_VARIANTS']=sys.argv[1]
  if sys.argv[2]: env['LIFE_CAPTURE_FILTER']=sys.argv[2]
p.write_bytes(plistlib.dumps(d))
PY
runfile=$(find .build/interaction-memory-loop/native/Build/Products -maxdepth 1 -name '*.xctestrun' -print)
result="artifacts/ios/IM-$label-$hardware-$(date -u +%Y%m%dT%H%M%SZ).xcresult"
xcodebuild test-without-building -xctestrun "$runfile" -destination "platform=iOS Simulator,id=$device" \
  -parallel-testing-enabled NO -collect-test-diagnostics never -resultBundlePath "$result" \
  -only-testing:"LifeCrossroadsUITests/InteractionCaptureTests${testname:+/$testname}" > "$out/test.log" 2>&1
python3 scripts/check-ios-runtime.py "$result"
python3 tools/interaction-memory-loop/export-captures.py "$result" "$out"
cp "${result%.xcresult}.runtime-summary.json" "$out/runtime-summary.json"
python3 tools/interaction-memory-loop/compact-logs.py "$out"
