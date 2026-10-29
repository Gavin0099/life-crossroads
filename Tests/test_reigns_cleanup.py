"""Cancellation backup owns only UUIDs in this capture's device records."""
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("reigns_cleanup", Path(__file__).resolve().parents[1] / "tools/reigns-card/cleanup.py")
cleanup = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cleanup)
OWNED = "00000000-0000-4000-8000-000000000001"
OTHER = "00000000-0000-4000-8000-000000000002"


class ReignsCleanupTests(unittest.TestCase):
    def test_only_recorded_device_is_deleted_and_receipt_matches_inventory(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); (root / "phone").mkdir()
            (root / "phone/device.txt").write_text(OWNED + "\n")
            with patch.object(cleanup, "inventory", side_effect=[{OWNED, OTHER}, {OTHER}]), \
                    patch.object(cleanup.subprocess, "run") as run:
                receipt = cleanup.cleanup(root)
            self.assertEqual([call.args[0] for call in run.call_args_list],
                             [["xcrun", "simctl", "shutdown", OWNED], ["xcrun", "simctl", "delete", OWNED]])
            self.assertEqual(receipt["deletedByBackup"], [OWNED])
            self.assertEqual(receipt["remainingOtherDevices"], [OTHER])
            self.assertEqual(json.loads((root / "cleanup.json").read_text()), receipt)

    def test_already_deleted_record_never_mutates_another_device(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); (root / "phone").mkdir()
            (root / "phone/device.txt").write_text(OWNED)
            with patch.object(cleanup, "inventory", return_value={OTHER}), \
                    patch.object(cleanup.subprocess, "run") as run:
                receipt = cleanup.cleanup(root)
            run.assert_not_called()
            self.assertEqual(receipt["alreadyAbsent"], [OWNED])

    def test_invalid_record_is_rejected_before_any_device_action(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); (root / "phone").mkdir()
            (root / "phone/device.txt").write_text("creation-error-not-a-device")
            with patch.object(cleanup, "inventory") as inventory, \
                    patch.object(cleanup.subprocess, "run") as run, self.assertRaises(ValueError):
                cleanup.cleanup(root)
            inventory.assert_not_called(); run.assert_not_called()
