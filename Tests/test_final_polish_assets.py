"""Read-only checks against the reviewed local-edit provenance and crop receipts."""
import hashlib
import json
from pathlib import Path
import unittest
from test_multicast_assets import rgba_rows

ROOT = Path(__file__).resolve().parents[1]

class FinalPolishAssetTests(unittest.TestCase):
    def setUp(self):
        self.manifest = json.loads((ROOT / 'docs/final-polish-loop/asset-manifest.json').read_text())

    def test_integrated_assets_are_exact_reviewed_candidates_not_new_approved_art(self):
        self.assertEqual(len(self.manifest['assets']), 2)
        for a in self.manifest['assets']:
            raw = (ROOT / a['retained_original']).read_bytes()
            self.assertEqual(hashlib.sha256(raw).hexdigest(), a['sha256'])
            self.assertEqual(raw, (ROOT / a['integrated_path']).read_bytes())
            self.assertFalse(a['approved_for_app'])
            self.assertTrue(a['draft_integration_allowed'])
            self.assertEqual(a['selected_cell_indices'], [2])
            self.assertTrue((ROOT / a['prompt_file']).is_file())

    def test_original_reference_bytes_remain_unchanged(self):
        for a in self.manifest['assets']:
            raw = (ROOT / a['edit_reference']).read_bytes()
            self.assertEqual(hashlib.sha256(raw).hexdigest(), a['source_reference_sha256'])

    def test_shared_crop_contains_all_visible_pixels_of_both_selected_endpoints(self):
        for a in self.manifest['assets']:
            rect = a['common_early_late_render_rect_px']
            x0, y0, x1, y1 = rect['x'], rect['y'], rect['x'] + rect['width'], rect['y'] + rect['height']
            for file in [a['edit_reference'], a['integrated_path']]:
                width, height, rows = rgba_rows((ROOT / file).read_bytes())
                self.assertEqual((width, height), (1254, 1254))
                # Reviewed selected cell is bottom-left. Visible character pixels
                # must fit one common crop, including stool, paper, bag and tail.
                visible = [(x, y) for y in range(627, 1254) for x in range(627)
                           if rows[y][x * 4 + 3] > 12]
                self.assertTrue(visible)
                self.assertTrue(all(x0 <= x < x1 and y0 <= y < y1 for x, y in visible), file)
                self.assertTrue(all(row[627 * 4 + 3] <= 12 for row in rows))
                self.assertTrue(all(rows[627][x * 4 + 3] <= 12 for x in range(width)))
