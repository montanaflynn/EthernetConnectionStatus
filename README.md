# Ethernet Connection Status

A native macOS menu bar app that monitors your ethernet connection status in real-time.

## Features

- **Real-time Ethernet Monitoring**: Displays current ethernet connection status in the menu bar
- **Dual Display Modes**: Toggle between text ("Ethernet") or custom RJ45 port icon
- **Status Indication**: Brightness changes based on connection (bright = connected, dim = disconnected)
- **Native macOS Design**: SwiftUI-based settings with native macOS styling
- **Menu Bar Only**: Runs as a menu bar-only app (no dock icon)

## Installation

### Option 1: Homebrew (Recommended)

```bash
brew install montanaflynn/EthernetConnectionStatus/ethernet-connection-status
```

The Homebrew installation automatically handles the quarantine attribute removal for you.

### Option 2: Manual Installation

1. Download the latest release ZIP from [GitHub Releases](https://github.com/montanaflynn/EthernetConnectionStatus/releases)
2. Extract the ZIP file
3. **Remove the quarantine attribute** (required for unsigned apps):
   ```bash
   xattr -cr "/path/to/Ethernet Connection Status.app"
   ```
   Replace `/path/to/` with the actual location of the extracted app
4. Drag the app to your Applications folder
5. Launch the app - it will appear in your menu bar

**Note:** This app is unsigned, so macOS will block it by default. The `xattr` command removes the quarantine flag that prevents unsigned apps from opening.

## Requirements

- **macOS 13.0 (Ventura) or later**
- Xcode 15.0+ for building from source

## Building

### From Xcode
1. Open `EthernetConnectionStatus.xcodeproj`
2. Select the "EthernetConnectionStatus" scheme
3. Build and run (⌘R)

### From Command Line
```bash
xcodebuild clean build \
  -project EthernetConnectionStatus.xcodeproj \
  -scheme EthernetConnectionStatus \
  -configuration Release
```

## CI/CD

This project includes GitHub Actions for continuous integration:

- **Build verification** on every push and pull request
- **macOS latest runner** for testing
- **Automated builds** with artifact upload

See `.github/workflows/build.yml` for configuration.

## Adding Tests

To add unit tests to this project:

1. Open the project in Xcode
2. Go to File → New → Target
3. Select "Unit Testing Bundle" under macOS
4. Name it "EthernetConnectionStatusTests"
5. Add the test file `NetworkMonitorTests.swift` to the test target
6. Run tests with ⌘U

The test file is already included in the repository and contains tests for:
- NetworkMonitor initialization
- Network interface detection
- Start/stop cycles

## Architecture

- **MacMenuBarApp.swift**: Main app entry point and AppDelegate
- **NetworkMonitor.swift**: Monitors network interfaces using SystemConfiguration framework
- **EthernetIcon.swift**: Custom RJ45 ethernet port icon drawing
- **SettingsView.swift**: SwiftUI settings interface

## Settings

Click the menu bar item to access settings:
- **Display mode**: Choose between Text or Icon display
- **Brightness indicator**: Shows connection status

## How It Works

The app uses the `SystemConfiguration` framework to monitor network interfaces:
- Detects ethernet interfaces (en1+, bridge devices)
- Polls every 5 seconds for reliable detection
- Posts notifications when status changes
- Updates menu bar display accordingly

## License

MIT License - feel free to modify and distribute.

## Compatibility

| macOS Version | Supported |
|--------------|-----------|
| Ventura (13.x) | ✅ Yes |
| Sonoma (14.x) | ✅ Yes |
| Sequoia (15.x) | ✅ Yes |
| Future versions | ✅ Expected |
| Monterey (12.x) and earlier | ❌ No |
