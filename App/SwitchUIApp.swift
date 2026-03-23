import SwiftUI

@main
struct SwitchUIApp: App {
    // This tells the app to stay in memory while you're playing
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            // We start with LaunchView to see the cool animation
            LaunchView()
                .preferredColorScheme(.dark) // Keeps the Switch vibe
        }
    }
}
