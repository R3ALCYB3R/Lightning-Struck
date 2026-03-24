import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @State private var selectedGame: String? = "smash"
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    // Updated Game List including Roblox and Leo AI
    let games = [
        ("Super Smash Bros. Ultimate", "smash"),
        ("Mario Kart 8 Deluxe", "kart"),
        ("Roblox", "roblox"), // Add roblox.png to your Root!
        ("Leo AI Coder", "leo")   // Add leo.png to your Root!
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // TOP BAR
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.red)
                    Text("R3ALCYB3R")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("9:44 PM").foregroundColor(.white)
                }
                .padding(.horizontal, 40).padding(.top, 30)
                
                Spacer()

                // MAIN SELECTION (Games + Apps)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(games, id: \.1) { gameName, imageName in
                            VStack(spacing: 15) {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 280, height: 160)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedGame == imageName ? Color.red : Color.clear, lineWidth: 5)
                                            .shadow(color: .red, radius: selectedGame == imageName ? 15 : 0)
                                    )
                                    .scaleEffect(selectedGame == imageName ? 1.05 : 1.0)
                                
                                if selectedGame == imageName {
                                    Text(gameName)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.red)
                                }
                            }
                            .onTapGesture(count: 2) {
                                launchApp(name: imageName)
                            }
                            .onTapGesture(count: 1) {
                                selectedGame = imageName
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                }
                
                Spacer()
                
                // SYSTEM ICONS
                HStack(spacing: 40) {
                    SystemIcon(name: "gearshape.fill")
                    
                    // SLEEP MODE (The Spiral Trigger)
                    Button(action: { startSpiralExit() }) {
                        Image(systemName: "powersleep")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Circle().fill(Color.red))
                    }
                    
                    SystemIcon(name: "power")
                }
                .padding(.bottom, 40)
            }
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(scale)
        }
    }

    // LOGIC TO "CODE" THE APPS
    func launchApp(name: String) {
        if name == "roblox" {
            // This attempts to open the actual Roblox app if installed
            if let url = URL(string: "roblox://") {
                UIApplication.shared.open(url)
            }
        } else if name == "leo" {
            print("Leo AI: 'Hello R3ALCYB3R, what are we coding today?'")
            // We can build a LeoChatView next!
        }
    }

    func startSpiralExit() {
        withAnimation(.easeInOut(duration: 1.2)) {
            rotation = 720
            scale = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            exit(0)
        }
    }
}
