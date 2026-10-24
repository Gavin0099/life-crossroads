"""Reviewed issue text from PR10's actual xcresult is a negative regression fixture."""
import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location("ios_runtime", Path(__file__).resolve().parents[1] / "scripts/check-ios-runtime.py")
runtime = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runtime)


class IOSRuntimeTests(unittest.TestCase):
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
