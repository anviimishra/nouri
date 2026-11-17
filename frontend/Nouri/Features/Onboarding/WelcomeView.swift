import SwiftUI

struct WelcomeView: View {
    let onStart: () -> Void

    var body: some View {
        OnboardingPage(title: "Welcome to Nouri",
                       subtitle: "Your health data, sleep, workouts, and goals in one place. Just ask.",
                       buttonTitle: "Get started",
                       action: onStart) {
            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(text: "Ask questions in plain language", systemImage: "text.bubble")
                FeatureRow(text: "See trends across your apps", systemImage: "chart.line.uptrend.xyaxis")
                FeatureRow(text: "Your data stays private to you", systemImage: "lock")
            }
        }
    }
}

/// Icon column has a fixed width that scales with Dynamic Type, so the text lines up.
private struct FeatureRow: View {
    let text: String
    let systemImage: String
    @ScaledMetric(relativeTo: .body) private var iconWidth = 28.0

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: iconWidth)
                .foregroundStyle(.tint)
                .accessibilityHidden(true)
            Text(text)
        }
        .font(.body)
    }
}

#Preview { NavigationStack { WelcomeView(onStart: {}) } }
