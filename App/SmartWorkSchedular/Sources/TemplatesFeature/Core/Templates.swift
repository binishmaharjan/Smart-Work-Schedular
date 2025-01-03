import ComposableArchitecture
import Foundation
import NavigationBarFeature
import SharedUIs

@Reducer
public struct Templates {
    @Reducer(state: .equatable)
    public enum Destination {
        case shiftEditor(ShiftEditor)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {
            self.selectedKind = .shift
            self.rotationList = RotationList.State()
            self.shiftList = ShiftList.State()
        }
        
        @Presents var destination: Destination.State? = .shiftEditor(.init())
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
        case destination(PresentationAction<Destination.Action>)
        case navigationBar(NavigationBar.Action)
        case view(View)
        
        case shiftList(ShiftList.Action)
        case rotationList(RotationList.Action)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.onAppear):
                return .none
                
            case .navigationBar(.firstTrailingItemTapped):
                logger.debug("firstTrailingItemTapped")
                
                state.destination = state.selectedKind == .shift ? .shiftEditor(.init()) : nil
                return .none
                
            case .navigationBar, .shiftList, .rotationList, .view, .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
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
