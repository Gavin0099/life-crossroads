#!/usr/bin/env python3
"""Read a finished xcresult and preserve named PNG/JSON attachments with hashes."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

p=argparse.ArgumentParser(description=__doc__)
p.add_argument('bundle',type=Path)
p.add_argument('destination',type=Path)
a=p.parse_args()
a.destination.mkdir(parents=True,exist_ok=False)
records=[]
with tempfile.TemporaryDirectory(prefix='lc-sim-export-') as temp:
    subprocess.run(['xcrun','xcresulttool','export','attachments','--path',str(a.bundle),'--output-path',temp],check=True,stdout=subprocess.DEVNULL)
    for test in json.loads((Path(temp)/'manifest.json').read_text()):
        for item in test['attachments']:
            src=Path(temp)/item['exportedFileName']
            if src.suffix not in ['.png','.json']:continue
            name=item['suggestedHumanReadableName'].split('_0_')[0]
            name=re.sub(r'[^A-Za-z0-9_-]','-',name)
            target=a.destination/(name+src.suffix)
            if target.exists():
                suffix=hashlib.sha256(test['testIdentifier'].encode()).hexdigest()[:6]
                target=a.destination/(name+'-'+suffix+src.suffix)
            if target.exists():raise SystemExit('Attachment name collision; preserve the original bundle')
            shutil.copyfile(src,target)
            records.append(dict(item,testIdentifier=test['testIdentifier'],file=target.name,
                                sha256=hashlib.sha256(target.read_bytes()).hexdigest(),sourceBundle=str(a.bundle)))
(a.destination/'manifest.json').write_text(json.dumps(records,ensure_ascii=False,indent=2)+'\n')
print(f'Exported {len(records)} PNG/JSON attachments to {a.destination}')
