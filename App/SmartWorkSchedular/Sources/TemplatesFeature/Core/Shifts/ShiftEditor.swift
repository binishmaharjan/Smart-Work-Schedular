import ComposableArchitecture
import Foundation
import SharedUIs

@Reducer
public struct ShiftEditor {
    @ObservableState
    public struct State: Equatable {
        public init() { 
            self.kind = .new
            self.title = ""
            self.icon = ""
            self.color = ""
            self.isAllDay = false
            self.startDate = ""
            self.endDate = ""
            self.breakTime = []
            self.alert = ""
            self.location = ""
            self.memo = ""
        }
        
        var kind: Kind
        var title: String
        var icon: String
        var color: String
        var isAllDay: Bool
        var startDate: String
        var endDate: String
        var breakTime: [String]
        var alert: String
        var location: String
        var memo: String
    }
    
    public enum Action: ViewAction, BindableAction {
        public enum View {
        }
        
        case binding(BindingAction<State>)
        case view(View)
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { _, action in
            switch action {
            case .view, .binding:
                return .none
            }
        }
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
