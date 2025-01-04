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
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Presents var destination: Destination.State?
        var kind: Kind = .new
        var title: String = ""
        var icon: String = ""
        var color: String = ""
        var isAllDay: Bool = false
        var startDate = HourAndMinute(hour: 9, minute: 0)
        var endDate = HourAndMinute(hour: 17, minute: 0)
        var breakTime = HourAndMinute(hour: 0, minute: 0)
        var alert: String = ""
        var location: String = ""
        var memo: String = ""
    }
    
    public enum Action: ViewAction, BindableAction {
        public enum View {
            case addBreakButtonTapped
            case startDateButtonTapped
            case endDateButtonTapped
            case cancelButtonTapped
            case saveButtonTapped
        }
        
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case view(View)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    @Dependency(\.dismiss) private var dismiss
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.addBreakButtonTapped):
                logger.debug("view.addBreakButtonTapped")
                
                state.destination = .breakTimePicker(.init(hour: state.breakTime.hour, minute: state.breakTime.minute))
                return .none
                
            case .view(.startDateButtonTapped):
                logger.debug("view.startDateButtonTapped")
                
                state.destination = .startDatePicker(.init(hour: state.startDate.hour, minute: state.startDate.minute))
                return .none
                
            case .view(.endDateButtonTapped):
                logger.debug("view.endDateButtonTapped")
                
                state.destination = .endDatePicker(.init(hour: state.endDate.hour, minute: state.endDate.minute))
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
                
            case .view, .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
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
