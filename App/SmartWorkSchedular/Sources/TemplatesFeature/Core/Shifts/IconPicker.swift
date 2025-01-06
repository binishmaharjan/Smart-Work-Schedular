import ComposableArchitecture
import Foundation

@Reducer
public struct IconPicker {
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
        Reduce<State, Action> { _, _ in
            .none
        }
    }
}
