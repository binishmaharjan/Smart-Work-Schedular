import CalendarKit
import ComposableArchitecture
import SwiftUI

@ViewAction(for: WeekCalendar.self)
public struct WeekCalendarView: View {
    public init(store: StoreOf<WeekCalendar>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<WeekCalendar>
    
    public var body: some View {
        Text("Hello World")
    }
}

#Preview {
    WeekCalendarView(
        store: .init(
            initialState: .init(originDay: Day(date: .now), displayDays: []),
            reducer: WeekCalendar.init
        )
    )
}
