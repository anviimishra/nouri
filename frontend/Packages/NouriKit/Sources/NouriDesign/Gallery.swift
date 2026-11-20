import SwiftUI

/// A sample screen built only from NouriDesign pieces: hero, serif headline, one line of
/// copy, page dots, one primary action, one text link. New screens should feel like this.
public struct NouriGallery: View {
    @State private var step = 1

    public init() {}

    public var body: some View {
        ZStack {
            NouriBackground()
            VStack(spacing: NouriSpacing.lg) {
                MetricPinsHero()
                    .frame(maxHeight: .infinity)

                VStack(spacing: NouriSpacing.sm) {
                    Text("Ask")
                        .font(.nouriDisplay)
                        .foregroundStyle(Color.nouriText)
                    Text("Your sleep, workouts, and heart in one place. Ask about any of it in plain words.")
                        .font(.nouriBody)
                        .foregroundStyle(Color.nouriTextSecondary)
                        .multilineTextAlignment(.center)
                }

                PageDots(current: step, total: 3)

                VStack(spacing: NouriSpacing.xs) {
                    Button("Get started") { step = step % 3 + 1 }
                        .buttonStyle(.nouriPrimary)
                    Button("Skip for now") {}
                        .buttonStyle(.nouriLink)
                }
            }
            .padding(.horizontal, NouriSpacing.xl)
            .padding(.bottom, NouriSpacing.md)
        }
    }
}

#Preview("Light") { NouriGallery() }
#Preview("Dark") { NouriGallery().preferredColorScheme(.dark) }
