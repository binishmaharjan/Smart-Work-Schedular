import ComposableArchitecture
import Foundation
import NavigationBarFeature

@Reducer
public struct Templates {
    enum Kind {
        case shift
        case rotation
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {
            self.kind = .shift
        }
        
        var kind: Kind
        var navigationBar = NavigationBar.State(
            title: "Templates",
            firstTrailingItem: "plus"
        )
    }
    
    public enum Action {
        case navigationBar(NavigationBar.Action)
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { _, action in
            switch action {
            case .navigationBar:
                return .none
            }
        }
        
        Scope(state: \.navigationBar, action: \.navigationBar) {
            NavigationBar()
        }
    }
}
