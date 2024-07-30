import Foundation
import ComposableArchitecture
import ScheduleFeature
import TemplatesFeature
import EarningsFeature

@Reducer
public struct MainTab {
    @ObservableState
    public struct State: Equatable {
        public init() { 
            self.schedule = Schedule.State()
            self.templates = Templates.State()
            self.earnings = Earnings.State()
            self.selectedtab = .schedule
        }
        
        public var schedule: Schedule.State
        public var templates: Templates.State
        public var earnings: Earnings.State
        public var selectedtab: Tab
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case schedule(Schedule.Action)
        case templates(Templates.Action)
        case earnings(Earnings.Action)
        case tabSelected(Tab)
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            return .none
        }
        
        Scope(state: \.schedule, action: \.schedule) {
            Schedule()
        }
        
        Scope(state: \.templates, action: \.templates) {
            Templates()
        }
        
        Scope(state: \.earnings, action: \.earnings) {
            Earnings()
        }
    }
}
