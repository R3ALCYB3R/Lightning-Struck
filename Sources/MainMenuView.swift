import SwiftUI

struct MainMenuView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("SwitchUI")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        GameCardView(title: "Super Smash Bros. Ultimate", image: "ssbu_art")
                        GameCardView(title: "Mario Kart 8", image: "mk8_art")
                        // Add more cards here
                    }
                    .padding()
                }
            }
        }
    }
}
