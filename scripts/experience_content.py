"""Original lived-experience dilemmas. All thresholds are fictional game rules."""

def extend(catalog):
    catalog['contentVersion']='p1-experience-story-1'
    for assumption in catalog['assumptions']:
        if assumption['id']=='event-selection':
            assumption['version']='3.0.0'
            assumption['statement'] += '完成的生活重心依life-focus-story設定，提高相關候選活動權重；不改獨立亂數鍵。'
    catalog['assumptions'] += [
        dict(id='life-focus-story',version='1',statement='完成的生活重心區間留下記錄。重心不直接額外加資源，資源變化由實際事件產生。四種重心提高相關活動權重2倍，且至少一段準備才開放各活動的延續行動。重心不保證抽中、接受邀請或成功。',limitation='虛構遊戲規則；非現實機率。只在已完成時間推進後生效，不重抽眼前事件。'),
        dict(id='environment-opportunities',version='1',statement='醫療直接自付背景依既有1/2/3格準備成本，加行動材料後與家庭本回合材料預算相比；可負擔提供預約安排，否則先商量共同預備。離線工具活動：電力取得率95%以上準備0格，否則多1格時間及材料；多準備且有家庭支持時提供手動攜帶箱。後續只接續實際採取的行動。',limitation='門檻、家庭與機會皆為虛構模型，不是個人醫療費用、供電穩定性、治療品質、就業率或國家優劣；缺值不估計。'),
        dict(id='support-recovery-story',version='1',statement='提出求助只記為請求；再次確認安排才記為支持。為休息留空白只記為界線；之後可自願調整參與方式，不自動產生友誼或工作。',limitation='求助與休息不是失敗，也不保證他人一定有空。人物與機會均為原創虛構情境。')]
    def fact(key,value,person=''):
        return dict(key=key,value=value,personID=person,relationshipDelta=1 if person else 0)
    def choice(id,title,kind='share',time=1,materials=0,changes=(),h=0,f=0,r=0,s=0,**extra):
        return dict(id=id,title=title,kind=kind,control='personal',minimumAge=0,timeCost=time,energyCost=1 if time else 0,materialCost=materials,
            requiresDigitalAccess=False,effect=dict(health=h,financial=f,relationships=r,skills=s),delayedHook=None,storyChanges=list(changes),
            assumptionIDs=['choice-effects','agency','support-recovery-story'],**extra)
    def rest(title='今天先不接新安排，留時間休息'):
        return choice('rest',title,'rest',0,h=2,changes=[fact('recovery','protected')])
    def ask(title='先說出自己的需要，詢問可用的協助'):
        return choice('ask',title,'askSupport',1,r=1,changes=[fact('support','requested')])
    def add(id,age,lo,hi,title,person,question,category,choices,flag=None,values=(),focus=None,continuation=None):
        event=dict(id=id,age=age,title=title,recurringPerson=person,storyQuestion=question,choices=choices,isFallback=False,eligibility=[],
            selection=dict(minimumAge=lo,maximumAge=hi,category=category,baseWeight=1,repeatable=False,cooldownDecisions=1,
                exclusiveGroup=None,continuityFlag=flag,continuityValues=list(values),relationshipID=None,resourceWeights=[],focusAffinity=focus),continuation=continuation)
        for c in choices:
            if lo<=12 and c['kind'] not in ('rest','askSupport'): c['control']='sharedWithAdult'
            if c['kind']=='work': c.update(control='adultResponsibility',minimumAge=23)
        catalog['decisions'].append(event)
        return event
    def follow(flag,values,unlocked,active,first):
        return dict(flag=flag,activeValues=values,unlockedChoices=unlocked,minimumSkills=0,activeTitle=active,recoveryTitle=first)
    def focus_event(id,age,lo,hi,title,person,question,focus,prepared,first,active):
        e=add(id,age,lo,hi,title,person,question,'recovery' if focus=='recovery' else 'learning' if focus=='learning' else 'friendship' if focus=='relationships' else 'work',
            [prepared,first,ask(),rest()],focus=focus)
        e['focusContinuation']=dict(focus=focus,minimumIntervals=1,unlockedChoiceID=prepared['id'],activeTitle=active,firstTitle=title)
    focus_event('child-lending-notebook',12,12,32,'桌上留著一本空白練習簿','樹老師','圖書角要交換練習方法。拿出未完成的草稿會有點緊張；從頭學也需要時間。','learning',
        choice('shareDraft','帶著平時練習的草稿，和老師交換修改方法','learn',2,s=3,r=1,changes=[fact('learning','paper','teacher')]),
        choice('firstPage','先借一頁圖解，從頭試一次','learn',2,s=2), '平時留下的練習有了交流的位置')
    focus_event('teen-friend-return',21,17,45,'阿禾的日曆還有一個空格','阿禾','你們的空閒並不相同。約一個短時段、一起做件事，或今天先不答應？','relationships',
        choice('makeTime','接續平時的問候，約好一小段一起做事的時間','share',2,r=2,h=-1,changes=[fact('friendship','connected','ahe')]),
        choice('sendCard','先送一張近況卡，等彼此方便再約','share',1,r=1,changes=[fact('friendship','connected','ahe')]),'平時的問候接成一次短短的相聚')
    focus_event('adult-boundary-calendar',32,25,65,'新活動碰上原本的休息日','小澄','夥伴想多開一天活動。答應全部會很累；你也可以提出只做一小段。','recovery',
        choice('pacedRole','拿出保留下來的空閒，商量只參與一小段','share',1,r=1,s=1,changes=[fact('recovery','paced','cheng')]),
        choice('setBoundary','這次先說清楚界線，暫不接工作','rest',1,h=2,changes=[fact('recovery','protected')]),'把練習過的休息界線帶進新的安排')
    focus_event('adult-buffer-envelope',32,25,59,'共用工具的購買單寄來了','小澄','一次買齊會很方便，也會壓縮日常支出。分段準備需要和夥伴再談一次。','stability',
        choice('stagedPlan','帶著整理過的預算，約定分段添購','share',2,materials=1,f=1,s=1,changes=[fact('budget','staged','cheng')]),
        choice('borrowFirst','暫時借用，承擔歸還與保養的時間','share',2,f=-1,r=1),'以前留出的預算讓你能提出分段安排')
    add('teen-asking-again',21,17,32,'求助後，還有一件事要說清楚','樹老師','你想把現在的需要，帶來詢問樹老師。對方還沒有答應；老師這週只有一小段空檔，你想怎樣安排？','learning',[
        choice('confirmHelp','把先前說過的需要列成清單，確認一次短時段協助','askSupport',2,r=2,s=1,changes=[fact('support','arranged','teacher')]),
        ask('先問老師哪個時間方便，再決定自己的安排'),rest()], 'support',['requested'],continuation=follow('support',['requested'],['confirmHelp'],'先前的求助來到了確認時間','第一次把需要說清楚'))
    add('adult-support-revisit',45,32,65,'合作桌需要有人接手十分鐘','樹老師','有舊的協助約定可以再核對；沒有，也可以從詢問需要開始。你能坦白說今天沒有空，互助不是欠債。','community',[
        choice('returnHelp','和曾安排協助的夥伴核對空檔，自願接一小段','share',2,h=-1,r=2,changes=[fact('support','reciprocal','teacher')]),
        ask('說明自己的負擔，請大家另找合適安排'),rest()], 'support',['arranged','reciprocal'],continuation=follow('support',['arranged','reciprocal'],['returnHelp'],'曾經一起安排協助的人又來商量','沒有舊約定，也能從認識需要開始'))
    add('middle-return-slowly',52,45,72,'一份可以重新商量的邀請','小澄','你想回到熟悉的活動，但不必回到以前忙碌的方式。先試短時段，還是繼續休息？','recovery',[
        choice('shortReturn','照著自己留下的界線，試一次短時段參與','share',1,h=1,r=1,changes=[fact('recovery','paced','cheng')]),
        choice('rest','先保留空白，說明這次還不能答應','rest',0,h=2,changes=[fact('recovery','protected')]),ask()], 'recovery',['protected','paced'],continuation=follow('recovery',['protected','paced'],['shortReturn'],'以前留給自己的空白成了新的步調','先辨認自己需要多少休息'))
    add('later-rest-circle-invite',65,59,72,'活動名單旁多了一欄參與方式','小澄','有人坐著整理，有人短暫陪伴。你可以把試過的步調說出來，也可以只來看看。','community',[
        choice('adaptedPlace','沿用試過的短時段安排，和夥伴分配適合的工作','share',1,r=2,changes=[fact('recovery','returned','cheng')]),
        choice('visit','先當訪客，找一個舒服的位置','share',1,h=1,r=1),rest()], 'recovery',['paced','returned'],continuation=follow('recovery',['paced','returned'],['adaptedPlace'],'試過的步調，這次被寫進共同安排','第一次找適合自己的參與方式'))
    add('adult-care-map',32,25,59,'看診行事曆和工作日撞在一起','小澄','需要預留交通與支出，卻還想保留其他生活安排。先確認、一起準備，或改天再商量？','care',[
        choice('reserveVisit','預留這次看診的時間與材料，再確認預約','care',2,materials=1,requiresCareFinancing=True,changes=[fact('careAccess','reserved')],h=1,f=-1),
        choice('sharedPlan','先和夥伴列共同預備清單，尚未完成預約','askSupport',2,r=1,changes=[fact('careAccess','shared','cheng')]),
        choice('askFees','先詢問費用與可用協助，尚未決定看診安排','askSupport',1,r=1,changes=[fact('careAccess','seeking')]),rest()])
    add('middle-care-followup',52,45,72,'生活安排需要再對一次','小澄','如果有先前的清單，今天可以重新核對；還沒有，就先詢問需要。安排時間與負擔，不代表身體已經康復。','care',[
        choice('reviewVisit','核對先前預留的看診與工作時間','care',1,s=1,changes=[fact('careAccess','followed')]),
        choice('reviewShared','接續共同清單，確認誰能協助哪一小段','askSupport',2,r=2,changes=[fact('careAccess','followed','cheng')]),ask(),rest()], 'careAccess',['reserved','shared'])
    add('young-power-table',25,21,45,'修理桌要選一套準備方式','樹老師','這次只在現場做事，不需要上網。電動工具省下一部分動手時間，手動攜帶箱則需要不同的練習。','learning',[
        choice('poweredBench','在現場準備電動工具，先學安全檢查','learn',2,materials=1,requiresElectricTools=True,s=3,f=-1,changes=[fact('tools','powered','teacher')]),
        choice('portableKit','和家人備妥手動攜帶箱，練習分段修理','learn',2,s=2,r=1,changes=[fact('tools','portable','teacher')]),
        choice('manualPractice','先借一件手動工具，從基本檢查學起','learn',1,s=2,changes=[fact('tools','manual','teacher')]),ask(),rest()])
    add('adult-tools-coop',45,32,65,'修理夥伴想一起做一份小工作','樹老師','如果有相應的工具經驗，可以試著合作；還沒有，就從練習開始。接下來仍要留出時間，也可以先不接。','work',[
        choice('benchWork','沿用電動工作桌的經驗，接一份桌邊修理工作','work',2,materials=1,requiresElectricTools=True,f=3,h=-1,changes=[fact('tools','cooperating','teacher')]),
        choice('mobileRepair','帶手動攜帶箱到活動現場，接一段分站修理','work',3,f=2,r=1,h=-1,changes=[fact('tools','cooperating','teacher')]),
        choice('learnManual','先練一件手動修理，這次不接案','learn',2,s=2,f=-1,changes=[fact('tools','manual','teacher')]),ask(),rest()], 'tools',['powered','portable'])
    # Requests and rest leave only the action actually taken, never a promised response.
    for event in catalog['decisions']:
        for c in event['choices']:
            keys={x['key'] for x in c['storyChanges']}
            if c['kind']=='askSupport' and 'support' not in keys:
                c['storyChanges'].append(fact('support','requested'))
            if c['id']=='rest' and 'recovery' not in keys:
                c['storyChanges'].append(fact('recovery','protected'))
            if c['kind']=='askSupport' or c['id']=='rest':
                c['assumptionIDs']=list(dict.fromkeys(c['assumptionIDs']+['support-recovery-story']))
    assert len(catalog['decisions'])==52
    return catalog
