"""Audit the actual Xcode color assets using WCAG 2 relative luminance."""
import json
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
ASSETS = ROOT / 'LifeCrossroads/App/Assets.xcassets'
VARIANTS = [(), ('dark',), ('high',), ('dark', 'high')]
PAIRS = [('StoryInk', 'StoryPaper'), ('StorySecondaryInk', 'StoryPaper'),
         ('StoryAccent', 'StoryPaper'), ('StoryInk', 'StoryPage'),
         ('StorySecondaryInk', 'StoryPage'), ('StoryAccent', 'StoryPage'),
         ('StoryOnButton', 'StoryButton'), ('StoryOnButton', 'StoryButtonPressed'),
         ('StorySceneInk', 'StoryScenePaper')]

def color(name, variant):
    entries = json.loads((ASSETS / (name + '.colorset') / 'Contents.json').read_text())['colors']
    key = set(variant)
    matches = [e for e in entries if {a['value'] for a in e.get('appearances', [])} == key]
    if len(matches) != 1:
        raise ValueError(f'{name}: missing or duplicate appearance {variant}')
    c = matches[0]['color']; assert c['color-space'] == 'srgb'
    rgb = c['components']; assert float(rgb['alpha']) == 1, 'Text surfaces must be opaque'
    return tuple(float(rgb[ch]) for ch in ('red', 'green', 'blue'))

def luminance(rgb):
    channels = [v / 12.92 if v <= 0.04045 else ((v + .055) / 1.055) ** 2.4 for v in rgb]
    return sum(v * w for v, w in zip(channels, (.2126, .7152, .0722)))

def contrast(a, b):
    x, y = sorted([luminance(a), luminance(b)])
    return (y + .05) / (x + .05)

def audit():
    return [{'appearance': '+'.join(v) or 'light', 'foreground': fg, 'background': bg,
             'ratio': contrast(color(fg, v), color(bg, v)),
             'minimum': 7.0 if 'high' in v or fg in ('StoryInk', 'StorySecondaryInk', 'StorySceneInk') else 4.5}
            for v in VARIANTS for fg, bg in PAIRS]

if __name__ == '__main__':
    rows = audit()
    print(json.dumps({'standard': 'WCAG 2 relative luminance; Apple HIG 4.5 minimum, 7 for small text',
                      'pass': all(r['ratio'] >= r['minimum'] for r in rows), 'pairs': rows}, indent=2))
    raise SystemExit(0 if all(r['ratio'] >= r['minimum'] for r in rows) else 1)
