import importlib.util
from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('experience_summary',ROOT/'scripts/summarize-experience.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)

class SummaryTests(unittest.TestCase):
    def fixture(self):
        sequences=[['a']*15,['a','b']+['a']*13,['c','b']+['a']*13]
        runs=[dict(country='JPN',household='jpn-1',seed=i,policy='restFirst',events=e,choices=['rest']*15,
            connections=[],environmentReceipts=[],finalResources=dict(health=99,financial=30,relationships=40,skills=20),replayMatched=True) for i,e in enumerate(sequences)]
        report=dict(version='experience-audit-1',engineVersion='test',contentVersion='v',runs=runs,
            eventCounts=dict(a=42,b=2,c=1),unobservedEvents=[],policyDescription='fixture',claimBoundary='fixture')
        catalog=dict(contentVersion='v',households=[dict(id='jpn-1',countryCode='JPN',templateID='shared',label='label')])
        return report,catalog

    def test_distances_and_zero_story_are_not_fabricated(self):
        r,c=self.fixture();s=module.summarize(r,c);cohort=s['cohorts'][0]
        self.assertEqual(cohort['seedPairs'],3)
        self.assertEqual(cohort['eventDifferenceMedian'],1)
        self.assertEqual(cohort['livesWithTwoDistinctLinkedRules'],0)
        self.assertEqual(cohort['connections']['support'],dict(livesWithOpportunity=0,livesAccepting=0))
        self.assertEqual(s['pairedEnvironmentWitnesses'],[])
    def test_invalid_run_and_version_fail_loudly(self):
        for change in ['duplicate','replay','length','version']:
            r,c=self.fixture()
            if change=='duplicate':r['runs'].append(r['runs'][0])
            if change=='replay':r['runs'][0]['replayMatched']=False
            if change=='length':r['runs'][0]['events'].pop()
            if change=='version':c['contentVersion']='different'
            with self.assertRaises(ValueError):module.summarize(r,c)

if __name__=='__main__':unittest.main()
