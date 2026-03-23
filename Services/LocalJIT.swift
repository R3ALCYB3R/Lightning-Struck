import Foundation

class LocalJIT: ObservableObject {
    static let shared = LocalJIT()
    @Published var isActive = false
    
    func enable() {
        // Triggers the C++ ptrace handshake
        let result = JITBridge.triggerJIT()
        self.isActive = (result == 0)
    }
}
