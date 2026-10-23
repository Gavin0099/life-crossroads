import argparse,datetime,json,os,signal,subprocess,time
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('device');p.add_argument('label');p.add_argument('--only',action='append',default=[]);p.add_argument('--repo',default='.');a=p.parse_args()
root=Path(a.repo).resolve();os.chdir(root)
stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
out=root/'artifacts/simulation';bundle=root/f'artifacts/ios/SIM-{a.label}-{stamp}.xcresult';device=None;proc=None
receipt={'device_type':a.device,'result_bundle':str(bundle.relative_to(root)),'started_utc':stamp,'cleanup':'NOT RUN'}
def stop(signum,frame): raise KeyboardInterrupt
signal.signal(signal.SIGTERM,stop);signal.signal(signal.SIGINT,stop)
try:
 device=subprocess.check_output(['xcrun','simctl','create',f'LC SIM {a.label} {stamp}',a.device,'com.apple.CoreSimulator.SimRuntime.iOS-27-0'],text=True).strip();receipt['device_uuid']=device
 command=['xcodebuild','-project','LifeCrossroads.xcodeproj','-scheme','LifeCrossroads','-destination',f'platform=iOS Simulator,id={device}','-parallel-testing-enabled','NO','-collect-test-diagnostics','never','-derivedDataPath','.build/ios-app','-resultBundlePath',str(bundle),'CODE_SIGNING_ALLOWED=NO']+[f'-only-testing:{x}' for x in a.only]+['test']
 receipt['command']=command
 with (out/f'{a.label}.log').open('w') as log:
  proc=subprocess.Popen(command,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
  receipt['exit_code']=proc.wait(timeout=1800)
except (KeyboardInterrupt,subprocess.TimeoutExpired) as exc:
 receipt['interruption']=type(exc).__name__;receipt['exit_code']=130
 if proc and proc.poll() is None:
  os.killpg(proc.pid,signal.SIGTERM)
  try:proc.wait(timeout=20)
  except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
finally:
 if device:
  subprocess.run(['xcrun','simctl','shutdown',device],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
  deletion=subprocess.run(['xcrun','simctl','delete',device],capture_output=True,text=True)
  inventory=json.loads(subprocess.check_output(['xcrun','simctl','list','devices','-j'],text=True))
  absent=all(x['udid']!=device for group in inventory['devices'].values() for x in group)
  receipt['cleanup']='PASS' if deletion.returncode==0 and absent else 'FAIL'
  receipt['cleanup_stderr']=deletion.stderr;receipt['owned_device_absent']=absent
 receipt['ended_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat()
 (out/f'{a.label}-run.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n')
 print(json.dumps(receipt,ensure_ascii=False,indent=2),flush=True)
raise SystemExit(receipt.get('exit_code',1) or (0 if receipt['cleanup']=='PASS' else 1))
