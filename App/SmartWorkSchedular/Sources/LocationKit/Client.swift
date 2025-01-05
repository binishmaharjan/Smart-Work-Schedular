import CoreLocation
import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct LocationKitClient {
    public enum DelegateEvent: Equatable {
        case didUpdateResults([Location])
        case didFailWithError(Error)
        
        public static func == (lhs: LocationKitClient.DelegateEvent, rhs: LocationKitClient.DelegateEvent) -> Bool {
            switch (lhs, rhs) {
            case (.didUpdateResults(let lhs), .didUpdateResults(let rhs)):
                return lhs == rhs
                
            case (.didFailWithError(let lhs), .didFailWithError(let rhs)):
                return lhs.localizedDescription == rhs.localizedDescription
                
            default:
                return false
            }
        }
    }

    public var searchLocations: @Sendable (_ query: String) -> Void
    public var delegate: @Sendable () -> AsyncStream<DelegateEvent> = { .never }
}

// MARK: Dependency Values
extension DependencyValues {
    public var locationKitClient: LocationKitClient {
        get { self[LocationKitClient.self] }
        set { self[LocationKitClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension LocationKitClient: TestDependencyKey {
    public static var testValue = Self()
    public static var previewValue = Self.noop
    
    public static var noop = LocationKitClient(
        searchLocations: { _ in },
        delegate: { AsyncStream { _ in } }
    )
}
