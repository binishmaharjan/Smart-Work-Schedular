import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct CalendarKitClient {
    /// Returns the display days for the calendar according to the current mode
    public var displayDays: (_ from: Day) -> [Day] = { _ in [] }
    public var nextFocusDay: (_ from: Day) -> Day = { _ in .init(date: .now) }
    public var previousFocusDay: (_ from: Day) -> Day = { _ in .init(date: .now) }
    public var updateStartWeekdayOn: (_ to: Weekday) -> Void
    public var weekDays: () -> [String] = { [] }
}

// MARK: Dependency Values
extension DependencyValues {
    public var calendarKitClient: CalendarKitClient {
        get { self[CalendarKitClient.self] }
        set { self[CalendarKitClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension CalendarKitClient: TestDependencyKey {
    public static var testValue = Self()
    public static var previewValue = Self.noop
    
    public static var noop = CalendarKitClient(
        displayDays:  { _ in [] },
        nextFocusDay: { _ in .init(date: .now) },
        previousFocusDay: { _ in .init(date: .now) },
        updateStartWeekdayOn: { _ in },
        weekDays: { [] }
    )
}
