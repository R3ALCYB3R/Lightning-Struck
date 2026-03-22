import SwiftUI
import UniformTypeIdentifiers
import GameController 

struct Game: Identifiable, Codable {
    let id = UUID()
    var name: String
    var iconURL: String
}

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var unlockTaps = 0
    @State private var isImporting = false
    @State private var showNamingSheet = false
    @State private var showControllerMenu = false // New State
    
    @State private var tempGameName = ""
    @State private var tempIconURL = ""
    @State private var games: [Game] = []

    var body: some View {
        if !isUnlocked {
            // --- 1. LOCK SCREEN ---
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: 30) {
                    Image(systemName: "joypad.fill").font(.system(size: 80)).foregroundColor(.gray.opacity(0.4))
                    Text("Press the same button three times.").font(.system(size: 18, weight: .medium))
                    Button(action: {
                        unlockTaps += 1
                        if unlockTaps >= 3 { isUnlocked = true }
                    }) {
                        ZStack {
                            Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2).frame(width: 80, height: 80)
                            Text("A").font(.title).bold().foregroundColor(.black)
                        }
                    }
                }
            }
        } else {
            // --- 2. MAIN DASHBOARD ---
            ZStack {
                Color(red: 0.93, green: 0.93, blue: 0.93).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Status Bar
                    HStack {
                        Image(systemName: "person.crop.circle.fill").font(.system(size: 35)).foregroundColor(.gray)
                        Spacer()
                        Text("5:45 PM").font(.system(size: 20, weight: .medium))
                        Image(systemName: "battery.100")
                    }.padding(.horizontal, 40).padding(.top, 20)

                    Spacer()
                    
                    // Game Grid
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(games) { game in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 4).fill(Color.white).frame(width: 200, height: 200).shadow(radius: 2)
                                        AsyncImage(url: URL(string: game.iconURL)) { image in
                                            image.resizable().aspectRatio(contentMode: .fill)
                                        } placeholder: { Color.gray.opacity(0.1) }
                                        .frame(width: 200, height: 200).clipShape(RoundedRectangle(cornerRadius: 4))
                                    }
                                    Text(game.name).font(.caption).bold().padding(.top, 5)
                                }
                            }
                            if games.count < 5 {
                                ForEach(0..<(5 - games.count), id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.2), lineWidth: 1).frame(width: 200, height: 200)
                                }
                            }
                        }.padding(.horizontal, 40)
                    }.frame(height: 250)
                    
                    Spacer()
                    
                    // Center Navigation
                    HStack(spacing: 20) {
                        CircleBtn(icon: "envelope.fill", color: .red)
                        Button(action: { UIApplication.shared.open(URL(string: "https://accounts.nintendo.com")!) }) {
                            CircleBtn(icon: "cart.fill", color: .orange)
                        }
                        CircleBtn(icon: "photo.fill", color: .blue)
                        Button(action: { isImporting = true }) {
                            VStack {
                                ZStack {
                                    Circle().fill(Color.orange).frame(width: 60, height: 60)
                                    Image(systemName: "plus").foregroundColor(.white).font(.title)
                                }
                                Text("Import").font(.caption2).bold().foregroundColor(.black)
                            }
                        }
                        
                        // CONTROLLERS BUTTON (The Joy-Con Icon)
                        Button(action: { showControllerMenu = true }) {
                            CircleBtn(icon: "gamecontroller.fill", color: .gray)
                        }
                        
                        CircleBtn(icon: "power", color: .gray)
                    }.padding(.bottom, 40)
                }
                
                // Corner Buttons
                VStack {
                    Spacer()
                    HStack {
                        Button(action: { print("Capture") }) {
                            RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.3)).frame(width: 40, height: 40)
                                .overlay(Circle().stroke(Color.black.opacity(0.5), lineWidth: 2).padding(10))
                        }.padding(25)
                        Spacer()
                        Button(action: { isUnlocked = false; unlockTaps = 0 }) {
                            Circle().fill(Color.gray.opacity(0.3)).frame(width: 50, height: 50)
                                .overlay(Image(systemName: "house.fill").foregroundColor(.black.opacity(0.7)))
                        }.padding(25)
                    }
                }
            }
            // --- 3. CONTROLLER MENU POP-UP ---
            .sheet(isPresented: $showControllerMenu) {
                VStack(spacing: 30) {
                    Text("Controllers").font(.title).bold()
                    
                    let connected = GCController.controllers()
                    
                    if connected.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "dot.radiowaves.left.and.right").font(.system(size: 60)).foregroundColor(.gray)
                            Text("You don’t have any controllers connected.")
                                .multilineTextAlignment(.center).padding(.horizontal)
                        }
                    } else {
                        ForEach(connected, id: \.self) { controller in
                            HStack(spacing: 20) {
                                Image(systemName: "gamecontroller.fill").font(.largeTitle).foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text(controller.vendorName ?? "Unknown Controller").font(.headline)
                                    Text("Connected via Bluetooth").font(.caption).foregroundColor(.green)
                                }
                            }
                            .padding().background(Color.gray.opacity(0.1)).cornerRadius(10)
                        }
                    }
                    
                    Button("Close") { showControllerMenu = false }.buttonStyle(.borderedProminent).padding(.top)
                }.padding()
            }
            // --- 4. IMPORT POP-UP ---
            .sheet(isPresented: $showNamingSheet) {
                VStack(spacing: 20) {
                    Text("New Game Details").font(.headline)
                    TextField("Game Name", text: $tempGameName).textFieldStyle(.roundedBorder)
                    TextField("Icon Image URL", text: $tempIconURL).textFieldStyle(.roundedBorder)
                    HStack {
                        Button("Cancel") { showNamingSheet = false }
                        Spacer()
                        Button("Add") {
                            games.append(Game(name: tempGameName, iconURL: tempIconURL))
                            tempGameName = ""; tempIconURL = ""; showNamingSheet = false
                        }.buttonStyle(.borderedProminent)
                    }
                }.padding()
            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data, .item]) { result in
                if case .success(_) = result { showNamingSheet = true }
            }
        }
    }
}

struct CircleBtn: View {
    let icon: String
    let color: Color
    var body: some View {
        Circle().fill(color).frame(width: 50, height: 50).overlay(Image(systemName: icon).foregroundColor(.white))
    }
}
