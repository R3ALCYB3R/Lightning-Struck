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
            // --- BACKGROUND ---
            (isDarkMode ? Color.black : Color(white: 0.94)).ignoresSafeArea()
            
            VStack {
                // Top Status Bar
                HStack {
                    Circle().fill(Color.red).frame(width: 35, height: 35) // Red Profile Circle
                        .overlay(Text(user.prefix(1)).foregroundColor(.white).bold())
                    Text(user).bold().foregroundColor(isDarkMode ? .white : .black)
                    Spacer()
                    
                    // JIT Status Indicator (Red/Green)
                    HStack(spacing: 5) {
                        Circle().fill(LocalJIT.shared.isActive ? .green : .red).frame(width: 8, height: 8)
                        Text("JIT").font(.caption2).bold().foregroundColor(isDarkMode ? .white : .black)
                    }.padding(5).background(Color.red.opacity(0.1)).cornerRadius(5)
                    
                    Text("1:27 PM").bold().foregroundColor(isDarkMode ? .white : .black)
                    Image(systemName: "battery.100").foregroundColor(.red) // Red Battery
                }.padding(.horizontal, 30).padding(.top, 20)
                
                Spacer()
                
                // --- GAME GRID ---
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        Button(action: { LocalJIT.shared.enable() }) {
                            VStack {
                                if let data = logo, let img = UIImage(data: data) {
                                    Image(uiImage: img).resizable().scaledToFill()
                                } else {
                                    Color.red.overlay(Text("LAUNCH").foregroundColor(.white).bold())
                                }
                            }
                            .frame(width: 220, height: 220).cornerRadius(2)
                            // RED BORDER instead of Cyan
                            .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.red, lineWidth: 6))
                            .shadow(color: .red.opacity(0.3), radius: 10)
                        }
                        
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(isDarkMode ? Color(white: 0.2) : .white)
                                .frame(width: 220, height: 220)
                        }
                    }.padding(.horizontal, 40)
                }
                
                Text(gameName).font(.headline).foregroundColor(isDarkMode ? .white : .black).padding(.top, 10)
                
                Spacer()
                
                // --- BOTTOM ICONS (Red Accent) ---
                HStack(spacing: 25) {
                    NavIcon(img: "bubble.left", color: .red)
                    NavIcon(img: "bag", color: .red)
                    NavIcon(img: "photo", color: .red)
                    Button(action: { currentSheet = "Controllers" }) { NavIcon(img: "gamecontroller", color: .red) }
                    Button(action: { currentSheet = "Settings" }) { NavIcon(img: "gearshape", color: .red) }
                    NavIcon(img: "power", color: .red)
                }.padding(.bottom, 40)
            }

            // --- LOCK SCREEN OVERLAY (Matches Red Logic) ---
            if !isUnlocked {
                ZStack {
                    Color.black.opacity(0.95).ignoresSafeArea()
                    VStack(spacing: 30) {
                        VStack {
                            Circle().stroke(Color.red, lineWidth: 2).frame(width: 70, height: 70)
                                .overlay(Image(systemName: "house.fill").foregroundColor(.red))
                            Text("HOME Menu").foregroundColor(.white).font(.caption)
                        }
                        Text("Press the same button three times.").foregroundColor(.white)
                        HStack {
                            ForEach(0..<3) { i in
                                Circle().fill(unlockTaps > i ? Color.red : Color.clear)
                                    .frame(width: 12, height: 12).overlay(Circle().stroke(Color.red, lineWidth: 1))
                            }
                        }
                        Button(action: {
                            unlockTaps += 1
                            if unlockTaps >= 3 { withAnimation { isUnlocked = true } }
                        }) {
                            ZStack {
                                Circle().stroke(Color.red, lineWidth: 3).frame(width: 80, height: 80)
                                Text("A").foregroundColor(.white).font(.title).bold()
                            }
                        }
                    }
                }.transition(.opacity)
            }
        }
        .sheet(item: $currentSheet) { sheet in
            if sheet == "Controllers" { ControllerView() }
            else { SettingsView() }
        }
    }
}
