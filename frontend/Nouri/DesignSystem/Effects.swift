import SwiftUI
import Pow
import NouriDesign

/// Pow effects, kept slow and subtle, and skipped entirely with Reduce Motion.
/// Use only for small moments of success, such as a data source connecting.
extension View {
    /// One slow, soft light sweep across the view when `value` changes.
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
            content.changeEffect(.shine(duration: 1.6), value: value)
        }
    }
}

#if DEBUG
/// Launch with `-gallery` to review the design system in the app.
struct DesignGalleryScreen: View {
    var body: some View {
        NouriGallery()
    }
}
#endif
