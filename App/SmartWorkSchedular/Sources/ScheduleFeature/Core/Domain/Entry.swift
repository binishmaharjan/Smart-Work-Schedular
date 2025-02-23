import Foundation

public enum EntryType {
    case shift
    case event
}

public struct Entry: Identifiable {
    public init(
        id: UUID,
        title: String,
        icon: String,
        isAllDay: Bool = false,
        startDate: String,
        endDate: String,
        breakTime: Double? = nil,
        notes: String? = nil,
        location: String? = nil,
        entryType: EntryType,
        wagePerHour: Double? = nil,
        creationDate: Date
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.breakTime = breakTime
        self.notes = notes
        self.location = location
        self.entryType = entryType
        self.wagePerHour = wagePerHour
        self.creationDate = creationDate
    }

    public var id: UUID
    public var title: String
    public var icon: String
    public var isAllDay: Bool
    public var startDate: String
    public var endDate: String
    public var breakTime: Double?
    public var notes: String?
    public var location: String?
    public var entryType: EntryType
    public var wagePerHour: Double?
    public var creationDate: Date
}
