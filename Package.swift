// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LifeCrossroads",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "LifeDomain", targets: ["LifeDomain"]),
        .library(name: "LifeData", targets: ["LifeData"]),
        .library(name: "LifeAnalysis", targets: ["LifeAnalysis"]),
        .library(name: "LifePersistence", targets: ["LifePersistence"]),
        .library(name: "LifePresentation", targets: ["LifePresentation"]),
        .executable(name: "life-demo", targets: ["LifeDemo"])
    ],
    targets: [
        .target(name: "LifeDomain", path: "LifeCrossroads/Domain"),
        .target(name: "LifeData", dependencies: ["LifeDomain"], path: "LifeCrossroads/Data",
                resources: [.copy("Resources")]),
        .target(name: "LifePersistence", dependencies: ["LifeDomain"], path: "LifeCrossroads/Persistence"),
        .target(name: "LifePresentation", dependencies: ["LifeDomain"], path: "LifeCrossroads/Presentation"),
        .target(name: "LifeAnalysis", dependencies: ["LifeDomain"], path: "LifeCrossroads/Analysis"),
        .executableTarget(name: "LifeDemo", dependencies: ["LifeDomain", "LifeData", "LifeAnalysis"],
                          path: "LifeCrossroads/CLI"),
        .testTarget(name: "LifeDomainTests", dependencies: ["LifeDomain", "LifeData"],
                    path: "Tests/LifeDomainTests"),
        .testTarget(name: "LifePersistenceTests", dependencies: ["LifePersistence", "LifeDomain", "LifeData"],
                    path: "Tests/LifePersistenceTests"),
        .testTarget(name: "LifeAnalysisTests", dependencies: ["LifeAnalysis", "LifeDomain", "LifeData"],
                    path: "Tests/LifeAnalysisTests"),
        .testTarget(name: "LifePresentationTests", dependencies: ["LifePresentation", "LifeDomain", "LifeData", "LifePersistence"],
                    path: "Tests/LifePresentationTests")
    ]
)
