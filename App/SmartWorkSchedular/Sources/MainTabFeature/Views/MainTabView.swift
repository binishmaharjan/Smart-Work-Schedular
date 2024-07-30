import SwiftUI
import ComposableArchitecture
import ScheduleFeature
import TemplatesFeature
import EarningsFeature
import SharedUIs

public struct MainTabView: View {
    public init(store: StoreOf<MainTab>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<MainTab>
    
    public var body: some View {
        TabView {
            Text("View 1")
                .font(.customTitle)
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            Text("View 2")
                .font(.title)
                .tabItem {
                    Label("Templates", systemImage: "list.star")
                }
            Text("View 3")
                .font(.title)
                .tabItem {
                    Label("Earnings", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

#Preview {
    MainTabView(
        store: .init(
            initialState: .init(),
            reducer: MainTab.init
        )
    )
}
