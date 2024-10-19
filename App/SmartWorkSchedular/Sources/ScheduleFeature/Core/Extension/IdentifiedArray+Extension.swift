import Foundation
import IdentifiedCollections
import CalendarKit

extension IdentifiedArray where Element == Day {
    /// Returns the list of weekday title
    public var weekdays: [String] {
        // check if there are atleast 7 days
        guard count > 7 else { return [] }

        return prefix(7).map(\.date).map { $0.formatted(.weekday) }
    }
}
