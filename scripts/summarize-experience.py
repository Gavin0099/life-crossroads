#!/usr/bin/env python3
"""Summarize executed experience-audit-1 evidence; no product percentage or synthetic observations."""
import argparse, collections, hashlib, itertools, json, statistics
from pathlib import Path


def summarize(report, catalog):
    if report['version']!='experience-audit-1': raise ValueError('unsupported report')
    if report['contentVersion']!=catalog['contentVersion']: raise ValueError('catalog version mismatch')
    families={h['id']:h for h in catalog['households']}
    def signature(run):
        # Country/id/translated label identify the instance; every other authored family condition must match.
        return {k:v for k,v in families[run['household']].items() if k not in ['countryCode','id','label']}
    runs=report['runs']
    if len({(r['household'],r['seed'],r['policy']) for r in runs})!=len(runs): raise ValueError('duplicate runs')
    if any(len(r['events'])!=15 or len(r['choices'])!=15 or not r['replayMatched'] for r in runs): raise ValueError('incomplete/replay failure')
    groups=collections.defaultdict(list)
    for run in runs: groups[(run['household'],run['policy'])].append(run)
    cohorts=[]
    for (family,policy), group in sorted(groups.items()):
        distances=[sum(a!=b for a,b in zip(x['events'],y['events'])) for x,y in itertools.combinations(group,2)]
        links={cat:dict(livesWithOpportunity=sum(any(l['category']==cat for l in r['connections']) for r in group),
                       livesAccepting=sum(any(l['category']==cat and l['accepted'] for l in r['connections']) for r in group))
               for cat in ['growth','support','recovery','relationship','environment']}
        cohorts.append(dict(household=family,policy=policy,lives=len(group),seedPairs=len(distances),
            eventDifferenceMedian=statistics.median(distances) if distances else None,connections=links,
            livesWithTwoDistinctLinkedRules=sum(len({l['ruleID'] for l in r['connections']})>=2 for r in group),
            finalAt100={k:sum(r['finalResources'][k]==100 for r in group) for k in ['health','financial','relationships','skills']}))
    witnesses=[]
    # Mechanism witnesses from real complete runs, not selected or synthesized outcomes.
    # Compare actual template IDs AND all family conditions from the version-matched pinned catalog.
    for axis,first,last in [('offlineTools','young-power-table','adult-tools-coop'),('carePreparation','adult-care-map','middle-care-followup')]:
        found=None
        for a in runs:
            if a['country']!='JPN' or a['policy']!='investFirst': continue
            b=next((r for r in runs if r['country']=='KEN' and signature(r)==signature(a) and r['policy']==a['policy'] and r['seed']==a['seed']),None)
            if not b: continue
            ar={r['eventID']:r for r in a['environmentReceipts']};br={r['eventID']:r for r in b['environmentReceipts']}
            if not all(k in ar and k in br for k in (first,last)): continue
            if any(ar[k]['age']!=br[k]['age'] for k in (first,last)): continue
            if ar[last]['storyVariantID']==br[last]['storyVariantID']: continue
            if any(r[last]['storyBranch']['sourceEventID']!=first for r in (ar,br)): continue
            found=dict(axis=axis,seed=a['seed'],familyTemplate=families[a['household']]['templateID'],familyConditions=signature(a),policy=a['policy'],
                original=dict(country=a['country'],events=a['events'],choices=a['choices'],focus=a['focus'],traces=[ar[first],ar[last]]),
                alternative=dict(country=b['country'],events=b['events'],choices=b['choices'],focus=b['focus'],traces=[br[first],br[last]]),
                boundary='同家庭模板、Seed及選擇策略的兩局實跑；不同路線使用不同可行行動。不能將整個後半生差異都歸因於單一環境值。')
            break
        if found: witnesses.append(found)
    return dict(version='experience-summary-1',engineVersion=report['engineVersion'],contentVersion=report['contentVersion'],
        runCount=len(runs),countries=sorted({r['country'] for r in runs}),households=sorted({r['household'] for r in runs}),
        eventCoverage=len(report['eventCounts']),eventCounts=report['eventCounts'],unobservedEvents=report['unobservedEvents'],
        allReplayMatched=True,policyDescription=report['policyDescription'],cohorts=cohorts,pairedEnvironmentWitnesses=witnesses,
        claimBoundary=report['claimBoundary'])

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('input',type=Path);p.add_argument('output',type=Path);p.add_argument('--catalog',type=Path,required=True);a=p.parse_args()
    data=a.input.read_bytes();out=summarize(json.loads(data),json.loads(a.catalog.read_bytes()));out['catalogSHA256']=hashlib.sha256(a.catalog.read_bytes()).hexdigest();out['rawSHA256']=hashlib.sha256(data).hexdigest()
    a.output.write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n')
    print(f"{out['runCount']} lives; {out['eventCoverage']} events observed; {len(out['pairedEnvironmentWitnesses'])} paired non-digital continuation witnesses")
