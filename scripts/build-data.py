#!/usr/bin/env python3
"""Rebuild the pinned LC-01 catalog offline. --refresh explicitly downloads WDI evidence."""
import argparse
import hashlib
import json
import urllib.request
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))

ROOT = Path(__file__).resolve().parents[1]
RESOURCES = ROOT / "LifeCrossroads/Data/Resources"
VERSION = "wdi-2023-snapshot-2026-10-23"
DATA_VERSION = "lc01-data-2"
TERMS = "https://www.worldbank.org/ext/en/legal/terms-conditions/datasets"
COUNTRIES = [("TWN", "台灣"), ("JPN", "日本"), ("USA", "美國"), ("DEU", "德國"),
             ("IND", "印度"), ("BRA", "巴西"), ("VNM", "越南"), ("KEN", "肯亞")]
INDICATORS = [
    ("IT.NET.USER.ZS", "internet", "International Telecommunication Union (ITU)"),
    ("EG.ELC.ACCS.ZS", "electricity", "World Bank / ESMAP, SDG 7.1.1 Electrification Dataset"),
]
# Authored fictional scenarios, shared by every country. No country position, label or statistic enters these values.
FAMILY_SCENARIOS = [
    dict(templateID="shared-equipment-near-support", health=66, financial=35, relationships=65,
         deviceAccess="shared", travelCost=0, careLoad=1, mentorSupport=2, materialBudget=2,
         description="共用設備、近處互助、家人輪班"),
    dict(templateID="own-equipment-long-commute", health=64, financial=60, relationships=50,
         deviceAccess="own", travelCost=1, careLoad=0, mentorSupport=1, materialBudget=4,
         description="獨用設備、較遠通勤、收入較穩"),
]
DIGITAL_TITLES = {
    "teen-project": "用線上圖解製作互動作品",
    "teen-direction": "參加需要連網的遠距課程",
    "adult-learning": "投入線上進修課程",
    "middle-turn": "用遠距課程學新技能",
}
# Authored action labels. Stable IDs are for replay; the child sees the concrete action and its tradeoff.
EVENT_CHOICES = {
    "child-interest": ("和大人把紙箱做成會動的玩具", "請大人幫忙借安全工具和紙本圖解", "先收好紙箱，留時間打球與休息"),
    "child-friend": ("和阿禾完成雙人風車，約好保持聯絡", "請阿禾和大人一起調整碰面方式", "今天自己休息，暫時不約下次"),
    "child-transition": ("和樹老師一起畫新學校的探路圖", "請樹老師陪你列出開學前的問題", "先照顧心情，今晚早一點休息"),
    "teen-project": (DIGITAL_TITLES["teen-project"], "請樹老師陪你找適合的創作起點", "先放下作品，保留自己的課後時間"),
    "teen-direction": (DIGITAL_TITLES["teen-direction"], "和指導者討論課程及現在的負擔", "課程先緩一緩，留下喘息的空間"),
    "teen-launch": ("和小澄練習獨立生活的記帳方法", "請小澄一起列出搬出後能求助的人", "暫緩練習，先和重要的人道別"),
    "adult-learning": (DIGITAL_TITLES["adult-learning"], "和工作夥伴討論調班與進修負擔", "這回先不加課，把下班時間留給休息"),
    "adult-balance": ("接下一段加班，增加眼前的收入", "和同事討論調整排班的可能", "不接這段加班，留下吃飯和休息時間"),
    "adult-care": ("和小澄共組照顧輪班，訂下聯絡約定", "請小澄陪你查詢照顧支持資訊", "先說明精力有限，暫緩承擔新安排"),
    "middle-turn": (DIGITAL_TITLES["middle-turn"], "請小澄陪你評估轉換方向的負擔", "暫緩轉換，先維持現在的步調"),
    "middle-support": ("和小澄一起整理照顧安排", "請小澄陪你找適合的支持", "先休息，把自己能做到的界線說清楚"),
    "middle-rhythm": ("和小澄交換想保留的散步路線", "請小澄陪你調整一週的日常安排", "今天獨自慢慢走，留一段安靜時間"),
    "later-pass-on": ("和年輕夥伴做一本失敗也值得記下的手冊", "請夥伴挑一件最想聽的小故事", "今天先歇一歇，等有精神時再分享"),
    "later-reconnect": ("和相遇的夥伴做一架風車", "一起找適合現在體力的活動", "留一天給自己的步調"),
    "later-review": ("把重要選擇與幫助寫進人生小冊", "請身邊的人一起補上珍惜的片段", "合上小冊，安靜看看走過的日子"),
}


def dump(value):
    return json.dumps(value, ensure_ascii=False, indent=2) + "\n"


def resources(health=0, financial=0, relationships=0, skills=0):
    return dict(health=health, financial=financial, relationships=relationships, skills=skills)


def build(refresh=False):
    raw_dir = RESOURCES / "raw"
    raw_dir.mkdir(parents=True, exist_ok=True)
    sources, observations = [], {}
    for code, label, publisher in INDICATORS:
        url = f"https://api.worldbank.org/v2/country/JPN;USA;DEU;IND;BRA;VNM;KEN/indicator/{code}?date=2023&format=json&per_page=100"
        relative = f"raw/wdi-{label}-2023.json"
        path = RESOURCES / relative
        if refresh:
            with urllib.request.urlopen(url, timeout=45) as response:
                downloaded = response.read()
            if path.exists() and path.read_bytes() != downloaded:
                raise SystemExit(f"Pinned snapshot is immutable: {relative}. Review new source bytes and bump snapshot/data versions and paths first.")
            path.write_bytes(downloaded)
        raw = path.read_bytes()
        metadata, rows = json.loads(raw)
        assert metadata["pages"] == 1 and metadata["total"] == 7
        source_id = f"wdi-{label}-2023"
        sources.append(dict(
            id=source_id, publisher=publisher, indicator=code,
            url=f"https://data.worldbank.org/indicator/{code}", downloadURL=url,
            license="CC-BY-4.0", licenseURL=TERMS,
            licenseEvidenceURL=f"https://data.worldbank.org/indicator/{code}",
            attribution=f"The World Bank: World Development Indicators: {publisher}. {code}, 2023. CC BY 4.0; World Bank Dataset Terms apply. National data unchanged; game transformations are design assumptions. No endorsement.",
            retrievedAt="2026-10-23", version=VERSION, rawPath=relative,
            sha256=hashlib.sha256(raw).hexdigest(),
            missingPolicy="Reject playable background if required value is null/absent. Never fill with zero, national neighbors or another year.",
            transformation="Exact API numeric value; 2023 common-year slice, no rounding, interpolation, weighting or household inference. API lastupdated=" + metadata["lastupdated"],
        ))
        for row in rows:
            assert row["date"] == "2023" and row["indicator"]["id"] == code
            value = row["value"]
            assert value is None or (not isinstance(value, bool) and 0 <= value <= 100)
            observations.setdefault(row["countryiso3code"], []).append(dict(
                indicator=code, value=value, year=2023, region=row["countryiso3code"],
                unit="% of population", sourceID=source_id, dataVersion=VERSION,
            ))
    assumptions = []

    def assumption(id_, statement, limitation, version="1"):
        assumptions.append(dict(id=id_, version=version, statement=statement, limitation=limitation))

    assumption("macro-friction", "需要數位資料的行動：網路使用率 >=90 時多用0格時間，60～<90多用1格，<60多用2格；電力取得率 <95 多用1格材料，否則0格。",
               "這些門檻及成本是教學用情境指數。全國人口比例不是個人/家庭連線機率，也不能代表設備品質、教育、供電穩定度或個人因果。")
    assumption("household-scenarios", "兩個具穩定templateID的虛構家庭：互助共用模板初始健康66、財務35、人際65、技能20；獨用通勤模板初始健康64、財務60、人際50、技能20。所有國家沿用完全相同的模板數值，國名及排序不參與初始資源。",
               "這些初始狀態是具名設計案例，不是家庭聯合分布、典型家庭或醫學因果；沒有真實發生頻率，不能用於國家排名。", version="2")
    assumption("learning-channels", "數位依賴逐選項明列。線上圖解、遠距課程使用數位情境規則；紙本創作、面對面練習與社區老師路線不讀取網路/電力比例，仍依交通、材料與協助計成本。",
               "相同技能目標有不同途徑；數位人口比例不能限制本來不需要上網的活動。離線途徑的成本/效果也是設計假設。")
    assumption("life-stages", "0～12、13～22、23～40、41～60、61～100為五階段。每個關鍵事件重置時間/精力；跳躍時觸發到期故事。80歲回顧只為骨架收束。",
               "年齡段、回合預算與收束年齡是遊戲節奏，不是人口或死亡模型；沒有將平均壽命當作死亡年齡。")
    assumption("agency", "童年學習由孩子表達意願並和可信任的大人共同安排；成人工作/照顧責任限23歲以上。家庭照顧安排只在23歲以上增加成本。",
               "遊戲控制權規則，不是法律或對兒童責任的要求；不能把成人/社會限制歸責於孩子。")
    assumption("support-network", "情境支持0～2格：學習/求助/共同照顧可減少相同格數時間；學習有人陪伴增加人際2、技能1。",
               "虛構可用支持，不代表某國人民較友善或每次求助都成功；沒有支持也保留免費休息路線。")
    assumption("choice-effects", "選項明列回合時間、精力、材料及四項資源變動；可行性不足不消耗資源、不產生後果。",
               "資源與代價皆是設計單位，不是健康量表、貨幣或教育成就估計；沒有合成人生成功分數。")
    assumption("cost-fatigue", "學習準備佔去至少5格時間，健康暫減2格。",
               "簡化遊戲取捨，不是醫學或勞動風險估計。")
    assumption("luck-encouragement", "可行的學習選項有25%額外鼓勵機會，人際+1。固定Seed+事件/年齡/機會通道的鍵控亂數，所有背景同一門檻。",
               "完全為遊戲假設，沒有國家成功倍率；不同選項不消耗共用亂數序列。")
    assumption("resource-bounds", "四項長期資源各自限制0～100；成本最低0；clamp調整列入trace。",
               "設計邊界，不是真實人生評價；人物價值不能由數值推導。")
    assumption("story-callback", "帶有後續標記的可行決策在4歲後由同一位虛構人物呼應，人際+2、技能+1；只觸發一次。",
               "為LC-02保留人物牽掛的最小故事契約，並非證實現實長期因果；完整事件內容及試玩仍待後續切片。")
    assumption("story-branches", "三條虛構故事條件：10歲與阿禾創作或調整碰面才在72歲重逢，否則和社區夥伴小澄開風車桌認識新鄰居；13歲線上/紙本/未製作決定17歲學習場景，作品經驗加技能至少28才可帶領工作坊；39歲共組照顧輪班才在52歲沿用互助約定，健康至少55才可自願接一小段。每次記錄實際歷史、資源門檻、場景及選項。",
               "人物、約定、門檻與後續路線皆為遊戲敘事假設，不是心理、醫學或社會因果；沒有連結不等於個人失敗，所有路線保留求助及免費休息。國家名稱不參與故事條件。")
    assumption("event-selection", "每局固定15個年齡槽。每槽先檢查明列的已執行決策、四項資源或家庭安排條件；符合者按event ID排序，再以Seed及年齡槽的鍵控亂數均等挑一個。每槽保留一個無條件預備情境。12、21、32、59、65歲共增加8個條件情境，其餘保留既有錨點。",
               "情境、門檻及均等機率都是原創遊戲設計，不是事件真實發生率、國家分布或現實因果。國名不參與候選條件或亂數鍵；不同Seed也可能遇到相同情境。版本改變不保證延續舊存檔。")

    countries, households = [], []
    for code, name in COUNTRIES:
        gaps = []
        if code == "TWN":
            gaps = ["尚未接入台灣官方同口徑2023網路與電力人口比例；不得以其他國家、不同分母或0填補。",
                    "待逐欄確認官方資料授權、可比定義及原始檔；此版本拒絕建立台灣可用背景。"]
        elif code in {"DEU", "BRA", "VNM"}:
            gaps = ["LC-01兩項宏觀指標已驗證；LC-02在地故事用語與制度情境尚未考證，不在首批四國名單。"]
        countries.append(dict(code=code, name=name, dataStatus="blocked" if code == "TWN" else "ready",
                              indicators=observations.get(code, []), gaps=gaps))
        for number, family in enumerate(FAMILY_SCENARIOS, start=1):
            # Explicit fictional scenarios, not national frequencies. Families are not moral rankings.
            households.append(dict(
                id=f"{code.lower()}-{number}", countryCode=code, templateID=family["templateID"],
                label=f"{name}・虛構家庭{number}：" + family["description"],
                deviceAccess=family["deviceAccess"], travelCost=family["travelCost"], careLoad=family["careLoad"],
                mentorSupport=family["mentorSupport"], materialBudget=family["materialBudget"],
                initialResources=resources(health=family["health"], financial=family["financial"],
                                           relationships=family["relationships"], skills=20),
                assumptionIDs=["household-scenarios"],
            ))

    decisions = []
    skeletons = [
        (8, "child-interest", "想試試新的興趣", "照顧你的大人", "我可以說出自己想做的事嗎？", "learn"),
        (10, "child-friend", "和阿禾一起完成雙人風車", "阿禾", "練習和陪伴要怎麼分配？", "learn"),
        (12, "child-transition", "準備進入新的學校", "樹老師", "我需要什麼幫忙？", "learn"),
        (13, "teen-project", "想參加共同創作", "樹老師", "同樣投入，為什麼準備成本不同？", "learn"),
        (17, "teen-direction", "選擇想繼續學的方向", "樹老師", "學習會留下什麼可能？", "learn"),
        (21, "teen-launch", "離開熟悉的地方之前", "小澄", "可以帶著哪些支持出發？", "learn"),
        (25, "adult-learning", "工作之外再學一點", "工作夥伴", "收入、時間與學習怎麼取捨？", "learn"),
        (32, "adult-balance", "工作安排出現變化", "曾經的同事", "我想留下多少生活空間？", "work"),
        (39, "adult-care", "一起分擔照顧安排", "小澄", "責任可以和誰一起承擔？", "care"),
        (45, "middle-turn", "想嘗試新的工作方向", "小澄", "已有經驗能帶我去哪裡？", "learn"),
        (52, "middle-support", "朋友需要有人一起想辦法", "小澄", "我能提供什麼支持？", "care"),
        (59, "middle-rhythm", "為下一階段調整節奏", "小澄", "什麼是我想保留的日常？", "share"),
        (65, "later-pass-on", "有人想聽你的經驗", "年輕的學習夥伴", "哪些經驗值得分享？", "share"),
        (72, "later-reconnect", "今天會和誰留下新回憶", "小澄", "我還想和誰一起創造回憶？", "share"),
        (80, "later-review", "回望走過的岔路", "一路相伴的人", "選擇、環境與他人的幫助留下了什麼？", "share"),
    ]
    for age, id_, title, person, question, kind in skeletons:
        control = "sharedWithAdult" if age <= 12 else ("adultResponsibility" if kind in {"work", "care"} else "personal")
        primary_title, ask_title, rest_title = EVENT_CHOICES[id_]
        primary_effect = {"learn": resources(skills=4, financial=-1), "work": resources(financial=4, health=-1),
                          "care": resources(relationships=4, health=-1), "share": resources(relationships=3, skills=1)}[kind]
        choices = [dict(id="invest", title=primary_title, kind=kind, control=control,
                        minimumAge=23 if kind in {"work", "care"} else 0, timeCost=3, energyCost=2,
                        materialCost=1 if kind == "learn" else 0, effect=primary_effect,
                        requiresDigitalAccess=id_ in DIGITAL_TITLES, delayedHook="reconnect" if age in {13, 25, 45} else None,
                        assumptionIDs=["choice-effects", "agency", "learning-channels"]),
                   dict(id="ask", title=ask_title, kind="askSupport", control="personal",
                        minimumAge=0, timeCost=1, energyCost=1, materialCost=0,
                        effect=resources(relationships=2, skills=1), requiresDigitalAccess=False, delayedHook=None,
                        assumptionIDs=["choice-effects", "support-network"]),
                   dict(id="rest", title=rest_title, kind="rest", control="personal", minimumAge=0,
                        timeCost=0, energyCost=0, materialCost=0, effect=resources(health=2, relationships=1),
                        requiresDigitalAccess=False, delayedHook=None, assumptionIDs=["choice-effects"])]
        if id_ in DIGITAL_TITLES:
            choices.insert(1, dict(id="offline", title="向社區老師借紙本圖解，一起練習", kind="learn",
                                  control=control, minimumAge=0, timeCost=3, energyCost=2, materialCost=1,
                                  effect=resources(skills=3, relationships=1), requiresDigitalAccess=False,
                                  delayedHook=None, assumptionIDs=["choice-effects", "learning-channels", "support-network"]))
        if id_ == "teen-direction":
            choices.insert(0, dict(id="leadWorkshop", title="和樹老師一起帶領紙本小工作坊", kind="share",
                                   control="personal", minimumAge=13, timeCost=2, energyCost=2, materialCost=1,
                                   effect=resources(relationships=3, skills=2), requiresDigitalAccess=False,
                                   delayedHook=None, assumptionIDs=["choice-effects", "story-branches"]))
        if id_ == "middle-support":
            choices.insert(0, dict(id="shareShift", title="自願接下一小段既有輪班，讓夥伴喘息", kind="care",
                                   control="adultResponsibility", minimumAge=23, timeCost=2, energyCost=2, materialCost=0,
                                   effect=resources(health=-1, relationships=3), requiresDigitalAccess=False,
                                   delayedHook=None, assumptionIDs=["choice-effects", "story-branches", "agency"]))
        decisions.append(dict(id=id_, age=age, title=title, recurringPerson=person, storyQuestion=question, choices=choices,
                              isFallback=True, eligibility=[]))

    def condition(id_, kind, key, threshold=None, choices=None):
        return dict(id=id_, kind=kind, key=key, threshold=threshold, choiceIDs=choices or [])

    # A small authored pool, not 8 extra decisions in a single life. Earlier anchors remain unconditionally available.
    pool = [
        (12, "child-library-map", "圖書角出現一張空白地圖", "樹老師", "怎麼讓新同學也找到能問問題的地方？", "learn",
         [condition("nearby-guide", "householdAtLeast", "mentorSupport", 1)],
         ("和樹老師畫借書與問路的小地圖", "請老師先帶你走一次圖書角", "把地圖留到明天，今天先安心休息"), resources(skills=3, relationships=2)),
        (12, "child-wind-team", "阿禾想替風車找新夥伴", "阿禾", "兩個人的約定，能不能多留一個位置？", "share",
         [condition("windmill-promise", "priorChoice", "child-friend", choices=["invest", "ask"])],
         ("和阿禾替新同學留一份風車材料", "請阿禾一起問新同學想玩什麼", "先告訴阿禾今天需要自己的時間"), resources(relationships=4, skills=1)),
        (21, "teen-repair-table", "樹老師的修理桌缺一雙手", "樹老師", "學過的經驗，能幫忙修好什麼？", "learn",
         [condition("made-a-project", "priorChoice", "teen-project", choices=["invest", "offline"]),
          condition("repair-practice", "resourceAtLeast", "skills", 25)],
         ("和樹老師修理社區的舊玩具", "請樹老師示範一個安全的小步驟", "先當安靜的旁觀者，保留休息時間"), resources(skills=3, relationships=2)),
        (21, "teen-shared-kitchen", "小澄提議排一張共煮表", "小澄", "生活安排能怎麼互相分擔？", "share",
         [condition("family-rotations", "householdAtLeast", "careLoad", 1),
          condition("kitchen-energy", "resourceAtLeast", "health", 50)],
         ("和小澄試排一週共煮與採買分工", "請小澄陪你說出現在忙不過來的事", "今天先吃簡單一點，照顧自己的步調"), resources(financial=1, relationships=3)),
        (32, "adult-neighbor-market", "週末市集想借你的巧思", "小澄", "多一點收入，也會少掉哪些空閒？", "work",
         [condition("current-financial-room", "resourceAtMost", "financial", 65),
          condition("market-helper", "householdAtLeast", "mentorSupport", 1)],
         ("和小澄試擺一個小攤，記下成本", "請小澄一起估算時間與材料負擔", "這次不擺攤，保留週末和身邊的人相處"), resources(financial=2, relationships=2)),
        (59, "middle-garden-table", "社區花圃邀你留一張椅子", "小澄", "一起照顧花草，也要留多少時間給自己？", "share",
         [condition("garden-energy", "resourceAtLeast", "health", 45)],
         ("和小澄認養一小格花圃，排好輪值", "請小澄幫忙挑適合體力的小工作", "坐在椅子上看看花，今天不接輪值"), resources(health=1, relationships=3)),
        (59, "middle-open-desk", "小澄想讓互助桌多開一小時", "小澄", "以前的約定，如何讓現在的人用得上？", "share",
         [condition("shared-care-contacts", "priorChoice", "adult-care", choices=["invest"])],
         ("把輪班經驗寫成一張互助桌小卡", "請小澄和其他夥伴一起分配開桌時間", "先把自己的界線寫好，暫不加開時段"), resources(relationships=4, skills=1)),
        (65, "later-voice-booth", "樹老師借來一台回憶錄音機", "樹老師", "想讓後來的人聽見哪一段不完美的故事？", "share",
         [condition("sharing-connection", "resourceAtLeast", "relationships", 60),
          condition("recording-companion", "householdAtLeast", "mentorSupport", 1)],
         ("和樹老師錄下一次失敗後再試的故事", "請樹老師先問你一個容易說的小問題", "今天先聽別人分享，保留自己的安靜"), resources(relationships=3, skills=2)),
    ]
    for age, id_, title, person, question, kind, eligibility, titles, effect in pool:
        control = "sharedWithAdult" if age <= 12 else ("adultResponsibility" if kind == "work" else "personal")
        choices = [dict(id="invest", title=titles[0], kind=kind, control=control,
                        minimumAge=23 if kind == "work" else 0, timeCost=2, energyCost=2,
                        materialCost=1 if kind == "learn" else 0, effect=effect,
                        requiresDigitalAccess=False, delayedHook=None,
                        assumptionIDs=["choice-effects", "event-selection", "agency"]),
                   dict(id="ask", title=titles[1], kind="askSupport", control="personal", minimumAge=0,
                        timeCost=1, energyCost=1, materialCost=0, effect=resources(relationships=2, skills=1),
                        requiresDigitalAccess=False, delayedHook=None,
                        assumptionIDs=["choice-effects", "support-network"]),
                   dict(id="rest", title=titles[2], kind="rest", control="personal", minimumAge=0,
                        timeCost=0, energyCost=0, materialCost=0, effect=resources(health=2, relationships=1),
                        requiresDigitalAccess=False, delayedHook=None, assumptionIDs=["choice-effects"])]
        decisions.append(dict(id=id_, age=age, title=title, recurringPerson=person, storyQuestion=question,
                              choices=choices, isFallback=False, eligibility=eligibility))
    from rng_v2_content import extend
    extend(decisions, assumptions)
    from lc03_data import extend as extend_country_data
    from opportunity_content import extend as extend_opportunities
    from experience_content import extend as extend_experience
    return extend_experience(extend_opportunities(extend_country_data(dict(schemaVersion=4, selectionRules=dict(version="story-race-rules-1", continuityMultiplier=2.0, relationshipMultiplier=1.15, recentCategoryMultiplier=0.55, recentCategoryWindow=1), dataVersion=DATA_VERSION, contentVersion="rng-v2-story-1", referenceYear=2023,
                sources=sources, assumptions=assumptions, countries=countries, households=households, decisions=decisions), RESOURCES)))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--refresh", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.refresh and args.check:
        parser.error("--check must be offline; cannot combine with --refresh")
    content = dump(build(args.refresh))
    target = RESOURCES / "catalog.json"
    if args.check:
        if target.read_text() != content:
            raise SystemExit("Catalog differs from pinned source evidence / design contract")
        print("Offline evidence and deterministic catalog: PASS (31 observations, 8 countries (Taiwan comparison gaps explicit), 16 households, 15 age slots / 52 event candidates)")
    else:
        target.write_text(content)
        print(f"Wrote {target.relative_to(ROOT)}")
