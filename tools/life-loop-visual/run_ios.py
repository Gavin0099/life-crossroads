#!/usr/bin/env python3
"""Build only the standalone Visual fixture; no Gameplay DTO or Domain dependency.

Never changes the app project, Gameplay worktree or production sources. Every Simulator
is dedicated and deleted in finally, including build/test failures.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import signal
import subprocess
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[2]


def run(*command, **kwargs):
    return subprocess.run(command, check=True, text=True, **kwargs)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--device', choices=['standard', 'narrow'], default='standard')
    parser.add_argument('--only-testing', default='LifeCrossroadsUITests/VisualFixtureUITests')
    args = parser.parse_args()
    def interrupted(signum, _frame):
        raise SystemExit(128 + signum)
    signal.signal(signal.SIGTERM, interrupted)
    stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    work = ROOT / '.build/life-loop-visual-ios' / f'{args.device}-{stamp}'
    evidence = ROOT / 'artifacts/evidence/life-loop-visual/ios' / f'{args.device}-{stamp}'
    work.mkdir(parents=True)
    evidence.mkdir(parents=True)
    project = work / 'VisualFixture.xcodeproj'
    project.mkdir()
    pbx = (ROOT / 'LifeCrossroads.xcodeproj/project.pbxproj').read_text()
    pbx = pbx.replace('name = App; path = LifeCrossroads/App;', f'name = App; path = "{ROOT}/LifeCrossroads/App";')
    pbx = pbx.replace('path = UITests;', f'path = "{ROOT}/tools/life-loop-visual";')
    pbx = pbx.replace('packageReferences = (A00000000000000000000030);', 'packageReferences = ();')
    pbx = re.sub(r'packageProductDependencies = \([^;]+\);', 'packageProductDependencies = ();', pbx)
    pbx = re.sub(r'(A00000000000000000000021 = \{isa = PBXFrameworksBuildPhase;[^;]+; files = )\([^;]+\)', r'\1()', pbx)
    pbx = pbx.replace('path = LifeCrossroadsApp.swift; sourceTree = "<group>";',
        f'path = "{ROOT}/tools/life-loop-visual/PreviewApp.swift"; sourceTree = "<absolute>";')
    pbx = pbx.replace('path = CrossroadsView.swift;', 'path = LifeWorldScenePreview.swift;')
    pbx = pbx.replace('path = LifeCrossroadsUITests.swift;', 'path = VisualFixtureUITests.swift;')
    # App source phase contains only the isolated entry and new component.
    pbx = re.sub(r'(A00000000000000000000020 = \{isa = PBXSourcesBuildPhase;[^;]+; files = )\([^;]+\)',
        r'\1(A00000000000000000000060, A00000000000000000000062)', pbx)
    pbx = pbx.replace('com.gavin0099.LifeCrossroads', 'com.gavin0099.VisualFixture')
    pbx = pbx.replace('SWIFT_OPTIMIZATION_LEVEL = "-Onone";',
        'SWIFT_OPTIMIZATION_LEVEL = "-Onone"; SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;')
    (project / 'project.pbxproj').write_text(pbx)
    scheme_dir = project / 'xcshareddata/xcschemes'
    scheme_dir.mkdir(parents=True)
    source_scheme = ROOT / 'LifeCrossroads.xcodeproj/xcshareddata/xcschemes/LifeCrossroads.xcscheme'
    scheme = source_scheme.read_text().replace('LifeCrossroads.xcodeproj', 'VisualFixture.xcodeproj')
    (scheme_dir / 'LifeCrossroads.xcscheme').write_text(scheme)
    source_paths = [Path(__file__), ROOT / 'LifeCrossroads/App/LifeWorldScenePreview.swift',
        ROOT / 'tools/life-loop-visual/PreviewApp.swift', ROOT / 'tools/life-loop-visual/VisualFixtureUITests.swift']
    for name in ['StoryCast', 'RiverCrossroads']:
        source_paths += list((ROOT / f'LifeCrossroads/App/Assets.xcassets/{name}.imageset').glob('*'))
    binding = {'head_before_run': run('git', '-C', str(ROOT), 'rev-parse', 'HEAD', capture_output=True).stdout.strip(),
        'sources': [{'path': str(p.relative_to(ROOT)), 'sha256': sha(p)} for p in source_paths],
        'scope': 'Standalone Visual fixture; no Domain, no formal DTO, no integrated gameplay regression'}
    (evidence / 'source-binding.json').write_text(json.dumps(binding, indent=2) + '\n')
    inventory = json.loads(run('xcrun', 'simctl', 'list', 'runtimes', '-j', capture_output=True).stdout)
    runtime = next(r['identifier'] for r in inventory['runtimes'] if r['isAvailable'] and r['name'].startswith('iOS'))
    device_type = 'com.apple.CoreSimulator.SimDeviceType.' + ('iPhone-17' if args.device == 'standard' else 'iPhone-SE-3rd-generation')
    device = run('xcrun', 'simctl', 'create', f'VisualFixture-{args.device}-{stamp}', device_type, runtime, capture_output=True).stdout.strip()
    receipt = {'device_type': device_type, 'runtime': runtime, 'device_id': device, 'deleted': False}
    exit_code = 1
    try:
        with (work / 'xcodebuild.log').open('w') as log:
            command = ['xcodebuild', '-project', str(project), '-scheme', 'LifeCrossroads',
                '-destination', f'platform=iOS Simulator,id={device}', '-derivedDataPath', str(work / 'DerivedData'),
                '-resultBundlePath', str(work / 'result.xcresult'), '-parallel-testing-enabled', 'NO',
                '-only-testing:' + args.only_testing, 'CODE_SIGNING_ALLOWED=NO', 'test']
            process = subprocess.Popen(command, stdout=log, stderr=subprocess.STDOUT, text=True)
            try:
                exit_code = process.wait()
            except BaseException:
                process.terminate()
                try:
                    process.wait(timeout=20)
                except subprocess.TimeoutExpired:
                    process.kill()
                    process.wait()
                raise
        receipt['test_exit_code'] = exit_code
        receipt['xcresult_local'] = str(work / 'result.xcresult')
        print((work / 'xcodebuild.log').read_text()[-7000:], flush=True)
        if (work / 'result.xcresult').exists():
            run('xcrun', 'xcresulttool', 'export', 'attachments', '--path', str(work / 'result.xcresult'),
                '--output-path', str(evidence / 'screenshots'))
            with (evidence / 'test-summary.json').open('w') as summary:
                run('xcrun', 'xcresulttool', 'get', 'test-results', 'summary', '--path', str(work / 'result.xcresult'), stdout=summary)
    finally:
        subprocess.run(['xcrun', 'simctl', 'shutdown', device], capture_output=True)
        cleanup = subprocess.run(['xcrun', 'simctl', 'delete', device], capture_output=True, text=True)
        inventory_after = json.loads(run('xcrun', 'simctl', 'list', 'devices', '-j', capture_output=True).stdout)
        receipt['absent_from_inventory'] = all(d['udid'] != device for group in inventory_after['devices'].values() for d in group)
        receipt['deleted'] = cleanup.returncode == 0 and receipt['absent_from_inventory']
        (evidence / 'simulator-cleanup.json').write_text(json.dumps(receipt, indent=2) + '\n')
        print(json.dumps(receipt), flush=True)
        if not receipt['deleted']:
            raise RuntimeError('Owned Simulator deletion failed: ' + cleanup.stderr)
    if exit_code:
        raise SystemExit(exit_code)


if __name__ == '__main__':
    main()
