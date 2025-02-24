import ComposableArchitecture
import Foundation
import SharedModels
import SharedUIs

@Reducer
public struct ShiftEditor {
    @Reducer(state: .equatable)
    public enum Destination {
        case startDatePicker(TimePicker)
        case endDatePicker(TimePicker)
        case breakTimePicker(TimePicker)
        case notificationTime(NotificationTimePicker)
        case searchLocation(SearchLocation)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Presents var destination: Destination.State?
        var iconPicker = IconPicker.State()
        var isIconToggleOpen = false
        
        var kind: Kind = .new
        var title: String = ""
        var icon: String = IconPreset.Image.sunMax.rawValue
        var hexCode: HexCode = IconPreset.Color.blue.rawValue
        var isAllDay: Bool = false
        var startDate = HourAndMinute(hour: 9, minute: 0)
        var endDate = HourAndMinute(hour: 17, minute: 0)
        var breakTime = HourAndMinute.empty
        var perHourWage: String = ""
        var notificationTime: NotificationTimeOption = .none
        var location: String = ""
        var memo: String = ""
    }
    
    public enum Action: ViewAction, BindableAction {
        public enum View {
            case onAppear
            case iconButtonTapped
            case breakButtonTapped
            case breakClearButtonTapped
            case startDateButtonTapped
            case endDateButtonTapped
            case cancelButtonTapped
            case saveButtonTapped
            case alertButtonTapped
            case locationButtonTapped
            case locationClearButtonTapped
        }
        
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case iconPicker(IconPicker.Action)
        case view(View)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.iconButtonTapped):
                logger.debug("view.iconButtonTapped")
                
                state.isIconToggleOpen.toggle()
                return .none
                
            case .view(.breakButtonTapped):
                logger.debug("view.addBreakButtonTapped")
                
                state.destination = .breakTimePicker(
                    .init(title: #localized("Break"), hour: state.breakTime.hour, minute: state.breakTime.minute)
                )
                return .none
                
            case .view(.breakClearButtonTapped):
                logger.debug("view.breakClearButtonTapped")
                
                state.breakTime = .empty
                return .none
                
            case .view(.startDateButtonTapped):
                logger.debug("view.startDateButtonTapped")
                
                state.destination = .startDatePicker(
                    .init(title: #localized("Starts"), hour: state.startDate.hour, minute: state.startDate.minute)
                )
                return .none
                
            case .view(.endDateButtonTapped):
                logger.debug("view.endDateButtonTapped")
                
                state.destination = .endDatePicker(
                    .init(title: #localized("Ends"), hour: state.endDate.hour, minute: state.endDate.minute)
                )
                return .none
                
            case .view(.alertButtonTapped):
                logger.debug("view.saveButtonTapped")
                
                state.destination = .notificationTime(.init(option: state.notificationTime))
                return .none
                
            case .view(.locationButtonTapped):
                logger.debug("view.locationButtonTapped")
                
                state.destination = .searchLocation(.init(searchText: state.location))
                return .none
                
            case .view(.locationClearButtonTapped):
                logger.debug("view.locationClearButtonTapped")
                
                state.location = ""
                return .none
                
            case .view(.cancelButtonTapped):
                logger.debug("view.cancelButtonTapped")
                
                return .run { _ in
                    await dismiss()
                }
                
            case .view(.saveButtonTapped):
                logger.debug("view.saveButtonTapped")
                
                return .run { _ in
                    await dismiss()
                }
                
            case .iconPicker(.delegate(.updateIcon(let icon))):
                logger.debug("iconPicker.delegate.updateIcon: \(icon)")
                
                state.icon = icon
                return .none
                
            case .iconPicker(.delegate(.updateColor(let hexCode))):
                logger.debug("iconPicker.delegate.updateColor: \(hexCode)")
                
                state.hexCode = hexCode
                return .none
                
            case .destination(.presented(.breakTimePicker(.delegate(.saveTime(let time))))):
                logger.debug("destination.presented.breakTimePicker.delegate.saveTime: \(time.hour):\(time.minute)")
                
                state.breakTime = time
                return .none
                
            case .destination(.presented(.startDatePicker(.delegate(.saveTime(let time))))):
                logger.debug("destination.presented.startDatePicker.delegate.saveTime: \(time.hour):\(time.minute)")
                
                state.startDate = time
                return .none
                
            case .destination(.presented(.endDatePicker(.delegate(.saveTime(let time))))):
                logger.debug("destination.presented.endDatePicker.delegate.saveTime: \(time.hour):\(time.minute)")
                
                state.endDate = time
                return .none
                
            case .destination(.presented(.notificationTime(.delegate(.updateOption(let option))))):
                logger.debug("destination.presented.notificationTime.delegate.updateOption: \(option)")
                
                state.notificationTime = option
                return .none
                
            case .destination(.presented(.searchLocation(.delegate(.updateLocation(let location))))):
                logger.debug("destination.presented.searchLocation.delegate.updateLocation: \(location)")
                
                state.location = location
                return .none
                
            case .view, .binding, .destination, .iconPicker:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        Scope(state: \.iconPicker, action: \.iconPicker) {
            IconPicker()
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
