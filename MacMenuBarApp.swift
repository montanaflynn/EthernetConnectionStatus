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
    var statusItem: NSStatusItem?
    var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set default value for showMenuBarIcon if not set
        if UserDefaults.standard.object(forKey: "showMenuBarIcon") == nil {
            UserDefaults.standard.set(true, forKey: "showMenuBarIcon")
        }

        // Create the status item in the menu bar with a menu
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "Menu Bar App")
        }

        // Create menu for the status item
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem?.menu = menu

        // Update visibility based on user defaults
        updateStatusItemVisibility()

        // Don't hide dock icon completely - keep it accessible
        NSApp.setActivationPolicy(.regular)
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
            settingsWindow?.title = "Settings"
            settingsWindow?.setContentSize(NSSize(width: 450, height: 200))
            settingsWindow?.styleMask = [.titled, .closable, .fullSizeContentView]
            settingsWindow?.titlebarAppearsTransparent = true
            settingsWindow?.center()
        }

        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func updateStatusItemVisibility() {
        let isVisible = UserDefaults.standard.bool(forKey: "showMenuBarIcon")
        print("DEBUG: showMenuBarIcon value = \(isVisible)")
        print("DEBUG: statusItem exists = \(statusItem != nil)")
        statusItem?.isVisible = isVisible
        print("DEBUG: statusItem.isVisible set to \(isVisible)")
    }
}
