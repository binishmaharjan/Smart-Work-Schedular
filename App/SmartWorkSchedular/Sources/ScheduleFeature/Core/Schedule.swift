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
        case calendarMode(CalendarMode)
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
        var weekdays: [String] = []
        // View State
        var currentPage: Int = 1
        var needsToCreateNewWeek = false
    
        var navigationBar = NavigationBar.State(
            title: "My Work Schedule",
            subTitle: "October",
            firstTrailingItem: "plus",
            secondTrailingItem: "calendar.badge.clock"
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
        
        case observeStartWeekOn
        case observerDisplayMode
        case startWeekOnUpdated(Weekday)
        case displayModeUpdated(DisplayMode)
    }
    
    public init() { }
    
    @Dependency(\.calendarKitClient) private var calendarKitClient
    @Dependency(\.loggerClient) private var logger
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.onAppear):
                logger.debug("view: onAppear")
                
                // initialize weekdays
                state.weekdays = calendarKitClient.weekDays()
                
                guard state.schedulePanels.isEmpty else {
                    return .none
                }
                
                // create display dates
                createInitialDisplayDate(state: &state)
                
                return .run { send in
                    await send(.observeStartWeekOn)
                    await send(.observerDisplayMode)
                }
                
            case .view(.scrollEndReached):
                logger.debug("view: scrollEndReached")
                
                return createNextDisplayDate(state: &state)
                
            case .observeStartWeekOn:
                logger.debug("observeStartWeekOn")
                
                return .publisher {
                    state.$startOfWeekday.publisher.map(Action.startWeekOnUpdated)
                }
                
            case .observerDisplayMode:
                logger.debug("observerDisplayMode")
                
                return .publisher {
                    state.$displayMode.publisher.map(Action.displayModeUpdated)
                }
                
            case .startWeekOnUpdated(let weekday):
                logger.debug("startWeekOnUpdated: \(weekday)")
                
                createInitialDisplayDate(state: &state)
                return .none
                
            case .displayModeUpdated(let displayMode):
                logger.debug("displayModeUpdated: \(displayMode)")
                
                return .none
                
            case .navigationBar(.delegate(.executeFirstAction)):
                logger.debug("navigationBar: delegate: executeFirstAction")
                
                return .none
                
            case .navigationBar(.delegate(.executeSecondAction)):
                logger.debug("navigationBar: delegate: executeSecondAction")
                
                state.destination = .calendarMode(CalendarMode.State())
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

// MARK: Effects
extension Schedule {
    private func createInitialDisplayDate(state: inout State) {
        // clear current displayDays
        state.schedulePanels.removeAll()
        
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
    }
    
    private func createNextDisplayDate(state: inout State) -> Effect<Action> {
        // safe guard for index
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
            // update focusDay
            state.focusDay = newOriginDate
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
            // update focusDay
            state.focusDay = newOriginDate
        }
        
        return .none
    }
}
