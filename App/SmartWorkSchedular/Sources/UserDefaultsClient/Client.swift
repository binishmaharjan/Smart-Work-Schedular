import Foundation
import Dependencies

public struct UserDefaultsClient {
    /// Get is tutorial complete
    public var isTutorialComplete: () -> Bool
    public var tutorialCompleted:  () -> Void
}

// MARK: DependencyValues
extension DependencyValues {
    public var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension UserDefaultsClient: TestDependencyKey {
    public static let testValue = UserDefaultsClient(
        isTutorialComplete: unimplemented("\(Self.self).isTutorialComplete is unimplemented", placeholder: false),
        tutorialCompleted: unimplemented("\(Self.self).tutorialCompleted is unimplemented", placeholder: ())
    )

    public static let previewValue = UserDefaultsClient(
        isTutorialComplete: unimplemented("\(Self.self).isTutorialComplete is unimplemented", placeholder: false),
        tutorialCompleted: unimplemented("\(Self.self).tutorialCompleted is unimplemented", placeholder: ())
    )
}
