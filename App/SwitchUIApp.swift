import SwiftUI

@main
struct SwitchUIApp: App {
    // This tracks the app's state (Active, Background, Inactive)
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            // This starts the app with your Red animated Launch Screen
            LaunchView()
                // Forces Dark Mode to match the Switch console look
                .preferredColorScheme(.dark) 
        }
    }
}
