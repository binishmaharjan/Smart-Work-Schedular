import AppFeature
import SwiftUI

public protocol App: SwiftUI.App {
    var appDelegate: AppDelegate { get }
}

extension App {
    public var body: some Scene {
        WindowGroup {
            RootView(
                store: appDelegate.store.scope(
                    state: \.rootState,
                    action: \.rootAction
                )
            )
        }
    }
}
