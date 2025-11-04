import Foundation
import SystemConfiguration

class NetworkMonitor: ObservableObject {
    @Published var isEthernetConnected: Bool = false
    @Published var ethernetInterfaceName: String?

    private var reachability: SCNetworkReachability?

    func startMonitoring() {
        updateEthernetStatus()

        // Set up reachability monitoring
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            print("Failed to create reachability")
            return
        }

        self.reachability = reachability

        var context = SCNetworkReachabilityContext(
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil,
            release: nil,
            copyDescription: nil
        )

        let callback: SCNetworkReachabilityCallBack = { (reachability, flags, info) in
            guard let info = info else { return }
            let monitor = Unmanaged<NetworkMonitor>.fromOpaque(info).takeUnretainedValue()
            DispatchQueue.main.async {
                monitor.updateEthernetStatus()
            }
        }

        SCNetworkReachabilitySetCallback(reachability, callback, &context)
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)

        // Also poll every 5 seconds for more reliable detection
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateEthernetStatus()
        }
    }

    func stopMonitoring() {
        if let reachability = reachability {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
        }
    }

    private func updateEthernetStatus() {
        let interfaces = getNetworkInterfaces()

        // Look for active ethernet interfaces
        var foundEthernet = false
        var ethernetName: String?

        for interface in interfaces {
            // Ethernet interfaces are typically en0, en1, etc. (but not en0 on MacBooks which is WiFi)
            // Thunderbolt/USB-C ethernet adapters show up as en5, en6, etc.
            if interface.name.hasPrefix("en") {
                // Check if this interface has an IP address and is up
                if interface.isUp && interface.hasIPAddress && !interface.isLoopback {
                    // Try to determine if it's ethernet vs WiFi
                    // WiFi is usually en0 on MacBooks, ethernet adapters are higher numbers
                    // Or we can check the BSD name more carefully
                    if isLikelyEthernet(interface: interface) {
                        foundEthernet = true
                        ethernetName = interface.name
                        break
                    }
                }
            }
        }

        if isEthernetConnected != foundEthernet {
            print("DEBUG: Ethernet status changed: \(foundEthernet)")
        }

        isEthernetConnected = foundEthernet
        ethernetInterfaceName = ethernetName

        // Post notification for updates
        NotificationCenter.default.post(name: NSNotification.Name("NetworkStatusDidUpdate"), object: nil)
    }

    func isLikelyEthernet(interface: NetworkInterface) -> Bool {
        let name = interface.name

        // en0 on most Macs is WiFi, but on Mac Pro/Mac Studio with ethernet, en0 is ethernet
        // Thunderbolt/USB ethernet adapters are usually en5+
        // The most reliable way is to check if we can get the interface type

        // For now, use a simple heuristic:
        // - If interface number is > 0 and has IP, likely ethernet adapter
        // - Also check common ethernet adapter patterns

        if name.hasPrefix("en") {
            if let numberStr = name.dropFirst(2).first,
               let number = Int(String(numberStr)) {
                // en1+ are more likely to be ethernet adapters
                if number > 0 {
                    return true
                }
            }
        }

        // Also check for bridge interfaces (sometimes used for ethernet)
        if name.hasPrefix("bridge") {
            return true
        }

        return false
    }

    private func getNetworkInterfaces() -> [NetworkInterface] {
        var interfaces: [NetworkInterface] = []
        var ifaddr: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&ifaddr) == 0 else { return interfaces }
        guard let firstAddr = ifaddr else { return interfaces }

        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ptr.pointee
            let name = String(cString: interface.ifa_name)

            // Check if interface is up
            let flags = Int32(interface.ifa_flags)
            let isUp = (flags & IFF_UP) != 0
            let isLoopback = (flags & IFF_LOOPBACK) != 0

            // Check if interface has IP address
            var hasIP = false
            if let addr = interface.ifa_addr {
                let family = addr.pointee.sa_family
                if family == UInt8(AF_INET) || family == UInt8(AF_INET6) {
                    hasIP = true
                }
            }

            let netInterface = NetworkInterface(
                name: name,
                isUp: isUp,
                isLoopback: isLoopback,
                hasIPAddress: hasIP
            )

            interfaces.append(netInterface)
        }

        freeifaddrs(ifaddr)
        return interfaces
    }

    deinit {
        stopMonitoring()
    }
}

struct NetworkInterface {
    let name: String
    let isUp: Bool
    let isLoopback: Bool
    let hasIPAddress: Bool
}
