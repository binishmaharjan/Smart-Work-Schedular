// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmartWorkSchedular",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v12)],
    products: [
        .library(name: "SmartWorkSchedular", targets: ["SmartWorkSchedular"]),
        .library(name: "SharedUIs", targets: ["SharedUIs"]),
    ],
    targets: [
        .target(
            name: "SmartWorkSchedular"
        ),
        .target(
            name: "SharedUIs",
            dependencies: [
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "SmartWorkSchedularTests",
            dependencies: [
                "SmartWorkSchedular"
            ]
        ),
    ]
)
