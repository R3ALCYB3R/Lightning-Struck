import SwiftUI

struct SwitchUIDashboard: View {
    let user: String
    let game: String
    @State private var isUnlocked = false
    @State private var selectedGameID: String? = nil

    var body: some View {
        ZStack {
            if !isUnlocked {
                // The "A" Button Home Menu we built earlier
                LockScreenView(isUnlocked: $isUnlocked)
            } else {
                // THE MAIN MENU
                ZStack {
                    Color(red: 0.94, green: 0.94, blue: 0.94).ignoresSafeArea()
                    VStack {
                        // Top Status Bar
                        HStack {
                            Circle().fill(Color.gray).frame(width: 35, height: 35)
                            Text(user).bold()
                            Spacer()
                            Text("7:18 PM").bold()
                            Image(systemName: "battery.100")
                        }.padding(.horizontal, 30).padding(.top, 20)
                        
                        Spacer()
                        
                        // Game Grid
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                GameSquare(name: game, isSelected: true)
                                // Add empty squares for that "Switch" feel
                                ForEach(0..<4) { _ in GameSquare(name: "", isSelected: false) }
                            }.padding(.horizontal, 40)
                        }
                        
                        Spacer()
                        
                        // Bottom Navigation Icons
                        HStack(spacing: 20) {
                            ForEach(["bubble.left", "bag", "photo", "gamecontroller", "gearshape", "power"], id: \.self) { icon in
                                Circle().stroke(Color.gray, lineWidth: 1).frame(width: 50, height: 50)
                                    .overlay(Image(systemName: icon))
                            }
                        }.padding(.bottom, 40)
                    }
                }
            }
        }
    }
}

struct GameSquare: View {
    let name: String
    let isSelected: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(name.isEmpty ? Color.white : Color.blue)
            .frame(width: 200, height: 200)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.cyan, lineWidth: isSelected ? 6 : 0))
            .shadow(radius: isSelected ? 10 : 0)
    }
}
