// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LifeCrossroads",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "LifeDomain", targets: ["LifeDomain"]),
        .library(name: "LifeData", targets: ["LifeData"]),
        .executable(name: "life-demo", targets: ["LifeDemo"])
    ],
    targets: [
        .target(name: "LifeDomain", path: "LifeCrossroads/Domain"),
        .target(name: "LifeData", dependencies: ["LifeDomain"], path: "LifeCrossroads/Data",
                resources: [.copy("Resources")]),
        .executableTarget(name: "LifeDemo", dependencies: ["LifeDomain", "LifeData"],
                          path: "LifeCrossroads/CLI"),
        .testTarget(name: "LifeDomainTests", dependencies: ["LifeDomain", "LifeData"],
                    path: "Tests/LifeDomainTests")
    ]
)
