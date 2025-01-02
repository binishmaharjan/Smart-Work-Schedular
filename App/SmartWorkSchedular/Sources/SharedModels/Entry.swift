import Foundation

public enum EntryType {
    case shift
    case event
}

public struct Entry: Identifiable {
    public var id: UUID
    public var title: String
    public var icon: String
    public var isAllDay: Bool
    public var startDate: Date
    public var endDate: Date
    public var breakTime: Int
    public var notes: String
    public var location: String
    public var entryType: EntryType
    public var wagePerHour: Double
    public var creationDate: Date
}
