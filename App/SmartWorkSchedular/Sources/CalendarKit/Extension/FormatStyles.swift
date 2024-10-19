import Foundation

// MARK: Date Identifier Format
public struct DateIdentifierFormat: FormatStyle {
    public func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = false
        formatter.timeStyle = .short
        formatter.dateStyle = .full
        return formatter.string(from: value.startOfDate)
    }
}

extension FormatStyle where Self == DateIdentifierFormat {
    /// Format Style for date as identifier
    public static var dateIdentifier: DateIdentifierFormat { .init() }
}

// MARK: Day Format
public struct CalendarDayFormat: FormatStyle {
    public func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat =  "d"
        return formatter.string(from: value.startOfDate)
    }
}

extension FormatStyle where Self == CalendarDayFormat {
    /// Format Style to display day in calendar
    public static var calendarDay: CalendarDayFormat { .init() }
}

// MARK: Weekday Format
public struct WeekDayFormat: FormatStyle {
    public func format(_ value: Date) -> String {
        let formatter = Date.FormatStyle().weekday()
        return formatter.format(value.startOfDate)
    }
}

extension FormatStyle where Self == WeekDayFormat {
    /// Format Style to display weekdays
    public static var weekday: WeekDayFormat { .init() }
}
