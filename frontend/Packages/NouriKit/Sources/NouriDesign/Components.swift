import SwiftUI

/// Warm canvas with two soft, static glows. Calm by design: nothing moves.
public struct NouriBackground: View {
    public init() {}

    public var body: some View {
        ZStack {
            Color.nouriCanvas
            RadialGradient(colors: [NouriPalette.canvasGlowWarm.color, .clear],
                           center: .topTrailing, startRadius: 0, endRadius: 420)
            RadialGradient(colors: [NouriPalette.canvasGlowCool.color, .clear],
                           center: .bottomLeading, startRadius: 0, endRadius: 460)
        }
        .ignoresSafeArea()
    }
}

/// Rounded card with a soft border and a light shadow.
public struct NouriCard<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(NouriSpacing.md + 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.nouriCard.opacity(0.85), in: RoundedRectangle(cornerRadius: NouriRadius.card, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: NouriRadius.card, style: .continuous)
                .strokeBorder(Color.nouriText.opacity(0.06)))
            .shadow(color: .black.opacity(0.05), radius: 16, y: 6)
    }
}

/// Tinted rounded square holding an SF Symbol.
public struct IconBadge: View {
    private let systemImage: String
    private let tint: Color
    @ScaledMetric(relativeTo: .body) private var size = 44.0

    public init(systemImage: String, tint: Color = .nouriAccent) {
        self.systemImage = systemImage
        self.tint = tint
    }

    public var body: some View {
        Image(systemName: systemImage)
            .font(.system(.title3, design: .rounded, weight: .semibold))
            .foregroundStyle(tint)
            .frame(width: size, height: size)
            .background(tint.opacity(0.14), in: RoundedRectangle(cornerRadius: NouriRadius.badge, style: .continuous))
            .accessibilityHidden(true)
    }
}

/// "Step 2 of 4" as a row of capsules.
public struct StepProgress: View {
    private let current: Int
    private let total: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(current: Int, total: Int) {
        self.current = current
        self.total = total
    }

    public var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index < current ? Color.nouriAccent : Color.nouriText.opacity(0.12))
                    .frame(height: 6)
                    .frame(maxWidth: index == current - 1 ? 40 : 18)
            }
        }
        .animation(reduceMotion ? nil : .spring(duration: 0.45, bounce: 0.25), value: current)
        .accessibilityElement()
        .accessibilityLabel("Step \(current) of \(total)")
    }
}

/// Filled capsule button with a gentle press spring.
public struct NouriPrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        PressableLabel(configuration: configuration, filled: true)
    }
}

/// Quiet capsule button for secondary actions.
public struct NouriSecondaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        PressableLabel(configuration: configuration, filled: false)
    }
}

private struct PressableLabel: View {
    let configuration: ButtonStyleConfiguration
    let filled: Bool
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        configuration.label
            .font(.nouriHeadline)
            .foregroundStyle(filled ? Color.nouriOnAccent : Color.nouriAccent)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: filled ? .infinity : nil)
            .background(filled ? Color.nouriAccent : Color.nouriAccent.opacity(0.12), in: Capsule())
            .opacity(isEnabled ? 1 : 0.45)
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1)
            .animation(.spring(duration: 0.25, bounce: 0.3), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == NouriPrimaryButtonStyle {
    static var nouriPrimary: NouriPrimaryButtonStyle { .init() }
}

public extension ButtonStyle where Self == NouriSecondaryButtonStyle {
    static var nouriSecondary: NouriSecondaryButtonStyle { .init() }
}
