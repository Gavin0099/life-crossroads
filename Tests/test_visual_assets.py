"""The review manifest must describe the actual assets shipped to the native renderer."""
import hashlib
import json
from pathlib import Path
import struct
import unittest

ROOT = Path(__file__).resolve().parents[1]

class VisualAssetIntegrityTests(unittest.TestCase):
    def test_reviewed_scene_layers_match_native_asset_catalog(self):
        manifest = json.loads((ROOT / 'docs/visual-loop-02/asset-manifest.json').read_text())
        required = {'VL2Studio','VL2Workshop','VL2Garden','VL2Teen13','VL2Teen17','VL2Adult25','VL2Recovery32','VL2Companions','VL2Neutral'}
        self.assertEqual({a['name'] for a in manifest['assets']}, required)
        for asset in manifest['assets']:
            with self.subTest(asset=asset['name']):
                path = ROOT / asset['path']; data = path.read_bytes()
                self.assertEqual(hashlib.sha256(data).hexdigest(), asset['sha256'])
                self.assertEqual(data[:8], b'\x89PNG\r\n\x1a\n')
                width, height, depth, color = struct.unpack('>IIBB', data[16:26])
                self.assertEqual({'width':width,'height':height}, asset['dimensions_px'])
                self.assertEqual(color, asset['png_color_type'])
                self.assertEqual(depth, 8)
                catalog = json.loads((path.parent/'Contents.json').read_text())
                self.assertIn(path.name, [i.get('filename') for i in catalog['images']])
                columns, rows = asset['grid']['columns'], asset['grid']['rows']
                self.assertEqual(width % columns, 0); self.assertEqual(height % rows, 0)
                self.assertEqual(len(asset['cells']), columns * rows)
                for cell in asset['cells']:
                    rect = cell['source_rect_px']; index = cell['index']
                    self.assertEqual(rect, {'x':index % columns * (width // columns),
                        'y':index // columns * (height // rows),'width':width // columns,'height':height // rows})
                if asset['kind'] != 'background': self.assertEqual(color, 6, 'Layered actors require real alpha')

if __name__ == '__main__': unittest.main()
