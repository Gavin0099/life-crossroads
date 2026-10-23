"""Opt-in macOS integration checks: actual devices, no boot or UI tests required."""
import importlib.util
import json
from pathlib import Path
import subprocess
import unittest

spec = importlib.util.spec_from_file_location("simulator_runner", Path(__file__).with_name("run-simulator-tests.py"))
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)


def device_ids():
    state = json.loads(subprocess.check_output(["xcrun", "simctl", "list", "devices", "-j"], text=True))
    return {device["udid"] for devices in state["devices"].values() for device in devices}


class SimulatorLifecycleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.device_type = "com.apple.CoreSimulator.SimDeviceType.iPhone-17"
        cls.runtime = runner.select_runtime(cls.device_type)

    def test_normal_exit_removes_actual_device(self):
        with runner.temporary_simulator(self.device_type, self.runtime) as device_id:
            self.assertIn(device_id, device_ids())
        self.assertNotIn(device_id, device_ids())

    def test_failed_work_still_removes_actual_device(self):
        with self.assertRaisesRegex(RuntimeError, "intentional test failure"):
            with runner.temporary_simulator(self.device_type, self.runtime) as device_id:
                self.assertIn(device_id, device_ids())
                raise RuntimeError("intentional test failure")
        self.assertNotIn(device_id, device_ids())


if __name__ == "__main__":
    unittest.main(verbosity=2)
