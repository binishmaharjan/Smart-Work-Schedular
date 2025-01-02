import Foundation

public enum EntriesType {
    case shift
    case event
}

public struct Entries {
    public var id: UUID
    public var title: String
    public var icon: String
    public var isAllDay: Bool
    public var startDate: Date
    public var endDate: Date
    public var breakTime: Int
    public var notes: String
    public var location: String
    public var entriesType: EntriesType
    public var wagePerHour: Double
}
