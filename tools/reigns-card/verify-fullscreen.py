"""Audit RC-FULLSCREEN-01 evidence; visual judgment remains a separate native-image review."""
from pathlib import Path
import hashlib
import json
import re
import subprocess

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'artifacts/evidence/reigns-fullscreen'
BASE = '225c2828f4ea56c8ae5eb89a414ac506808b6374'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

fixture = ROOT / 'artifacts/evidence/interaction-memory-loop/interaction-fixtures/13-before.json'
initial = sha(fixture)
paired, batches, bounds = {}, [], []
for hardware in ['iPhone-SE-3rd-generation', 'iPhone-17']:
    folder = OUT / 'final' / hardware
    source = json.loads((folder / 'source.json').read_text())
    assert source['base'] == BASE
    assert all(sha(ROOT / p) == h for p, h in source['sha256'].items()), 'Tested sources drifted'
    log = (folder / 'light/test.log').read_text()
    matches = re.findall(r'RC_SAVED ui=(\w+) choice=(\w+) before=(\w{64}) after=(\w{64})', log)
    values = {(ui, choice): after for ui, choice, before, after in matches if before == initial}
    assert len(matches) == len(values) == 8
    for choice in ['offline', 'invest', 'ask', 'rest']:
        assert values['original', choice] == values['card', choice]
    paired[hardware] = {c: values['card', c] for c in ['offline', 'invest', 'ask', 'rest']}
    assert len(set(paired[hardware].values())) == 4
    for mode, count in [('light', 7), ('accessible', 1)]:
        summary = json.loads((folder / mode / 'result.runtime-summary.json').read_text())
        assert summary['passedTests'] == count and summary['failedTests'] == summary['skippedTests'] == 0
        assert not summary['runtimeWarnings']
        batches.append({'hardware': hardware, 'mode': mode, 'passed': count, 'publicationWarnings': 0})
    for line in log.splitlines():
        if 'RC_LAYOUT ' not in line:
            continue
        rects = {k: [float(v) for v in coords.split(', ')] for k, coords in re.findall(r'(\w+)=\(([^)]+)\)', line)}
        ratio = rects['card'][3] / rects['screen'][3]
        assert ratio >= .65, 'Conservative full-screen ratio must also meet Owner minimum'
        assert rects['prompt'][3] <= 58
        bounds.append({'hardware': hardware, 'outcome': 'outcome=true' in line, 'rects': rects,
                       'cardToFullScreenHeight': ratio})
    assert any(r['hardware'] == hardware and r['outcome'] for r in bounds)
    assert any(r['hardware'] == hardware and not r['outcome'] for r in bounds)
assert len(set(json.dumps(v, sort_keys=True) for v in paired.values())) == 1

screens = []
for manifest in sorted(OUT.rglob('screenshots.json')):
    names = set()
    for row in json.loads(manifest.read_text()):
        assert row['path'] not in names
        names.add(row['path'])
        image = manifest.parent / row['path']
        assert sha(image) == row['sha256']
        screens.append({'path': str(image.relative_to(OUT)), 'sha256': row['sha256']})
held = []
for path in sorted(OUT.rglob('held-preview.json')):
    value = json.loads(path.read_text())
    for row in value:
        assert sha(path.parent / row['path']) == row['sha256']
    held.append({'path': str(path.relative_to(OUT)), 'evidence': value})

inventory = json.loads(subprocess.check_output(['xcrun', 'simctl', 'list', 'devices', '-j']))
present = {d['udid'] for group in inventory['devices'].values() for d in group}
owned = [p.read_text().strip() for p in sorted(OUT.rglob('device.txt'))]
assert len(owned) == len(set(owned)) and not any(d in present for d in owned)
protected = ['LifeCrossroads/Domain', 'LifeCrossroads/Data', 'LifeCrossroads/Persistence',
             'LifeCrossroads/Resources', 'LifeCrossroads/Presentation', 'LifeCrossroads/App/GameStore.swift',
             'LifeCrossroads/App/Assets.xcassets', 'Tests', 'LifeCrossroads.xcodeproj']
changed = subprocess.check_output(['git', 'diff', '--name-only', BASE, '--', *protected], cwd=ROOT, text=True)
assert not changed, 'Protected surfaces changed: ' + changed
result = {'baseline': BASE, 'fixture': str(fixture.relative_to(ROOT)), 'fixtureSHA256': initial,
          'pairedOutcomes': paired, 'acceptedNativeBatches': batches, 'nativeBounds': bounds,
          'screenshots': screens, 'heldPreviews': held, 'protectedUnchanged': protected,
          'ownedSimulatorsDeleted': owned, 'preservedOtherDevices': sorted(present),
          'historicalFailures': [
              'layout1: build passed; capture runner found two xctestrun outputs before UI launch; own device deleted',
              'layout2: duplicate background/sheet action ID selected hidden button; scoped query fixed',
              'round1: paper desk obscured teacher face; native blind critic FAIL; composition corrected',
              'round1/round2: accessibility stage fixed height truncated prompt; natural text layout corrected'],
          'notClaimed': ['Owner visual acceptance', 'Human playability', 'Manual VoiceOver',
                         'Native held-drag background interruption', 'Clean all-CI', 'RC03–06', 'Phone installation']}
(OUT / 'evidence-verification.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
print(f'PASS: {len(batches)} final native batches, two-device paired saves, {len(screens)} native PNG hashes, {len(owned)} owned Simulators deleted')
