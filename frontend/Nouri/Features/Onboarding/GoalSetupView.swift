import SwiftUI
import NouriDesign

/// Goals step. Optional: the goal form itself comes in #15.
struct GoalSetupView: View {
    let model: OnboardingViewModel

    var body: some View {
        OnboardingPage(step: 2,
                       title: "Any goals in mind?",
                       subtitle: "Optional. Nouri can shape answers and plans around what you're working toward. You can add one later.",
                       primaryTitle: "Continue",
                       primaryAction: model.continueToSync,
                       linkTitle: "Skip for now",
                       linkAction: model.continueToSync) {
            EmptyView()
        }
    }
}

#Preview { NavigationStack { GoalSetupView(model: .preview) } }
