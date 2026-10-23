#!/usr/bin/env python3
"""Deadline-bound visual loop. CLI agents propose; trusted supervisor validates. No push."""
from __future__ import annotations
import argparse
import datetime as dt
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import signal
import subprocess
import sys
import time
import uuid

VERSION = 1
RESERVE = 600
MAX_BUILDERS = 6
PNG_NAMES = ('01-home.png', '02-friend-outcome.png', '03-teacher-outcome.png', '04-narrow.png', '05-large-type.png', '06-acting-contact-sheet.png')
EXTRA_IMAGE = '07-large-type-reaction.png'
WRITABLE = ('UIPrototype/WorldGameplay', 'UIPrototype/WorldGameplayTests', 'UIPrototype/WorldGameplay.xcodeproj',
            'assets/gameplay', 'assets/prompts', 'docs/ui-loop')
SOURCE_ROOTS = ('UIPrototype/WorldGameplay', 'UIPrototype/WorldGameplayTests', 'UIPrototype/WorldGameplay.xcodeproj',
                'LifeCrossroads', 'Tests', 'tools', 'assets/gameplay', 'assets/prompts', 'Package.swift',
                'docs/ui-loop/STYLE_GUIDE.md', 'docs/ui-loop/CHARACTER_ACTING_SPEC.md')
MODEL_NAMES = ('iPhone 17', 'iPhone SE (3rd generation)')
REQUIRED_TESTS = frozenset(('testTeamSceneGrowsIntoAdultMemory',
    'testHelpHasDifferentActorsObjectComparisonAndMemory',
    'testFoldGatePauseAndBackgroundFreezeTime',
    'testLargestTextAndReducedMotionKeepChoiceAndDetailReachable',
    'testMissingRouteDoesNotProduceLifeAndCanRestart',
    'testMissingNextRetainsLastSceneWithoutInventingYears',
    'testActingBranchesAreVisuallyDistinct', 'testReducedMotionPreservesOutcome',
    'testActingContactSheetShowsCatalog', 'testMissingRouteKeepsInitialActing'))
EXPRESSIONS = frozenset(('neutral', 'thinking', 'hopeful', 'tired'))
POSES = frozenset(('idle', 'collaborating', 'asking'))
ACTING_STATES = {'bridge-initial': (None, 'thinking', 'idle', PNG_NAMES[0]),
                 'bridge-team': ('team', 'hopeful', 'collaborating', PNG_NAMES[1]),
                 'bridge-help': ('help', None, 'asking', PNG_NAMES[2])}

class Stop(RuntimeError):
    pass


def utc(value):
    parsed = dt.datetime.fromisoformat(value.replace('Z', '+00:00'))
    if parsed.tzinfo is None:
        raise Stop('Deadline must include UTC offset')
    return parsed.timestamp()


def now():
    return dt.datetime.now(dt.timezone.utc).isoformat()


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write_json(path, data):
    path = Path(path); path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + '.tmp')
    temporary.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    temporary.replace(path)


def bounded_path(root, name):
    if not isinstance(name, str):
        raise Stop('Evidence path must be a string')
    p = (root / name).resolve()
    if not p.is_relative_to(root.resolve()) or not p.is_file():
        raise Stop('Evidence path escapes root or is missing: ' + name)
    return p


def source_hashes(root):
    paths = []
    for name in SOURCE_ROOTS:
        p = root / name
        paths.extend(p.rglob('*') if p.is_dir() else [p])
    for p in paths:
        if p.is_symlink():
            raise Stop('Symlink in validated source: ' + str(p))
    return {str(p.relative_to(root)): sha(p) for p in sorted(set(paths))
            if p.is_file() and not any(x in p.parts for x in ('DerivedData', '__pycache__', '.build'))}


def validate_provenance(root):
    records = {}
    manifests = sorted((root / 'assets/gameplay').glob('*manifest*.json'))
    if not manifests:
        raise Stop('No gameplay provenance manifest')
    for manifest in manifests:
        data = json.loads(manifest.read_text())
        if not isinstance(data, dict) or data.get('production_approval') is True or not isinstance(data.get('assets'), list):
            raise Stop('Malformed/production-approved prototype manifest')
        for asset in data['assets']:
            if not isinstance(asset, dict) or asset.get('approved_for_app') is not False:
                raise Stop('Candidate must explicitly remain unapproved for App use')
            path = bounded_path(root, asset.get('path'))
            if sha(path) != asset.get('output_sha256'):
                raise Stop('Asset provenance output hash mismatch: ' + str(path))
            prompt = bounded_path(root, asset.get('prompt_path'))
            if sha(prompt) != asset.get('prompt_sha256'):
                raise Stop('Asset prompt hash mismatch')
            inputs = asset.get('input_hashes')
            if not isinstance(inputs, dict):
                raise Stop('Asset input provenance missing')
            for name, digest in inputs.items():
                if sha(bounded_path(root, name)) != digest:
                    raise Stop('Asset reference hash mismatch')
            records[str(path.relative_to(root))] = asset['output_sha256']
    for image in (root / 'UIPrototype/WorldGameplay/Assets.xcassets').rglob('*.png'):
        if sha(image) not in records.values():
            raise Stop('Used UI image has no matching candidate provenance: ' + str(image))
    return {'result': 'PASS', 'output_sha256': records,
            'claim_boundary': 'Traceable existing prototype candidates only; no commercial or production approval'}


def parse_critic(text):
    lines = text.strip().splitlines()
    if len(lines) < 5 or not re.fullmatch(r'GATE=(PASS|FAIL|NOT_VERIFIED)', lines[0]):
        raise Stop('Malformed critic gate header')
    counts = []
    for prefix, line in zip(('P0_COUNT', 'P1_COUNT'), lines[1:3]):
        if not re.fullmatch(prefix + r'=(0|[1-9][0-9]*)', line):
            raise Stop('Malformed critic count header')
        counts.append(int(line.split('=')[1]))
    passed = lines[0] == 'GATE=PASS'
    if passed and counts != [0, 0]:
        raise Stop('Critic PASS contradicts P0/P1 count')
    for prefix, line in zip(('ACTING_GATE', 'REDUCE_MOTION_GATE'), lines[3:5]):
        if not re.fullmatch(prefix + r'=(PASS|FAIL|NOT_VERIFIED)', line):
            raise Stop('Missing critic acting/motion assessment')
    acting, motion = (line.split('=')[1] for line in lines[3:5])
    if passed and (acting != 'PASS' or motion != 'PASS'):
        raise Stop('Overall PASS requires acting and reduced-motion PASS')
    return {'gate': lines[0][5:], 'p0': counts[0], 'p1': counts[1], 'acting_gate': acting, 'reduce_motion_gate': motion}


def check_summary(data, model):
    if not isinstance(data, dict) or data.get('title') != 'Test - WorldGameplay':
        raise Stop('Wrong xcresult scheme')
    if data.get('result') != 'Passed' or type(data.get('failedTests')) is not int or data['failedTests'] != 0:
        raise Stop('xcresult did not pass')
    if type(data.get('passedTests')) is not int or data['passedTests'] < 10:
        raise Stop('xcresult has no executed passing tests')
    devices = data.get('devicesAndConfigurations')
    if not isinstance(devices, list) or len(devices) != 1:
        raise Stop('Expected one untouched summary for one device')
    d = devices[0]
    if not isinstance(d, dict) or not isinstance(d.get('device'), dict):
        raise Stop('Malformed xcresult device')
    if d['device'].get('modelName') != model or d['device'].get('platform') != 'iOS Simulator':
        raise Stop('Wrong Simulator model/platform')
    if type(d.get('failedTests')) is not int or d['failedTests'] != 0 or type(d.get('passedTests')) is not int or d['passedTests'] < 10:
        raise Stop('Simulator tests not passing')
    return d['device']['deviceId']


def valid_png(path):
    data = Path(path).read_bytes()
    return len(data) > 4096 and data[:8] == b'\x89PNG\r\n\x1a\n' and data[12:16] == b'IHDR'


def check_tests(data, device_id):
    if not isinstance(data, dict) or not isinstance(data.get('testNodes'), list):
        raise Stop('Malformed raw test tree')
    devices = data.get('devices')
    if not isinstance(devices, list) or len(devices) != 1 or devices[0].get('deviceId') != device_id:
        raise Stop('Test tree device differs from summary')
    found = set()
    def visit(nodes, suites=()):
        for node in nodes:
            if not isinstance(node, dict):
                raise Stop('Malformed test node')
            name = node.get('name', '')
            identifier = node.get('nodeIdentifier', '')
            method = name.removesuffix('()')
            if node.get('nodeType') == 'Test Case' and method in REQUIRED_TESTS:
                belongs = 'WorldGameplayTests' in suites or 'WorldGameplayTests/' + name in identifier
                if not belongs or node.get('result') != 'Passed' or method in found:
                    raise Stop('Mandatory WorldGameplay test missing, duplicated or not passing: ' + method)
                found.add(method)
            children = node.get('children', [])
            if not isinstance(children, list):
                raise Stop('Malformed test children')
            visit(children, suites + (name,))
    visit(data['testNodes'])
    if found != REQUIRED_TESTS:
        raise Stop('Missing mandatory WorldGameplay tests: ' + ', '.join(sorted(REQUIRED_TESTS - found)))


def validate_acting_observations(root, data):
    """Validate observations exported by the real branch test, not a builder-authored proof."""
    if not isinstance(data, dict) or data.get('schema_version') != '1.1' or data.get('event_id') != 'bridge' or data.get('source_event_id') != 'workshop-2027' or data.get('character_id') != 'otter-acheng':
        raise Stop('Acting observations need schema 1.1, bridge presentation alias and workshop-2027 source event')
    if not isinstance(data.get('expression_catalog'), list) or set(data['expression_catalog']) != EXPRESSIONS or len(data['expression_catalog']) != 4:
        raise Stop('Acting observation lacks four-expression catalog')
    if not isinstance(data.get('pose_catalog'), list) or set(data['pose_catalog']) != POSES or len(data['pose_catalog']) != 3:
        raise Stop('Acting observation lacks three-pose catalog')
    states = data.get('states')
    if not isinstance(states, dict) or set(states) != set(ACTING_STATES):
        raise Stop('Acting observation requires three actual route states')
    asset_hashes = {}
    for state_id, (option, expression, pose, _) in ACTING_STATES.items():
        state = states[state_id]
        if not isinstance(state, dict) or state.get('event_id') != 'bridge' or state.get('option_id') != option:
            raise Stop('Acting event/option mismatch: ' + state_id)
        if state.get('pose_id') != pose or state.get('expression_id') not in ({expression} if expression else {'neutral', 'hopeful'}):
            raise Stop('Acting expression/pose mismatch: ' + state_id)
        if not isinstance(state.get('prop_id'), str) or not state['prop_id']:
            raise Stop('Acting observation lacks prop ID')
        ids = state.get('asset_ids')
        if not isinstance(ids, list) or not ids:
            raise Stop('Acting state lacks actually rendered asset IDs')
        for asset in ids:
            if not isinstance(asset, str) or not re.fullmatch(r'[A-Za-z0-9_-]+', asset):
                raise Stop('Invalid acting asset ID')
            folder = root / 'UIPrototype/WorldGameplay/Assets.xcassets' / (asset + '.imageset')
            content = json.loads(bounded_path(root, str((folder / 'Contents.json').relative_to(root))).read_text())
            images = [item['filename'] for item in content.get('images', []) if item.get('filename')]
            if not images:
                raise Stop('Acting asset has no image content: ' + asset)
            for filename in images:
                image = bounded_path(root, str((folder / filename).relative_to(root)))
                if not valid_png(image):
                    raise Stop('Acting asset is not a real PNG: ' + asset)
                asset_hashes[str(image.relative_to(root.resolve()))] = sha(image)
    if states['bridge-team']['prop_id'] == states['bridge-help']['prop_id']:
        raise Stop('Acting branch props must differ')
    return asset_hashes


def acting_attachment_name(manifest):
    matches = []
    for test in manifest:
        if 'WorldGameplayTests/testActingBranchesAreVisuallyDistinct' not in test.get('testIdentifier', ''):
            continue
        for item in test.get('attachments', []):
            if item.get('suggestedHumanReadableName', '').startswith('acting-state-observations'):
                matches.append(item.get('exportedFileName'))
    if len(matches) != 1:
        raise Stop('Exactly one branch-test acting observation attachment is required')
    return matches[0]


def read_acting_attachment(export):
    return bounded_path(export, acting_attachment_name(json.loads((export / 'manifest.json').read_text())))


def validate_acting_proof(root, proof, image_hashes):
    assets = validate_acting_observations(root, proof)
    if proof.get('asset_sha256') != assets:
        raise Stop('Acting proof asset binding differs from current UI images')
    if proof.get('contact_sheet') != 'artifacts/ui-loop/final/' + PNG_NAMES[5] or proof.get('contact_sheet_sha256') != image_hashes[PNG_NAMES[5]]:
        raise Stop('Acting contact sheet binding mismatch')
    if proof.get('reduced_motion_test') != 'testReducedMotionPreservesOutcome':
        raise Stop('Reduced-motion proof names the wrong executed test')
    for state_id, (_, _, _, png) in ACTING_STATES.items():
        state = proof['states'][state_id]
        if state.get('screenshot') != 'artifacts/ui-loop/final/' + png or state.get('screenshot_sha256') != image_hashes[png]:
            raise Stop('Acting state screenshot binding mismatch')
    if len({image_hashes[PNG_NAMES[i]] for i in (0, 1, 2)}) != 3:
        raise Stop('Acting route screenshots are byte-identical')
    return True


def image_calls(path):
    """Only completed tool events count; agent text mentioning a tool does not."""
    viewed = set()
    for line in Path(path).read_text().splitlines():
        event = json.loads(line)
        if event.get('type') != 'item.completed':
            continue
        item = event.get('item', {})
        kind = item.get('type', '')
        if kind in ('agent_message', 'reasoning', 'error'):
            continue
        payload = json.dumps(item, ensure_ascii=False)
        if kind in ('tool_call', 'mcp_tool_call', 'custom_tool_call', 'function_call', 'tool_execution') and 'view_image' in payload:
            viewed.update(re.findall(r'/[^\s"\\]+\.png', payload))
    return viewed


def terminate_group(pid):
    try:
        os.killpg(pid, signal.SIGTERM)
    except ProcessLookupError:
        return
    time.sleep(0.2)
    try:
        os.killpg(pid, signal.SIGKILL)
    except ProcessLookupError:
        pass
    except PermissionError:
        # macOS may report EPERM for a process group containing only terminated zombies.
        rows = subprocess.check_output(['ps', '-axo', 'pgid=,stat='], text=True, timeout=2).splitlines()
        if any(row.split()[0] == str(pid) and not row.split()[1].startswith('Z') for row in rows if len(row.split()) >= 2):
            raise Stop('Unable to terminate owned live process group')


def watch_child(parent, child, deadline, ledger, sim_script):
    # Independent session: survives SIGKILL/crash of the supervisor. No arbitrary deletion.
    while os.getppid() == parent and time.time() < deadline:
        time.sleep(0.25)
    terminate_group(child)
    if Path(ledger).exists():
        try:
            subprocess.run([sys.executable, sim_script, '--cleanup-only', '--owned-ledger', ledger], timeout=60)
        except (OSError, subprocess.TimeoutExpired):
            pass  # Ledger remains owned for the next supervised sweep.


class Runner:
    def __init__(self, root, control, deadline):
        self.root, self.control, self.deadline = root, control, deadline
        self.ledger = control / 'owned-simulators.json'
        self.sim_script = root / 'tools/ui/run-simulator-tests.py'
        self.children = set()

    def remaining(self):
        return self.deadline - time.time()

    def run(self, args, tag, cap=90, cwd=None, prompt=None, reserve=15):
        seconds = min(cap, self.remaining() - max(reserve, 60))
        if seconds <= 0:
            raise Stop('Absolute deadline reached')
        out = self.control / (tag + '.stdout.log'); err = self.control / (tag + '.stderr.log')
        self.control.mkdir(parents=True, exist_ok=True)
        guardian = None
        with out.open('w') as stdout, err.open('w') as stderr:
            child = subprocess.Popen([str(a) for a in args], cwd=cwd or self.root, text=True,
                                     stdin=subprocess.PIPE if prompt is not None else subprocess.DEVNULL,
                                     stdout=stdout, stderr=stderr, start_new_session=True)
            self.children.add(child.pid)
            try:
                guardian = subprocess.Popen([sys.executable, str(Path(__file__).resolve()), '--watch-child',
                                             str(os.getpid()), str(child.pid), str(self.deadline - 45),
                                             str(self.ledger), str(self.sim_script)], start_new_session=True,
                                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                child.communicate(input=prompt, timeout=seconds)
                if child.returncode:
                    raise Stop(f'{tag} failed exit={child.returncode}; see {err}')
            except subprocess.TimeoutExpired as exc:
                raise Stop(f'{tag} exceeded bounded timeout') from exc
            finally:
                terminate_group(child.pid)
                child.wait(timeout=5)
                self.children.discard(child.pid)
                if guardian:
                    terminate_group(guardian.pid)
                    guardian.wait(timeout=5)
        return out

    def git(self, *args):
        return self.run(['git', *args], 'git-' + str(time.time_ns()), cap=45).read_text().strip()

    def cleanup(self):
        for pid in self.children.copy():
            terminate_group(pid)
        if self.ledger.exists():
            subprocess.run([sys.executable, str(self.sim_script), '--cleanup-only', '--owned-ledger', str(self.ledger)],
                           cwd=self.root, timeout=60, check=True)

    def inventory(self):
        names = self.git('ls-files', '-z', '--cached', '--others', '--exclude-standard').split('\0')
        return {name: sha(self.root / name) if (self.root / name).is_file() else 'MISSING'
                for name in names if name}

    def identity(self, branch, base):
        if self.git('branch', '--show-current') != branch or not branch.startswith('codex/ui-visual-loop-'):
            raise Stop('Unexpected branch')
        if self.git('rev-parse', '--show-toplevel') != str(self.root):
            raise Stop('Unexpected worktree root')
        if self.git('rev-parse', base + '^{commit}') != base:
            raise Stop('Base must be an exact commit SHA')
        self.git('merge-base', '--is-ancestor', base, 'HEAD')

    def cli(self, prompt, tag, builder=False, images=None):
        sandbox = self.control / 'builder-sandbox'; sandbox.mkdir(exist_ok=True)
        output = self.control / (tag + '.md')
        args = ['codex', 'exec', '--ephemeral', '--json', '--color', 'never', '-c', 'approval_policy="never"',
                '-c', 'sandbox_workspace_write.network_access=false',
                '-c', 'sandbox_workspace_write.exclude_tmpdir_env_var=true',
                '-c', 'sandbox_workspace_write.exclude_slash_tmp=true',
                '--sandbox', 'workspace-write' if builder else 'read-only', '--output-last-message', str(output)]
        if builder:
            args += ['--skip-git-repo-check']
            for name in WRITABLE:
                path = self.root / name
                if not path.is_dir() or path.is_symlink():
                    raise Stop('Missing/unsafe writable root: ' + name)
                args += ['--add-dir', str(path)]
        inputs = {name: {'path': str(Path(path).resolve()), 'sha256': sha(path)} for name, path in (images or {}).items()}
        for image in inputs.values():
            args += ['--image', image['path']]
        args += ['-']
        invoked = now()
        log = self.run(args, tag, cap=1800 if builder else 720, cwd=sandbox if builder else self.root,
                       prompt=prompt, reserve=RESERVE if builder else 30)
        if not output.is_file():
            raise Stop('CLI returned without final output')
        receipt = self.control / (tag + '.input.json')
        write_json(receipt, {'tag': tag, 'started_at': invoked, 'finished_at': now(), 'exit_code': 0,
                             'image_inputs': inputs, 'argv': args, 'transcript_sha256': sha(log)})
        return output, log

    def validate(self, number):
        before = source_hashes(self.root)
        folder = self.control / f'round-{number:02d}'; folder.mkdir(exist_ok=True)
        checks = []
        def check(args, tag, cap):
            log = self.run(args, tag, cap=cap)
            checks.append({'kind': tag.split(f'round-{number:02d}-', 1)[-1], 'command': [str(x) for x in args], 'exit_code': 0, 'stdout': str(log), 'stdout_sha256': sha(log),
                           'stderr': str(self.control / (tag + '.stderr.log')), 'stderr_sha256': sha(self.control / (tag + '.stderr.log'))})
            return log
        check(['swift', 'test'], f'round-{number:02d}-swift', 300)
        flow = folder / 'flow-check'
        check(['xcrun', 'swiftc', '-parse-as-library', 'UIPrototype/WorldGameplay/WorldModels.swift',
                  'tools/ui/check-world-flow.swift', '-o', str(flow)], f'round-{number:02d}-flow-build', 90)
        check([flow], f'round-{number:02d}-flow', 60)
        check(['swift', 'assets/gameplay/inspect-alpha.swift'], f'round-{number:02d}-alpha', 90)
        provenance = validate_provenance(self.root)
        provenance_log = folder / 'provenance.json'; write_json(provenance_log, provenance)
        provenance_error = folder / 'provenance.stderr.log'; provenance_error.write_text('')
        checks.append({'kind': 'provenance', 'command': ['supervisor:validate_provenance'], 'exit_code': 0,
                       'stdout': str(provenance_log), 'stdout_sha256': sha(provenance_log),
                       'stderr': str(provenance_error), 'stderr_sha256': sha(provenance_error)})
        summaries = []; exports = []; observations = []
        for label, model, suffix in (('standard', MODEL_NAMES[0], 'iPhone-17'), ('narrow', MODEL_NAMES[1], 'iPhone-SE-3rd-generation')):
            bundle = folder / (label + '.xcresult')
            self.run([sys.executable, self.sim_script, '--scheme', 'WorldGameplay', '--device-type', suffix,
                      '--result-bundle', bundle, '--owned-ledger', self.ledger,
                      '--deadline', dt.datetime.fromtimestamp(self.deadline - 15, dt.timezone.utc).isoformat()],
                     f'round-{number:02d}-{label}-ui', cap=900)
            raw = self.run(['xcrun', 'xcresulttool', 'get', 'test-results', 'summary', '--path', bundle],
                           f'round-{number:02d}-{label}-summary', cap=60)
            data = json.loads(raw.read_text()); device_id = check_summary(data, model)
            target = folder / (label + '-summary.json'); shutil.copyfile(raw, target)
            tree_raw = self.run(['xcrun', 'xcresulttool', 'get', 'test-results', 'tests', '--path', bundle],
                                f'round-{number:02d}-{label}-tests', cap=60)
            check_tests(json.loads(tree_raw.read_text()), device_id)
            tree_target = folder / (label + '-tests.json'); shutil.copyfile(tree_raw, tree_target)
            summaries.append({'path': str(target), 'sha256': sha(target), 'tests_path': str(tree_target),
                              'tests_sha256': sha(tree_target), 'model': model, 'bundle': str(bundle)})
            export = folder / label
            self.run([sys.executable, 'tools/ui/export-world-evidence.py', bundle, export],
                     f'round-{number:02d}-{label}-export', cap=90)
            exports.append(export)
            raw_export = folder / (label + '-attachments')
            self.run(['xcrun', 'xcresulttool', 'export', 'attachments', '--path', bundle, '--output-path', raw_export],
                     f'round-{number:02d}-{label}-acting-export', cap=90)
            attachment = read_acting_attachment(raw_export)
            observed = json.loads(attachment.read_text()); validate_acting_observations(self.root, observed)
            observations.append({'path': str(attachment), 'sha256': sha(attachment), 'device_id': device_id,
                                 'manifest_path': str(raw_export / 'manifest.json'), 'manifest_sha256': sha(raw_export / 'manifest.json'),
                                 'exported_filename': attachment.name,
                                 'test_id': 'WorldGameplayTests/testActingBranchesAreVisuallyDistinct()'})
        if before != source_hashes(self.root):
            raise Stop('Source changed during supervisor validation')
        mapping = {PNG_NAMES[0]: exports[0] / '01-world-home.png',
                   PNG_NAMES[1]: exports[0] / '02-team-reaction.png',
                   PNG_NAMES[2]: exports[0] / '04-help-reaction-cat-teacher.png',
                   PNG_NAMES[3]: exports[1] / '01-world-home.png',
                   PNG_NAMES[4]: exports[1] / 'accessibility-home.png',
                   PNG_NAMES[5]: exports[0] / 'acting-contact-sheet.png'}
        sheet_records = [record for record in json.loads((exports[0] / 'manifest.json').read_text())
                         if record.get('file') == 'acting-contact-sheet.png'
                         and 'WorldGameplayTests/testActingContactSheetShowsCatalog' in record.get('testIdentifier', '')]
        if len(sheet_records) != 1:
            raise Stop('Acting contact sheet must come from its actual catalog UI test')
        images = folder / 'final'; images.mkdir(exist_ok=True)
        for name, src in mapping.items():
            if not src.is_file() or not valid_png(src):
                raise Stop('Missing real named XCTest screenshot: ' + str(src))
            shutil.copyfile(src, images / name)
        extras = {}
        large_reaction = exports[1] / 'accessibility-reaction.png'
        if large_reaction.is_file() and valid_png(large_reaction):
            shutil.copyfile(large_reaction, images / EXTRA_IMAGE)
            extras[EXTRA_IMAGE] = str(images / EXTRA_IMAGE)
        observed = [json.loads(Path(record['path']).read_text()) for record in observations]
        if observed[0] != observed[1]:
            raise Stop('Acting observations differ across Simulator models')
        proof = observed[0]
        proof.update(contact_sheet='artifacts/ui-loop/final/' + PNG_NAMES[5], contact_sheet_sha256=sha(images / PNG_NAMES[5]),
                     reduced_motion_test='testReducedMotionPreservesOutcome', asset_sha256=validate_acting_observations(self.root, proof))
        for state_id, (_, _, _, png) in ACTING_STATES.items():
            proof['states'][state_id].update(screenshot='artifacts/ui-loop/final/' + png, screenshot_sha256=sha(images / png))
        proof_path = folder / 'acting-state-proof.json'; write_json(proof_path, proof)
        validate_acting_proof(self.root, proof, {n: sha(images / n) for n in PNG_NAMES})
        return {'source_sha256': before, 'checks': checks, 'summaries': summaries, 'extra_images': extras,
                'acting_observations': observations, 'acting_proof': str(proof_path), 'acting_proof_sha256': sha(proof_path),
                'extra_image_sha256': {n: sha(p) for n, p in extras.items()}, 'images': {n: str(images / n) for n in PNG_NAMES},
                'image_sha256': {n: sha(images / n) for n in PNG_NAMES}, 'validated_at': now()}

    def critic(self, number, evidence):
        images = dict(evidence['images'], **evidence.get('extra_images', {}))
        prompt = f'''You are a strictly read-only independent visual UX critic. Repository: {self.root}.
Read docs/ui-loop/STYLE_GUIDE.md, CHARACTER_ACTING_SPEC.md, ACTING_IMPLEMENTATION.md and PROGRESS.md. The six required PNGs including acting contact sheet and available maximum-text outcome are attached using CLI --image. Inspect every image, not filenames or source code alone.
Compare against baseline artifacts/gameplay/screenshots/standard/01-world-home.png and prior critic reports.
Review character scale, first-screen decisions, teen suitability, two visibly different consequences, narrow and maximum text layout, CTA reachability.
Only inspect, do not modify any file, commit, run tests or generate assets. First five lines of final output MUST be exactly:
GATE=PASS or GATE=FAIL or GATE=NOT_VERIFIED
P0_COUNT=<nonnegative integer>
P1_COUNT=<nonnegative integer>
ACTING_GATE=PASS or ACTING_GATE=FAIL or ACTING_GATE=NOT_VERIFIED
REDUCE_MOTION_GATE=PASS or REDUCE_MOTION_GATE=FAIL or REDUCE_MOTION_GATE=NOT_VERIFIED
PASS requires all six images inspected, no P0/P1, all choices/CTA reachable, four distinct expressions and three actual poses visible in the contact sheet, consistent identity anchors and visibly different hand/body/prop interactions across both played branches. Text labels, emoji, image hash differences or unchanged smiling portraits are not proof of acting.
Inspect actual SwiftUI presentation and reduced-motion test plus supervisor observations at {evidence['acting_proof']}. Ten required tests passed separately on each Simulator. Reduced-motion gate is an engineering observation, not a claim of a video or real-device check; verify final acting state is preserved without animation delay. Report boundaries clearly.
If any attached image cannot be seen, use NOT_VERIFIED. Then list precise evidence and at most three fixes; distinguish subjective judgment from test facts.
For each P0 finding include a stable line P0_ID=short-lowercase-hyphenated-id. Reuse that ID if the same defect persists.
Round {number}; images: {json.dumps(images, ensure_ascii=False)}
'''
        before = self.inventory()
        report, log = self.cli(prompt, f'critic-{number:02d}', images=images)
        if before != self.inventory():
            raise Stop('Read-only critic changed repo files')
        decision = parse_critic(report.read_text())
        p0_ids = sorted(set(re.findall(r'^P0_ID=([a-z0-9-]+)$', report.read_text(), re.MULTILINE)))
        if len(p0_ids) != decision['p0']:
            raise Stop('Critic P0 findings must have stable P0_ID lines')
        thread_ids = [json.loads(line).get('thread_id') for line in log.read_text().splitlines()
                      if json.loads(line).get('type') == 'thread.started']
        if len(thread_ids) != 1 or not thread_ids[0]:
            raise Stop('Missing genuine CLI thread.started event')
        return dict(decision, report=str(report), transcript=str(log),
                    input_receipt=str(self.control / f'critic-{number:02d}.input.json'), thread_id=thread_ids[0],
                    p0_ids=p0_ids, source_sha256=evidence['source_sha256'], image_sha256=evidence['image_sha256'], extra_image_sha256=evidence.get('extra_image_sha256', {}), reviewed_at=now())


def gate(root, receipt):
    try:
        return _gate(root, receipt)
    except (ValueError, TypeError, KeyError, AttributeError, OSError) as exc:
        raise Stop("Malformed receipt/evidence: " + str(exc)) from exc


def _gate(root, receipt):
    if not isinstance(receipt, dict) or receipt.get('version') != VERSION or receipt.get('result') != 'PASS':
        raise Stop('Malformed/incomplete supervisor receipt')
    if receipt.get('source_sha256') != source_hashes(root):
        raise Stop('Current source differs from validated source')
    images = receipt.get('image_sha256')
    if not isinstance(images, dict) or set(images) != set(PNG_NAMES):
        raise Stop('Expected six final PNG hashes')
    for name, digest in images.items():
        path = root / 'artifacts/ui-loop/final' / name
        if not path.is_file() or not valid_png(path) or sha(path) != digest:
            raise Stop('Final image hash mismatch: ' + name)
    summaries = receipt.get('summaries')
    if not isinstance(summaries, list) or len(summaries) != 2:
        raise Stop('Two independent raw xcresult summaries required')
    devices = []
    for record, model in zip(summaries, MODEL_NAMES):
        if not isinstance(record, dict):
            raise Stop('Malformed xcresult record')
        p = bounded_path(root, record.get('path'))
        if sha(p) != record.get('sha256'):
            raise Stop('Summary hash mismatch')
        device_id = check_summary(json.loads(p.read_text()), model)
        tree = bounded_path(root, record.get('tests_path'))
        if sha(tree) != record.get('tests_sha256'):
            raise Stop('Raw test tree hash mismatch')
        check_tests(json.loads(tree.read_text()), device_id)
        devices.append(device_id)
    if len(set(devices)) != 2:
        raise Stop('Two independent devices required')
    acting = receipt.get('acting_state')
    if not isinstance(acting, dict):
        raise Stop('Missing supervisor acting proof')
    proof_path = bounded_path(root, acting.get('path'))
    if sha(proof_path) != acting.get('sha256'):
        raise Stop('Acting proof hash mismatch')
    proof = json.loads(proof_path.read_text()); validate_acting_proof(root, proof, images)
    observations = acting.get('observations')
    if not isinstance(observations, list) or len(observations) != 2:
        raise Stop('Two real Simulator acting observations are required')
    observed_data = []
    for record, device_id in zip(observations, devices):
        raw = bounded_path(root, record.get('path'))
        if sha(raw) != record.get('sha256') or record.get('device_id') != device_id or record.get('test_id') != 'WorldGameplayTests/testActingBranchesAreVisuallyDistinct()':
            raise Stop('Acting observation hash/device/test mismatch')
        manifest = bounded_path(root, record.get('manifest_path'))
        if sha(manifest) != record.get('manifest_sha256') or acting_attachment_name(json.loads(manifest.read_text())) != record.get('exported_filename'):
            raise Stop('Acting attachment origin manifest mismatch')
        data = json.loads(raw.read_text()); validate_acting_observations(root, data); observed_data.append(data)
        for state_id in ACTING_STATES:
            for key in ('event_id', 'option_id', 'expression_id', 'pose_id', 'prop_id', 'asset_ids'):
                if proof['states'][state_id].get(key) != data['states'][state_id].get(key):
                    raise Stop('Acting proof differs from observed UI state')
    if observed_data[0] != observed_data[1]:
        raise Stop('Acting observations differ between devices')
    cleanup = receipt.get('simulator_cleanup')
    if not isinstance(cleanup, dict):
        raise Stop('Missing owned Simulator cleanup receipt')
    ledger_path = bounded_path(root, cleanup.get('path'))
    if sha(ledger_path) != cleanup.get('sha256'):
        raise Stop('Cleanup ledger hash mismatch')
    ledger = json.loads(ledger_path.read_text())
    if not isinstance(ledger, dict) or ledger.get('version') != 1 or not isinstance(ledger.get('devices'), list):
        raise Stop('Malformed cleanup ledger')
    owned = {str(uuid.UUID(d['uuid'])).upper() for d in ledger['devices'] if isinstance(d, dict) and d.get('status') == 'deleted'}
    if len(owned) != len(ledger['devices']) or not set(str(uuid.UUID(d)).upper() for d in devices).issubset(owned):
        raise Stop('Test devices were not all confirmed deleted')
    if any(c.get('status') != 'recorded' for c in ledger.get('creates', [])):
        raise Stop('Unresolved owned creation intent')
    checks = receipt.get('checks')
    if not isinstance(checks, list) or {c.get('kind') for c in checks if isinstance(c, dict)} != {'swift', 'flow-build', 'flow', 'alpha', 'provenance'}:
        raise Stop('Missing supervisor Swift/flow/alpha command evidence')
    for check in checks:
        if not isinstance(check, dict) or check.get('exit_code') != 0:
            raise Stop('Supervisor check did not pass')
        for kind in ('stdout', 'stderr'):
            if sha(bounded_path(root, check.get(kind))) != check.get(kind + '_sha256'):
                raise Stop('Supervisor command evidence hash mismatch')
    critics = receipt.get('critics')
    if not isinstance(critics, list) or len(critics) < 2:
        raise Stop('At least two actual independent critic executions required')
    for critic in critics:
        if not isinstance(critic, dict):
            raise Stop('Malformed critic record')
        report = bounded_path(root, critic.get('report')); transcript = bounded_path(root, critic.get('transcript'))
        if sha(report) != critic.get('report_sha256') or sha(transcript) != critic.get('transcript_sha256'):
            raise Stop('Critic evidence hash mismatch')
        parse_critic(report.read_text())
        inputs_path = bounded_path(root, critic.get('input_receipt'))
        if sha(inputs_path) != critic.get('input_receipt_sha256'):
            raise Stop('Image input receipt hash mismatch')
        inputs = json.loads(inputs_path.read_text())
        if not isinstance(inputs, dict) or inputs.get('exit_code') != 0 or inputs.get('transcript_sha256') != sha(transcript):
            raise Stop('Incomplete real critic execution receipt')
        image_inputs = inputs.get('image_inputs')
        if not isinstance(image_inputs, dict) or not set(PNG_NAMES).issubset(image_inputs) or set(image_inputs) - set(PNG_NAMES) - {EXTRA_IMAGE}:
            raise Stop('Six actual image inputs required')
        if {name: item.get('sha256') for name, item in image_inputs.items()} != dict(critic.get('image_sha256', {}), **critic.get('extra_image_sha256', {})):
            raise Stop('Critic image inputs differ from reviewed images')
        argv = inputs.get('argv', [])
        for item in image_inputs.values():
            if not any(argv[i] == '--image' and argv[i + 1] == item.get('path') for i in range(len(argv) - 1)):
                raise Stop('Image was not attached to CLI')
        thread_ids = [json.loads(line).get('thread_id') for line in transcript.read_text().splitlines() if json.loads(line).get('type') == 'thread.started']
        if thread_ids != [critic.get('thread_id')] or not thread_ids[0]:
            raise Stop('Critic thread receipt mismatch')
    if len({c['thread_id'] for c in critics}) < 2:
        raise Stop('Critic executions are not independent')
    latest = critics[-1]
    parsed = parse_critic(bounded_path(root, latest['report']).read_text())
    if parsed != {'gate': 'PASS', 'p0': 0, 'p1': 0, 'acting_gate': 'PASS', 'reduce_motion_gate': 'PASS'} or latest.get('gate') != 'PASS':
        raise Stop('Latest critic is not PASS with P0/P1 zero')
    if latest.get('source_sha256') != receipt['source_sha256'] or latest.get('image_sha256') != images:
        raise Stop('Critic did not review current final source/images')
    extras = receipt.get('extra_image_sha256', {})
    if not isinstance(extras, dict) or latest.get('extra_image_sha256', {}) != extras:
        raise Stop('Extra reviewed image mismatch')
    for name, digest in extras.items():
        if name != EXTRA_IMAGE or sha(root / 'artifacts/ui-loop/final' / name) != digest:
            raise Stop('Extra final image hash mismatch')
    for name in ('STYLE_GUIDE.md', 'PROGRESS.md', 'FINAL_REVIEW.md', 'ACTING_IMPLEMENTATION.md', 'CHARACTER_ACTING_SPEC.md'):
        if not (root / 'docs/ui-loop' / name).is_file():
            raise Stop('Missing required document ' + name)
    return True


def publish_snapshot(runner, state):
    root = runner.root; destination = root / 'artifacts/ui-loop'; destination.mkdir(parents=True, exist_ok=True)
    if not state.get('validated') or not state['validated'].get('acting_proof'):
        write_json(destination / 'runner-status.json', state); return False
    evidence = state['validated']; (destination / 'final').mkdir(exist_ok=True)
    proof_target = destination / 'acting-state-proof.json'; shutil.copyfile(evidence['acting_proof'], proof_target)
    observation_records = []
    for i, record in enumerate(evidence['acting_observations']):
        target = destination / f'acting-observations-{i + 1}.json'; shutil.copyfile(record['path'], target)
        manifest_target = destination / f'acting-attachments-{i + 1}.json'; shutil.copyfile(record['manifest_path'], manifest_target)
        observation_records.append(dict(record, path=str(target.relative_to(root)), manifest_path=str(manifest_target.relative_to(root))))
    acting = {'path': str(proof_target.relative_to(root)), 'sha256': sha(proof_target), 'observations': observation_records}
    for name, path in dict(evidence['images'], **evidence.get('extra_images', {})).items():
        shutil.copyfile(path, destination / 'final' / name)
    summaries = []
    for i, item in enumerate(evidence['summaries']):
        p = destination / f'xcresult-{i + 1}.json'; shutil.copyfile(item['path'], p)
        tree = destination / f'xcresult-{i + 1}-tests.json'; shutil.copyfile(item['tests_path'], tree)
        summaries.append(dict(item, path=str(p.relative_to(root)), tests_path=str(tree.relative_to(root))))
    checks = []
    for i, item in enumerate(evidence.get('checks', [])):
        record = dict(item)
        for kind in ('stdout', 'stderr'):
            target = destination / f'check-{i + 1:02d}.{kind}.log'
            shutil.copyfile(record[kind], target); record[kind] = str(target.relative_to(root))
        checks.append(record)
    critics = []
    for i, critic in enumerate(state['critics']):
        c = dict(critic)
        for key in ('report', 'transcript', 'input_receipt'):
            suffix = {'report': 'md', 'transcript': 'jsonl', 'input_receipt': 'input.json'}[key]
            target = destination / f'critic-{i + 1:02d}.{suffix}'
            shutil.copyfile(c[key], target); c[key] = str(target.relative_to(root)); c[key + '_sha256'] = sha(target)
        critics.append(c)
    cleanup = None
    if runner.ledger.exists():
        ledger_target = destination / 'simulator-cleanup.json'
        shutil.copyfile(runner.ledger, ledger_target)
        cleanup = {'path': str(ledger_target.relative_to(root)), 'sha256': sha(ledger_target)}
    receipt = dict(version=VERSION, acting_state=acting, simulator_cleanup=cleanup, result='PASS' if state.get('execution') == 'finished' and not state.get('cleanup_error') and not state.get('validation_error') else 'PARTIAL', source_sha256=evidence['source_sha256'],
                   image_sha256=evidence['image_sha256'], extra_image_sha256=evidence.get('extra_image_sha256', {}), summaries=summaries, critics=critics, checks=checks,
                   deadline=state['deadline'], started_at=state['started_at'], worktree=str(root), branch=state['branch'], base_commit=state['base_commit'], builder_count=len(state['rounds']),
                   not_claimed=['real iPhone', 'child playtest', 'commercial asset approval', 'release'])
    try:
        gate(root, receipt)
    except (Stop, ValueError, TypeError, KeyError, OSError) as exc:
        receipt['result'] = 'PARTIAL'; receipt['reason'] = str(exc)
    write_json(destination / 'verification.json', receipt)
    write_json(destination / 'runner-status.json', state)
    return receipt['result'] == 'PASS'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repo', type=Path, default=Path.cwd())
    parser.add_argument('--worktree', type=Path)
    parser.add_argument('--base-commit', required=True)
    parser.add_argument('--deadline', required=True)
    parser.add_argument('--control-dir', type=Path, default=Path('/tmp/lc-ui-loop-control'))
    parser.add_argument('--iterations', type=int, default=6)
    parser.add_argument('--no-push', action='store_true', default=True)
    parser.add_argument('--verify-only', action='store_true')
    args = parser.parse_args()
    if not re.fullmatch(r'[a-f0-9]{40}', args.base_commit) or not 1 <= args.iterations <= MAX_BUILDERS:
        parser.error('Exact 40-character base commit and 1..6 iterations required')
    deadline = utc(args.deadline)
    root = (args.worktree or args.repo).resolve(); control = args.control_dir.resolve()
    if control.is_relative_to(root):
        parser.error('Runtime control must be outside the worktree')
    control.mkdir(parents=True, exist_ok=True)
    with (control / 'runner.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        r = Runner(root, control, max(deadline, time.time() + 120) if args.verify_only else deadline)
        if not args.worktree:
            branch = 'codex/ui-visual-loop-' + dt.datetime.now(dt.timezone.utc).strftime('%Y%m%d-%H%M%S')
            target = root.parent / (root.name + '-' + branch.split('/')[-1])
            r.run(['git', 'worktree', 'add', '-b', branch, target, args.base_commit], 'create-worktree')
            root = target.resolve(); r.root = root; r.sim_script = root / 'tools/ui/run-simulator-tests.py'
        branch = r.git('branch', '--show-current'); r.identity(branch, args.base_commit)
        if args.verify_only:
            receipt = json.loads((root / 'artifacts/ui-loop/verification.json').read_text())
            if not isinstance(receipt, dict) or receipt.get('worktree') != str(root) or receipt.get('branch') != branch or receipt.get('base_commit') != args.base_commit or receipt.get('deadline') != args.deadline:
                raise Stop('Receipt worktree/branch/base/deadline mismatch')
            gate(root, receipt)
            r.git('diff', '--check'); print('VERIFIED current source, acting observations and six final images; no push performed'); return 0
        state_path = control / 'state.json'
        if state_path.exists():
            state = json.loads(state_path.read_text())
            if not isinstance(state, dict) or state.get('deadline') != args.deadline or state.get('base_commit') != args.base_commit or state.get('branch') != branch:
                raise Stop('Persistent deadline/base/branch mismatch; resume cannot reset budget')
            if state.get('worktree', str(root)) != str(root) or not isinstance(state.get('rounds'), list):
                raise Stop('Persistent worktree/round ledger mismatch')
        else:
            if not time.time() < deadline <= time.time() + 4 * 3600:
                raise Stop('New deadline must be within four hours of actual initialization')
            state = dict(started_at=now(),
                         deadline=args.deadline, base_commit=args.base_commit, branch=branch, rounds=[])
        if not 0 < deadline - utc(state['started_at']) <= 4 * 3600 or len(state['rounds']) > MAX_BUILDERS or any(not isinstance(v, dict) or v.get('number') != i + 1 for i, v in enumerate(state['rounds'])):
            raise Stop('Persistent budget exceeds four hours/six builders')
        state['worktree'] = str(root); state.setdefault('critics', []); state['version'] = VERSION
        state['execution'] = 'running'; state.pop('finished_at', None)
        write_json(state_path, state)
        try:
            r.cleanup()
            while len(state['rounds']) < args.iterations and r.remaining() > RESERVE + 120:
                n = len(state['rounds']) + 1
                before = r.inventory(); head = r.git('rev-parse', 'HEAD')
                state['rounds'].append({'number': n, 'started': now(), 'status': 'running'})
                write_json(state_path, state)
                instructions = f'''You are the UI builder for Life Crossroads. Repository to READ: {root}.
Your cwd is an isolated writable sandbox; actual writable repo paths ONLY: {json.dumps(WRITABLE)}.
Read repo AGENTS.md, PLAN.md, docs/ui-loop/AGENT_PROMPT.md (adopted instructions; source-kit is reference only), docs/ui-loop/CHARACTER_ACTING_SPEC.md, docs/ui-loop/STYLE_GUIDE.md and docs/ui-loop/PROGRESS.md plus latest critic reports below.
This bounded task is explicitly authorized. Do not update PLAN/memory, Domain/Data, Package, formal App, test runner or any other path. No commit, branch changes, network, package installation, paid API or permission escalation.
Implement one focused improvement toward the adopted acting v1.1 gate. Round {n} of at most {args.iterations}. Keep story fixture meaning, real WorldFlow event workshop-2027/options team/help (bridge is only the art/proof presentation alias), mandatory ten test method names and screenshot names including acting-contact-sheet. Use root-provided candidate art and SwiftUI layers; no invented image generation. Preserve assets/gameplay/va-* and matching prompts/manifest; do not redraw or delete them. Four expressions, three poses, actual initial/team/help presentation and Reduce Motion equivalence are required. Read tools/ui-loop/README.md for the exact acting-state-observations.json XCTest attachment contract; report actual actor accessibilityValue after each real UI choice, not manually authored expected state masquerading as observation.
Supervisor runs all Swift/UI tests and screenshots; do NOT run Simulator/xcodebuild or claim tests ran. Read existing baseline actual screenshots with view_image. Update only docs/ui-loop/PROGRESS.md and FINAL_REVIEW.md honestly with changes and unresolved issues. FINAL_REVIEW may remain partial.
Absolute deadline {args.deadline}; your maximum command time 30 minutes. Finish a reviewable change early.
Latest validation issue: {state.get('validation_error', 'none')}.
Latest critic: {json.dumps(state['critics'][-1:] if state['critics'] else [], ensure_ascii=False)}
'''
                r.cli(instructions, f'builder-{n:02d}', builder=True)
                after = r.inventory()
                changed = {p for p in set(before) | set(after) if before.get(p) != after.get(p)}
                illegal = [p for p in changed if not any(p == a or p.startswith(a + '/') for a in WRITABLE)]
                if illegal or head != r.git('rev-parse', 'HEAD'):
                    raise Stop('Builder crossed writable scope/commit boundary: ' + ', '.join(illegal))
                r.identity(branch, args.base_commit)
                state['rounds'][-1].update(status='built', changed=sorted(changed), finished=now()); write_json(state_path, state)
                try:
                    evidence = r.validate(n)
                except Stop as exc:
                    state['validation_error'] = str(exc)
                    state['rounds'][-1]['status'] = 'validation_failed'
                    write_json(state_path, state)
                    continue
                state.pop('validation_error', None)
                state['validated'] = evidence; write_json(state_path, state)
                critique = r.critic(n, evidence); state['critics'].append(critique)
                state['rounds'][-1].update(status='reviewed', critic_gate=critique['gate'])
                write_json(state_path, state)
                if critique['gate'] == 'PASS' and len(state['critics']) >= 2:
                    break
                if len(state['critics']) >= 2:
                    previous = state['critics'][-2]
                    repeated = set(previous.get('p0_ids', [])) & set(critique.get('p0_ids', []))
                    unchanged = previous.get('image_sha256') == critique.get('image_sha256') and previous.get('source_sha256') == critique.get('source_sha256')
                    if repeated or unchanged:
                        state['halt_reason'] = 'Repeated P0: ' + ', '.join(sorted(repeated)) if repeated else 'No verified change across two reviews'
                        break
            state['execution'] = 'finished'
        except (Stop, OSError, ValueError, TypeError, KeyError, InterruptedError) as exc:
            state['execution'] = 'stopped'; state['reason'] = str(exc)
            print('LOOP STOPPED:', exc, flush=True)
        finally:
            for sig in (signal.SIGTERM, signal.SIGINT):
                signal.signal(sig, signal.SIG_IGN)
            try:
                r.cleanup()
            except Exception as exc:
                state['execution'] = 'stopped'; state['cleanup_error'] = str(exc)
            state['finished_at'] = now(); write_json(state_path, state)
        ready = publish_snapshot(r, state)
        if state.get('execution') != 'finished' or state.get('cleanup_error'):
            ready = False
        print(json.dumps({'ready': ready, 'state': str(state_path), 'pushed': False}))
        return 0 if ready else 2


def interrupt(signum, frame):
    raise InterruptedError(f'Supervisor interrupted by signal {signum}')


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--watch-child':
        watch_child(int(sys.argv[2]), int(sys.argv[3]), float(sys.argv[4]), sys.argv[5], sys.argv[6])
    else:
        for sig in (signal.SIGTERM, signal.SIGINT):
            signal.signal(sig, interrupt)
        try:
            raise SystemExit(main())
        except (Stop, OSError, ValueError, TypeError, KeyError, InterruptedError) as exc:
            print('FAIL CLOSED:', exc, file=sys.stderr); raise SystemExit(2)
