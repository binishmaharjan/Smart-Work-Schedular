import Foundation
import ComposableArchitecture

@Reducer
public struct Launch {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action {
        @CasePathable
        public enum Delegate: Equatable {
            case showTutorial
            case showMainTab
        }

        case delegate(Delegate)
        
        case onAppear
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                // Check if first launch
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
