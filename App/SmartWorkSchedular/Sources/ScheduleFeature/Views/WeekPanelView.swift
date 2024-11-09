import CalendarKit
import ComposableArchitecture
import SharedUIs
import SwiftUI

public struct WeekPanelView: View {
    public init(store: StoreOf<SchedulePanel>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<SchedulePanel>
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    public var body: some View {
        HStack(spacing: 0) {
            Color.clear
                .frame(width: 56)
            
            VStack(spacing: 0) {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(store.displayDays) { day in
                        MonthItemView(originDay: store.originDay, day: day)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

#Preview {
    WeekPanelView(
        store: .init(
            initialState: .init(displayMode: .week, originDay: .init(date: .now), displayDays: []),
            reducer: SchedulePanel.init
        )
    )
}
