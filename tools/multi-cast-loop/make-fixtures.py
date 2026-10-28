#!/usr/bin/env python3
"""Compile unchanged engine and save real, replay-validated scene witnesses."""
import hashlib
import json
import subprocess
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
b = ROOT / '.build/multi-cast-loop/fixtures'
b.mkdir(parents=True, exist_ok=True)
out = ROOT / 'artifacts/evidence/multi-cast-loop/cast-fixtures'
out.mkdir(parents=True, exist_ok=True)
sources = sorted((ROOT / 'LifeCrossroads/Domain').glob('*.swift')) + sorted((ROOT / 'LifeCrossroads/Persistence').glob('*.swift'))
sources += [ROOT / 'LifeCrossroads/Data/Resources/catalog.json', Path(__file__), Path(__file__).with_name('Fixtures.swift')]
source_hashes = {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
common = ['xcrun', 'swiftc', '-O', '-swift-version', '6', '-I', str(b), '-L', str(b)]
for name, folder in [('LifeDomain', 'Domain'), ('LifePersistence', 'Persistence')]:
    subprocess.run(common + ['-parse-as-library', '-emit-library', '-emit-module', '-module-name', name,
        '-emit-module-path', str(b / (name + '.swiftmodule')), '-o', str(b / ('lib' + name + '.dylib'))]
        + ([] if folder == 'Domain' else ['-lLifeDomain'])
        + [str(p) for p in sorted((ROOT / 'LifeCrossroads' / folder).glob('*.swift'))], check=True)
subprocess.run(common + ['-parse-as-library', '-lLifeDomain', '-lLifePersistence', '-Xlinker', '-rpath', '-Xlinker', str(b), '-o', str(b / 'fixtures'), str(Path(__file__).with_name('Fixtures.swift'))], check=True)
subprocess.run([str(b / 'fixtures'), str(ROOT)], check=True)
assert source_hashes == {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}, 'Fixture sources changed during generation'
manifest_path = out / 'manifest.json'
manifest = json.loads(manifest_path.read_text())
manifest['sourceSHA256'] = source_hashes
manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, sort_keys=True, indent=2) + '\n')
