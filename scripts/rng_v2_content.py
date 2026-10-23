"""Original, versioned story design for RNG-V2. No national success rates or reference-game content."""

def extend(decisions, assumptions):
    def resources(**values):
        return dict(health=values.get('health',0), financial=values.get('financial',0), relationships=values.get('relationships',0), skills=values.get('skills',0))
    def change(key, value, person='', delta=0):
        return dict(key=key,value=value,personID=person,relationshipDelta=delta)
    def choice(id_,title,kind,effect,cost=2,changes=(),digital=False):
        return dict(id=id_,title=title,kind=kind,control='personal',minimumAge=0,timeCost=cost,energyCost=1 if cost else 0,
                    materialCost=0,effect=resources(**effect),requiresDigitalAccess=digital,delayedHook=None,
                    storyChanges=list(changes),assumptionIDs=['choice-effects','story-branches','agency'])
    def rest(title='今天不接新的安排，留時間好好休息'):
        return choice('rest',title,'rest',dict(health=2),0)
    def support(title,changes=()):
        return choice('seekGuide',title,'askSupport',dict(relationships=1,skills=1),1,changes)
    def policy(lo,hi,category,flag=None,values=(),person=None,weight=1):
        return dict(minimumAge=lo,maximumAge=hi,category=category,baseWeight=weight,repeatable=False,cooldownDecisions=1,
                    exclusiveGroup=None,continuityFlag=flag,continuityValues=list(values),relationshipID=person,resourceWeights=[])
    milestones={'child-interest','child-friend','teen-project','adult-care','later-review'}
    windows={'child-transition':(12,12),'teen-direction':(17,25),'teen-launch':(21,25),'adult-learning':(25,45),
             'adult-balance':(32,52),'middle-turn':(45,59),'middle-support':(52,72),'middle-rhythm':(59,72),
             'later-pass-on':(65,72),'later-reconnect':(72,72),
             'child-library-map':(12,12),'child-wind-team':(12,17),'teen-repair-table':(17,32),
             'teen-shared-kitchen':(17,32),'adult-neighbor-market':(25,52),'middle-garden-table':(32,65),
             'middle-open-desk':(45,72),'later-voice-booth':(59,72)}
    routes={'teen-direction':('learning',['online','paper'],'teacher'), 'teen-repair-table':('learning',['online','paper'],'teacher'),
            'child-wind-team':('friendship',['connected'],'ahe'),'later-reconnect':('friendship',['connected'],'ahe'),
            'middle-support':('care',['shared'],'cheng'),'middle-open-desk':('care',['shared'],'cheng')}
    for e in decisions:
        category={'learn':'learning','work':'work','care':'care','share':'community'}[next(c for c in e['choices'] if c['id']=='invest')['kind']]
        if e['id'] in ('child-friend','later-reconnect','child-wind-team'): category='friendship'
        if e['id']=='later-review': category='reflection'
        lo,hi=windows.get(e['id'],(e['age'],e['age']))
        route=routes.get(e['id'],(None,[],None))
        e['selection']=policy(lo,hi,category,*route)
        e['continuation']=None
        for c in e['choices']: c['storyChanges']=[]
        for cond in e['eligibility']:
            if cond['kind']=='priorChoice':
                cond['kind']='storyFlag'
                cond['key'],cond['choiceIDs']={'child-friend':('friendship',['connected']),'teen-project':('learning',['online','paper']),'adult-care':('care',['shared'])}[cond['key']]
    byid={e['id']:e for e in decisions}
    def setchange(event, mapping):
        for c in byid[event]['choices']:
            c['storyChanges']=mapping.get(c['id'],[])
    setchange('child-friend',{'invest':[change('friendship','connected','ahe',2)],'ask':[change('friendship','connected','ahe',1)],'rest':[change('friendship','paused')]})
    setchange('teen-project',{'invest':[change('learning','online','teacher',1)],'offline':[change('learning','paper','teacher',1)],'rest':[change('learning','none')],'ask':[change('learning','none','teacher',1)]})
    setchange('adult-care',{'invest':[change('care','shared','cheng',2)],'ask':[change('care','seeking','cheng',1)],'rest':[change('care','paused')]})
    setchange('teen-repair-table',{'invest':[change('repair','practiced','teacher',2)],'ask':[change('repair','seeking','teacher',1)]})
    setchange('teen-shared-kitchen',{'invest':[change('kitchen','shared','cheng',2)],'ask':[change('kitchen','seeking','cheng',1)]})
    setchange('middle-garden-table',{'invest':[change('garden','tending','cheng',2)],'ask':[change('garden','seeking','cheng',1)]})
    # Recovery actions also create real antecedents; no reliance on a specific age or event ID.
    setchange('middle-support',{'invest':[change('care','shared','cheng',1)],'ask':[change('care','seeking','cheng',1)],'shareShift':[change('care','shared','cheng',1)]})
    setchange('teen-direction',{'invest':[change('learning','online','teacher',1)],'offline':[change('learning','paper','teacher',1)]})
    def add(id_,age,lo,hi,title,person,question,category,choices,flag=None,values=(),personid=None,continuation=None):
        e=dict(id=id_,age=age,title=title,recurringPerson=person,storyQuestion=question,choices=choices,
               isFallback=False,eligibility=[],selection=policy(lo,hi,category,flag,values,personid),continuation=continuation)
        decisions.append(e);byid[id_]=e
    def follow(flag,active,title,recovery,minimum=24):
        return dict(flag=flag,activeValues=[active],unlockedChoices=['lead'],minimumSkills=minimum,activeTitle=title,recoveryTitle=recovery)
    add('child-rain-notebook',12,12,17,'雨後的小路留下了線索','阿禾','想觀察自然，也要怎樣照顧自己的安全？','nature',[
        choice('observe','和大人沿安全步道畫下雨後的植物','learn',dict(skills=3,health=-1),2,[change('nature','observing','ahe',1)]),
        support('請大人陪你從窗邊開始觀察',[change('nature','seeking','ahe',1)]),rest('把觀察本收好，等天氣合適再出發')])
    add('child-quiet-stage',12,12,17,'阿禾想在班上表演','阿禾','上台與在幕後幫忙，哪種方式適合你？','friendship',[
        choice('perform','和阿禾排練一段短劇','share',dict(relationships=2,skills=2,health=-1),2,[change('friendship','connected','ahe',2)]),
        choice('backstage','和大人一起幫忙整理安全道具','learn',dict(skills=2),1,[change('repair','seeking','teacher',1)]),rest('告訴阿禾這次想當觀眾')])
    add('teen-tool-library',17,17,32,'工具圖書角招募學習夥伴','樹老師','買新的，還是花時間學會借用與維修？','learning',[
        choice('practice','先學安全檢查，再修一件舊玩具','learn',dict(skills=3,financial=-1),2,[change('repair','practiced','teacher',1)]),
        support('請樹老師陪你登記借用工具',[change('repair','seeking','teacher',1)]),rest()])
    add('teen-river-survey',17,17,32,'步道觀察隊出發前','阿禾','已有的觀察經驗，可以怎樣和新夥伴分享？','nature',[
        choice('lead','帶隊整理觀察位置，練習說明安全界線','share',dict(skills=2,relationships=2,health=-1),3,[change('nature','observing','ahe',1)]),
        choice('join','和隊員學記錄植物與天氣','learn',dict(skills=3),2,[change('nature','observing','ahe',1)]),
        support('請隊員安排一段短而安全的路線',[change('nature','seeking','ahe',1)]),rest()],
        'nature',['observing'],'ahe',follow('nature','observing','阿禾帶來你以前的觀察本','從第一張觀察卡認識步道'))
    add('teen-shared-room',21,21,32,'合租的空間要怎樣使用','小澄','安靜、租金與彼此的界線怎麼談？','community',[
        choice('agreement','一起寫清楚安靜時段與共用物品規則','share',dict(relationships=2,financial=1),2,[change('kitchen','seeking','cheng',1)]),
        choice('privateRoom','保留獨處的角落，承擔多一點租金','rest',dict(health=2,financial=-3),1),rest('先不換住處，讓自己多想一天')])
    add('adult-repair-coop',25,25,59,'修理桌想多開一天','樹老師','接案收入與教新手，時間要如何安排？','work',[
        choice('lead','帶新手檢查玩具，分配修理桌工作','work',dict(financial=3,skills=2,health=-1),2,[change('repair','practiced','teacher',1)]),
        choice('apprentice','少接一份工作，跟樹老師慢慢練習','learn',dict(financial=-2,skills=3),2,[change('repair','practiced','teacher',1)]),
        support('請樹老師安排短時段合作',[change('repair','seeking','teacher',1)]),rest()],
        'repair',['practiced'],'teacher',follow('repair','practiced','樹老師邀你一起主持修理桌','還沒有修理經驗，也可以從旁學習'))
    add('adult-meal-circle',25,25,59,'共煮夥伴想試一週輪值','小澄','省下一點開銷，是否值得固定付出時間？','care',[
        choice('lead','接續共煮表，邀新夥伴分擔採買','share',dict(financial=2,relationships=2,health=-1),2,[change('kitchen','shared','cheng',1)]),
        choice('trial','先試一天共煮，寫下自己的空閒','share',dict(financial=1,relationships=1),1,[change('kitchen','shared','cheng',1)]),
        support('請小澄找較短的共煮時段',[change('kitchen','seeking','cheng',1)]),rest()],
        'kitchen',['shared'],'cheng',follow('kitchen','shared','一起延續那張共煮輪值表','第一次加入共煮，先從一天開始',20))
    add('adult-local-trail',25,25,59,'社區想留住一條好走的步道','阿禾','觀察、分享與日常工作要怎麼安排？','nature',[
        choice('lead','整理以前的觀察，帶大家標記安全路段','share',dict(skills=2,relationships=2,health=-1),3,[change('nature','observing','ahe',1)]),
        choice('record','和阿禾分段記錄沿路植物','learn',dict(skills=3),2,[change('nature','observing','ahe',1)]),
        support('請夥伴分配適合體力的短路段',[change('nature','seeking','ahe',1)]),rest()],
        'nature',['observing'],'ahe',follow('nature','observing','從觀察本走到社區步道計畫','沒有舊記錄，也能從今天開始'))
    add('adult-shift-offer',25,25,52,'新排班有兩種安排','工作夥伴','多一點收入和準時回家，你現在需要什麼？','work',[
        choice('extraShift','短期多接一班，記下休息日期','work',dict(financial=4,health=-2,relationships=-1),3),
        choice('predictable','保留穩定的下班時間，少接一些班','share',dict(financial=-2,health=2,relationships=1),1),rest('暫不接額外班次，先看看現有負擔')])
    add('adult-broken-bicycle',32,25,59,'常用的腳踏車需要修理','樹老師','修理費、時間與通勤安排怎樣取捨？','recovery',[
        choice('repairTogether','跟樹老師檢查安全零件，學一次修理','learn',dict(financial=-2,skills=3),2,[change('repair','practiced','teacher',1)]),
        choice('borrow','先借車，說好歸還日期','askSupport',dict(relationships=1,financial=-1),1,[change('repair','seeking','teacher',1)]),rest('改走安全的短路線，等有空再處理')])
    add('middle-seed-exchange',45,45,72,'花圃的小種子交換會','小澄','照顧植物的經驗，要怎樣交給下一個人？','nature',[
        choice('lead','用自己的輪值經驗帶大家照顧幼苗','share',dict(relationships=2,skills=2),2,[change('garden','tending','cheng',1)]),
        choice('onePot','只認養一盆，和夥伴約好輪流澆水','share',dict(health=1,relationships=1),1,[change('garden','tending','cheng',1)]),
        support('請小澄挑一盆適合新手的植物',[change('garden','seeking','cheng',1)]),rest()],
        'garden',['tending'],'cheng',follow('garden','tending','帶著照顧過的花圃經驗交換種子','從一盆植物開始的新約定',20))
    add('middle-friend-letter',45,32,65,'一封還沒寄出的問候','阿禾','忙碌之後，還能怎樣重新開始聯絡？','friendship',[
        choice('write','寫一張簡短的近況卡，重新約一次碰面','share',dict(relationships=2),1,[change('friendship','connected','ahe',1)]),
        support('請共同朋友問問方便聯絡的時間',[change('friendship','connected','ahe',1)]),rest('先留好地址，今天不勉強自己回覆')])
    add('middle-skill-exchange',45,32,65,'工作夥伴想交換一項技能','工作夥伴','用熟悉的事換新知，也會少掉什麼時間？','learning',[
        choice('teach','分享自己熟悉的做法，換一次學習機會','share',dict(skills=2,relationships=2,health=-1),2),
        choice('study','專心學一項新技能，暫緩額外工作','learn',dict(skills=4,financial=-2),2,[change('learning','paper','teacher',1)]),rest()])
    add('middle-rest-circle',52,45,72,'夥伴發現大家都有些累','小澄','說出負擔後，可以調整哪一件事？','recovery',[
        choice('boundaries','和夥伴重新安排照顧界線','askSupport',dict(health=2,relationships=1),1,[change('care','shared','cheng',1)]),
        choice('walk','把今天的空檔留給一段慢走','rest',dict(health=3,financial=-1),1),rest('今天先睡飽，等精力回來再討論')])
    add('later-tool-stories',65,59,72,'舊工具和新的學習者','樹老師','修得好之外，還想傳下什麼？','learning',[
        choice('lead','帶新手練安全檢查，分享修理失敗的經驗','share',dict(skills=1,relationships=2),2),
        choice('learnAgain','和新手一起學不熟悉的修理方法','learn',dict(skills=2),2,[change('repair','practiced','teacher',1)]),
        support('請夥伴先準備材料，自己只教一小段'),rest()],
        'repair',['practiced'],'teacher',follow('repair','practiced','那些修過的玩具帶來了新學生','和新學生一起從安全檢查開始'))
    add('later-shared-recipes',65,59,72,'共煮桌想留下一本食譜','小澄','留下食譜，還是把時間留給眼前的聚餐？','community',[
        choice('lead','整理輪值經驗和食譜，讓新夥伴能接手','share',dict(skills=2,relationships=2),2),
        choice('cookOnce','只一起煮一道簡單的菜，享受相聚','share',dict(health=1,relationships=1),1,[change('kitchen','shared','cheng',1)]),
        support('請夥伴記錄，自己慢慢口述'),rest()],
        'kitchen',['shared'],'cheng',follow('kitchen','shared','把一起煮過的日子寫進食譜','從一道簡單的菜認識新夥伴',20))
    add('later-path-map',72,59,72,'一張讓大家走得更安心的地圖','阿禾','經驗、體力與社區需要，能怎樣一起安排？','nature',[
        choice('lead','用觀察記錄標出平緩路段和休息處','share',dict(skills=2,relationships=2),2),
        choice('shortWalk','與夥伴試走一小段，記下自己的感受','share',dict(health=1,skills=1),1,[change('nature','observing','ahe',1)]),
        support('請夥伴陪走，讓不同需求都被聽見'),rest()],
        'nature',['observing'],'ahe',follow('nature','observing','觀察本成了社區步道圖的起點','一張空白地圖也能慢慢畫起'))
    # These two work opportunities represent mutually exclusive commitments for this short life.
    for id_ in ('adult-shift-offer','adult-neighbor-market'): byid[id_]['selection']['exclusiveGroup']='side-work-commitment'
    byid['middle-rest-circle']['selection'].update(repeatable=True,cooldownDecisions=2,resourceWeights=[dict(resource='health',atMost=60,multiplier=1.5)])
    byid['adult-broken-bicycle']['selection']['resourceWeights']=[dict(resource='financial',atMost=45,multiplier=1.25)]
    # Protect childhood agency and age windows, regardless of an event's nominal authored age.
    for e in decisions:
        if e['selection']['minimumAge']<=12:
            for c in e['choices']:
                if c['kind'] not in ('rest','askSupport'): c['control']='sharedWithAdult'
        if e['id'] in ('adult-shift-offer','adult-repair-coop'):
            for c in e['choices']:
                if c['kind']=='work': c['control']='adultResponsibility'; c['minimumAge']=23
    for a in assumptions:
        if a['id']=='event-selection':
            a.update(version='2.0.0',statement='15個時點、5個里程碑；年齡範圍、故事事實、資源與家庭資格篩選。候選各有獨立亂數鍵，以加權指數競賽抽選；權重、一次性、冷卻與互斥皆記錄於trace。',limitation='所有權重和門檻都是遊戲假設，不是現實機率；已遇見的同一情境用於跨國成本比較。')
        if a['id']=='story-branches':
            a.update(version='2.0.0',statement='友情、學習、照顧、修理、共煮、花圃與自然觀察七條故事記錄，由實際決策重建；參與或重新求助可接續後續人物與可用行動。',limitation='有前期參與不保證抽到後續邀請；沒有舊經驗也保留恢復路線。')
        if a['id']=='support-network':
            a.update(version='2.0.0',statement='支援依家庭模板降低準備時間；一起學習額外增加人際1、技能1，避免把同一支持重複獎勵。',limitation='虛構家庭支持，不由國名推定；不是統計因果。')
        if a['id']=='story-callback':
            a.update(version='2.0.0',statement='延遲呼應保留人物記憶並增加技能1，不再自動疊加人際2；其來源、實際發生年齡和效果留在trace。',limitation='故事記憶不等於人際總量；這是依舊版批次觸頂觀察調整的遊戲假設。')
    assert len(decisions)==40
