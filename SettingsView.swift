import SwiftUI

struct SettingsView: View {
    @AppStorage("useTextDisplay") private var useTextDisplay = true
    let appDelegate: AppDelegate?

    init(appDelegate: AppDelegate? = nil) {
        self.appDelegate = appDelegate
    }

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Display mode:")
                        Spacer()
                    }

                    // Text mode option with preview
                    Button(action: {
                        useTextDisplay = true
                        appDelegate?.updateMenuBarDisplay()
                    }) {
                        HStack {
                            Image(systemName: useTextDisplay ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(useTextDisplay ? .blue : .gray)
                            Text("Text")
                            Spacer()
                            Text("Ethernet")
                                .font(.system(.body))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    .buttonStyle(.plain)

                    // Icon mode option with preview
                    Button(action: {
                        useTextDisplay = false
                        appDelegate?.updateMenuBarDisplay()
                    }) {
                        HStack {
                            Image(systemName: !useTextDisplay ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(!useTextDisplay ? .blue : .gray)
                            Text("Icon")
                            Spacer()
                            HStack(spacing: 8) {
                                EthernetIconView(isConnected: true, size: 16)
                                Text("/")
                                    .foregroundColor(.secondary)
                                EthernetIconView(isConnected: false, size: 16)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                        }
                    }
                    .buttonStyle(.plain)
                }

                Text("Brightness indicates connection status.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Label("Display", systemImage: "eye")
            }
        }
        .formStyle(.grouped)
        .frame(width: 450, height: 240)
    }

}

#Preview {
    SettingsView()
}
