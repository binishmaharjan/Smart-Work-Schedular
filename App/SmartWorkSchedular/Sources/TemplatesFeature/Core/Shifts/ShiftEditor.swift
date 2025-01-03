import ComposableArchitecture
import Foundation
import SharedUIs

@Reducer
public struct ShiftEditor {
    @Reducer(state: .equatable)
    public enum Destination {
        case timePicker(TimePicker)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Presents var destination: Destination.State?
        var kind: Kind = .new
        var title: String = ""
        var icon: String = ""
        var color: String = ""
        var isAllDay: Bool = false
        var startHour: Int = 9
        var startMinute: Int = 0
        var endHour: Int = 17
        var endMinutes: Int = 0
        var breakTime: [String] = []
        var alert: String = ""
        var location: String = ""
        var memo: String = ""
    }
    
    public enum Action: ViewAction, BindableAction {
        public enum View {
            case addBreakButtonTapped
        }
        
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case view(View)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.addBreakButtonTapped):
                logger.debug("view.addBreakButtonTapped")
                
                state.destination = .timePicker(.init(hour: 16, minute: 20))
                return .none
                
            case .view, .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: Kind
extension ShiftEditor {
    enum Kind: String, Identifiable {
        case new
        case edit
        
        var id: String { rawValue }
        
        var title: String {
            switch self {
            case .new:
                return #localized("New Shift")
                
            case .edit:
                return #localized("Edit Shift")
            }
        }
    }
}
