#!/usr/bin/env python3
"""Export named XCTest screenshots, preserving source metadata and hashes."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('bundle', type=Path)
parser.add_argument('destination', type=Path)
args = parser.parse_args()
args.destination.mkdir(parents=True, exist_ok=True)
records = []
with tempfile.TemporaryDirectory(prefix='lc-xcresult-') as temp:
    subprocess.run(['xcrun', 'xcresulttool', 'export', 'attachments', '--path', str(args.bundle), '--output-path', temp], check=True, stdout=subprocess.DEVNULL)
    manifest = json.loads((Path(temp) / 'manifest.json').read_text())
    for test in manifest:
        for entry in test['attachments']:
            filename = entry['exportedFileName']
            if not filename.endswith('.png'):
                continue
            name = entry['suggestedHumanReadableName'].split('_0_')[0]
            name = re.sub(r'[^A-Za-z0-9_-]', '-', name)
            target = args.destination / (name + '.png')
            if target.exists():
                target = args.destination / (name + '-' + hashlib.sha256(test['testIdentifier'].encode()).hexdigest()[:6] + '.png')
            shutil.copy2(Path(temp) / filename, target)
            records.append(dict(entry, testIdentifier=test['testIdentifier'], file=target.name,
                                sha256=hashlib.sha256(target.read_bytes()).hexdigest(), sourceBundle=str(args.bundle)))
(args.destination / 'manifest.json').write_text(json.dumps(records, ensure_ascii=False, indent=2) + '\n')
print(f'Exported {len(records)} screenshots to {args.destination}')
