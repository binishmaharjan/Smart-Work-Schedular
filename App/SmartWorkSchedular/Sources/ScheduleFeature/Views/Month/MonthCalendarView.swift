import CalendarKit
import ComposableArchitecture
import SharedUIs
import SwiftUI

@ViewAction(for: MonthCalendar.self)
public struct MonthCalendarView: View {
    public init(store: StoreOf<MonthCalendar>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<MonthCalendar>
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                monthItemList(calendarHeight: proxy.size.height)
            }
        }
    }
}

// MARK: Views
extension MonthCalendarView {
    @ViewBuilder
    private func monthItemList(calendarHeight: CGFloat) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(store.displayDays) { day in
                monthItem(
                    for: day,
                    height: calendarHeight / CGFloat(store.numberOfWeeks)
                )
                .onTapGesture {
                    send(.daySelected(day))
                }
            }
        }
    }
    
    @ViewBuilder
    private func monthItem(for day: Day, height: CGFloat) -> some View {
        MonthItemView(originDay: store.originDay, day: day)
            .frame(height: height)
    }
}

#Preview {
    MonthCalendarView(
        store: .init(
            initialState: .init(originDay: Day(date: .now), displayDays: []),
            reducer: MonthCalendar.init
        )
    )
}
