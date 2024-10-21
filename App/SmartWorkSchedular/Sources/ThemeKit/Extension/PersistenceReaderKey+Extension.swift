import Foundation
import ComposableArchitecture

// MARK: AppStorage Key
extension AppStorageKey where Value == AppScheme {
    public static var appScheme: Self = .appStorage("appScheme")
}

// MARK: Persistance Key
extension PersistenceReaderKey where Self == AppStorageKey<AppScheme> {
    public static var appScheme: Self { AppStorageKey.appScheme }
}

