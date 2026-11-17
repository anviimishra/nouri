import SwiftUI
import Pow
import NouriDesign

/// Pow effects, toned down for a calm app and skipped entirely with Reduce Motion.
extension View {
    /// A soft shine across the view when `value` changes (e.g. a source connects).
    func nouriShine(value: some Equatable) -> some View {
        modifier(ShineOnChange(value: value))
    }
}

private struct ShineOnChange<Value: Equatable>: ViewModifier {
    let value: Value
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content.changeEffect(.shine(duration: 0.9), value: value)
        }
    }
}

#if DEBUG
/// Launch with `-gallery` to review the design system in the app.
struct DesignGalleryScreen: View {
    @State private var connected = false

    var body: some View {
        ZStack(alignment: .bottom) {
            NouriGallery()
            Button(connected ? "Connected" : "Try the shine effect") { connected.toggle() }
                .buttonStyle(.nouriPrimary)
                .nouriShine(value: connected)
                .padding(NouriSpacing.lg)
        }
    }
}
#endif
