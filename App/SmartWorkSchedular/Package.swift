// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmartWorkSchedular",
    products: [
        .library(
            name: "SmartWorkSchedular",
            targets: ["SmartWorkSchedular"]
        ),
    ],
    targets: [
        .target(
            name: "SmartWorkSchedular"
        ),
        .testTarget(
            name: "SmartWorkSchedularTests",
            dependencies: [
                "SmartWorkSchedular"
            ]
        ),
    ]
)
