import Foundation

public struct HourAndMinute: Equatable {
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    public var hour: Int
    public var minute: Int
}

// MARK: Description
extension HourAndMinute: CustomStringConvertible {
    /// Format: 00:00
    public var description: String {
        "\(hour.formatted(.twoDigit)):\(minute.formatted(.twoDigit))"
    }
    
    /// Format: 0 hr 0 min
    public var timeDescription: String {
        "\(hour) hr \(minute) min"
    }
}

// MARK: Empty
extension HourAndMinute {
    /// Predefined HourAndMinute: hour = 0, minute = 0
    public static let empty = HourAndMinute(hour: 0, minute: 0)
    public var isEmpty: Bool {
        hour == 0 && minute == 0
    }
}
