import CalendarKit
import ComposableArchitecture
import Foundation
import LoggerClient

@Reducer
public struct CalendarMode {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        // Shared State
        @Shared(.displayMode) var displayMode = DisplayMode.month
        
        var displayModeList = DisplayMode.allCases
    }
    
    public enum Action: ViewAction {
        public enum View {
            case onDisplayModeSelected(DisplayMode)
        }
        
        case view(View)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.onDisplayModeSelected(let displayMode)):
                guard displayMode != state.displayMode else {
                    return .none
                }
                logger.debug("displayMode Changed to: \(displayMode)")
                
                state.displayMode = displayMode
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}

