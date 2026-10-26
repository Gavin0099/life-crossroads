import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location("ios_shards", Path(__file__).resolve().parents[1] / "scripts/ios-test-shards.py")
shards = importlib.util.module_from_spec(spec)
spec.loader.exec_module(shards)


class IOSShardTests(unittest.TestCase):
    def test_literal_partition_and_complete_disjoint_union(self):
        cases = ["testD", "testB", "testA", "testC"]
        self.assertEqual(shards.partition(cases, 0, 3), ["testA", "testD"])
        self.assertEqual(shards.partition(cases, 1, 3), ["testB"])
        self.assertEqual(shards.partition(cases, 2, 3), ["testC"])
        actual = sum([shards.partition(cases, i, 3) for i in range(3)], [])
        self.assertCountEqual(actual, cases)
        self.assertEqual(len(actual), len(set(actual)))

    def test_source_fixture_and_duplicate_rejection(self):
        source = "    func testBeta() {}\n    private func helper() {}\n    func testAlpha() throws {}\n"
        self.assertEqual(shards.declared_tests(source), ["testAlpha", "testBeta"])
        with self.assertRaises(ValueError):
            shards.declared_tests(source + "    func testAlpha() {}\n")
        with self.assertRaises(ValueError):
            shards.declared_tests("    private func helper() {}")
        with self.assertRaises(ValueError):
            shards.declared_tests(source + "  func testNewStyle () {}\n")

    def test_invalid_and_empty_shards_cannot_succeed(self):
        for names, index, count in [([], 0, 1), (["testA"], 1, 2), (["testA"], -1, 1), (["testA"], 0, 0), (["testA", "testA"], 0, 1)]:
            with self.subTest(index=index, count=count), self.assertRaises(ValueError):
                shards.partition(names, index, count)

    def test_actual_execution_must_match_the_selected_count(self):
        valid = {"result": "Passed", "passedTests": 2, "failedTests": 0, "skippedTests": 0}
        shards.verify_execution(valid, ["testA", "testB"])
        for delta in [{"passedTests": 1}, {"passedTests": 3}, {"passedTests": True}, {"failedTests": 1}, {"skippedTests": 1}, {"result": "Cancelled"}]:
            with self.subTest(delta=delta), self.assertRaises(ValueError):
                shards.verify_execution({**valid, **delta}, ["testA", "testB"])
        with self.assertRaises(ValueError):
            shards.verify_execution(valid, [])
