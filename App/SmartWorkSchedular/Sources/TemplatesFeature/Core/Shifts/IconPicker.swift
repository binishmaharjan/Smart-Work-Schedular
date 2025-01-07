import ComposableArchitecture
import Foundation
import SharedUIs

@Reducer
public struct IconPicker {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        var selectedImage: IconPreset.Image = .sunMax
        var selectedColor: IconPreset.Color = .blue
    }
    
    public enum Action: ViewAction {
        @CasePathable
        public enum Delegate {
            case updateIcon(String)
            case updateColor(HexCode)
        }
    
        public enum View {
            case imageTapped(IconPreset.Image)
            case colorTapped(IconPreset.Color)
        }
        
        case delegate(Delegate)
        case view(View)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.imageTapped(let image)):
                logger.debug("view.imageTapped: \(image.rawValue)")
                
                state.selectedImage = image
                return .send(.delegate(.updateIcon(image.rawValue)))
                
            case .view(.colorTapped(let color)):
                logger.debug("view.colorTapped: \(color.rawValue)")
                
                state.selectedColor = color
                return .send(.delegate(.updateColor(color.rawValue)))
                
            case .delegate:
                return .none
            }
        }
    }
}
