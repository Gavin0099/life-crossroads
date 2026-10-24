# Third-party notices

## AI Governance Framework

- Source: https://github.com/Gavin0099/ai-governance-framework
- Initial adopted commit: `3bc4db55c9132f81aed4fce328f3622caf15db3c`
- License: Apache License 2.0; complete upstream license preserved at
  `additional/ai-governance-framework/LICENSE`.
- The submodule is unmodified. `AGENTS.base.md`, governance Markdown/rule packs,
  generated baseline and installer-managed instruction/hook surfaces originate
  from that framework. Repository-specific additions are in AGENTS.md, PLAN.md,
  contract.yaml, docs/ and scripts/.
- The CI workflow is adapted to this consumer's submodule path.
- Trailing whitespace was normalized in the consumer copy of
  `governance/SEMANTIC_FAILURE_TAXONOMY.md`; the upstream submodule is unchanged.

Framework licensing does not grant rights to either reference game's code,
event text, artwork or data bundle. Application/source licensing remains undecided.

## World Development Indicators snapshot (2023 observations)

The World Bank: World Development Indicators: International Telecommunication
Union (ITU), Individuals using the Internet (`IT.NET.USER.ZS`); World Bank / ESMAP,
SDG 7.1.1 Electrification Dataset, Access to electricity (`EG.ELC.ACCS.ZS`).
Retrieved 2026-10-23, API lastupdated 2026-10-08. Seven economies; this is not a
sample of all births in the world.

- Indicator licenses: [Internet](https://data.worldbank.org/indicator/IT.NET.USER.ZS),
  [Electricity](https://data.worldbank.org/indicator/EG.ELC.ACCS.ZS), each marked CC BY 4.0.
- [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/)
  and [World Bank Dataset Terms](https://www.worldbank.org/ext/en/legal/terms-conditions/datasets),
  including the additional dispute-resolution terms and attribution requirements.
  Downstream redistribution must preserve this acknowledgment and the Dataset Terms URL.
- Numeric observations are unchanged. Selection of common year/countries and all
  game mappings are ours. No World Bank or provider endorsement or association is implied.
- Machine-readable attribution, raw response hashes and transformations are in
  `LifeCrossroads/Data/Resources/catalog.json`; original API bytes are in its `raw/` folder.
- Household scenarios, cost thresholds, resource changes, support and luck are
  explicitly authored design assumptions, not statistical facts or individual causal estimates.

## Randomness algorithm

The pure Swift implementation uses FNV-1a and SplitMix64 arithmetic, with keyed
streams defined by this project's versioned contract. SplitMix64 reference:
Sebastiano Vigna, [public-domain reference](https://prng.di.unimi.it/splitmix64.c).
No reference game's code, event text, artwork or data was imported.

## LC-03 additional national statistics (retrieved 2026-10-24)

WHO Global Health Expenditure Database, redistributed by World Bank WDI:
`SH.XPD.OOPC.CH.ZS` (out-of-pocket / current health expenditure) and
`SH.XPD.CHEX.GD.ZS` (current health expenditure / GDP), seven economies, 2023.
Indicator pages mark CC BY 4.0; retain the World Bank Dataset Terms above.
Raw API bytes, exact values and hashes accompany the catalog. National financing
shares are not individual medical bills, service availability or treatment effects.

衛生福利部統計處，2026年發布113年NHE統計表中的112年（2023）本國列。
數位發展部，數位近用調查112年度全國列（CSV原編碼CP950）。
兩者依 [政府資料開放授權條款第1版](https://data.gov.tw/license) 釋出。
使用者遵守該條款可利用及改作；顯名義務仍須保留，不宣稱政府背書。
授權依據分別為[衛福部宣告](https://www.mohw.gov.tw/www/cp-81-155-1.html)及
[數發部開放資料集5960](https://data.gov.tw/dataset/5960)。
只取本國統計列，不含機關標誌、照片、專案文章或NHE內第三方國際表格。

台灣12歲以上國民個人上網率及含商保理賠的家庭自付份額保留原生定義，
不當作WDI全人口使用率或WHO直接自付份額。CHE/GDP作背景展示，不推算個人機會。
機讀來源含原始下載SHA256、欄位及年度位置；來源改版需重新核對。
