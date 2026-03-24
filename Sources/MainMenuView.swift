import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @State private var selectedGame: String? = nil
    @State private var clickCount = 0
    
    let games = [
        ("Super Smash Bros", "smash"),
        ("Mario Kart 8", "kart"),
        ("Mario Party", "party")
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // Deep dark background
            
            VStack(spacing: 30) {
                // Header Image
                Image("header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25) {
                        ForEach(games, id: \.1) { gameName, imageName in
                            VStack {
                                Image(imageName)
                                    .resizable()
                                    .frame(width: 250, height: 140)
                                    .cornerRadius(12)
                                    // NEON BLUE BORDER & GLOW
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedGame == imageName ? Color.blue : Color.clear, lineWidth: 4)
                                            .shadow(color: .blue, radius: selectedGame == imageName ? 10 : 0)
                                    )
                                    .scaleEffect(selectedGame == imageName ? 1.05 : 1.0)
                                    .animation(.spring(), value: selectedGame)
                                
                                // NEON BLUE TEXT
                                Text(gameName)
                                    .font(.headline)
                                    .foregroundColor(.blue) 
                                    .padding(.top, 10)
                            }
                            .onTapGesture(count: 2) {
                                print("Double tapped: Launching \(gameName)")
                                // Access the thing you want to access here
                            }
                            .onTapGesture(count: 1) {
                                selectedGame = imageName
                                handleSound()
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
    }

    func handleSound() {
        clickCount += 1
        if clickCount >= 3 {
            playClickSound()
            clickCount = 0
        }
    }
}

// Sound Helper
var audioPlayer: AVAudioPlayer?
func playClickSound() {
    guard let url = Bundle.main.url(forResource: "click", withExtension: "mp3") else { return }
    try? audioPlayer = AVAudioPlayer(contentsOf: url)
    audioPlayer?.play()
}
