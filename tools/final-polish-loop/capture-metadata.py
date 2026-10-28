import hashlib,json,subprocess,sys
from pathlib import Path
out=Path(sys.argv[1]); paths=sorted(Path('LifeCrossroads/App').rglob('*.swift'))+sorted(Path('LifeCrossroads/Presentation').glob('*.swift'))+list(Path('UITests').glob('*.swift'))
paths += sorted(Path('LifeCrossroads/App/Assets.xcassets').rglob('*.png'))
paths += [Path('LifeCrossroads.xcodeproj/project.pbxproj')] + sorted(Path('tools/final-polish-loop').glob('*'))
paths += list(Path('artifacts/evidence/interaction-memory-loop/interaction-fixtures').glob('*.json'))
data={'base':'325b69896553fb6c479e415c0c0991e76ef78a26','sourceCommit':subprocess.check_output(['git','rev-parse','HEAD'],text=True).strip(),
 'sourceOverlay':'Capture-only compiler flag ingress validates actual saved sessions, pauses playback; production build excludes ingress. Source hashes below bind uncommitted rendering if present.',
 'device':sys.argv[2],'runtime':sys.argv[3],'variants':sys.argv[4],'filter':sys.argv[5],
 'sourceHashes':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
(out/'source.json').write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n')
