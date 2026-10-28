"""Independent PNG/manifest checks for native casting (no image editing)."""
import hashlib
import json
from pathlib import Path
import struct
import unittest
import zlib

ROOT = Path(__file__).resolve().parents[1]

def rgba_rows(data):
    width, height, depth, color, _, _, interlace = struct.unpack('>IIBBBBB', data[16:29])
    assert (depth, color, interlace) == (8, 6, 0)
    chunks = []; offset = 8
    while offset < len(data):
        length = struct.unpack('>I', data[offset:offset+4])[0]
        if data[offset+4:offset+8] == b'IDAT': chunks.append(data[offset+8:offset+8+length])
        offset += length + 12
    raw = zlib.decompress(b''.join(chunks)); stride = width * 4; previous = bytearray(stride)
    rows = []
    for y in range(height):
        start = y * (stride + 1); mode = raw[start]; row = bytearray(raw[start+1:start+1+stride])
        for x in range(stride):
            left = row[x-4] if x >= 4 else 0; up = previous[x]; corner = previous[x-4] if x >= 4 else 0
            if mode == 0: prediction = 0
            elif mode == 1: prediction = left
            elif mode == 2: prediction = up
            elif mode == 3: prediction = (left + up) // 2
            elif mode == 4:
                estimate = left + up - corner
                distances = [abs(estimate-left), abs(estimate-up), abs(estimate-corner)]
                prediction = [left, up, corner][distances.index(min(distances))]
            else: raise AssertionError('Unsupported PNG filter')
            row[x] = (row[x] + prediction) & 255
        rows.append(row); previous = row
    return width, height, rows

class MultiCastAssetTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = json.loads((ROOT/'docs/multi-cast-loop/asset-manifest.json').read_text())

    def test_original_images_and_explicit_pose_rectangles_are_complete(self):
        assets = self.manifest['assets']
        self.assertEqual({a['name'] for a in assets}, {'MCAhe','MCTeacher','MCCheng','MCMumu','MCCatCandidate','MCDogCandidate'})
        for a in assets:
            with self.subTest(asset=a['name']):
                p = ROOT/a['path']; raw = p.read_bytes()
                self.assertEqual(hashlib.sha256(raw).hexdigest(), a['sha256'])
                self.assertEqual(raw[:8], b'\x89PNG\r\n\x1a\n')
                w,h,depth,color = struct.unpack('>IIBB',raw[16:26])
                self.assertEqual((w,h), (a['dimensions_px']['width'], a['dimensions_px']['height']))
                self.assertEqual((depth,color),(8,6))
                self.assertIn(p.name,[v.get('filename') for v in json.loads((p.parent/'Contents.json').read_text())['images']])
                cells = a['cells']; grid = a['grid']
                self.assertEqual(len(cells), grid['columns']*grid['rows'])
                area = 0
                for c in cells:
                    r=c['source_rect_px']; b=c['visible_alpha_bbox_px']
                    self.assertGreater(r['width'],0);self.assertGreater(r['height'],0)
                    self.assertGreaterEqual(r['x'],0);self.assertGreaterEqual(r['y'],0)
                    self.assertLessEqual(r['x']+r['width'],w);self.assertLessEqual(r['y']+r['height'],h)
                    self.assertGreaterEqual(b['x'],r['x']);self.assertGreaterEqual(b['y'],r['y'])
                    self.assertLessEqual(b['x']+b['width'],r['x']+r['width']);self.assertLessEqual(b['y']+b['height'],r['y']+r['height'])
                    area += r['width']*r['height']
                self.assertEqual(area,w*h)
                self.assertFalse(a['approved_for_app'], 'Draft integration is not formal art approval')

    def test_real_alpha_gutters_do_not_cut_ears_feet_or_tails(self):
        for a in self.manifest['assets']:
            with self.subTest(asset=a['name']):
                w,h,rows=rgba_rows((ROOT/a['path']).read_bytes())
                for x in a['grid']['x_edges_px'][1:-1]:
                    self.assertEqual(sum(row[x*4+3]>12 for row in rows),0)
                for y in a['grid']['y_edges_px'][1:-1]:
                    self.assertEqual(sum(rows[y][x*4+3]>12 for x in range(w)),0)
                self.assertGreater(sum(row[x*4+3]==0 for row in rows for x in range(w)), w*h*0.25)

    def test_cat_and_dog_are_five_age_unapproved_candidates(self):
        for name in ['MCCatCandidate','MCDogCandidate']:
            a=next(a for a in self.manifest['assets'] if a['name']==name)
            self.assertEqual(len(a['cells']),5)
            self.assertEqual(a['kind'],'candidateAtlas')
            self.assertFalse(a['approved_for_app'])
            self.assertIn('Preview',a['approval_scope'])

if __name__ == '__main__': unittest.main()
