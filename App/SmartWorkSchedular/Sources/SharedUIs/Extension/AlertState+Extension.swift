import Foundation
import ComposableArchitecture

extension AlertState {
    /// Common Alert for error
    public static func onError(_ error: Error) -> AlertState {
        AlertState {
            TextState(#localized("Error"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState(error.localizedDescription)
        }
    }
}
