import SwiftUI
import UniformTypeIdentifiers

struct GameSlot: Identifiable {
    let id = UUID()
    var name: String = ""
}

struct ContentView: View {
    @State var isLiveContainer: Bool = false 
    @State var jitEnabled: Bool = false 
    @State private var isImporting: Bool = false
    @State private var importedGames: [String] = [] 
    
    // Generates the 8 boxes for the home screen
    var slots: [GameSlot] {
        var tempSlots = (0..<8).map { _ in GameSlot() }
        for i in 0..<importedGames.count {
            if i < 8 { tempSlots[i].name = importedGames[i] }
        }
        return tempSlots
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.93, green: 0.93, blue: 0.93).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Status Bar
                HStack {
                    Image(systemName: "person.crop.circle.fill").font(.system(size: 35)).foregroundColor(.gray)
                    Spacer()
                    Text("5:02 PM").font(.system(size: 20, weight: .medium))
                    Image(systemName: "battery.100")
                }.padding(.horizontal, 40).padding(.top, 20)

                // JIT Warning
                if !isLiveContainer && !jitEnabled {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
                        Text("It is recommended to enable JIT before adding a ROM.").font(.system(size: 13, weight: .bold))
                        Spacer()
                        Button("OPEN SIDESTORE") {
                            if let url = URL(string: "sidestore://") { UIApplication.shared.open(url) }
                        }
                        .font(.system(size: 11, weight: .black)).foregroundColor(.white).padding(8).background(Color.blue).cornerRadius(4)
                    }.padding().background(Color.white).cornerRadius(8).padding(.horizontal, 40).padding(.top, 10)
                }

                Spacer()
                
                // Game Grid
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(slots) { slot in
                            ZStack {
                                RoundedRectangle(cornerRadius: 4).fill(Color.white).frame(width: 210, height: 210)
                                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                                
                                if !slot.name.isEmpty {
                                    Text(slot.name).font(.caption).bold().multilineTextAlignment(.center).padding()
                                }
                            }
                        }
                    }.padding(.horizontal, 40)
                }.frame(height: 220)
                
                Spacer()
                
                // Bottom Utility Row
                HStack(spacing: 15) {
                    SmallCircle(icon: "envelope.fill", color: .red)
                    SmallCircle(icon: "cart.fill", color: .orange)
                    SmallCircle(icon: "photo.fill", color: .blue)
                    
                    Button(action: { isImporting = true }) {
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
                }.padding(.bottom, 30)
            }
        }
        // The File Picker logic
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data, .item], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let url):
                importedGames.append(url.lastPathComponent)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct SmallCircle: View {
    let icon: String
    let color: Color
    var body: some View {
        Circle().fill(color).frame(width: 50, height: 50).overlay(Image(systemName: icon).foregroundColor(.white))
    }
}

