import CalendarKit
import ComposableArchitecture
import Foundation
import NavigationBarFeature
import SettingsFeature
import SharedUIs

@Reducer
public struct Schedule {
    @Reducer(state: .equatable)
    public enum Destination {
        case settings(Settings)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        // Shared State
        @Shared(.displayMode) var displayMode = DisplayMode.month
        @Shared(.startOfWeekday) var startOfWeekday = Weekday.sunday
        // Data State
        @Presents var destination: Destination.State?
        var schedulePanels: IdentifiedArrayOf<SchedulePanel.State> = []
        var focusDay = Day(date: .now)
        var displayDays: IdentifiedArrayOf<[Day]> = []
        var weekdays: [String] = []
        // View State
        var currentPage: Int = 1
        var needsToCreateNewWeek = false
    
        var navigationBar = NavigationBar.State(
            title: "My Work Schedule",
            subTitle: "October",
            firstTrailingItem: "plus",
            secondTrailingItem: "gearshape.fill"
        )
    }
    
    public enum Action: BindableAction, ViewAction {
        public enum View {
            case onAppear
            case scrollEndReached
        }
        
        case destination(PresentationAction<Destination.Action>)
        case navigationBar(NavigationBar.Action)
        case binding(BindingAction<State>)
        case schedulePanels(IdentifiedActionOf<SchedulePanel>)
        case view(View)
        
        case updateDisplayDates
        case startWeekOnUpdated(Weekday)
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
            case .view(.onAppear):
                // initialize weekdays
                state.weekdays = calendarKitClient.weekDays()
                
                return .send(.updateDisplayDates)
                
            case .view(.scrollEndReached):
                guard state.schedulePanels.indices.contains(state.currentPage) else {
                    return .none
                }
                
                if state.currentPage == 0 {
                    // inserting new dates at index 0 and remove last item
                    let currentFirstOriginDate = state.schedulePanels[0].originDay
                    let newOriginDate = currentFirstOriginDate.previousMonthDay
                    state.schedulePanels.insert(
                        SchedulePanel.State(
                            displayMode: state.displayMode,
                            originDay: newOriginDate,
                            displayDays: calendarKitClient.displayDays(from: newOriginDate)
                        ),
                        at: 0
                    )
                    
                    state.schedulePanels.removeLast()
                    state.currentPage = 1
                }
                
                if state.currentPage == (state.schedulePanels.count - 1) {
                    // append new dates at last index and remove firs item
                    let currentLastOriginDate = state.schedulePanels[state.schedulePanels.count - 1].originDay
                    let newOriginDate = currentLastOriginDate.nextMonthDay
                    state.schedulePanels.append(
                        SchedulePanel.State(
                            displayMode: state.displayMode,
                            originDay: newOriginDate,
                            displayDays: calendarKitClient.displayDays(from: newOriginDate)
                        )
                    )
                    
                    state.schedulePanels.removeFirst()
                    state.currentPage = state.schedulePanels.count - 2
                }
                return .none
                
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
                
            case .startWeekOnUpdated(let weekday):
                print("Start Week Updated To: \(weekday)")
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
