#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../.."
hardware="${1:?device type}"; modes="${2:-light dark dark-high-large}"
out="artifacts/evidence/readability/${3:-after}/$hardware"
mkdir -p "$out"
device=''
cleanup() { status=$?; trap - EXIT; if [ -n "$device" ]; then xcrun simctl shutdown "$device" >/dev/null 2>&1 || true; xcrun simctl delete "$device" || status=1; echo "Deleted readability Simulator: $device"; fi; exit "$status"; }
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
runtime=$(xcrun simctl list runtimes -j | python3 -c 'import sys,json;print([r["identifier"] for r in json.load(sys.stdin)["runtimes"] if r["isAvailable"] and any(d["identifier"]=="com.apple.CoreSimulator.SimDeviceType."+sys.argv[1] for d in r.get("supportedDeviceTypes",[]))][-1])' "$hardware")
device=$(xcrun simctl create "Readability-$hardware" "com.apple.CoreSimulator.SimDeviceType.$hardware" "$runtime")
echo "$device" > "$out/device.txt"
xcrun simctl boot "$device"
xcrun simctl bootstatus "$device" -b
python3 - "$out" "$runtime" <<'PY'
import sys,json,hashlib,subprocess
from pathlib import Path
files=sorted(Path('LifeCrossroads/App').rglob('*.swift'))+sorted(Path('LifeCrossroads/App/Assets.xcassets').rglob('*.json'))+[Path('UITests/FinalPolishCaptureTests.swift')]
Path(sys.argv[1],'source.json').write_text(json.dumps({'base':subprocess.check_output(['git','rev-parse','HEAD'],text=True).strip(),'runtime':sys.argv[2],'sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}},indent=2)+'\n')
PY
xcodebuild -project LifeCrossroads.xcodeproj -scheme LifeCrossroads -destination "platform=iOS Simulator,id=$device" -derivedDataPath .build/readability CODE_SIGNING_ALLOWED=NO SWIFT_ACTIVE_COMPILATION_CONDITIONS='DEBUG VISUAL_LOOP_CAPTURE' build-for-testing > "$out/build.log" 2>&1
for mode in $modes; do
 mkdir -p "$out/$mode"
 appearance=light; high=disabled; size=large
 [[ "$mode" != dark* ]] || appearance=dark
 [[ "$mode" != *high* ]] || high=enabled
 [[ "$mode" != *large* ]] || size=accessibility-extra-extra-extra-large
 xcrun simctl ui "$device" appearance "$appearance"
 xcrun simctl ui "$device" increase_contrast "$high"
 xcrun simctl ui "$device" content_size "$size"
 { xcrun simctl ui "$device" appearance; xcrun simctl ui "$device" increase_contrast; xcrun simctl ui "$device" content_size; } > "$out/$mode/settings.txt"
 python3 - "$mode" <<'PY'
import sys,plistlib
from pathlib import Path
files=list(Path('.build/readability/Build/Products').glob('*.xctestrun'));assert len(files)==1
p=files[0]; d=plistlib.loads(p.read_bytes())
targets=[t for c in d.get('TestConfigurations',[]) for t in c['TestTargets']] if 'TestConfigurations' in d else [v for k,v in d.items() if k!='__xctestrun_metadata__']
for t in targets:
 for key in ['EnvironmentVariables','TestingEnvironmentVariables']:
  t.setdefault(key,{})['READABILITY_VARIANT']=sys.argv[1]
p.write_bytes(plistlib.dumps(d))
PY
 runfile=$(find .build/readability/Build/Products -maxdepth 1 -name '*.xctestrun' -print)
 result="$out/$mode/result.xcresult"
 xcodebuild test-without-building -xctestrun "$runfile" -destination "platform=iOS Simulator,id=$device" -parallel-testing-enabled NO -collect-test-diagnostics never -resultBundlePath "$result" -only-testing:LifeCrossroadsUITests/ReadabilityCaptureTests > "$out/$mode/test.log" 2>&1
 python3 scripts/check-ios-runtime.py "$result"
 python3 tools/readability/export.py "$result" "$out/$mode"
done
