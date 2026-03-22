import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("SwitchUI")
                .font(.largeTitle)
                .bold()
            
            Text("LocalJIT Integrated")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                print("JIT would start here")
            }) {
                Text("Launch Emulator")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
