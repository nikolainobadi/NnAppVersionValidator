// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NnAppVersionValidator",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "NnAppVersionValidator",
            targets: ["NnAppVersionValidator"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NnAppVersionValidator",
            dependencies: []),
        .testTarget(
            name: "NnAppVersionValidatorTests",
            dependencies: ["NnAppVersionValidator"]),
    ]
)
