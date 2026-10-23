import importlib.util
import unittest
from pathlib import Path

spec = importlib.util.spec_from_file_location("build_data", Path(__file__).parents[1] / "scripts/build-data.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class DataGenerationTests(unittest.TestCase):
    def test_country_order_does_not_change_household_initial_resources(self):
        original_order = module.COUNTRIES[:]
        try:
            original = {h["id"]: h["initialResources"] for h in module.build()["households"]}
            module.COUNTRIES = list(reversed(original_order))
            reordered = {h["id"]: h["initialResources"] for h in module.build()["households"]}
            self.assertEqual(original, reordered)
        finally:
            module.COUNTRIES = original_order

    def test_only_explicit_digital_choices_use_macro_rules(self):
        data = module.build()
        digital_events = {"teen-project", "teen-direction", "adult-learning", "middle-turn"}
        for event in data["decisions"]:
            for choice in event["choices"]:
                self.assertEqual(choice["requiresDigitalAccess"], event["id"] in digital_events and choice["id"] == "invest")
            if event["id"] in digital_events:
                self.assertTrue(any(c["kind"] == "learn" and not c["requiresDigitalAccess"] for c in event["choices"]))

    def test_named_household_templates_are_shared_without_country_health(self):
        data = module.build()
        expected_health = {"shared-equipment-near-support": 66, "own-equipment-long-commute": 64}
        for household in data["households"]:
            self.assertEqual(household["initialResources"]["health"], expected_health[household["templateID"]])


if __name__ == "__main__":
    unittest.main()
