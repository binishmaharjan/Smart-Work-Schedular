import Foundation
import ComposableArchitecture
import CalendarKit
import SharedUIs
import SettingsFeature
import NavigationBarFeature

@Reducer
public struct Schedule {
    @Reducer(state: .equatable)
    public enum Destination {
        case settings(Settings)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Presents var destination: Destination.State?
        var navigationBar: NavigationBar.State = NavigationBar.State(
            title: "My Work Schedule",
            subTitle: "October", // TODO:
            firstTrailingItem: "plus",
            secondTrailingItem: "gearshape.fill"
        )
        
        var schedulePanels: IdentifiedArrayOf<SchedulePanel.State> = []
        var focusDay = Day(date: .now)
        var displayDays: IdentifiedArrayOf<[Day]> = []
        var weekdays: [String] = []
        @Shared(.displayMode) var displayMode = DisplayMode.month
        @Shared(.startOfWeekday) var startOfWeekday = Weekday.sunday
    }
    
    public enum Action: BindableAction {
        case destination(PresentationAction<Destination.Action>)
        case navigationBar(NavigationBar.Action)
        case binding(BindingAction<State>)
        case schedulePanels(IdentifiedActionOf<SchedulePanel>)
        
        case onAppear
        case updateDisplayDates
        case previousButtonPressed
        case nextButtonPressed
        case monthButtonPressed
        case weekButtonPressed
        case dayButtonPressed
    }
    
    public init() { }
    
    @Dependency(\.calendarKitClient) private var calendarKitClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                // initialize weekdays
                state.weekdays = calendarKitClient.weekDays()
                
                return .send(.updateDisplayDates)
                
            case .binding(\.startOfWeekday): // <- find the changed timing
                print("Changed To: \(state.startOfWeekday)")
                return .none
                
            case .updateDisplayDates:
                // Initially set previous month as first
                let prevMonth = calendarKitClient.displayDays(from: state.focusDay.previousMonthDay)
                state.schedulePanels.append(
                    SchedulePanel.State(
                        displayMode: state.displayMode,
                        originDay: state.focusDay.previousMonthDay,
                        displayDays: prevMonth
                    )
                )
                
                // Initially set this month as second
                let thisMonth = calendarKitClient.displayDays(from: state.focusDay)
                state.schedulePanels.append(
                    SchedulePanel.State(
                        displayMode: state.displayMode,
                        originDay: state.focusDay,
                        displayDays: thisMonth
                    )
                )
                
                // Initially set next month as third
                let nextMonth = calendarKitClient.displayDays(from: state.focusDay.nextMonthDay)
                state.schedulePanels.append(
                    SchedulePanel.State(
                        displayMode: state.displayMode,
                        originDay: state.focusDay.nextMonthDay,
                        displayDays: nextMonth
                    )
                )
                
                return .none
                
            case .previousButtonPressed:
                state.focusDay = calendarKitClient.previousFocusDay(state.focusDay)
                return .send(.updateDisplayDates)
                
            case .nextButtonPressed:
                state.focusDay = calendarKitClient.nextFocusDay(state.focusDay)
                return .send(.updateDisplayDates)
                
            case .monthButtonPressed:
                state.displayMode = .month

                return .send(.updateDisplayDates)
                
            case .weekButtonPressed:
                state.displayMode = .week
                return .send(.updateDisplayDates)
                
            case .dayButtonPressed:
                state.displayMode = .day
                return .send(.updateDisplayDates)
                
            case .navigationBar(.delegate(.executeFirstAction)):
                return .none
                
            case .navigationBar(.delegate(.executeSecondAction)):
                state.destination = .settings(Settings.State())
                return .none
                
            case .destination, .navigationBar, .binding, .schedulePanels:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.schedulePanels, action: \.schedulePanels) {
            SchedulePanel()
        }
        
        Scope(state: \.navigationBar, action: \.navigationBar) {
            NavigationBar()
        }
    }
}
