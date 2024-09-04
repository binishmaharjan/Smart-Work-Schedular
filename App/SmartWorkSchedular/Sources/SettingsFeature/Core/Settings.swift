import Foundation
import ComposableArchitecture
import NavigationBarFeature
import SharedUIs

@Reducer
public struct Settings {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        var navigationBar: NavigationBar.State = NavigationBar.State(
            title: "",
            subTitle: #localized("Settings"), // TODO:
            secondTrailingItem: "xmark"
        )
    }
    
    public enum Action {
        case navigationBar(NavigationBar.Action)
    }
    
    public init() { }
    
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .navigationBar(.delegate(.executeSecondAction)):
                return .run { _ in
                    await dismiss()
                }
                
            case .navigationBar:
                return .none
            }
        }
        
        Scope(state: \.navigationBar, action: \.navigationBar) {
            NavigationBar()
        }
    }
}
