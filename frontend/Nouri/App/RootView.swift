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
        if (try? await profiles.isOnboarded()) == true {
            phase = .home
        } else {
            onboarding = OnboardingViewModel(health: health, profiles: profiles) {
                phase = .home
            }
            phase = .onboarding
        }
    }
}

/// Stand-in until the Ask screen (#18).
private struct HomePlaceholderView: View {
    var body: some View {
        Text("Nouri").font(.largeTitle.bold())
    }
}

#Preview { RootView() }
