import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @State private var selectedGame: String? = "smash" // Default selection
    @State private var clickCount = 0
    
    // The list of games from your Root folder
    let games = [
        ("Super Smash Bros. Ultimate", "smash"),
        ("Mario Kart 8 Deluxe", "kart"),
        ("Mario Party", "party")
    ]

    var body: some View {
        ZStack {
            // Background color
            Color(red: 0.1, green: 0.1, blue: 0.1).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - TOP BAR (Username & Clock)
                HStack(spacing: 15) {
                    // Profile Icon
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.red)
                    
                    // YOUR USERNAME
                    Text("R3ALCYB3R")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Clock
                    Text("9:41 PM")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 40)
                .padding(.top, 30)
                
                Spacer()

                // MARK: - MAIN GAME SELECTION
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(games, id: \.1) { gameName, imageName in
                            VStack(spacing: 15) {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 280, height: 160)
                                    .cornerRadius(10)
                                    // NEON RED SELECT BORDER
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedGame == imageName ? Color.red : Color.clear, lineWidth: 5)
                                            .shadow(color: .red, radius: selectedGame == imageName ? 15 : 0)
                                    )
                                    .scaleEffect(selectedGame == imageName ? 1.05 : 1.0)
                                    .animation(.spring(response: 0.3), value: selectedGame)
                                
                                // Game Title below the image
                                if selectedGame == imageName {
                                    Text(gameName)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.red)
                                        .transition(.opacity)
                                } else {
                                    Text(" ") // Keeps spacing consistent
                                        .font(.system(size: 20))
                                }
                            }
                            // INTERACTION LOGIC
                            .onTapGesture(count: 2) {
                                print("Double Tap: Accessing \(gameName)")
                                // Future: Trigger JIT launch here
                            }
                            .onTapGesture(count: 1) {
                                selectedGame = imageName
                                handleSound()
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                }
                
                Spacer()
                
                // MARK: - BOTTOM SYSTEM ICONS
                HStack(spacing: 40) {
                    SystemIcon(name: "message.fill")
                    SystemIcon(name: "photo.fill")
                    SystemIcon(name: "gamecontroller.fill")
                    SystemIcon(name: "gearshape.fill")
                    SystemIcon(name: "power")
                }
                .padding(.bottom, 40)
            }
        }
    }

    // Sound Logic: Plays click.mp3 after 3 taps
    func handleSound() {
        clickCount += 1
        if clickCount >= 3 {
            playClickSound()
            clickCount = 0
        }
    }
}

// Helper for the small bottom icons
struct SystemIcon: View {
    let name: String
    var body: some View {
        Image(systemName: name)
            .font(.system(size: 22))
            .foregroundColor(.white.opacity(0.8))
            .frame(width: 50, height: 50)
            .background(Circle().fill(Color.white.opacity(0.1)))
    }
}

// Global Sound Player
var audioPlayer: AVAudioPlayer?
func playClickSound() {
    guard let url = Bundle.main.url(forResource: "click", withExtension: "mp3") else { return }
    try? audioPlayer = AVAudioPlayer(contentsOf: url)
    audioPlayer?.play()
}
