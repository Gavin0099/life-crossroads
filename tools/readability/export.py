import sys,subprocess,json,shutil,hashlib,re
from pathlib import Path
result=Path(sys.argv[1]);out=Path(sys.argv[2]);raw=out/'attachments'
raw.mkdir(exist_ok=True)
if not (raw/'manifest.json').exists():
 subprocess.run(['xcrun','xcresulttool','export','attachments','--path',str(result),'--output-path',str(raw)],check=True, stdout=subprocess.DEVNULL)
rows=[]
for test in json.loads((raw/'manifest.json').read_text()):
 for a in test.get('attachments',[]):
  match=re.search(r'(readability-.*?-screen)',a.get('suggestedHumanReadableName',''))
  if match and a['exportedFileName'].endswith('.png'):
   p=out/(match[1]+'.png');shutil.copy2(raw/a['exportedFileName'],p)
   rows.append({'path':p.name,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
  audit=re.search(r'(readability-.*?-audit)',a.get('suggestedHumanReadableName',''))
  if audit and a['exportedFileName'].endswith('.txt'):
   shutil.copy2(raw/a['exportedFileName'],out/(audit[1]+'.txt'))
(out/'screenshots.json').write_text(json.dumps(rows,indent=2)+'\n')
print('Exported',len(rows),'native screenshots')
