"""Retain complete local logs, publish only capture records and test/build verdicts."""
from pathlib import Path
import hashlib,json,shutil,sys
out=Path(sys.argv[1]); raw=Path('artifacts/governance/interaction-memory-loop')/(out.parent.name+'-'+out.name+'-raw')
raw.mkdir(parents=True,exist_ok=True); records=[]
for name in ['build.log','test.log']:
 p=out/name
 if not p.exists():continue
 original=p.read_bytes(); target=raw/name
 # Do not replace an existing complete raw log with its condensed projection.
 if not target.exists(): shutil.copyfile(p,target)
 else: original=target.read_bytes()
 lines=original.decode(errors='replace').splitlines()
 selected=[line for line in lines if any(token in line for token in ['VISUAL_REQUEST ', 'CAST_SAVE_FAILURE ', 'VISUAL_CAPTURE ','VISUAL_CONTROL ','Executed ','Test Case ', '** TEST ', '** TEST BUILD ', 'error:', 'warning:','Failing tests:'])]
 p.write_text('\n'.join(selected)+'\n')
 records.append({'file':name,'completeLog':str(target),'completeSHA256':hashlib.sha256(original).hexdigest(),
                 'publishedSHA256':hashlib.sha256(p.read_bytes()).hexdigest(),'projection':'test/capture verdict lines; complete log retained locally'})
(out/'logs.json').write_text(json.dumps(records,indent=2)+'\n')
