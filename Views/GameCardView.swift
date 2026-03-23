import SwiftUI

struct GameCardView: View {
    let title: String
    let imageName: String // This will be "smash.png", "kart.png", etc.

    var body: some View {
        VStack {
            if let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
            } else {
                // Fallback if the image isn't found
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray)
                    .frame(width: 200, height: 200)
                    .overlay(Text("Missing").foregroundColor(.white))
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}
