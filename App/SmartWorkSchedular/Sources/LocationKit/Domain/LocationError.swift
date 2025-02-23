import Foundation

/// Error wrapper for failed location search
public enum LocationError: Error {
    case searchFailed(String)
}
