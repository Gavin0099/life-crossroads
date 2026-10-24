import csv
import importlib.util
import io
import json
from pathlib import Path
import sys
import unittest
import zipfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
import lc03_data
spec = importlib.util.spec_from_file_location('lc03_build', ROOT/'scripts/build-data.py')
build = importlib.util.module_from_spec(spec); spec.loader.exec_module(build)

class LC03DataTests(unittest.TestCase):
    def test_pinned_national_rows_keep_native_denominators_and_year(self):
        catalog = build.build()
        tw = next(c for c in catalog['countries'] if c['code']=='TWN')
        rows = {o['indicator']:o for o in tw['indicators']}
        self.assertEqual(rows['TWN.INTERNET.12PLUS']['value'],87.2)
        self.assertEqual(rows['SH.XPD.CHEX.GD.ZS']['value'],7.25)
        self.assertEqual(rows['TWN.OOP.INCLUDING.REIMBURSEMENT']['value'],38.78)
        self.assertNotIn('IT.NET.USER.ZS',rows)
        self.assertNotIn('SH.XPD.OOPC.CH.ZS',rows)
        self.assertTrue(all(o['year']==2023 for o in rows.values()))
        self.assertIsNone(rows['TWN.INTERNET.12PLUS']['comparisonGroup'])
        self.assertEqual(rows['TWN.INTERNET.12PLUS']['usage'],'contextOnly')
        self.assertEqual(len(catalog['countries']),8)
        self.assertEqual(len(catalog['households']),16)

    def test_common_year_health_raw_values_not_replaced_or_rounded(self):
        catalog = build.build()
        countries = [c for c in catalog['countries'] if c['code']!='TWN']
        self.assertEqual(len(countries),7)
        for code,label,unit in lc03_data.HEALTH:
            raw = json.loads((build.RESOURCES/'raw'/f'wdi-{label}-2023-lc03.json').read_bytes())
            expected = {r['countryiso3code']:r['value'] for r in raw[1]}
            self.assertEqual(len(expected),7)
            for country in countries:
                obs=next(o for o in country['indicators'] if o['indicator']==code)
                self.assertEqual(obs['value'],expected[country['code']])
                self.assertEqual(obs['unit'],unit)
                self.assertEqual(obs['year'],2023)

    def test_cp950_csv_extraction_checks_header_year_and_duplicate(self):
        output = io.StringIO(); writer=csv.writer(output)
        writer.writerows([['年度','全國樣本數','全國抽樣誤差','個人上網率\n%'],['112','15081','±0.8%','87.2'],['113','1','±1%','90']])
        data=output.getvalue().encode('cp950')
        self.assertEqual(lc03_data.digital_row(data),['112','15081','±0.8%','87.2'])
        for bad in [data.replace(b'112',b'114'),data+data.split(b'\r\n',1)[1],data.replace('個人'.encode('cp950'), b'xx')]:
            with self.assertRaises(ValueError): lc03_data.digital_row(bad)

    def test_nhe_extraction_uses_table_1_national_row_not_third_party_table(self):
        cells=['112年']+[str(i) for i in range(1,20)]+['2023','']
        xml='<office:document-content xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"><table:table table:name="表1"><table:table-row>'
        xml+=''.join('<table:table-cell>'+s+'</table:table-cell>' for s in cells)
        xml+='</table:table-row></table:table></office:document-content>'
        def archive(content):
            buf=io.BytesIO()
            with zipfile.ZipFile(buf,'w') as z:z.writestr('content.xml',content.encode())
            return buf.getvalue()
        self.assertEqual(lc03_data.nhe_row(archive(xml)),cells)
        with self.assertRaises(ValueError):lc03_data.nhe_row(archive(xml.replace('112年','113年')))
        with self.assertRaises(ValueError):lc03_data.nhe_row(archive(xml.replace('2023','2024')))

    def test_care_financing_scope_is_explicit_not_every_care_or_support_action(self):
        c=build.build()
        for event in c['decisions']:
            for choice in event['choices']:
                self.assertEqual(choice.get('requiresCareFinancing',False),event['id'] in ['adult-care','middle-support'] and choice['kind']=='care')

if __name__=='__main__':unittest.main()
