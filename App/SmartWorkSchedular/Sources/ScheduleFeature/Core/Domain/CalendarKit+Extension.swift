import CalendarKit
import Foundation

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

extension Day {
    var navigationTitle: String {
        formatted(.monthAndYear)
    }
}
