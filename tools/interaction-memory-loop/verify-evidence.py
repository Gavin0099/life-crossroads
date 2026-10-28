"""Bind final native evidence, immutable core, real fixtures and Simulator deletion."""
import hashlib,json,re,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
BASE='a79f667528b5b4cbeb2e543b6d9ca33a12d680f1'
E=ROOT/'artifacts/evidence/interaction-memory-loop'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
checks={}; devices=[]; finals=[]
protected=['LifeCrossroads/Domain','LifeCrossroads/Data','LifeCrossroads/Persistence','.github/workflows','UITests/LifeCrossroadsUITests.swift']
checks['protectedDiffEmpty']=not subprocess.check_output(['git','diff',BASE,'--']+protected,cwd=ROOT,text=True).strip()
for hardware in ['iPhone-SE-3rd-generation','iPhone-17']:
 d=E/'final3'/hardware; source=json.loads((d/'source.json').read_text())
 checks[hardware+'SourceMatches']=all(sha(ROOT/p)==h for p,h in source['sourceHashes'].items())
 screenshots=json.loads((d/'screenshots.json').read_text())
 checks[hardware+'ImageHashes']=all(sha(d/i['file'])==i['sha256'] for i in screenshots['images'])
 log=(d/'test.log').read_text()
 captures=re.findall(r'^VISUAL_CAPTURE (\S+) (\S+) archive=(\w+)',log,re.M)
 controls=re.findall(r'^VISUAL_CONTROL (\S+) (\S+) ',log,re.M)
 expected={(n,'normal') for n in ['13-ask','32-ask','72-ahe','72-neighbor','45-neutral','25-neutral','13-before','10-before','72-ahe-before','13-rest','32-participating']}
 expected|={(n,v) for n in ['13-ask','32-ask','72-ahe','72-neighbor'] for v in ['large','reduced']}
 checks[hardware+'Matrix']=set((n,v) for n,v,_ in captures)==expected and set(controls)==expected and len(captures)==19
 for name,variant,digest in captures: assert sha(E/'interaction-fixtures'/(name+'.json'))==digest,(hardware,name,variant)
 supplement=E/'final2'/hardware
 supplemental_log=(supplement/'test.log').read_text()
 supplemental_shots=json.loads((supplement/'screenshots.json').read_text())
 checks[hardware+'SupplementImageHashes']=all(sha(supplement/i['file'])==i['sha256'] for i in supplemental_shots['images'])
 checks[hardware+'NoRuntimeWarnings']=not json.loads((d/'runtime-summary.json').read_text())['runtimeWarnings'] and not json.loads((supplement/'runtime-summary.json').read_text())['runtimeWarnings']
 supplemental_source=json.loads((supplement/'source.json').read_text())
 # The only later source difference is the independently reviewed 72-memory container alignment.
 mismatches=[p for p,h in supplemental_source['sourceHashes'].items() if sha(ROOT/p)!=h]
 scene_path='LifeCrossroads/App/LifeWorldScene.swift'
 previous_scene=(ROOT/scene_path).read_text().replace('}.frame(width: size.width * 0.68 - 3, height: size.height, alignment: .topLeading).clipped()', '}.frame(width: size.width * 0.68 - 3, height: size.height).clipped()')
 checks[hardware+'SupplementScope']=set(mismatches)<= {scene_path} and hashlib.sha256(previous_scene.encode()).hexdigest()==supplemental_source['sourceHashes'][scene_path]
 beats=re.findall(r'^VISUAL_REQUEST (\d+) (\w+) archive=(\w+) phaseMs=(\d+)',supplemental_log,re.M)
 checks[hardware+'RequestClock']=len(beats)==4 and {(a,b) for a,b,_,_ in beats}=={('13','expressing'),('13','listening'),('32','expressing'),('32','listening')} and all((200<=int(ms)<1100 if beat=='expressing' else 1400<=int(ms)<2000) for age,beat,digest,ms in beats)
 checks[hardware+'RequestSaveInvariant']=all(len({digest for a,b,digest,ms in beats if a==age})==1 for age in ['13','32'])
 checks[hardware+'FailureRetry']='CAST_SAVE_FAILURE oldFileAndInvitationUnchanged=true retrySaved=true' in supplemental_log
 checks[hardware+'TestsPass']='Executed 1 test, with 0 failures' in log and 'Executed 3 tests, with 0 failures' in supplemental_log
 finals.append({'hardware':hardware,'captures':len(captures),'requestBeats':beats,'runtime':json.loads((d/'runtime-summary.json').read_text())})
for p in E.glob('*-run.log'):
 text=p.read_text();created=re.findall(r'Created visual Simulator: ([0-9A-F-]+)',text);deleted=re.findall(r'Deleted visual Simulator: ([0-9A-F-]+)',text)
 for udid in created: devices.append({'udid':udid,'log':str(p.relative_to(ROOT)),'deletedReceipt':udid in deleted})
inventory=json.loads(subprocess.check_output(['xcrun','simctl','list','devices','-j'],text=True))
existing={d['udid'] for group in inventory['devices'].values() for d in group}
checks['dedicatedSimulatorsDeleted']=all(d['deletedReceipt'] and d['udid'] not in existing for d in devices)
checks['eightDedicatedDevices']=len(devices)==8
report={'base':BASE,'checks':checks,'allPass':all(checks.values()),'devices':devices,'finals':finals,
'claimBoundary':'Local engineering evidence; no human playtest, official art, real iPhone or overall CI acceptance.'}
(E/'verification.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n')
print(json.dumps({'allPass':report['allPass'],'checks':checks,'devices':len(devices)},indent=2));assert report['allPass']
