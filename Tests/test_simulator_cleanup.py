"""Exercise the real shell wrapper with fake tools; no developer devices are touched."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class SimulatorCleanupTests(unittest.TestCase):
    def run_wrapper(self, build_status=0, delete_status=0, requested="existing-phone", config=None):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "scripts").mkdir()
            shutil.copyfile(Path(__file__).resolve().parents[1] / "scripts/ios-check.sh", root / "scripts/ios-check.sh")
            binary = root / "bin"
            binary.mkdir()
            tool = '''#!/usr/bin/env python3
import json, os, sys
from pathlib import Path
args = sys.argv[1:]
with open(os.environ['LIFE_FAKE_LOG'], 'a') as log:
    log.write(json.dumps([Path(sys.argv[0]).name, *args]) + '\\n')
if Path(sys.argv[0]).name == 'xcodebuild':
    sys.exit(int(os.environ['LIFE_FAKE_BUILD_STATUS']))
if args[:3] == ['simctl', 'list', 'devices']:
    print(json.dumps({'devices': {'com.apple.CoreSimulator.SimRuntime.iOS-27-0': [
        {'udid': 'existing-phone', 'isAvailable': True, 'name': 'Existing phone',
         'deviceTypeIdentifier': 'com.apple.CoreSimulator.SimDeviceType.iPhone-SE-3rd-generation'}]}}))
elif args[:2] == ['simctl', 'create']:
    print('owned-test-phone')
elif args[:2] == ['simctl', 'delete']:
    sys.exit(int(os.environ['LIFE_FAKE_DELETE_STATUS']))
'''
            for name in ["xcrun", "xcodebuild"]:
                path = binary / name
                path.write_text(tool)
                path.chmod(0o755)
            log = root / "calls.jsonl"
            result = subprocess.run(["bash", "scripts/ios-check.sh"], cwd=root, text=True, capture_output=True,
                                    env={**os.environ, "PATH": f"{binary}:{os.environ['PATH']}",
                                         "LIFE_SIMULATOR_ID": requested, "LIFE_FAKE_LOG": str(log),
                                         "LIFE_SIMULATOR_DEVICE_TYPE": "", "LIFE_SIMULATOR_RUNTIME": "",
                                         "LIFE_FAKE_BUILD_STATUS": str(build_status),
                                         "LIFE_FAKE_DELETE_STATUS": str(delete_status), **(config or {})})
            calls = [json.loads(line) for line in log.read_text().splitlines()] if log.exists() else []
            return result, calls

    def test_explicit_hardware_needs_no_saved_device_and_partial_config_is_rejected(self):
        config = {"LIFE_SIMULATOR_DEVICE_TYPE": "com.apple.CoreSimulator.SimDeviceType.iPhone-SE-3rd-generation",
                  "LIFE_SIMULATOR_RUNTIME": "com.apple.CoreSimulator.SimRuntime.iOS-27-0"}
        result, calls = self.run_wrapper(requested="", config=config)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(calls[0][1:3], ["simctl", "create"])
        self.assertEqual(calls[0][-2:], list(config.values()))
        self.assertEqual(calls[-1], ["xcrun", "simctl", "delete", "owned-test-phone"])
        for invalid in [{"LIFE_SIMULATOR_DEVICE_TYPE": "incomplete"}, config]:
            result, calls = self.run_wrapper(config=invalid)  # existing ID conflicts with explicit settings
            self.assertEqual(result.returncode, 2)
            self.assertEqual(calls, [])

    def test_success_and_failure_delete_only_the_created_device(self):
        for status in [0, 65]:
            with self.subTest(build_status=status):
                result, calls = self.run_wrapper(build_status=status)
                self.assertEqual(result.returncode, status, result.stderr)
                self.assertEqual(calls[-2:], [["xcrun", "simctl", "shutdown", "owned-test-phone"],
                                              ["xcrun", "simctl", "delete", "owned-test-phone"]])
                build = next(call for call in calls if call[0] == "xcodebuild")
                self.assertIn("platform=iOS Simulator,id=owned-test-phone", build)
                self.assertEqual(build[build.index("-parallel-testing-enabled") + 1], "NO")

    def test_cleanup_failure_is_visible_and_fails_an_otherwise_successful_run(self):
        result, _ = self.run_wrapper(delete_status=1)
        self.assertEqual(result.returncode, 1)
        self.assertIn("Could not delete test Simulator", result.stderr)

    def test_unknown_configuration_does_not_create_or_delete_any_device(self):
        result, calls = self.run_wrapper(requested="unknown")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(len(calls), 1)


if __name__ == "__main__":
    unittest.main()
