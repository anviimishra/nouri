import XCTest
import NouriKit
@testable import Nouri

@MainActor
final class OnboardingViewModelTests: XCTestCase {
    private struct FailingHealth: HealthAuthorizing {
        func requestAuthorization() async throws { throw URLError(.cancelled) }
    }

    private final class FakeProfiles: ProfileRepository, @unchecked Sendable {
        var onboardedAt: Date?
        func isOnboarded() async throws -> Bool { onboardedAt != nil }
        func markOnboarded(at date: Date) async throws { onboardedAt = date }
    }

    private func makeModel(health: HealthAuthorizing = PlaceholderHealthAuthorizer(),
                           profiles: FakeProfiles = FakeProfiles(),
                           onFinished: @escaping () -> Void = {}) -> OnboardingViewModel {
        OnboardingViewModel(health: health, profiles: profiles, onFinished: onFinished)
    }

    func testStepsAdvanceInOrder() {
        let model = makeModel()
        model.start()
        model.continueToGoals()
        model.continueToSync()
        XCTAssertEqual(model.path, [.connectSources, .goals, .syncProgress])
    }

    func testBackNavigationPopsOneStep() {
        let model = makeModel()
        model.start()
        model.continueToGoals()
        model.path.removeLast()
        XCTAssertEqual(model.path, [.connectSources])
    }

    func testConnectHealthMarksConnected() async {
        let model = makeModel()
        await model.connectHealth()
        XCTAssertTrue(model.healthConnected)
        XCTAssertNil(model.errorMessage)
    }

    func testConnectHealthFailureShowsError() async {
        let model = makeModel(health: FailingHealth())
        await model.connectHealth()
        XCTAssertFalse(model.healthConnected)
        XCTAssertNotNil(model.errorMessage)
    }

    func testFinishMarksOnboardedAndCallsBack() async throws {
        let profiles = FakeProfiles()
        var finished = false
        let model = makeModel(profiles: profiles) { finished = true }
        await model.finish()
        XCTAssertTrue(finished)
        let onboarded = try await profiles.isOnboarded()
        XCTAssertTrue(onboarded)
    }
}
