import SwiftUI

struct GameCardView: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // The Game Art
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200) // Perfect square for the grid
                .clipped()
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
            
            // The Game Title
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.leading, 5)
        }
        .frame(width: 200)
    }
}

// Preview for your iPad
struct GameCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            GameCardView(title: "Super Smash Bros.", imageName: "SSBU-Art")
        }
    }
}
