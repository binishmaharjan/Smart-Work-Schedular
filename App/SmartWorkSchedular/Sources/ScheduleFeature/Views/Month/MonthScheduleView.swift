import CalendarKit
import ComposableArchitecture
import SharedUIs
import SwiftUI

@ViewAction(for: Schedule.self)
public struct MonthScheduleView: View {
    public init(store: StoreOf<MonthSchedule>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<MonthSchedule>
    @State private var needsToCreateNewDays = false
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    // TODO: Temp
    
    public var body: some View {
        VStack(spacing: 0) {
            weekdays
                .padding(.bottom, 4)

            hSeparator()
            
            monthCalendar
        }
        .onAppear { send(.onAppear) }
        .onChange(of: store.currentPage, initial: false) { _, newValue in
            // create week if the page reaches first/last page
            if newValue == 0 || newValue == (store.monthCalendar.count - 1) {
                needsToCreateNewDays = true
            }
        }
        .sheet(
            item: $store.scope(state: \.destination?.entriesTimeline, action: \.destination.entriesTimeline),
            content: entriesTimeline(store:)
        )
    }
}

// MARK: Views
extension MonthScheduleView {
    @ViewBuilder
    private var weekdays: some View {
        LazyVGrid(columns: columns) {
            ForEach(store.weekdays, id: \.self) { weekday in
                Text(weekday)
            }
        }
        .font(.customSubheadline)
        .foregroundStyle(#color("text_color"))
    }
    
    @ViewBuilder
    private var monthCalendar: some View {
        TabView(selection: $store.currentPage) {
            ForEach(
                Array(store.scope(state: \.monthCalendar, action: \.monthCalendar).enumerated()),
                id: \.element.id
            ) { index, store in
                MonthCalendarView(store: store)
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
    
    @ViewBuilder
    private func entriesTimeline(store: StoreOf<EntriesTimeline>) -> some View {
        EntriesTimelineView(store: store)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
    }
}

#Preview {
    MonthScheduleView(
        store: .init(
            initialState: .init(originDay: Day(date: .now)),
            reducer: MonthSchedule.init
        )
    )
}
