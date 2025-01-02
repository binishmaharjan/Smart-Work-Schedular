//
//  Created by マハルジャン ビニシュ on 2024/12/31.
//

import Foundation

public enum EventType {
    case shift
    case event
}

public struct Event {
    public var id: UUID
    public var title: String
    public var icon: String
    public var isAllDay: Bool
    public var startDate: Date
    public var endDate: Date
    public var breakTime: Int
    public var notes: String
    public var location: String
}
