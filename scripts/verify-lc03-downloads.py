#!/usr/bin/env python3
"""Optional live verification of the pinned national-row extracts. Never overwrites pinned evidence."""
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
from lc03_data import nhe_row, digital_row

raw=Path(__file__).resolve().parents[1]/'LifeCrossroads/Data/Resources/raw'
for filename,extractor in [('taiwan-nhe-national-row-2023.json',nhe_row),('taiwan-digital-national-row-2023.json',digital_row)]:
    record=json.loads((raw/filename).read_text())
    with tempfile.TemporaryDirectory(prefix='lc03-source-') as folder:
        path=Path(folder)/'download'
        subprocess.run(['curl','--fail','--location','--silent','--show-error','--max-time','60','-A','Mozilla/5.0',record['downloadURL'],'-o',str(path)],check=True)
        data=path.read_bytes()
    if hashlib.sha256(data).hexdigest()!=record['originalSHA256']:
        raise SystemExit(filename+': upstream bytes changed; review a new version, do not overwrite')
    if extractor(data)!=record['row']:
        raise SystemExit(filename+': extracted row mismatch')
    print(filename+': full download SHA256 and national row PASS')
