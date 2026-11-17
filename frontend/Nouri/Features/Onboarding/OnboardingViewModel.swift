import Foundation
import Observation
import NouriKit

/// Screens pushed after Welcome. Welcome is the stack's root, so Back works on every step.
enum OnboardingStep: Hashable {
    case connectSources
    case goals
    case syncProgress
}

@MainActor
@Observable
final class OnboardingViewModel {
    var path: [OnboardingStep] = []
    private(set) var healthConnected = false
    private(set) var isConnectingHealth = false
    private(set) var isFinishing = false
    var errorMessage: String?

    private let health: HealthAuthorizing
    private let profiles: ProfileRepository
    private let onFinished: () -> Void

    init(health: HealthAuthorizing, profiles: ProfileRepository, onFinished: @escaping () -> Void) {
        self.health = health
        self.profiles = profiles
        self.onFinished = onFinished
    }

    func start() {
        path = [.connectSources]
    }

    func connectHealth() async {
        isConnectingHealth = true
        defer { isConnectingHealth = false }
        do {
            try await health.requestAuthorization()
            healthConnected = true
        } catch {
            errorMessage = "Couldn't connect to Apple Health. You can try again or connect later in Settings."
        }
    }

    func continueToGoals() {
        path.append(.goals)
    }

    /// Used by both "Continue" and "Skip for now" (goals are optional; #15 adds the goal form).
    func continueToSync() {
        path.append(.syncProgress)
    }

    func finish() async {
        isFinishing = true
        defer { isFinishing = false }
        do {
            try await profiles.markOnboarded(at: .now)
            onFinished()
        } catch {
            errorMessage = "Couldn't save your progress. Please try again."
        }
    }
}
