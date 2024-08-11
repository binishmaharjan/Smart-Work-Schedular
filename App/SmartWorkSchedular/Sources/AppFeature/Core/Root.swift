import Foundation
import ComposableArchitecture
import TutorialFeature
import MainTabFeature
import LoggerClient

@Reducer
public struct Root {
    @Reducer(state: .equatable)
    public enum Destination {
        case launch(Launch)
        case tutorial(Tutorial)
        case mainTab(MainTab)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Presents var destination: Destination.State? = .launch(.init())
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        
        case onAppear
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                logger.debug("onAppear")
                
                return .none
                
            case .destination(.presented(.launch(.delegate(.showTutorial)))):
                logger.debug("destination.presented.launch.delegate.showTutorial")
                
                state.destination = .tutorial(.init())
                return .none
                
            case .destination(.presented(.launch(.delegate(.showMainTab)))):
                logger.debug("destination.presented.launch.delegate.showMainTab")
                
                state.destination = .mainTab(.init())
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
