import SwiftUI

struct MainMenuView: View {
    // List of games - You can add more here later!
    let games = [
        (title: "Super Smash Bros. Ultimate", image: "ssbu_art"),
        (title: "Mario Kart 8 Deluxe", image: "mk8_art"),
        (title: "The Legend of Zelda", image: "botw_art")
    ]
    
    var body: some View {
        ZStack {
            // Dark background like the Switch "Dark Theme"
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // 1. TOP BAR: User Profile & System Info
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.blue)
                    
                    Text("R3ALCYB3R")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "battery.75")
                        .foregroundColor(.white)
                    Text("11:51 PM")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                // 2. MIDDLE: The Scrolling Game List
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 25) {
                        // Spacer at the start to center the first game
                        Spacer().frame(width: 15)
                        
                        ForEach(games, id: \.title) { game in
                            GameCardView(title: game.title, imageName: game.image)
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                // 3. BOTTOM BAR: System Icons
                HStack(spacing: 50) {
                    SystemIconButton(icon: "newspaper.fill", color: .red)
                    SystemIconButton(icon: "bag.fill", color: .orange)
                    SystemIconButton(icon: "photo.fill", color: .green)
                    SystemIconButton(icon: "gamecontroller.fill", color: .gray)
                    SystemIconButton(icon: "gearshape.fill", color: .gray)
                    SystemIconButton(icon: "moon.stars.fill", color: .blue)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

// Small helper for those bottom circles
struct SystemIconButton: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color.opacity(0.2))
            .frame(width: 60, height: 60)
            .overlay(
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
            )
    }
}
