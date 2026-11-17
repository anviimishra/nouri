import SwiftUI

/// Goals step. Optional: the form itself comes in #15; for now users continue or skip.
struct GoalSetupView: View {
    let model: OnboardingViewModel

    var body: some View {
        OnboardingPage(title: "Set a goal",
                       subtitle: "Optional. Nouri can tailor answers and plans to what you're working toward.",
                       buttonTitle: "Continue",
                       action: model.continueToSync) {
            Text("You can add or change goals any time in Settings.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Skip for now", action: model.continueToSync)
        }
    }
}

#Preview { NavigationStack { GoalSetupView(model: .preview) } }
