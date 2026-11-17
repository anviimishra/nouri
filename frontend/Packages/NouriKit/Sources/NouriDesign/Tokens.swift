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

/// Brand colors chosen by the team. Fills and glows use these exactly.
public enum NouriBrand {
    public static let cream = RGB(0xF6F0E7)
    public static let sand = RGB(0xE6D6C2)
    public static let clay = RGB(0xC77D5B)
    public static let olive = RGB(0x89916B)
    public static let forest = RGB(0x343D30)
}

/// Semantic tokens built from the brand colors. Clay and olive are mid-tones, so text and
/// icons use deeper "ink" shades of them to stay readable (WCAG AA, see ContrastTests).
public enum NouriPalette {
    public static let canvas = ColorToken(light: NouriBrand.cream, dark: RGB(0x1E241C))
    /// Hero pins and quiet fills.
    public static let sand = ColorToken(light: NouriBrand.sand, dark: RGB(0x3A3A2E))
    public static let textPrimary = ColorToken(light: NouriBrand.forest, dark: NouriBrand.cream)
    public static let textSecondary = ColorToken(light: RGB(0x525A4B), dark: RGB(0xC9BFAF))
    /// Buttons and progress: forest by day, sand by night.
    public static let accent = ColorToken(light: NouriBrand.forest, dark: NouriBrand.sand)
    public static let onAccent = ColorToken(light: NouriBrand.cream, dark: RGB(0x1E241C))
    public static let clay = ColorToken(light: NouriBrand.clay, dark: NouriBrand.clay)
    public static let clayInk = ColorToken(light: RGB(0x9E5536), dark: RGB(0xE09A78))
    public static let olive = ColorToken(light: NouriBrand.olive, dark: NouriBrand.olive)
    public static let oliveInk = ColorToken(light: RGB(0x5C6444), dark: RGB(0xA9B188))
    public static let card = ColorToken(light: RGB(0xFBF8F3), dark: RGB(0x283024))
}

public extension Color {
    static let nouriCanvas = NouriPalette.canvas.color
    static let nouriText = NouriPalette.textPrimary.color
    static let nouriTextSecondary = NouriPalette.textSecondary.color
    static let nouriAccent = NouriPalette.accent.color
    static let nouriOnAccent = NouriPalette.onAccent.color
    static let nouriSand = NouriPalette.sand.color
    static let nouriClay = NouriPalette.clay.color
    static let nouriClayInk = NouriPalette.clayInk.color
    static let nouriOlive = NouriPalette.olive.color
    static let nouriOliveInk = NouriPalette.oliveInk.color
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

/// SF Pro Rounded throughout, kept neutral: bold headlines, semibold labels,
/// regular body. Built on text styles, so Dynamic Type still works.
public extension Font {
    static let nouriDisplay = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let nouriTitle = Font.system(.title, design: .rounded, weight: .bold)
    static let nouriHeadline = Font.system(.headline, design: .rounded, weight: .semibold)
    static let nouriBody = Font.system(.body, design: .rounded)
    static let nouriCaption = Font.system(.subheadline, design: .rounded)
}
