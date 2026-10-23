"""Independent fail-closed invariants; no Codex network call or real Simulator."""
import importlib.util
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import tempfile
import time
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('loop', Path(__file__).with_name('run_ui_loop.py'))
loop = importlib.util.module_from_spec(spec); spec.loader.exec_module(loop)
spec = importlib.util.spec_from_file_location('sim', Path(__file__).parents[1] / 'ui/run-simulator-tests.py')
sim = importlib.util.module_from_spec(spec); spec.loader.exec_module(sim)


def summary(model='iPhone 17'):
    return {'title': 'Test - WorldGameplay', 'result': 'Passed', 'failedTests': 0, 'passedTests': 10,
            'devicesAndConfigurations': [{'device': {'modelName': model, 'platform': 'iOS Simulator', 'deviceId': 'test-device'},
                                           'failedTests': 0, 'passedTests': 10}]}


class Gates(unittest.TestCase):
    def test_critic_requires_exact_head_and_zero_both_counts(self):
        self.assertEqual(loop.parse_critic('GATE=PASS\nP0_COUNT=0\nP1_COUNT=0\nACTING_GATE=PASS\nREDUCE_MOTION_GATE=PASS\nEvidence'), {'gate': 'PASS', 'p0': 0, 'p1': 0, 'acting_gate': 'PASS', 'reduce_motion_gate': 'PASS'})
        for text in ('prefix GATE=PASS\nP0_COUNT=0\nP1_COUNT=0', 'GATE=FAIL\nP0_COUNT=0\nP1_COUNT=0\nACTING_GATE=FAIL\nREDUCE_MOTION_GATE=PASS\nGATE=PASS',
                     'GATE=PASS\nP0_COUNT=0\nP1_COUNT=1', 'GATE=PASS\nP0_COUNT=0\nP1_COUNT=01'):
            if text.startswith('GATE=FAIL'):
                self.assertEqual(loop.parse_critic(text)['gate'], 'FAIL')
            else:
                with self.assertRaises(loop.Stop): loop.parse_critic(text)

    def test_two_raw_summaries_cannot_fake_wrong_scheme_or_device(self):
        self.assertEqual(loop.check_summary(summary(), 'iPhone 17'), 'test-device')
        for field, value in [('title', 'Test - EventFirst'), ('result', 'Failed'), ('failedTests', 1), ('passedTests', 0), ('devicesAndConfigurations', [])]:
            bad = summary(); bad[field] = value
            with self.assertRaises(loop.Stop): loop.check_summary(bad, 'iPhone 17')
        with self.assertRaises(loop.Stop): loop.check_summary(summary('iPhone SE (3rd generation)'), 'iPhone 17')
        with self.assertRaises(loop.Stop): loop.check_summary([], 'iPhone 17')

    def test_path_traversal_and_symlink_escape_rejected(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d) / 'repo'; root.mkdir(); outside = Path(d) / 'outside'; outside.write_text('x')
            (root / 'link').symlink_to(outside)
            for path in ('../outside', 'link', None):
                with self.assertRaises(loop.Stop): loop.bounded_path(root, path)

    def test_agent_claim_of_viewing_is_not_a_tool_call(self):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d) / 'log'
            p.write_text(json.dumps({'type': 'item.completed', 'item': {'type': 'agent_message', 'text': 'view_image /tmp/one.png'}}) + '\n')
            self.assertEqual(loop.image_calls(p), set())
            p.write_text(json.dumps({'type': 'item.completed', 'item': {'type': 'tool_call', 'name': 'view_image', 'arguments': {'path': '/tmp/one.png'}}}) + '\n')
            self.assertEqual(loop.image_calls(p), {'/tmp/one.png'})

    def receipt_fixture(self, root):
        final = root / 'artifacts/ui-loop/final'; final.mkdir(parents=True)
        docs = root / 'docs/ui-loop'; docs.mkdir(parents=True)
        for name in ('STYLE_GUIDE.md', 'PROGRESS.md', 'FINAL_REVIEW.md', 'ACTING_IMPLEMENTATION.md', 'CHARACTER_ACTING_SPEC.md'): (docs / name).write_text('fixture')
        for i, name in enumerate(loop.PNG_NAMES): (final / name).write_bytes(b'\x89PNG\r\n\x1a\n' + b'\x00\x00\x00\rIHDR' + bytes([i]) * 5000)
        hashes = {name: loop.sha(final / name) for name in loop.PNG_NAMES}
        summaries = []
        for i, model in enumerate(loop.MODEL_NAMES):
            p = root / f'summary-{i}.json'; value = summary(model)
            value['devicesAndConfigurations'][0]['device']['deviceId'] = f'11111111-2222-4333-8444-55555555555{i}'
            p.write_text(json.dumps(value))
            tree = root / f'tests-{i}.json'
            tree.write_text(json.dumps({'devices': [value['devicesAndConfigurations'][0]['device']],
                'testNodes': [{'name': 'WorldGameplayTests', 'nodeType': 'Test Suite', 'children': [
                    {'name': name + '()', 'nodeType': 'Test Case', 'result': 'Passed'} for name in loop.REQUIRED_TESTS]}]}))
            summaries.append({'path': p.name, 'sha256': loop.sha(p), 'tests_path': tree.name, 'tests_sha256': loop.sha(tree)})
        asset_folder = root / 'UIPrototype/WorldGameplay/Assets.xcassets/fixture-actor.imageset'
        asset_folder.mkdir(parents=True)
        asset = asset_folder / 'actor.png'; asset.write_bytes((final / loop.PNG_NAMES[0]).read_bytes())
        (asset_folder / 'Contents.json').write_text(json.dumps({'images': [{'filename': 'actor.png'}]}))
        observations = {'schema_version': '1.1', 'event_id': 'bridge', 'source_event_id': 'workshop-2027', 'character_id': 'otter-acheng',
            'expression_catalog': ['neutral', 'thinking', 'hopeful', 'tired'],
            'pose_catalog': ['idle', 'collaborating', 'asking'], 'states': {}}
        for state_id, option, expression, pose, prop in (
            ('bridge-initial', None, 'thinking', 'idle', 'materials'),
            ('bridge-team', 'team', 'hopeful', 'collaborating', 'prototype'),
            ('bridge-help', 'help', 'neutral', 'asking', 'tools-list')):
            observations['states'][state_id] = {'event_id': 'bridge', 'option_id': option,
                'expression_id': expression, 'pose_id': pose, 'prop_id': prop, 'asset_ids': ['fixture-actor']}
        observation_records = []
        for i in range(2):
            raw = root / f'observations-{i}.json'; raw.write_text(json.dumps(observations))
            manifest = root / f'attachments-{i}.json'
            manifest.write_text(json.dumps([{'testIdentifier': 'WorldGameplayTests/testActingBranchesAreVisuallyDistinct()',
                'attachments': [{'suggestedHumanReadableName': 'acting-state-observations.json', 'exportedFileName': raw.name}]}]))
            observation_records.append({'path': raw.name, 'sha256': loop.sha(raw),
                'manifest_path': manifest.name, 'manifest_sha256': loop.sha(manifest), 'exported_filename': raw.name,
                'device_id': f'11111111-2222-4333-8444-55555555555{i}',
                'test_id': 'WorldGameplayTests/testActingBranchesAreVisuallyDistinct()'})
        proof = json.loads(json.dumps(observations))
        proof.update(contact_sheet='artifacts/ui-loop/final/06-acting-contact-sheet.png',
            contact_sheet_sha256=hashes['06-acting-contact-sheet.png'],
            reduced_motion_test='testReducedMotionPreservesOutcome',
            asset_sha256={str(asset.relative_to(root)): loop.sha(asset)})
        for state_id, png in (('bridge-initial', '01-home.png'), ('bridge-team', '02-friend-outcome.png'), ('bridge-help', '03-teacher-outcome.png')):
            proof['states'][state_id].update(screenshot='artifacts/ui-loop/final/' + png, screenshot_sha256=hashes[png])
        proof_path = root / 'acting-state-proof.json'; proof_path.write_text(json.dumps(proof))
        acting = {'path': proof_path.name, 'sha256': loop.sha(proof_path), 'observations': observation_records}
        critics = []
        for i in range(2):
            report = root / f'critic-{i}.md'; report.write_text('GATE=PASS\nP0_COUNT=0\nP1_COUNT=0\nACTING_GATE=PASS\nREDUCE_MOTION_GATE=PASS\nfixture')
            log = root / f'critic-{i}.jsonl'; log.write_text(json.dumps({'type': 'thread.started', 'thread_id': f'fixture-{i}'}) + '\n')
            inputs = {name: {'path': str(final / name), 'sha256': hashes[name]} for name in loop.PNG_NAMES}
            argv = ['codex', 'exec']
            for image in inputs.values(): argv += ['--image', image['path']]
            input_path = root / f'input-{i}.json'
            input_path.write_text(json.dumps({'exit_code': 0, 'transcript_sha256': loop.sha(log), 'image_inputs': inputs, 'argv': argv}))
            critics.append({'gate': 'PASS', 'report': report.name, 'report_sha256': loop.sha(report), 'transcript': log.name,
                            'transcript_sha256': loop.sha(log), 'input_receipt': input_path.name, 'input_receipt_sha256': loop.sha(input_path),
                            'thread_id': f'fixture-{i}', 'source_sha256': loop.source_hashes(root), 'image_sha256': hashes})
        checks = []
        for i, kind in enumerate(('swift', 'flow-build', 'flow', 'alpha', 'provenance')):
            log = root / f'check-{i}.log'; log.write_text('fixture check pass')
            checks.append({'kind': kind, 'exit_code': 0, 'stdout': log.name, 'stderr': log.name, 'stdout_sha256': loop.sha(log), 'stderr_sha256': loop.sha(log)})
        cleanup = root / 'cleanup.json'
        cleanup.write_text(json.dumps({'version': 1, 'devices': [{'uuid': f'11111111-2222-4333-8444-55555555555{i}', 'status': 'deleted'} for i in range(2)], 'creates': []}))
        return {'version': 1, 'result': 'PASS', 'acting_state': acting, 'simulator_cleanup': {'path': cleanup.name, 'sha256': loop.sha(cleanup)}, 'checks': checks, 'source_sha256': loop.source_hashes(root), 'image_sha256': hashes,
                'summaries': summaries, 'critics': critics}

    def test_receipt_binds_current_source_images_two_threads_and_both_models(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); receipt = self.receipt_fixture(root)
            self.assertTrue(loop.gate(root, receipt))
            receipt['critics'] = receipt['critics'][:1]
            with self.assertRaises(loop.Stop): loop.gate(root, receipt)
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); receipt = self.receipt_fixture(root)
            (root / 'artifacts/ui-loop/final/01-home.png').write_bytes(b'changed')
            with self.assertRaises(loop.Stop): loop.gate(root, receipt)
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); receipt = self.receipt_fixture(root)
            (root / 'docs/ui-loop/STYLE_GUIDE.md').write_text('changed')
            with self.assertRaises(loop.Stop): loop.gate(root, receipt)

    def test_claiming_images_without_cli_attachment_is_rejected(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); receipt = self.receipt_fixture(root)
            item = receipt['critics'][-1]; p = root / item['input_receipt']
            data = json.loads(p.read_text()); data['argv'] = ['codex', 'exec']
            p.write_text(json.dumps(data)); item['input_receipt_sha256'] = loop.sha(p)
            with self.assertRaises(loop.Stop): loop.gate(root, receipt)

    def test_acting_catalog_or_rendered_asset_cannot_be_claimed_by_name_only(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); receipt = self.receipt_fixture(root)
            proof = json.loads((root / receipt['acting_state']['path']).read_text())
            proof['expression_catalog'].remove('tired')
            with self.assertRaisesRegex(loop.Stop, 'four-expression'): loop.validate_acting_observations(root, proof)
            proof['expression_catalog'].append('tired')
            proof['states']['bridge-help']['asset_ids'] = ['nonexistent-actor']
            with self.assertRaises(loop.Stop): loop.validate_acting_observations(root, proof)

    def test_proof_must_equal_observed_actual_ui_state(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); receipt = self.receipt_fixture(root)
            item = receipt['acting_state']; path = root / item['path']
            proof = json.loads(path.read_text()); proof['states']['bridge-help']['prop_id'] = 'invented-help-prop'
            path.write_text(json.dumps(proof)); item['sha256'] = loop.sha(path)
            with self.assertRaisesRegex(loop.Stop, 'differs from observed'): loop.gate(root, receipt)

    def test_nine_tests_or_missing_acting_critic_assessment_is_rejected(self):
        data = summary(); data['passedTests'] = 9
        with self.assertRaises(loop.Stop): loop.check_summary(data, 'iPhone 17')
        with self.assertRaises(loop.Stop): loop.parse_critic('GATE=PASS\nP0_COUNT=0\nP1_COUNT=0')
        with self.assertRaises(loop.Stop): loop.parse_critic('GATE=PASS\nP0_COUNT=0\nP1_COUNT=0\nACTING_GATE=NOT_VERIFIED\nREDUCE_MOTION_GATE=PASS')

    def test_observation_attachment_must_come_from_executed_branch_test(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); raw = root / 'observation.json'; raw.write_text('{}')
            attachment = {'suggestedHumanReadableName': 'acting-state-observations_0_123.json', 'exportedFileName': raw.name}
            (root / 'manifest.json').write_text(json.dumps([{'testIdentifier': 'Unrelated/testFake()', 'attachments': [attachment]}]))
            with self.assertRaises(loop.Stop): loop.read_acting_attachment(root)
            (root / 'manifest.json').write_text(json.dumps([{'testIdentifier': 'WorldGameplayTests/testActingBranchesAreVisuallyDistinct()', 'attachments': [attachment]}]))
            self.assertEqual(loop.read_acting_attachment(root), raw.resolve())

    def test_six_unrelated_passing_tests_do_not_replace_required_methods(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); receipt = self.receipt_fixture(root)
            item = receipt['summaries'][0]; p = root / item['tests_path']
            tree = json.loads(p.read_text())
            tree['testNodes'][0]['children'][0]['name'] = 'testUnrelated()'
            p.write_text(json.dumps(tree)); item['tests_sha256'] = loop.sha(p)
            with self.assertRaisesRegex(loop.Stop, 'Missing mandatory'): loop.gate(root, receipt)

    def test_skipped_required_method_and_wrong_device_are_rejected(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); receipt = self.receipt_fixture(root)
            item = receipt['summaries'][0]; p = root / item['tests_path']
            tree = json.loads(p.read_text())
            tree['testNodes'][0]['children'][0]['result'] = 'Skipped'
            with self.assertRaises(loop.Stop): loop.check_tests(tree, tree['devices'][0]['deviceId'])
            tree['testNodes'][0]['children'][0]['result'] = 'Passed'
            with self.assertRaisesRegex(loop.Stop, 'device differs'): loop.check_tests(tree, 'different-device')

    def test_malformed_receipt_is_never_ready(self):
        with tempfile.TemporaryDirectory() as d:
            for receipt in ([], None, {}, {'version': 1, 'result': 'PASS', 'source_sha256': {}}):
                with self.assertRaises(loop.Stop): loop.gate(Path(d), receipt)

    def test_expired_absolute_deadline_starts_no_child(self):
        with tempfile.TemporaryDirectory() as d:
            r = loop.Runner(Path(d), Path(d), time.time() - 1)
            with patch.object(subprocess, 'Popen') as popen:
                with self.assertRaises(loop.Stop): r.run(['does-not-exist'], 'expired')
                popen.assert_not_called()

    def test_timeout_terminates_descendant_process_group(self):
        with tempfile.TemporaryDirectory() as d:
            path = Path(d); pidfile = path / 'grandchild'
            r = loop.Runner(path, path, time.time() + 120)
            code = 'import subprocess,time; p=subprocess.Popen(["sleep","30"]); open(' + repr(str(pidfile)) + ',"w").write(str(p.pid)); time.sleep(30)'
            with self.assertRaises(loop.Stop): r.run([sys.executable, '-c', code], 'timeout', cap=0.4, reserve=0)
            pid = int(pidfile.read_text())
            # A reaped process is absent; an unreaped terminated zombie is also no longer running.
            result = subprocess.run(['ps', '-o', 'stat=', '-p', str(pid)], capture_output=True, text=True)
            self.assertTrue(result.returncode != 0 or result.stdout.strip().startswith('Z'), result.stdout)

    def test_source_hashes_detect_changed_ui_but_ignore_runtime_outputs(self):
        with tempfile.TemporaryDirectory() as d:
            root = Path(d); ui = root / 'UIPrototype/WorldGameplay'; ui.mkdir(parents=True)
            f = ui / 'View.swift'; f.write_text('a'); before = loop.source_hashes(root)
            cache = ui / 'DerivedData'; cache.mkdir(); (cache / 'temp').write_text('noise')
            self.assertEqual(before, loop.source_hashes(root))
            f.write_text('b'); self.assertNotEqual(before, loop.source_hashes(root))


class SimulatorOwnership(unittest.TestCase):
    def test_ledger_written_before_work_and_exact_uuid_deleted_on_failure(self):
        identifier = '11111111-2222-4333-8444-555555555555'
        calls = []
        with tempfile.TemporaryDirectory() as d:
            ledger = Path(d) / 'owned.json'
            def fake(args, **kwargs):
                calls.append(args)
                if 'create' in args: return identifier + '\n'
                if 'list' in args:
                    owned = [] if ['xcrun', 'simctl', 'delete', identifier] in calls else [{'udid': identifier}]
                    return json.dumps({'devices': {'runtime': owned + [{'udid': 'other-device'}]}})
                return ''
            with patch.object(sim, 'command', side_effect=fake):
                with self.assertRaisesRegex(ValueError, 'fixture'):
                    with sim.temporary_simulator('type', 'runtime', ledger):
                        self.assertEqual(sim.read_ledger(ledger)['devices'][0]['status'], 'owned')
                        raise ValueError('fixture')
                self.assertEqual(sim.read_ledger(ledger)['devices'][0]['status'], 'deleted')
            self.assertIn(['xcrun', 'simctl', 'delete', identifier], calls)
            self.assertFalse(any('other-device' in call or 'all' in call for call in calls))

    def test_pending_create_is_recovered_by_exact_nonce_then_deleted_by_uuid(self):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d) / 'ledger'; name = 'LC UI owned ' + 'a' * 32
            identifier = '11111111-2222-4333-8444-555555555555'
            sim.atomic_json(p, {'version': 1, 'devices': [], 'creates': [{'name': name, 'status': 'pending'}]})
            calls = []
            def fake(args, **kwargs):
                calls.append(args)
                if 'list' in args:
                    owned = [] if ['xcrun', 'simctl', 'delete', identifier] in calls else [{'udid': identifier, 'name': name}]
                    return json.dumps({'devices': {'r': owned + [{'udid': 'other', 'name': 'shared'}]}})
                return ''
            with patch.object(sim, 'command', side_effect=fake): sim.cleanup_owned(p)
            self.assertIn(['xcrun', 'simctl', 'delete', identifier], calls)
            self.assertEqual(sim.read_ledger(p)['devices'][0]['status'], 'deleted')

    def test_unresolved_creation_stays_pending_until_device_appears(self):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d) / 'ledger'; name = 'LC UI owned ' + 'b' * 32
            identifier = '11111111-2222-4333-8444-555555555555'
            sim.atomic_json(p, {'version': 1, 'devices': [], 'creates': [{'name': name, 'status': 'pending'}]})
            with patch.object(sim, 'command', return_value=json.dumps({'devices': {}})):
                with self.assertRaises(RuntimeError): sim.cleanup_owned(p)
            self.assertEqual(sim.read_ledger(p)['creates'][0]['status'], 'pending')
            deleted = False
            def appear(args, **kwargs):
                nonlocal deleted
                if 'delete' in args: deleted = True
                return json.dumps({'devices': {'r': [] if deleted else [{'udid': identifier, 'name': name}]}}) if 'list' in args else ''
            with patch.object(sim, 'command', side_effect=appear): sim.cleanup_owned(p)
            self.assertEqual(sim.read_ledger(p)['creates'][0]['status'], 'recorded')
            self.assertEqual(sim.read_ledger(p)['devices'][0]['status'], 'deleted')

    def test_delete_success_without_absence_keeps_owned_for_retry(self):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d) / 'ledger'
            identifier = '11111111-2222-4333-8444-555555555555'
            sim.atomic_json(p, {'version': 1, 'devices': [{'uuid': identifier, 'status': 'owned'}], 'creates': []})
            def stale(args, **kwargs):
                return json.dumps({'devices': {'r': [{'udid': identifier}]}}) if 'list' in args else ''
            with patch.object(sim, 'command', side_effect=stale):
                with self.assertRaisesRegex(RuntimeError, 'remains after delete'): sim.cleanup_owned(p)
            self.assertEqual(sim.read_ledger(p)['devices'][0]['status'], 'owned')

    def test_delete_failure_keeps_owned_for_retry(self):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d) / 'ledger'
            identifier = '11111111-2222-4333-8444-555555555555'
            sim.atomic_json(p, {'version': 1, 'devices': [{'uuid': identifier, 'status': 'owned'}], 'creates': []})
            def failure(args, **kwargs):
                if 'delete' in args: raise subprocess.CalledProcessError(1, args)
                return json.dumps({'devices': {'r': [{'udid': identifier}]}}) if 'list' in args else ''
            with patch.object(sim, 'command', side_effect=failure):
                with self.assertRaises(subprocess.CalledProcessError): sim.cleanup_owned(p)
            self.assertEqual(sim.read_ledger(p)['devices'][0]['status'], 'owned')

    def test_bad_ledger_does_not_delete_any_device(self):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d) / 'ledger'; p.write_text('{"version":1,"devices":[{"uuid":"all","status":"owned"}]}')
            with patch.object(sim, 'command') as command:
                with self.assertRaises(ValueError): sim.cleanup_owned(p)
                command.assert_not_called()


if __name__ == '__main__': unittest.main(verbosity=2)
