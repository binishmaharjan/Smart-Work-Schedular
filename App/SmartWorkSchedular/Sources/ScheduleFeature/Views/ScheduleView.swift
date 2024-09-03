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
        VStack {
            HStack(spacing: 0) {
                Button(#localized("Prev")) {
                    store.send(.previousButtonPressed)
                }
                .buttonStyle(.borderedProminent)
                
                Text(#localized("Some Text"))
                    .frame(maxWidth: .infinity)
                
                Button(#localized("Next")) {
                    store.send(.nextButtonPressed)
                }
                .buttonStyle(.borderedProminent)
            }
            HStack() {
                Button(#localized("月")) {
                    store.send(.monthButtonPressed)
                }
                .buttonStyle(.borderedProminent)
                
                Button(#localized("週")) {
                    store.send(.weekButtonPressed)
                }
                .buttonStyle(.borderedProminent)
                
                Button(#localized("日")) {
                    store.send(.dayButtonPressed)
                }
                .buttonStyle(.borderedProminent)
            }
            
            ScrollView {
                ForEach(store.displayDays) { day in
                    Text("\(day.formatted(.dateTest))")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .padding(.top, 50)
        .background(#color("background"))
        .overlay(navigationBar)
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
