"""Verify native results, paired save bytes, final source binding and owned-device cleanup."""
from pathlib import Path
import hashlib
import json
import re
import subprocess

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'artifacts/evidence/reigns-card'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

fixture = ROOT / 'artifacts/evidence/interaction-memory-loop/interaction-fixtures/13-before.json'
initial = sha(fixture)
rows = []
paired = {}
for folder in ['round2/iPhone-SE-3rd-generation', 'final/iPhone-17']:
    path = OUT / folder
    text = (path / 'light/test.log').read_text()
    matches = re.findall(r'RC_SAVED ui=(\w+) choice=(\w+) before=(\w{64}) after=(\w{64})', text)
    values = {(ui, choice): after for ui, choice, before, after in matches if before == initial}
    assert len(matches) == 8 and len(values) == 8
    for choice in ['offline', 'invest', 'ask', 'rest']:
        assert values['original', choice] == values['card', choice]
    assert len({values['card', c] for c in ['offline', 'invest', 'ask', 'rest']}) == 4
    paired[folder] = {c: values['card', c] for c in ['offline', 'invest', 'ask', 'rest']}
    for mode, count in [('light', 4), ('accessible', 1)]:
        summary = json.loads((path / mode / 'result.runtime-summary.json').read_text())
        assert summary['passedTests'] == count and summary['failedTests'] == summary['skippedTests'] == 0
        assert not summary['runtimeWarnings']
        rows.append({'path': f'{folder}/{mode}', 'passed': count, 'publicationWarnings': 0})
assert len(set(json.dumps(v, sort_keys=True) for v in paired.values())) == 1

for hardware in ['iPhone-SE-3rd-generation', 'iPhone-17']:
    path = OUT / 'details-corrected' / hardware
    source = json.loads((path / 'source.json').read_text())
    assert all(sha(ROOT / p) == value for p, value in source['sha256'].items()), 'Final product/test sources drifted'
    for mode in ['light', 'accessible']:
        summary = json.loads((path / mode / 'result.runtime-summary.json').read_text())
        assert summary['passedTests'] == 1 and summary['failedTests'] == summary['skippedTests'] == 0
        assert not summary['runtimeWarnings']
        rows.append({'path': f'details-corrected/{hardware}/{mode}', 'passed': 1, 'publicationWarnings': 0})

screens = []
for manifest in sorted(OUT.rglob('screenshots.json')):
    names = set()
    for item in json.loads(manifest.read_text()):
        assert item['path'] not in names, 'Duplicate screenshot output name'
        names.add(item['path'])
        p = manifest.parent / item['path']; assert sha(p) == item['sha256']
        screens.append({'path': str(p.relative_to(OUT)), 'sha256': item['sha256']})

inventory = json.loads(subprocess.check_output(['xcrun', 'simctl', 'list', 'devices', '-j']))
present = {d['udid'] for devices in inventory['devices'].values() for d in devices}
owned = [p.read_text().strip() for p in sorted(OUT.rglob('device.txt'))]
assert len(owned) == len(set(owned)) and not any(d in present for d in owned)
protected = json.loads((OUT / 'protected-surfaces.json').read_text())
assert all(sha(ROOT / r['path']) == r['sha256'] and r['unchanged'] for r in protected['files'])
result = {'fixture': str(fixture.relative_to(ROOT)), 'fixtureSHA256': initial,
          'pairedOutcomes': paired, 'acceptedNativeBatches': rows,
          'historicalFailure': 'round1 SE 3 PASS/1 FAIL: original UI target outside footer; preserved and corrected reveal helper',
          'historicalReviewFinding': 'details-final SE: digital preparation text incorrectly repeated for non-digital choices; corrected in both final targeted batches',
          'screenshots': screens, 'ownedSimulatorsDeleted': owned,
          'preservedOtherDevices': sorted(present), 'protectedFilesUnchanged': len(protected['files']),
          'notClaimed': ['Human playability', 'Manual VoiceOver', 'Native held-drag background interruption', 'Clean all-CI', 'RC03–06', 'Phone installation']}
(OUT / 'evidence-verification.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
print(f'PASS: {len(rows)} native batches, paired four choices across two devices, {len(screens)} PNG hashes, {len(owned)} own Simulators deleted')
