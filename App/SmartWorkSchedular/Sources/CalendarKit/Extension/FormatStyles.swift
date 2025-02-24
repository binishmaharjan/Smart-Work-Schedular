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
    // returns day from the date
    /// eg: 1, 2, 3
    public struct CalendarDay: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            return formatter.string(from: value.startOfDate)
        }
    }

    // MARK: Weekday Format
    /// returns weekday from the date
    /// eg: Sun, Mon, Tue
    public struct WeekDay: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatter = Date.FormatStyle().weekday()
            return formatter.format(value.startOfDate)
        }
    }
    
    // MARK: Month Format
    /// returns month and year from the date
    /// eg: Oct, 2024
    public struct MonthAndYear: FormatStyle {
        public func format(_ value: Date) -> String {
            let formatter = Date.FormatStyle().month().year()
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

extension FormatStyle where Self == DateFormatStyle.MonthAndYear {
    /// Format Style to display weekdays
    public static var monthAndYear: DateFormatStyle.MonthAndYear { .init() }
}
