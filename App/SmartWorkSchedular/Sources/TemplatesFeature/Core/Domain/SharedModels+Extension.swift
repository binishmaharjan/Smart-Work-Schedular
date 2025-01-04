import Foundation
import SharedModels

extension NotificationTimeOption {
    var title: String {
        switch self {
        case .none:
            return "None"
            
        case .atTimeOfEvent:
            return "At time of event"
            
        case .fiveMinutesBefore:
            return "5 minutes before"
            
        case .fifteenMinutesBefore:
            return "15 minutes before"
            
        case .thirtyMinutesBefore:
            return "20 minutes before"
            
        case .oneHourBefore:
            return "1 hour before"
            
        case .twoHoursBefore:
            return "2 hours before"
            
        case .fourHoursBefore:
            return "4 hours before"
            
        case .oneDayBefore:
            return "1 day before"
            
        case .oneWeekBefore:
            return "1 week before"
        }
    }
}
