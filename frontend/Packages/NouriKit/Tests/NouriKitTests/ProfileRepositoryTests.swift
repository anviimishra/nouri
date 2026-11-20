import XCTest
@testable import NouriKit

final class ProfileRepositoryTests: XCTestCase {
    private var defaults: UserDefaults!
    private let suite = "ProfileRepositoryTests"

    override func setUp() {
        defaults = UserDefaults(suiteName: suite)
        defaults.removePersistentDomain(forName: suite)
    }

    func testNewUserIsNotOnboarded() async throws {
        let repo = LocalProfileRepository(defaults: defaults)
        let onboarded = try await repo.isOnboarded()
        XCTAssertFalse(onboarded)
    }

    func testOnboardedStatePersistsAcrossInstances() async throws {
        try await LocalProfileRepository(defaults: defaults).markOnboarded(at: .now)
        let onboarded = try await LocalProfileRepository(defaults: defaults).isOnboarded()
        XCTAssertTrue(onboarded)
    }

    func testProfileDecodesSnakeCase() throws {
        let json = #"{"id":"3F2504E0-4F89-11D3-9A0C-0305E82C3301","display_name":"Tanvi","onboarded_at":null}"#
        let profile = try JSONDecoder().decode(Profile.self, from: Data(json.utf8))
        XCTAssertEqual(profile.displayName, "Tanvi")
        XCTAssertNil(profile.onboardedAt)
    }
}
