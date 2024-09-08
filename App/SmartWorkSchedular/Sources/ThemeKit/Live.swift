import Foundation
import Dependencies
import SwiftUI
import ComposableArchitecture
import LoggerClient

// MARK: Dependency (liveValue)
extension ThemeKitClient: DependencyKey {
    public static let liveValue = Self.live()
}

// MARK: - Live Implementation
extension ThemeKitClient {
    public static func live() -> ThemeKitClient {
        // MARK: Shared Properties
        @Shared(.appScheme) var apperance = AppScheme.system
        // MARK: Dependicies
        @Dependency(\.loggerClient) var logger
        
        return ThemeKitClient(
            updateAppearance: { mode in
                logger.debug("updateAppearance(to:) - \(mode)")
                apperance = mode
            }
        )
    }
}
