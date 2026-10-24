"""LC-03: pinned national evidence; deliberately incompatible measures never get a common ID."""
import csv
import hashlib
import io
import json
from pathlib import Path
import xml.etree.ElementTree as ET
import zipfile

VERSION = 'lc03-2023-snapshot-2026-10-24'
NHE_URL = 'https://www.mohw.gov.tw/dl-99629-5e22053d-dad4-4a9e-85f8-f268fc0a1056.html'
DIGITAL_URL = 'https://www-api.moda.gov.tw/OpenData/Files/4303'
HEALTH = [('SH.XPD.OOPC.CH.ZS', 'oop', '% of current health expenditure'),
          ('SH.XPD.CHEX.GD.ZS', 'che-gdp', '% of GDP')]

def nhe_row(data):
    ns = {'t': 'urn:oasis:names:tc:opendocument:xmlns:table:1.0'}
    root = ET.fromstring(zipfile.ZipFile(io.BytesIO(data)).read('content.xml'))
    sheet = next(t for t in root.findall('.//t:table', ns) if t.get('{'+ns['t']+'}name') == '表1')
    rows = [[''.join(c.itertext()).strip() for c in row] for row in sheet.findall('t:table-row', ns)]
    matches = [r for r in rows if r and r[0] == '112年']
    if len(matches) != 1 or matches[0][20] != '2023':
        raise ValueError('NHE table/year changed; review extraction')
    return matches[0]

def digital_row(data):
    rows = list(csv.reader(io.StringIO(data.decode('cp950'))))
    if rows[0][3].replace('\n', '') != '個人上網率%':
        raise ValueError('digital column changed')
    matches = [r for r in rows if r[0].strip() == '112']
    if len(matches) != 1:
        raise ValueError('digital year missing/duplicated')
    return matches[0]

def extend(catalog, resources):
    """Offline by default. Reviewed extractions retain native labels/denominators."""
    raw = resources / 'raw'
    catalog['schemaVersion'] = 5
    catalog['dataVersion'] = 'lc03-data-1'
    catalog['contentVersion'] = 'lc03-environment-story-1'
    defs = {
        'IT.NET.USER.ZS': ('使用網路的人口', 'wdi-internet-population-2023', 'WDI/ITU population; national methods may vary; not an individual access probability.'),
        'EG.ELC.ACCS.ZS': ('可取得電力的人口', 'wdi-electricity-population-2023', 'Population with electricity access, not reliability or household equipment.'),
        'SH.XPD.OOPC.CH.ZS': ('家庭直接自付占經常醫療支出', 'sha2011-oop-che-2023', 'SHA 2011 household out-of-pocket share of CHE; excludes reimbursement, not a personal bill percentage.'),
        'SH.XPD.CHEX.GD.ZS': ('經常醫療支出占 GDP', 'sha2011-che-gdp-2023', 'Current health expenditure / nominal GDP; excludes capital. Spending share is not quality, access or insurance coverage.'),
        'TWN.INTERNET.12PLUS': ('12歲以上國民個人上網率', None, '22 counties, nationals aged 12+ living in households, telephone sample; not WDI all-population denominator.'),
        'TWN.OOP.INCLUDING.REIMBURSEMENT': ('家庭自付占經常醫療支出（含商保理賠）', None, 'Taiwan OOP includes reimbursements from commercial insurance; not comparable to WHO OOP/CHE.'),
    }
    for code, label, unit in HEALTH:
        path = raw / f'wdi-{label}-2023-lc03.json'
        metadata, rows = json.loads(path.read_bytes())
        if metadata['pages'] != 1 or len(rows) != 7 or metadata['total'] != 7:
            raise ValueError('incomplete health source')
        sid = f'wdi-{label}-2023'
        url = f'https://api.worldbank.org/v2/country/JPN;USA;DEU;IND;BRA;VNM;KEN/indicator/{code}?date=2023&format=json&per_page=100'
        catalog['sources'].append(dict(id=sid, publisher='WHO Global Health Expenditure Database / World Bank WDI', indicator=code,
            url=f'https://data.worldbank.org/indicator/{code}', downloadURL=url,
            license='CC-BY-4.0', licenseURL='https://www.worldbank.org/ext/en/legal/terms-conditions/datasets',
            licenseEvidenceURL=f'https://data.worldbank.org/indicator/{code}',
            attribution=f'The World Bank: World Development Indicators: World Health Organization, Global Health Expenditure Database. {code}, 2023. CC BY 4.0; Dataset Terms https://www.worldbank.org/ext/en/legal/terms-conditions/datasets . National values unchanged; game mappings are design assumptions. No endorsement.',
            retrievedAt='2026-10-24', version=VERSION, rawPath='raw/'+path.name,
            sha256=hashlib.sha256(path.read_bytes()).hexdigest(), format='wdi',
            missingPolicy='No zero filling, interpolation, neighboring country or year substitution.',
            transformation='Exact common-year 2023 API value; lastupdated='+metadata['lastupdated']))
        for r in rows:
            if r['date'] != '2023' or r['indicator']['id'] != code:
                raise ValueError('health provenance')
            country = next(c for c in catalog['countries'] if c['code'] == r['countryiso3code'])
            country['indicators'].append(dict(indicator=code, value=r['value'], year=2023, region=country['code'],
                unit=unit, sourceID=sid, dataVersion=VERSION))
    # National rows only: do not redistribute third-party international tables from the NHE workbook.
    nhe = json.loads((raw/'taiwan-nhe-national-row-2023.json').read_text())
    digital = json.loads((raw/'taiwan-digital-national-row-2023.json').read_text())
    if nhe['row'][0] != '112年' or nhe['row'][20] != '2023' or digital['row'][0] != '112':
        raise ValueError('Taiwan extraction year')
    tw = next(c for c in catalog['countries'] if c['code']=='TWN')
    specs = [
        ('SH.XPD.CHEX.GD.ZS', 'taiwan-che', 'taiwan-nhe-national-row-2023.json', nhe, 9, '% of GDP'),
        ('TWN.OOP.INCLUDING.REIMBURSEMENT', 'taiwan-oop', 'taiwan-nhe-national-row-2023.json', nhe, 17, '% of current health expenditure (including commercial reimbursement)'),
        ('TWN.INTERNET.12PLUS', 'taiwan-digital', 'taiwan-digital-national-row-2023.json', digital, 3, '% of nationals aged 12+ in households'),
    ]
    for code, sid, filename, extraction, index, unit in specs:
        catalog['sources'].append(dict(id=sid, publisher='衛生福利部統計處' if 'nhe' in filename else '數位發展部', indicator=code,
            url='https://dep.mohw.gov.tw/DOS/fp-5071-85844-113.html' if 'nhe' in filename else 'https://data.gov.tw/dataset/5960',
            downloadURL=extraction['downloadURL'], license='OGDL-Taiwan-1.0', licenseURL='https://data.gov.tw/license',
            licenseEvidenceURL='https://www.mohw.gov.tw/www/cp-81-155-1.html' if 'nhe' in filename else 'https://data.gov.tw/dataset/5960',
            attribution=f"{('衛生福利部統計處 2026 113年NHE統計表之2023年本國列' if 'nhe' in filename else '數位發展部 數位近用調查112年度全國列')}。依政府資料開放授權條款第1版釋出 https://data.gov.tw/license 。遊戲轉換為設計假設，非機關背書。",
            retrievedAt='2026-10-24', version=VERSION, rawPath='raw/'+filename,
            sha256=hashlib.sha256((raw/filename).read_bytes()).hexdigest(), format='taiwan-row', column=index,
            missingPolicy='Native non-comparable measures retained under separate IDs; absent electricity/internet population values stay absent.',
            transformation=f"{extraction['location']}; zero-based cell {index}; exact numeric value; original download SHA256={extraction['originalSHA256']}; national row extraction only, no adjustment."))
        tw['indicators'].append(dict(indicator=code,value=float(extraction['row'][index]),year=2023,region='TWN',unit=unit,sourceID=sid,dataVersion=VERSION))
    for country in catalog['countries']:
        country['dataStatus'] = 'limited' if country['code']=='TWN' else 'ready'
        country['gaps'] = (['數位調查12歲以上母體與WDI人口口徑不合；家庭自付含商保理賠，不能與WHO直接自付相比。',
                            '未取得同口徑全人口網路與電力資料；相關行動僅試算明示家庭成本，跨國成本比較標為資料不足，不能當作0或台灣缺乏資源。'] if country['code']=='TWN' else [])
        country['gaps'] += ['國家平均只作背景；家庭為共用虛構模板，沒有抽樣頻率。共用河畔故事不代表當地制度或實景。']
        for obs in country['indicators']:
            title,group,definition = defs[obs['indicator']]
            obs.update(title=title, comparisonGroup=group, definition=definition,
                       usage='contextOnly' if obs['indicator'] in ['SH.XPD.CHEX.GD.ZS','TWN.INTERNET.12PLUS','TWN.OOP.INCLUDING.REIMBURSEMENT'] else 'ruleInput')
    for source in catalog['sources']:
        source.setdefault('format','wdi')
    catalog['assumptions'].append(dict(id='care-financing',version='1',
        statement='只對明列的成人醫療支持安排：WHO直接自付/CHE <20時多用1材料、20～<40多用2、>=40多用3；先詢問財務協助的選項不增加材料但需要2時間。這是預備支出情境，不是實際費用或得到補助的機率。',
        limitation='國家支出份額不能推算個人帳單、醫療品質或治療結果。台灣含理賠口徑不可代入此規則，保留家庭試算並標示未知，不聲稱無額外成本。所有情境保留免費休息/求助，孩子不承擔成人責任。'))
    catalog['assumptions'].append(dict(id='partial-environment',version='1',
        statement='有限資料情境仍可完整遊玩；缺少可比規則輸入時只執行已知家庭及行動成本，trace明示未估算項。比較頁不顯示該部分情境的總成本/可行性結論。',
        limitation='未知不是零、不可比較不是國家資源不足，也不表示各國成本相同；補齊合格來源並升資料/引擎版本後才解除限制。'))
    for event in catalog['decisions']:
        if event['id'] in ['adult-care','middle-support']:
            # Explicit medical-planning scope: do not tax every act of caring for someone.
            event['storyQuestion'] += ' 這次還要一起安排看診交通與預備支出。'
            for choice in event['choices']:
                choice['requiresCareFinancing'] = choice['kind']=='care'
            ask = next(c for c in event['choices'] if c['id']=='ask')
            ask['title'] = '請小澄陪你詢問醫療費用與可用協助，先不接新輪班'
            ask['timeCost'] = 2
            ask['assumptionIDs'].append('care-financing')
    return catalog
