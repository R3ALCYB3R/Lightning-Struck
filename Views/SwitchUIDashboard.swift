import SwiftUI

struct SwitchUIDashboard: View {
    // This controls the "Glow" effect for the dashboard
    @State private var isGlowing = false
    
    var body: some View {
        ZStack {
            // Dark Background for the console vibe
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header Area
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                    
                    Text("R3ALCYB3R") // Your Dev Handle
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("10:26 PM") // You can make this dynamic later
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

                Spacer()

                // Central Icon with a Pulse Animation
                ZStack {
                    Circle()
                        .stroke(Color.red.opacity(0.5), lineWidth: 2)
                        .scaleEffect(isGlowing ? 1.2 : 1.0)
                        .opacity(isGlowing ? 0.0 : 1.0)
                    
                    Image("SwitchUI-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(25)
                }
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                        isGlowing = true
                    }
                }

                Text("SwitchUI Loaded")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                // Quick Launch Button
                Button(action: {
                    // This is where you'll trigger the emulator JIT later
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }) {
                    Text("START EMULATOR")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }

                Spacer()
                
                // Bottom Status Bar
                HStack {
                    Label("JIT: Ready", systemImage: "bolt.fill")
                    Spacer()
                    Label("Battery: 100%", systemImage: "battery.100")
                }
                .font(.caption2)
                .foregroundColor(.gray)
                .padding()
            }
        }
    }
}

// Needed so you can see it in the Xcode Preview
struct SwitchUIDashboard_Previews: PreviewProvider {
    static var previews: some View {
        SwitchUIDashboard()
    }
}
