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
    
    // Generates 8 slots, filling the first ones with your imported ROM names
    var slots: [GameSlot] {
        var tempSlots = (0..<8).map { _ in GameSlot() }
        for i in 0..<importedGames.count {
            if i < 8 { tempSlots[i].name = importedGames[i] }
        }
        return tempSlots
    }
    
    var body: some View {
        ZStack {
            // Background Color
            Color(red: 0.93, green: 0.93, blue: 0.93).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- TOP STATUS BAR ---
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 35)).foregroundColor(.gray)
                    Spacer()
                    Text("5:22 PM").font(.system(size: 20, weight: .medium))
                    Image(systemName: "battery.100")
                }
                .padding(.horizontal, 40).padding(.top, 20)

                // --- JIT WARNING BANNER ---
                if !isLiveContainer && !jitEnabled {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
                        Text("JIT is required for MeloNX (SwitchUI).")
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
                
                // --- HORIZONTAL GAME GRID ---
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(slots) { slot in
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white)
                                    .frame(width: 210, height: 210)
                                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                                
                                if !slot.name.isEmpty {
                                    VStack {
                                        Text(slot.name)
                                            .font(.caption).bold()
                                            .multilineTextAlignment(.center)
                                            .padding()
                                        
                                        Button(action: {
                                            importedGames.removeAll { $0 == slot.name }
                                        }) {
                                            Image(systemName: "trash.circle.fill")
                                                .foregroundColor(.red).font(.title2)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .frame(height: 220)
                
                Spacer()
                
                // --- BOTTOM NAVIGATION ROW ---
                HStack(spacing: 15) {
                    SmallCircle(icon: "envelope.fill", color: .red)
                    SmallCircle(icon: "cart.fill", color: .orange)
                    SmallCircle(icon: "photo.fill", color: .blue)
                    
                    // IMPORT BUTTON
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
                }
                .padding(.bottom, 30)
            }
        }
        // --- FILE PICKER LOGIC ---
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.data, .item],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let url):
                importedGames.append(url.lastPathComponent)
            case .failure(let error):
                print("Import failed: \(error.localizedDescription)")
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
