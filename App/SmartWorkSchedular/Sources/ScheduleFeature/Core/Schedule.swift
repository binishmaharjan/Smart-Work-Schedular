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
        var focusDay = Day(date: .now) {
            didSet {
                print("🍎: \(focusDay.date.startOfDate)")
            }
        }
        var weekdays: [String] = []
        // View State
        var currentPage: Int = 1
    
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
                
                createNextDisplayDate(state: &state)
                return .none
                
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
                
                createInitialDisplayDate(state: &state)
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

// MARK: Effects & Methods
extension Schedule {
    private func createInitialDisplayDate(state: inout State) {
        // clear current displayDays
        state.schedulePanels.removeAll()
        
        // Initially set previous month as first
        let previousOriginDay = calendarKitClient.previousFocusDay(from: state.focusDay)
        let previousDisplayDays = calendarKitClient.displayDays(from: previousOriginDay)
        state.schedulePanels.append(
            SchedulePanel.State(
                displayMode: state.displayMode,
                originDay: state.focusDay.previousMonthDay,
                displayDays: previousDisplayDays
            )
        )
        
        // Initially set this month as second
        let displayDays = calendarKitClient.displayDays(from: state.focusDay)
        state.schedulePanels.append(
            SchedulePanel.State(
                displayMode: state.displayMode,
                originDay: state.focusDay,
                displayDays: displayDays
            )
        )
        
        // Initially set next month as third
        let nextOriginDay = calendarKitClient.nextFocusDay(from: state.focusDay)
        let nextDisplayDays = calendarKitClient.displayDays(from: nextOriginDay)
        state.schedulePanels.append(
            SchedulePanel.State(
                displayMode: state.displayMode,
                originDay: state.focusDay.nextMonthDay,
                displayDays: nextDisplayDays
            )
        )
    }
    
    private func createNextDisplayDate(state: inout State) {
        // safe guard for index
        guard state.schedulePanels.indices.contains(state.currentPage) else {
            return
        }
        
        // inserting new dates at index 0 and remove last item
        if state.currentPage == 0 {
            // get first page origin day
            let currentFirstOriginDay = state.schedulePanels[0].originDay
            // get new origin day from first day, to add as first page
            let newOriginDay = calendarKitClient.previousFocusDay(from: currentFirstOriginDay)
            print("🍎 Current : \(currentFirstOriginDay.date.startOfDate)")
            print("🍎 Previous: \(newOriginDay.date.startOfDate)")
            // create new display days
            let newDisplayDays = calendarKitClient.displayDays(from: newOriginDay)
            // add new created display days and add at first page
            state.schedulePanels.insert(
                SchedulePanel.State(
                    displayMode: state.displayMode,
                    originDay: newOriginDay,
                    displayDays: newDisplayDays
                ),
                at: 0
            )
            
            // remove last page
            state.schedulePanels.removeLast()
            // adjust index
            state.currentPage = 1
            // update originDay to current middle page, i.e previous first day
            // since previous first day was changed to middle page
            state.focusDay = currentFirstOriginDay
        }
        
        // append new dates at last index and remove firs item
        if state.currentPage == (state.schedulePanels.count - 1) {
            // get last page origin day
            let currentLastOriginDay = state.schedulePanels[state.schedulePanels.count - 1].originDay
            // get new origin day from last day, to add as first page
            let newOriginDay = calendarKitClient.nextFocusDay(from: currentLastOriginDay)
            print("🍎 Current : \(currentLastOriginDay.date.startOfDate)")
            print("🍎 Next: \(newOriginDay.date.startOfDate)")
            // create new display days
            let newDisplayDays = calendarKitClient.displayDays(from: newOriginDay)
            // add new created display days and add at last page
            state.schedulePanels.append(
                SchedulePanel.State(
                    displayMode: state.displayMode,
                    originDay: newOriginDay,
                    displayDays: newDisplayDays
                )
            )
            
            // remove first page
            state.schedulePanels.removeFirst()
            // adjust index
            state.currentPage = state.schedulePanels.count - 2
            // update originDay to current middle page, i.e previous last day
            // since previous last day was changed to middle page
            state.focusDay = currentLastOriginDay
        }
    }
}
