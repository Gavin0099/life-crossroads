"""Verify retained native evidence, shared-clock receipts and task-device cleanup.

This verifies provenance and invariants, not visual quality or child comprehension.
"""
import hashlib
import json
import re
import subprocess
from pathlib import Path

ROOT = Path('artifacts/evidence/final-polish-loop')
BASE = '325b69896553fb6c479e415c0c0991e76ef78a26'
FINAL_ROUND = 'round3-ax'
ARCHIVED_ROUNDS = {'round3': 'c74fadfaf6d6a063bf4e57260ba16cb1827c2118'}
devices = subprocess.check_output(['xcrun', 'simctl', 'list', 'devices', '-j'], text=True)
report = {'base': BASE, 'final_round': FINAL_ROUND, 'captures': [], 'failures': []}
requests = {}
archives = {}
for source in sorted(ROOT.glob('round*/iPhone*/source.json')):
    folder = source.parent
    identity = str(folder.relative_to(ROOT))
    data = json.loads(source.read_text())
    runtime = json.loads((folder / 'runtime-summary.json').read_text())
    screenshots = json.loads((folder / 'screenshots.json').read_text())['images']
    log = (folder / 'test.log').read_text()
    def check(condition, message):
        if not condition: report['failures'].append(identity + ': ' + message)
    check(data['device'] not in devices, 'task Simulator still present')
    check(runtime['result'] == 'Passed' and runtime['failedTests'] == 0 and runtime['skippedTests'] == 0,
          'native test result is not an unskipped pass')
    check(not runtime['runtimeWarnings'], 'runtime warning')
    for entry in screenshots:
        check(hashlib.sha256((folder / entry['file']).read_bytes()).hexdigest() == entry['sha256'],
              'image SHA mismatch: ' + entry['file'])
    if folder.parent.name == 'round1':
        for path, sha in data['sourceHashes'].items():
            if path.startswith(('LifeCrossroads/App/', 'LifeCrossroads/Presentation/',
                                'artifacts/evidence/interaction-memory-loop/interaction-fixtures/')):
                content = subprocess.check_output(['git', 'show', BASE + ':' + path])
                check(hashlib.sha256(content).hexdigest() == sha, 'baseline drift: ' + path)
    if folder.parent.name == FINAL_ROUND or folder.parent.name in ARCHIVED_ROUNDS:
        for path, sha in data['sourceHashes'].items():
            if path.startswith(('LifeCrossroads/App/', 'LifeCrossroads/Presentation/', 'UITests/',
                                'artifacts/evidence/interaction-memory-loop/interaction-fixtures/')) or path == 'LifeCrossroads.xcodeproj/project.pbxproj':
                content = (subprocess.check_output(['git', 'show', ARCHIVED_ROUNDS[folder.parent.name] + ':' + path])
                           if folder.parent.name in ARCHIVED_ROUNDS else Path(path).read_bytes())
                check(hashlib.sha256(content).hexdigest() == sha, 'capture source drift: ' + path)
    matrix = re.findall(r'VISUAL_CAPTURE (\S+) (\S+) archive=([a-f0-9]{64})', log)
    controls = re.findall(r'VISUAL_CONTROL (\S+) (\S+) \S+ hittable=true', log)
    names = set(data['filter'].split(','))
    accessible = {'13-ask', '17-remote', '17-collective', '32-ask', '32-participating', '72-ahe', '72-neighbor'}
    expected_matrix = {(name, variant) for name in names for variant in data['variants'].split(',')
                       if variant == 'normal' or name in accessible}
    check(len(matrix) == len(expected_matrix) and {(a, b) for a, b, _ in matrix} == expected_matrix,
          'missing or duplicate matrix state')
    check(len(controls) == len(expected_matrix), 'missing or duplicate control check')
    check(set((a, b) for a, b, _ in matrix) == set(controls), 'missing reachable control')
    for name, variant, sha in matrix:
        archives.setdefault(name, set()).add(sha)
    beats = re.findall(r'VISUAL_REQUEST (13|32) (\S+) archive=([a-f0-9]{64}) phaseMs=(\d+) pause=actual-clock', log)
    beat_names = ['expressing', 'transition', 'handoff', 'listening'] if folder.parent.name.startswith('round3') else ['expressing', 'handoff', 'listening']
    expected_beats = {(age, beat) for age in ['13', '32'] for beat in beat_names}
    check(len(beats) == len(expected_beats) and {(age, beat) for age, beat, _, _ in beats} == expected_beats,
          'missing or duplicate request timing sample')
    for age, beat, sha, elapsed in beats:
        target = {'expressing': 200, 'transition': 720, 'handoff': 900, 'listening': 1400}[beat]
        check(target <= int(elapsed) < target + 450, 'clock sample outside observation window')
        if beat == 'transition': check(int(elapsed) < 820, 'short transition image was already settled')
        requests.setdefault(age, set()).add(sha)
    if 'testCastSaveFailureKeepsOriginalInvitation' in log:
        check('CAST_SAVE_FAILURE oldFileAndInvitationUnchanged=true retrySaved=true' in log,
              'save-failure/retry receipt missing')
    report['captures'].append({'path': identity, 'tests': runtime['passedTests'], 'screenshots': len(screenshots),
                               'matrixStates': len(matrix), 'requestSamples': len(beats),
                               'simulator': data['device'], 'deleted': data['device'] not in devices})
for name, hashes in {**archives, **requests}.items():
    if len(hashes) != 1: report['failures'].append('presentation changed persisted archive: ' + name)
final_devices = {row['path'].split('/')[1] for row in report['captures'] if row['path'].startswith(FINAL_ROUND + '/')}
if final_devices != {'iPhone-SE-3rd-generation', 'iPhone-17'}:
    report['failures'].append('final source requires both native device captures')
report['stableArchiveHashes'] = {name: sorted(hashes) for name, hashes in archives.items()}
report['requestArchiveHashes'] = {age: sorted(hashes) for age, hashes in requests.items()}
report['result'] = 'PASS' if report['captures'] and not report['failures'] else 'FAIL'
(ROOT / 'evidence-verification.json').write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n')
print(json.dumps({k: report[k] for k in ['result', 'captures', 'failures']}, indent=2))
raise SystemExit(0 if report['result'] == 'PASS' else 1)
