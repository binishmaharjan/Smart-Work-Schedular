import Foundation
import ComposableArchitecture
import CalendarFeature

@Reducer
public struct Schedule {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        var selectedDay = Day(date: .now)
        // Should Change to Identified Array
        var week: IdentifiedArrayOf<Day> {
            IdentifiedArray(uniqueElements: selectedDay.daysInWeek.days)
        }
        var month: IdentifiedArrayOf<Week> {
            IdentifiedArray(uniqueElements: selectedDay.daysInMonth.weeks)
        }
    }
    
    public enum Action {
        case onAppear
        case previousButtonPressed
        case nextButtonPressed
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .previousButtonPressed:
                state.selectedDay = state.selectedDay.previousMonthDay
                return .none
                
            case .nextButtonPressed:
                state.selectedDay = state.selectedDay.nextMonthDay
                return .none
            }
        }
    }
}
