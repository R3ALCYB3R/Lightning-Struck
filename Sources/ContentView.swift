import SwiftUI

struct ContentView: View {
    // Set this to 'true' if you are testing in LiveContainer to hide the warning
    @State var isLiveContainer: Bool = false 
    @State var jitEnabled: Bool = false // We can automate this check later
    
    let slots = Array(repeating: GameSlot(), count: 8)
    
    var body: some View {
        ZStack {
            Color(red: 0.93, green: 0.93, blue: 0.93).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. TOP BAR
                HStack {
                    Image(systemName: "person.crop.circle.fill").font(.system(size: 35)).foregroundColor(.gray)
                    Spacer()
                    Text("1:28 PM").font(.system(size: 20, weight: .medium))
                    Image(systemName: "battery.100")
                }
                .padding(.horizontal, 40).padding(.top, 20)

                // 2. JIT WARNING (Conditional)
                if !isLiveContainer && !jitEnabled {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        
                        Text("It is recommended to enable JIT before adding a ROM.")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        // SWITCH THEMED BUTTON TO SIDESTORE
                        Button(action: {
                            // URL Schemes for AltStore/SideStore
                            if let url = URL(string: "sidestore://") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("OPEN SIDESTORE")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(Color.blue) // Classic Switch Blue
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)
                }

                Spacer()
                
                // 3. THE GRID
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
                
                // 4. BOTTOM ROW
                HStack(spacing: 15) {
                    SmallCircle(icon: "envelope.fill", color: .red)
                    SmallCircle(icon: "cart.fill", color: .orange)
                    SmallCircle(icon: "photo.fill", color: .blue)
                    
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
