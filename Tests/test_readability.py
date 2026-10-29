"""Regression expectations come from Apple HIG / WCAG, not current palette values."""
import importlib.util
from pathlib import Path
import unittest
SPEC = importlib.util.spec_from_file_location('contrast', Path(__file__).resolve().parents[1] / 'tools/readability/check-contrast.py')
audit = importlib.util.module_from_spec(SPEC); SPEC.loader.exec_module(audit)

class ReadabilityTests(unittest.TestCase):
    def test_luminance_reference_endpoints_and_old_failure(self):
        self.assertAlmostEqual(audit.contrast((0, 0, 0), (1, 1, 1)), 21)
        self.assertAlmostEqual(audit.contrast((1, 1, 1), (1, 1, 1)), 1)
        # Previous fixed cream + iOS dark-mode white label must be rejected.
        self.assertLess(audit.contrast((1, 1, 1), (.98, .95, .88)), 4.5)

    def test_every_shipped_text_surface_pair_meets_contrast_in_all_appearances(self):
        for row in audit.audit():
            with self.subTest(pair=row):
                self.assertGreaterEqual(row['ratio'], row['minimum'])

    def test_scene_paper_and_ink_remain_paired_when_system_changes(self):
        for name in ('StorySceneInk', 'StoryScenePaper'):
            for variant in audit.VARIANTS:
                self.assertEqual(audit.color(name, ()), audit.color(name, variant))
        self.assertNotEqual(audit.color('StoryPaper', ()), audit.color('StoryPaper', ('dark',)))
