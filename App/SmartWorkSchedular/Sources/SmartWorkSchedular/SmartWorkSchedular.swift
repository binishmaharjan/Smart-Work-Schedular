import SwiftUI
import AppFeature

public protocol App: SwiftUI.App {
    var appDelegate: AppDelegate { get }
}

extension App {
    public var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
