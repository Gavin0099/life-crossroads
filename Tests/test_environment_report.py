import copy
import importlib.util
from pathlib import Path
import unittest

spec=importlib.util.spec_from_file_location('environment_report',Path(__file__).resolve().parents[1]/'scripts/render-environment-report.py')
renderer=importlib.util.module_from_spec(spec);spec.loader.exec_module(renderer)

def fixture():
    codes=['TWN','JPN','USA','DEU','IND','BRA','VNM','KEN']
    samples=[]
    for event,age in [('child-interest',8),('teen-project',13),('adult-care',39),('middle-support',52)]:
        rows=[]
        for i,code in enumerate(codes):
            trace=dict(countryCode=code,householdID=code+'-1',seed=0,eventID=event,choiceID='invest',
                       finalCost=dict(time=1 if age==8 else i,energy=2,materials=1),applied=True,
                       environmentGaps=['unknown'] if code=='TWN' and age!=8 else [],costSteps=[],recordedStoryFacts=[])
            rows.append(dict(trace=trace,availableAlternatives=[]))
        samples.append(dict(eventID=event,age=age,choiceID='invest',seed=0,comparisons=rows,householdComparison=[]))
    trace=dict(age=80,eventID='later-review',choiceID='rest',resourcesAfter={},recordedStoryFacts=[],environmentGaps=[])
    runs=[dict(countryCode=c,householdID=c+str(f),policy=p,seed=seed,traces=[{**trace,'age':39,'eventID':'adult-care'}]+[trace]*14,replayAndRestoreMatch=True)
          for c in codes for f in [1,2] for seed in [0,3] for p in ['investFirst','supportFirst','restFirst','seededVariety']]
    return dict(samples=samples,runs=runs,engineVersion='fixture',dataVersion='fixture',claimBoundary='fixture only',policies=[])

class EnvironmentReportTests(unittest.TestCase):
    def test_unknown_cost_is_null_not_zero_and_not_in_feasibility_conclusion(self):
        report=fixture();report['samples'][1]['comparisons'][0]['trace']['finalCost']={'time':0,'energy':0,'materials':0}
        result=renderer.summarize(report)
        row=result['samples'][1]['rows'][0]
        self.assertIsNone(row['cost']);self.assertIsNone(row['feasible'])
        self.assertEqual(result['samples'][0]['rows'][0]['cost'],{'time':1,'energy':2,'materials':1})
        self.assertIn('未估完整成本（非0）',renderer.render(result))

    def test_duplicate_matrix_and_mismatched_seed_are_rejected(self):
        for mutate in [lambda r:r['runs'].__setitem__(0,r['runs'][1]),lambda r:r['samples'][0]['comparisons'][0]['trace'].__setitem__('seed',1),lambda r:r['runs'][0].__setitem__('replayAndRestoreMatch',False)]:
            report=fixture();mutate(report)
            with self.assertRaises(ValueError):renderer.summarize(report)

    def test_three_real_differing_samples_required_not_labels_only(self):
        report=fixture()
        for sample in report['samples']:
            for row in sample['comparisons']:row['trace']['finalCost']={'time':1,'energy':2,'materials':1}
        with self.assertRaises(ValueError):renderer.summarize(report)

if __name__=='__main__':unittest.main()
