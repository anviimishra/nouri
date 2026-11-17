import Foundation

/// Asks the user for Apple Health read access.
/// The real HealthKit implementation comes in #14; onboarding only depends on this protocol.
protocol HealthAuthorizing: Sendable {
    func requestAuthorization() async throws
}

/// Placeholder until #14 lands: succeeds immediately without touching HealthKit.
struct PlaceholderHealthAuthorizer: HealthAuthorizing {
    func requestAuthorization() async throws {}
}
