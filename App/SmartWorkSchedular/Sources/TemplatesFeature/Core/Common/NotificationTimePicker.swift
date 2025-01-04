import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct NotificationTimePicker {
    @ObservableState
    public struct State: Equatable {
        public init(option: NotificationTimeOption = .none) {
            self.selectedOptions = option
        }
        
        var selectedOptions: NotificationTimeOption
    }
    
    public enum Action: ViewAction {
        @CasePathable
        public enum Delegate {
            case updateOption(NotificationTimeOption)
        }
        public enum View {
            case optionSelected(NotificationTimeOption)
        }
        
        case view(View)
        case delegate(Delegate)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.optionSelected(let option)):
                logger.debug("optionSelected: \(option.rawValue)")
                
                state.selectedOptions = option
                return .run { send in
                    await send(.delegate(.updateOption(option)))
                    await dismiss()
                }
                
            case .delegate, .view:
                return .none
            }
        }
    }
}
