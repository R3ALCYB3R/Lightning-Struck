import SwiftUI
import UniformTypeIdentifiers
import PhotosUI

struct ContentView: View {
    @AppStorage("nickname") private var nickname = ""
    @AppStorage("hasAskedShare") private var hasAskedShare = false
    @State private var tempName = ""
    @State private var setupComplete = false
    
    // File/Logo State
    @State private var gameName = ""
    @State private var isImporting = false
    @State private var selectedLogoItem: PhotosPickerItem?
    @State private var logoData: Data?

    var body: some View {
        ZStack {
            if nickname.isEmpty {
                SetupScreen(title: "New Profile") {
                    TextField("Nickname", text: $tempName).textFieldStyle(.roundedBorder).padding(.horizontal, 50)
                    Button("Confirm") { if !tempName.isEmpty { nickname = tempName } }.buttonStyle(.borderedProminent)
                }
            } else if !hasAskedShare {
                SetupScreen(title: "Share SwitchUI?") {
                    HStack(spacing: 20) {
                        Button("Yes") { hasAskedShare = true }
                        Button("Later") { hasAskedShare = true }.foregroundColor(.gray)
                    }
                }
            } else if !setupComplete {
                SetupScreen(title: "Add Game (.nsp/.xci)") {
                    TextField("Game Name", text: $gameName).textFieldStyle(.roundedBorder).padding(.horizontal, 50)
                    Button("Select File") { isImporting = true }.buttonStyle(.bordered)
                    PhotosPicker(selection: $selectedLogoItem, matching: .images) {
                        Text(logoData == nil ? "Select Logo" : "Logo Added ✅")
                    }
                    Button("Finish") { setupComplete = true }.buttonStyle(.borderedProminent).disabled(gameName.isEmpty)
                }
            } else {
                SwitchUIDashboard(user: nickname, gameName: gameName, logo: logoData)
            }
        }
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [UTType(filenameExtension: "nsp")!, UTType(filenameExtension: "xci")!]) { _ in }
        .onChange(of: selectedLogoItem) { newItem in
            Task { if let data = try? await newItem?.loadTransferable(type: Data.self) { logoData = data } }
        }
    }
}
