import Foundation
import ComposableArchitecture
import CalendarKit

@Reducer
public struct StartWeekOn {
    @Reducer(state: .equatable)
    public enum Destination {
        case settings(Settings)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Shared(.startOfWeekday) var startOfWeekday = Weekday.sunday
        var weekdays: IdentifiedArrayOf<Weekday> = .init(uniqueElements: Weekday.allCases)
    }
    
    public enum Action {
        case selected(Weekday)
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .selected(let weekday):
                state.startOfWeekday = weekday
                return .none
            }
        }
    }
}
