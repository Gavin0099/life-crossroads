"""Offline unit checks of the acting + critic evidence gate, not visual tests."""
from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

RUNNER_PATH = Path(__file__).resolve().parents[1] / "run_ui_loop.py"
spec = importlib.util.spec_from_file_location("run_ui_loop", RUNNER_PATH)
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)


class RunnerEvidenceTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.docs = self.root / "docs/ui-loop"
        self.artifacts = self.root / "artifacts/ui-loop"
        self.final = self.artifacts / "final"
        self.final.mkdir(parents=True)
        self.docs.mkdir(parents=True)
        for d in runner.REQUIRED_DOCS:
            (self.docs / d).write_text("TEST FIXTURE ONLY", encoding="utf8")
        # These are synthetic binary fixtures to exercise the gate, never screenshot evidence.
        for i, name in enumerate(runner.MANDATORY_PNGS):
            (self.final / name).write_bytes(b"\x89PNG\r\n\x1a\n" + b"_" * 25 + bytes([i]) * 4100)
        tests = self.root / "UIPrototype/EventFirstTests"
        tests.mkdir(parents=True)
        (tests / "ActingTests.swift").write_text(
            "func testActingBranchesAreVisuallyDistinct() {}\n"
            "func testReducedMotionPreservesOutcome() {}\n", encoding="utf8"
        )
        views = self.root / "UIPrototype/EventFirst"
        views.mkdir(parents=True)
        (views / "Actor.swift").write_text(
            "@Environment(\\.accessibilityReduceMotion) var reduceMotion\n", encoding="utf8"
        )
        self.proof = {
            "schema_version": "1.1", "event_id": "bridge", "character_id": "otter-acheng",
            "expression_catalog": ["neutral", "thinking", "hopeful", "tired"],
            "pose_catalog": ["idle", "collaborating", "asking"],
            "contact_sheet": "artifacts/ui-loop/final/06-acting-contact-sheet.png",
            "states": {
                "bridge-initial": {
                    "expression_id": "thinking", "pose_id": "idle", "prop_id": "materials",
                    "screenshot": "artifacts/ui-loop/final/01-home.png"
                },
                "bridge-team": {
                    "expression_id": "hopeful", "pose_id": "collaborating", "prop_id": "prototype",
                    "screenshot": "artifacts/ui-loop/final/02-friend-outcome.png"
                },
                "bridge-help": {
                    "expression_id": "neutral", "pose_id": "asking", "prop_id": "material-list",
                    "screenshot": "artifacts/ui-loop/final/03-teacher-outcome.png"
                },
            },
            "reduced_motion_test": "testReducedMotionPreservesOutcome"
        }
        self.save_proof()
        (self.artifacts / "build.log").write_text("BUILD FIXTURE", encoding="utf8")
        (self.artifacts / "swift-tests.log").write_text("DOMAIN FIXTURE", encoding="utf8")
        (self.artifacts / "manifest.log").write_text("MANIFEST FIXTURE", encoding="utf8")
        (self.artifacts / "ui-tests.json").write_text(json.dumps({
            "result": "Passed", "devicesAndConfigurations": [
                {"passedTests": 10, "failedTests": 0},
                {"passedTests": 10, "failedTests": 0},
            ]
        }), encoding="utf8")
        (self.artifacts / "verification.json").write_text(json.dumps({
            "result": "PASS", "checks": {
                "build": {"result": "PASS", "evidence": "artifacts/ui-loop/build.log"},
                "ui_tests": {"result": "PASS", "evidence": "artifacts/ui-loop/ui-tests.json"},
                "domain_tests": {"result": "PASS", "evidence": "artifacts/ui-loop/swift-tests.log"},
                "visual_review": {"result": "PASS", "evidence": "artifacts/ui-loop/critic-06.md"},
                "acting_state": {"result": "PASS", "evidence": "artifacts/ui-loop/acting-state-proof.json"},
                "asset_provenance": {"result": "PASS", "evidence": "artifacts/ui-loop/manifest.log"},
            }
        }), encoding="utf8")
        self.write_critic()

    def tearDown(self):
        self.tmp.cleanup()

    def save_proof(self):
        (self.artifacts / "acting-state-proof.json").write_text(json.dumps(self.proof), encoding="utf8")

    def write_critic(self, gate="PASS", acting="PASS", motion="PASS"):
        labels = ["HOME", "FRIEND", "TEACHER", "ACTING_SHEET"]
        imgs = ["01-home.png", "02-friend-outcome.png", "03-teacher-outcome.png", "06-acting-contact-sheet.png"]
        report = [f"GATE={gate}", "P0_COUNT=0", "P1_COUNT=0", f"ACTING_GATE={acting}", f"REDUCE_MOTION_GATE={motion}"]
        report += [f"SHA256_{label}={runner.sha256_file(self.final / img)}" for label, img in zip(labels, imgs)]
        (self.artifacts / "critic-06.md").write_text("\n".join(report) + "\nFixture-only report\n", encoding="utf8")

    def test_complete_structural_fixture_passes(self):
        ok, issues = runner.ready_for_human_review(self.root)
        self.assertTrue(ok, issues)

    def test_missing_fourth_expression_fails(self):
        self.proof["expression_catalog"].remove("tired")
        self.save_proof()
        ok, issues = runner.ready_for_human_review(self.root)
        self.assertFalse(ok)
        self.assertTrue(any("4-expression" in s for s in issues), issues)

    def test_branch_same_pose_expression_prop_fails(self):
        self.proof["states"]["bridge-help"].update({
            k: self.proof["states"]["bridge-team"][k]
            for k in ("expression_id", "pose_id", "prop_id")
        })
        self.save_proof()
        ok, issues = runner.ready_for_human_review(self.root)
        self.assertFalse(ok)
        self.assertTrue(any("branch state" in s for s in issues), issues)

    def test_stale_critic_screenshot_hash_fails(self):
        p = self.final / "03-teacher-outcome.png"
        p.write_bytes(p.read_bytes() + b"changed after review")
        ok, issues = runner.ready_for_human_review(self.root)
        self.assertFalse(ok)
        self.assertTrue(any("after last critic" in s for s in issues), issues)

    def test_critic_lacks_acting_gate_fails(self):
        self.write_critic(acting="NOT_VERIFIED")
        ok, issues = runner.ready_for_human_review(self.root)
        self.assertFalse(ok)
        self.assertTrue(any("motion gates" in s for s in issues), issues)

    def test_one_simulator_nine_tests_fails(self):
        summary = self.artifacts / "ui-tests.json"
        payload = json.loads(summary.read_text(encoding="utf8"))
        payload["devicesAndConfigurations"][1]["passedTests"] = 9
        summary.write_text(json.dumps(payload), encoding="utf8")
        ok, issues = runner.ready_for_human_review(self.root)
        self.assertFalse(ok)
        self.assertTrue(any(">=10" in s for s in issues), issues)

    def test_no_visual_report_never_passes(self):
        (self.artifacts / "critic-06.md").unlink()
        ok, issues = runner.ready_for_human_review(self.root)
        self.assertFalse(ok)
        self.assertTrue(any("critic" in s for s in issues), issues)


if __name__ == "__main__":
    unittest.main()
