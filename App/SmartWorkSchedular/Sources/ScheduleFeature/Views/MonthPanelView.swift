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
            LazyVGrid(columns: columns) {
                Text("Sun")
                Text("Mon")
                Text("Tue")
                Text("Wed")
                Text("Thu")
                Text("Fri")
                Text("Sat")
            }
            .padding(.bottom, 8)
            .font(.customSubheadline)
            .foregroundStyle(#color("text_color"))
            
            GeometryReader { proxy in
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(store.displayDays) { day in
                        MonthItemView(day: day)
                            .frame(height: (proxy.size.height / 5))
                    }
                }
            }
        }
    }
}

#Preview {
    MonthPanelView(
        store: .init(
            initialState: .init(originDay: .init(date: .now), displayDays: []),
            reducer: SchedulePanel.init
        )
    )
}
