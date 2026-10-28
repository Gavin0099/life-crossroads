"""Verify native capture correspondence, source hashes and task-owned Simulator cleanup."""
import hashlib, json, re, subprocess, sys
from pathlib import Path
root = Path('artifacts/evidence/visual-loop-02')
label = sys.argv[1] if len(sys.argv) > 1 else 'round2'
source_ref = sys.argv[2] if len(sys.argv) > 2 else None
fixtures = [f['name'] for f in json.loads((root/'fixtures/manifest.json').read_text())['fixtures']]
core = ['13-online','13-paper','17-remote','17-collective','25-remote','25-collective','32-prepared','32-participating']
expected = {(f, v) for v in ['normal','large','reduced'] for f in (fixtures if v=='normal' else core)}
rows = []
for hardware in ['iPhone-SE-3rd-generation','iPhone-17']:
    before = root/'baseline'/hardware; after = root/label/hardware
    def checksums(directory):
        return {(f,v):h for f,v,h in re.findall(r'VISUAL_CAPTURE (\S+) (\S+) archive=([0-9a-f]{64})', (directory/'test.log').read_text())}
    b, a = checksums(before), checksums(after)
    assert set(a)==expected, (hardware,'capture coverage',set(a)^expected)
    controls = set(re.findall(r'VISUAL_CONTROL (\S+) (\S+) \S+ hittable=true', (after/'test.log').read_text()))
    assert controls==expected, (hardware,'reachable controls',expected-controls)
    for fixture, variant in expected:
        assert a[fixture,variant] == b[fixture,'normal'], (hardware,fixture,variant,'archive changed')
    source=json.loads((after/'source.json').read_text())
    for file, sha in source['sourceHashes'].items():
        content = subprocess.check_output(['git', 'show', f'{source_ref}:{file}']) if source_ref else Path(file).read_bytes()
        assert hashlib.sha256(content).hexdigest()==sha, ('captured source changed',file)
    for directory in [before,after]:
        images=json.loads((directory/'screenshots.json').read_text())['images']
        for image in images:
            assert hashlib.sha256((directory/image['file']).read_bytes()).hexdigest()==image['sha256']
    rows.append({'hardware':hardware, 'captures':len(a), 'archiveEquality':True, 'controlsReachable':len(controls),
                 'capturedSourceMatches':source_ref or 'working-tree', 'source':str(after/'source.json'),
                 'nativeImages':str(after/'screenshots.json')})
unchanged=['LifeCrossroads/Domain','LifeCrossroads/Data','LifeCrossroads/Persistence','UITests/LifeCrossroadsUITests.swift','.github/workflows/governance-drift.yml']
assert not subprocess.check_output(['git','diff','81371e0',*([source_ref] if source_ref else []),'--',*unchanged],text=True).strip(), 'Protected product surfaces changed'
logs=list(Path('artifacts/governance/visual-loop-02').glob('*.log'))
owned=set(); deleted=set()
for p in logs:
    text=p.read_text(errors='replace')
    owned.update(re.findall(r'Created visual Simulator: ([0-9A-F-]{36})',text))
    deleted.update(re.findall(r'Deleted visual Simulator: ([0-9A-F-]{36})',text))
assert owned<=deleted, ('missing deletion receipt', owned-deleted)
inventory=json.loads(subprocess.check_output(['xcrun','simctl','list','devices','-j'],text=True))
remaining={d['udid'] for devices in inventory['devices'].values() for d in devices}
assert not owned & remaining, ('owned devices still exist', owned & remaining)
report={'status':'PASS','scope':'Native capture/source/archive checks; not full UI suite, human playtest or formal art acceptance',
        'base':'81371e0aa257233fadd0355faf36ba8e0edcdc64','label':label,'matrix':rows,
        'unchangedPaths':unchanged,'deletedOwnedSimulators':sorted(owned),
        'excludedFailures':['baseline create with unsupported runtime','baseline harness initially executed zero tests','baseline archive exceeded launch argument limit','round3 shell changed during execution; retried with frozen script']}
(root/'verification.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(report,ensure_ascii=False,indent=2))
