cask "ethernet-connection-status" do
  version "0.0.5"
  sha256 "0291c91588ce9e23a734bdac7a68c738d4076901e36f463a94cbecf411c9994e"

  url "https://github.com/montanaflynn/EthernetConnectionStatus/releases/download/v#{version}/EthernetConnectionStatus-v#{version}.zip"
  name "Ethernet Connection Status"
  desc "Menu bar app that monitors ethernet connection status in real-time"
  homepage "https://github.com/montanaflynn/EthernetConnectionStatus"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Ethernet Connection Status.app"

  # Remove quarantine attribute automatically on installation
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Ethernet Connection Status.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.yourcompany.EthernetConnectionStatus.plist",
  ]
end
