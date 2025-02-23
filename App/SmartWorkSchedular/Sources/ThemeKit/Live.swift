import ComposableArchitecture
import Dependencies
import Foundation
import LoggerClient
import SwiftUI

// MARK: Dependency (liveValue)
extension ThemeKitClient: DependencyKey {
    public static let liveValue = Self.live()
}

// MARK: - Live Implementation
extension ThemeKitClient {
    public static func live() -> ThemeKitClient {
        // MARK: Shared Properties
        @Shared(.appScheme) var appScheme = AppScheme.system
        // MARK: Dependenicies
        @Dependency(\.loggerClient) var logger
        
        return ThemeKitClient(
            updateAppScheme: { newAppScheme in
                logger.debug("updateAppearance(to:) - \(newAppScheme)")
                $appScheme.withLock { $0 = newAppScheme }
                changeAppScheme(to: appScheme)
            },
            applyInitialAppScheme: {
                logger.debug("applyInitialAppScheme(to:) - \(appScheme)")
                changeAppScheme(to: appScheme)
            }
        )
    }
    
    private static func changeAppScheme(to appScheme: AppScheme) {
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
}
