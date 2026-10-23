import base64
import copy
import hashlib
from pathlib import Path
import tempfile
import unittest
from validate_manifest import validate


class CandidateManifestTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        # Independent, fixed 1x1 grayscale+alpha PNG fixture.
        self.png = base64.b64decode("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=")
        (self.root / "one.png").write_bytes(self.png)
        (self.root / "prompt.txt").write_text("An original cat.")
        self.row = {"asset_id": "cat", "path": "one.png", "prompt_path": "prompt.txt",
                    "output_sha256": hashlib.sha256(self.png).hexdigest(), "width": 1, "height": 1,
                    "has_alpha_channel": True, "approved_for_app": False}

    def check(self, row=None):
        return validate({"assets": [row or self.row]}, self.root)

    def test_candidate_does_not_need_fake_approval(self):
        self.assertEqual(self.check(), [])

    def test_unreviewed_approval_is_rejected(self):
        self.row["approved_for_app"] = True
        self.assertIn("asset[0]: approval requires all human reviews", self.check())
        self.assertIn("asset[0]: approval requires license evidence", self.check())

    def test_missing_prompt_is_rejected(self):
        (self.root / "prompt.txt").unlink()
        self.assertEqual(self.check(), ["asset[0]: invalid prompt_path"])

    def test_duplicate_id_is_rejected(self):
        self.assertIn("asset[1]: missing or duplicate asset_id",
                      validate({"assets": [self.row, copy.deepcopy(self.row)]}, self.root))

    def test_dimensions_and_alpha_are_checked(self):
        self.row.update(width=2, has_alpha_channel=False)
        self.assertEqual(self.check(), ["asset[0]: dimension mismatch", "asset[0]: alpha channel mismatch"])

    def test_changed_file_is_rejected(self):
        (self.root / "one.png").write_bytes(b"broken")
        self.assertIn("asset[0]: SHA256 mismatch", self.check())
        self.assertIn("asset[0]: not a PNG with IHDR", self.check())

    def test_path_outside_repo_is_rejected(self):
        self.row["path"] = "../outside.png"
        self.assertIn("asset[0]: invalid path", self.check())

    def test_invalid_and_empty_manifest_are_rejected(self):
        self.assertEqual(validate([], self.root), ["manifest.assets must be a list"])
        self.assertEqual(validate({"assets": []}, self.root), ["manifest.assets must not be empty"])


if __name__ == "__main__":
    unittest.main()
