import SwiftUI

/// Every NouriDesign component in one place, for previews and visual review.
public struct NouriGallery: View {
    @State private var step = 2

    public init() {}

    public var body: some View {
        ZStack {
            NouriBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: NouriSpacing.lg) {
                    VStack(alignment: .leading, spacing: NouriSpacing.sm) {
                        Text("Nouri design").font(.nouriDisplay).foregroundStyle(Color.nouriText)
                        Text("Soft wellness tokens and components.")
                            .font(.nouriBody).foregroundStyle(Color.nouriTextSecondary)
                    }

                    StepProgress(current: step, total: 4)

                    NouriCard {
                        HStack(spacing: NouriSpacing.md) {
                            IconBadge(systemImage: "moon.zzz.fill", tint: .nouriOliveInk)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sleep").font(.nouriHeadline).foregroundStyle(Color.nouriText)
                                Text("7h 12m last night").font(.nouriCaption).foregroundStyle(Color.nouriTextSecondary)
                            }
                        }
                    }

                    NouriCard {
                        HStack(spacing: NouriSpacing.md) {
                            IconBadge(systemImage: "heart.fill", tint: .nouriClayInk)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Resting heart rate").font(.nouriHeadline).foregroundStyle(Color.nouriText)
                                Text("54 bpm, 2 lower than last month").font(.nouriCaption).foregroundStyle(Color.nouriTextSecondary)
                            }
                        }
                    }

                    Button("Next step") { step = step % 4 + 1 }.buttonStyle(.nouriPrimary)
                    Button("Skip for now") {}.buttonStyle(.nouriSecondary)
                    Button("Disabled") {}.buttonStyle(.nouriPrimary).disabled(true)
                }
                .padding(NouriSpacing.lg)
            }
        }
    }
}

#Preview("Light") { NouriGallery() }
#Preview("Dark") { NouriGallery().preferredColorScheme(.dark) }
