import Foundation

// MARK: Date Identifier Format
public enum DateFormatStyle {
    public struct DateIdentifier: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatter = DateFormatter()
            formatter.doesRelativeDateFormatting = false
            formatter.timeStyle = .short
            formatter.dateStyle = .full
            return formatter.string(from: value.startOfDate)
        }
    }

    // MARK: Day Format
    public struct CalendarDay: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM,d"
            return formatter.string(from: value.startOfDate)
        }
    }

    // MARK: Weekday Format
    public struct WeekDay: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatter = Date.FormatStyle().weekday()
            return formatter.format(value.startOfDate)
        }
    }
}

extension FormatStyle where Self == DateFormatStyle.DateIdentifier {
    /// Format Style for date as identifier
    public static var dateIdentifier: DateFormatStyle.DateIdentifier { .init() }
}

extension FormatStyle where Self == DateFormatStyle.CalendarDay {
    /// Format Style to display day in calendar
    public static var calendarDay: DateFormatStyle.CalendarDay { .init() }
}

extension FormatStyle where Self == DateFormatStyle.WeekDay {
    /// Format Style to display weekdays
    public static var weekday: DateFormatStyle.WeekDay { .init() }
}
