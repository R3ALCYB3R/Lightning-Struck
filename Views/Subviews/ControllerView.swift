import SwiftUI

struct ControllerView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button("Back") { dismiss() }.foregroundColor(.blue)
                Spacer()
                Text("Controllers").font(.headline).bold()
                Spacer()
                Button("Close") { dismiss() }.opacity(0) // Spacing filler
            }.padding()

            Divider()

            // Controller Image (from your screenshot)
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 100))
                .foregroundColor(.gray)
                .padding(.top, 40)

            Text("Console").font(.title2).bold()

            // Menu Options
            List {
                Button("Change Grip/Order") { }
                Button("Find Controllers") { }
                Button("Pairing New Controllers") { }
            }
            .listStyle(.insetGrouped)
        }
        .background(Color(white: 0.95))
    }
}
