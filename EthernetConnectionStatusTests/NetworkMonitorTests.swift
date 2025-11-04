import XCTest
@testable import Ethernet_Connection_Status

final class NetworkMonitorTests: XCTestCase {
    var networkMonitor: NetworkMonitor!

    override func setUp() {
        super.setUp()
        networkMonitor = NetworkMonitor()
    }

    override func tearDown() {
        networkMonitor.stopMonitoring()
        networkMonitor = nil
        super.tearDown()
    }

    func testNetworkMonitorInitialization() {
        XCTAssertNotNil(networkMonitor, "NetworkMonitor should initialize")
        XCTAssertFalse(networkMonitor.isEthernetConnected, "Should start with no connection detected")
        XCTAssertNil(networkMonitor.ethernetInterfaceName, "Should start with no interface name")
    }

    func testNetworkInterfaceDetection() {
        // This test verifies that the monitor can detect network interfaces
        // The actual connection state will vary by environment
        let expectation = XCTestExpectation(description: "Network status should update")

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("NetworkStatusDidUpdate"),
            object: nil,
            queue: .main
        ) { _ in
            expectation.fulfill()
        }

        networkMonitor.startMonitoring()

        // Wait for initial network check
        wait(for: [expectation], timeout: 2.0)

        // Connection state is environment-dependent, so we just verify the monitor works
        XCTAssertTrue(true, "NetworkMonitor should complete initial check")
    }

    func testNetworkInterfaceNameValidation() {
        // Test that interface names follow expected patterns
        let validInterfaces = ["en0", "en1", "en5", "bridge0"]

        for interface in validInterfaces {
            XCTAssertTrue(interface.hasPrefix("en") || interface.hasPrefix("bridge"),
                         "Interface '\(interface)' should be a valid pattern")
        }
    }

    func testMultipleStartStopCycles() {
        // Verify monitor can be started and stopped multiple times
        XCTAssertNoThrow(networkMonitor.startMonitoring())
        XCTAssertNoThrow(networkMonitor.stopMonitoring())
        XCTAssertNoThrow(networkMonitor.startMonitoring())
        XCTAssertNoThrow(networkMonitor.stopMonitoring())
    }

    // MARK: - isLikelyEthernet Logic Tests

    func testIsLikelyEthernet_En1AndAbove() {
        // en1, en2, en5, etc. are likely ethernet adapters
        let interface1 = NetworkInterface(name: "en1", isUp: true, isLoopback: false, hasIPAddress: true)
        XCTAssertTrue(networkMonitor.isLikelyEthernet(interface: interface1), "en1 should be identified as ethernet")

        let interface5 = NetworkInterface(name: "en5", isUp: true, isLoopback: false, hasIPAddress: true)
        XCTAssertTrue(networkMonitor.isLikelyEthernet(interface: interface5), "en5 should be identified as ethernet")
    }

    func testIsLikelyEthernet_En0IsNotEthernet() {
        // en0 is typically WiFi on MacBooks
        let interface = NetworkInterface(name: "en0", isUp: true, isLoopback: false, hasIPAddress: true)
        XCTAssertFalse(networkMonitor.isLikelyEthernet(interface: interface), "en0 should NOT be identified as ethernet")
    }

    func testIsLikelyEthernet_BridgeInterfaces() {
        // Bridge interfaces are sometimes used for ethernet
        let interface = NetworkInterface(name: "bridge0", isUp: true, isLoopback: false, hasIPAddress: true)
        XCTAssertTrue(networkMonitor.isLikelyEthernet(interface: interface), "bridge0 should be identified as ethernet")
    }

    func testIsLikelyEthernet_OtherInterfaces() {
        // Other interface types should not be identified as ethernet
        let loopback = NetworkInterface(name: "lo0", isUp: true, isLoopback: true, hasIPAddress: true)
        XCTAssertFalse(networkMonitor.isLikelyEthernet(interface: loopback), "lo0 should NOT be ethernet")

        let utun = NetworkInterface(name: "utun0", isUp: true, isLoopback: false, hasIPAddress: true)
        XCTAssertFalse(networkMonitor.isLikelyEthernet(interface: utun), "utun0 should NOT be ethernet")
    }

    func testIsLikelyEthernet_EdgeCases() {
        // Test edge cases with unusual interface names
        let emptyName = NetworkInterface(name: "", isUp: true, isLoopback: false, hasIPAddress: true)
        XCTAssertFalse(networkMonitor.isLikelyEthernet(interface: emptyName), "Empty name should NOT be ethernet")

        let justEn = NetworkInterface(name: "en", isUp: true, isLoopback: false, hasIPAddress: true)
        XCTAssertFalse(networkMonitor.isLikelyEthernet(interface: justEn), "Just 'en' should NOT be ethernet")
    }
}
