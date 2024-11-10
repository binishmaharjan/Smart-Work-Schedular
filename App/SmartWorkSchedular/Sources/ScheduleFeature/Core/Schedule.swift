import CalendarKit
import ComposableArchitecture
import Foundation
import NavigationBarFeature

@Reducer
public struct Schedule {
    @Reducer(state: .equatable)
    public enum Destination {
        case calendarMode(CalendarMode)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        // Shared State
        @Shared(.displayMode) var displayMode = DisplayMode.month
        // Data State
        @Presents var destination: Destination.State?
        var monthSchedule: MonthSchedule.State?
        var weekSchedule: WeekSchedule.State?
        var daySchedule: DaySchedule.State?
        
        var navigationBar = NavigationBar.State(
            title: "October",
            firstTrailingItem: "plus",
            secondTrailingItem: "calendar.badge.clock"
        )
    }
    
    public enum Action: ViewAction {
        public enum View {
            case onAppear
        }
        
        case destination(PresentationAction<Destination.Action>)
        case monthSchedule(MonthSchedule.Action)
        case weekSchedule(WeekSchedule.Action)
        case daySchedule(DaySchedule.Action)
        case navigationBar(NavigationBar.Action)
        case view(View)
        
        case observeDisplayMode
        case displayModeUpdated(DisplayMode)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.onAppear):
                createSchedule(&state)
                
                return .run { send in
                    await send(.observeDisplayMode)
                }
                
            case .observeDisplayMode:
                return .publisher {
                    state.$displayMode.publisher.map(Action.displayModeUpdated)
                }
                
            case .displayModeUpdated:
                createSchedule(&state)
                return .none
                
            case .navigationBar(.firstTrailingItemTapped):
                return .none
                
            case .navigationBar(.secondTrailingItemTapped):
                logger.debug("navigationBar: delegate: executeSecondAction")
                
                state.destination = .calendarMode(CalendarMode.State())
                return .none
                
            case .destination, .navigationBar, .monthSchedule, .weekSchedule, .daySchedule:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.monthSchedule, action: \.monthSchedule) {
            MonthSchedule()
        }
        .ifLet(\.weekSchedule, action: \.weekSchedule) {
            WeekSchedule()
        }
        .ifLet(\.daySchedule, action: \.daySchedule) {
            DaySchedule()
        }
        
        Scope(state: \.navigationBar, action: \.navigationBar) {
            NavigationBar()
        }
    }
}

// MARK: Effects & Methods
extension Schedule {
    private func createSchedule(_ state: inout State) {
        switch state.displayMode {
        case .month:
            state.monthSchedule = MonthSchedule.State()
            state.weekSchedule = nil
            state.daySchedule = nil
            
        case .week:
            state.monthSchedule = nil
            state.weekSchedule = WeekSchedule.State()
            state.daySchedule = nil
            
        case .day:
            state.monthSchedule = nil
            state.weekSchedule = nil
            state.daySchedule = DaySchedule.State()
        }
    }
}
