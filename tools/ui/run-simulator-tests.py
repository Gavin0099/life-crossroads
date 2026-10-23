#!/usr/bin/env python3
"""Run UI tests on an owned temporary Simulator, journal ownership, always delete it."""
import argparse
from contextlib import contextmanager
import datetime as dt
import json
import os
from pathlib import Path
import signal
import subprocess
import time
import uuid

ROOT = Path(__file__).resolve().parents[2]
DEADLINE = None


def atomic_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = path.with_name(path.name + '.tmp')
    temp.write_text(json.dumps(value, indent=2) + '\n')
    temp.replace(path)


def read_ledger(path):
    if not Path(path).exists():
        return {'version': 1, 'devices': [], 'creates': []}
    value = json.loads(Path(path).read_text())
    if not isinstance(value, dict) or value.get('version') != 1 or not isinstance(value.get('devices'), list):
        raise ValueError('Malformed owned Simulator ledger')
    for item in value['devices']:
        if not isinstance(item, dict) or str(uuid.UUID(item['uuid'])).upper() != item['uuid'].upper():
            raise ValueError('Malformed owned Simulator UUID')
        if item.get('status') not in ('owned', 'deleted'):
            raise ValueError('Malformed owned Simulator status')
    if not isinstance(value.get('creates', []), list):
        raise ValueError('Malformed create journal')
    for request in value.get('creates', []):
        if not isinstance(request, dict) or not isinstance(request.get('name'), str) or not request['name'].startswith('LC UI owned ') or len(request['name']) != len('LC UI owned ') + 32 or request.get('status') not in ('pending', 'recorded'):
            raise ValueError('Malformed owned create request')
    return value


def command(args, *, capture=False, cleanup=False):
    seconds = 25 if cleanup else 1800
    if DEADLINE is not None and not cleanup:
        seconds = min(seconds, DEADLINE - time.time())
        if seconds <= 0:
            raise TimeoutError('Simulator deadline reached')
    proc = subprocess.Popen(args, cwd=ROOT, text=True, stdout=subprocess.PIPE if capture else None)
    try:
        output, _ = proc.communicate(timeout=seconds)
        if proc.returncode:
            raise subprocess.CalledProcessError(proc.returncode, args, output)
        return output or ''
    finally:
        if proc.poll() is None:
            proc.terminate()
            try:
                proc.wait(timeout=3)
            except subprocess.TimeoutExpired:
                proc.kill()
                proc.wait(timeout=3)


def select_runtime(device_type, requested=None):
    runtimes = json.loads(command(['xcrun', 'simctl', 'list', 'runtimes', '-j'], capture=True))['runtimes']
    available = [r for r in runtimes if r.get('isAvailable') and r.get('platform') == 'iOS'
                 and any(d['identifier'] == device_type for d in r.get('supportedDeviceTypes', []))
                 and (requested is None or r['identifier'] == requested)]
    if not available:
        raise ValueError('No installed iOS runtime supports the requested device type')
    return max(available, key=lambda r: tuple(int(n) for n in r['version'].split('.')))['identifier']


def cleanup_owned(path):
    ledger = read_ledger(path)
    pending = [d for d in ledger['devices'] if d['status'] == 'owned']
    unresolved = [c for c in ledger.get('creates', []) if c['status'] == 'pending']
    if not pending and not unresolved:
        return
    state = json.loads(command(['xcrun', 'simctl', 'list', 'devices', '-j'], capture=True, cleanup=True))
    records = [d for rows in state['devices'].values() for d in rows]
    # A persisted 128-bit create nonce closes the kill-between-create-and-return gap.
    # Resolve only this exact owned request, record its UUID, then delete by UUID.
    for request in unresolved:
        matches = [d for d in records if d.get('name') == request['name']]
        if len(matches) > 1:
            raise ValueError('Ambiguous owned create request; refusing deletion')
        if matches:
            identifier = str(uuid.UUID(matches[0]['udid'])).upper()
            if not any(d['uuid'].upper() == identifier for d in ledger['devices']):
                item = {'uuid': identifier, 'status': 'owned', 'recovered_create_nonce': request['name']}
                ledger['devices'].append(item); pending.append(item)
            request['status'] = 'recorded'
            atomic_json(path, ledger)
    existing = {d['udid'].upper() for d in records}
    for device in pending:
        identifier = device['uuid']
        if identifier.upper() in existing:
            try:
                command(['xcrun', 'simctl', 'shutdown', identifier], cleanup=True)
            except (subprocess.CalledProcessError, subprocess.TimeoutExpired, TimeoutError):
                pass  # Deletion is still attempted after an already-stopped or timed-out shutdown.
            command(['xcrun', 'simctl', 'delete', identifier], cleanup=True)
            after = json.loads(command(['xcrun', 'simctl', 'list', 'devices', '-j'], capture=True, cleanup=True))
            if any(d.get('udid', '').upper() == identifier.upper()
                   for rows in after['devices'].values() for d in rows):
                raise RuntimeError('Owned Simulator remains after delete: ' + identifier)
        device['status'] = 'deleted'
        atomic_json(path, ledger)
        print(f'Deleted temporary Simulator: {identifier}', flush=True)
    if any(c['status'] == 'pending' for c in ledger.get('creates', [])):
        raise RuntimeError('Unresolved owned create intent; retained for exact-UUID cleanup retry')


@contextmanager
def temporary_simulator(device_type, runtime, ledger_path=None):
    ledger_path = Path(ledger_path or f'/tmp/lc-simulator-owned-{os.getpid()}.json')
    ledger = read_ledger(ledger_path)
    # Defer catchable termination only across create+ownership publication. The caller's
    # watchdog can then always sweep the exact returned UUID, never a shared device name.
    name = 'LC UI owned ' + uuid.uuid4().hex
    request = {'name': name, 'status': 'pending'}
    ledger.setdefault('creates', []).append(request)
    atomic_json(ledger_path, ledger)
    mask = signal.pthread_sigmask(signal.SIG_BLOCK, {signal.SIGTERM, signal.SIGINT})
    try:
        device_id = command(['xcrun', 'simctl', 'create', name,
                             device_type, runtime], capture=True).strip()
        uuid.UUID(device_id)
        ledger['devices'].append({'uuid': device_id, 'status': 'owned', 'device_type': device_type,
                                  'runtime': runtime, 'created': dt.datetime.now(dt.timezone.utc).isoformat()})
        request['status'] = 'recorded'
        atomic_json(ledger_path, ledger)
    finally:
        signal.pthread_sigmask(signal.SIG_SETMASK, mask)
    print(f'Created temporary Simulator: {device_id}', flush=True)
    try:
        yield device_id
    finally:
        cleanup_owned(ledger_path)


def interrupted(signum, frame):
    raise InterruptedError(f'Simulator runner interrupted by signal {signum}')


def main():
    global DEADLINE
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--scheme', choices=['EventFirst', 'WorldGameplay'], default='EventFirst')
    parser.add_argument('--device-type', default='iPhone-17')
    parser.add_argument('--runtime')
    parser.add_argument('--result-bundle', type=Path)
    parser.add_argument('--only-testing', action='append', default=[])
    parser.add_argument('--owned-ledger', type=Path, default=Path(f'/tmp/lc-simulator-owned-{os.getpid()}.json'))
    parser.add_argument('--cleanup-only', action='store_true')
    parser.add_argument('--deadline', help='Absolute UTC ISO deadline; never extends a caller deadline')
    args = parser.parse_args()
    if args.deadline:
        DEADLINE = dt.datetime.fromisoformat(args.deadline.replace('Z', '+00:00')).timestamp()
    for sig in (signal.SIGTERM, signal.SIGINT):
        signal.signal(sig, interrupted)
    try:
        cleanup_owned(args.owned_ledger)
        if args.cleanup_only:
            return 0
        device_type = args.device_type if args.device_type.startswith('com.apple.') else 'com.apple.CoreSimulator.SimDeviceType.' + args.device_type
        runtime = select_runtime(device_type, args.runtime)
        result = (args.result_bundle or ROOT / f'UIPrototype/{args.scheme}/DerivedData/run-{uuid.uuid4().hex}.xcresult').resolve()
        if result.exists():
            parser.error(f'Result bundle already exists: {result}')
        result.parent.mkdir(parents=True, exist_ok=True)
        print(f'Retained result bundle: {result}', flush=True)
        with temporary_simulator(device_type, runtime, args.owned_ledger) as device_id:
            args_xcode = ['xcodebuild', '-project', f'UIPrototype/{args.scheme}.xcodeproj', '-scheme', args.scheme,
                         '-destination', f'platform=iOS Simulator,id={device_id}', '-parallel-testing-enabled', 'NO',
                         '-collect-test-diagnostics', 'never', '-test-timeouts-enabled', 'YES',
                         '-maximum-test-execution-time-allowance', '120', '-derivedDataPath', f'UIPrototype/{args.scheme}/DerivedData',
                         '-resultBundlePath', str(result), 'CODE_SIGNING_ALLOWED=NO', 'test']
            args_xcode.extend(f'-only-testing:{test}' for test in args.only_testing)
            command(args_xcode)
        return 0
    finally:
        # Cleanup remains required on signals, malformed result paths and failed tests.
        for sig in (signal.SIGTERM, signal.SIGINT):
            signal.signal(sig, signal.SIG_IGN)
        cleanup_owned(args.owned_ledger)


if __name__ == '__main__':
    raise SystemExit(main())
