import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @State private var selectedGame: String? = "smash"
    @State private var isShowingLeo = false
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    let games = [
        ("Super Smash Bros. Ultimate", "smash"),
        ("Mario Kart 8 Deluxe", "kart"),
        ("Roblox", "roblox"),
        ("Leo AI Coder", "leo")
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // TOP BAR: Username & Clock
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable().frame(width: 35, height: 35).foregroundColor(.red)
                    Text("R3ALCYB3R").font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                    Spacer()
                    Text("9:44 PM").foregroundColor(.white)
                }
                .padding(.horizontal, 40).padding(.top, 30)
                
                Spacer()

                // MAIN MENU: Games & Apps
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(games, id: \.1) { gameName, imageName in
                            VStack(spacing: 15) {
                                Image(imageName)
                                    .resizable().aspectRatio(contentMode: .fill)
                                    .frame(width: 280, height: 160).cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedGame == imageName ? Color.red : Color.clear, lineWidth: 5)
                                            .shadow(color: .red, radius: selectedGame == imageName ? 15 : 0)
                                    )
                                    .scaleEffect(selectedGame == imageName ? 1.05 : 1.0)
                                
                                if selectedGame == imageName {
                                    Text(gameName).font(.system(size: 20, weight: .bold)).foregroundColor(.red)
                                }
                            }
                            .onTapGesture(count: 2) { launchLogic(id: imageName) }
                            .onTapGesture(count: 1) { selectedGame = imageName }
                        }
                    }
                    .padding(.horizontal, 60)
                }
                
                Spacer()
                
                // BOTTOM BAR: Sleep Mode Trigger
                HStack(spacing: 40) {
                    SystemIcon(name: "gearshape.fill")
                    Button(action: { startSpiralExit() }) {
                        Image(systemName: "powersleep")
                            .font(.system(size: 22)).foregroundColor(.white)
                            .frame(width: 50, height: 50).background(Circle().fill(Color.red))
                    }
                    SystemIcon(name: "power")
                }
                .padding(.bottom, 40)
            }
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(scale)
            
            // LEO AI OVERLAY
            if isShowingLeo {
                LeoAIView(isShowing: $isShowingLeo)
                    .transition(.move(edge: .bottom))
            }
        }
    }

    func launchLogic(id: String) {
        if id == "roblox" {
            if let url = URL(string: "roblox://") { UIApplication.shared.open(url) }
        } else if id == "leo" {
            withAnimation { isShowingLeo = true }
        }
    }

    func startSpiralExit() {
        withAnimation(.easeInOut(duration: 1.2)) {
            rotation = 720
            scale = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { exit(0) }
    }
}

// THE LEO AI CODER VIEW
struct LeoAIView: View {
    @Binding var isShowing: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.95).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("LEO AI CODER").font(.headline).foregroundColor(.red)
                Text("Hello R3ALCYB3R. I am ready to help you code SwitchUI.").multilineTextAlignment(.center).foregroundColor(.white)
                
                Button("Close") { withAnimation { isShowing = false } }
                    .padding().background(Color.red).foregroundColor(.white).cornerRadius(10)
            }
        }
    }
}

struct SystemIcon: View {
    let name: String
    var body: some View {
        Image(systemName: name).font(.system(size: 22)).foregroundColor(.white.opacity(0.8))
            .frame(width: 50, height: 50).background(Circle().fill(Color.white.opacity(0.1)))
    }
}
