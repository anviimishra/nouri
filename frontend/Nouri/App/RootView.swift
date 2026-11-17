import SwiftUI
import NouriKit

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
                HomePlaceholderView()
            }
        }
        .task { await load() }
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
    var body: some View {
        Text("Nouri").font(.largeTitle.bold())
    }
}

#Preview { RootView() }
