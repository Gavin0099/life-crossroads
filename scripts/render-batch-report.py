#!/usr/bin/env python3
"""Render engine-produced LC-05 batch statistics; never select events or run a simulation."""
import argparse
import html
import json
import math
import os
from pathlib import Path
import sys
import tempfile


class ReportError(ValueError):
    pass


def require_object(value, path):
    if not isinstance(value, dict):
        raise ReportError(f"{path}: expected an object")
    return value


def required(value, key, path):
    require_object(value, path)
    if key not in value:
        raise ReportError(f"{path}.{key}: required field is missing")
    return value[key]


def integer(value, path, minimum=0):
    if type(value) is not int or value < minimum:
        raise ReportError(f"{path}: expected an integer >= {minimum}")
    return value


def number(value, path):
    if type(value) not in (int, float) or not math.isfinite(value):
        raise ReportError(f"{path}: expected a finite number")
    return value


def string(value, path):
    if not isinstance(value, str) or not value:
        raise ReportError(f"{path}: expected a nonempty string")
    return value


def array(value, path):
    if not isinstance(value, list):
        raise ReportError(f"{path}: expected an array")
    return value


def check(condition, message):
    if not condition:
        raise ReportError(message)


def format_rate(numerator, denominator):
    integer(numerator, "rate numerator")
    integer(denominator, "rate denominator")
    check(numerator <= denominator, "rate numerator exceeds denominator")
    if denominator == 0:
        return "— (0/0)"
    return f"{numerator}/{denominator} ({numerator / denominator:.1%})"


def escape(value):
    return html.escape(str(value)).replace("|", "\\|").replace("\n", "<br>")


def table(headers, rows):
    return "\n".join([
        "| " + " | ".join(escape(x) for x in headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
        *("| " + " | ".join(escape(x) for x in row) + " |" for row in rows),
    ])


def reject_duplicate_keys(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ReportError(f"duplicate JSON field: {key}")
        result[key] = value
    return result


def read_json(path):
    def invalid_number(value):
        raise ReportError(f"non-finite JSON number: {value}")
    return json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=reject_duplicate_keys,
                      parse_constant=invalid_number)

POLICIES = {
    "investFirst": "投入優先", "supportFirst": "求助優先",
    "restFirst": "休息優先", "seededVariety": "穩定亂數多樣選擇",
}
RESOURCES = {"health": "健康", "financial": "財務安全", "relationships": "人際關係", "skills": "技能"}
COUNTRIES = {"JPN": "日本", "USA": "美國", "IND": "印度", "KEN": "肯亞"}
STAGES = {"childhood": "童年", "adolescence": "青少年", "youngAdult": "青年", "middleAge": "中年", "laterLife": "晚年"}


def objects(value, path):
    values = array(value, path)
    for index, item in enumerate(values):
        require_object(item, f"{path}[{index}]")
    return values


def unique(values, path):
    check(len(values) == len(set(values)), f"{path}: duplicate values")


def rate(value, path, denominator=None):
    count = integer(required(value, "count", path), f"{path}.count")
    total = integer(required(value, "denominator", path), f"{path}.denominator")
    check(count <= total, f"{path}: count exceeds denominator")
    if denominator is not None:
        check(total == denominator, f"{path}: denominator {total} != {denominator}")
    reported = value.get("rate")  # Codable omits nil when the denominator is zero.
    if total == 0:
        check(reported is None, f"{path}: zero denominator requires an undefined rate")
    else:
        number(required(value, "rate", path), f"{path}.rate")
        check(math.isclose(reported, count / total, rel_tol=1e-10, abs_tol=1e-12), f"{path}: rate disagrees with counts")
    return count


def metric(value):
    return format_rate(value["count"], value["denominator"])


def background(value, path):
    keys = [string(required(value, key, path), f"{path}.{key}") for key in ("countryCode", "householdID", "templateID")]
    return tuple(keys)


def values(value, path, bounded=True):
    require_object(value, path)
    for key in RESOURCES:
        item = required(value, key, path)
        if bounded:
            integer(item, f"{path}.{key}")
            check(item <= 100, f"{path}.{key}: resource exceeds 100")
        else:
            check(type(item) is int, f"{path}.{key}: expected an integer")


def histogram(items, path, key, denominator, allowed=None, require_zero=False):
    items = objects(items, path)
    observed = []
    total = 0
    for index, item in enumerate(items):
        slot = f"{path}[{index}]"
        label = required(item, key, slot)
        if key == "signature":
            string(label, f"{slot}.{key}")
        elif label is not None:
            integer(label, f"{slot}.{key}")
        if allowed is not None:
            check(label in allowed, f"{slot}: unsupported {key}")
        observed.append(label)
        total += rate(required(item, "frequency", slot), f"{slot}.frequency", denominator)
    unique(observed, path)
    check(total == denominator, f"{path}: frequencies sum to {total}, expected {denominator}")
    if require_zero:
        check(0 in observed, f"{path}: the zero-difference bin must be retained")
    return items


def pair_differences(value, path, expected_pairs, slots):
    check(integer(required(value, "pairCount", path), f"{path}.pairCount") == expected_pairs,
          f"{path}: wrong number of pairs")
    for key in ("eventIDHamming", "storyRouteHamming"):
        histogram(required(value, key, path), f"{path}.{key}", "distance", expected_pairs,
                  allowed=set(range(slots + 1)), require_zero=True)


def clamp_summary(value, path, observation_count, jumps):
    check(integer(required(value, "totalObservations", path), f"{path}.totalObservations") == observation_count,
          f"{path}: incorrect observation count")
    if jumps:
        with_hooks = integer(required(value, "observationsWithHooks", path), f"{path}.observationsWithHooks")
        check(with_hooks <= observation_count, f"{path}: hook observations exceed total")
    else:
        check(value.get("observationsWithHooks") is None, f"{path}: decision observations cannot claim hook counts")
    summaries = objects(required(value, "resources", path), f"{path}.resources")
    check({x.get("resource") for x in summaries} == set(RESOURCES) and len(summaries) == len(RESOURCES),
          f"{path}: expected all four distinct resources")
    for item in summaries:
        loc = f"{path}.{item['resource']}"
        positive = integer(required(item, "positiveNetGainSteps", loc), f"{loc}.positiveNetGainSteps")
        check(positive <= observation_count, f"{loc}: positive steps exceed observations")
        across = rate(required(item, "clippedAcrossAllSteps", loc), f"{loc}.clippedAcrossAllSteps", observation_count)
        clipped = rate(required(item, "clippedPositiveSteps", loc), f"{loc}.clippedPositiveSteps", positive)
        offset = rate(required(item, "fullyOffsetPositiveSteps", loc), f"{loc}.fullyOffsetPositiveSteps", positive)
        check(across == clipped and offset <= clipped, f"{loc}: inconsistent clipped/offset counts")
        points = integer(required(item, "requestedPositivePoints", loc), f"{loc}.requestedPositivePoints")
        check(points >= positive, f"{loc}: positive points smaller than positive step count")
        rate(required(item, "lostPositivePoints", loc), f"{loc}.lostPositivePoints", points)
        integer(required(item, "lowerBoundAdjustmentPoints", loc), f"{loc}.lowerBoundAdjustmentPoints")
    for index, item in enumerate(objects(required(value, "attributions", path), f"{path}.attributions")):
        loc = f"{path}.attributions[{index}]"
        kind = string(required(item, "kind", loc), f"{loc}.kind")
        check(kind in ({"singleHookJump", "aggregateHookJump"} if jumps else {"decision"}), f"{loc}: wrong attribution kind")
        check(required(item, "resource", loc) in RESOURCES, f"{loc}: unsupported resource")
        integer(required(item, "age", loc), f"{loc}.age")
        origins = objects(required(item, "originHooks", loc), f"{loc}.originHooks")
        rate(required(item, "clippedOccurrences", loc), f"{loc}.clippedOccurrences")
        rate(required(item, "lostPositivePoints", loc), f"{loc}.lostPositivePoints")
        if kind == "decision":
            check(not origins, f"{loc}: decision attribution has hook origins")
            string(required(item, "eventID", loc), f"{loc}.eventID")
            string(required(item, "choiceID", loc), f"{loc}.choiceID")
        else:
            integer(required(item, "fromAge", loc), f"{loc}.fromAge")
            check(len(origins) == 1 if kind == "singleHookJump" else len(origins) >= 2,
                  f"{loc}: hook group size disagrees with kind")
            if kind == "aggregateHookJump":
                check(item.get("eventID") is None and item.get("choiceID") is None,
                      f"{loc}: aggregate jump must not assign loss to one event/choice")
        for origin in origins:
            hook_origin(origin, f"{loc}.originHook")


def hook_origin(value, path):
    for key in ("hookID", "eventID", "choiceID"):
        string(required(value, key, path), f"{path}.{key}")
    integer(required(value, "dueAge", path), f"{path}.dueAge")
    values(required(value, "requestedEffect", path), f"{path}.requestedEffect", bounded=False)


def validate_report(report):
    require_object(report, "report")
    check(integer(required(report, "schemaVersion", "report"), "schemaVersion") == 1, "unsupported report schemaVersion")
    for key in ("analysisVersion", "engineVersion", "dataVersion", "contentVersion", "claimBoundary"):
        string(required(report, key, "report"), key)
    seeds = array(required(report, "seeds", "report"), "seeds")
    check(2 <= len(seeds) <= 128, "seeds: expected 2...128 seeds")
    for seed in seeds:
        check(integer(seed, "seed") <= 2**64 - 1, "seed exceeds UInt64")
    unique(seeds, "seeds")
    policies = array(required(report, "policies", "report"), "policies")
    check(set(policies) == set(POLICIES) and len(policies) == 4, "policies: expected four distinct declared policies")
    countries = array(required(report, "countryCodes", "report"), "countryCodes")
    check(set(countries) == set(COUNTRIES) and len(countries) == 4, "countryCodes: expected four playable countries")
    ages = array(required(report, "decisionAges", "report"), "decisionAges")
    check(bool(ages), "decisionAges: cannot be empty")
    for age in ages:
        integer(age, "decisionAge")
    check(ages == sorted(set(ages)), "decisionAges: must be unique and increasing")
    definitions = objects(required(report, "policyDefinitions", "report"), "policyDefinitions")
    check({x.get("policy") for x in definitions} == set(policies) and len(definitions) == len(policies), "policyDefinitions: missing or duplicate policy")
    for definition in definitions:
        for choice in array(required(definition, "priorityChoiceIDs", "policyDefinition"), "priorityChoiceIDs"):
            string(choice, "priorityChoiceID")
        string(required(definition, "fallback", "policyDefinition"), "fallback")
        if definition.get("randomChannel") is not None:
            string(definition["randomChannel"], "randomChannel")
    cohorts = objects(required(report, "cohorts", "report"), "cohorts")
    expected_runs = len(countries) * 2 * len(policies) * len(seeds)
    check(integer(required(report, "runCount", "report"), "runCount") == expected_runs, "runCount does not match the declared 4 × 2 × 4 × seed grid")
    check(len(cohorts) == len(countries) * 2 * len(policies), "cohorts: incomplete experiment grid")
    cohort_keys = []
    backgrounds = set()
    event_sets = []
    choice_sets = []
    for index, cohort in enumerate(cohorts):
        loc = f"cohorts[{index}]"
        context = background(required(cohort, "background", loc), f"{loc}.background")
        check(context[0] in countries, f"{loc}: undeclared country")
        backgrounds.add(context)
        policy = required(cohort, "policy", loc)
        check(policy in policies, f"{loc}: undeclared policy")
        cohort_keys.append((*context, policy))
        n = integer(required(cohort, "runCount", loc), f"{loc}.runCount")
        check(n == len(seeds), f"{loc}: incomplete seed sample")
        coverage = objects(required(cohort, "eventCoverage", loc), f"{loc}.eventCoverage")
        encounters = {}
        event_age = {}
        for item in coverage:
            event_id = string(required(item, "eventID", loc), f"{loc}.eventID")
            age = integer(required(item, "age", loc), f"{loc}.age")
            check(age in ages, f"{loc}: event age is outside the declared schedule")
            opportunities = integer(required(item, "ageOpportunities", loc), f"{loc}.ageOpportunities")
            check(opportunities == n, f"{loc}: event opportunity denominator does not match reached age")
            eligible = rate(required(item, "eligible", loc), f"{loc}.{event_id}.eligible", opportunities)
            selected = rate(required(item, "selected", loc), f"{loc}.{event_id}.selected", opportunities)
            check(selected <= eligible, f"{loc}: selected count exceeds eligibility")
            check(rate(required(item, "selectedWhenEligible", loc), f"{loc}.{event_id}.selectedWhenEligible", eligible) == selected,
                  f"{loc}: conditional selection count disagrees")
            check(event_id not in encounters, f"{loc}: duplicate event coverage")
            encounters[event_id] = selected
            event_age[event_id] = age
        check(set(event_age.values()) == set(ages), f"{loc}: missing age coverage")
        for age in ages:
            check(sum(encounters[k] for k, a in event_age.items() if a == age) == n, f"{loc}: age selections do not sum to run count")
        event_sets.append(set(encounters))
        choices = objects(required(cohort, "choiceHistogram", loc), f"{loc}.choiceHistogram")
        choice_keys = []
        chosen_total = {event_id: 0 for event_id in encounters}
        for item in choices:
            event_id = required(item, "eventID", loc)
            check(event_id in encounters, f"{loc}: choice refers to missing event")
            choice_id = string(required(item, "choiceID", loc), f"{loc}.choiceID")
            choice_keys.append((event_id, choice_id))
            offered = integer(required(item, "offeredOpportunities", loc), f"{loc}.offeredOpportunities")
            available = integer(required(item, "availableOpportunities", loc), f"{loc}.availableOpportunities")
            chosen = rate(required(item, "chosen", loc), f"{loc}.chosen", encounters[event_id])
            check(chosen <= available <= offered <= encounters[event_id], f"{loc}: chosen/available/offered count is inconsistent")
            chosen_total[event_id] += chosen
        unique(choice_keys, f"{loc}.choiceHistogram")
        check(chosen_total == encounters, f"{loc}: chosen counts do not match event encounters")
        choice_sets.append(set(choice_keys))
        for key in ("eventRoutes", "storyRoutes"):
            routes = histogram(required(cohort, key, loc), f"{loc}.{key}", "signature", n)
            for route in routes:
                try:
                    signature = json.loads(route["signature"])
                except json.JSONDecodeError as error:
                    raise ReportError(f"{loc}.{key}: malformed canonical route signature") from error
                check(isinstance(signature, list) and len(signature) == len(ages), f"{loc}.{key}: route length differs from decision schedule")
                check(route["frequency"]["count"] > 0, f"{loc}.{key}: observed routes must have positive counts")
        pair_differences(required(cohort, "seedPairDifferences", loc), f"{loc}.seedPairDifferences", n * (n - 1) // 2, len(ages))
        summaries = objects(required(cohort, "resourceSummaries", loc), f"{loc}.resourceSummaries")
        check({x.get("resource") for x in summaries} == set(RESOURCES) and len(summaries) == 4, f"{loc}: missing resource summary")
        for item in summaries:
            name = item["resource"]
            detail = f"{loc}.{name}"
            bins = histogram(required(item, "finalValues", detail), f"{detail}.finalValues", "value", n, allowed=set(range(101)))
            final = rate(required(item, "finalAt100", detail), f"{detail}.finalAt100", n)
            expected_final = sum(x["frequency"]["count"] for x in bins if x["value"] == 100)
            check(final == expected_final, f"{detail}: final saturation disagrees with value distribution")
            ever = rate(required(item, "everObservedAt100", detail), f"{detail}.everObservedAt100", n)
            check(ever >= final, f"{detail}: ever saturation is lower than final saturation")
            first = objects(required(item, "firstObservedAt100Age", detail), f"{detail}.firstObservedAt100Age")
            first_ages, first_total, never = [], 0, 0
            for bin_item in first:
                first_age = bin_item.get("age")  # nil is the documented never-observed bin.
                if first_age is not None:
                    integer(first_age, f"{detail}.firstAge")
                first_ages.append(first_age)
                count = rate(required(bin_item, "frequency", detail), f"{detail}.firstFrequency", n)
                first_total += count
                if first_age is None:
                    never += count
            unique(first_ages, f"{detail}.firstAges")
            check(first_total == n and never == n - ever, f"{detail}: first saturation distribution disagrees")
            by_age = objects(required(item, "byAge", detail), f"{detail}.byAge")
            check(len(by_age) == len(ages) and {x.get("age") for x in by_age} == set(ages), f"{detail}: incomplete age rows")
            age_total = sum(rate(required(x, "postDecisionAt100", detail), f"{detail}.byAge", n) for x in by_age)
            by_stage = objects(required(item, "byStage", detail), f"{detail}.byStage")
            check(len(by_stage) == len(STAGES) and {x.get("stage") for x in by_stage} == set(STAGES), f"{detail}: incomplete stage rows")
            stage_total = 0
            stage_denominator = 0
            for stage in by_stage:
                item_rate = required(stage, "postDecisionAt100", detail)
                stage_total += rate(item_rate, f"{detail}.byStage")
                stage_denominator += item_rate["denominator"]
            check(stage_total == age_total and stage_denominator == n * len(ages), f"{detail}: stage/age saturation totals disagree")
        clamp_summary(required(cohort, "decisionClamps", loc), f"{loc}.decisionClamps", n * len(ages), jumps=False)
        clamp_summary(required(cohort, "timeJumpClamps", loc), f"{loc}.timeJumpClamps", n * len(ages), jumps=True)
    unique(cohort_keys, "cohorts")
    check(len(backgrounds) == len(countries) * 2, "background grid is incomplete")
    for country in countries:
        check(len({x for x in backgrounds if x[0] == country}) == 2, "each country must contain two backgrounds")
    check(all(x == event_sets[0] for x in event_sets), "cohorts must retain the same event universe, including zero-trigger events")
    check(all(x == choice_sets[0] for x in choice_sets), "cohorts must retain the same event/choice universe, including unused choices")
    comparisons = objects(required(report, "policyComparisons", "report"), "policyComparisons")
    comparison_keys = []
    for index, comparison in enumerate(comparisons):
        loc = f"policyComparisons[{index}]"
        context = background(required(comparison, "background", loc), f"{loc}.background")
        first = required(comparison, "firstPolicy", loc)
        second = required(comparison, "secondPolicy", loc)
        check(context in backgrounds and first in policies and second in policies and first != second, f"{loc}: invalid policy pair")
        comparison_keys.append((*context, *sorted((first, second))))
        paired = array(required(comparison, "pairedSeeds", loc), f"{loc}.pairedSeeds")
        check(len(paired) == len(seeds) and set(paired) == set(seeds), f"{loc}: incomplete paired Seeds")
        pair_differences(required(comparison, "differences", loc), f"{loc}.differences", len(seeds), len(ages))
    unique(comparison_keys, "policyComparisons")
    check(len(comparisons) == len(backgrounds) * len(policies) * (len(policies) - 1) // 2, "policyComparisons: missing policy pairs")
    runs = objects(required(report, "runs", "report"), "runs")
    check(len(runs) == expected_runs, "runs: missing raw playthroughs")
    run_keys = []
    for index, run in enumerate(runs):
        loc = f"runs[{index}]"
        context = background(required(run, "background", loc), f"{loc}.background")
        policy = required(run, "policy", loc)
        seed = required(run, "seed", loc)
        check((*context, policy) in cohort_keys and seed in seeds, f"{loc}: undeclared playthrough")
        run_keys.append((*context, policy, seed))
        values(required(run, "initialResources", loc), f"{loc}.initialResources")
        values(required(run, "finalResources", loc), f"{loc}.finalResources")
        steps = objects(required(run, "steps", loc), f"{loc}.steps")
        check([x.get("age") for x in steps] == ages, f"{loc}: raw decision schedule is incomplete")
        for step in steps:
            step_path = f"{loc}.step({step['age']})"
            event_id = string(required(step, "eventID", step_path), f"{step_path}.eventID")
            check(event_id in event_sets[0], f"{step_path}: undeclared event")
            if step.get("storyVariantID") is not None:
                string(step["storyVariantID"], f"{step_path}.storyVariantID")
            choice = string(required(step, "choiceID", step_path), f"{step_path}.choiceID")
            offered = array(required(step, "offeredChoiceIDs", step_path), f"{step_path}.offeredChoiceIDs")
            available = array(required(step, "availableChoiceIDs", step_path), f"{step_path}.availableChoiceIDs")
            check(choice in available and set(available).issubset(offered), f"{step_path}: choice was not feasible/offered")
            for key in ("resourcesBefore", "resourcesAfter", "requestedDeltaBeforeClamp", "clampAdjustment"):
                values(required(step, key, step_path), f"{step_path}.{key}", bounded=key in ("resourcesBefore", "resourcesAfter"))
            for resource in RESOURCES:
                check(step["resourcesBefore"][resource] + step["requestedDeltaBeforeClamp"][resource] + step["clampAdjustment"][resource] == step["resourcesAfter"][resource],
                      f"{step_path}: resource transition is inconsistent")
            candidates = objects(required(step, "candidates", step_path), f"{step_path}.candidates")
            eligible_ids = []
            for candidate in candidates:
                string(required(candidate, "eventID", step_path), f"{step_path}.candidate.eventID")
                check(type(required(candidate, "eligible", step_path)) is bool, f"{step_path}: candidate eligibility must be boolean")
                if candidate["eligible"]:
                    eligible_ids.append(candidate["eventID"])
            check(event_id in eligible_ids, f"{step_path}: selected event was not eligible")
        jumps = objects(required(run, "timeJumps", loc), f"{loc}.timeJumps")
        check(len(jumps) == len(ages), f"{loc}: raw time jumps are incomplete")
        for jump in jumps:
            integer(required(jump, "fromAge", loc), f"{loc}.fromAge")
            integer(required(jump, "toAge", loc), f"{loc}.toAge")
            check(jump["toAge"] > jump["fromAge"], f"{loc}: time jump does not advance")
            for key in ("resourcesBefore", "resourcesAfter", "requestedDeltaBeforeClamp", "clampAdjustment"):
                values(required(jump, key, loc), f"{loc}.jump.{key}", bounded=key in ("resourcesBefore", "resourcesAfter"))
            for origin in objects(required(jump, "originHooks", loc), f"{loc}.originHooks"):
                hook_origin(origin, f"{loc}.originHook")
    unique(run_keys, "runs")
    return report


def ratio(value):
    return format_rate(value["count"], value["denominator"])


def median_bins(bins):
    total = sum(x["frequency"]["count"] for x in bins)
    if not total:
        return None
    ranks = [(total - 1) // 2, total // 2]
    found = []
    count = 0
    for row in sorted(bins, key=lambda x: x["distance"]):
        end = count + row["frequency"]["count"]
        found.extend(row["distance"] for rank in ranks if count <= rank < end)
        count = end
    return sum(found) / 2


def render(report):
    validate_report(report)
    lines = ["# 人生批次量測", "", report["claimBoundary"], "",
             f"引擎 `{report['engineVersion']}`；內容 `{report['contentVersion']}`；資料 `{report['dataVersion']}`；分析 `{report['analysisVersion']}`。",
             f"樣本：{report['runCount']} 局；Seeds：{report['seeds']}；策略版本：{report['policyVersion']}。", "",
             "事件距離只計不同event ID；故事距離另計同事件的變體。0距離包含在完整配對中。資源值不合成人生分數。", ""]
    rows = []
    for c in report["cohorts"]:
        bins = c["seedPairDifferences"]["eventIDHamming"]
        resources = {r["resource"]: r for r in c["resourceSummaries"]}
        rows.append([c["background"]["householdID"], POLICIES[c["policy"]], len(c["eventRoutes"]),
                     median_bins(bins), ratio(bins[0]["frequency"]),
                     *(ratio(resources[key]["finalAt100"]) for key in RESOURCES)])
    lines += ["## 分群總覽", "", table(["家庭", "策略", "事件路線數", "事件差異中位數", "完全相同率", *[x+"最終100" for x in RESOURCES.values()]], rows), ""]
    for c in report["cohorts"]:
        lines += [f"## {c['background']['householdID']}／{POLICIES[c['policy']]}", "",
                  "### 事件出現與資格", "",
                  table(["事件", "年齡", "符合／機會", "入選／機會", "入選／符合", "未符合原因（可重疊）"],
                        [[e["eventID"], e["age"], ratio(e["eligible"]), ratio(e["selected"]), ratio(e["selectedWhenEligible"]),
                          "; ".join(f"{f['condition']['id']}: {ratio(f['failed'])}" for f in e["conditionFailures"])] for e in c["eventCoverage"]]), "",
                  "### 實際選項", "",
                  table(["事件", "選項", "提供", "可行", "提交／遇到事件"],
                        [[x["eventID"], x["choiceID"], x["offeredOpportunities"], x["availableOpportunities"], ratio(x["chosen"])] for x in c["choiceHistogram"]]), "",
                  f"相鄰相同行動類型：{ratio(c['adjacentSameChoiceKind'])}（不是事件類型）。", "",
                  "### 封頂損失", ""]
        for key, title in [("decisionClamps", "當回合"), ("timeJumpClamps", "延遲呼應／時間跳躍")]:
            lines += [f"{title}，觀測數 {c[key]['totalObservations']}。", "",
                      table(["資源", "截斷／正淨增益", "完全抵銷／正淨增益", "損失／原淨增益點數"],
                            [[RESOURCES[x['resource']],ratio(x['clippedPositiveSteps']),ratio(x['fullyOffsetPositiveSteps']),ratio(x['lostPositivePoints'])] for x in c[key]['resources']]), ""]
        lines += ["### 故事鏈", "", table(["規則", "前因出現", "後續有trace", "來源選擇吻合"],
                  [[x['ruleID'], ratio(x['originObserved']), ratio(x['outcomeWithTrace']), ratio(x['traceMatchesPriorChoice'])] for x in c['storyChains']]), ""]
    lines += ["## 同背景、同Seed、不同策略", "", table(["家庭", "策略一", "策略二", "配對數", "事件距離中位數", "故事距離中位數"],
              [[x['background']['householdID'], POLICIES[x['firstPolicy']], POLICIES[x['secondPolicy']], x['differences']['pairCount'], median_bins(x['differences']['eventIDHamming']), median_bins(x['differences']['storyRouteHamming'])] for x in report['policyComparisons']]), "",
              "零觸發只代表本批次未觀察到；完整分布、逐步資源及多hook聚合截斷來源見同名JSON。實機、VoiceOver與兒少重玩意願仍未驗收。", ""]
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    try:
        text = render(read_json(args.input))
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")
    except (OSError, ValueError, KeyError, TypeError) as error:
        print(f"batch report failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
