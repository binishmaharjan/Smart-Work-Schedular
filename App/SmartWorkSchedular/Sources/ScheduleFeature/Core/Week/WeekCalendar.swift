import CalendarKit
import ComposableArchitecture
import Foundation

@Reducer
public struct WeekCalendar {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public init(originDay: Day, displayDays: [Day]) {
            self.originDay = originDay
            self.displayDays = IdentifiedArray(uniqueElements: displayDays)
        }
        
        // Shared State
        @Shared(.mem_currentSelectedDay) var currentSelectedDay = Day(date: .now)
        
        var originDay: Day
        var displayDays: IdentifiedArrayOf<Day>
        
        public var id: String = UUID().uuidString
    }
    
    public enum Action: ViewAction {
        public enum View {
            case daySelected(Day)
        }
        
        case view(View)
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.daySelected(let day)):
                state.currentSelectedDay = day
                return .none
            }
        }
    }
}
