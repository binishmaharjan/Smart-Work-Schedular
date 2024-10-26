import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct ThemeKitClient {
    public var updateAppScheme: (_ to: AppScheme) -> Void
    public var applyInitialAppScheme: () -> Void
}

// MARK: Dependency Values
extension DependencyValues {
    public var themeKitClient: ThemeKitClient {
        get { self[ThemeKitClient.self] }
        set { self[ThemeKitClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension ThemeKitClient: TestDependencyKey {
    public static var testValue = Self()
    public static var previewValue = Self.noop
}

extension ThemeKitClient {
    public static let noop = Self(
        updateAppScheme: { _ in },
        applyInitialAppScheme: { }
    )
}
