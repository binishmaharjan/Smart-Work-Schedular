import Foundation

public enum NotificationTimeOption: String, CaseIterable, Identifiable {
    case none
    case atTimeOfEvent
    case fiveMinutesBefore
    case fifteenMinutesBefore
    case thirtyMinutesBefore
    case oneHourBefore
    case twoHoursBefore
    case fourHoursBefore
    case oneDayBefore
    case oneWeekBefore
    
    public var id: String { rawValue }
}
