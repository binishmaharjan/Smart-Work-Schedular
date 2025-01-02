import CalendarKit
import ComposableArchitecture
import SharedUIs
import SwiftUI

@ViewAction(for: WeekSchedule.self)
public struct WeekScheduleView: View {
    public init(store: StoreOf<WeekSchedule>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<WeekSchedule>
    @State private var needsToCreateNewDays = false
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    public var body: some View {
        VStack {
            weekCalendar
                .frame(height: 75)
            
            hSeparator()
                
            VStack {
                Text("\(store.currentSelectedDay.formatted(.dateIdentifier))")
                    .font(.customHeadline)
                    .foregroundStyle(#color("sub_text_color"))
            }
            .vSpacing(.center)
        }
        .onAppear { send(.onAppear) }
        .onChange(of: store.currentPage, initial: false) { _, newValue in
            // create week if the page reaches first/last page
            if newValue == 0 || newValue == (store.weekCalendar.count - 1) {
                needsToCreateNewDays = true
            }
        }
    }
}

// MARK: Views
extension WeekScheduleView {    
    @ViewBuilder
    private var weekCalendar: some View {
        TabView(selection: $store.currentPage) {
            ForEach(
                Array(store.scope(state: \.weekCalendar, action: \.weekCalendar).enumerated()),
                id: \.element.id
            ) { index, store in
                WeekCalendarView(store: store)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(index)
                    .background {
                        GeometryReader { proxy in
                            let minX = proxy.frame(in: .global).minX
                            
                            Color.clear
                                .preference(key: OffsetPreferenceKey.self, value: minX)
                                .onPreferenceChange(OffsetPreferenceKey.self) { value in
                                    // when offset reaches 0 and if createWeek is toggled  then
                                    // simply generate next set of dates
                                    if value == 0 && needsToCreateNewDays {
                                        send(.scrollEndReached)
                                        needsToCreateNewDays = false
                                    }
                                }
                        }
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    WeekScheduleView(
        store: .init(
            initialState: .init(originDay: Day(date: .now)),
            reducer: WeekSchedule.init
        )
    )
}
