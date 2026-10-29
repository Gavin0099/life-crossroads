"""Capture actual held native gestures; never inject UI/model state or edit screenshots."""
from pathlib import Path
import sys, time, subprocess, json, hashlib
folder = Path(sys.argv[2]); seen = set(); receipts = []
while len(seen) < 2:
    text = (folder / 'test.log').read_text(errors='replace') if (folder / 'test.log').exists() else ''
    for side in ['left', 'right']:
        marker = 'RC_PREVIEW_HOLD_' + side
        if side not in seen and marker in text:
            seen.add(side)
            time.sleep(1.6)  # inside XCTest's explicit four-second hold, not engine time
            path = folder / ('rc-preview-hold-' + side + '.png')
            subprocess.run(['xcrun', 'simctl', 'io', sys.argv[1], 'screenshot', str(path)], check=True)
            receipts.append({'side': side, 'marker': marker, 'path': path.name, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
            (folder / 'held-preview.json').write_text(json.dumps(receipts, indent=2)+'\n')
    time.sleep(0.1)
