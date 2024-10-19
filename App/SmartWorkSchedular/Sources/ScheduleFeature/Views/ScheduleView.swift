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
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    @State private var currentSelected = 0
    
    public var body: some View {
        NavigationStack {
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(store.weekdays, id: \.self) { weekday in
                        Text(weekday)
                    }
                }
                .padding(.bottom, 8)
                .font(.customSubheadline)
                .foregroundStyle(#color("text_color"))
                
                TabView(selection: $currentSelected) {
                    ForEach(store.scope(state: \.schedulePanels, action: \.schedulePanels)) { store in
                        MonthPanelView(store: store)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .padding(.top, 50) // Takes space for navigation bar
            .padding(.top, 8)
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
