import SwiftUI

struct SwitchUIDashboard: View {
    let user: String; let gameName: String; let logo: Data?
    @State private var isUnlocked = false
    @State private var unlockTaps = 0
    @State private var currentSheet: String? = nil

    var body: some View {
        ZStack {
            // --- MAIN INTERFACE ---
            Color(white: 0.95).ignoresSafeArea()
            VStack {
                // Top Bar
                HStack {
                    Circle().fill(Color.gray).frame(width: 35, height: 35).overlay(Text(user.prefix(1)).foregroundColor(.white))
                    Text(user).bold()
                    Spacer()
                    Text("1:27 PM").bold()
                    Image(systemName: "battery.100")
                }.padding(.horizontal, 30).padding(.top, 20)
                
                Spacer()
                
                // Game Grid
                HStack(spacing: 15) {
                    Button(action: { LocalJIT.shared.enable() }) {
                        VStack {
                            if let data = logo, let img = UIImage(data: data) {
                                Image(uiImage: img).resizable().scaledToFill()
                            } else { Color.blue }
                        }
                        .frame(width: 200, height: 200).cornerRadius(2)
                        .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.cyan, lineWidth: 6))
                    }
                    ForEach(0..<4) { _ in RoundedRectangle(cornerRadius: 2).fill(Color.white).frame(width: 200, height: 200) }
                }.padding(.horizontal, 40)
                
                Text(gameName).font(.headline).padding(.top, 10)
                
                Spacer()
                
                // Bottom Icons
                HStack(spacing: 25) {
                    NavIcon(img: "bubble.left", color: .red)
                    NavIcon(img: "bag", color: .orange)
                    NavIcon(img: "photo", color: .blue)
                    Button(action: { currentSheet = "Controllers" }) { NavIcon(img: "gamecontroller", color: .gray) }
                    Button(action: { currentSheet = "Settings" }) { NavIcon(img: "gearshape", color: .gray) }
                    NavIcon(img: "power", color: .gray)
                }.padding(.bottom, 40)
            }

            // --- LOCK SCREEN OVERLAY (Matches your image) ---
            if !isUnlocked {
                ZStack {
                    Color.black.opacity(0.85).ignoresSafeArea()
                    VStack(spacing: 30) {
                        VStack {
                            Circle().stroke(Color.white, lineWidth: 2).frame(width: 70, height: 70)
                                .overlay(Image(systemName: "house.fill").foregroundColor(.white))
                            Text("HOME Menu").foregroundColor(.white).font(.caption)
                        }
                        Text("Press the same button three times.").foregroundColor(.white)
                        HStack {
                            ForEach(0..<3) { i in Circle().fill(unlockTaps > i ? Color.red : Color.clear).frame(width: 12, height: 12).overlay(Circle().stroke(Color.white, lineWidth: 1)) }
                        }
                        Button(action: {
                            unlockTaps += 1
                            if unlockTaps >= 3 { withAnimation { isUnlocked = true } }
                        }) {
                            ZStack { Circle().stroke(Color.white, lineWidth: 3).frame(width: 80, height: 80); Text("A").foregroundColor(.white).font(.title).bold() }
                        }
                    }
                }.transition(.move(edge: .top))
            }
        }
        .sheet(item: $currentSheet) { sheet in
            if sheet == "Controllers" { ControllerView() }
            else { SettingsView() }
        }
    }
}

extension String: Identifiable { public var id: String { self } }

struct NavIcon: View {
    let img: String; let color: Color
    var body: some View {
        Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1).frame(width: 50, height: 50)
            .overlay(Image(systemName: img).foregroundColor(color))
    }
}
