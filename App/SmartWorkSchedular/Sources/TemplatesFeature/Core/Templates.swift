import ComposableArchitecture
import Foundation
import NavigationBarFeature
import SharedUIs

@Reducer
public struct Templates {
    @ObservableState
    public struct State: Equatable {
        public init() {
            self.selectedKind = .shift
            self.rotationList = RotationList.State()
            self.shiftList = ShiftList.State()
        }
        
        var selectedKind: Kind
        var shiftList: ShiftList.State
        var rotationList: RotationList.State
        var navigationBar = NavigationBar.State(
            title: "Templates",
            firstTrailingItem: "plus"
        )
    }
    
    public enum Action: ViewAction, BindableAction {
        public enum View {
            case onAppear
        }
        case binding(BindingAction<State>)
        case navigationBar(NavigationBar.Action)
        case view(View)
        
        case shiftList(ShiftList.Action)
        case rotationList(RotationList.Action)
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { _, action in
            switch action {
            case .navigationBar, .shiftList, .rotationList, .view, .binding:
                return .none
            }
        }
        
        Scope(state: \.shiftList, action: \.shiftList) {
            ShiftList()
        }
        
        Scope(state: \.rotationList, action: \.rotationList) {
            RotationList()
        }
        
        Scope(state: \.navigationBar, action: \.navigationBar) {
            NavigationBar()
        }
    }
}

// MARK: - Kind
extension Templates {
    enum Kind: String, CaseIterable, Identifiable {
        case shift = "shifts"
        case rotation = "rotations"
        
        var id: String { rawValue }
        
        var title: String {
            switch self {
            case .shift:
                return #localized("Shifts")
                
            case .rotation:
                return #localized("Rotations")
            }
        }
    }
}
