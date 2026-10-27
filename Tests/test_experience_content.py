import importlib.util
from pathlib import Path
import sys
import unittest

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'))
spec=importlib.util.spec_from_file_location('experience_build',ROOT/'scripts/build-data.py')
build=importlib.util.module_from_spec(spec);spec.loader.exec_module(build)

class ExperienceContentTests(unittest.TestCase):
    def test_all_fifty_two_events_have_an_unconditional_free_exit(self):
        catalog=build.build()
        self.assertEqual(len(catalog['decisions']),52)
        self.assertEqual(len({e['id'] for e in catalog['decisions']}),52)
        for event in catalog['decisions']:
            rest=next(c for c in event['choices'] if c['id']=='rest')
            self.assertEqual((rest['timeCost'],rest['energyCost'],rest['materialCost']),(0,0,0),event['id'])
            self.assertFalse(rest['requiresDigitalAccess'])
            self.assertFalse(rest.get('requiresElectricTools',False))

    def test_offline_tools_and_focus_require_specific_authored_contracts(self):
        catalog=build.build()
        powered={(e['id'],c['id']) for e in catalog['decisions'] for c in e['choices'] if c.get('requiresElectricTools')}
        self.assertEqual(powered,{('young-power-table','poweredBench'),('adult-tools-coop','benchWork')})
        for event in catalog['decisions']:
            for c in event['choices']:
                if c.get('requiresElectricTools'): self.assertFalse(c['requiresDigitalAccess'])
        focus={e['focusContinuation']['focus']:e['id'] for e in catalog['decisions'] if e.get('focusContinuation')}
        self.assertEqual(set(focus),{'learning','relationships','recovery','stability'})
        for event in catalog['decisions']:
            if event.get('focusContinuation'):
                self.assertEqual(event['selection']['focusAffinity'],event['focusContinuation']['focus'])
                if event['selection']['minimumAge']<=12:
                    self.assertTrue(all(c['control']=='sharedWithAdult' for c in event['choices'] if c['kind'] not in ['askSupport','rest']))

if __name__=='__main__':unittest.main()
