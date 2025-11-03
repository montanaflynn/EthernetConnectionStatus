import SwiftUI

struct SettingsView: View {
    @AppStorage("showMenuBarIcon") private var showMenuBarIcon = true
    let appDelegate: AppDelegate?

    init(appDelegate: AppDelegate? = nil) {
        self.appDelegate = appDelegate
    }

    var body: some View {
        Form {
            Section {
                Toggle("Show icon in menu bar", isOn: Binding(
                    get: { showMenuBarIcon },
                    set: { newValue in
                        print("DEBUG: Toggle changed to \(newValue)")
                        showMenuBarIcon = newValue
                        print("DEBUG: showMenuBarIcon set to \(showMenuBarIcon)")
                        print("DEBUG: About to call updateMenuBarIcon")

                        // Call immediately without delay
                        if let delegate = appDelegate {
                            print("DEBUG: Got appDelegate directly, calling update")
                            delegate.updateStatusItemVisibility()
                        } else {
                            print("DEBUG: ERROR - appDelegate is nil")
                        }
                    }
                ))

                Text("When enabled, a star icon will appear in your menu bar.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Label("Menu Bar", systemImage: "menubar.rectangle")
            }
        }
        .formStyle(.grouped)
        .frame(width: 450, height: 200)
    }

}

#Preview {
    SettingsView()
}
