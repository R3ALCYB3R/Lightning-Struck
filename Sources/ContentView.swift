import SwiftUI
import UniformTypeIdentifiers

// --- JIT LOGIC ---
class LocalJITManager {
    static let shared = LocalJITManager()
    var isJITEnabled: Bool = false
    
    func setupJIT() {
        print("Initializing LocalJIT for SwitchUI...")
        isJITEnabled = true
    }
}

struct GameSlot: Identifiable {
    let id = UUID()
    var name: String = ""
}

// --- MAIN UI ---
struct ContentView: View {
    @State var isLiveContainer: Bool = false 
    @State private var isImporting: Bool = false
    @State private var importedGames: [String] = [] 
    @State private var jitStatus: Bool = LocalJITManager.shared.isJITEnabled
    
    var slots: [GameSlot] {
        var tempSlots = (0..<8).map { _ in GameSlot() }
        for i in 0..<importedGames.count {
            if i < 8 { tempSlots[i].name = importedGames[i] }
        }
        return tempSlots
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.93, green: 0.93, blue: 0.93).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Image(systemName: "person.crop.circle.fill").font(.system(size: 35)).foregroundColor(.gray)
                    Spacer()
                    Text("2:25 PM").font(.system(size: 20, weight: .medium))
                    Image(systemName: "battery.100")
                }.padding(.horizontal, 40).padding(.top, 20)

                // JIT Banner
                if !jitStatus {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
                        Text("JIT is required for MeloNX.").font(.system(size: 13, weight: .bold))
                        Spacer()
                        Button("ENABLE JIT") {
                            LocalJITManager.shared.setupJIT()
                            jitStatus = LocalJITManager.shared.isJITEnabled
                        }.font(.system(size: 11, weight: .black)).foregroundColor(.white).padding(8).background(Color.blue).cornerRadius(4)
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
                                    VStack {
                                        Text(slot.name).font(.caption).bold().multilineTextAlignment(.center).padding()
                                        Button(action: { importedGames.removeAll { $0 == slot.name } }) {
                                            Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 40)
                }.frame(height: 220)
                
                Spacer()
                
                // Bottom Icons
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
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data, .item]) { result in
            if case .success(let url) = result {
                importedGames.append(url.lastPathComponent)
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
