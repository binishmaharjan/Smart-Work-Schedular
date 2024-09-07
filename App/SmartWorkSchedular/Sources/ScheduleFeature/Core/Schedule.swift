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
        @Shared(.appStorage("sharedStateDisplayMode")) var displayMode = DisplayMode.month
        @Shared(.appStorage("sharedStateStartOfWeekday")) var startOfWeekday = Weekday.sunday
    }
    
    public enum Action: BindableAction {
        case destination(PresentationAction<Destination.Action>)
        case navigationBar(NavigationBar.Action)
        case binding(BindingAction<State>)
        
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
                return .send(.updateDisplayDates)
                
            case .binding(\.startOfWeekday):
                print("Changed To: \(state.startOfWeekday)")
                return .none
                
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
                state.displayMode = .month

                return .send(.updateDisplayDates)
                
            case .weekButtonPressed:
                state.displayMode = .week
                return .send(.updateDisplayDates)
                
            case .dayButtonPressed:
                state.displayMode = .day
                return .send(.updateDisplayDates)
                
            case .navigationBar(.delegate(.executeFirstAction)):
                print("First")
                return .none
                
            case .navigationBar(.delegate(.executeSecondAction)):
                print("Second")
                state.destination = .settings(Settings.State())
                return .none
                
            case .destination, .navigationBar, .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        Scope(state: \.navigationBar, action: \.navigationBar) {
            NavigationBar()
        }
    }
}
