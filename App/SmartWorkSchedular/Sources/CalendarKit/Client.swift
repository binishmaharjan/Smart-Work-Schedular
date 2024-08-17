import Foundation
import Dependencies

public struct CalendarKitClient {
    /// Returns the display days for the calendar according to the current mode
    public var displayDays: (_ from: Day) -> [Day]
    public var nextFocusDay: (_ from: Day) -> Day
    public var previousFocusDay: (_ from: Day) -> Day
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
    public static var testValue = CalendarKitClient(
        displayDays: unimplemented("\(Self.self).displayDays is unimplemented", placeholder: []),
        nextFocusDay: unimplemented("\(Self.self).nextFocusDay is unimplemented", placeholder: Day(date: .now)),
        previousFocusDay: unimplemented("\(Self.self).previousFocusDay is unimplemented", placeholder: Day(date: .now))
    )
    
    public static var previewValue = CalendarKitClient(
        displayDays: unimplemented("\(Self.self).displayDays is unimplemented", placeholder: []),
        nextFocusDay: unimplemented("\(Self.self).nextFocusDay is unimplemented", placeholder: Day(date: .now)),
        previousFocusDay: unimplemented("\(Self.self).previousFocusDay is unimplemented", placeholder: Day(date: .now))
    )
}
