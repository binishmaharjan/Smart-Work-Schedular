import ComposableArchitecture
import NavigationBarFeature
import SharedUIs
import SwiftUI

@ViewAction(for: Schedule.self)
public struct ScheduleView: View {
    public init(store: StoreOf<Schedule>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<Schedule>
    @State private var sheetHeight: CGFloat = .zero
    
    public var body: some View {
        NavigationStack {
            VStack {
                if let monthSchedule = store.scope(state: \.monthSchedule, action: \.monthSchedule) {
                    MonthScheduleView(store: monthSchedule)
                } else if let weekSchedule = store.scope(state: \.weekSchedule, action: \.weekSchedule) {
                    WeekScheduleView(store: weekSchedule)
                } else if let daySchedule = store.scope(state: \.daySchedule, action: \.daySchedule) {
                    DayScheduleView(store: daySchedule)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 50) // Takes space for navigation bar
            .padding(.top, 8)
            .background(Color.background)
            .overlay(navigationBar)
        }
        .onAppear { send(.onAppear) }
        .sheet(
            item: $store.scope(state: \.destination?.calendarMode, action: \.destination.calendarMode),
            content: calendarMode(store:)
        )
    }
}

// MARK: Views
extension ScheduleView {
    @ViewBuilder
    private var navigationBar: some View {
        NavigationBarView(
            store: store.scope(state: \.navigationBar, action: \.navigationBar)
        )
    }
    
    @ViewBuilder
    private func calendarMode(store: StoreOf<CalendarMode>) -> some View {
        CalendarModeView(store: store)
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: InnerHeightPreferenceKey.self,
                        value: geometry.size.height
                    )
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                sheetHeight = newHeight
            }
            .presentationDetents([.height(sheetHeight)])
            .presentationDragIndicator(.visible)
    }
}

#Preview {
    ScheduleView(
        store: .init(
            initialState: .init(),
            reducer: Schedule.init
        )
    )
}
