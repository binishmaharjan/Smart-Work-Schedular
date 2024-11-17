import ComposableArchitecture
import EarningsFeature
import Foundation
import LoggerClient
import ScheduleFeature
import SettingsFeature
import TemplatesFeature

@Reducer
public struct MainTab {
    @ObservableState
    public struct State: Equatable {
        public init() { 
            self.schedule = Schedule.State()
            self.templates = Templates.State()
            self.earnings = Earnings.State()
            self.settings = Settings.State()
            self.selectedTab = .schedule
        }
        
        public var schedule: Schedule.State
        public var templates: Templates.State
        public var earnings: Earnings.State
        public var settings: Settings.State
        public var selectedTab: Tab
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case schedule(Schedule.Action)
        case templates(Templates.Action)
        case earnings(Earnings.Action)
        case settings(Settings.Action)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .binding(\.selectedTab):
                logger.debug("tabSelected: \(state.selectedTab)")
                return .none
                
            case .binding, .schedule, .templates, .earnings, .settings:
                return .none
            }
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
        
        Scope(state: \.settings, action: \.settings) {
            Settings()
        }
    }
}
