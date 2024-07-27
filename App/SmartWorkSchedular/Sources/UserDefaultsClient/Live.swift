import Foundation
import Dependencies

private enum Keys {
    static let isTutorialComplete = "isTutorialComplete"
}

// MARK: - Live Implementation
extension UserDefaultsClient {
    public static func live(userDefaults: UserDefaults, jsonDecoder: JSONDecoder,jsonEncoder: JSONEncoder) -> Self {
        UserDefaultsClient(
            isTutorialComplete: { 
                userDefaults.bool(forKey: Keys.isTutorialComplete)
            },
            tutorialCompleted: {
                userDefaults.set(true, forKey: Keys.isTutorialComplete)
            }
        )
    }
}
