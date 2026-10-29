"""Reviewed issue text from PR10's actual xcresult is a negative regression fixture."""
import importlib.util
from pathlib import Path
import unittest
import json
import tempfile
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("ios_runtime", Path(__file__).resolve().parents[1] / "scripts/check-ios-runtime.py")
runtime = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runtime)


class IOSRuntimeTests(unittest.TestCase):
    def test_failed_ci_summary_is_retained_and_still_rejected(self):
        # Actual PR24 CI #2 outcome, independent of the checking implementation.
        summary = {"result": "Failed", "passedTests": 6, "failedTests": 1,
                   "skippedTests": 0, "runtimeWarnings": []}
        with tempfile.TemporaryDirectory() as directory:
            result = Path(directory) / "failed.xcresult"
            with patch("sys.argv", ["check-ios-runtime.py", str(result)]), \
                    patch.object(runtime.subprocess, "check_output", return_value=json.dumps(summary)):
                self.assertEqual(runtime.main(), 1)
            self.assertEqual(json.loads(result.with_suffix(".runtime-summary.json").read_text()), summary)

    def test_passing_summary_retains_all_runtime_warnings(self):
        summary = {"result": "Passed", "passedTests": 7, "failedTests": 0,
                   "runtimeWarnings": [{"message": "Different runtime issue"}]}
        with tempfile.TemporaryDirectory() as directory:
            result = Path(directory) / "passed.xcresult"
            with patch("sys.argv", ["check-ios-runtime.py", str(result)]), \
                    patch.object(runtime.subprocess, "check_output", return_value=json.dumps(summary)):
                self.assertEqual(runtime.main(), 0)
            self.assertEqual(json.loads(result.with_suffix(".runtime-summary.json").read_text()), summary)

    def test_unfinished_empty_and_malformed_summaries_never_pass(self):
        for summary in [None, [], {}, {"result": "Running", "passedTests": 6},
                        {"result": "Passed", "passedTests": 0},
                        {"result": "Passed", "passedTests": "7"}]:
            with self.subTest(summary=summary), self.assertRaises(ValueError):
                runtime.require_passing_tests(summary)

    def test_actual_pr10_publication_issue_is_rejected(self):
        summary = {"runtimeWarnings": [{"issueType": "Runtime Warning", "message": "Publishing changes from within view updates is not allowed, this will cause undefined behavior."}]}
        self.assertEqual(len(runtime.publication_issues(summary)), 1)

    def test_empty_and_other_issues_do_not_become_the_publication_defect(self):
        self.assertEqual(runtime.publication_issues({"runtimeWarnings": []}), [])
        self.assertEqual(runtime.publication_issues({}), [])
        self.assertEqual(runtime.publication_issues({"runtimeWarnings": [{"message": "Different runtime issue"}]}), [])

    def test_malformed_results_fail_instead_of_claiming_no_warning(self):
        for value in [None, [], {"runtimeWarnings": None}, {"runtimeWarnings": ["warning"]}, {"runtimeWarnings": [{}]}]:
            with self.subTest(value=value), self.assertRaises(ValueError):
                runtime.publication_issues(value)


if __name__ == "__main__":
    unittest.main()
