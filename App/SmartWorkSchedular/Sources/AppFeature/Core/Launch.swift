import ComposableArchitecture
import Foundation
import LoggerClient
import UserDefaultsClient

@Reducer
public struct Launch {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action {
        @CasePathable
        public enum Delegate: Equatable {
            case showTutorial
            case showMainTab
        }

        case delegate(Delegate)
        
        case onAppear
    }
    
    public init() { }
    
    @Dependency(\.userDefaultsClient) private var userDefaultsClient
    @Dependency(\.loggerClient) private var logger
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { _, action in
            switch action {
            case .onAppear:
                logger.debug("onAppear")
                
                let isTutorialComplete = userDefaultsClient.isTutorialComplete()
                if isTutorialComplete {
                    return .send(.delegate(.showMainTab))
                } else {
                    return .send(.delegate(.showTutorial))
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
