import ColorPaletteFeature
import ComposableArchitecture
import Foundation
import SharedUIs

@Reducer
public struct IconPicker {
    @Reducer(state: .equatable)
    public enum Destination {
        case colorPalette(ColorPalette)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Presents var destination: Destination.State?
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
            case showColorPalette
        }
        
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
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
                
            case .view(.showColorPalette):
                logger.debug("view.showColorPalette")
                
                state.destination = .colorPalette(.init())
                return .none
                
            case .destination(.presented(.colorPalette(.delegate(.updateColor(let color))))):
                logger.debug("destination.presented.colorPalette.delegate.updateColor: \(color)")
                
                state.selectedColor = .custom
                return .send(.delegate(.updateColor(color)))
                
            case .delegate, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
