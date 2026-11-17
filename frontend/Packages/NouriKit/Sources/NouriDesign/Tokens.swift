import SwiftUI

/// An sRGB color defined as a hex value, so token contrast can be unit tested.
public struct RGB: Equatable, Sendable {
    public let r: Double, g: Double, b: Double

    public init(_ hex: UInt32) {
        r = Double((hex >> 16) & 0xFF) / 255
        g = Double((hex >> 8) & 0xFF) / 255
        b = Double(hex & 0xFF) / 255
    }

    /// WCAG relative luminance.
    public var luminance: Double {
        func lin(_ c: Double) -> Double { c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4) }
        return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)
    }

    /// WCAG contrast ratio between two colors (1...21).
    public func contrast(with other: RGB) -> Double {
        let (hi, lo) = (max(luminance, other.luminance), min(luminance, other.luminance))
        return (hi + 0.05) / (lo + 0.05)
    }
}

/// A light/dark pair. watchOS always uses the dark value.
public struct ColorToken: Sendable {
    public let light: RGB
    public let dark: RGB

    public var color: Color {
        #if os(iOS)
        Color(UIColor { $0.userInterfaceStyle == .dark ? dark.uiColor : light.uiColor })
        #elseif os(macOS)
        Color(NSColor(name: nil) { $0.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark.nsColor : light.nsColor })
        #else
        dark.color
        #endif
    }
}

extension RGB {
    var color: Color { Color(.sRGB, red: r, green: g, blue: b) }
    #if os(iOS)
    var uiColor: UIColor { UIColor(red: r, green: g, blue: b, alpha: 1) }
    #elseif os(macOS)
    var nsColor: NSColor { NSColor(srgbRed: r, green: g, blue: b, alpha: 1) }
    #endif
}

/// Soft wellness palette: warm cream and peach, sage accent, deep navy at night.
public enum NouriPalette {
    public static let canvas = ColorToken(light: RGB(0xFBF7F2), dark: RGB(0x0F1626))
    public static let canvasGlowWarm = ColorToken(light: RGB(0xFCE3D3), dark: RGB(0x2A2440))
    public static let canvasGlowCool = ColorToken(light: RGB(0xDDEBDF), dark: RGB(0x14303A))
    public static let textPrimary = ColorToken(light: RGB(0x1F2A2E), dark: RGB(0xF3F1EC))
    public static let textSecondary = ColorToken(light: RGB(0x566368), dark: RGB(0xA9B3B8))
    public static let accent = ColorToken(light: RGB(0x3F6B4C), dark: RGB(0x8FC29C))
    public static let onAccent = ColorToken(light: RGB(0xFFFFFF), dark: RGB(0x0F1626))
    public static let peach = ColorToken(light: RGB(0xB8572B), dark: RGB(0xF2AE8B))
    public static let card = ColorToken(light: RGB(0xFFFFFF), dark: RGB(0x1A2438))
}

public extension Color {
    static let nouriCanvas = NouriPalette.canvas.color
    static let nouriText = NouriPalette.textPrimary.color
    static let nouriTextSecondary = NouriPalette.textSecondary.color
    static let nouriAccent = NouriPalette.accent.color
    static let nouriOnAccent = NouriPalette.onAccent.color
    static let nouriPeach = NouriPalette.peach.color
    static let nouriCard = NouriPalette.card.color
}

public enum NouriSpacing {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
}

public enum NouriRadius {
    public static let card: CGFloat = 24
    public static let badge: CGFloat = 14
}

/// Rounded type scale. Built on text styles, so Dynamic Type still works.
public extension Font {
    static let nouriDisplay = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let nouriTitle = Font.system(.title2, design: .rounded, weight: .semibold)
    static let nouriHeadline = Font.system(.headline, design: .rounded, weight: .semibold)
    static let nouriBody = Font.system(.body, design: .rounded)
    static let nouriCaption = Font.system(.subheadline, design: .rounded)
}
