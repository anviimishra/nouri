import SwiftUI

/// The speech bubble from the app icon, as one path so the tail joins the body cleanly.
/// Keep in sync with frontend/Design/AppIcon/render.swift.
public struct NouriBubbleShape: Shape {
    public init() {}

    public func path(in rect: CGRect) -> Path {
        let body = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height * 0.82)
        var path = Path(roundedRect: body, cornerRadius: body.height * 0.45, style: .continuous)
        let topLeft = CGPoint(x: body.minX + body.width * 0.35, y: body.maxY - 1)
        let topRight = CGPoint(x: body.minX + body.width * 0.55, y: body.maxY - 1)
        let tip = CGPoint(x: body.minX + body.width * 0.27, y: rect.maxY)
        var tail = Path()
        tail.move(to: topLeft)
        tail.addLine(to: topRight)
        tail.addQuadCurve(to: tip, control: CGPoint(x: body.minX + body.width * 0.41, y: rect.maxY - rect.height * 0.04))
        tail.addQuadCurve(to: topLeft, control: CGPoint(x: body.minX + body.width * 0.32, y: body.maxY + rect.height * 0.05))
        tail.closeSubpath()
        path.addPath(tail)
        return path
    }
}

/// The app icon drawn in code: forest tile, cream bubble, forest "n", clay dot.
/// Uses brand colors directly so it matches the home-screen icon in light and dark mode.
public struct NouriAppMark: View {
    private let size: CGFloat

    public init(size: CGFloat = 64) {
        self.size = size
    }

    public var body: some View {
        let unit = size / 1024
        ZStack {
            NouriBrand.forest.color
            NouriBubbleShape()
                .fill(NouriBrand.cream.color)
                .frame(width: 680 * unit, height: 600 * unit)
                .offset(y: 30 * unit)
            Text("n")
                .font(.system(size: 400 * unit, weight: .bold, design: .rounded))
                .foregroundStyle(NouriBrand.forest.color)
                .offset(y: -55 * unit)
            Circle()
                .fill(NouriBrand.clay.color)
                .frame(width: 92 * unit)
                .offset(x: 170 * unit, y: -150 * unit)
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.225, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: size * 0.225, style: .continuous)
            .strokeBorder(NouriBrand.cream.color.opacity(0.12)))
        .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: 24) {
        NouriAppMark(size: 64)
        NouriAppMark(size: 120)
    }
    .padding()
}
