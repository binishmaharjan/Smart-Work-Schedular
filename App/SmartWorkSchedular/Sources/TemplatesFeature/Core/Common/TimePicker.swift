import ComposableArchitecture
import Foundation
import SharedModels

@Reducer
public struct TimePicker {
    @ObservableState
    public struct State: Equatable {
        public init(hour: Int, minute: Int) {
            self.hour = hour
            self.minute = minute
        }
        
        var hour: Int
        var minute: Int
    }
    
    public enum Action: ViewAction, BindableAction {
        @CasePathable
        public enum Delegate: Equatable {
            case saveTime(HourAndMinute)
        }

        public enum View {
            case saveButtonPressed
        }
        
        case view(View)
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.saveButtonPressed):
                return .run { [state] send in
                    await send(.delegate(.saveTime(HourAndMinute(hour: state.hour, minute: state.minute))))
                    await dismiss()
                }
                
            case .view, .binding, .delegate:
                return .none
            }
        }
    }
}
