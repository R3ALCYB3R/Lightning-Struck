import SwiftUI

struct GameSlot: Identifiable {
    let id = UUID()
}

struct ContentView: View {
    // Toggles for the JIT Warning
    @State var isLiveContainer: Bool = false 
    @State var jitEnabled: Bool = false 
    
    let slots = Array(repeating: GameSlot(), count: 8)
    
    var body: some View {
        ZStack {
            // Light Grey Background
            Color(red: 0.93, green: 0.93, blue: 0.93).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Status Bar
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 35)).foregroundColor(.gray)
                    Spacer()
                    Text("4:20 PM").font(.system(size: 20, weight: .medium))
                    Image(systemName: "battery.100")
                }
                .padding(.horizontal, 40).padding(.top, 20)

                // JIT Warning Banner (Shows if not in LiveContainer & JIT is off)
                if !isLiveContainer && !jitEnabled {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
                        Text("It is recommended to enable JIT before adding a ROM.")
                            .font(.system(size: 13, weight: .bold)).foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            if let url = URL(string: "sidestore://") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("OPEN SIDESTORE")
                                .font(.system(size: 11, weight: .black)).foregroundColor(.white)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(Color.blue).cornerRadius(4)
                        }
                    }
                    .padding().background(Color.white).cornerRadius(8)
                    .padding(.horizontal, 40).padding(.top, 10)
                    .shadow(color: Color.black.opacity(0.08), radius: 4)
                }

                Spacer()
                
                // Game Grid (8 empty boxes)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(slots) { _ in
                            RoundedRectangle(cornerRadius: 4).fill(Color.white).frame(width: 210, height: 210)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .frame(height: 220)
                
                Spacer()
                
                // Bottom Menu with the Import Button
                HStack(spacing: 15) {
                    SmallCircle(icon: "envelope.fill", color: .red)
                    SmallCircle(icon: "cart.fill", color: .orange)
                    SmallCircle(icon: "photo.fill", color: .blue)
                    
                    // The Orange Import Button
                    Button(action: { print("Import tapped") }) {
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
