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
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
        .library(name: "NavigationBarFeature", targets: ["NavigationBarFeature"]),
        .library(name: "CalendarKit", targets: ["CalendarKit"]),
        .library(name: "ThemeKit", targets: ["ThemeKit"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "LoggerClient", targets: ["LoggerClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.14.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "510.0.2"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.57.0"),
    ],
    targets: [
        .target(
            name: "SmartWorkSchedular",
            dependencies: [
                "AppFeature",
                "LoggerClient",
                "SharedUIs",
                "ThemeKit",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
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
                "CalendarKit",
                "LoggerClient",
                "SettingsFeature",
                "NavigationBarFeature",
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
            name: "SettingsFeature",
            dependencies: [
                "LoggerClient",
                "NavigationBarFeature",
                "CalendarKit",
                "ThemeKit",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "NavigationBarFeature",
            dependencies: [
                "SharedUIs",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "CalendarKit",
            dependencies: [
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ThemeKit",
            dependencies: [
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
