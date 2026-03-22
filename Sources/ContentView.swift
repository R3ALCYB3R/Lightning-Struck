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
    @State private var tempName = ""
    @State private var tempURL = ""

    let gameData = [
        "Mario Kart 8 Deluxe": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/karts.png",
        "Super Smash Bros. Ultimate": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/smash.png",
        "Super Mario Party": "https://raw.githubusercontent.com/R3ALCYB3R/Lightning-Struck/main/party.png"
    ]

    var body: some View {
        if !hasSignedUp {
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
            VStack(spacing: 30) {
                if let profileImage { profileImage.resizable().scaledToFill().frame(width: 80, height: 80).clipShape(Circle()) }
                Text("Tap A 3 times").font(.headline)
                Button(action: {
                    unlockTaps += 1
                    if unlockTaps >= 3 { AudioServicesPlaySystemSound(1003); isUnlocked = true }
                }) {
                    ZStack {
                        Circle().stroke(Color.gray.opacity(0.3), lineWidth: 3).frame(width: 80, height: 80)
                        Text("A").font(.title).bold().foregroundColor(.black)
                    }
                }
            }
        } else {
            ZStack {
                Color(red: 0.93, green: 0.93, blue: 0.93).ignoresSafeArea()
                VStack {
                    HStack {
                        if let profileImage { profileImage.resizable().scaledToFill().frame(width: 35, height: 35).clipShape(Circle()) }
                        Text(username).bold(); Spacer(); Text("6:15 PM"); Image(systemName: "battery.100")
                    }.padding(.horizontal, 40).padding(.top, 20)
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(games) { game in
                                VStack {
                                    AsyncImage(url: URL(string: game.iconURL)) { img in img.resizable().aspectRatio(contentMode: .fill) }
                                    placeholder: { Color.white }.frame(width: 200, height: 200).cornerRadius(4).shadow(radius: 2)
                                    Text(game.name).font(.caption).bold()
                                }
                            }
                        }.padding(.horizontal, 40)
                    }
                    Spacer()
                    HStack(spacing: 20) {
                        CircleBtn(i: "envelope.fill", c: .red)
                        Button(action: { UIApplication.shared.open(URL(string: "https://accounts.nintendo.com")!) }) { CircleBtn(i: "cart.fill", c: .orange) }
                        CircleBtn(i: "photo.fill", c: .blue)
                        Button(action: { isImporting = true }) {
                            VStack { ZStack { Circle().fill(Color.orange).frame(width: 60, height: 60); Image(systemName: "plus").foregroundColor(.white) }; Text("Import").font(.caption2).bold() }
                        }
                        Button(action: { showControllerMenu = true }) { CircleBtn(i: "gamecontroller.fill", c: .gray) }
                        CircleBtn(i: "power", c: .gray)
                    }.padding(.bottom, 40)
                }
                VStack {
                    Spacer()
                    HStack {
                        RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.3)).frame(width: 40, height: 40).overlay(Circle().stroke(Color.black.opacity(0.4), lineWidth: 2).padding(10)).padding(.leading, 30)
                        Spacer()
                        Button(action: { isUnlocked = false; unlockTaps = 0 }) { Circle().fill(Color.gray.opacity(0.3)).frame(width: 50, height: 50).overlay(Image(systemName: "house.fill").foregroundColor(.black.opacity(0.6))) }.padding(.trailing, 30)
                    }.padding(.bottom, 20)
                }
            }
            .sheet(isPresented: $showControllerMenu) {
                VStack {
                    Text("Controllers").font(.title).bold()
                    if GCController.controllers().isEmpty { Text("None Connected") }
                    else { ForEach(GCController.controllers(), id: \.self) { c in Text(c.vendorName ?? "Controller") } }
                    Button("Close") { showControllerMenu = false }
                }.padding()
            }
            .sheet(isPresented: $showNamingSheet) {
                VStack {
                    TextField("Name", text: $tempName).textFieldStyle(.roundedBorder)
                    TextField("Icon URL", text: $tempURL).textFieldStyle(.roundedBorder)
                    Button("Save") { games.append(Game(name: tempName, iconURL: tempURL)); tempName = ""; tempURL = ""; showNamingSheet = false }.buttonStyle(.borderedProminent)
                }.padding()
            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data]) { _ in showNamingSheet = true }
        }
    }
}

struct CircleBtn: View {
    let i: String; let c: Color
    var body: some View { Circle().fill(c).frame(width: 50, height: 50).overlay(Image(systemName: i).foregroundColor(.white)) }
}
