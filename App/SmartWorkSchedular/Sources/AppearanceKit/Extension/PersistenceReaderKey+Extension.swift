import Foundation
import ComposableArchitecture

// MARK: AppStorage Key
extension AppStorageKey where Value == AppearanceMode {
    public static var appearanceMode: Self = .appStorage("appearanceMode")
}

// MARK: Persistance Key
extension PersistenceReaderKey where Self == AppStorageKey<AppearanceMode> {
    public static var appearanceMode: Self { AppStorageKey.appearanceMode }
}

