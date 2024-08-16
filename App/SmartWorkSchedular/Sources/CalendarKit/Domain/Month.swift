import Foundation

public struct Month: Identifiable {
    public init(weeks: [Week]) {
        self.weeks = weeks
    }
    
    public var id: UUID = UUID()
    public var weeks: [Week]
}

extension Month: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.weeks == rhs.weeks
    }
}
