# MacMenuBar

A native macOS menu bar application built with Swift and SwiftUI.

## Features

- Menu bar icon with star symbol
- Settings window to configure menu bar visibility
- Checkbox to toggle menu bar icon on/off
- Native macOS UI using SwiftUI

## Building and Running

### Prerequisites

- macOS 13.0 or later
- Xcode 14.0 or later

### Building

1. Open the project in Xcode:
   ```bash
   open MacMenuBar.xcodeproj
   ```

2. Build and run the project (Cmd+R)

### Command Line Build

You can also build from the command line:

```bash
xcodebuild -project MacMenuBar.xcodeproj -scheme MacMenuBar -configuration Debug build
```

## Usage

1. When the app launches, a star icon will appear in your menu bar
2. Click the star icon to open the Settings window
3. Use the checkbox to toggle the menu bar icon visibility
4. Click "Quit" to exit the application

## Project Structure

- `MacMenuBarApp.swift` - Main app entry point and AppDelegate
- `SettingsView.swift` - Settings window UI
- `Info.plist` - App configuration (includes LSUIElement for menu bar-only app)
