import SwiftUI
import NouriDesign

struct ConnectSourcesView: View {
    let model: OnboardingViewModel

    var body: some View {
        OnboardingPage(step: 1,
                       title: "Connect your apps",
                       subtitle: "Nouri reads from Apple Health, which already collects data from your other fitness apps.",
                       primaryTitle: "Continue",
                       primaryAction: model.continueToGoals) {
            VStack(alignment: .leading, spacing: NouriSpacing.md) {
                NouriCard {
                    HStack(spacing: NouriSpacing.md) {
                        IconBadge(systemImage: "heart.fill", tint: .nouriClayInk)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Apple Health").font(.nouriHeadline).foregroundStyle(Color.nouriText)
                            Text("Sleep, heart, workouts, steps").font(.nouriCaption).foregroundStyle(Color.nouriTextSecondary)
                        }
                        Spacer(minLength: NouriSpacing.sm)
                        connectControl
                    }
                }
                .nouriShine(value: model.healthConnected)

                Text("Strava, Oura, Garmin, and WHOOP come in through Apple Health. Turn on Apple Health sync in each app's settings.")
                    .font(.nouriCaption)
                    .foregroundStyle(Color.nouriTextSecondary)
            }
        }
    }

    @ViewBuilder private var connectControl: some View {
        if model.healthConnected {
            Label("Connected", systemImage: "checkmark")
                .font(.nouriCaption.weight(.semibold))
                .foregroundStyle(Color.nouriOliveInk)
        } else {
            Button("Connect") { Task { await model.connectHealth() } }
                .font(.nouriHeadline)
                .foregroundStyle(Color.nouriOnAccent)
                .padding(.horizontal, NouriSpacing.md)
                .padding(.vertical, NouriSpacing.sm)
                .background(Color.nouriAccent, in: Capsule())
                .disabled(model.isConnectingHealth)
        }
    }
}

#Preview { NavigationStack { ConnectSourcesView(model: .preview) } }
