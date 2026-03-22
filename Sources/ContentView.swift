import SwiftUI
import UniformTypeIdentifiers
import GameController
import PhotosUI
import AVFoundation

// --- DATA MODELS ---
struct Game: Identifiable, Codable {
    let id = UUID()
    var name: String
    var iconURL: String
    var nspBookmark: Data? // Saves the .nsp location on your iPhone 8 Plus
}

struct ContentView: View {
    // --- APP STATE ---
    @State private var hasSignedUp = false
    @State private var username = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    @State private var selectedFirstGame = "Mario Kart 8 Deluxe"
    @State private var isUnlocked = false
    @State private var unlockTaps = 0
    @State private var games: [Game] = []
    
    // --- INTERACTIVE STATE ---
    @State private var selectedGameID: UUID? = nil
    @State private var activeNavButton: String? = "News"
    @State private var isGameRunning = false
    @State private var runningGameName = ""
    @State private var isImporting = false
    @State private var audioPlayer: AVPlayer?

    // --- YOUR GITHUB ASSETS ---
    let gameData = [
        "Mario Kart 8 Deluxe": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/karts.png",
        "Super Smash Bros. Ultimate": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/smash.png",
        "Super Mario Party": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/party.png"
    ]

    // --- FUNCTIONS ---
    func playClick() {
        guard let url = URL(string: "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/click.mp3") else { return }
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
    }

    func launchGame(game: Game) {
        playClick()
        if let bookmark = game.nspBookmark {
            // Already have the .nsp? Start the Emulator Core
            startEmulator(bookmark: bookmark, name: game.name)
        } else {
            // No file yet? Open picker to find the .nsp
            selectedGameID = game.id
            isImporting = true
        }
    }

    func startEmulator(bookmark: Data, name: String) {
        // This is where your merged LocalJIT / MeloNX code executes
        print("MeloNX: Booting \(name) using JIT...")
        runningGameName = name
        isGameRunning = true
    }

    var body: some View {
        if isGameRunning {
            // --- 4. EMULATOR VIEW ---
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Text("NOW PLAYING").font(.caption).foregroundColor(.gray)
                    Text(runningGameName).font(.largeTitle).bold().foregroundColor(.white)
                    Spacer()
                    Button("Exit to Menu") { isGameRunning = false; playClick() }
                        .buttonStyle(.bordered).tint(.white)
                }.padding()
            }
        } else if !hasSignedUp {
            // --- 1. SIGN UP ---
            VStack(spacing: 25) {
                Text("Create Profile").font(.largeTitle).bold()
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let profileImage { profileImage.resizable().scaledToFill().frame(width: 110, height: 110).clipShape(Circle()) }
                    else { Circle().fill(Color.gray.opacity(0.1)).frame(width: 110, height: 110).overlay(Image(systemName: "camera.fill")) }
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) { profileImage = Image(uiImage: uiImage) }
                    }
                }
                TextField("Username", text: $username).textFieldStyle(.roundedBorder).padding(.horizontal, 60).multilineTextAlignment(.center)
                Text("Select Starter Game").font(.caption).bold()
                Picker("", selection: $selectedFirstGame) {
                    Text("Mario Kart 8 Deluxe").tag("Mario Kart 8 Deluxe")
                    Text("Super Smash Bros. Ultimate").tag("Super Smash Bros. Ultimate")
                    Text("Super Mario Party").tag("Super Mario Party")
                }.pickerStyle(.wheel).frame(height: 100)
                Button("Initialize") {
                    if !username.isEmpty {
                        games.append(Game(name: selectedFirstGame, iconURL: gameData[selectedFirstGame] ?? ""))
                        hasSignedUp = true; playClick()
                    }
                }.buttonStyle(.borderedProminent)
            }
        } else if !isUnlocked {
            // --- 2. LOCK SCREEN ---
            VStack(spacing: 40) {
                Text("Press A three times").font(.headline)
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
            // --- 3. MAIN DASHBOARD ---
            ZStack {
                Color(red: 0.94, green: 0.94, blue: 0.94).ignoresSafeArea()
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        if let profileImage { profileImage.resizable().scaledToFill().frame(width: 40, height: 40).clipShape(Circle()) }
                        Text(username).bold(); Spacer(); Text("7:17 PM").bold(); Image(systemName: "battery.100")
                    }.padding(.horizontal, 40).padding(.top, 25)

                    Spacer()
                    
                    // Game Grid (Double Tap Logic)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 18) {
                            ForEach(games) { game in
                                Button(action: {
                                    if selectedGameID == game.id { launchGame(game: game) }
                                    else { selectedGameID = game.id; activeNavButton = nil; playClick() }
                                }) {
                                    VStack {
                                        AsyncImage(url: URL(string: game.iconURL)) { img in img.resizable().scaledToFill() }
                                        placeholder: { Color.white }
                                        .frame(width: 215, height: 215).cornerRadius(2)
                                        .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.cyan, lineWidth: selectedGameID == game.id ? 6 : 0))
                                        .shadow(radius: selectedGameID == game.id ? 10 : 2)
                                    }
                                }
                            }
                        }.padding(.horizontal, 40)
                    }

                    Spacer()
                    
                    // CENTER NAV BUTTONS
                    HStack(spacing: 22) {
                        NavBtn(id: "News", icon: "bubble.left.fill", color: .red, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        NavBtn(id: "eShop", icon: "bag.fill", color: .orange, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        NavBtn(id: "Album", icon: "photo.fill", color: .blue, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        
                        // Import Button
                        Button(action: { isImporting = true; playClick() }) {
                            VStack {
                                Circle().fill(Color.orange).frame(width: 55, height: 55).overlay(Image(systemName: "plus").foregroundColor(.white))
                                Text("Import").font(.system(size: 10)).bold().foregroundColor(.black)
                            }
                        }
                        
                        NavBtn(id: "Controllers", icon: "gamecontroller.fill", color: .gray, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        NavBtn(id: "Settings", icon: "gearshape.fill", color: .gray, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                        NavBtn(id: "Power", icon: "power", color: .gray, active: $activeNavButton, game: $selectedGameID, sound: playClick)
                    }.padding(.bottom, 50)
                }
            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [UTType(filenameExtension: "nsp")!]) { result in
                switch result {
                case .success(let url):
                    if let id = selectedGameID, let index = games.firstIndex(where: { $0.id == id }) {
                        do {
                            let data = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
                            games[index].nspBookmark = data
                            startEmulator(bookmark: data, name: games[index].name)
                        } catch { print("Error saving bookmark") }
                    }
                case .failure: print("Import failed")
                }
            }
        }
    }
}

// --- REUSABLE NAV BUTTON ---
struct NavBtn: View {
    let id: String; let icon: String; let color: Color
    @Binding var active: String?; @Binding var game: UUID?
    var sound: () -> Void

    var body: some View {
        Button(action: { active = id; game = nil; sound() }) {
            VStack {
                ZStack {
                    Circle().fill(active == id ? color : Color.white).frame(width: 55, height: 55)
                        .overlay(Circle().stroke(color, lineWidth: 2))
                    Image(systemName: icon).foregroundColor(active == id ? .white : color).font(.title3)
                }
                Text(id).font(.system(size: 10)).bold().foregroundColor(active == id ? .cyan : .black)
            }
        }
    }
}
