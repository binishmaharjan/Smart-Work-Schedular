import Foundation
import ComposableArchitecture
import AppearanceKit

@Reducer
public struct Appearance {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @SharedReader(.appearanceMode) var currentMode = AppearanceMode.system
        var modes: IdentifiedArrayOf<AppearanceMode> = .init(uniqueElements: AppearanceMode.allCases)
    }
    
    public enum Action {
        case onAppear
        case modeSelected(AppearanceMode)
    }
    
    public init() { }

    @Dependency(\.appearanceKitClient) private var apperanceKitClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .modeSelected(let mode):
                apperanceKitClient.updateAppearance(to: mode)
                return .none
            }
        }
    }
}
