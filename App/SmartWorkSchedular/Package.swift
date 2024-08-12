// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SmartWorkSchedular",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v12)],
    products: [
        .library(name: "SmartWorkSchedular", targets: ["SmartWorkSchedular"]),
        .library(name: "SharedUIs", targets: ["SharedUIs"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "TutorialFeature", targets: ["TutorialFeature"]),
        .library(name: "MainTabFeature", targets: ["MainTabFeature"]),
        .library(name: "ScheduleFeature", targets: ["ScheduleFeature"]),
        .library(name: "TemplatesFeature", targets: ["TemplatesFeature"]),
        .library(name: "EarningsFeature", targets: ["EarningsFeature"]),
        .library(name: "CalendarFeature", targets: ["CalendarFeature"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "LoggerClient", targets: ["LoggerClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.12.1"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "510.0.2"),
    ],
    targets: [
        .target(
            name: "SmartWorkSchedular",
            dependencies: [
                "AppFeature",
                "LoggerClient",
                "SharedUIs",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "SharedUIs",
            dependencies: [
                "AppMacros",
                "LoggerClient",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "SharedUIs",
                "TutorialFeature",
                "MainTabFeature",
                "UserDefaultsClient",
                "LoggerClient",
            ]
        ),
        .target(
            name: "MainTabFeature",
            dependencies: [
                "SharedUIs",
                "ScheduleFeature",
                "TemplatesFeature",
                "EarningsFeature",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "TutorialFeature",
            dependencies: [
                "SharedUIs",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ScheduleFeature",
            dependencies: [
                "SharedUIs",
                "CalendarFeature",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "TemplatesFeature",
            dependencies: [
                "SharedUIs",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "EarningsFeature",
            dependencies: [
                "SharedUIs",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "CalendarFeature",
            dependencies: [
                "SharedUIs",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "LoggerClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .macro(
            name: "AppMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
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
