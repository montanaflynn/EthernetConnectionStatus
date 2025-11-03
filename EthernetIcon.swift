import SwiftUI
import AppKit

struct EthernetIconView: View {
    let isConnected: Bool
    let size: CGFloat

    var body: some View {
        // RJ45 ethernet port/jack icon (front view)
        Canvas { context, canvasSize in
            let padding = canvasSize.width * 0.15

            // Port opening (main rounded rectangle)
            let portRect = CGRect(x: padding, y: padding,
                                 width: canvasSize.width - padding * 2,
                                 height: canvasSize.height - padding * 2)
            let portPath = Path(roundedRect: portRect, cornerRadius: 1.5)
            context.stroke(portPath, with: .color(.primary), lineWidth: 1.5)

            // Connector pins at top (5 vertical lines)
            let pinCount = 5
            let pinsWidth = portRect.width * 0.65
            let pinsX = portRect.minX + (portRect.width - pinsWidth) / 2
            let pinSpacing = pinsWidth / CGFloat(pinCount - 1)
            let pinTop = portRect.minY + portRect.height * 0.1
            let pinHeight = portRect.height * 0.25

            for i in 0..<pinCount {
                let pinX = pinsX + CGFloat(i) * pinSpacing
                var pinPath = Path()
                pinPath.move(to: CGPoint(x: pinX, y: pinTop))
                pinPath.addLine(to: CGPoint(x: pinX, y: pinTop + pinHeight))
                context.stroke(pinPath, with: .color(.primary), lineWidth: 1.0)
            }

            // Bottom notches (left and right)
            let notchWidth = portRect.width * 0.18
            let notchHeight = portRect.height * 0.22
            let notchY = portRect.maxY - notchHeight - portRect.height * 0.05

            // Left notch
            let leftNotch = Path(CGRect(x: portRect.minX + portRect.width * 0.12,
                                       y: notchY,
                                       width: notchWidth,
                                       height: notchHeight))
            context.stroke(leftNotch, with: .color(.primary), lineWidth: 1.0)

            // Right notch
            let rightNotch = Path(CGRect(x: portRect.maxX - portRect.width * 0.12 - notchWidth,
                                        y: notchY,
                                        width: notchWidth,
                                        height: notchHeight))
            context.stroke(rightNotch, with: .color(.primary), lineWidth: 1.0)
        }
        .frame(width: size, height: size)
        .opacity(isConnected ? 1.0 : 0.3)
    }
}

// Function to create the ethernet icon using NSImage directly
func createEthernetIcon(isConnected: Bool, size: CGFloat = 16) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))

    // Fix the flipped coordinate system
    image.lockFocus()

    // Flip the coordinate system to match SwiftUI
    if let context = NSGraphicsContext.current?.cgContext {
        context.translateBy(x: 0, y: size)
        context.scaleBy(x: 1.0, y: -1.0)
    }

    // Set color based on appearance
    let color = NSColor.labelColor
    color.setStroke()

    // Apply opacity for disconnected state
    let opacity: CGFloat = isConnected ? 1.0 : 0.3
    NSGraphicsContext.current?.cgContext.setAlpha(opacity)

    // RJ45 ethernet port/jack icon (front view)
    let padding = size * 0.15

    // Port opening (main rounded rectangle)
    let portRect = CGRect(x: padding, y: padding,
                         width: size - padding * 2,
                         height: size - padding * 2)
    let portPath = NSBezierPath(roundedRect: portRect, xRadius: 1.5, yRadius: 1.5)
    portPath.lineWidth = 1.5
    portPath.stroke()

    // Connector pins at top (5 vertical lines)
    let pinCount = 5
    let pinsWidth = portRect.width * 0.65
    let pinsX = portRect.minX + (portRect.width - pinsWidth) / 2
    let pinSpacing = pinsWidth / CGFloat(pinCount - 1)
    let pinTop = portRect.minY + portRect.height * 0.1
    let pinHeight = portRect.height * 0.25

    for i in 0..<pinCount {
        let pinX = pinsX + CGFloat(i) * pinSpacing
        let pinPath = NSBezierPath()
        pinPath.move(to: CGPoint(x: pinX, y: pinTop))
        pinPath.line(to: CGPoint(x: pinX, y: pinTop + pinHeight))
        pinPath.lineWidth = 1.0
        pinPath.stroke()
    }

    // Bottom notches (left and right)
    let notchWidth = portRect.width * 0.18
    let notchHeight = portRect.height * 0.22
    let notchY = portRect.maxY - notchHeight - portRect.height * 0.05

    // Left notch
    let leftNotch = NSBezierPath(rect: CGRect(x: portRect.minX + portRect.width * 0.12,
                                              y: notchY,
                                              width: notchWidth,
                                              height: notchHeight))
    leftNotch.lineWidth = 1.0
    leftNotch.stroke()

    // Right notch
    let rightNotch = NSBezierPath(rect: CGRect(x: portRect.maxX - portRect.width * 0.12 - notchWidth,
                                               y: notchY,
                                               width: notchWidth,
                                               height: notchHeight))
    rightNotch.lineWidth = 1.0
    rightNotch.stroke()

    image.unlockFocus()
    image.isTemplate = true

    return image
}
