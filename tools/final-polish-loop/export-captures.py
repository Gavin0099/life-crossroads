import hashlib,json,subprocess,sys,shutil
from pathlib import Path
result=Path(sys.argv[1]);out=Path(sys.argv[2]);raw=Path('artifacts/governance/final-polish-loop')/(out.parent.name+'-'+out.name+'-attachments')
raw.mkdir(parents=True,exist_ok=True)
if not (raw/'manifest.json').exists(): subprocess.run(['xcrun','xcresulttool','export','attachments','--path',str(result),'--output-path',str(raw)],check=True)
manifest=json.loads((raw/'manifest.json').read_text());entries=[]
for test in manifest:
 for a in test.get('attachments',[]):
  name=a.get('suggestedHumanReadableName','')
  if not any(t in name for t in ('-screen','-scene')) or not a['exportedFileName'].endswith('.png'):continue
  stem=name.split('_')[0] if '_' in name else name
  # xcresult names the attachment with a .png extension, sometimes a UUID suffix.
  import re
  match=re.search(r'(\d{2}-[a-z]+(?:-[a-z]+)*-(?:normal|large|reduced)-(?:screen|scene))',name)
  if not match:continue
  dest=out/(match.group(1)+'.png');shutil.copy2(raw/a['exportedFileName'],dest)
  entries.append({'file':dest.name,'sha256':hashlib.sha256(dest.read_bytes()).hexdigest(),'sourceAttachment':a['exportedFileName']})
assert entries,manifest
(out/'screenshots.json').write_text(json.dumps({'xcresult':str(result),'kind':'native iOS App, real replay-validated archives; scene is native element crop', 'images':entries},indent=2)+'\n')
print('Exported',len(entries),'native screenshots to',out)
