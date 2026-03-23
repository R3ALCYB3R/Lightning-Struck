import SwiftUI

struct LaunchView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View {
        if isActive {
            ContentView() // Goes to your main setup/dashboard after animation
        } else {
            ZStack {
                // Background matches your red/blue theme
                LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack {
                    Image("SwitchUI-icon") // This pulls from your Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .cornerRadius(20)
                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    Text("SwitchUI")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.80))
                }
            }
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 1.1 // The "Grow" effect
                    self.opacity = 1.0
                }
                // Wait 2 seconds, then switch to the main app
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
