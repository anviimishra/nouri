import SwiftUI
import NouriKit

/// Welcome → Connect Sources → Goals → Sync Progress, with standard back navigation.
struct OnboardingFlow: View {
    @Bindable var model: OnboardingViewModel

    var body: some View {
        NavigationStack(path: $model.path) {
            WelcomeView(onStart: model.start)
                .navigationDestination(for: OnboardingStep.self) { step in
                    switch step {
                    case .connectSources: ConnectSourcesView(model: model)
                    case .goals: GoalSetupView(model: model)
                    case .syncProgress: SyncProgressView(model: model)
                    }
                }
        }
        .alert("Something went wrong", isPresented: .constant(model.errorMessage != nil)) {
            Button("OK") { model.errorMessage = nil }
        } message: {
            Text(model.errorMessage ?? "")
        }
    }
}

/// Shared layout for onboarding screens: scrollable content with a pinned primary button.
struct OnboardingPage<Content: View>: View {
    let title: String
    let subtitle: String
    let buttonTitle: String
    var buttonDisabled = false
    let action: () -> Void
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title).font(.largeTitle.bold())
                    Text(subtitle).font(.body).foregroundStyle(.secondary)
                }
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: action) {
                Text(buttonTitle).frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(buttonDisabled)
            .padding(24)
            .background(.background)
        }
    }
}

#Preview {
    OnboardingFlow(model: .preview)
}

extension OnboardingViewModel {
    static var preview: OnboardingViewModel {
        OnboardingViewModel(health: PlaceholderHealthAuthorizer(),
                            profiles: LocalProfileRepository(defaults: UserDefaults(suiteName: "preview")!),
                            onFinished: {})
    }
}
