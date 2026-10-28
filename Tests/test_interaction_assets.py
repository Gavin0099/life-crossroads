"""Read-only checks of reviewed age cells; no generated pixels are modified."""
import hashlib
import json
from pathlib import Path
import unittest
from test_multicast_assets import rgba_rows

ROOT = Path(__file__).resolve().parents[1]

class InteractionAssetTests(unittest.TestCase):
    def test_reviewed_atlas_preserves_original_bytes_and_age_ranges(self):
        m = json.loads((ROOT/'docs/interaction-memory-loop/asset-manifest.json').read_text())
        self.assertEqual(len(m['assets']), 1)
        a = m['assets'][0]
        raw = (ROOT/a['path']).read_bytes()
        self.assertEqual(raw, (ROOT/a['retained_original']).read_bytes())
        self.assertEqual(hashlib.sha256(raw).hexdigest(), a['sha256'])
        self.assertFalse(a['approved_for_app']); self.assertTrue(a['draft_integration_allowed'])
        self.assertEqual([c['existing_ui_age_range_inclusive'] for c in a['cells']], [[13,22],[23,40],[41,60]])
        self.assertEqual(a['grid']['x_edges_px'], [0,724,1448,2172])
        self.assertTrue((ROOT/a['prompt_file']).is_file())
        w,h,rows = rgba_rows(raw)
        self.assertEqual((w,h), (2172,724))
        for x in [724,1448]:
            self.assertTrue(all(row[x*4+3] <= 12 for row in rows), 'Crop boundary must not cut a visible character')
        for c in a['cells']:
            r = c['source_rect_px']; b = c['visible_alpha_bbox_px']
            self.assertGreater(b['x'], r['x']); self.assertLess(b['x']+b['width'],r['x']+r['width'])
            self.assertGreater(b['y'],r['y']); self.assertLess(b['y']+b['height'],r['y']+r['height'])
