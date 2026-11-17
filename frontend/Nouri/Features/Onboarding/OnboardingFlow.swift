import SwiftUI
import NouriKit
import NouriDesign

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
        .tint(Color.nouriText)
        .alert("Something went wrong", isPresented: .constant(model.errorMessage != nil)) {
            Button("OK") { model.errorMessage = nil }
        } message: {
            Text(model.errorMessage ?? "")
        }
    }
}

/// Shared onboarding layout: headline and one line on top, optional content,
/// then step dots, one primary action, and an optional text link at the bottom.
struct OnboardingPage<Content: View>: View {
    let step: Int
    let title: String
    let subtitle: String
    let primaryTitle: String
    var primaryDisabled = false
    let primaryAction: () -> Void
    var linkTitle: String?
    var linkAction: (() -> Void)?
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            NouriBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: NouriSpacing.xl) {
                    VStack(alignment: .leading, spacing: NouriSpacing.sm) {
                        Text(title).font(.nouriTitle).foregroundStyle(Color.nouriText)
                        Text(subtitle).font(.nouriBody).foregroundStyle(Color.nouriTextSecondary)
                    }
                    content
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, NouriSpacing.lg)
                .padding(.top, NouriSpacing.md)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: NouriSpacing.md) {
                PageDots(current: step, total: 3)
                VStack(spacing: NouriSpacing.xs) {
                    Button(primaryTitle, action: primaryAction)
                        .buttonStyle(.nouriPrimary)
                        .disabled(primaryDisabled)
                    if let linkTitle, let linkAction {
                        Button(linkTitle, action: linkAction).buttonStyle(.nouriLink)
                    }
                }
            }
            .padding(.horizontal, NouriSpacing.lg)
            .padding(.bottom, NouriSpacing.sm)
            .background(Color.nouriCanvas)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
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
