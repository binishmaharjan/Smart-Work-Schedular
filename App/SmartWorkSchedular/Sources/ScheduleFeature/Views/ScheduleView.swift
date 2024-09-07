import SwiftUI
import ComposableArchitecture
import SharedUIs
import CalendarKit
import SettingsFeature
import NavigationBarFeature

public struct ScheduleView: View {
    public init(store: StoreOf<Schedule>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Schedule>
    
    public var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ForEach(store.displayDays) { day in
                        Text("\(day.formatted(.dateTest))")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .padding(.top, 50) // Takes space for navigation bar
            .background(#color("background"))
            .overlay(navigationBar)
        }
        .onAppear { store.send(.onAppear) }
        .fullScreenCover(
            item: $store.scope(state: \.destination?.settings, action: \.destination.settings),
            content: SettingsView.init(store:)
        )
    }
}

// MARK: Views
extension ScheduleView {
    private var navigationBar: some View {
        NavigationBarView(
            store: store.scope(state: \.navigationBar, action: \.navigationBar)
        )
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
