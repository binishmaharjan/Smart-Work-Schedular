import Dependencies
import Foundation

private enum Keys {
    static let isTutorialComplete = "isTutorialComplete"
}

// MARK: Dependency (liveValue)
extension UserDefaultsClient: DependencyKey {
    public static let liveValue = Self.live(userDefaults: .standard)
}

// MARK: - Live Implementation
extension UserDefaultsClient {
    public static func live(userDefaults: UserDefaults) -> Self {
        UserDefaultsClient(
            isTutorialComplete: { 
                // TODO: For now return true
                // implement when the tutorial view is implemented
                // userDefaults.bool(forKey: Keys.isTutorialComplete)
                true
            },
            tutorialCompleted: {
                userDefaults.set(true, forKey: Keys.isTutorialComplete)
            }
        )
    }
}
