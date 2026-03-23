import SwiftUI

struct LaunchView: View {
    @State private var isActive = false
    @State private var logoScale = 0.5
    @State private var logoOpacity = 0.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.9, green: 0.1, blue: 0.1), Color(red: 0.5, green: 0, blue: 0)], 
                    startPoint: .top, 
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    Image("SwitchUI-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .cornerRadius(32)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    Text("SwitchUI")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                    self.logoScale = 1.0
                    self.logoOpacity = 1.0
                }
                
                // Haptic for iPhone 8 Plus
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation { self.isActive = true }
                }
            }
        }
    }
}
