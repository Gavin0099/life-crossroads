#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../.."
hardware="${1:?device type}"; modes="${2:-light accessible}"
out="${RC_EVIDENCE_ROOT:-artifacts/evidence/reigns-card}/${3:-round1}/$hardware"
derived="${RC_DERIVED_DATA:-.build/reigns-card}"
mkdir -p "$out"
device=''; watcher=''
cleanup() { status=$?; trap - EXIT; if [ -n "$watcher" ]; then kill "$watcher" >/dev/null 2>&1 || true; fi; if [ -n "$device" ]; then xcrun simctl shutdown "$device" >/dev/null 2>&1 || true; xcrun simctl delete "$device" || status=1; echo "Deleted Reigns card Simulator: $device"; fi; exit "$status"; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
runtime="${RC_RUNTIME:-}"
if [ -z "$runtime" ]; then
 runtime=$(xcrun simctl list runtimes -j | python3 -c 'import sys,json;print([r["identifier"] for r in json.load(sys.stdin)["runtimes"] if r["isAvailable"] and any(d["identifier"]=="com.apple.CoreSimulator.SimDeviceType."+sys.argv[1] for d in r.get("supportedDeviceTypes",[]))][-1])' "$hardware")
fi
device=$(xcrun simctl create "ReignsCard-$hardware" "com.apple.CoreSimulator.SimDeviceType.$hardware" "$runtime")
echo "$device" > "$out/device.txt"
xcrun simctl boot "$device"
xcrun simctl bootstatus "$device" -b
python3 - "$out" "$runtime" <<'PY'
import sys,json,hashlib,subprocess
from pathlib import Path
files=sorted(Path('LifeCrossroads/App').rglob('*.swift'))+sorted(Path('LifeCrossroads/App/Assets.xcassets').rglob('*.json'))+sorted(Path('LifeCrossroads/Presentation').rglob('*.swift'))+[Path('UITests/ReignsCardTests.swift')]
Path(sys.argv[1],'source.json').write_text(json.dumps({'base':subprocess.check_output(['git','rev-parse','HEAD'],text=True).strip(),'runtime':sys.argv[2],'sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}},indent=2)+'\n')
PY
xcodebuild -project LifeCrossroads.xcodeproj -scheme LifeCrossroads -destination "platform=iOS Simulator,id=$device" -derivedDataPath "$derived" CODE_SIGNING_ALLOWED=NO SWIFT_ACTIVE_COMPILATION_CONDITIONS='DEBUG VISUAL_LOOP_CAPTURE' build-for-testing > "$out/build.log" 2>&1
for mode in $modes; do
 mkdir -p "$out/$mode"
 appearance=light; high=disabled; size=large
 [[ "$mode" == light ]] || appearance=dark
 [[ "$mode" != accessible ]] || high=enabled
 [[ "$mode" != accessible ]] || size=accessibility-extra-extra-extra-large
 xcrun simctl ui "$device" appearance "$appearance"
 xcrun simctl ui "$device" increase_contrast "$high"
 xcrun simctl ui "$device" content_size "$size"
 { xcrun simctl ui "$device" appearance; xcrun simctl ui "$device" increase_contrast; xcrun simctl ui "$device" content_size; } > "$out/$mode/settings.txt"
 python3 - "$mode" "$derived" <<'PY'
import sys,plistlib
from pathlib import Path
files=list(Path(sys.argv[2], 'Build/Products').glob('*.xctestrun'));assert len(files)==1
p=files[0]; d=plistlib.loads(p.read_bytes())
targets=[t for c in d.get('TestConfigurations',[]) for t in c['TestTargets']] if 'TestConfigurations' in d else [v for k,v in d.items() if k!='__xctestrun_metadata__']
for t in targets:
 for key in ['EnvironmentVariables','TestingEnvironmentVariables']:
  t.setdefault(key,{})['RC_VARIANT']=sys.argv[1]
p.write_bytes(plistlib.dumps(d))
PY
 runfile=$(find "$derived/Build/Products" -maxdepth 1 -name '*.xctestrun' -print)
 test_args=(-only-testing:LifeCrossroadsUITests/ReignsCardTests)
 [[ "$mode" != accessible ]] || test_args=(-only-testing:LifeCrossroadsUITests/ReignsCardTests/testFirstScreenAndAllButtonAlternativesAccessible)
 if [ -n "${RC_ONLY_TEST:-}" ]; then test_args=("-only-testing:LifeCrossroadsUITests/ReignsCardTests/$RC_ONLY_TEST"); fi
 result="$out/$mode/result.xcresult"
 test_status=0
 if [ "${RC_CAPTURE_DRAG:-0}" == 1 ] && [ "$mode" == light ]; then
  python3 tools/reigns-card/capture-drag.py "$device" "$out/$mode" & watcher=$!
 fi
 xcodebuild test-without-building -xctestrun "$runfile" -destination "platform=iOS Simulator,id=$device" -parallel-testing-enabled NO -collect-test-diagnostics never -resultBundlePath "$result" "${test_args[@]}" > "$out/$mode/test.log" 2>&1 || test_status=$?
 if [ -n "$watcher" ]; then kill "$watcher" >/dev/null 2>&1 || true; wait "$watcher" 2>/dev/null || true; watcher=""; fi
 python3 scripts/check-ios-runtime.py "$result" || test_status=1
 python3 tools/reigns-card/export.py "$result" "$out/$mode"
 if [ "$test_status" -ne 0 ]; then exit "$test_status"; fi
done
