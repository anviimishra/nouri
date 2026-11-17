import SwiftUI

/// Flat brand canvas. Screens stay quiet: one idea, one action, lots of space.
public struct NouriBackground: View {
    public init() {}

    public var body: some View {
        Color.nouriCanvas.ignoresSafeArea()
    }
}

/// Rounded glass card: Liquid Glass on iOS/watchOS 26+, frosted material before that.
/// Use sparingly, only where content needs grouping.
public struct NouriCard<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(NouriSpacing.md + 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .nouriGlass(in: RoundedRectangle(cornerRadius: NouriRadius.card, style: .continuous))
    }
}

public extension View {
    /// Glass surface that keeps the iOS 17 minimum: native Liquid Glass where available.
    func nouriGlass(in shape: some Shape) -> some View {
        modifier(GlassSurface(shape: shape))
    }
}

private struct GlassSurface<S: Shape>: ViewModifier {
    let shape: S

    func body(content: Content) -> some View {
        if #available(iOS 26, watchOS 26, macOS 26, *) {
            content.glassEffect(.regular.tint(Color.nouriCard.opacity(0.45)), in: shape)
        } else {
            content
                .background(Color.nouriCard.opacity(0.6), in: shape)
                .background(.ultraThinMaterial, in: shape)
                .overlay(shape.stroke(Color.nouriText.opacity(0.06), lineWidth: 1))
        }
    }
}

/// Tinted rounded square holding an SF Symbol.
public struct IconBadge: View {
    private let systemImage: String
    private let tint: Color
    @ScaledMetric(relativeTo: .body) private var size = 40.0

    public init(systemImage: String, tint: Color = .nouriOliveInk) {
        self.systemImage = systemImage
        self.tint = tint
    }

    public var body: some View {
        Image(systemName: systemImage)
            .font(.system(.body, weight: .semibold))
            .foregroundStyle(tint)
            .frame(width: size, height: size)
            .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: NouriRadius.badge, style: .continuous))
            .accessibilityHidden(true)
    }
}

/// Small page dots for multi-step flows.
public struct PageDots: View {
    private let current: Int
    private let total: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// `current` is 1-based.
    public init(current: Int, total: Int) {
        self.current = current
        self.total = total
    }

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(1...max(total, 1), id: \.self) { index in
                Circle()
                    .fill(index == current ? Color.nouriAccent : Color.nouriText.opacity(0.15))
                    .frame(width: 7, height: 7)
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.3), value: current)
        .accessibilityElement()
        .accessibilityLabel("Step \(current) of \(total)")
    }
}

/// Hero art: the user's kind of numbers as soft map-style pins, fading into the canvas.
public struct MetricPinsHero: View {
    public enum Tone { case accent, olive, clay }

    struct Pin: Identifiable {
        let id: Int, label: String, x: CGFloat, y: CGFloat, tone: Tone, strength: Double
    }

    static let pins: [Pin] = [
        ("7h 12m", 0.22, 0.18, Tone.accent, 1.0), ("54 bpm", 0.62, 0.10, .olive, 0.9),
        ("8:05 /mi", 0.78, 0.34, .accent, 0.85), ("9,842", 0.40, 0.38, .clay, 0.8),
        ("62 ms", 0.14, 0.52, .olive, 0.7), ("6h 48m", 0.58, 0.56, .accent, 0.6),
        ("48.2", 0.84, 0.64, .olive, 0.45), ("31:20", 0.30, 0.74, .clay, 0.4),
        ("56 bpm", 0.66, 0.84, .accent, 0.3),
    ].enumerated().map { Pin(id: $0, label: $1.0, x: $1.1, y: $1.2, tone: $1.3, strength: $1.4) }

    public init() {}

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(Self.pins) { pin in
                    PinView(label: pin.label, fill: fill(pin.tone))
                        .compositingGroup()
                        .opacity(pin.strength)
                        .position(x: proxy.size.width * pin.x, y: proxy.size.height * pin.y)
                }
            }
        }
        .mask(LinearGradient(colors: [.black, .black, .clear], startPoint: .top, endPoint: .bottom))
        .accessibilityHidden(true)
    }

    private func fill(_ tone: Tone) -> Color {
        switch tone {
        case .accent: .nouriAccent
        case .olive: .nouriOlive
        case .clay: .nouriClay
        }
    }
}

private struct PinView: View {
    let label: String
    let fill: Color

    var body: some View {
        VStack(spacing: -4) {
            Text(label)
                .font(.system(.subheadline, weight: .semibold).monospacedDigit())
                .foregroundStyle(Color.nouriOnAccent)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(fill, in: Capsule())
            Rectangle()
                .fill(fill)
                .frame(width: 10, height: 10)
                .rotationEffect(.degrees(45))
        }
        .fixedSize()
    }
}

/// The one main action on a screen: a calm, filled pill.
public struct NouriPrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        PrimaryLabel(configuration: configuration)
    }
}

private struct PrimaryLabel: View {
    let configuration: ButtonStyleConfiguration
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        configuration.label
            .font(.nouriHeadline)
            .foregroundStyle(Color.nouriOnAccent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(Color.nouriAccent.opacity(isEnabled ? 1 : 0.35), in: Capsule())
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.98 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

/// Secondary actions read as quiet text links ("Skip for now").
public struct NouriLinkButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, weight: .semibold))
            .foregroundStyle(Color.nouriTextSecondary)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

public extension ButtonStyle where Self == NouriPrimaryButtonStyle {
    static var nouriPrimary: NouriPrimaryButtonStyle { .init() }
}

public extension ButtonStyle where Self == NouriLinkButtonStyle {
    static var nouriLink: NouriLinkButtonStyle { .init() }
}
