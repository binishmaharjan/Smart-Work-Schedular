import CalendarKit
import ComposableArchitecture
import Foundation

@Reducer
public struct WeekSchedule {
    @ObservableState
    public struct State: Equatable {
        public init(originDay: Day) {
            self.originDay = originDay
        }
        // Shared State
        @Shared(.ud_startOfWeekday) var startOfWeekday = Weekday.sunday
        @Shared(.mem_currentSelectedDay) var currentSelectedDay = Day(date: .now)
        
        var weekCalendar: IdentifiedArrayOf<WeekCalendar.State> = []
        var weekdays: [String] = []
        var currentPage: Int = 1
        var originDay: Day
        
        var displayDays: IdentifiedArrayOf<Day> = []
    }
    
    public enum Action: ViewAction, BindableAction {
        public enum View {
            case onAppear
            case scrollEndReached
        }
        
        public enum Delegate {
            case weekChanged(originDay: Day)
        }
        
        case view(View)
        case delegate(Delegate)
        case binding(BindingAction<State>)
        
        case observeStartWeekOn
        case startWeekOnUpdated(Weekday)
        case observeCurrentSelectedDay
        case currentSelectedDayUpdate(Day)
        case weekCalendar(IdentifiedActionOf<WeekCalendar>)
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
                
                guard state.weekCalendar.isEmpty else {
                    return .none
                }
                
                // create display dates
                createInitialDisplayDate(state: &state)
                
                return .run { [originDay = state.originDay] send in
                    await send(.delegate(.weekChanged(originDay: originDay)))
                    await send(.observeStartWeekOn)
                    await send(.observeCurrentSelectedDay)
                }
                
            case .view(.scrollEndReached):
                logger.debug("view: scrollEndReached: generate new days")
                
                createNextDisplayDate(state: &state)
                return .send(.delegate(.weekChanged(originDay: state.originDay)))
                
            case .observeStartWeekOn:
                logger.debug("observeStartWeekOn")
                
                return .publisher {
                    state.$startOfWeekday.publisher.map(Action.startWeekOnUpdated)
                }
                
            case .startWeekOnUpdated(let weekday):
                logger.debug("startWeekOnUpdated: \(weekday)")
                
                createNextDisplayDate(state: &state)
                return .none
                
            case .observeCurrentSelectedDay:
                logger.debug("observeCurrentSelectedDay")
                
                return .publisher {
                    state.$startOfWeekday.publisher.map(Action.startWeekOnUpdated)
                }
                
            case .currentSelectedDayUpdate(let day):
                logger.debug("currentSelectedDayUpdate: \(day.formatted(.dateIdentifier))")
                
                return .none

            case .binding, .weekCalendar, .delegate:
                return .none
            }
        }
        .forEach(\.weekCalendar, action: \.weekCalendar) {
            WeekCalendar()
        }
    }
}

// MARK: Effects & Methods
extension WeekSchedule {
    private func createInitialDisplayDate(state: inout State) {
        // clear current displayDays
        state.weekCalendar.removeAll()
        
        // Initially set previous month as first
        let previousOriginDay = calendarKitClient.previousFocusDay(from: state.originDay)
        let previousDisplayDays = calendarKitClient.displayDays(from: previousOriginDay)
        state.weekCalendar.append(
            WeekCalendar.State(
                originDay: previousOriginDay,
                displayDays: previousDisplayDays
            )
        )
        
        // Initially set this month as second
        let displayDays = calendarKitClient.displayDays(from: state.originDay)
        state.weekCalendar.append(
            WeekCalendar.State(
                originDay: state.originDay,
                displayDays: displayDays
            )
        )
        
        // Initially set next month as third
        let nextOriginDay = calendarKitClient.nextFocusDay(from: state.originDay)
        let nextDisplayDays = calendarKitClient.displayDays(from: nextOriginDay)
        state.weekCalendar.append(
            WeekCalendar.State(
                originDay: nextOriginDay,
                displayDays: nextDisplayDays
            )
        )
    }
    
    private func createNextDisplayDate(state: inout State) {
        // safe guard for index
        guard state.weekCalendar.indices.contains(state.currentPage) else {
            return
        }
        
        // inserting new dates at index 0 and remove last item
        if state.currentPage == 0 {
            // get first page origin day
            let currentFirstOriginDay = state.weekCalendar[0].originDay
            // get new origin day from first day, to add as first page
            let newOriginDay = calendarKitClient.previousFocusDay(from: currentFirstOriginDay)
            // create new display days
            let newDisplayDays = calendarKitClient.displayDays(from: newOriginDay)
            // add new created display days and add at first page
            state.weekCalendar.insert(
                WeekCalendar.State(
                    originDay: newOriginDay,
                    displayDays: newDisplayDays
                ),
                at: 0
            )
            
            // remove last page
            state.weekCalendar.removeLast()
            // adjust index
            state.currentPage = 1
            // update originDay to current middle page, i.e previous first day
            // since previous first day was changed to middle page
            state.originDay = currentFirstOriginDay
        }
        
        // append new dates at last index and remove firs item
        if state.currentPage == (state.weekCalendar.count - 1) {
            // get last page origin day
            let currentLastOriginDay = state.weekCalendar[state.weekCalendar.count - 1].originDay
            // get new origin day from last day, to add as first page
            let newOriginDay = calendarKitClient.nextFocusDay(from: currentLastOriginDay)
            // create new display days
            let newDisplayDays = calendarKitClient.displayDays(from: newOriginDay)
            // add new created display days and add at last page
            state.weekCalendar.append(
                WeekCalendar.State(
                    originDay: newOriginDay,
                    displayDays: newDisplayDays
                )
            )
            
            // remove first page
            state.weekCalendar.removeFirst()
            // adjust index
            state.currentPage = state.weekCalendar.count - 2
            // update originDay to current middle page, i.e previous last day
            // since previous last day was changed to middle page
            state.originDay = currentLastOriginDay
        }
    }
}
