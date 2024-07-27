import Foundation
import ComposableArchitecture
import TutorialFeature
import MainTabFeature

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
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .destination:
                return .none
            }
        }
    }
}
