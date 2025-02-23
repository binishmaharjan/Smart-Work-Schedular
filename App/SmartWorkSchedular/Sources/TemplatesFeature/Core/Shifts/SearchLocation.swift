import ComposableArchitecture
import Foundation
import LocationKit
import SharedModels

@Reducer
public struct SearchLocation {
    @Reducer(state: .equatable)
    public enum Destination {
        public enum Alert: Equatable { }
        
        case alert(AlertState<Alert>)
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(searchText: String = "") {
            self.searchText = searchText
        }
        
        @Presents var destination: Destination.State?
        var searchText: String
        var locations: IdentifiedArrayOf<Location> = []
    }
    
    public enum Action: ViewAction, BindableAction {
        @CasePathable
        public enum Delegate {
            case updateLocation(String)
        }
        
        public enum View {
            case onAppear
            case searchTextChanged(String)
            case locationSelected(Location)
        }
        
        case view(View)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case locationKit(LocationKitClient.DelegateEvent)
    }
    
    public init() { }
    
    @Dependency(\.loggerClient) private var logger
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.locationKitClient) private var locationKitClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.onAppear):
                logger.debug("view.onAppear")
                
                let locationEventStream = locationKitClient.delegate()
                return .run { send in
                    await withThrowingTaskGroup(of: Void.self) { group in
                        group.addTask {
                            for await event in locationEventStream {
                                await send(.locationKit(event))
                            }
                        }
                    }
                }
                
            case .view(.searchTextChanged(let text)):
                logger.debug("view.searchTextChanged")
                
                guard text.isNotEmpty else {
                    state.locations.removeAll()
                    return .none
                }
                
                locationKitClient.searchLocations(query: text)
                return .none
                
            case .view(.locationSelected(let location)):
                logger.debug("view.locationSelected")
                
                return .run { send in
                    await send(.delegate(.updateLocation(location.title)))
                    await dismiss()
                }
                
            case .locationKit(.didUpdateResults(let results)):
                logger.debug("locationKit.didUpdateResults")
                
                state.locations.removeAll()
                state.locations = IdentifiedArrayOf(uniqueElements: results)
                return .none
                
            case .locationKit(.didFailWithError(let error)):
                logger.debug("locationKit.didFailWithError")
                
                state.destination = .alert(.onError(error))
                return .none
                
            case .view, .binding, .delegate, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
