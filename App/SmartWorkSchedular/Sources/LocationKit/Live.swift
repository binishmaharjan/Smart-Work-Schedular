import Dependencies
import Foundation
import LoggerClient
import MapKit

// MARK: Dependency (liveValue)
extension LocationKitClient: DependencyKey {
    public static let liveValue = Self.live()
}

extension LocationKitClient {
    public static func live() -> LocationKitClient {
        let session = Session()
        
        return LocationKitClient(
            searchLocations: { session.searchLocations(query: $0) },
            delegate: { session.delegate() }
        )
    }
}
extension LocationKitClient {
    final class Session {
        @Dependency(\.loggerClient) var logger
        var searchCompleter = MKLocalSearchCompleter()
        
        func searchLocations(query: String) {
            searchCompleter.queryFragment = query
        }
        
        func delegate() -> AsyncStream<DelegateEvent> {
            AsyncStream { continuation in
                let delegate = Delegate(continuation: continuation)
                searchCompleter.delegate = delegate
                continuation.onTermination = { _ in
                    _ = delegate
                }
            }
        }
    }
}

extension LocationKitClient {
    fileprivate class Delegate: NSObject, MKLocalSearchCompleterDelegate {
        let continuation: AsyncStream<LocationKitClient.DelegateEvent>.Continuation
        
        init(continuation: AsyncStream<LocationKitClient.DelegateEvent>.Continuation) {
            self.continuation = continuation
        }
        
        deinit {
            continuation.finish() // TODO: Do i need this?
        }
        
        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            let results = completer.results
            let locations = results.map { Location(title: $0.title, subTitle: $0.subtitle) }
            continuation.yield(.didUpdateResults(locations))
        }
        
        func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
            continuation.yield(.didFailWithError(LocationError.searchFailed(error.localizedDescription)))
        }
    }
}
