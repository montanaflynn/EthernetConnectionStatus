# Release Guide

This guide explains how to create and distribute releases of Ethernet Connection Status.

## Quick Release Process

1. **Update version number** (if you want to track it in code)
2. **Commit your changes**
3. **Create and push a tag:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. **GitHub Actions will automatically:**
   - Build the release version
   - Create a ZIP file
   - Create a GitHub Release with the ZIP attached

5. **Edit the release notes** on GitHub to describe what's new

## Version Numbering

Use [Semantic Versioning](https://semver.org/):
- `v1.0.0` - Major release (breaking changes)
- `v1.1.0` - Minor release (new features)
- `v1.0.1` - Patch release (bug fixes)

## Distribution Methods

### Current: Unsigned Release (Free)

**Pros:**
- No cost
- Simple setup
- Works for open source projects

**Cons:**
- Users see security warnings
- Must right-click → Open on first launch
- Can't auto-update

**Users install by:**
1. Download ZIP from GitHub Releases
2. Extract the app
3. Drag to Applications folder
4. Right-click → Open (first time only)

### Future: Notarized Release ($99/year)

To upgrade to a notarized release:

1. **Join Apple Developer Program** ($99/year)
   - Sign up at: https://developer.apple.com/programs/

2. **Create signing certificates**
   - Developer ID Application certificate
   - Add to keychain

3. **Update GitHub Actions workflow**
   - Add signing step
   - Add notarization step
   - Store certificates as GitHub secrets

4. **Benefits:**
   - No security warnings for users
   - Can enable auto-updates with Sparkle
   - More professional distribution

**Example notarization workflow:**
```bash
# Sign the app
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application: Your Name" \
  --options runtime "YourApp.app"

# Create ZIP
ditto -c -k --keepParent "YourApp.app" "YourApp.zip"

# Notarize
xcrun notarytool submit "YourApp.zip" \
  --apple-id "your@email.com" \
  --team-id "TEAMID" \
  --password "app-specific-password" \
  --wait

# Staple notarization
xcrun stapler staple "YourApp.app"
```

## Creating Your First Release

```bash
# Make sure everything is committed
git status

# Create a tag for version 1.0.0
git tag -a v1.0.0 -m "Initial release"

# Push the tag
git push origin v1.0.0

# GitHub Actions will automatically create the release
```

Then go to: `https://github.com/YOUR_USERNAME/EthernetConnectionStatus/releases`

Edit the auto-generated release to add release notes!

## Testing Releases Locally

Before creating a tag, test the build locally:

```bash
xcodebuild clean build \
  -project EthernetConnectionStatus.xcodeproj \
  -scheme EthernetConnectionStatus \
  -configuration Release
```

The app will be in: `~/Library/Developer/Xcode/DerivedData/.../Build/Products/Release/`

## Auto-Updates (Future Enhancement)

To add automatic updates:

1. Integrate [Sparkle framework](https://sparkle-project.org/)
2. Host an appcast.xml file (can use GitHub Releases)
3. Users get notified of updates automatically

This requires:
- Signed/notarized builds
- Setting up Sparkle in your Xcode project
- Generating appcast.xml for each release

## Alternative: Homebrew Distribution

For technical users, you can create a Homebrew Cask:

```ruby
cask "ethernet-connection-status" do
  version "1.0.0"
  sha256 "..."

  url "https://github.com/user/repo/releases/download/v#{version}/EthernetConnectionStatus.zip"
  name "Ethernet Connection Status"
  desc "Monitor ethernet connection in menu bar"
  homepage "https://github.com/user/repo"

  app "Ethernet Connection Status.app"
end
```

Users install with: `brew install ethernet-connection-status`

## Resources

- [Apple Code Signing Guide](https://developer.apple.com/support/code-signing/)
- [Notarizing macOS Software](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [Sparkle Auto-Update Framework](https://sparkle-project.org/)
- [Homebrew Cask Documentation](https://docs.brew.sh/Cask-Cookbook)
