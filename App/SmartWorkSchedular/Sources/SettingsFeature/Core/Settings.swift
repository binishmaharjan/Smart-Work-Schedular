import Foundation
import ComposableArchitecture

@Reducer
public struct Settings {
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action {
        case closeButtonTapped
    }
    
    public init() { }
    
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .closeButtonTapped:
                return .run { _ in
                    await dismiss()
                }
            }
        }
    }
}
