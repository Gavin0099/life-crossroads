enum DemoMode: Equatable {
    case demo, json, storySamples, batchReport(seedCount: Int)
}

enum DemoArgumentError: Error, CustomStringConvertible {
    case invalid(String)
    var description: String {
        switch self {
        case .invalid(let reason):
            "\(reason)\nUsage: life-demo [--json | --story-samples | --batch-report [--seed-count N]]; N: 2...128 (default 32)"
        }
    }
}

/// Parse before loading any data or starting a simulation. Unknown or conflicting flags never fall back.
enum DemoCLIArguments {
    static func parse(_ arguments: [String]) throws -> DemoMode {
        var mode: String?
        var seedCount: Int?
        var index = 0
        while index < arguments.count {
            let flag = arguments[index]
            switch flag {
            case "--json", "--story-samples", "--batch-report":
                guard mode == nil else { throw DemoArgumentError.invalid("Duplicate or conflicting mode: \(flag)") }
                mode = flag
            case "--seed-count":
                guard seedCount == nil else { throw DemoArgumentError.invalid("Duplicate --seed-count") }
                index += 1
                guard index < arguments.count else { throw DemoArgumentError.invalid("Missing --seed-count value") }
                let token = arguments[index]
                guard !token.isEmpty, token.utf8.allSatisfy({ (48...57).contains($0) }),
                      let value = Int(token), (2...128).contains(value) else {
                    throw DemoArgumentError.invalid("--seed-count must be an integer in 2...128")
                }
                seedCount = value
            default:
                throw DemoArgumentError.invalid("Unknown argument: \(flag)")
            }
            index += 1
        }
        if mode == "--batch-report" { return .batchReport(seedCount: seedCount ?? 32) }
        guard seedCount == nil else { throw DemoArgumentError.invalid("--seed-count requires --batch-report") }
        switch mode {
        case "--json": return .json
        case "--story-samples": return .storySamples
        default: return .demo
        }
    }
}
