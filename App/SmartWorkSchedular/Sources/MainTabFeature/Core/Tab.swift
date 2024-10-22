import Foundation
import SharedUIs
import SwiftUI

public enum Tab {
    case schedule
    case templates
    case earnings
    
    public var title: String {
        switch self {
        case .schedule: 
            return #localized("Schedule")
            
        case .templates:
            return #localized("Templates")
            
        case .earnings:
            return #localized("Earnings")
        }
    }
    
    public var icon: String {
        switch self {
        case .schedule: 
            return "calendar"
            
        case .templates:
            return "list.star"
            
        case .earnings:
            return "chart.bar.xaxis"
        }
    }
}
