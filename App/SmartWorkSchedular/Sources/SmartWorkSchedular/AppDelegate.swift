import AppFeature
import ComposableArchitecture
import Foundation
import LoggerClient
import SharedUIs
import UIKit

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
        Reduce { _, action in
            switch action {
            case .didFinishLaunching:
                // Logging
                logger.setLogEnabled(true)
                logger.setLogLevel(.debug)
                logger.debug("didFinishLaunching")

                // Fonts
                CustomFontManager.registerFonts()

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
    private(set) lazy var viewStore = ViewStore(store) { bindingViewStore in
        /* observe */bindingViewStore
    }
    
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        viewStore.send(.didFinishLaunching)
        
        return true
    }
}
