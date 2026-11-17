import SwiftUI
import NouriDesign

/// Landing carousel: the three things Nouri does (Ask, Connect, Plan), Beli-style.
struct WelcomeView: View {
    let onStart: () -> Void
    @State private var slide = 0

    struct Slide: Hashable {
        let title: String
        let line: String
    }

    static let slides = [
        Slide(title: "Ask", line: "“How did my sleep change during finals?” Ask about your health in plain words."),
        Slide(title: "Connect", line: "Apple Health, Strava, Oura, and more in one place. No more juggling apps."),
        Slide(title: "Plan", line: "Workouts that fit your schedule and adapt as you go."),
    ]

    var body: some View {
        ZStack {
            NouriBackground()
            VStack(spacing: NouriSpacing.lg) {
                Text("nouri")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.nouriText)
                    .accessibilityAddTraits(.isHeader)

                MetricPinsHero()
                    .frame(maxHeight: .infinity)

                TabView(selection: $slide) {
                    ForEach(Array(Self.slides.enumerated()), id: \.offset) { index, item in
                        VStack(spacing: NouriSpacing.sm) {
                            Text(item.title)
                                .font(.nouriDisplay)
                                .foregroundStyle(Color.nouriText)
                            Text(item.line)
                                .font(.nouriBody)
                                .foregroundStyle(Color.nouriTextSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, NouriSpacing.sm)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 150)

                PageDots(current: slide + 1, total: Self.slides.count)

                Button("Get started", action: onStart)
                    .buttonStyle(.nouriPrimary)
            }
            .padding(.horizontal, NouriSpacing.lg)
            .padding(.bottom, NouriSpacing.sm)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview { NavigationStack { WelcomeView(onStart: {}) } }
