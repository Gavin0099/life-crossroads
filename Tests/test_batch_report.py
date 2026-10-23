import copy
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).parents[1]
SCRIPT = ROOT / "scripts/render-batch-report.py"
spec = importlib.util.spec_from_file_location("render_batch_report", SCRIPT)
renderer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(renderer)


class CLIArgumentTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        compiler = shutil.which("swiftc")
        if not compiler:
            raise unittest.SkipTest("Swift compiler unavailable; renderer tests remain independent")
        cls.directory = tempfile.TemporaryDirectory()
        directory = Path(cls.directory.name)
        harness = directory / "ArgumentHarness.swift"
        harness.write_text(r'''
import Foundation
@main struct ArgumentHarness {
    static func main() {
        do {
            switch try DemoCLIArguments.parse(Array(CommandLine.arguments.dropFirst())) {
            case .demo: print("demo")
            case .json: print("json")
            case .storySamples: print("story-samples")
            case .batchReport(let count): print("batch:\(count)")
            }
        } catch {
            FileHandle.standardError.write(Data("\(error)\n".utf8))
            exit(1)
        }
    }
}
''', encoding="utf-8")
        cls.binary = directory / "argument-harness"
        result = subprocess.run([compiler, "-parse-as-library", str(ROOT / "LifeCrossroads/CLI/CLIArguments.swift"),
                                 str(harness), "-o", str(cls.binary)], capture_output=True, text=True)
        if result.returncode:
            cls.directory.cleanup()
            raise AssertionError(result.stderr)

    @classmethod
    def tearDownClass(cls):
        cls.directory.cleanup()

    def test_existing_modes_and_batch_boundaries(self):
        cases = [([], "demo"), (["--json"], "json"), (["--story-samples"], "story-samples"),
                 (["--batch-report"], "batch:32"), (["--batch-report", "--seed-count", "2"], "batch:2"),
                 (["--batch-report", "--seed-count", "128"], "batch:128"),
                 (["--seed-count", "4", "--batch-report"], "batch:4")]
        for arguments, expected in cases:
            with self.subTest(arguments=arguments):
                result = subprocess.run([str(self.binary), *arguments], capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout.strip(), expected)
                self.assertEqual(result.stderr, "")

    def test_unknown_duplicate_conflicting_and_invalid_counts_fail_without_stdout(self):
        cases = [["--unknown"], ["--batch-report", "extra"], ["--json", "--json"],
                 ["--story-samples", "--batch-report"], ["--json", "--story-samples"],
                 ["--batch-report", "--json"], ["--batch-report", "--batch-report"],
                 ["--seed-count", "2"], ["--json", "--seed-count", "2"],
                 ["--batch-report", "--seed-count"],
                 ["--batch-report", "--seed-count", "2", "--seed-count", "3"]]
        cases += [["--batch-report", "--seed-count", value]
                  for value in ["0", "1", "129", "-2", "+2", "2.0", "two", "", "184467440737095516160", "--json"]]
        for arguments in cases:
            with self.subTest(arguments=arguments):
                result = subprocess.run([str(self.binary), *arguments], capture_output=True, text=True)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")
                self.assertIn("Usage:", result.stderr)


class RendererPrimitiveTests(unittest.TestCase):
    def test_rates_keep_zero_observations_and_show_undefined_denominator(self):
        self.assertEqual(renderer.format_rate(0, 8), "0/8 (0.0%)")
        self.assertEqual(renderer.format_rate(3, 8), "3/8 (37.5%)")
        self.assertEqual(renderer.format_rate(8, 8), "8/8 (100.0%)")
        self.assertEqual(renderer.format_rate(0, 0), "— (0/0)")
        for numerator, denominator in [(1, 0), (9, 8), (-1, 8), (True, 8)]:
            with self.subTest(numerator=numerator, denominator=denominator):
                with self.assertRaises(renderer.ReportError):
                    renderer.format_rate(numerator, denominator)

    def test_duplicate_json_keys_and_nonfinite_numbers_are_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "bad.json"
            for text in ['{"schemaVersion": 1, "schemaVersion": 2}', '{"value": NaN}']:
                path.write_text(text)
                with self.assertRaises(renderer.ReportError):
                    renderer.read_json(path)


if __name__ == "__main__":
    unittest.main()
