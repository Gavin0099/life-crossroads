"""Bind native evidence to the reviewed rendering sources and unchanged life engine."""
import hashlib,json,re,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
BASE='30d60007ca43431a740c093f17c75a5e75dc0fb6'
label=sys.argv[1] if len(sys.argv)>1 else 'round3'
root=ROOT/'artifacts/evidence/multi-cast-loop'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((root/'cast-fixtures/manifest.json').read_text())
checks=[]
for device in ['iPhone-SE-3rd-generation','iPhone-17']:
 folder=root/label/device
 source=json.loads((folder/'source.json').read_text())
 mismatched=[p for p,digest in source['sourceHashes'].items() if sha(ROOT/p)!=digest]
 assert not mismatched, mismatched
 images=json.loads((folder/'screenshots.json').read_text())['images']
 for image in images: assert sha(folder/image['file'])==image['sha256']
 log=(folder/'test.log').read_text()
 captures=re.findall(r'VISUAL_CAPTURE (\S+) (\S+) archive=([a-f0-9]{64})',log)
 controls=re.findall(r'VISUAL_CONTROL (\S+) (\S+) \S+ hittable=true',log)
 assert len(captures)==31,(device,len(captures))
 assert len({(n,m) for n,m,_ in captures})==31
 assert {(n,m) for n,m,_ in captures}==set(controls)
 for name,mode,digest in captures:
  assert sha(root/'cast-fixtures'/(name+'.json'))==digest,(name,mode)
 runtime=json.loads((folder/'runtime-summary.json').read_text())
 assert runtime['result']=='Passed' and runtime['failedTests']==0
 assert not runtime['runtimeWarnings'],runtime['runtimeWarnings']
 checks.append({'device':device,'states':31,'controlReachability':True,'archiveChecksumsMatch':True,'sourceHashesMatch':True,'warnings':[]})
for path in ['LifeCrossroads/Domain','LifeCrossroads/Data','LifeCrossroads/Persistence','.github/workflows','UITests/LifeCrossroadsUITests.swift']:
 diff=subprocess.check_output(['git','diff',BASE,'--',path],cwd=ROOT,text=True)
 assert not diff,path
simulators=json.loads(subprocess.check_output(['xcrun','simctl','list','devices','-j'],text=True))
live={d['udid'] for devices in simulators['devices'].values() for d in devices}
owned={json.loads(p.read_text())['device'] for p in root.glob('*/*/source.json')}
assert not (owned & live),owned & live
out={'base':BASE,'renderSourceDigest':hashlib.sha256(json.dumps(source['sourceHashes'],sort_keys=True).encode()).hexdigest(),
 'native':checks,'unchangedEngineDataPersistenceAndOriginal30UITests':True,'deletedSimulators':sorted(owned),
 'claimBoundary':['Native automated evidence, not human child comprehension or physical iPhone acceptance','Basic governance known91daytransitionalkeyfailure remains separate','Original capture failures retained in baseline/iPhone-17/failure.json and CRITIC.md']}
failure_results=[]
for device in ['iPhone-SE-3rd-generation','iPhone-17']:
 folder=root/'save-failure'/device
 if not folder.exists(): continue
 runtime=json.loads((folder/'runtime-summary.json').read_text())
 assert runtime['result']=='Passed' and runtime['failedTests']==0 and not runtime['runtimeWarnings']
 assert 'CAST_SAVE_FAILURE oldFileAndInvitationUnchanged=true retrySaved=true' in (folder/'test.log').read_text()
 failure_results.append(device)
out['nativeSaveFailure']={'devices':failure_results,'cases':len(failure_results),'result':'PASS' if len(failure_results)==2 else 'NOT COMPLETE',
 'invariants':['Original archive checksum unchanged on failure','Invitation pose unchanged on failure','No committed action published before save','Retry saves actual friendship interaction']}
(root/'verification.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
