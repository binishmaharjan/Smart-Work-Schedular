import ComposableArchitecture
import Foundation

@Reducer
public struct ColorPalette {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        var selectedColorHex: String = ""
    }
    
    public enum Action: ViewAction {
        @CasePathable
        public enum Delegate: Equatable {
            case updateColor(String)
        }
        
        public enum View {
            case colorSelected(String)
        }
        
        case delegate(Delegate)
        case view(View)
    }
    
    public init() { }
    
    public var body: some
    ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.colorSelected(let hexColor)):
                state.selectedColorHex = hexColor
                return .send(.delegate(.updateColor(state.selectedColorHex)))
                
            case .delegate:
                return .none
            }
        }
    }
}
