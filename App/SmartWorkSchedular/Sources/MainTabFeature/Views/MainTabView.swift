import ComposableArchitecture
import EarningsFeature
import ScheduleFeature
import SettingsFeature
import SharedUIs
import SwiftUI
import TemplatesFeature

public struct MainTabView: View {
    public init(store: StoreOf<MainTab>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<MainTab>
    
    public var body: some View {
        TabView(selection: $store.selectedTab) {
            ScheduleView(store: store.scope(state: \.schedule, action: \.schedule))
                .tag(Tab.schedule)
                .tabItem {
                    Label(Tab.schedule.title, systemImage: Tab.schedule.icon)
                }
            
            TemplatesView(store: store.scope(state: \.templates, action: \.templates))
                .tag(Tab.templates)
                .tabItem {
                    Label(Tab.templates.title, systemImage: Tab.templates.icon)
                }
            
            EarningsView(store: store.scope(state: \.earnings, action: \.earnings))
                .tag(Tab.earnings)
                .tabItem {
                    Label(Tab.earnings.title, systemImage: Tab.earnings.icon)
                }
            
            SettingsView(store: store.scope(state: \.settings, action: \.settings))
                .tag(Tab.settings)
                .tabItem {
                    Label(Tab.settings.title, systemImage: Tab.settings.icon)
                }
        }
    }
}

#Preview("Light Mode") {
    MainTabView(
        store: .init(
            initialState: .init(),
            reducer: MainTab.init
        )
    )
    .tint(Color.accent)
}

#Preview("Dark Mode") {
    MainTabView(
        store: .init(
            initialState: .init(),
            reducer: MainTab.init
        )
    )
    .tint(Color.accent)
    .preferredColorScheme(.dark)
}
