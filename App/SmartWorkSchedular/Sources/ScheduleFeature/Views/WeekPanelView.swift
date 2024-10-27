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
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(store.displayDays) { day in
                        MonthItemView(originDay: store.originDay, day: day)
                            .frame(height: 70)
                    }
                }
                
                Rectangle()
                    .fill(#color("sub_text_color").opacity(0.5))
                    .frame(height: 1)
                
                VStack {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.slash")
                        .font(.customTitle)
                    
                    Text(#localized("No Events"))
                        .font(.customHeadline)
                }
                .foregroundStyle(#color("sub_text_color"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
