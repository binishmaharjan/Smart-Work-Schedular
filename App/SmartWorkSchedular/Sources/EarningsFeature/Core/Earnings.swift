import ComposableArchitecture
import Foundation

@Reducer
public struct Earnings {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action {
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { _, _ in
            .none
        }
    }
}
