import Foundation
import ComposableArchitecture
import AppearanceKit

@Reducer
public struct Appearance {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @SharedReader(.appStorage("apperance")) var currentMode = Mode.system
        var modes: IdentifiedArrayOf<Mode> = .init(uniqueElements: Mode.allCases)
    }
    
    public enum Action {
        case onAppear
        case modeSelected(Mode)
    }
    
    public init() { }
    // Pass to Client, Update inside the specified module(update calendar)
    @Dependency(\.appearanceKitClient) private var apperanceKitClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .modeSelected(let mode):
                apperanceKitClient.updateAppearance(mode)
                return .none
            }
        }
    }
}
