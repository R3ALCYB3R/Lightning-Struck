import SwiftUI
import UniformTypeIdentifiers
import GameController
import PhotosUI
import AVFoundation

struct Game: Identifiable, Codable {
    let id = UUID()
    var name: String
    var iconURL: String
}

struct ContentView: View {
    @State private var hasSignedUp = false
    @State private var username = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    @State private var selectedFirstGame = "Mario Kart 8 Deluxe"
    @State private var isUnlocked = false
    @State private var unlockTaps = 0
    @State private var isImporting = false
    @State private var showNamingSheet = false
    @State private var games: [Game] = []
    
    // Selection & Sound
    @State private var selectedGameID: UUID? = nil
    @State private var activeNavButton: String? = nil
    @State private var isGameRunning = false
    @State private var runningGameName = ""
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
        if isGameRunning {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Now Playing").foregroundColor(.gray)
                    Text(runningGameName).font(.largeTitle).bold().foregroundColor(.white)
                    Button("Close Game") { isGameRunning = false; playClick() }
                        .buttonStyle(.bordered).tint(.white)
                }
            }
        } else if !hasSignedUp {
            // --- SIGN UP ---
            VStack(spacing: 20) {
                Text("Create Profile").font(.largeTitle).bold()
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let profileImage { profileImage.resizable().scaledToFill().frame(width: 100, height: 100).clipShape(Circle()) }
                    else { Circle().fill(Color.gray.opacity(0.1)).frame(width: 100, height: 100).overlay(Image(systemName: "camera.fill")) }
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) { profileImage = Image(uiImage: uiImage) }
                    }
                }
                TextField("Username", text: $username).textFieldStyle(.roundedBorder).padding(.horizontal, 50).multilineTextAlignment(.center)
                Picker("First Game", selection: $selectedFirstGame) {
                    Text("Mario Kart 8 Deluxe").tag("Mario Kart 8 Deluxe")
                    Text("Super Smash Bros. Ultimate").tag("Super Smash Bros. Ultimate")
                    Text("Super Mario Party").tag("Super Mario Party")
                }.pickerStyle(.wheel).frame(height: 100)
                Button("Get Started") {
                    if !username.isEmpty {
                        games.append(Game(name: selectedFirstGame, iconURL: gameData[selectedFirstGame] ?? ""))
                        hasSignedUp = true; playClick()
                    }
                }.buttonStyle(.borderedProminent)
            }
        } else if !isUnlocked {
            // --- LOCK SCREEN ---
            VStack(spacing: 40) {
                Text("Press the same button three times").font(.headline)
                Button(action: {
                    unlockTaps += 1; playClick()
                    if unlockTaps >= 3 { isUnlocked = true }
                }) {
                    ZStack {
                        Circle().stroke(Color.gray.opacity(0.3), lineWidth: 3).frame(width: 90, height: 90)
                        Text("A").font(.title).bold().foregroundColor(.black)
                    }
                }
            }
        } else {
            // --- MAIN DASHBOARD ---
            ZStack {
                Color(red: 0.94, green: 0.94, blue: 0.94).ignoresSafeArea()
                VStack(spacing: 0) {
                    // Top Bar
                    HStack {
                        if let profileImage { profileImage.resizable().scaledToFill().frame(width: 40, height: 40).clipShape(Circle()) }
                        Text(username).bold(); Spacer(); Text("7:15 PM").font(.headline); Image(systemName: "battery.100")
                    }.padding(.horizontal, 40).padding(.top, 20)

                    Spacer()
                    
                    // Grid: Double Tap to Play
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(games) { game in
                                Button(action: {
                                    if selectedGameID == game.id {
                                        runningGameName = game.name
                                        isGameRunning = true
                                    } else {
                                        selectedGameID = game.id; activeNavButton = nil
                                    }
                                    playClick()
                                }) {
                                    AsyncImage(url: URL(string: game.iconURL)) { img in img.resizable().scaledToFill() }
                                    placeholder: { Color.white }
                                    .frame(width: 210, height: 210).cornerRadius(2)
                                    .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.cyan, lineWidth: selectedGameID == game.id ? 6 : 0))
                                    .shadow(radius: selectedGameID == game.id ? 8 : 2)
                                }
                            }
                        }.padding(.horizontal, 40)
                    }

                    Spacer()
                    
                    // BOTTOM NAV: Matching your Screen
                    HStack(spacing: 20) {
                        NavBtn(id: "News", icon: "bubble.left.fill", color: .red, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        NavBtn(id: "eShop", icon: "bag.fill", color: .orange, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        NavBtn(id: "Album", icon: "photo.fill", color: .blue, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        
                        // Import
                        Button(action: { isImporting = true; playClick() }) {
                            VStack {
                                Circle().fill(Color.orange).frame(width: 50, height: 50)
                                    .overlay(Image(systemName: "plus").foregroundColor(.white))
                                Text("Import").font(.system(size: 10)).bold().foregroundColor(.black)
                            }
                        }
                        
                        NavBtn(id: "Controllers", icon: "gamecontroller.fill", color: .gray, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        NavBtn(id: "Settings", icon: "gearshape.fill", color: .gray, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        NavBtn(id: "Power", icon: "power", color: .gray, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                    }.padding(.bottom, 40)
                }
            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data]) { _ in }
        }
    }
}

struct NavBtn: View {
    let id: String; let icon: String; let color: Color
    @Binding var active: String?; @Binding var game: UUID?
    var sound: () -> Void

    var body: some View {
        Button(action: { 
            active = id; game = nil; sound()
        }) {
            VStack {
                ZStack {
                    Circle().fill(active == id ? color : Color.white).frame(width: 50, height: 50)
                        .overlay(Circle().stroke(color, lineWidth: 2))
                    Image(systemName: icon).foregroundColor(active == id ? .white : color)
                }
                Text(id).font(.system(size: 10)).bold().foregroundColor(active == id ? .cyan : .black)
            }
        }
    }
}
