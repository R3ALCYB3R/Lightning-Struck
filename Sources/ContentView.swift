import SwiftUI
import UniformTypeIdentifiers
import GameController
import PhotosUI
import AVFoundation

struct Game: Identifiable, Codable {
    let id = UUID()
    var name: String
    var iconURL: String
    var nspBookmark: Data?
}

struct ContentView: View {
    @State private var hasSignedUp = false
    @State private var username = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    @State private var selectedFirstGame = "Mario Kart 8 Deluxe"
    
    // UI State
    @State private var isUnlocked = false
    @State private var unlockTaps = 0
    @State private var selectedGameID: UUID? = nil
    @State private var activeNavButton: String? = "News"
    @State private var isGameRunning = false
    @State private var runningGameName = ""
    @State private var isImporting = false
    @State private var games: [Game] = []
    @State private var audioPlayer: AVPlayer?

    let gameData = [
        "Mario Kart 8 Deluxe": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/karts.png",
        "Super Smash Bros. Ultimate": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/smash.png",
        "Super Mario Party": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/party.png"
    ]

    func playClick() {
        guard let url = URL(string: "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/click.mp3") else { return }
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
    }

    var body: some View {
        ZStack {
            if isGameRunning {
                // --- 3. GAME VIEW ---
                Color.black.ignoresSafeArea()
                VStack {
                    Text(runningGameName).font(.largeTitle).bold().foregroundColor(.white)
                    Button("Close") { isGameRunning = false; playClick() }.tint(.white)
                }
            } else if !hasSignedUp {
                // --- 0. SIGN UP ---
                VStack(spacing: 20) {
                    Text("New Profile").font(.title).bold()
                    TextField("Name", text: $username).textFieldStyle(.roundedBorder).padding(.horizontal, 50)
                    Button("Start") {
                        games.append(Game(name: selectedFirstGame, iconURL: gameData[selectedFirstGame] ?? ""))
                        hasSignedUp = true; playClick()
                    }.buttonStyle(.borderedProminent)
                }
            } else {
                // --- 1. MAIN MENU (The Background) ---
                ZStack {
                    Color(red: 0.94, green: 0.94, blue: 0.94).ignoresSafeArea()
                    VStack(spacing: 0) {
                        HStack {
                            if let profileImage { profileImage.resizable().scaledToFill().frame(width: 40, height: 40).clipShape(Circle()) }
                            Text(username).bold(); Spacer(); Text("7:25 PM"); Image(systemName: "battery.100")
                        }.padding(.horizontal, 40).padding(.top, 25)

                        Spacer()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(games) { game in
                                    Button(action: {
                                        if selectedGameID == game.id { runningGameName = game.name; isGameRunning = true }
                                        else { selectedGameID = game.id; activeNavButton = nil; playClick() }
                                    }) {
                                        AsyncImage(url: URL(string: game.iconURL)).frame(width: 210, height: 210).cornerRadius(2)
                                            .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.cyan, lineWidth: selectedGameID == game.id ? 6 : 0))
                                    }
                                }
                            }.padding(.horizontal, 40)
                        }

                        Spacer()
                        
                        HStack(spacing: 20) {
                            NavBtn(id: "News", icon: "bubble.left.fill", color: .red, active: $activeNavButton, sound: playClick)
                            NavBtn(id: "eShop", icon: "bag.fill", color: .orange, active: $activeNavButton, sound: playClick)
                            NavBtn(id: "Album", icon: "photo.fill", color: .blue, active: $activeNavButton, sound: playClick)
                            Button(action: { isImporting = true; playClick() }) {
                                VStack {
                                    Circle().fill(Color.orange).frame(width: 50, height: 50).overlay(Image(systemName: "plus").foregroundColor(.white))
                                    Text("Import").font(.system(size: 10)).bold().foregroundColor(.black)
                                }
                            }
                            NavBtn(id: "Controllers", icon: "gamecontroller.fill", color: .gray, active: $activeNavButton, sound: playClick)
                            NavBtn(id: "Settings", icon: "gearshape.fill", color: .gray, active: $activeNavButton, sound: playClick)
                            NavBtn(id: "Power", icon: "power", color: .gray, active: $activeNavButton, sound: playClick)
                        }.padding(.bottom, 50)
                    }
                }

                // --- 2. LOCK SCREEN (The Overlay) ---
                if !isUnlocked {
                    ZStack {
                        Color.black.opacity(0.85).ignoresSafeArea()
                        VStack(spacing: 25) {
                            Spacer()
                            VStack(spacing: 10) {
                                Circle().stroke(Color.white, lineWidth: 2).frame(width: 70, height: 70)
                                    .overlay(Image(systemName: "house.fill").foregroundColor(.white))
                                Text("HOME Menu").foregroundColor(.white).font(.caption)
                            }
                            Text("Press the same button three times.").foregroundColor(.white).font(.subheadline)
                            HStack(spacing: 12) {
                                ForEach(0..<3) { i in
                                    Circle().fill(unlockTaps > i ? Color.red : Color.clear)
                                        .frame(width: 15, height: 15).overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                                }
                            }
                            Button(action: {
                                unlockTaps += 1; playClick()
                                if unlockTaps >= 3 { withAnimation { isUnlocked = true } }
                            }) {
                                ZStack {
                                    Circle().stroke(Color.white, lineWidth: 3).frame(width: 90, height: 90)
                                    Text("A").font(.largeTitle).bold().foregroundColor(.white)
                                }
                            }
                            Spacer()
                        }
                    }
                    .transition(.move(edge: .top)) // Slides up when unlocked
                }
            }
        }
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [UTType(filenameExtension: "nsp")!]) { _ in }
    }
}

struct NavBtn: View {
    let id: String; let icon: String; let color: Color
    @Binding var active: String?
    var sound: () -> Void
    var body: some View {
        Button(action: { active = id; sound() }) {
            VStack {
                ZStack {
                    Circle().fill(active == id ? color : Color.white).frame(width: 50, height: 50).overlay(Circle().stroke(color, lineWidth: 2))
                    Image(systemName: icon).foregroundColor(active == id ? .white : color)
                }
                Text(id).font(.system(size: 10)).bold().foregroundColor(active == id ? .cyan : .black)
            }
        }
    }
}
