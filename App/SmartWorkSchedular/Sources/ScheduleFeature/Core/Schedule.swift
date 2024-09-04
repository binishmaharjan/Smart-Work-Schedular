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
            subTitle: "September", // TODO:
            firstTrailingItem: "plus",
            secondTrailingItem: "gearshape.fill"
        )
        
        var focusDay = Day(date: .now)
        var displayDays: IdentifiedArrayOf<Day> = []
        @Shared(.displayMode) var _displayMode: Int = 0
        var displayMode: DisplayMode { DisplayMode(rawValue: _displayMode) ?? .month }
        @Shared(.startOfWeekday) var _startOfWeekday: Int = 0
        var startOfWeekday: Weekday { Weekday(rawValue: _startOfWeekday) ?? .sunday }
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        case navigationBar(NavigationBar.Action)
        
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
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .send(.updateDisplayDates)
                
            case .updateDisplayDates:
                let displayDays = calendarKitClient.displayDays(state.focusDay)
                state.displayDays = .init(uniqueElements: displayDays)
                return .none
                
            case .previousButtonPressed:
                state.focusDay = calendarKitClient.previousFocusDay(state.focusDay)
                return .send(.updateDisplayDates)
                
            case .nextButtonPressed:
                state.focusDay = calendarKitClient.nextFocusDay(state.focusDay)
                return .send(.updateDisplayDates)
                
            case .monthButtonPressed:
                state._displayMode = 0
                return .send(.updateDisplayDates)
                
            case .weekButtonPressed:
                state._displayMode = 1
                return .send(.updateDisplayDates)
                
            case .dayButtonPressed:
                state._displayMode = 2
                return .send(.updateDisplayDates)
                
            case .navigationBar(.delegate(.executeFirstAction)):
                print("First")
                return .none
                
            case .navigationBar(.delegate(.executeSecondAction)):
                print("Second")
                state.destination = .settings(Settings.State())
                return .none
                
            case .destination, .navigationBar:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        Scope(state: \.navigationBar, action: \.navigationBar) {
            NavigationBar()
        }
    }
}
