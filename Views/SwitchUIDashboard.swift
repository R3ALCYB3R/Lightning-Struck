import SwiftUI

struct SwitchUIDashboard: View {
    let user: String
    let gameName: String
    let logo: Data?
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isUnlocked = false
    @State private var unlockTaps = 0
    @State private var currentSheet: String? = nil

    var body: some View {
        ZStack {
            // --- MAIN BACKGROUND (Swaps between White and Basic Black) ---
            (isDarkMode ? Color.black : Color(white: 0.94)).ignoresSafeArea()
            
            VStack {
                // Top Status Bar
                HStack {
                    Circle().fill(Color.gray).frame(width: 35, height: 35)
                        .overlay(Text(user.prefix(1)).foregroundColor(.white))
                    Text(user).bold().foregroundColor(isDarkMode ? .white : .black)
                    Spacer()
                    // JIT Status Indicator
                    HStack(spacing: 5) {
                        Circle().fill(LocalJIT.shared.isActive ? .green : .red).frame(width: 8, height: 8)
                        Text("JIT").font(.caption2).bold()
                    }.padding(5).background(Color.gray.opacity(0.2)).cornerRadius(5)
                    
                    Text("1:27 PM").bold().foregroundColor(isDarkMode ? .white : .black)
                    Image(systemName: "battery.100").foregroundColor(isDarkMode ? .white : .black)
                }.padding(.horizontal, 30).padding(.top, 20)
                
                Spacer()
                
                // --- GAME GRID ---
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        // Your Custom Game Button
                        Button(action: { LocalJIT.shared.enable() }) {
                            VStack {
                                if let data = logo, let img = UIImage(data: data) {
                                    Image(uiImage: img).resizable().scaledToFill()
                                } else {
                                    Color.blue.overlay(Text("NSP/XCI").foregroundColor(.white))
                                }
                            }
                            .frame(width: 220, height: 220).cornerRadius(2)
                            .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.cyan, lineWidth: 6))
                        }
                        
                        // Empty Slots (For that Switch Look)
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(isDarkMode ? Color(white: 0.2) : .white)
                                .frame(width: 220, height: 220)
                        }
                    }.padding(.horizontal, 40)
                }
                
                Text(gameName).font(.headline).foregroundColor(isDarkMode ? .white : .black).padding(.top, 10)
                
                Spacer()
                
                // --- BOTTOM ICONS (Matches your screenshots) ---
                HStack(spacing: 25) {
                    NavIcon(img: "bubble.left", color: .red)
                    NavIcon(img: "bag", color: .orange)
                    NavIcon(img: "photo", color: .blue)
                    Button(action: { currentSheet = "Controllers" }) { NavIcon(img: "gamecontroller", color: .gray) }
                    Button(action: { currentSheet = "Settings" }) { NavIcon(img: "gearshape", color: .gray) }
                    NavIcon(img: "power", color: .gray)
                }.padding(.bottom, 40)
            }

            // --- LOCK SCREEN OVERLAY (Your "A" Button Screen) ---
            if !isUnlocked {
                ZStack {
                    Color.black.opacity(0.92).ignoresSafeArea()
                    VStack(spacing: 30) {
                        VStack {
                            Circle().stroke(Color.white, lineWidth: 2).frame(width: 70, height: 70)
                                .overlay(Image(systemName: "house.fill").foregroundColor(.white))
                            Text("HOME Menu").foregroundColor(.white).font(.caption)
                        }
                        Text("Press the same button three times.").foregroundColor(.white)
                        HStack {
                            ForEach(0..<3) { i in
                                Circle().fill(unlockTaps > i ? Color.red : Color.clear)
                                    .frame(width: 12, height: 12).overlay(Circle().stroke(Color.white, lineWidth: 1))
                            }
                        }
                        Button(action: {
                            unlockTaps += 1
                            if unlockTaps >= 3 { withAnimation { isUnlocked = true } }
                        }) {
                            ZStack {
                                Circle().stroke(Color.white, lineWidth: 3).frame(width: 80, height: 80)
                                Text("A").foregroundColor(.white).font(.title).bold()
                            }
                        }
                    }
                }.transition(.move(edge: .top))
            }
        }
        // This opens the Controllers or Settings screen when you tap the icons
        .sheet(item: $currentSheet) { sheet in
            if sheet == "Controllers" { ControllerView() }
            else { SettingsView() }
        }
    }
}
