import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("System")) {
                    NavigationLink("Screen Brightness") { Text("Brightness Slider") }
                    NavigationLink("Screen Lock") { Text("Lock Settings") }
                }

                Section(header: Text("Theme")) {
                    Button(action: { isDarkMode = false }) {
                        HStack {
                            Text("Basic White")
                            Spacer()
                            if !isDarkMode { Image(systemName: "checkmark").foregroundColor(.blue) }
                        }
                    }.foregroundColor(.primary)

                    Button(action: { isDarkMode = true }) {
                        HStack {
                            Text("Basic Black")
                            Spacer()
                            if isDarkMode { Image(systemName: "checkmark").foregroundColor(.blue) }
                        }
                    }.foregroundColor(.primary)
                }

                Section(header: Text("Console")) {
                    Text("System Update")
                    Text("Language: English")
                }
            }
            .navigationTitle("System Settings")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}
