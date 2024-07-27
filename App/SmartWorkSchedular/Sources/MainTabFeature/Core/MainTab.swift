import Foundation
import ComposableArchitecture
import ScheduleFeature
import TemplatesFeature
import EarningsFeature

@Reducer
public struct MainTab {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action {
        
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            return .none
        }
    }
}
