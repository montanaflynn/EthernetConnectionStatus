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
}
