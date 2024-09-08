import Foundation
import ComposableArchitecture
import NavigationBarFeature
import SharedUIs

@Reducer
public struct Settings {
    @Reducer(state: .equatable)
    public enum Destination {
        case startWeekOn(StartWeekOn)
        case appearance(ThemePicker)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Presents var destination: Destination.State?
        var navigationBar: NavigationBar.State = NavigationBar.State(
            title: "",
            subTitle: #localized("Settings"), // TODO:
            secondTrailingItem: "xmark"
        )
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        case navigationBar(NavigationBar.Action)
        
        case startWeekOnMenuTapped
        case appearanceTapped
    }
    
    public init() { }
    
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .navigationBar(.delegate(.executeSecondAction)):
                return .run { _ in
                    await dismiss()
                }
                
            case .startWeekOnMenuTapped:
                state.destination = .startWeekOn(StartWeekOn.State())
                return .none
                
            case .appearanceTapped:
                state.destination = .appearance(ThemePicker.State())
                return .none
                
            case .navigationBar, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        Scope(state: \.navigationBar, action: \.navigationBar) {
            NavigationBar()
        }
    }
}
