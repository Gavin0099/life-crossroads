#!/usr/bin/env python3
"""Rebuild the pinned LC-01 catalog offline. --refresh explicitly downloads WDI evidence."""
import argparse
import hashlib
import json
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RESOURCES = ROOT / "LifeCrossroads/Data/Resources"
VERSION = "wdi-2023-snapshot-2026-10-23"
DATA_VERSION = "lc01-data-1"
TERMS = "https://www.worldbank.org/ext/en/legal/terms-conditions/datasets"
COUNTRIES = [("TWN", "台灣"), ("JPN", "日本"), ("USA", "美國"), ("DEU", "德國"),
             ("IND", "印度"), ("BRA", "巴西"), ("VNM", "越南"), ("KEN", "肯亞")]
INDICATORS = [
    ("IT.NET.USER.ZS", "internet", "International Telecommunication Union (ITU)"),
    ("EG.ELC.ACCS.ZS", "electricity", "World Bank / ESMAP, SDG 7.1.1 Electrification Dataset"),
]


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

    def assumption(id_, statement, limitation):
        assumptions.append(dict(id=id_, version="1", statement=statement, limitation=limitation))

    assumption("macro-friction", "需要數位資料的行動：網路使用率 >=90 時多用0格時間，60～<90多用1格，<60多用2格；電力取得率 <95 多用1格材料，否則0格。",
               "這些門檻及成本是教學用情境指數。全國人口比例不是個人/家庭連線機率，也不能代表設備品質、教育、供電穩定度或個人因果。")
    assumption("household-scenarios", "每國兩個刻意對比的虛構家庭：設備、交通、成人照顧安排、材料及初始資源皆為手工情境；不抽樣國家平均值。",
               "不是家庭聯合分布、不代表典型家庭、沒有真實發生頻率；兩種情境可存在於任何國家，不能用於國家排名。")
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

    countries, households = [], []
    for index, (code, name) in enumerate(COUNTRIES):
        gaps = []
        if code == "TWN":
            gaps = ["尚未接入台灣官方同口徑2023網路與電力人口比例；不得以其他國家、不同分母或0填補。",
                    "待逐欄確認官方資料授權、可比定義及原始檔；此版本拒絕建立台灣可用背景。"]
        elif code in {"DEU", "BRA", "VNM"}:
            gaps = ["LC-01兩項宏觀指標已驗證；LC-02在地故事用語與制度情境尚未考證，不在首批四國名單。"]
        countries.append(dict(code=code, name=name, dataStatus="blocked" if code == "TWN" else "ready",
                              indicators=observations.get(code, []), gaps=gaps))
        for number in (1, 2):
            # Explicit fictional scenarios, not national frequencies. Families are not moral rankings.
            households.append(dict(
                id=f"{code.lower()}-{number}", countryCode=code,
                label=f"{name}・虛構家庭{number}：" + ("共用設備、近處互助、家人輪班" if number == 1 else "獨用設備、較遠通勤、收入較穩"),
                deviceAccess="shared" if number == 1 else "own",
                travelCost=0 if number == 1 else 1,
                careLoad=1 if number == 1 else 0,
                mentorSupport=2 if number == 1 else 1,
                materialBudget=2 if number == 1 else 4,
                initialResources=resources(health=65 + index % 3, financial=35 if number == 1 else 60,
                                           relationships=65 if number == 1 else 50, skills=20),
                assumptionIDs=["household-scenarios"],
            ))

    decisions = []
    skeletons = [
        (8, "child-interest", "想試試新的興趣", "照顧你的大人", "我可以說出自己想做的事嗎？", "learn"),
        (10, "child-friend", "和朋友約好一起完成", "童年朋友", "練習和陪伴要怎麼分配？", "learn"),
        (12, "child-transition", "準備進入新的學校", "陪你準備的老師", "我需要什麼幫忙？", "learn"),
        (13, "teen-project", "想參加共同創作", "一起找材料的同伴", "同樣投入，為什麼準備成本不同？", "learn"),
        (17, "teen-direction", "選擇想繼續學的方向", "社區指導者", "學習會留下什麼可能？", "learn"),
        (21, "teen-launch", "離開熟悉的地方之前", "一起長大的朋友", "可以帶著哪些支持出發？", "learn"),
        (25, "adult-learning", "工作之外再學一點", "工作夥伴", "收入、時間與學習怎麼取捨？", "learn"),
        (32, "adult-balance", "工作安排出現變化", "曾經的同事", "我想留下多少生活空間？", "work"),
        (39, "adult-care", "一起分擔照顧安排", "重要的家人", "責任可以和誰一起承擔？", "care"),
        (45, "middle-turn", "想嘗試新的工作方向", "多年來的夥伴", "已有經驗能帶我去哪裡？", "learn"),
        (52, "middle-support", "朋友需要有人一起想辦法", "曾經支持你的朋友", "我能提供什麼支持？", "care"),
        (59, "middle-rhythm", "為下一階段調整節奏", "一起散步的鄰居", "什麼是我想保留的日常？", "share"),
        (65, "later-pass-on", "有人想聽你的經驗", "年輕的學習夥伴", "哪些經驗值得分享？", "share"),
        (72, "later-reconnect", "和老朋友重新聯絡", "童年朋友", "我還想和誰一起創造回憶？", "share"),
        (80, "later-review", "回望走過的岔路", "一路相伴的人", "選擇、環境與他人的幫助留下了什麼？", "share"),
    ]
    for age, id_, title, person, question, kind in skeletons:
        control = "sharedWithAdult" if age <= 12 else ("adultResponsibility" if kind in {"work", "care"} else "personal")
        primary_title = {"learn": "投入時間一起學習", "work": "增加一段工作時間", "care": "和別人共同安排照顧", "share": "和重要的人分享經驗"}[kind]
        primary_effect = {"learn": resources(skills=4, financial=-1), "work": resources(financial=4, health=-1),
                          "care": resources(relationships=4, health=-1), "share": resources(relationships=3, skills=1)}[kind]
        choices = [dict(id="invest", title=primary_title, kind=kind, control=control,
                        minimumAge=23 if kind in {"work", "care"} else 0, timeCost=3, energyCost=2,
                        materialCost=1 if kind == "learn" else 0, effect=primary_effect,
                        requiresDigitalAccess=kind == "learn", delayedHook="reconnect" if age in {13, 25, 45} else None,
                        assumptionIDs=["choice-effects", "agency"]),
                   dict(id="ask", title="先說出需要，和別人一起找方法", kind="askSupport", control="personal",
                        minimumAge=0, timeCost=1, energyCost=1, materialCost=0,
                        effect=resources(relationships=2, skills=1), requiresDigitalAccess=False, delayedHook=None,
                        assumptionIDs=["choice-effects", "support-network"]),
                   dict(id="rest", title="保留時間休息和陪伴", kind="rest", control="personal", minimumAge=0,
                        timeCost=0, energyCost=0, materialCost=0, effect=resources(health=2, relationships=1),
                        requiresDigitalAccess=False, delayedHook=None, assumptionIDs=["choice-effects"])]
        decisions.append(dict(id=id_, age=age, title=title, recurringPerson=person, storyQuestion=question, choices=choices))
    return dict(schemaVersion=1, dataVersion=DATA_VERSION, contentVersion="lc02-story-1", referenceYear=2023,
                sources=sources, assumptions=assumptions, countries=countries, households=households, decisions=decisions)


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
        print("Offline evidence and deterministic catalog: PASS (14 observations, 8 countries, 16 households, 15 decision skeletons)")
    else:
        target.write_text(content)
        print(f"Wrote {target.relative_to(ROOT)}")
