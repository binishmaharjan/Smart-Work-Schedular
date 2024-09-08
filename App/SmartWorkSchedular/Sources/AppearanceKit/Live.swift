import Foundation
import Dependencies
import SwiftUI
import ComposableArchitecture
import LoggerClient

// MARK: Dependency (liveValue)
extension AppearanceKitClient: DependencyKey {
    public static let liveValue = Self.live()
}

// MARK: - Live Implementation
extension AppearanceKitClient {
    public static func live() -> AppearanceKitClient {
        // MARK: Shared Properties
        @Shared(.appearanceMode) var apperance = AppearanceMode.system
        // MARK: Dependicies
        @Dependency(\.loggerClient) var logger
        
        return AppearanceKitClient(
            updateAppearance: { mode in
                logger.debug("updateAppearance(to:) - \(mode)")
                apperance = mode
            }
        )
    }
}
