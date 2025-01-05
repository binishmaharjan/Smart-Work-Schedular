import ComposableArchitecture
import Foundation
import LocationKit
import SharedModels

@Reducer
public struct SearchLocation {
    @ObservableState
    public struct State: Equatable {
        public init(searchText: String = "") {
            self.searchText = searchText
        }
        
        var searchText: String
        var locations: IdentifiedArrayOf<Location> = []
    }
    
    public enum Action: ViewAction, BindableAction {
        public enum View {
            case onAppear
            case searchTextChanged(String)
        }
        
        case view(View)
        case binding(BindingAction<State>)
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
                guard text.isNotEmpty else {
                    state.locations.removeAll()
                    return .none
                }
                
                locationKitClient.searchLocations(query: text)
                return .none
                
            case .locationKit(.didUpdateResults(let results)):
                state.locations.removeAll()
                state.locations = IdentifiedArrayOf(uniqueElements: results)
                return .none
                
            case .locationKit(.didFailWithError(let error)):
                return .none
                
            case .view, .binding:
                return .none
            }
        }
    }
}
