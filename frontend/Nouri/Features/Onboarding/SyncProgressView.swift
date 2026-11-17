import SwiftUI
import NouriDesign

/// Final step. Real backfill progress is wired up in #14; this screen finishes onboarding.
struct SyncProgressView: View {
    let model: OnboardingViewModel

    var body: some View {
        OnboardingPage(step: 3,
                       title: "You're all set",
                       subtitle: model.healthConnected
                           ? "Nouri will keep your Apple Health data up to date in the background."
                           : "You can connect Apple Health any time in Settings.",
                       primaryTitle: "Start using Nouri",
                       primaryDisabled: model.isFinishing,
                       primaryAction: { Task { await model.finish() } }) {
            if model.isFinishing {
                ProgressView().tint(Color.nouriText)
            }
        }
    }
}

#Preview { NavigationStack { SyncProgressView(model: .preview) } }
