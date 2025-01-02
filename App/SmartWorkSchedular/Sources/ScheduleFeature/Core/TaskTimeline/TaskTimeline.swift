import ComposableArchitecture
import Foundation

@Reducer
public struct TaskTimeline {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action: ViewAction {
        public enum View {
        }
        
        case view(View)
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
}
