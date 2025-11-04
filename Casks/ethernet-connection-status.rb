cask "ethernet-connection-status" do
  version "1.0.0"
  sha256 "9316571801f00ad216f4ac2b21f9998866fbfddd27c5fbf19709592afc3956e5"

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
