import SwiftUI
import NouriKit

@main
struct NouriApp: App {
    var body: some Scene {
        WindowGroup {
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("-gallery") {
                DesignGalleryScreen()
            } else {
                RootView()
            }
            #else
            RootView()
            #endif
        }
    }
}
