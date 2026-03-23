import SwiftUI

@main
struct SwitchUIApp: App {
    var body: some Scene {
        WindowGroup {
            // This starts the app with your Red animation
            LaunchView()
                .preferredColorScheme(.dark)
        }
    }
}
