import SwiftUI

@main
struct MacMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static let appName = "Ethernet Connection Status"
    var statusItem: NSStatusItem?
    var settingsWindow: NSWindow?
    var networkMonitor = NetworkMonitor()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set default values if not set
        if UserDefaults.standard.object(forKey: "useTextDisplay") == nil {
            UserDefaults.standard.set(true, forKey: "useTextDisplay")
        }

        // Create the status item in the menu bar with a menu
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "Menu Bar App")
            button.action = #selector(statusItemClicked)
            button.target = self
        }

        // Create menu for the status item
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem?.menu = menu

        // Start network monitoring
        networkMonitor.startMonitoring()

        // Observe network status changes
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("NetworkStatusDidUpdate"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateMenuBarDisplay()
        }

        // Update display
        updateMenuBarDisplay()

        // Menu bar only app - no dock icon
        NSApp.setActivationPolicy(.accessory)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // When user clicks the app in dock, open settings
        openSettings()
        return true
    }

    @objc func statusItemClicked() {
        openSettings()
    }

    @objc func openSettings() {
        if settingsWindow == nil {
            let settingsView = SettingsView(appDelegate: self)
            let hostingController = NSHostingController(rootView: settingsView)

            settingsWindow = NSWindow(contentViewController: hostingController)
            settingsWindow?.title = AppDelegate.appName
            settingsWindow?.setContentSize(NSSize(width: 450, height: 240))
            settingsWindow?.styleMask = [.titled, .closable, .fullSizeContentView]
            settingsWindow?.titlebarAppearsTransparent = true
            settingsWindow?.center()
        }

        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func updateMenuBarDisplay() {
        let useTextDisplay = UserDefaults.standard.bool(forKey: "useTextDisplay")
        let isConnected = networkMonitor.isEthernetConnected

        if useTextDisplay {
            // Show ethernet status as text with opacity
            let opacity: CGFloat = isConnected ? 1.0 : 0.3
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: NSColor.labelColor.withAlphaComponent(opacity)
            ]
            let attributedString = NSAttributedString(string: "Ethernet", attributes: attributes)
            statusItem?.button?.attributedTitle = attributedString
            statusItem?.button?.image = nil
        } else {
            // Show custom ethernet icon
            statusItem?.button?.title = ""
            let icon = createEthernetIcon(isConnected: isConnected, size: 16)
            statusItem?.button?.image = icon
        }

        print("DEBUG: Ethernet \(isConnected ? "Connected" : "Disconnected")")
    }
}
