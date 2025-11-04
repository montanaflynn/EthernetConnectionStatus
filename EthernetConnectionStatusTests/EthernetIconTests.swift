import XCTest
@testable import Ethernet_Connection_Status

final class EthernetIconTests: XCTestCase {

    // MARK: - Icon Creation Tests

    func testCreateEthernetIcon_ReturnsValidImage() {
        let icon = createEthernetIcon(isConnected: true, size: 16)
        XCTAssertNotNil(icon, "Icon should be created")
        XCTAssertEqual(icon.size.width, 16, "Icon width should match requested size")
        XCTAssertEqual(icon.size.height, 16, "Icon height should match requested size")
    }

    func testCreateEthernetIcon_IsTemplate() {
        let icon = createEthernetIcon(isConnected: true, size: 16)
        XCTAssertTrue(icon.isTemplate, "Icon should be a template image for menu bar")
    }

    func testCreateEthernetIcon_ConnectedState() {
        let connectedIcon = createEthernetIcon(isConnected: true, size: 16)
        XCTAssertNotNil(connectedIcon, "Connected icon should be created")
        // Note: We can't directly test opacity in NSImage, but we verify it doesn't crash
    }

    func testCreateEthernetIcon_DisconnectedState() {
        let disconnectedIcon = createEthernetIcon(isConnected: false, size: 16)
        XCTAssertNotNil(disconnectedIcon, "Disconnected icon should be created")
        // Note: Opacity is applied during drawing, can't be tested without rendering
    }

    func testCreateEthernetIcon_VariousSizes() {
        let sizes: [CGFloat] = [16, 32, 64, 128]

        for size in sizes {
            let icon = createEthernetIcon(isConnected: true, size: size)
            XCTAssertNotNil(icon, "Icon should be created for size \(size)")
            XCTAssertEqual(icon.size.width, size, "Icon width should be \(size)")
            XCTAssertEqual(icon.size.height, size, "Icon height should be \(size)")
        }
    }

    func testCreateEthernetIcon_BothStates() {
        // Test that we can create icons for both connected and disconnected
        let connected = createEthernetIcon(isConnected: true, size: 32)
        let disconnected = createEthernetIcon(isConnected: false, size: 32)

        XCTAssertNotNil(connected, "Connected icon should be created")
        XCTAssertNotNil(disconnected, "Disconnected icon should be created")

        // Both should have same size
        XCTAssertEqual(connected.size, disconnected.size, "Icons should have same size")
    }

    // MARK: - SwiftUI View Tests

    func testEthernetIconView_Initialization() {
        // Test that the SwiftUI view can be initialized
        let view = EthernetIconView(isConnected: true, size: 16)
        XCTAssertNotNil(view, "EthernetIconView should initialize")
    }

    func testEthernetIconView_BothStates() {
        // Test both connected and disconnected states
        let connectedView = EthernetIconView(isConnected: true, size: 16)
        let disconnectedView = EthernetIconView(isConnected: false, size: 16)

        XCTAssertNotNil(connectedView, "Connected view should initialize")
        XCTAssertNotNil(disconnectedView, "Disconnected view should initialize")
    }
}
