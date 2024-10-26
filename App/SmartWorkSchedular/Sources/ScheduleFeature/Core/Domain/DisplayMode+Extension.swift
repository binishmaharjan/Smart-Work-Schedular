import Foundation
import CalendarKit

extension DisplayMode {
    var image: String {
        switch self {
        case .month:
            return "m.square"
            
        case .week:
            return "w.square"
            
        case .day:
            return "d.square"
        }
    }
}
