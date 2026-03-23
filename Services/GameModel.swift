import Foundation

struct Game: Identifiable, Codable {
    var id = UUID()
    var name: String
    var iconData: Data? // For the custom logo
    var fileBookmark: Data? // Saves the .nsp / .xci location
}
