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
        VStack(spacing: 0) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(store.displayDays) { day in
                    MonthItemView(originDay: store.originDay, day: day)
                        .frame(height: 70)
                        .onTapGesture {
                            send(.daySelected(day))
                        }
                }
            }
            
            hSeparator()
            
            VStack {
                Image(systemName: "rectangle.portrait.on.rectangle.portrait.slash")
                    .font(.customTitle)
                
                Text(#localized("No Events"))
                    .font(.customHeadline)
                
                Text(#localized("\(store.currentSelectedDay.formatted(.dateIdentifier))"))
                    .font(.customHeadline)
            }
            .foregroundStyle(#color("sub_text_color"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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
