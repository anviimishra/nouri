import SwiftUI
import NouriKit
import NouriDesign

/// Routes to onboarding or Home based on the user's onboarding state.
/// Sign-in routing is added in #11 / #12.
struct RootView: View {
    private enum Phase { case loading, onboarding, home }

    @State private var phase: Phase = .loading
    @State private var onboarding: OnboardingViewModel?
    private let profiles: ProfileRepository
    private let health: HealthAuthorizing

    init(profiles: ProfileRepository = LocalProfileRepository(),
         health: HealthAuthorizing = PlaceholderHealthAuthorizer()) {
        self.profiles = profiles
        self.health = health
    }

    var body: some View {
        Group {
            switch phase {
            case .loading:
                ProgressView()
            case .onboarding:
                if let onboarding { OnboardingFlow(model: onboarding) }
            case .home:
                HomePlaceholderView(onRestartOnboarding: restartOnboarding)
            }
        }
        .task { await load() }
    }

    /// Debug helper: forget the onboarded flag and show onboarding again.
    private func restartOnboarding() {
        (profiles as? LocalProfileRepository)?.resetOnboarding()
        phase = .loading
        Task { await load() }
    }

    private func load() async {
        guard phase == .loading else { return }
        let forceOnboarding = DebugLaunch.onboardingSteps != nil
        if !forceOnboarding, (try? await profiles.isOnboarded()) == true {
            phase = .home
        } else {
            let model = OnboardingViewModel(health: health, profiles: profiles) {
                phase = .home
            }
            if let steps = DebugLaunch.onboardingSteps { model.path = steps }
            onboarding = model
            phase = .onboarding
        }
    }
}

/// Debug-only launch arguments for reviewing screens without tapping through.
/// `-onboardingStep connect|goals|sync` opens onboarding at that step.
private enum DebugLaunch {
    static var onboardingSteps: [OnboardingStep]? {
        #if DEBUG
        let args = ProcessInfo.processInfo.arguments
        guard let i = args.firstIndex(of: "-onboardingStep"), i + 1 < args.count else { return nil }
        let all: [OnboardingStep] = [.connectSources, .goals, .syncProgress]
        switch args[i + 1] {
        case "welcome": return []
        case "connect": return Array(all.prefix(1))
        case "goals": return Array(all.prefix(2))
        case "sync": return all
        default: return nil
        }
        #else
        return nil
        #endif
    }
}

/// Stand-in until the Ask screen (#18).
private struct HomePlaceholderView: View {
    let onRestartOnboarding: () -> Void

    var body: some View {
        ZStack {
            NouriBackground()
            VStack(spacing: NouriSpacing.sm) {
                Text("nouri")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Color.nouriText)
                    .padding(.bottom, NouriSpacing.lg)
                Text("You're in")
                    .font(.nouriDisplay)
                    .foregroundStyle(Color.nouriText)
                Text("This is Home for now. The Ask screen, where you'll chat about your health data, is coming next.")
                    .font(.nouriBody)
                    .foregroundStyle(Color.nouriTextSecondary)
                    .multilineTextAlignment(.center)
                #if DEBUG
                Button("Restart onboarding", action: onRestartOnboarding)
                    .buttonStyle(.nouriLink)
                    .padding(.top, NouriSpacing.lg)
                #endif
            }
            .padding(.horizontal, NouriSpacing.xl)
        }
    }
}

#Preview { RootView() }
