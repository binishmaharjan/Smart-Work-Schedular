import Foundation
import Dependencies
import SwiftUI
import ComposableArchitecture

// MARK: Dependency (liveValue)
extension AppearanceKitClient: DependencyKey {
    public static let liveValue = Self.live()
}

// MARK: - Live Implementation
extension AppearanceKitClient {
    public static func live() -> AppearanceKitClient {
        @Shared(.appearanceMode) var apperance = AppearanceMode.system
        
        return AppearanceKitClient(
            updateAppearance: { mode in
                apperance = mode
            }
        )
    }
}
