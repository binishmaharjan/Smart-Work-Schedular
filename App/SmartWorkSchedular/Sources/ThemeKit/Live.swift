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
        @Shared(.appScheme) var appScheme = AppScheme.system
        // MARK: Dependicies
        @Dependency(\.loggerClient) var logger
        
        return ThemeKitClient(
            updateAppScheme: { newAppScheme in
                logger.debug("updateAppearance(to:) - \(newAppScheme)")
                appScheme = newAppScheme
                if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
                    if appScheme == .dark {
                        window.overrideUserInterfaceStyle = .dark
                    } else if appScheme == .light {
                        window.overrideUserInterfaceStyle = .light
                    } else {
                        window.overrideUserInterfaceStyle = .unspecified
                    }
                }
            }
        )
    }
}
