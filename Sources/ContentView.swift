import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct ContentView: View {
    // Persistent User Data
    @AppStorage("nickname") private var nickname = ""
    @AppStorage("hasAskedShare") private var hasAskedShare = false
    @AppStorage("gameName") private var gameName = ""
    
    // UI State
    @State private var tempName = ""
    @State private var setupComplete = false
    @State private var logoData: Data?
    
    // File/Photo Pickers
    @State private var isImportingFile = false
    @State private var selectedLogoItem: PhotosPickerItem?
    @State private var selectedFileURL: URL?

    var body: some View {
        ZStack {
            if nickname.isEmpty {
                // --- STAGE 1: NICKNAME ---
                SetupContainer(title: "New Profile") {
                    VStack(spacing: 20) {
                        TextField("Enter Nickname", text: $tempName)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                        
                        Button("Confirm") {
                            if !tempName.isEmpty { nickname = tempName }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .disabled(tempName.isEmpty)
                    }
                }
            } else if !hasAskedShare {
                // --- STAGE 2: SHARE ---
                SetupContainer(title: "Share SwitchUI?") {
                    VStack(spacing: 25) {
                        Text("Would you like to share the repo?").font(.subheadline)
                        HStack(spacing: 30) {
                            Button("Yes, Share") { hasAskedShare = true }
                            Button("Maybe Later") { hasAskedShare = true }.foregroundColor(.gray)
                        }
                    }
                }
            } else if !setupComplete {
                // --- STAGE 3: GAME & LOGO SETUP ---
                SetupContainer(title: "Add Your Game") {
                    VStack(spacing: 20) {
                        // File Picker (.nsp or .xci)
                        Button(action: { isImportingFile = true }) {
                            HStack {
                                Image(systemName: "doc.badge.plus")
                                Text(selectedFileURL == nil ? "Select .nsp or .xci" : selectedFileURL!.lastPathComponent)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                        }

                        // Game Name Input
                        TextField("Game Name", text: $gameName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 20)

                        // Logo Picker
                        PhotosPicker(selection: $selectedLogoItem, matching: .images) {
                            HStack {
                                Image(systemName: "photo.artframe")
                                Text(logoData == nil ? "Pick Game Logo" : "Logo Loaded ✅")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.3))
                            .cornerRadius(10)
                        }

                        Button("Enter Dashboard") {
                            if !gameName.isEmpty && selectedFileURL != nil {
                                setupComplete = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .disabled(gameName.isEmpty || selectedFileURL == nil)
                    }
                    .padding(.horizontal, 40)
                }
            } else {
                // --- FINAL: SWITCHUI DASHBOARD ---
                SwitchUIDashboard(user: nickname, gameName: gameName, logo: logoData)
            }
        }
        // Save Logo when picked
        .onChange(of: selectedLogoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    saveLogoToDisk(data: data)
                    self.logoData = data
                }
            }
        }
        // File Importer Logic
        .fileImporter(isPresented: $isImportingFile, allowedContentTypes: [UTType(filenameExtension: "nsp")!, UTType(filenameExtension: "xci")!]) { result in
            if case .success(let url) = result {
                self.selectedFileURL = url
            }
        }
        // Auto-load logo and check if setup is done
        .onAppear {
            loadSavedLogo()
            if !nickname.isEmpty && !gameName.isEmpty {
                setupComplete = true
            }
        }
    }

    // --- HELPER FUNCTIONS ---
    
    func saveLogoToDisk(data: Data) {
        let url = getDocumentsDirectory().appendingPathComponent("custom_logo.png")
        try? data.write(to: url)
    }

    func loadSavedLogo() {
        let url = getDocumentsDirectory().appendingPathComponent("custom_logo.png")
        if let data = try? Data(contentsOf: url) {
            self.logoData = data
        }
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

// Reusable Background for Setup Screens
struct SetupContainer<Content: View>: View {
    let title: String
    let content: Content
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Brighter Red/Blue Gradient Background
            LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text(title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                content
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}
