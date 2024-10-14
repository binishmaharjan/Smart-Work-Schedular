import Foundation
import ComposableArchitecture
import CalendarKit

@Reducer
public struct SchedulePanel {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public init(originDay: Day, displayDays: [Day]) {
            self.originDay = originDay
            self.displayDays = IdentifiedArray(uniqueElements: displayDays)
        }
        
        var originDay: Day
        var displayDays: IdentifiedArrayOf<Day>
        
        public var id: String { // TODO: Think of the id
            UUID().uuidString
        }
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
