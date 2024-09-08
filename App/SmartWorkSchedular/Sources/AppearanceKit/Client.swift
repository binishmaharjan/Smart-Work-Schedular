import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct AppearanceKitClient {
    public var updateAppearance: (_ to: AppearanceMode) -> Void
}

// MARK: Dependency Values
extension DependencyValues {
    public var appearanceKitClient: AppearanceKitClient {
        get { self[AppearanceKitClient.self] }
        set { self[AppearanceKitClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension AppearanceKitClient: TestDependencyKey {
    public static var testValue = Self()
    public static var previewValue = Self.noop
}

extension AppearanceKitClient {
    public static let noop = Self(
        updateAppearance: { _ in }
    )
}
