import ComposableArchitecture
import Foundation

// MARK: AppStorage Key
extension AppStorageKey where Value == AppScheme {
    public static var appScheme: Self = .appStorage("appScheme")
}

// MARK: Persistance Key
extension SharedReaderKey where Self == AppStorageKey<AppScheme> {
    public static var appScheme: Self { AppStorageKey.appScheme }
}
