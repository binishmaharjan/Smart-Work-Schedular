import Foundation

public struct Week: Identifiable {
    public init(days: [Day]) {
        self.days = days
    }
    
    public var id: UUID = UUID()
    public var hashValue: Int { Int(firstDayOfWeek.date.timeIntervalSinceNow) }
    public var days: [Day]
}

extension Week: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.days == rhs.days
    }
}

// MARK: Helper
extension Week {
    /// Returns the first day of the week
    public var firstDayOfWeek: Day {
        guard let day = days.first else { return Day(date: .now) }
        return day
    }
    
    /// Determines if the given date is in same week
    public func hasDay(_ day: Day) -> Bool {
        days.contains(day)
    }
}
