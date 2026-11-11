// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Trustify",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "SharedEngine", targets: ["SharedEngine"]),
        .executable(name: "TrustifyApp", targets: ["TrustifyApp"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SharedModels",
            path: "Sources/Shared/Models"
        ),
        .target(
            name: "SharedEngine",
            dependencies: ["SharedModels"],
            path: "Sources/Shared/Engine"
        ),
        .executableTarget(
            name: "TrustifyApp",
            dependencies: ["SharedModels", "SharedEngine"],
            path: "Sources/TrustifyApp"
        ),
        .target(
            name: "TrustifyCallDirectory",
            dependencies: ["SharedModels", "SharedEngine"],
            path: "Sources/TrustifyCallDirectory"
        )
    ]
)

