import SwiftUI

struct LaunchView: View {
    // State variables for the "Pop" and "Fade" animation
    @State private var isActive = false
    @State private var logoScale = 0.5
    @State private var logoOpacity = 0.0
    
    var body: some View {
        if isActive {
            // This matches the file name in your "Views" folder screenshot
            SwitchUIDashboard()
        } else {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [Color(red: 0.9, green: 0.1, blue: 0.1), Color(red: 0.5, green: 0, blue: 0)], 
                    startPoint: .top, 
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // The Logo
                    Image("SwitchUI-icon")
                        .resizable()        // Modifier 1: Allows resizing
                        .scaledToFit()      // Modifier 2: Keeps proportions
                        .frame(width: 160, height: 160) // Modifier 3: Sets size
                        .cornerRadius(32)   // Modifier 4: Rounds corners
                        .scaleEffect(logoScale) // Modifier 5: Controls "Pop"
                        .opacity(logoOpacity)   // Modifier 6: Controls "Fade"
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                    
                    // The App Name
                    Text("SwitchUI")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(2) // Adds a little space between letters
                }
            }
            .onAppear {
                // Start the animation when the screen appears
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0)) {
                    self.logoScale = 1.0
                    self.logoOpacity = 1.0
                }
                
                // Trigger a "Thump" haptic for the iPhone 8 Plus
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()

                // Wait 2.5 seconds, then switch to the Dashboard
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

// Preview provider for testing on Windows/Mac
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
