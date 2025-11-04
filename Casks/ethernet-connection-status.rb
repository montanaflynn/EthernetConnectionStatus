cask "ethernet-connection-status" do
  version "0.0.4"
  sha256 "ef72900f1695bc15ba082160e0905cab7ecce6474c5c2955abbbe45d7d5402ca"

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
                   args: ["-cr", "#{appdir}/Ethernet Connection Status.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Preferences/com.yourcompany.EthernetConnectionStatus.plist",
  ]
end
