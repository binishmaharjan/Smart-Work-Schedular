import Foundation
import UIKit
import ComposableArchitecture
import AppFeature
import LoggerClient

public final class AppDelegate: NSObject, UIApplicationDelegate {
    private var _store: StoreOf<AppDelegateReducer>?

    var store: StoreOf<AppDelegateReducer> {
        if let _store {
            return _store
        }
        let store = Store(initialState: AppDelegateReducer.State(), reducer: AppDelegateReducer.init)
        self._store = store
        return store
    }
    private(set) lazy var viewStore = ViewStore(store, observe: { $0 })
    
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        viewStore.send(.didFinishLaunching)
        
        return true
    }
}

// MARK: Reducer
@Reducer
struct AppDelegateReducer {
    @ObservableState
    struct State: Equatable {
        var rootState = Root.State()
    }
    
    enum Action {
        case didFinishLaunching
        case rootAction(Root.Action)
    }
    
    @Dependency(\.loggerClient) private var logger
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didFinishLaunching:
                logger.debug("didFinishLaunching")
                
                return .none
                
            case .rootAction:
                return .none
            }
        }

        Scope(state: \.rootState, action: \.rootAction) {
            Root()
        }
    }
}
