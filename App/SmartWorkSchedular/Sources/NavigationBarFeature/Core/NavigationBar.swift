import Foundation
import ComposableArchitecture

@Reducer
public struct NavigationBar {
    @ObservableState
    public struct State: Equatable {
        public init(title: String) {
            self.title = title
        }
        
        var title: String
    }
    
    public enum Action {
        @CasePathable
        public enum Delegate {
            case executeFirstAction
            case executeSecondAction
        }
        
        case delegate(Delegate)
        case firstTrailingItemTapped
        case secondTrailingItemTapped
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .firstTrailingItemTapped:
                return .send(.delegate(.executeFirstAction))

            case .secondTrailingItemTapped:
                return .send(.delegate(.executeSecondAction))
                
            case .delegate:
                return .none
            }
        }
    }
}
