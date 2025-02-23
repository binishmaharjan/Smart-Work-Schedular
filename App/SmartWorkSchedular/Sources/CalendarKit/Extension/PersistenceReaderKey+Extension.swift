import ComposableArchitecture
import Foundation

// MARK: AppStorage Key
extension AppStorageKey where Value == DisplayMode {
    public static var displayMode: Self = .appStorage("displayMode")
}

extension AppStorageKey where Value == Weekday {
    public static var startOfWeekday: Self = .appStorage("startOfWeekday")
}

// MARK: Persistence Key
extension SharedReaderKey where Self == AppStorageKey<DisplayMode> {
    public static var ud_displayMode: Self { AppStorageKey.displayMode }
}

extension SharedReaderKey where Self == AppStorageKey<Weekday> {
    public static var ud_startOfWeekday: Self { AppStorageKey.startOfWeekday }
}

extension SharedReaderKey where Self == InMemoryKey<Day> {
    public static var mem_currentSelectedDay: Self { inMemory("currentSelectedDay") }
}
