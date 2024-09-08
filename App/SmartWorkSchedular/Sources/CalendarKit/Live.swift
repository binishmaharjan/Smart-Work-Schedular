import Foundation
import ComposableArchitecture
import LoggerClient

// MARK: The Main Calendar instance
var gegorianCalendar: Calendar = {
    @SharedReader(.startOfWeekday) var startOfWeekday = Weekday.sunday
    
    var calendar = Calendar(identifier: .gregorian)
    calendar.firstWeekday = startOfWeekday.index
    return calendar
}()

// MARK: Dependency (liveValue)
extension CalendarKitClient: DependencyKey {
    public static let liveValue = Self.live()
}

extension CalendarKitClient {
    public static func live() -> CalendarKitClient {
        // MARK: Shared Properties
        @Shared(.displayMode) var displayMode = DisplayMode.month
        @Shared(.startOfWeekday) var startOfWeekday = Weekday.sunday
        // MARK: Dependicies
        @Dependency(\.loggerClient) var logger
        
        return CalendarKitClient(
            displayDays: { focusDay in
                logger.debug("displayDays(from:) | DisplayMode: \(displayMode) | \(focusDay)")
                
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
                logger.debug("nextFocusDay(from:) | DisplayMode: \(displayMode) | \(currentFocusDay)")
                
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
                logger.debug("previousFocusDay(from:) | DisplayMode: \(displayMode) | \(currentFocusDay)")
                
                switch displayMode {
                case .month:
                    return currentFocusDay.previousMonthDay
                case .week:
                    return currentFocusDay.previousWeekDay
                case .day:
                    return currentFocusDay.previousDay
                }
            },
            updateStartWeekdayOn: { weekday in
                logger.debug("updateStartWeekdayOn(to:) - \(weekday)")
                
                startOfWeekday = weekday
                gegorianCalendar.firstWeekday = weekday.index
            }
        )
    }
}
