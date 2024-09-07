import Foundation
import ComposableArchitecture

// MARK: The Main Calendar instance
var gegorianCalendar: Calendar = {
  var calendar = Calendar(identifier: .gregorian)
    calendar.firstWeekday = 1
    return calendar
}()

// MARK: Dependency (liveValue)
extension CalendarKitClient: DependencyKey {
    public static let liveValue = Self.live()
}

extension CalendarKitClient {
    public static func live() -> CalendarKitClient {
        
        // MARK: Shared Properties
        @Shared(.appStorage("sharedStateDisplayMode")) var displayMode = DisplayMode.month
        @Shared(.appStorage("sharedStateStartOfWeekday")) var startOfWeekday = Weekday.sunday
        
//        // TODO: Update the calendar if it has changed
//        // Find the way to update when startOfWeekday changes
//        if gegorianCalendar.firstWeekday != startOfWeekday.rawValue {
//            gegorianCalendar.firstWeekday = startOfWeekday.rawValue
//        }
        
        return CalendarKitClient(
            displayDays: { focusDay in
                switch displayMode {
                case .day:
                    return [focusDay]
                case .week:
                    return focusDay.daysInWeek.days
                case .month:
                    return focusDay.daysInMonth.weeks.flatMap(\.days)
                }
            },
            nextFocusDay: { currentFocusDay in
                switch displayMode {
                case .month:
                    return currentFocusDay.nextMonthDay
                case .week:
                    return currentFocusDay.nextWeekDay
                case .day:
                    return currentFocusDay.nextDay
                }
            },
            previousFocusDay: { currentFocusDay in
                switch displayMode {
                case .month:
                    return currentFocusDay.previousMonthDay
                case .week:
                    return currentFocusDay.previousWeekDay
                case .day:
                    return currentFocusDay.previousDay
                }
            }
        )
    }
}

public enum DisplayMode: String, RawRepresentable, CaseIterable, Identifiable {
    case month
    case week
    case day
    
    public var id: Self { self }
    
    public var name: String { rawValue.capitalized }
}

extension PersistenceReaderKey where Self == AppStorageKey<Int> {
    public static var displayMode: AppStorageKey<Int> {
        appStorage("sharedStateDisplayMode")
    }
    
    public static var startOfWeekday: AppStorageKey<Int> {
        appStorage("sharedStateStartOfWeekday")
    }
}
