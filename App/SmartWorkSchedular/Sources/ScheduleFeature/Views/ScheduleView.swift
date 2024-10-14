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
            TabView(selection: $currentSelected) {
                ForEach(store.displayDays.indices, id: \.self) { index in
                    MonthView(store: store, index: index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
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


struct MonthView: View {
    
    init(store: StoreOf<Schedule>, index: Int) {
        self.store = store
        self.index = index
    }
    
    @Bindable private var store: StoreOf<Schedule>
    private let index: Int
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var body: some View {
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
                let displayDays = store.displayDays[index]
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(displayDays) { day in
                        MonthItemView(day: day)
                            .frame(height: (proxy.size.height / 5))
                    }
                }
            }
        }
    }
}
