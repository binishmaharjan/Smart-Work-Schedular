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
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "TutorialFeature", targets: ["TutorialFeature"]),
        .library(name: "MainTabFeature", targets: ["MainTabFeature"]),
        .library(name: "ScheduleFeature", targets: ["ScheduleFeature"]),
        .library(name: "TemplatesFeature", targets: ["TemplatesFeature"]),
        .library(name: "EarningsFeature", targets: ["EarningsFeature"]),
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
        .library(name: "ColorPaletteFeature", targets: ["ColorPaletteFeature"]),
        .library(name: "NavigationBarFeature", targets: ["NavigationBarFeature"]),
        .library(name: "CalendarKit", targets: ["CalendarKit"]),
        .library(name: "ThemeKit", targets: ["ThemeKit"]),
        .library(name: "LocationKit", targets: ["LocationKit"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "LoggerClient", targets: ["LoggerClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.17.1"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.58.2"),
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
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "SharedUIs",
            dependencies: [
                "SharedModels",
                "AppMacros",
                "LoggerClient",
            ],
            resources: [
                .process("Resources"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
                .plugin(name: "AssetGenPlugin")
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                "AppMacros",
                "LoggerClient",
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "TutorialFeature",
            dependencies: [
                "SharedUIs",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "ScheduleFeature",
            dependencies: [
                "SharedUIs",
                "SharedModels",
                "CalendarKit",
                "LoggerClient",
                "SettingsFeature",
                "NavigationBarFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "TemplatesFeature",
            dependencies: [
                "SharedUIs",
                "SharedModels",
                "LoggerClient",
                "LocationKit",
                "ColorPaletteFeature",
                "NavigationBarFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "EarningsFeature",
            dependencies: [
                "SharedUIs",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "ColorPaletteFeature",
            dependencies: [
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "NavigationBarFeature",
            dependencies: [
                "SharedUIs",
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "CalendarKit",
            dependencies: [
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "ThemeKit",
            dependencies: [
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "LocationKit",
            dependencies: [
                "LoggerClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "LoggerClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .plugin(
            name: "AssetGenPlugin",
            capability: .buildTool()
        ),
        .macro(
            name: "AppMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
