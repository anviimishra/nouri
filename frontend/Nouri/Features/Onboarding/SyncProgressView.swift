import SwiftUI

/// Final step. Real backfill progress is wired up in #14; this screen finishes onboarding.
struct SyncProgressView: View {
    let model: OnboardingViewModel

    var body: some View {
        OnboardingPage(title: "You're all set",
                       subtitle: model.healthConnected
                           ? "Nouri will keep syncing your Apple Health data in the background."
                           : "You can connect Apple Health later in Settings.",
                       buttonTitle: "Start using Nouri",
                       buttonDisabled: model.isFinishing,
                       action: { Task { await model.finish() } }) {
            if model.isFinishing {
                ProgressView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview { NavigationStack { SyncProgressView(model: .preview) } }
