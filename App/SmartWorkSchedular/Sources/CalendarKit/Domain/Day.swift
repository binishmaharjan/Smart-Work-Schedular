import Foundation

public struct Day: Identifiable, Equatable {
    public init(date: Date) {
        self.date = date.startOfDate
    }
    
    public var id: String { date.formatted(.dateIdentifier) }
    public var date: Date
}

// MARK: Helpers
extension Day {
    /// Returns a start of date for self
    /// Note: Use this for proper date calculation
    public var startOfDay: Day {
        Day(date: date.startOfDate)
    }
    
    /// Determines if the self is today
    public var isToday: Bool {
        date.isToday
    }
    
    /// Determines if the give date is same as self
    public func isSameDay(as day: Day) -> Bool {
        date.isSameDate(as: day.date)
    }
    
    /// Determines if the self is tomorrow
    public var isTomorrow: Bool {
        date.isTomorrow
    }
    
    /// Determines if the self is yesterday
    public var isYesterDay: Bool {
        date.isYesterDay
    }
    
    // Returns next day
    public var nextDay: Day {
        Day(date: date.nextDate)
    }
    
    // Returns previous day
    public var previousDay: Day {
        Day(date: date.previousDate)
    }
    
    /// Returns the date of same weekDate from next week
    public var nextWeekDay: Day {
        Day(date: date.nextWeeDate)
    }
    
    /// Returns the date of same weekDate from previous week
    public var previousWeekDay: Day {
        Day(date: date.previousWeekDate)
    }
    
    /// Returns the date of same date from next month
    public var nextMonthDay: Day {
        Day(date: date.nextMonthDate)
    }
    
    /// Returns the date of same date from next month
    public var previousMonthDay: Day {
        Day(date: date.previousMonthDate)
    }
    
    /// Returns the date as formatted string
    public func formatted<F>(_ format: F) -> F.FormatOutput where F : FormatStyle, F.FormatInput == Date , F.FormatOutput == String {
        return date.formatted(format)
    }
}

// MARK: Week
extension Day {
    /// Returns all days in the week
    public var daysInWeek: Week {
        var days: [Day] = []
        let weekInterval = gegorianCalendar.dateInterval(of: .weekOfMonth, for: date)
        guard let startOfWeek = weekInterval?.start else {
            return Week(days: [])
        }
        
        (0..<7) .forEach { index in
            if let day = gegorianCalendar.date(byAdding: .day, value: index, to: startOfWeek) {
                days.append(Day(date: day))
            }
        }
        
        return Week(days: days)
    }
}

// MARK: Month
extension Day {
    /// Returns all days in the month
    public var daysInMonth: Month {
        var weeks: [Week] = []
        // get start date of the month
        let monthInterval = gegorianCalendar.dateInterval(of: .month, for: date)
        guard let startOfMonth = monthInterval?.start else {
            return Month(weeks: [])
        }
        // get the end date of the month
        let nextMonthInterval = gegorianCalendar.dateInterval(of: .month, for: date.nextMonthDate)
        guard let startOfNextmonth = nextMonthInterval?.start else {
            return Month(weeks: [])
        }
        let endOfMonth = startOfNextmonth.previousDate
        
        // add current week
        let currentWeek = daysInWeek
        weeks.append(currentWeek)
        
        // add past week for same month
        while true {
            // get the first week in the current array
            guard let first = weeks.first else { break }
            // check if the first week has the start of month, then stop adding past week
            if first.hasDay(Day(date: startOfMonth.startOfDate)) { break }
            // insert the week for the previous week day
            weeks.insert(first.firstDayOfWeek.previousWeekDay.daysInWeek, at: 0)
        }
        
        // add future week for same month
        while true {
            // get the last week in the current array
            guard let last = weeks.last else { break }
            // check if the last week has the end of month, then stop adding future week
            if last.hasDay(Day(date: endOfMonth.startOfDate)) { break }
            // insert the week for the next week day
            weeks.append(last.firstDayOfWeek.nextWeekDay.daysInWeek)
        }
        
        return Month(weeks: weeks)
    }
}
