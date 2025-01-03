import CalendarKit
import ComposableArchitecture
import SharedUIs
import SwiftUI

@ViewAction(for: WeekCalendar.self)
public struct WeekCalendarView: View {
    public init(store: StoreOf<WeekCalendar>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<WeekCalendar>
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(store.displayDays) { day in
                VStack(spacing: 4) {
                    Text(day.formatted(.weekday))
                        .font(.customSubheadline)
                        .foregroundStyle(Color.text)
                    
                    Text(day.formatted(.calendarDay))
                        .font(.customSubheadline)
                        .foregroundStyle(
                            day.isSameDay(as: store.currentSelectedDay) ? Color.background : Color.text
                        )
                        .frame(width: 35, height: 35)
                        .background {
                            if day.isSameDay(as: store.currentSelectedDay) {
                                RoundedRectangle(cornerRadius: 8).fill(Color.accent)
                            }
                            
                            if day.isToday {
                                todayIndicator()
                                    .vSpacing(.bottom)
                                    .offset(y: 8)
                            }
                        }
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    send(.daySelected(day), animation: .snappy)
                }
            }
        }
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
