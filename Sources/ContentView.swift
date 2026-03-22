import SwiftUI

struct GameSlot: Identifiable {
    let id = UUID()
}

struct ContentView: View {
    // 8 empty slots just like the real home screen
    let slots = Array(repeating: GameSlot(), count: 8)
    
    var body: some View {
        ZStack {
            // The signature light-grey Switch background
            Color(red: 0.93, green: 0.93, blue: 0.93)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Top Status Bar
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("1:27 PM")
                        .font(.system(size: 20, weight: .medium))
                    Image(systemName: "wifi")
                    Image(systemName: "battery.100")
                }
                .padding(.horizontal, 50)
                .padding(.top, 20)
                
                Spacer()
                
                // 2. Main Game Grid (All Empty)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(slots) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .frame(width: 210, height: 210)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 50)
                }
                .frame(height: 220)
                
                Spacer()
                
                // 3. Bottom Utility Row
                HStack(spacing: 20) {
                    // Standard Buttons
                    CircleButton(icon: "envelope.fill", color: .red)     // News
                    CircleButton(icon: "cart.fill", color: .orange)    // eShop
                    CircleButton(icon: "photo.fill", color: .blue)      // Album
                    CircleButton(icon: "gamecontroller.fill", color: .gray) // Controllers
                    
                    // YOUR CUSTOM BUTTON: Import Game
                    Button(action: {
                        print("Import Game Triggered")
                    }) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 55, height: 55)
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            Text("Import Game")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    
                    CircleButton(icon: "gearshape.fill", color: .gray)  // Settings
                    CircleButton(icon: "power", color: .gray)           // Sleep
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// Helper view for the circular bottom buttons
struct CircleButton: View {
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 55, height: 55)
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 22))
            }
            // Text is hidden or tiny in real UI, keeping it clean
            Text(" ") 
                .font(.system(size: 10))
        }
    }
}
