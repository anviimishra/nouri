// Renders the Nouri app icon as a 1024×1024 opaque PNG: a cream speech bubble on forest
// green holding a forest lowercase "n" in New York (Apple's serif).
//
//   cd frontend && swift Design/AppIcon/render.swift
//
// Writes the PNG into the iOS and watchOS AppIcon sets. Edit the shapes below and rerun.
import SwiftUI
import AppKit

let forest = Color(red: 0x34 / 255, green: 0x3D / 255, blue: 0x30 / 255)
let cream = Color(red: 0xF6 / 255, green: 0xF0 / 255, blue: 0xE7 / 255)

/// Speech bubble: one path, so the tail joins the body with no seam or notch.
struct BubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let body = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height * 0.82)
        var path = Path(roundedRect: body, cornerRadius: body.height * 0.45, style: .continuous)
        // Tail sits on the flat part of the bottom edge, left of center, pointing down-left.
        // The corner curve ends at body.minX + cornerRadius; start the tail after it.
        let tailTopLeft = CGPoint(x: body.minX + body.width * 0.35, y: body.maxY - 2)
        let tailTopRight = CGPoint(x: body.minX + body.width * 0.55, y: body.maxY - 2)
        let tailTip = CGPoint(x: body.minX + body.width * 0.27, y: rect.maxY)
        var tail = Path()
        tail.move(to: tailTopLeft)
        tail.addLine(to: tailTopRight)
        tail.addQuadCurve(to: tailTip, control: CGPoint(x: body.minX + body.width * 0.41, y: rect.maxY - rect.height * 0.04))
        tail.addQuadCurve(to: tailTopLeft, control: CGPoint(x: body.minX + body.width * 0.32, y: body.maxY + rect.height * 0.05))
        tail.closeSubpath()
        path.addPath(tail)
        return path
    }
}

struct NouriIcon: View {
    var body: some View {
        ZStack {
            forest
            BubbleShape()
                .fill(cream)
                .frame(width: 680, height: 600)
                .offset(y: 30)
            Text("n")
                .font(.system(size: 440, weight: .bold, design: .serif))
                .foregroundStyle(forest)
                .offset(y: -78)
        }
        .frame(width: 1024, height: 1024)
    }
}

/// Renders without an alpha channel: App Store icons must be fully opaque.
@MainActor func renderOpaquePNG() -> Data {
    let renderer = ImageRenderer(content: NouriIcon())
    renderer.scale = 1
    guard let image = renderer.cgImage,
          let context = CGContext(data: nil, width: 1024, height: 1024, bitsPerComponent: 8, bytesPerRow: 0,
                                  space: CGColorSpace(name: CGColorSpace.sRGB)!,
                                  bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    else { fatalError("render failed") }
    context.draw(image, in: CGRect(x: 0, y: 0, width: 1024, height: 1024))
    let rep = NSBitmapImageRep(cgImage: context.makeImage()!)
    return rep.representation(using: .png, properties: [:])!
}

MainActor.assumeIsolated {
    let png = renderOpaquePNG()
    for target in ["Nouri", "NouriWatch"] {
        let url = URL(fileURLWithPath: "\(target)/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png")
        try! png.write(to: url)
        print("wrote \(url.path)")
    }
}
