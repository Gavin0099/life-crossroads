import sys,subprocess,json,shutil,hashlib,re
from pathlib import Path
result=Path(sys.argv[1]);out=Path(sys.argv[2]);raw=out/'attachments'
raw.mkdir(exist_ok=True)
if not (raw/'manifest.json').exists():
 subprocess.run(['xcrun','xcresulttool','export','attachments','--path',str(result),'--output-path',str(raw)],check=True, stdout=subprocess.DEVNULL)
rows=[]; seen={}
for test in json.loads((raw/'manifest.json').read_text()):
 for a in test.get('attachments',[]):
  match=re.search(r'(rc-.+?)_\d+_',a.get('suggestedHumanReadableName',''))
  if match and a['exportedFileName'].endswith('.png'):
   name=match[1];seen[name]=seen.get(name,0)+1
   suffix='' if seen[name]==1 else '-'+str(seen[name])
   p=out/(name+suffix+'.png');shutil.copy2(raw/a['exportedFileName'],p)
   rows.append({'path':p.name,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
(out/'screenshots.json').write_text(json.dumps(rows,indent=2)+'\n')
print('Exported',len(rows),'native screenshots')
