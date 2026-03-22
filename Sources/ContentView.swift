import SwiftUI

struct Game: Identifiable {
    let id = UUID()
    let isEmpty: Bool
}

struct ContentView: View {
    // Making all games "Empty" for now as you requested
    let games = Array(repeating: Game(isEmpty: true), count: 8)
    
    let rows = [GridItem(.fixed(200))]

    var body: some View {
        ZStack {
            // Background color from your image_14
            Color(red: 0.92, green: 0.92, blue: 0.92).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Top Bar
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("3:38 PM").font(.headline)
                    Image(systemName: "wifi")
                    Image(systemName: "battery.100")
                }
                .padding(.horizontal, 60)
                .padding(.top, 30)

                Spacer()

                // 2. Main Game Grid (Empty Slots)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows, spacing: 15) {
                        ForEach(games) { game in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 200, height: 200)
                                .shadow(color: Color.black.opacity(0.1), radius: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 60)
                }
                .frame(height: 220)

                Spacer()

                // 3. Bottom Row Menu (Adding "Import Game" here)
                HStack(spacing: 25) {
                    // Existing Switch-style circle buttons
                    BottomMenuCircle(icon: "archivebox.fill", label: "Album", color: .blue)
                    BottomMenuCircle(icon: "gamecontroller.fill", label: "Controllers", color: .gray)
                    BottomMenuCircle(icon: "gearshape.fill", label: "Settings", color: .gray)
                    BottomMenuCircle(icon: "power", label: "Sleep", color: .gray)
                    
                    // NEW: Your Import Game Button
                    Button(action: {
                        print("Importing Game...")
                    }) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 50, height: 50)
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.title2)
                            }
                            Text("Import Game")
                                .font(.caption2)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

// Helper for the circle buttons
struct BottomMenuCircle: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50)
                .overlay(Image(systemName: icon).foregroundColor(.white))
            Text(label)
                .font(.caption2)
                .foregroundColor(.black)
        }
    }
}
