import SwiftUI

struct GameSlot: Identifiable {
    let id = UUID()
}

struct ContentView: View {
    let slots = Array(repeating: GameSlot(), count: 8)
    
    var body: some View {
        ZStack {
            // Switch Light Grey Background
            Color(red: 0.93, green: 0.93, blue: 0.93).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 35)).foregroundColor(.gray)
                    Spacer()
                    Text("1:27 PM").font(.system(size: 20, weight: .medium))
                    Image(systemName: "battery.100")
                }
                .padding(.horizontal, 40).padding(.top, 20)
                
                Spacer()
                
                // The Empty Grid
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(slots) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .frame(width: 210, height: 210)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .frame(height: 220)
                
                Spacer()
                
                // Bottom Row with IMPORT button
                HStack(spacing: 15) {
                    SmallCircle(icon: "envelope.fill", color: .red)
                    SmallCircle(icon: "cart.fill", color: .orange)
                    SmallCircle(icon: "photo.fill", color: .blue)
                    
                    // YOUR CENTER BUTTON
                    Button(action: { print("Importing...") }) {
                        VStack {
                            ZStack {
                                Circle().fill(Color.orange).frame(width: 55, height: 55)
                                Image(systemName: "plus").foregroundColor(.white).font(.title)
                            }
                            Text("Import Game").font(.caption2).bold().foregroundColor(.black)
                        }
                    }
                    
                    SmallCircle(icon: "gearshape.fill", color: .gray)
                    SmallCircle(icon: "power", color: .gray)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct SmallCircle: View {
    let icon: String
    let color: Color
    var body: some View {
        Circle().fill(color).frame(width: 50, height: 50)
            .overlay(Image(systemName: icon).foregroundColor(.white))
    }
}
