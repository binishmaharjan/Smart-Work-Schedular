import SwiftUI
import ComposableArchitecture
import TutorialFeature
import MainTabFeature

public struct RootView: View {
    public init(store: StoreOf<Root>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Root>
    
    public var body: some View {
        ZStack {
            if let store = store.scope(state: \.destination, action: \.destination) {
                switch store.state {
                case .launch:
                    if let launchStore = store.scope(state: \.launch, action: \.launch) {
                        LaunchView(store: launchStore)
                    }
                    
                case .tutorial:
                    if let tutorialStore = store.scope(state: \.tutorial, action: \.tutorial) {
                        TutorialView(store: tutorialStore)
                    }
                    
                case .mainTab:
                    if let mainTabStore = store.scope(state: \.mainTab, action: \.mainTab) {
                        MainTabView(store: mainTabStore)
                    }
                }
            }
        }
    }
}

#Preview {
    RootView(
        store: .init(
            initialState: .init(),
            reducer: Root.init
        )
    )
}
