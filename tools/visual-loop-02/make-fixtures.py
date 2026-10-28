#!/usr/bin/env python3
"""Compile unchanged engine and save real, replay-validated scene witnesses."""
import subprocess
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
b = ROOT / '.build/visual-loop-02/fixtures'
b.mkdir(parents=True, exist_ok=True)
common = ['xcrun', 'swiftc', '-O', '-swift-version', '6', '-I', str(b), '-L', str(b)]
for name, folder in [('LifeDomain', 'Domain'), ('LifePersistence', 'Persistence')]:
    subprocess.run(common + ['-parse-as-library', '-emit-library', '-emit-module', '-module-name', name,
        '-emit-module-path', str(b / (name + '.swiftmodule')), '-o', str(b / ('lib' + name + '.dylib'))]
        + ([] if folder == 'Domain' else ['-lLifeDomain'])
        + [str(p) for p in sorted((ROOT / 'LifeCrossroads' / folder).glob('*.swift'))], check=True)
subprocess.run(common + ['-parse-as-library', '-lLifeDomain', '-lLifePersistence', '-Xlinker', '-rpath', '-Xlinker', str(b), '-o', str(b / 'fixtures'), str(Path(__file__).with_name('Fixtures.swift'))], check=True)
subprocess.run([str(b / 'fixtures'), str(ROOT)], check=True)
