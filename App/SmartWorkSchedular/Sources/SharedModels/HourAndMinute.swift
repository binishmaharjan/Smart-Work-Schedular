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
    public var description: String {
        "\(hour.formatted(.twoDigit)):\(minute.formatted(.twoDigit))"
    }
}
