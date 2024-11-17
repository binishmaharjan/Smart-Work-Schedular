import CalendarKit
import ComposableArchitecture
import Foundation

@Reducer
public struct StartWeekOn {
    @Reducer(state: .equatable)
    public enum Destination {
        case settings(Settings)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @SharedReader(.ud_startOfWeekday) var startOfWeekday = Weekday.sunday
        var weekdays: IdentifiedArrayOf<Weekday> = .init(uniqueElements: Weekday.allCases)
    }
    
    public enum Action {
        case selected(Weekday)
    }
    
    public init() { }
    
    @Dependency(\.calendarKitClient) private var calendarKitClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { _, action in
            switch action {
            case .selected(let weekday):
                calendarKitClient.updateStartWeekdayOn(to: weekday)
                return .none
            }
        }
    }
}
