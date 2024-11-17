import Foundation

extension Date {
    /// Returns a start of date for self
    /// Note: Use this for proper date calculation
    public var startOfDate: Date {
        gregorianCalendar.startOfDay(for: self)
    }
    
    /// Determines if the self is today
    public var isToday: Bool {
        gregorianCalendar.isDateInToday(self)
    }
    
    /// Determines if the self is tomorrow
    public var isTomorrow: Bool {
        gregorianCalendar.isDateInTomorrow(self)
    }
    
    /// Determines if the date is in this year
    public var isInThisYear: Bool {
        isEqual(to: .now, toGranularity: .year, in: gregorianCalendar)
    }
            
    /// Determines if the date is in this month
    public var isInThisMonth: Bool {
        isEqual(to: .now, toGranularity: .month, in: gregorianCalendar)
    }
    
    /// Determines if the date is in same week
    public var isInThisWeek: Bool {
        isEqual(to: .now, toGranularity: .weekOfYear, in: gregorianCalendar)
    }
    
    /// Determines if the self is yesterday
    public var isYesterDay: Bool {
        gregorianCalendar.isDateInYesterday(self)
    }
    
    // Returns the date of next day
    public var nextDate: Date {
        guard let nextDate = gregorianCalendar.date(byAdding: .day, value: 1, to: self) else {
            return self
        }
        return nextDate
    }
    
    // Returns the date of previous day
    public var previousDate: Date {
        guard let previousDate = gregorianCalendar.date(byAdding: .day, value: -1, to: self) else {
            return self
        }
        return previousDate
    }
    
    // Returns the date of same weekDate from next week
    public var nextWeeDate: Date {
        guard let nextWeekDate = gregorianCalendar.date(byAdding: .weekOfMonth, value: 1, to: self) else {
            return self
        }
        return nextWeekDate
    }
    
    // Returns the date of same weekDate from previous week
    public var previousWeekDate: Date {
        guard let previousWeekDate = gregorianCalendar.date(byAdding: .weekOfMonth, value: -1, to: self) else {
            return self
        }
        return previousWeekDate
    }
    
    // Returns the date of same date from next month
    public var nextMonthDate: Date {
        guard let nextWeekDate = gregorianCalendar.date(byAdding: .month, value: 1, to: self) else {
            return self
        }
        return nextWeekDate
    }
    
    // Returns the date of same date from next month
    public var previousMonthDate: Date {
        guard let nextWeekDate = gregorianCalendar.date(byAdding: .month, value: -1, to: self) else {
            return self
        }
        return nextWeekDate
    }
    
    /// Determines if the give date is same as self
    public func isSameDate(as date: Date) -> Bool {
        gregorianCalendar.isDate(self, inSameDayAs: date)
    }
    
    /// Determines if the date is in same year as the date
    public func isInSameYear(as date: Date) -> Bool {
        isEqual(to: date, toGranularity: .year, in: gregorianCalendar)
    }
    
    /// Determines if the date is in same week as the date
    public func isInSameWeek(as date: Date) -> Bool {
        isEqual(to: date, toGranularity: .weekOfYear, in: gregorianCalendar)
    }
    
    /// Determines if the date is in same month as the date
    public func isInSameMonth(as date: Date) -> Bool {
        isEqual(to: date, toGranularity: .month, in: gregorianCalendar)
    }
}

// MARK: Helper
extension Date {
    private func isEqual(
        to date: Date,
        toGranularity component: Calendar.Component,
        in calendar: Calendar = .current
    ) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
}
