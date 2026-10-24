"""Recheck frozen sources, unchanged assets/rules, route fixtures and owned-device deletion."""
import datetime,hashlib,json,re,subprocess
from pathlib import Path
root=Path(__file__).resolve().parents[2]
import os
os.chdir(root)
out=Path('artifacts/simulation-p2')
def read(p): return json.loads(Path(p).read_text())
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
snapshot=read(out/'native-source-final.json')
source={p:sha(p)==h for p,h in snapshot['source_sha256'].items()}
protected={p:sha(p)==h for p,h in read(out/'protected-source.json')['unchanged_files'].items()}
base=snapshot['base']
asset_roots=['assets/simulation','LifeCrossroads/App/Assets.xcassets']
before=subprocess.check_output(['git','ls-tree','-r','--name-only',base,'--',*asset_roots],text=True).splitlines()
after=sorted(str(p) for folder in asset_roots for p in Path(folder).rglob('*') if p.is_file() and p.name!='.DS_Store')
unchanged_assets=sorted(before)==after and all(sha(p)==hashlib.sha256(subprocess.check_output(['git','show',base+':'+p])).hexdigest() for p in before)
test_paths=['UITests/LifeCrossroadsUITests.swift','UITests/WorkshopGameplayTests.swift']
old_names={n for p in test_paths for n in re.findall(r'func (test\w+)\(',subprocess.check_output(['git','show',base+':'+p],text=True))}
new_names={n for p in test_paths for n in re.findall(r'func (test\w+)\(',Path(p).read_text())}
ui={};routes={};attachments={}
for label in ['narrow-final','standard-final']:
 s=read(out/(label+'-summary.json'))
 ui[label]={'passed':s['passedTests'],'failed':s['failedTests'],'total':s['totalTestCount'],'skipped':s['skippedTests'],'expected_failures':s['expectedFailures'],'pass':s['passedTests']==17 and s['totalTestCount']==17 and s['failedTests']==0 and s['skippedTests']==0 and s['expectedFailures']==0}
 folder=out/'screenshots'/label
 records=read(folder/'manifest.json')
 attachments[label]={'count':len(records),'all_hashes_match':all(sha(folder/r['file'])==r['sha256'] for r in records)}
 for file in ['team-life-observations.json','help-graphics-off-observations.json']:
  routes[label+'/'+file]=read(folder/file)==read(Path('artifacts/simulation/screenshots/narrow-final')/file)
 past=read(folder/'p2-memory-browsing-observations.json')
 routes[label+'/past_browsing_retained_current_world']=past==read(folder/'team-life-observations.json')['age15']
inventory=read_devices=json.loads(subprocess.check_output(['xcrun','simctl','list','devices','-j'],text=True))
existing={d['udid'] for group in inventory['devices'].values() for d in group}
cleanup=[]
for path in sorted(out.glob('*-run.json')):
 r=read(path);cleanup.append({'receipt':str(path),'uuid':r['device_uuid'],'exit_code':r['exit_code'],'cleanup':r['cleanup'],'absent_now':r['device_uuid'] not in existing})
report={'at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_snapshot_sha256':sha(out/'native-source-final.json'),'source_count':len(source),'all_sources_match':all(source.values()),'protected_count':len(protected),'protected_all_match':all(protected.values()),'asset_inventory_and_bytes_unchanged':unchanged_assets,'asset_file_count':len(before),'original_tests_retained':old_names <= new_names,'original_test_count':len(old_names),'current_test_count':len(new_names),'native':ui,'attachments':attachments,'route_fixtures_equal_baseline':routes,'simulator_cleanup':cleanup,'all_owned_devices_deleted':all(r['cleanup']=='PASS' and r['absent_now'] for r in cleanup),'boundary':'Presentation-only 13-to-15 workshop; no annual simulation, human fun, hardware or production art approval claim'}
report['pass']=all([report['all_sources_match'],report['protected_all_match'],unchanged_assets,old_names<=new_names,len(new_names)==17,all(r['pass'] for r in ui.values()),all(r['all_hashes_match'] for r in attachments.values()),all(routes.values()),report['all_owned_devices_deleted']])
(out/'verification.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(report,ensure_ascii=False,indent=2))
raise SystemExit(0 if report['pass'] else 1)
