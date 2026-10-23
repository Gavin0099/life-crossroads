#!/usr/bin/env python3
"""Compare identical experiment grids; no simulation, selection, or gameplay success score."""
import argparse
from collections import Counter
import importlib.util
import json
from pathlib import Path

spec = importlib.util.spec_from_file_location('batch_renderer', Path(__file__).with_name('render-batch-report.py'))
renderer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(renderer)


def summarize(report, policy):
    cohorts = [c for c in report['cohorts'] if c['policy'] == policy]
    runs = [r for r in report['runs'] if r['policy'] == policy]
    distances = Counter()
    for cohort in cohorts:
        for row in cohort['seedPairDifferences']['eventIDHamming']:
            distances[row['distance']] += row['frequency']['count']
    chain_counts = Counter()
    chain_coverage = Counter()
    for run in runs:
        linked = set()
        for index, step in enumerate(run['steps']):
            branch = step.get('storyBranch')
            if not branch:
                continue
            prior = [s for s in run['steps'][:index] if s['eventID'] == branch['sourceEventID'] and s['choiceID'] == branch.get('sourceChoiceID')
                     and ('sourceAge' not in branch or s['age'] == branch['sourceAge'])]
            active = branch['variantID'] in ['teen-direction-paper', 'teen-direction-online', 'middle-support-reciprocal', 'later-reconnect-old-friend']
            # New routes must offer a feasible distinct action, not just a differently worded title.
            active |= branch['variantID'].endswith('-continuation') and 'lead' in step['availableChoiceIDs']
            if prior and active:
                linked.add(branch['ruleID'])
        if 'linkedStoryChains' in run:
            renderer.check(sorted(linked) == run['linkedStoryChains'], 'engine analysis and independent chain audit disagree')
        chain_counts[len(linked)] += 1
        chain_coverage.update(linked)
    pair_count = sum(distances.values())
    bins = [dict(distance=d, frequency=dict(count=distances[d])) for d in range(16)]
    return dict(lives=len(runs), pairs=pair_count, eventDistanceCounts=dict(sorted(distances.items())),
                medianEventDistance=renderer.median_bins(bins), identicalEventPairs=distances[0],
                uniqueEvents=len({s['eventID'] for r in runs for s in r['steps']}),
                linkedChainCounts=dict(sorted(chain_counts.items())), linkedChainCoverage=dict(sorted(chain_coverage.items())),
                atLeastTwoLinkedChains=sum(v for k,v in chain_counts.items() if k>=2),
                finalAt100={key:sum(r['finalResources'][key]==100 for r in runs) for key in renderer.RESOURCES},
                clippedDecisionPoints={key:sum(next(x for x in c['decisionClamps']['resources'] if x['resource']==key)['lostPositivePoints']['count'] for c in cohorts) for key in renderer.RESOURCES},
                clippedHookPoints={key:sum(next(x for x in c['timeJumpClamps']['resources'] if x['resource']==key)['lostPositivePoints']['count'] for c in cohorts) for key in renderer.RESOURCES})


def compare(before, after):
    for report in (before, after):
        renderer.validate_report(report)
    for key in ('seeds','policies','policyVersion','policyDefinitions','countryCodes','decisionAges','runCount','dataVersion'):
        renderer.check(before[key] == after[key], f'experiment grid changed: {key}')
    identity = lambda r: sorted((x['background']['countryCode'],x['background']['householdID'],x['background']['templateID'],x['policy'],x['seed']) for x in r['runs'])
    renderer.check(identity(before)==identity(after),'background/Seed/strategy pairings changed')
    results = [dict(policy=p,before=summarize(before,p),after=summarize(after,p)) for p in before['policies']]
    return dict(schemaVersion=1,beforeEngine=before['engineVersion'],afterEngine=after['engineVersion'],
                seeds=before['seeds'],runCountEach=before['runCount'],policyVersion=before['policyVersion'],policies=results,
                claimBoundary='Same balanced experiment grid, not population or player frequencies. Different actions may be feasible after content changes. A linked chain requires an actual earlier source choice; new continuations require a feasible distinct lead action. Does not establish fun, real-world causality, or kid/device acceptance.')


def render(result):
    rows=[]
    for item in result['policies']:
        a,b=item['before'],item['after']
        rows.append([renderer.POLICIES[item['policy']], a['lives'], f"{a['medianEventDistance']} → {b['medianEventDistance']}",
                     f"{a['finalAt100']['relationships']} → {b['finalAt100']['relationships']}",
                     f"{a['atLeastTwoLinkedChains']} → {b['atLeastTwoLinkedChains']}"])
    return '\n'.join(['# RNG-V2 新舊比較','',f"每版 {result['runCountEach']} 局；Seed 0～31；四國×兩家庭×四策略。舊引擎 `{result['beforeEngine']}`，新引擎 `{result['afterEngine']}`。",'',
        renderer.table(['策略','局數','事件差異中位數／15','最終人際100局數','至少兩條實質連結局數'],rows),'',
        '事件差異只比較同背景、同策略的不同 Seed，共 15,872 對。每種策略 3,968 對，沒有刪掉相同路線。完整分群與同 Seed 不同策略的 1,536 對比較見 baseline.md／current.md。','',
        '40 個事件、5 個固定里程碑及 10 個動態時點。七條故事線都能影響後續人物、情境或可用行動；新增線必須真的提供可行的帶領行動才計入實質連結。只有標題變體不計。','',
        '多樣性達到探索性 5／15 目標，但每局兩條實質故事連結仍未普遍達成。舊版的三個後續節點固定出現；新版有機會遇到其他故事，因此既有線的收束頻率下降。求助和休息策略尤其需要真人驗證是否仍能形成角色牽掛；不為了達標強迫建立未選擇的約定。','',
        '依基準的觸頂來源，把每次學習的額外支持由人際+2改為+1，延遲呼應保留技能+1及故事記憶、取消自動人際+2。其他選項保留不同取捨。封頂仍可能發生，UI顯示實際效果與上限說明。','',
        '這是有限測試格的工程證據，不是娛樂性、現實機率或教育成效證明。實機、人工 VoiceOver、10～15 分鐘真人節奏與 10～12／13～15 歲分齡試玩仍未驗收。PR 保持 Draft／HOLD，不合併。',''])


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('before',type=Path);parser.add_argument('after',type=Path);parser.add_argument('output',type=Path)
    args=parser.parse_args()
    result=compare(renderer.read_json(args.before),renderer.read_json(args.after))
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.with_suffix('.json').write_text(json.dumps(result,ensure_ascii=False,indent=2,sort_keys=True)+'\n')
    args.output.with_suffix('.md').write_text(render(result))

if __name__=='__main__':main()
