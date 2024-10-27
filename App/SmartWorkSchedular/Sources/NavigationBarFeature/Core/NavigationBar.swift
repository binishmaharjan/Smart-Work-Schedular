import ComposableArchitecture
import Foundation

@Reducer
public struct NavigationBar {
    @ObservableState
    public struct State: Equatable {
        public init(title: String, firstTrailingItem: String? = nil, secondTrailingItem: String? = nil) {
            self.title = title
            self.firstTrailingItem = firstTrailingItem
            self.secondTrailingItem = secondTrailingItem
        }
        
        var title: String
        var firstTrailingItem: String?
        var secondTrailingItem: String?
    }
    
    public enum Action {
        @CasePathable
        public enum Delegate {
            case executeFirstAction
            case executeSecondAction
        }
        
        case delegate(Delegate)
        case updateTitle(String)
        case firstTrailingItemTapped
        case secondTrailingItemTapped
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .updateTitle(let title):
                state.title = title
                return .none
                
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
