import SwiftUI

@main
struct SwitchUIApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView() // Starts with your red animation
                .preferredColorScheme(.dark)
        }
    }
}
