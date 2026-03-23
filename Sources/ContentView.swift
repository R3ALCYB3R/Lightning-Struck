import SwiftUI

struct ContentView: View {
    // Persistent data saved to your iPhone 8 Plus
    @AppStorage("nickname") private var nickname = ""
    @AppStorage("hasAskedShare") private var hasAskedShare = false
    @AppStorage("mainGame") private var mainGame = ""
    
    @State private var tempName = ""

    var body: some View {
        ZStack {
            if nickname.isEmpty {
                // --- 1. NICKNAME SCREEN (LOCKED) ---
                SetupView(title: "Create Profile") {
                    VStack(spacing: 20) {
                        TextField("Enter Nickname", text: $tempName)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button("Confirm") {
                            if !tempName.isEmpty { nickname = tempName }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(tempName.isEmpty)
                    }
                }
            } else if !hasAskedShare {
                // --- 2. SHARE SCREEN ---
                SetupView(title: "Share SwitchUI?") {
                    VStack(spacing: 25) {
                        Text("Would you like to share this project with a friend?")
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            Button("Yes, Share") { showShareSheet(); hasAskedShare = true }
                            Button("Maybe Later") { hasAskedShare = true }.foregroundColor(.gray)
                        }
                    }
                }
            } else if mainGame.isEmpty {
                // --- 3. GAME PICKER ---
                SetupView(title: "Select Starter Game") {
                    VStack(spacing: 15) {
                        ForEach(["Mario Kart 8 Deluxe", "Smash Ultimate", "Mario Party"], id: \.self) { game in
                            Button(action: { mainGame = game }) {
                                Text(game).bold().frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(8)
                            }
                        }
                    }.padding(.horizontal, 40)
                }
            } else {
                // --- 4. THE MAIN SWITCHUI DASHBOARD ---
                SwitchUIDashboard(user: nickname, game: mainGame)
            }
        }
    }
    
    func showShareSheet() {
        // Logic to trigger iOS Share Sheet with your GitHub link
    }
}

// Reusable Setup Container
struct SetupView<Content: View>: View {
    let title: String
    let content: Content
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 30) {
                Text(title).font(.largeTitle).bold()
                content
            }.foregroundColor(.white)
        }
    }
}
