import ComposableArchitecture
import Foundation
import ThemeKit

@Reducer
public struct ThemePicker {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @SharedReader(.appScheme) var currentMode = AppScheme.system
        var modes: IdentifiedArrayOf<AppScheme> = .init(uniqueElements: AppScheme.allCases)
    }
    
    public enum Action {
        case onAppear
        case modeSelected(AppScheme)
    }
    
    public init() { }

    @Dependency(\.themeKitClient) private var themeKitClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { _, action in
            switch action {
            case .onAppear:
                return .none
                
            case .modeSelected(let appScheme):
                themeKitClient.updateAppScheme(to: appScheme)
                return .none
            }
        }
    }
}
