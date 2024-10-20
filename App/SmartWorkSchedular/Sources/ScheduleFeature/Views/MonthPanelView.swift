import SwiftUI
import ComposableArchitecture
import SharedUIs
import CalendarKit

public struct MonthPanelView: View {
    public init(store: StoreOf<SchedulePanel>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<SchedulePanel>
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    public var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(store.displayDays) { day in
                        MonthItemView(originDay: store.originDay, day: day)
                            .frame(height: (proxy.size.height / CGFloat(store.numberOfWeeks)))
                    }
                }
            }
        }
    }
}

#Preview {
    MonthPanelView(
        store: .init(
            initialState: .init(displayMode: .month, originDay: .init(date: .now), displayDays: []),
            reducer: SchedulePanel.init
        )
    )
}


