import CalendarKit
import ComposableArchitecture
import Foundation

@Reducer
public struct MonthCalendar {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public init(originDay: Day, displayDays: [Day]) {
            self.originDay = originDay
            self.displayDays = IdentifiedArray(uniqueElements: displayDays)
        }
        
        var originDay: Day
        var displayDays: IdentifiedArrayOf<Day>
        
        public var id: String {
            originDay.formatted(.dateIdentifier)
        }
    }
    
    public enum Action {
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { _, _ in
            return .none
        }
    }
}
