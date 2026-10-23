#!/usr/bin/env python3
"""Run the predeclared 1,024-life grid twice and preserve compressed, reproducible evidence."""
import gzip
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/evidence/rng-v2'


def sha(path):
    digest = hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b''):
            digest.update(chunk)
    return digest.hexdigest()


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    subprocess.run(['swift','build','-c','release'],cwd=ROOT,check=True)
    binary = ROOT / '.build/release/life-demo'
    with tempfile.TemporaryDirectory(prefix='life-rng-evidence-') as directory:
        temp = Path(directory)
        outputs=[]
        for index in range(2):
            path=temp / f'batch-{index}.json'
            with path.open('wb') as stream:
                subprocess.run([str(binary),'--batch-report','--seed-count','32'],cwd=ROOT,stdout=stream,check=True)
            outputs.append(path)
            print(f'Completed {index+1}/2 fixed-grid runs',flush=True)
        hashes=[sha(p) for p in outputs]
        if hashes[0] != hashes[1]: raise SystemExit('FAIL: repeated full reports differ')
        # Compress the exact verified bytes. No timestamps, filenames or changing gzip headers.
        with outputs[0].open('rb') as source, (OUT/'current.json.gz').open('wb') as target:
            with gzip.GzipFile(filename='',mode='wb',fileobj=target,mtime=0) as compressed:
                for chunk in iter(lambda: source.read(1024*1024),b''): compressed.write(chunk)
        subprocess.run([sys.executable,'scripts/render-batch-report.py',str(OUT/'current.json.gz'),str(OUT/'current.md')],cwd=ROOT,check=True)
        subprocess.run([sys.executable,'scripts/compare-batch-reports.py',str(OUT/'baseline.json.gz'),str(OUT/'current.json.gz'),str(OUT/'comparison')],cwd=ROOT,check=True)
        with (temp/'stories.json').open('wb') as stream:
            subprocess.run([str(binary),'--story-samples'],cwd=ROOT,stdout=stream,check=True)
        (OUT/'story-samples.json.gz').write_bytes(gzip.compress((temp/'stories.json').read_bytes(),mtime=0))
        tracked = subprocess.check_output(['git','ls-files','LifeCrossroads','scripts','Tests','UITests','Package.swift'],cwd=ROOT,text=True).splitlines()
        manifest=dict(productCommit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),
                      command='python3 scripts/run-rng-v2-evidence.py',sample=dict(seeds=list(range(32)),livesPerRun=1024,runs=2),
                      repeatResult='byte-identical',outputSHA256=hashes[0],compressedSHA256=sha(OUT/'current.json.gz'),
                      sourceSHA256={name:sha(ROOT/name) for name in tracked if (ROOT/name).is_file()},
                      claimBoundary='Pure Swift model evidence; no real-device, VoiceOver or child playtest acceptance. Baseline was captured before engine changes.')
        (OUT/'current-manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2,sort_keys=True)+'\n')
    print('PASS: 2 × 1,024 lives, exact repeat, comparison, and three full story/replay samples; temporary raw reports deleted.')

if __name__=='__main__': main()
