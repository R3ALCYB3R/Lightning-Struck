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
    @State private var showControllerMenu = false
    @State private var games: [Game] = []
    
    // --- NEW INTERACTIVE STATE ---
    @State private var selectedGameID: UUID? = nil
    @State private var activeNavButton: String? = nil
    @State private var isGameRunning = false
    @State private var runningGameName = ""

    let gameData = [
        "Mario Kart 8 Deluxe": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/karts.png",
        "Super Smash Bros. Ultimate": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/smash.png",
        "Super Mario Party": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/party.png"
    ]

    var body: some View {
        if isGameRunning {
            // --- 4. GAME RUNNING STATE ---
            ZStack {
                Color.black.ignoresSafeArea()
                Text("Launching \(runningGameName)...").foregroundColor(.white).font(.headline)
                VStack {
                    Spacer()
                    Button("Exit Game") { isGameRunning = false }.buttonStyle(.bordered).tint(.white)
                }.padding()
            }
        } else if !hasSignedUp {
            // --- 1. SIGN UP SCREEN ---
            VStack(spacing: 20) {
                Text("Create Profile").font(.largeTitle).bold()
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let profileImage { profileImage.resizable().scaledToFill().frame(width: 100, height: 100).clipShape(Circle()) }
                    else { Circle().fill(Color.gray.opacity(0.2)).frame(width: 100, height: 100).overlay(Image(systemName: "camera.fill").foregroundColor(.gray)) }
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
                        hasSignedUp = true
                    }
                }.buttonStyle(.borderedProminent)
            }
        } else if !isUnlocked {
            // --- 2. LOCK SCREEN (Updated with Video Sound Logic) ---
            VStack(spacing: 30) {
                if let profileImage { profileImage.resizable().scaledToFill().frame(width: 80, height: 80).clipShape(Circle()) }
                Text("Press the same button three times").font(.headline)
                HStack(spacing: 15) {
                    ForEach(0..<3) { i in
                        Circle().fill(unlockTaps > i ? Color.gray : Color.gray.opacity(0.2)).frame(width: 15, height: 15)
                    }
                }
                Button(action: {
                    unlockTaps += 1
                    // Play the "Click" sound from your video
                    AudioServicesPlaySystemSound(1104) 
                    if unlockTaps >= 3 { 
                        // Final unlock sound
                        AudioServicesPlaySystemSound(1026) 
                        isUnlocked = true 
                    }
                }) {
                    ZStack {
                        Circle().stroke(Color.gray.opacity(0.3), lineWidth: 3).frame(width: 80, height: 80)
                        Text("A").font(.title).bold().foregroundColor(.black)
                    }
                }
            }
        } else {
            // --- 3. MAIN DASHBOARD ---
            ZStack {
                Color(red: 0.93, green: 0.93, blue: 0.93).ignoresSafeArea()
                VStack {
                    // Header
                    HStack {
                        if let profileImage { profileImage.resizable().scaledToFill().frame(width: 35, height: 35).clipShape(Circle()) }
                        Text(username).bold(); Spacer(); Text("6:45 PM"); Image(systemName: "battery.100")
                    }.padding(.horizontal, 40).padding(.top, 20)
                    
                    Spacer()
                    
                    // Game Grid with "Double Tap to Launch"
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(games) { game in
                                VStack {
                                    Button(action: {
                                        if selectedGameID == game.id {
                                            runningGameName = game.name
                                            isGameRunning = true
                                        } else {
                                            selectedGameID = game.id
                                            AudioServicesPlaySystemSound(1104)
                                        }
                                    }) {
                                        AsyncImage(url: URL(string: game.iconURL)) { img in img.resizable().aspectRatio(contentMode: .fill) }
                                        placeholder: { Color.white }
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(4)
                                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.cyan, lineWidth: selectedGameID == game.id ? 5 : 0))
                                        .shadow(radius: selectedGameID == game.id ? 10 : 2)
                                    }
                                    Text(game.name).font(.caption).bold().opacity(selectedGameID == game.id ? 1 : 0.5)
                                }
                            }
                        }.padding(.horizontal, 40)
                    }
                    
                    Spacer()
                    
                    // BOTTOM CENTER NAV (Matching your screenshot)
                    HStack(spacing: 20) {
                        NavBtn(id: "News", icon: "bubble.left.fill", color: .red, active: $activeNavButton)
                        NavBtn(id: "eShop", icon: "bag.fill", color: .orange, active: $activeNavButton)
                        NavBtn(id: "Album", icon: "photo.fill", color: .blue, active: $activeNavButton)
                        
                        // Import Button
                        Button(action: { isImporting = true }) {
                            VStack {
                                ZStack { Circle().fill(Color.orange).frame(width: 50, height: 50); Image(systemName: "plus").foregroundColor(.white) }
                                Text("Import").font(.system(size: 10)).bold().foregroundColor(.black)
                            }
                        }
                        
                        NavBtn(id: "Controllers", icon: "gamecontroller.fill", color: .gray, active: $activeNavButton)
                        NavBtn(id: "Settings", icon: "gearshape.fill", color: .gray, active: $activeNavButton)
                        NavBtn(id: "Power", icon: "power", color: .gray, active: $activeNavButton)
                    }.padding(.bottom, 40)
                }
                
                // Corners
                VStack {
                    Spacer()
                    HStack {
                        CaptureBtn().padding(.leading, 30)
                        Spacer()
                        Button(action: { isUnlocked = false; unlockTaps = 0 }) { 
                            Circle().fill(Color.gray.opacity(0.3)).frame(width: 50, height: 50)
                                .overlay(Image(systemName: "house.fill").foregroundColor(.black.opacity(0.6))) 
                        }.padding(.trailing, 30)
                    }.padding(.bottom, 20)
                }
            }
            .onChange(of: activeNavButton) { val in
                if val == "Controllers" { showControllerMenu = true }
            }
            .sheet(isPresented: $showControllerMenu) {
                ControllerMenuView(isPresented: $showControllerMenu)
            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data]) { _ in showNamingSheet = true }
        }
    }
}

// --- SUBVIEWS ---

struct NavBtn: View {
    let id: String; let icon: String; let color: Color
    @Binding var active: String?
    
    var body: some View {
        Button(action: { 
            active = id
            AudioServicesPlaySystemSound(1104)
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

struct CaptureBtn: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.3)).frame(width: 40, height: 40).overlay(Circle().stroke(Color.black.opacity(0.4), lineWidth: 2).padding(10))
    }
}

struct ControllerMenuView: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack(spacing: 20) {
            Text("Controllers").font(.title).bold()
            if GCController.controllers().isEmpty { Text("You don’t have any controllers connected.") }
            else { ForEach(GCController.controllers(), id: \.self) { c in Text(c.vendorName ?? "Controller") } }
            Button("Close") { isPresented = false }
        }.padding()
    }
}
