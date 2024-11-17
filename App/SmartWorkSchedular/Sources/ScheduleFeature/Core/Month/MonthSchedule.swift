import CalendarKit
import ComposableArchitecture
import Foundation

@Reducer
public struct MonthSchedule {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        // Shared State
        @Shared(.ud_startOfWeekday) var startOfWeekday = Weekday.sunday
        @Shared(.mem_currentSelectedDay) var currentSelectedDay = Day(date: .now)
        
        var monthCalendar: IdentifiedArrayOf<MonthCalendar.State> = []
        var weekdays: [String] = []
        var currentPage: Int = 1
        var originDay = Day(date: .now)
    }
    
    public enum Action: BindableAction, ViewAction {
        public enum View {
            case onAppear
            case scrollEndReached
        }
        
        case view(View)
        case binding(BindingAction<State>)
        
        case observeStartWeekOn
        case startWeekOnUpdated(Weekday)
        case monthCalendar(IdentifiedActionOf<MonthCalendar>)
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
                
                guard state.monthCalendar.isEmpty else {
                    return .none
                }
                
                // create display dates
                createInitialDisplayDate(state: &state)
                
                return .run { send in
                    await send(.observeStartWeekOn)
                }
                
            case .view(.scrollEndReached):
                createNextDisplayDate(state: &state)
                
                return .none
                
            case .observeStartWeekOn:
                return .publisher {
                    state.$startOfWeekday.publisher.map(Action.startWeekOnUpdated)
                }
                
            case .startWeekOnUpdated(let weekday):
                createNextDisplayDate(state: &state)
                return .none

            case .binding, .monthCalendar:
                return .none
            }
        }
        .forEach(\.monthCalendar, action: \.monthCalendar) {
            MonthCalendar()
        }
    }
}

// MARK: Effects & Methods
extension MonthSchedule {
    private func createInitialDisplayDate(state: inout State) {
        // clear current displayDays
        state.monthCalendar.removeAll()
        
        // Initially set previous month as first
        let previousOriginDay = calendarKitClient.previousFocusDay(from: state.originDay)
        let previousDisplayDays = calendarKitClient.displayDays(from: previousOriginDay)
        state.monthCalendar.append(
            MonthCalendar.State(
                originDay: previousOriginDay,
                displayDays: previousDisplayDays
            )
        )
        
        // Initially set this month as second
        let displayDays = calendarKitClient.displayDays(from: state.originDay)
        state.monthCalendar.append(
            MonthCalendar.State(
                originDay: state.originDay,
                displayDays: displayDays
            )
        )
        
        // Initially set next month as third
        let nextOriginDay = calendarKitClient.nextFocusDay(from: state.originDay)
        let nextDisplayDays = calendarKitClient.displayDays(from: nextOriginDay)
        state.monthCalendar.append(
            MonthCalendar.State(
                originDay: nextOriginDay,
                displayDays: nextDisplayDays
            )
        )
    }
    
    private func createNextDisplayDate(state: inout State) {
        // safe guard for index
        guard state.monthCalendar.indices.contains(state.currentPage) else {
            return
        }
        
        // inserting new dates at index 0 and remove last item
        if state.currentPage == 0 {
            // get first page origin day
            let currentFirstOriginDay = state.monthCalendar[0].originDay
            // get new origin day from first day, to add as first page
            let newOriginDay = calendarKitClient.previousFocusDay(from: currentFirstOriginDay)
            print("🍎 Current : \(currentFirstOriginDay.date.startOfDate)")
            // create new display days
            let newDisplayDays = calendarKitClient.displayDays(from: newOriginDay)
            // add new created display days and add at first page
            state.monthCalendar.insert(
                MonthCalendar.State(
                    originDay: newOriginDay,
                    displayDays: newDisplayDays
                ),
                at: 0
            )
            
            // remove last page
            state.monthCalendar.removeLast()
            // adjust index
            state.currentPage = 1
            // update originDay to current middle page, i.e previous first day
            // since previous first day was changed to middle page
            state.originDay = currentFirstOriginDay
        }
        
        // append new dates at last index and remove firs item
        if state.currentPage == (state.monthCalendar.count - 1) {
            // get last page origin day
            let currentLastOriginDay = state.monthCalendar[state.monthCalendar.count - 1].originDay
            // get new origin day from last day, to add as first page
            let newOriginDay = calendarKitClient.nextFocusDay(from: currentLastOriginDay)
            print("🍎 Current : \(currentLastOriginDay.date.startOfDate)")
            // create new display days
            let newDisplayDays = calendarKitClient.displayDays(from: newOriginDay)
            // add new created display days and add at last page
            state.monthCalendar.append(
                MonthCalendar.State(
                    originDay: newOriginDay,
                    displayDays: newDisplayDays
                )
            )
            
            // remove first page
            state.monthCalendar.removeFirst()
            // adjust index
            state.currentPage = state.monthCalendar.count - 2
            // update originDay to current middle page, i.e previous last day
            // since previous last day was changed to middle page
            state.originDay = currentLastOriginDay
        }
    }
}
