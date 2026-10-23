import Foundation
import LifeDomain
import LifeData

private struct DirectorCoverage: Encodable {
    let eventID: String
    var eligibleSlots = 0
    var selectedOccurrences = 0
    var resolvedConsequences = 0
    var eligibleLives = 0
    var selectedLives = 0
    var selectionRatePerEligibleSlot: Double? { eligibleSlots == 0 ? nil : Double(selectedOccurrences) / Double(eligibleSlots) }
    enum CodingKeys: String, CodingKey { case eventID, eligibleSlots, selectedOccurrences, resolvedConsequences, eligibleLives, selectedLives, selectionRatePerEligibleSlot }
    func encode(to encoder: any Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(eventID, forKey: .eventID); try values.encode(eligibleSlots, forKey: .eligibleSlots)
        try values.encode(selectedOccurrences, forKey: .selectedOccurrences); try values.encode(resolvedConsequences, forKey: .resolvedConsequences)
        try values.encode(eligibleLives, forKey: .eligibleLives); try values.encode(selectedLives, forKey: .selectedLives)
        try values.encode(selectionRatePerEligibleSlot, forKey: .selectionRatePerEligibleSlot)
    }
}
private struct DirectorContextResult: Encodable {
    let countryCode: String
    let householdID: String
    var completed = 0
    var pathSignatures: [String] = []
}
private struct DirectorBatchTotals: Encodable {
    var attempted = 0
    var completed = 0
    var selectionTraces = 0
    var consequenceTraces = 0
    var executedEffectSteps = 0
    var delayedCallbacks = 0
    var relationshipFacts = 0
    var repeatedOccurrences = 0
    var onceOnlyViolations = 0
    var cooldownViolations = 0
    var exclusiveGroupViolations = 0
    var ineligibleSelections = 0
    var tracePairViolations = 0
    var deadEnds = 0
    var completionViolations = 0
    var replayMatched = 0
    var permutationMatched = 0
    var resumeMatched = 0
    var recoveryChecks = 0
    var recoveryViolations = 0
}
private struct DirectorTargetedEvidence: Encodable {
    let name: String
    let seed: UInt64
    let inputRoute: [String]
    let eventID: String
    let age: Int
    let factOrigin: RelationshipFact?
    let offeredWithFact: [String]?
    let offeredWithoutFact: [String]?
    let executedTrace: ConsequenceTrace?
}
private struct DirectorSample: Encodable {
    let label: String
    let choicePolicyKeys: [String]
    let life: DirectedLifeSession
}
private struct DirectorBatchEvidence: Encodable {
    let purpose: String
    let status: String
    let catalogVersion: String
    let engineVersion: String
    let directorVersion: String
    let randomVersion: String
    let dataVersion: String
    let legacyContentVersion: String
    let seedRangeInclusive: [Int]
    let expectedLives: Int
    let decisionSlots: Int
    let eventDefinitions: Int
    let policy: String
    let totals: DirectorBatchTotals
    let contexts: [DirectorContextResult]
    let coverage: [DirectorCoverage]
    let zeroEligibleEventIDs: [String]
    let zeroSelectedEventIDs: [String]
    let targeted: [DirectorTargetedEvidence]
    let failures: [String]
    let samples: [DirectorSample]
    let limitations: [String]
}
private struct AuditPlay {
    let run: DirectedLifeSession
    let choiceKeys: [String]
    let recoveryChecks: Int
    let recoveryViolations: Int
}

/// Explicit CLI adapter. It performs no file I/O in Domain; stdout is the reviewable JSON artifact.
func runDirectorAudit() throws {
    let base = try StatisticsRepository.bundled()
    let catalog = try DirectedDemo.catalog(base: base)
    try catalog.validate()
    let arguments = CommandLine.arguments
    var seedCount = 128
    if let index = arguments.firstIndex(of: "--seeds-per-context") {
        guard arguments.indices.contains(index + 1), let count = Int(arguments[index + 1]), (1...4096).contains(count) else {
            throw ModelError.invalid("--seeds-per-context must be 1...4096")
        }
        seedCount = count
    }
    let countries = ["JPN", "USA", "IND", "KEN"]
    var reversed = catalog; reversed.events.reverse()
    var coverage = Dictionary(uniqueKeysWithValues: catalog.events.map { ($0.id, DirectorCoverage(eventID: $0.id)) })
    var totals = DirectorBatchTotals(), contexts: [DirectorContextResult] = [], failures: [String] = [], samples: [DirectorSample] = []
    for code in countries {
        for family in 1...2 {
            let household = "\(code.lowercased())-\(family)"
            var context = DirectorContextResult(countryCode: code, householdID: household)
            for seedNumber in 0..<seedCount {
                totals.attempted += 1
                let seed = UInt64(seedNumber)
                do {
                    let played = try auditPlay(catalog: catalog, country: code, household: household, seed: seed, checkRecovery: true)
                    let run = played.run
                    totals.recoveryChecks += played.recoveryChecks; totals.recoveryViolations += played.recoveryViolations
                    guard run.phase == .ended else { totals.deadEnds += 1; continue }
                    context.completed += 1; totals.completed += 1
                    let stages = Set(try run.traces.map { try LifeStage.at(age: $0.age) })
                    if !(12...18).contains(run.traces.count) || stages != Set(LifeStage.allCases) || run.state.age != 80 { totals.completionViolations += 1 }
                    totals.selectionTraces += run.selections.count; totals.consequenceTraces += run.traces.count
                    totals.executedEffectSteps += run.traces.reduce(0) { $0 + $1.effectSteps.count }
                    totals.delayedCallbacks += run.state.memories.count
                    totals.relationshipFacts += run.state.directorHistory?.relationships.count ?? 0
                    let signature = run.traces.map { "\($0.age):\($0.eventID)" }.joined(separator: ">")
                    if !context.pathSignatures.contains(signature) { context.pathSignatures.append(signature) }
                    var eligibleLife: Set<String> = [], selectedLife: Set<String> = []
                    for selection in run.selections {
                        for candidate in selection.candidates where candidate.eligibility.eligible {
                            coverage[candidate.eventID]!.eligibleSlots += 1; eligibleLife.insert(candidate.eventID)
                        }
                        let id = selection.selection.selectedEventID
                        coverage[id]!.selectedOccurrences += 1; selectedLife.insert(id)
                        if selection.candidates.first(where: { $0.eventID == id })?.eligibility.eligible != true { totals.ineligibleSelections += 1 }
                    }
                    for trace in run.traces {
                        coverage[trace.eventID]!.resolvedConsequences += 1
                        if !trace.applied || run.selections.filter({ $0.occurrence.id == trace.occurrenceID && $0.occurrence.eventID == trace.eventID && $0.age == trace.age }).count != 1 { totals.tracePairViolations += 1 }
                    }
                    for id in eligibleLife { coverage[id]!.eligibleLives += 1 }
                    for id in selectedLife { coverage[id]!.selectedLives += 1 }
                    let occurrences = run.state.directorHistory!.occurrences
                    if Set(occurrences.map(\.id)).count != occurrences.count { totals.tracePairViolations += 1 }
                    var groups: [String: Set<String>] = [:]
                    for event in catalog.events {
                        let history = occurrences.filter { $0.eventID == event.id }
                        totals.repeatedOccurrences += max(0, history.count - 1)
                        if let maximum = event.policy.maxOccurrences, history.count > maximum { totals.onceOnlyViolations += 1 }
                        for pair in zip(history, history.dropFirst()) where pair.1.age - pair.0.age < event.policy.cooldownYears { totals.cooldownViolations += 1 }
                        if !history.isEmpty, let group = event.policy.exclusiveGroup { groups[group, default: []].insert(event.id) }
                    }
                    totals.exclusiveGroupViolations += groups.values.filter { $0.count > 1 }.count
                    let decisions = run.traces.map(\.choiceID)
                    let replay = try auditPlay(catalog: catalog, country: code, household: household, seed: seed, decisions: decisions)
                    if replay.run == run { totals.replayMatched += 1 } else { failures.append("replay mismatch: \(household)/\(seed)") }
                    let permutation = try auditPlay(catalog: reversed, country: code, household: household, seed: seed, decisions: decisions)
                    if permutation.run == run { totals.permutationMatched += 1 } else { failures.append("permutation mismatch: \(household)/\(seed)") }
                    let resumed = try auditPlay(catalog: catalog, country: code, household: household, seed: seed, decisions: decisions, resumeAt: 7)
                    if resumed.run == run { totals.resumeMatched += 1 } else { failures.append("resume mismatch: \(household)/\(seed)") }
                    if code == "USA" && family == 1 && seedNumber < 3 {
                        samples.append(.init(label: "同一家庭，不同 Seed：usa-1 / \(seed)", choicePolicyKeys: played.choiceKeys, life: run))
                    }
                } catch {
                    totals.deadEnds += 1
                    failures.append("\(household)/\(seed): \(error)")
                }
            }
            contexts.append(context)
        }
    }
    let targeted: [DirectorTargetedEvidence]
    do { targeted = try auditTargeted(catalog: catalog) }
    catch { targeted = []; failures.append("targeted reachability: \(error)") }
    let expected = seedCount * 8
    let violations = totals.onceOnlyViolations + totals.cooldownViolations + totals.exclusiveGroupViolations + totals.ineligibleSelections + totals.tracePairViolations + totals.completionViolations + totals.recoveryViolations
    let passed = failures.isEmpty && totals.completed == expected && violations == 0 && totals.replayMatched == expected && totals.permutationMatched == expected && totals.resumeMatched == expected
    let rows = coverage.values.sorted { $0.eventID < $1.eventID }
    let evidence = DirectorBatchEvidence(
        purpose: "RNG-01～04 原創純 Swift 排程工程驗證；主批次覆蓋與具名可達性路徑分開。",
        status: passed ? "passed" : "failed", catalogVersion: catalog.version, engineVersion: LifeState.directedEngineVersion,
        directorVersion: EventDirector.version, randomVersion: KeyedRandom.version,
        dataVersion: catalog.model.dataVersion, legacyContentVersion: catalog.model.contentVersion,
        seedRangeInclusive: [0, seedCount - 1], expectedLives: expected, decisionSlots: catalog.slots.count, eventDefinitions: catalog.events.count,
        policy: "每槽以獨立 audit-player-choice-v1 鍵均勻挑選已呈現選項；若回合成本不可行則求助。重播/反序/續玩使用原始實際 choice ID 序列。",
        totals: totals, contexts: contexts, coverage: rows,
        zeroEligibleEventIDs: rows.filter { $0.eligibleSlots == 0 }.map(\.eventID),
        zeroSelectedEventIDs: rows.filter { $0.selectedOccurrences == 0 }.map(\.eventID),
        targeted: targeted, failures: failures, samples: samples,
        limitations: ["固定 Seed 工程樣本不是人口機率、真人遊戲平衡或兒少試玩。", "內容為 19 個定義、每局 15 個決策；P1 的八國、50～70 事件尚未由本批次驗收。", "保留既有模型與統計資料版本；新增權重、年齡窗、關係事實與門檻皆為 rng-scheduling-demo 設計假設。", "中途 Codable restore 不是 SwiftData 磁碟交易或實機存檔驗收。", "未啟動 Simulator，也未合併或發布 App。"])
    let encoder = JSONEncoder(); encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    print(String(decoding: try encoder.encode(evidence), as: UTF8.self))
    if !passed { throw ModelError.invalid("director audit failed; JSON contains preserved failures") }
}

private func auditPlay(catalog: EventCatalog, country: String, household: String, seed: UInt64,
                       decisions: [String]? = nil, resumeAt: Int? = nil, checkRecovery: Bool = false) throws -> AuditPlay {
    var run = try DirectedLifeSession.start(catalog: catalog, countryCode: country, householdID: household, seed: seed)
    var keys: [String] = [], checks = 0, recoveryFailures = 0
    while run.phase != .ended {
        let event = try run.event(catalog: catalog)
        if checkRecovery {
            for id in ["ask", "rest"] {
                checks += 1
                if !(try run.preview(choiceID: id, catalog: catalog).applied) { recoveryFailures += 1 }
            }
        }
        let index = run.traces.count
        let key = KeyedRandom.key(eventID: run.currentOffer!.occurrence.id, age: run.state.age, channel: "audit-player-choice-v1")
        keys.append(key)
        let choice: String
        if let decisions {
            guard decisions.indices.contains(index) else { throw ModelError.invalid("missing replay choice") }
            choice = decisions[index]
        } else {
            let selected = event.choices[min(event.choices.count - 1, Int(KeyedRandom.draw(seed: seed, key: key) * Double(event.choices.count)))].id
            choice = try run.preview(choiceID: selected, catalog: catalog).applied ? selected : "ask"
        }
        try run.choose(choice, catalog: catalog)
        try run.continueLife(catalog: catalog)
        if run.traces.count == resumeAt {
            run = try DirectedLifeSession.restore(JSONEncoder().encode(run), catalog: catalog)
        }
        guard run.traces.count <= 18 else { throw ModelError.invalid("directed life exceeded decision cap") }
    }
    return .init(run: run, choiceKeys: keys, recoveryChecks: checks, recoveryViolations: recoveryFailures)
}

private func auditTargeted(catalog: EventCatalog) throws -> [DirectorTargetedEvidence] {
    var evidence: [DirectorTargetedEvidence] = []
    for seed: UInt64 in 0..<128 {
        var connected = try DirectedLifeSession.start(catalog: catalog, countryCode: "USA", householdID: "usa-1", seed: seed)
        var other = connected
        while connected.phase != .ended {
            let event = try connected.event(catalog: catalog)
            if event.id == "rng-legacy-workshop",
               let fact = connected.state.directorHistory?.relationships.first(where: { $0.factID == "connection" }),
               connected.state.resources.skills >= 28, other.state.resources.skills >= 28 {
                let withFact = event.choices.map(\.id), withoutFact = try other.event(catalog: catalog).choices.map(\.id)
                guard withFact.contains("host"), !withoutFact.contains("host") else { throw ModelError.invalid("relationship gate has no observable difference") }
                let route = connected.traces.map { "\($0.age):\($0.eventID)/\($0.choiceID)" }
                try connected.choose("host", catalog: catalog)
                evidence.append(.init(name: "合法早期選擇留下聯繫，晚年實際開啟主持；同 Seed 改選休息不開啟", seed: seed,
                    inputRoute: route, eventID: event.id, age: event.age, factOrigin: fact,
                    offeredWithFact: withFact, offeredWithoutFact: withoutFact, executedTrace: connected.traces.last))
                break
            }
            try connected.choose("ask", catalog: catalog)
            try other.choose(event.id == "rng-child-tool-library" ? "rest" : "ask", catalog: catalog)
            try connected.continueLife(catalog: catalog); try other.continueLife(catalog: catalog)
        }
        if !evidence.isEmpty { break }
    }
    guard !evidence.isEmpty else { throw ModelError.unavailable("no legal relation-gated route found") }
    // A deliberately narrow history + household condition must have a legal complete path, separately from broad sampling.
    var supportFound = false
    for seed: UInt64 in 0..<1024 {
        var run = try DirectedLifeSession.start(catalog: catalog, countryCode: "KEN", householdID: "ken-1", seed: seed)
        while run.phase != .ended {
            let event = try run.event(catalog: catalog)
            if event.id == "rng-mutual-support" {
                let route = run.traces.map { "\($0.age):\($0.eventID)/\($0.choiceID)" }
                try run.choose("ask", catalog: catalog)
                evidence.append(.init(name: "照顧負荷＋既有 adult-care/ask 歷史的具名可達路徑", seed: seed,
                    inputRoute: route, eventID: event.id, age: event.age, factOrigin: nil,
                    offeredWithFact: nil, offeredWithoutFact: nil, executedTrace: run.traces.last))
                supportFound = true; break
            }
            try run.choose("ask", catalog: catalog); try run.continueLife(catalog: catalog)
        }
        if supportFound { break }
    }
    guard supportFound else { throw ModelError.unavailable("no legal narrow support path found") }
    return evidence
}
