import Foundation
import SharedModels
import SharedUIs

extension NotificationTimeOption {
    var title: String {
        switch self {
        case .none:
            return #localized("None")
            
        case .atTimeOfEvent:
            return #localized("At time of event")
            
        case .fiveMinutesBefore:
            return #localized("5 minutes before")
            
        case .fifteenMinutesBefore:
            return #localized("15 minutes before")
            
        case .thirtyMinutesBefore:
            return #localized("20 minutes before")
            
        case .oneHourBefore:
            return #localized("1 hour before")
            
        case .twoHoursBefore:
            return #localized("2 hours before")
            
        case .fourHoursBefore:
            return #localized("4 hours before")
            
        case .oneDayBefore:
            return #localized("1 day before")
            
        case .oneWeekBefore:
            return #localized("1 week before")
        }
    }
}
