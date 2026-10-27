"""LX-05 original, versioned game opportunities, never country-specific success rates."""
from copy import deepcopy

def extend(catalog):
    catalog['contentVersion'] = 'lx05-opportunity-story-1'
    catalog['assumptions'].append(dict(id='creative-opportunities', version='1',
        statement='13歲投入、紙本、求助後在17歲保留一次後續機會；17歲選擇接續後在25歲再商量。線上創作的後續：macro-friction多用至少2格時間或1格材料時，有家庭指導支持才提供分段下載後面對面共作；負擔較低提供遠距協作。缺可比資料不推定管道。17歲實際遠距／共作經驗分別解鎖25歲遠距試作／在地合作桌。求助、休息及重新入門保留。',
        limitation='所有邀請、能力與機會映射為虛構設計，不是國家教育資源、家庭連線品質、就業機率或現實因果。沒有國家成功倍率，未取得資料不代表沒有機會。'))
    by_id={e['id']:e for e in catalog['decisions']}
    def add(event, source, id_, title, kind, digital, time, effect, memory):
        choice=deepcopy(next(c for c in by_id[event]['choices'] if c['id']==source))
        choice.update(id=id_,title=title,kind=kind,requiresDigitalAccess=digital,timeCost=time,
            effect=effect,delayedHook=None,storyChanges=[dict(key='creative',value=memory,personID='teacher',relationshipDelta=1)],
            assumptionIDs=['creative-opportunities','choice-effects','agency','support-network'])
        if kind=='work': choice.update(control='adultResponsibility',minimumAge=23)
        by_id[event]['choices'].insert(0,choice)
    def effect(h=0,f=0,r=0,s=0): return dict(health=h,financial=f,relationships=r,skills=s)
    add('teen-direction','invest','remoteStudio','和遠方夥伴連線，把作品整理成共同草稿','learn',True,3,effect(f=-1,r=1,s=3),'remote')
    add('teen-direction','offline','mentorRelay','請樹老師分段備好圖解，在共作桌逐步製作','learn',False,2,effect(r=2,s=2),'collective')
    add('adult-learning','invest','portfolio','用遠距協作草稿，參與一份有酬試作','work',True,3,effect(h=-1,f=3,s=2),'remote')
    add('adult-learning','offline','cooperate','和共作夥伴試辦一張在地製作桌','work',False,2,effect(h=-1,f=2,r=2),'collective')
    for c in by_id['teen-direction']['choices']:
        if c['id'] in ['leadWorkshop','offline']: c['storyChanges'].append(dict(key='creative',value='collective',personID='teacher' if c['id']=='leadWorkshop' else '',relationshipDelta=1 if c['id']=='leadWorkshop' else 0))
        if c['id'] in ['ask','rest']: c['storyChanges'].append(dict(key='creative',value='seeking' if c['id']=='ask' else 'paused',personID='',relationshipDelta=0))
    return catalog
