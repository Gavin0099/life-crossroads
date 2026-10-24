import Foundation

/// Native definitions stay distinct. A matching unit alone never grants comparability.
public enum IndicatorContract {
    public static func valid(_ observation: IndicatorObservation) -> Bool {
        let contract: [String: (String, String?, String)] = [
            "IT.NET.USER.ZS": ("% of population", "wdi-internet-population-2023", "ruleInput"),
            "EG.ELC.ACCS.ZS": ("% of population", "wdi-electricity-population-2023", "ruleInput"),
            "SH.XPD.OOPC.CH.ZS": ("% of current health expenditure", "sha2011-oop-che-2023", "ruleInput"),
            "SH.XPD.CHEX.GD.ZS": ("% of GDP", "sha2011-che-gdp-2023", "contextOnly"),
            "TWN.INTERNET.12PLUS": ("% of nationals aged 12+ in households", nil, "contextOnly"),
            "TWN.OOP.INCLUDING.REIMBURSEMENT": ("% of current health expenditure (including commercial reimbursement)", nil, "contextOnly")
        ]
        guard let expected = contract[observation.indicator] else { return false }
        return observation.unit == expected.0 && observation.comparisonGroup == expected.1
            && observation.usage == expected.2 && observation.title?.isEmpty == false
            && observation.definition?.isEmpty == false
    }
}
