#!/usr/bin/env python3
"""Render actual LC-03 execution evidence; omit unknown costs from numeric comparisons."""
import argparse
import gzip
import hashlib
import json
from pathlib import Path

CODES={'TWN','JPN','USA','DEU','IND','BRA','VNM','KEN'}

def summarize(report):
    samples=report['samples']; runs=report['runs']
    if {s['eventID'] for s in samples}!={'child-interest','teen-project','adult-care','middle-support'}:
        raise ValueError('missing comparable-decision witnesses')
    if len(runs)!=128 or {r['countryCode'] for r in runs}!=CODES:
        raise ValueError('incomplete eight-country policy matrix')
    keys=[(r['countryCode'],r['householdID'],r['policy'],r['seed']) for r in runs]
    if len(set(keys))!=128:raise ValueError('duplicate runs')
    for country in CODES:
        local=[r for r in runs if r['countryCode']==country]
        families={r['householdID'] for r in local}
        if len(families)!=2:raise ValueError('country must have two households')
        for family in families:
            members=[r for r in local if r['householdID']==family]
            if {r['policy'] for r in members}!={'investFirst','supportFirst','restFirst','seededVariety'}:
                raise ValueError('missing choice strategy')
            for policy in {r['policy'] for r in members}:
                if {r['seed'] for r in members if r['policy']==policy}!={0,3}:
                    raise ValueError('unpaired Seed matrix')
    for r in runs:
        if not r['replayAndRestoreMatch'] or len(r['traces'])!=15 or r['traces'][-1]['age']!=80:
            raise ValueError('incomplete replayed life')
    summary=[]
    for sample in samples:
        rows=sample['comparisons']
        if len(rows)!=8 or {r['trace']['countryCode'] for r in rows}!=CODES:raise ValueError('unpaired countries')
        formatted=[]
        for row in rows:
            t=row['trace']
            if t['seed']!=sample['seed'] or t['choiceID']!=sample['choiceID'] or t['eventID']!=sample['eventID']:
                raise ValueError('unpaired event/choice/seed')
            qualified=not t['environmentGaps']
            formatted.append(dict(country=t['countryCode'],household=t['householdID'],
                cost=t['finalCost'] if qualified else None,feasible=t['applied'] if qualified else None,
                missing=t['environmentGaps'],support=[s for s in t['costSteps'] if s['ruleID'].startswith('support.')],
                alternatives=row['availableAlternatives'],storyFacts=t['recordedStoryFacts'],
                sourceRules=[s for s in t['costSteps'] if s['sourceIDs']]))
        summary.append(dict(eventID=sample['eventID'],age=sample['age'],seed=sample['seed'],choice=sample['choiceID'],rows=formatted,households=sample['householdComparison']))
    differences=sum(len({(r['cost']['time'],r['cost']['materials'],r['feasible']) for r in s['rows'] if r['cost'] is not None})>1 for s in summary)
    if differences<3:raise ValueError('three distinct environmental decision witnesses not observed')
    routes=[dict(country=r['countryCode'],household=r['householdID'],seed=r['seed'],policy=r['policy'],
                 steps=[{**{k:t[k] for k in ['age','eventID','choiceID','resourcesAfter','recordedStoryFacts','environmentGaps']}, 'storyVariantID':t.get('storyVariantID')} for t in r['traces']]) for r in runs]
    return dict(engineVersion=report['engineVersion'],dataVersion=report['dataVersion'],claimBoundary=report['claimBoundary'],runCount=128,policies=report['policies'],samples=summary,runs=routes)

def render(summary):
    lines=['# LC-03 八國環境：執行比較','',summary['claimBoundary'],'',
           '128局（8國×2家庭×4既有明列策略×Seed0/3）完成至80歲；同版本同選擇重播與Codable恢復由CLI逐局比對。策略定義、完整選擇及故事見同名JSON；完整trace見壓縮原始檔/CI artifact。',
           '', '## 相同事件與行動的快照比較','',
           '固定實際事件、選前狀態、前史、Seed及家庭模板。此表不會把台灣未知成本記作0；CHE/GDP只作背景，沒有推導個人服務或成功率。']
    for s in summary['samples']:
        lines += ['',f"### {s['age']}歲 / {s['eventID']} / {s['choice']} / Seed {s['seed']}",'','|國家|時間/精力/材料|可行性|實際可行替代|','|---|---|---|---|']
        for r in s['rows']:
            cost=r['cost']; value=f"{cost['time']}/{cost['energy']}/{cost['materials']}" if cost else '未估完整成本（非0）'
            feasible=('可安排' if r['feasible'] else '本回合預算不足') if r['feasible'] is not None else '不作跨國判斷'
            alternatives='、'.join(a['id']+('（家庭試算）' if a['environmentGaps'] else '') for a in r['alternatives'])
            lines.append(f"|{r['country']}|{value}|{feasible}|{alternatives}|")
        lines+=['','支持由實際家庭安排計算，來源及假設列於JSON的support/sourceRules；不是按國籍給支持倍率。']
    lines+=['','## 實際後續路線','', '|國家/家庭|策略|前因選擇|後續照顧情境|','|---|---|---|---|']
    witnesses=0
    for r in summary['runs']:
        if r['policy']!='investFirst':continue
        care=next((t for t in r['steps'] if t['eventID']=='adult-care'),None)
        if care is None:raise ValueError('missing care milestone')
        later=[t for t in r['steps'] if t['eventID']=='middle-support']
        lines.append(f"|{r['country']}/{r['household']} Seed{r['seed']}|{r['policy']}|39歲 {care['choiceID']}|"+('、'.join(str(t['age'])+'歲 '+str(t['storyVariantID']) for t in later) if later else '本局未抽中；不編造呼應')+'|')
        witnesses+=len(later)
    lines+=['','不是每局必定遇到後續事件；先前選擇可能改變候選資格/權重與選項。各路後續另有選擇及運氣，不作單一原因歸因。',
            '', '## 未完成驗收','',
            '- 台灣全人口數位與不含商保理賠的WHO口徑自付資料仍缺；八國可玩不等於所有成本可定量比較。',
            '- 共用寓言故事不宣稱完整重現各國制度；在地內容、實機、人工VoiceOver、兒少理解與10～15分鐘節奏待驗收。',
            '- 舊版存檔因引擎/資料/內容版本變更會明確拒絕，原檔保留；未交付自動遷移。','']
    return '\n'.join(lines)

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('input');parser.add_argument('output');args=parser.parse_args()
    raw=Path(args.input).read_bytes();summary=summarize(json.loads(raw));out=Path(args.output);out.parent.mkdir(parents=True,exist_ok=True)
    out.with_suffix('.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n')
    out.with_suffix('.md').write_text(render(summary))
    out.with_suffix('.full.json.gz').write_bytes(gzip.compress(raw,mtime=0))
    out.with_suffix('.sha256').write_text(hashlib.sha256(raw).hexdigest()+'  uncompressed full execution JSON\n')
    print('LC-03: 128 complete replayed lives; 3 differing decision comparisons and 1 equal offline control; unknown costs excluded')
